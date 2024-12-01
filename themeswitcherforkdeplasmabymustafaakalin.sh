#!/bin/bash

# Renkler ve Stiller
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # Renk sıfırlama

# Yapılandırma Dosyaları
CONFIG_FILE="$HOME/.theme_switcher_config"
BACKUP_DIR="$HOME/.theme_backups"
SYSTEMD_SERVICE="theme-switcher.service"
SYSTEMD_SERVICE_PATH="$HOME/.config/systemd/user/$SYSTEMD_SERVICE"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Banner Fonksiyonu
print_banner() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${BOLD}       KDE TEMA DEĞİŞTİRİCİ v1.0        ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo
}

# Güncelleme Menüsü
update_menu() {
    echo -e "${CYAN}┌─ Tema Güncelleme ─┐${NC}"
    echo -e "${YELLOW}Mevcut ayarlarınızı güncellemek ister misiniz?${NC}\n"
    echo -e "1) ${MAGENTA}Gündüz Temasını Güncelle 🌞${NC}"
    echo -e "2) ${MAGENTA}Gece Temasını Güncelle 🌙${NC}"
    echo -e "3) ${MAGENTA}Mevcut Temayı Uygula${NC}"
    echo -e "4) ${RED}Çıkış${NC}"
    
    read -p $'\nSeçiminiz (1-4): ' choice

    case $choice in
        1)
            echo -e "\n${YELLOW}🌞 Gündüz teması ayarlarını güncelleme${NC}"
            update_theme_settings "day"
            ;;
        2)
            echo -e "\n${YELLOW}🌙 Gece teması ayarlarını güncelleme${NC}"
            update_theme_settings "night"
            ;;
        3)
            switch_theme
            ;;
        4)
            echo -e "\n${GREEN}Program kapatılıyor...${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}⚠ Geçersiz seçim!${NC}"
            update_menu
            ;;
    esac
}

# Tema Ayarlarını Güncelleme
update_theme_settings() {
    local theme_type=$1
    list_options

    # Mevcut ayarları yedekle
    source "$CONFIG_FILE"

    if [[ $theme_type == "day" ]]; then
        echo -e "\n${YELLOW}🌞 Yeni gündüz teması ayarlarınızı seçin:${NC}"
        echo -e "${MAGENTA}1. Global Tema:${NC}"
        select day_theme in $themes; do break; done

        echo -e "${MAGENTA}2. Plasma Stili:${NC}"
        select day_plasma_style in $plasma_styles; do break; done

        echo -e "${MAGENTA}3. İkon Takımı:${NC}"
        select day_icons in $icons; do break; done

        echo -e "${MAGENTA}4. Mouse Teması:${NC}"
        select day_cursor in $cursors; do break; done

        echo -e "${MAGENTA}5. Kvantum Teması:${NC}"
        select day_kvantum in $kvantum_themes; do break; done

        echo -e "${MAGENTA}6. Renk Şeması:${NC}"
        select day_color_scheme in $color_schemes; do break; done

        echo -e "${MAGENTA}7. Konsole Renk Şeması:${NC}"
        select day_konsole_color_scheme in $konsole_color_schemes; do break; done

        echo -e "${MAGENTA}8. SDDM Teması:${NC}"
        select day_sddm_theme in $sddm_themes; do break; done
    else
        echo -e "\n${YELLOW}🌙 Yeni gece teması ayarlarınızı seçin:${NC}"
        echo -e "${MAGENTA}1. Global Tema:${NC}"
        select night_theme in $themes; do break; done

        echo -e "${MAGENTA}2. Plasma Stili:${NC}"
        select night_plasma_style in $plasma_styles; do break; done

        echo -e "${MAGENTA}3. İkon Takımı:${NC}"
        select night_icons in $icons; do break; done

        echo -e "${MAGENTA}4. Mouse Teması:${NC}"
        select night_cursor in $cursors; do break; done

        echo -e "${MAGENTA}5. Kvantum Teması:${NC}"
        select night_kvantum in $kvantum_themes; do break; done

        echo -e "${MAGENTA}6. Renk Şeması:${NC}"
        select night_color_scheme in $color_schemes; do break; done

        echo -e "${MAGENTA}7. Konsole Renk Şeması:${NC}"
        select night_konsole_color_scheme in $konsole_color_schemes; do break; done

        echo -e "${MAGENTA}8. SDDM Teması:${NC}"
        select night_sddm_theme in $sddm_themes; do break; done
    fi

    # Yeni ayarları kaydet
    if [[ $theme_type == "day" ]]; then
        cat <<EOL > $CONFIG_FILE
day_theme=$day_theme
day_plasma_style=$day_plasma_style
day_icons=$day_icons
day_cursor=$day_cursor
day_kvantum=$day_kvantum
day_color_scheme=$day_color_scheme
day_konsole_color_scheme=$day_konsole_color_scheme
day_sddm_theme=$day_sddm_theme

night_theme=$night_theme
night_plasma_style=$night_plasma_style
night_icons=$night_icons
night_cursor=$night_cursor
night_kvantum=$night_kvantum
night_color_scheme=$night_color_scheme
night_konsole_color_scheme=$night_konsole_color_scheme
night_sddm_theme=$night_sddm_theme
EOL
    else
        cat <<EOL > $CONFIG_FILE
day_theme=$day_theme
day_plasma_style=$day_plasma_style
day_icons=$day_icons
day_cursor=$day_cursor
day_kvantum=$day_kvantum
day_color_scheme=$day_color_scheme
day_konsole_color_scheme=$day_konsole_color_scheme
day_sddm_theme=$day_sddm_theme

night_theme=$night_theme
night_plasma_style=$night_plasma_style
night_icons=$night_icons
night_cursor=$night_cursor
night_kvantum=$night_kvantum
night_color_scheme=$night_color_scheme
night_konsole_color_scheme=$night_konsole_color_scheme
night_sddm_theme=$night_sddm_theme
EOL
    fi

    echo -e "\n${GREEN}✓ Yeni ayarlar kaydedildi${NC}"
    
    # Kullanıcıya tema uygulama seçeneği sun
    echo -e "\n${YELLOW}Yeni ayarları şimdi uygulamak ister misiniz? (E/H)${NC}"
    read -p "Seçiminiz: " apply_now
    if [[ $apply_now =~ ^[Ee]$ ]]; then
        apply_settings $theme_type
    fi
}

# Temalar ve Seçenekleri Listeleme
list_options() {
    echo -e "${CYAN}┌─ Tema Tarayıcı ─┐${NC}"
    echo -e "${YELLOW}Tüm temalar ve ayarlar taranıyor...${NC}\n"

    echo -e "${MAGENTA}► Global Temalar${NC}"
    themes=$(find /usr/share/plasma/look-and-feel ~/.local/share/plasma/look-and-feel -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    echo -e "${MAGENTA}► Plasma Stilleri${NC}"
    plasma_styles=$(find /usr/share/plasma/desktoptheme ~/.local/share/plasma/desktoptheme -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    echo -e "${MAGENTA}► İkon Takımları${NC}"
    icons=$(find /usr/share/icons ~/.local/share/icons -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    echo -e "${MAGENTA}► Mouse Temaları${NC}"
    cursors=$(find /usr/share/icons ~/.local/share/icons -mindepth 1 -maxdepth 2 -type d -name cursors -exec dirname {} \; 2>/dev/null | xargs -n 1 basename)

    echo -e "${MAGENTA}► Kvantum Temaları${NC}"
    kvantum_themes=$(find /usr/share/Kvantum ~/.config/Kvantum -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)

    echo -e "${MAGENTA}► Renk Şemaları${NC}"
    color_schemes=$(find /usr/share/color-schemes ~/.local/share/color-schemes -type f -name '*.colors' -exec basename {} .colors \; 2>/dev/null)

    # Konsole Renk Şemaları
    echo -e "${MAGENTA}► Konsole Renk Şemaları${NC}"
    konsole_color_schemes=$(find /usr/share/konsole ~/.local/share/konsole -type f -name '*.profile' -exec basename {} .colorscheme \; 2>/dev/null)


    # SDDM Temaları
    echo -e "${MAGENTA}► SDDM Temaları${NC}"
    sddm_themes=$(find /usr/share/sddm/themes -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null)



    echo -e "\n${GREEN}✓ Tüm seçenekler başarıyla listelendi!${NC}\n"
}

# Kullanıcı Seçimleri
get_user_choices() {
    echo -e "${CYAN}┌─ Tema Seçici ─┐${NC}"
    
    echo -e "\n${YELLOW}🌞 Gündüz teması ayarlarınızı seçin:${NC}"
    echo -e "${MAGENTA}1. Global Tema:${NC}"
    select day_theme in $themes; do break; done

    echo -e "${MAGENTA}2. Plasma Stili:${NC}"
    select day_plasma_style in $plasma_styles; do break; done

    echo -e "${MAGENTA}3. İkon Takımı:${NC}"
    select day_icons in $icons; do break; done

    echo -e "${MAGENTA}4. Mouse Teması:${NC}"
    select day_cursor in $cursors; do break; done

    echo -e "${MAGENTA}5. Kvantum Teması:${NC}"
    select day_kvantum in $kvantum_themes; do break; done

    echo -e "${MAGENTA}6. Renk Şeması:${NC}"
    select day_color_scheme in $color_schemes; do break; done

    echo -e "${MAGENTA}7. Konsole Renk Şemaları:${NC}"
    select day_konsole_color_scheme in $konsole_color_schemes; do break; done

    echo -e "${MAGENTA}8. SDDM Temaları:${NC}"
    select day_sddm_theme in $sddm_themes; do break; done

    echo -e "\n${YELLOW}🌙 Gece teması ayarlarınızı seçin:${NC}"
    echo -e "${MAGENTA}1. Global Tema:${NC}"
    select night_theme in $themes; do break; done

    echo -e "${MAGENTA}2. Plasma Stili:${NC}"
    select night_plasma_style in $plasma_styles; do break; done

    echo -e "${MAGENTA}3. İkon Takımı:${NC}"
    select night_icons in $icons; do break; done

    echo -e "${MAGENTA}4. Mouse Teması:${NC}"
    select night_cursor in $cursors; do break; done

    echo -e "${MAGENTA}5. Kvantum Teması:${NC}"
    select night_kvantum in $kvantum_themes; do break; done

    echo -e "${MAGENTA}6. Renk Şeması:${NC}"
    select night_color_scheme in $color_schemes; do break; done

    echo -e "${MAGENTA}7. Konsole Renk Şemaları:${NC}"
    select night_konsole_color_scheme in $konsole_color_schemes; do break; done

    echo -e "${MAGENTA}8. SDDM Temaları:${NC}"
    select night_sddm_theme in $sddm_themes; do break; done

    # Seçimleri Kaydet
    echo -e "${YELLOW}Seçimler kaydediliyor...${NC}"
    cat <<EOL > $CONFIG_FILE
day_theme=$day_theme
day_plasma_style=$day_plasma_style
day_icons=$day_icons
day_cursor=$day_cursor
day_kvantum=$day_kvantum
day_color_scheme=$day_color_scheme
day_konsole_color_scheme=$day_konsole_color_scheme
day_sddm_theme=$day_sddm_theme

night_theme=$night_theme
night_plasma_style=$night_plasma_style
night_icons=$night_icons
night_cursor=$night_cursor
night_kvantum=$night_kvantum
night_color_scheme=$night_color_scheme
night_konsole_color_scheme=$night_konsole_color_scheme
night_sddm_theme=$night_sddm_theme
EOL
    echo -e "\n${GREEN}✓ Seçimler başarıyla kaydedildi: ${BOLD}$CONFIG_FILE${NC}\n"
}

# Yedekleme İşlemi
backup_settings() {
    echo -e "${CYAN}┌─ Yedekleme ─┐${NC}"
    echo -e "${YELLOW}Yedekleme işlemi başlatılıyor...${NC}\n"
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
            echo -e "${GREEN}✓ ${file}${NC} yedeklendi"
        else
            echo -e "${RED}⚠ ${file}${NC} bulunamadı, atlanıyor."
        fi
    done

    if [[ -f /etc/sddm.conf.d/kde_settings.conf ]]; then
        sudo cp /etc/sddm.conf.d/kde_settings.conf "$BACKUP_DIR/sddm.conf_$TIMESTAMP"
        echo -e "${GREEN}✓ /etc/sddm.conf.d/kde_settings.conf${NC} yedeklendi"
    fi

    echo -e "\n${GREEN}✓ Yedekleme tamamlandı${NC}\n"
}

# Ayarları Uygulama
apply_settings() {
    local theme_type=$1
    echo -e "${CYAN}┌─ Tema Uygulama ─┐${NC}"

    source "$CONFIG_FILE"

    if [[ $theme_type == "day" ]]; then
        echo -e "${YELLOW}🌞 Gündüz teması uygulanıyor...${NC}"
        lookandfeeltool -a "$day_theme"
        plasma-apply-desktoptheme "$day_plasma_style"
        kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "$day_icons"
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "$day_cursor"
        kvantummanager --set "$day_kvantum"
        kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "$day_color_scheme"
        # SDDM teması değiştirme
        sudo sed -i "s/^Current=.*/Current=$day_sddm_theme/" "/etc/sddm.conf.d/kde_settings.conf"
        
        # Konsole renk şeması değiştirme
        konsoleprofile colors="$day_konsole_color_scheme"

    else
        echo -e "${YELLOW}🌙 Gece teması uygulanıyor...${NC}"
        lookandfeeltool -a "$night_theme"
        plasma-apply-desktoptheme "$night_plasma_style"
        kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "$night_icons"
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "$night_cursor"
        kvantummanager --set "$night_kvantum"
        kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "$night_color_scheme"
        # SDDM teması değiştirme
        sudo sed -i "s/^Current=.*/Current=$night_sddm_theme/" "/etc/sddm.conf.d/kde_settings.conf"
        
        # Konsole renk şeması değiştirme
        kwriteconfig5 --group "Desktop Entry" --file ~/.config/konsolerc --key DefaultProfile "$night_konsole_color_scheme"
    
    fi

    echo -e "${YELLOW}Plasma yeniden başlatılıyor...${NC}"
    qdbus-qt5 org.kde.KWin /KWin reconfigure
    plasmashell --replace &>/dev/null &
    echo -e "${GREEN}✓ Ayarlar başarıyla uygulandı${NC}\n"
}

# Systemd Servisi Kurulumu
setup_systemd_service() {
    echo -e "${CYAN}┌─ Systemd Servis Kurulumu ─┐${NC}"
    
    if [[ -f $SYSTEMD_SERVICE_PATH ]]; then
        echo -e "${YELLOW}⚠ Systemd servisi zaten mevcut, tekrar oluşturulmayacak.${NC}"
    else
        echo -e "${YELLOW}Systemd servisi oluşturuluyor...${NC}"
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
        echo -e "${GREEN}✓ Systemd servisi oluşturuldu ve etkinleştirildi${NC}\n"
    fi
}

# Temayı Güncelle
switch_theme() {
    current_hour=$(date +%H)

    if (( 6 <= current_hour && current_hour < 18 )); then
        apply_settings "day"
    else
        apply_settings "night"
    fi
}

# Hata Yakalama
trap 'echo -e "\n${RED}⚠ Script kesintiye uğradı!${NC}"; exit 1' INT TERM


# Ana Program
clear
print_banner

if [[ ! -f $CONFIG_FILE ]]; then
    echo -e "${YELLOW}⚙ İlk kurulum başlatılıyor...${NC}\n"
    list_options
    get_user_choices
    backup_settings
    setup_systemd_service
    switch_theme
else
    update_menu
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${BOLD}           İŞLEM TAMAMLANDI           ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
