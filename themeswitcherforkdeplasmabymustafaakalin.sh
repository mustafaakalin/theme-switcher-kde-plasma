#!/bin/bash

CONFIG_FILE="$HOME/.theme_switcher_config"
BACKUP_DIR="$HOME/.theme_backups"
SYSTEMD_SERVICE="theme-switcher.service"
SYSTEMD_SERVICE_PATH="$HOME/.config/systemd/user/$SYSTEMD_SERVICE"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Temalar ve Seçenekleri Listeleme
list_options() {
    echo "Tüm temalar ve ayarlar taranıyor..."

    # Global Temalar
    themes=$(find /usr/share/plasma/look-and-feel ~/.local/share/plasma/look-and-feel -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    # Plasma Stilleri
    plasma_styles=$(find /usr/share/plasma/desktoptheme ~/.local/share/plasma/desktoptheme -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    # İkon Takımları
    icons=$(find /usr/share/icons ~/.local/share/icons -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    # Mouse Temaları
    cursors=$(find /usr/share/icons ~/.local/share/icons -mindepth 1 -maxdepth 2 -type d -name cursors -exec dirname {} \; 2>/dev/null | xargs -n 1 basename)

    # Kvantum Temaları
    kvantum_themes=$(find /usr/share/Kvantum ~/.config/Kvantum -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    # Renk Şemaları
    color_schemes=$(find /usr/share/color-schemes ~/.local/share/color-schemes -type f -name '*.colors' -exec basename {} .colors \; 2>/dev/null)

    echo "Tüm seçenekler listelendi!"
}

# Kullanıcı Seçimleri
get_user_choices() {
    echo "Gündüz teması ayarlarınızı seçin:"
    echo "1. Global Tema:"
    select day_theme in $themes; do break; done

    echo "2. Plasma Stili:"
    select day_plasma_style in $plasma_styles; do break; done

    echo "3. İkon Takımı:"
    select day_icons in $icons; do break; done

    echo "4. Mouse Teması:"
    select day_cursor in $cursors; do break; done

    echo "5. Kvantum Teması:"
    select day_kvantum in $kvantum_themes; do break; done

    echo "6. Renk Şeması:"
    select day_color_scheme in $color_schemes; do break; done

    echo "Gece teması ayarlarınızı seçin:"
    echo "1. Global Tema:"
    select night_theme in $themes; do break; done

    echo "2. Plasma Stili:"
    select night_plasma_style in $plasma_styles; do break; done

    echo "3. İkon Takımı:"
    select night_icons in $icons; do break; done

    echo "4. Mouse Teması:"
    select night_cursor in $cursors; do break; done

    echo "5. Kvantum Teması:"
    select night_kvantum in $kvantum_themes; do break; done

    echo "6. Renk Şeması:"
    select night_color_scheme in $color_schemes; do break; done

    # Seçimleri Kaydet
    echo "Seçimler kaydediliyor..."
    cat <<EOL > $CONFIG_FILE
day_theme=$day_theme
day_plasma_style=$day_plasma_style
day_icons=$day_icons
day_cursor=$day_cursor
day_kvantum=$day_kvantum
day_color_scheme=$day_color_scheme

night_theme=$night_theme
night_plasma_style=$night_plasma_style
night_icons=$night_icons
night_cursor=$night_cursor
night_kvantum=$night_kvantum
night_color_scheme=$night_color_scheme
EOL
    echo "Konfigürasyon dosyasına kaydedildi: $CONFIG_FILE"
}

# Yedekleme İşlemi
backup_settings() {
    echo "Yedekleme işlemi başlatılıyor..."
    mkdir -p "$BACKUP_DIR"

    files_to_backup=(
        ~/.config/kdeglobals
        ~/.config/kwinrc
        ~/.config/plasmarc
        ~/.config/ksplashrc
        ~/.config/kcminputrc
    )

    for file in "${files_to_backup[@]}"; do
        if [[ -f $file ]]; then
            cp "$file" "$BACKUP_DIR/$(basename "$file")_$TIMESTAMP"
        else
            echo "Uyarı: $file bulunamadı, atlanıyor."
        fi
    done

    if [[ -f /etc/sddm.conf ]]; then
        sudo cp /etc/sddm.conf "$BACKUP_DIR/sddm.conf_$TIMESTAMP"
    fi

    echo "Yedekleme tamamlandı."
}

# Ayarları Uygulama
apply_settings() {
    local theme_type=$1

    source "$CONFIG_FILE"

    if [[ $theme_type == "day" ]]; then
        lookandfeeltool -a "$day_theme"
        plasma-apply-desktoptheme "$day_plasma_style"
        kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "$day_icons"
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "$day_cursor"
        kvantummanager --set "$day_kvantum"
        kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "$day_color_scheme"
    else
        lookandfeeltool -a "$night_theme"
        plasma-apply-desktoptheme "$night_plasma_style"
        kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "$night_icons"
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "$night_cursor"
        kvantummanager --set "$night_kvantum"
        kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "$night_color_scheme"
    fi

    echo "Ayarlar uygulandı, Plasma yeniden başlatılıyor..."
    qdbus-qt5 org.kde.KWin /KWin reconfigure
    plasmashell --replace &>/dev/null &
}

# Systemd Servisi Kurulumu
setup_systemd_service() {
    if [[ -f $SYSTEMD_SERVICE_PATH ]]; then
        echo "Systemd servisi zaten mevcut, tekrar oluşturulmayacak."
    else
        echo "Systemd servisi oluşturuluyor..."
        mkdir -p "$(dirname "$SYSTEMD_SERVICE_PATH")"
        cat <<EOL > $SYSTEMD_SERVICE_PATH
[Unit]
Description=Theme Switcher for KDE Plasma
After=graphical.target

[Service]
ExecStart=$0
Restart=always
User=$USER

[Install]
WantedBy=default.target
EOL
        systemctl --user enable "$SYSTEMD_SERVICE"
        systemctl --user start "$SYSTEMD_SERVICE"
        echo "Systemd servisi oluşturuldu ve etkinleştirildi."
    fi
}

# Temayı Güncelle
switch_theme() {
    current_hour=$(date +%H)

    if (( 6 <= current_hour && current_hour < 18 )); then
        echo "Gündüz teması uygulanıyor..."
        apply_settings "day"
    else
        echo "Gece teması uygulanıyor..."
        apply_settings "night"
    fi
}

# Ana Program
if [[ ! -f $CONFIG_FILE ]]; then
    echo "Konfigürasyon dosyası bulunamadı. İlk kurulum başlatılıyor..."
    list_options
    get_user_choices
    backup_settings
    setup_systemd_service
fi

switch_theme
