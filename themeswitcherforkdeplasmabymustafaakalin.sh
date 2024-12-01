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
KONSOLE_PROFILE_DIR="$HOME/.local/share/konsole"

# Banner Fonksiyonu
print_banner() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${BOLD}       KDE TEMA DEĞİŞTİRİCİ v1.1        ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo
}

# Konsol Profilleri Listesi
list_console_profiles() {
    echo -e "${MAGENTA}► Konsol Profilleri${NC}"
    console_profiles=$(find "$KONSOLE_PROFILE_DIR" -name "*.profile" -exec basename {} .profile \; 2>/dev/null)
    if [[ -z "$console_profiles" ]]; then
        echo -e "${RED}⚠ Hiç konsol profili bulunamadı${NC}"
        return 1
    fi
}

# Güncelleme Menüsü
update_menu() {
    echo -e "${CYAN}┌─ Tema Güncelleme ─┐${NC}"
    echo -e "${YELLOW}Mevcut ayarlarınızı güncellemek ister misiniz?${NC}\n"
    echo -e "1) ${MAGENTA}Gündüz Temasını Güncelle 🌞${NC}"
    echo -e "2) ${MAGENTA}Gece Temasını Güncelle 🌙${NC}"
    echo -e "3) ${MAGENTA}Mevcut Temayı Uygula${NC}"
    echo -e "4) ${MAGENTA}Konsol Profillerini Yönet 🖥️${NC}"
    echo -e "5) ${RED}Çıkış${NC}"
    
    read -p $'\nSeçiminiz (1-5): ' choice

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
            manage_console_profiles
            ;;
        5)
            echo -e "\n${GREEN}Program kapatılıyor...${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}⚠ Geçersiz seçim!${NC}"
            update_menu
            ;;
    esac
}

# Konsol Profilleri Yönetimi
manage_console_profiles() {
    echo -e "${CYAN}┌─ Konsol Profilleri Yönetimi ─┐${NC}"
    if ! list_console_profiles; then
        echo -e "${YELLOW}Yeni bir konsol profili oluşturmak ister misiniz? (E/H)${NC}"
        read -p "Seçiminiz: " create_new
        if [[ $create_new =~ ^[Ee]$ ]]; then
            create_console_profile
        fi
        return
    fi

    echo -e "\n${YELLOW}1) Gündüz Konsol Profilini Seç${NC}"
    echo -e "${YELLOW}2) Gece Konsol Profilini Seç${NC}"
    echo -e "${YELLOW}3) Yeni Profil Oluştur${NC}"
    echo -e "${RED}4) Geri${NC}"

    read -p $'\nSeçiminiz (1-4): ' profile_choice

    case $profile_choice in
        1)
            echo -e "\n${YELLOW}Gündüz konsol profili seçin:${NC}"
            select day_console_profile in $console_profiles; do
                update_console_setting "day" "$day_console_profile"
                break
            done
            ;;
        2)
            echo -e "\n${YELLOW}Gece konsol profili seçin:${NC}"
            select night_console_profile in $console_profiles; do
                update_console_setting "night" "$night_console_profile"
                break
            done
            ;;
        3)
            create_console_profile
            ;;
        4)
            update_menu
            ;;
        *)
            echo -e "${RED}⚠ Geçersiz seçim!${NC}"
            manage_console_profiles
            ;;
    esac
}

# Yeni Konsol Profili Oluşturma
create_console_profile() {
    echo -e "${CYAN}┌─ Yeni Konsol Profili ─┐${NC}"
    read -p "Profil adı: " profile_name
    
    if [[ -z "$profile_name" ]]; then
        echo -e "${RED}⚠ Profil adı boş olamaz!${NC}"
        return
    fi

    mkdir -p "$KONSOLE_PROFILE_DIR"
    profile_file="$KONSOLE_PROFILE_DIR/${profile_name}.profile"

    # Temel profil ayarları
    cat <<EOL > "$profile_file"
[Appearance]
ColorScheme=Breeze
Font=Monospace,10,-1,5,50,0,0,0,0,0

[General]
Name=$profile_name
Parent=FALLBACK/

[Scrolling]
HistoryMode=2
ScrollBarPosition=2

[Terminal Features]
BlinkingCursorEnabled=true
EOL

    if [[ -f "$profile_file" ]]; then
        echo -e "${GREEN}✓ Yeni profil oluşturuldu: $profile_name${NC}"
        echo -e "${YELLOW}Profili şimdi ayarlamak ister misiniz? (E/H)${NC}"
        read -p "Seçiminiz: " set_now
        if [[ $set_now =~ ^[Ee]$ ]]; then
            manage_console_profiles
        fi
    else
        echo -e "${RED}⚠ Profil oluşturulurken hata oluştu!${NC}"
    fi
}

# Konsol Ayarlarını Güncelleme
update_console_setting() {
    local time_of_day=$1
    local profile_name=$2
    
    if [[ -z "$profile_name" ]]; then
        echo -e "${RED}⚠ Profil seçilmedi!${NC}"
        return
    }

    # Mevcut ayarları yükle
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi

    # Yeni konsol profilini kaydet
    if [[ $time_of_day == "day" ]]; then
        sed -i "/^day_console_profile=.*/d" "$CONFIG_FILE"
        echo "day_console_profile=$profile_name" >> "$CONFIG_FILE"
    else
        sed -i "/^night_console_profile=.*/d" "$CONFIG_FILE"
        echo "night_console_profile=$profile_name" >> "$CONFIG_FILE"
    fi

    echo -e "${GREEN}✓ Konsol profili güncellendi: $profile_name${NC}"
}

# Tema Ayarlarını Uygulama (Güncellendi)
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
        
        # Konsol profili değişimi
        if [[ -n "$day_console_profile" ]]; then
            konsoleprofile colors="$day_console_profile"
        fi
    else
        echo -e "${YELLOW}🌙 Gece teması uygulanıyor...${NC}"
        lookandfeeltool -a "$night_theme"
        plasma-apply-desktoptheme "$night_plasma_style"
        kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "$night_icons"
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "$night_cursor"
        kvantummanager --set "$night_kvantum"
        kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "$night_color_scheme"
        
        # Konsol profili değişimi
        if [[ -n "$night_console_profile" ]]; then
            konsoleprofile colors="$night_console_profile"
        fi
    fi

    echo -e "${YELLOW}Plasma yeniden başlatılıyor...${NC}"
    qdbus-qt5 org.kde.KWin /KWin reconfigure
    plasmashell --replace &>/dev/null &
    echo -e "${GREEN}✓ Ayarlar başarıyla uygulandı${NC}\n"
}

# Kullanıcı Seçimleri (Güncellendi)
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

    echo -e "${MAGENTA}7. Konsol Profili:${NC}"
    if list_console_profiles; then
        select day_console_profile in $console_profiles; do break; done
    fi

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

    echo -e "${MAGENTA}7. Konsol Profili:${NC}"
    if list_console_profiles; then
        select night_console_profile in $console_profiles; do break; done
    fi

    # Seçimleri Kaydet
    echo -e "${YELLOW}Seçimler kaydediliyor...${NC}"
    cat <<EOL > $CONFIG_FILE
day_theme=$day_theme
day_plasma_style=$day_plasma_style
day_icons=$day_icons
day_cursor=$day_cursor
day_kvantum=$day_kvantum
day_color_scheme=$day_color_scheme
day_console_profile=$day_console_profile

night_theme=$night_theme
night_plasma_style=$night_plasma_style
night_icons=$night_icons
night_cursor=$night_cursor
night_kvantum=$night_kvantum
night_color_scheme=$night_color_scheme
night_console_profile=$night_console_profile
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

    if [[ -f /etc/sddm.conf ]]; then
        sudo cp /etc/sddm.conf "$BACKUP_DIR/sddm.conf_$TIMESTAMP"
        echo -e "${GREEN}✓ /etc/sddm.conf${NC} yedeklendi"
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
    else
        echo -e "${YELLOW}🌙 Gece teması uygulanıyor...${NC}"
        lookandfeeltool -a "$night_theme"
        plasma-apply-desktoptheme "$night_plasma_style"
        kwriteconfig5 --file ~/.config/kdeglobals --group Icons --key Theme "$night_icons"
        kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme "$night_cursor"
        kvantummanager --set "$night_kvantum"
        kwriteconfig5 --file ~/.config/kdeglobals --group General --key ColorScheme "$night_color_scheme"
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
