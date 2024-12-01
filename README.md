# KDE Theme Switcher 🎨

KDE Theme Switcher, KDE Plasma masaüstü ortamı için otomatik tema değiştirici bir araçtır. Gündüz/gece temalarını otomatik olarak değiştirir ve sistem genelinde tutarlı bir görünüm sağlar.

## 🌟 Özellikler

### Ana Özellikler
- 🌞 Gündüz/Gece tema desteği
- 🔄 Otomatik tema değişimi (6:00-18:00 arası gündüz teması, 18:00-6:00 arası gece teması)
- 🎯 Sistemd servisi ile otomatik başlatma
- 💾 Yapılandırma yedekleme
- 📊 Kolay kullanımlı terminal arayüzü

### Özelleştirilebilen Temalar
- 🎨 Global Temalar
- 🖥️ Plasma Stilleri
- 📱 İkon Takımları
- 🖱️ Mouse Temaları
- 🎯 Kvantum Temaları
- 🌈 Renk Şemaları
- 💻 Konsol Profilleri

## ⚙️ Kurulum

1. Script dosyasını indirin:
```bash
wget https://raw.githubusercontent.com/username/kde-theme-switcher/main/themeswitcherforkdeplasmabymustafaakalin.sh
```

2. Çalıştırma iznini verin:
```bash
chmod +x themeswitcherforkdeplasmabymustafaakalin.sh
```

3. Scripti çalıştırın:
```bash
./themeswitcherforkdeplasmabymustafaakalin.sh
```

## 📝 Kullanım

### İlk Kurulum
İlk çalıştırmada script:
1. Mevcut temaları tarar
2. Gündüz/gece tema seçimlerini ister
3. Mevcut ayarları yedekler
4. Systemd servisini kurar
5. Seçilen temayı uygular

### Tema Güncelleme
Ana menüden şu seçeneklere erişebilirsiniz:
1. Gündüz Temasını Güncelle
2. Gece Temasını Güncelle
3. Mevcut Temayı Uygula
4. Konsol Profillerini Yönet
5. Çıkış

### Konsol Profilleri
- Yeni profil oluşturma
- Mevcut profilleri görüntüleme
- Gündüz/gece için farklı profiller atama
- Profil renk şemalarını değiştirme

## 🗄️ Yapılandırma Dosyaları

- Ana yapılandırma: `~/.theme_switcher_config`
- Yedekler: `~/.theme_backups`
- Systemd servisi: `~/.config/systemd/user/theme-switcher.service`
- Konsol profilleri: `~/.local/share/konsole/`

## 🔧 Bağımlılıklar

- KDE Plasma Desktop Environment
- Systemd
- Kvantum Manager
- KDE CLI araçları (lookandfeeltool, plasma-apply-desktoptheme)

## 🚨 Hata Bildirimi

Herhangi bir hata veya öneriniz için GitHub Issues bölümünü kullanabilirsiniz.

## 📜 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakınız.

## 🤝 Katkıda Bulunma

1. Fork'layın
2. Feature branch oluşturun (`git checkout -b feature/özellik`)
3. Değişikliklerinizi commit edin (`git commit -am 'Yeni özellik: Özellik açıklaması'`)
4. Branch'inizi push edin (`git push origin feature/özellik`)
5. Pull Request oluşturun

## 📌 Not

- Script çalıştırılmadan önce mevcut tema ayarlarınızı yedeklemeniz önerilir
- Systemd servisi kurulumu için root yetkisi gerekmez
- Tema değişim saatlerini script içinden özelleştirebilirsiniz

## ✨ Teşekkürler

Bu projeye katkıda bulunan herkese teşekkürler!
