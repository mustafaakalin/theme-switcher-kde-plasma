# theme-switcher-kde-plasma-by-mustafaakalin
Bu bash betiği, KDE Plasma masaüstü ortamında, gündüz ve gece temalarını otomatik olarak değiştiren bir tema anahtarlama aracıdır. 


# KDE Plasma Tema Anahtarlama Betiği

Bu bash betiği, KDE Plasma masaüstü ortamında, gündüz ve gece temalarını otomatik olarak değiştiren bir tema anahtarlama aracıdır. Betik, kullanıcıya farklı tema seçenekleri sunar, seçimlerini kaydeder, ayarları uygular ve belirli dosyaların yedeğini alır. Ayrıca bir systemd servisi oluşturarak, temaların otomatik olarak güncellenmesini sağlar. İşte betiğin adım adım özeti:

## 1. Değişkenler ve Yedekleme Dizini Tanımlamaları
Betik, temalar ve konfigürasyon dosyalarını yönetmek için çeşitli dosya ve dizin yollarını tanımlar.
- **CONFIG_FILE**: Kullanıcının tema seçimlerini kaydedecek dosya yolu.
- **BACKUP_DIR**: Temel konfigürasyon dosyalarının yedekleneceği dizin.
- **SYSTEMD_SERVICE**: systemd servisi için kullanılacak dosya adı ve yolu.
- **TIMESTAMP**: Yedekleme dosya adlarında zaman damgası eklemek için kullanılır.

## 2. Listeleme İşlevi (list_options)
Betik, kullanıcıya seçim yapabilmesi için mevcut tüm tema seçeneklerini listeler:
- Global Temalar
- Plasma Stilleri
- İkon Takımları
- Mouse Temaları
- Kvantum Temaları
- Renk Şemaları

## 3. Kullanıcı Seçimlerini Alma (get_user_choices)
Kullanıcıya gündüz ve gece için tema seçeneklerini seçmesi istenir. Seçilen temalar **CONFIG_FILE** dosyasına kaydedilir.

## 4. Yedekleme İşlemi (backup_settings)
Betik, bazı temel KDE ayar dosyalarının yedeğini alır. Bu dosyalar şunlardır:
- `~/.config/kdeglobals`
- `~/.config/kwinrc`
- `~/.config/plasmarc`
- `~/.config/ksplashrc`
- `~/.config/kcminputrc`
Eğer varsa, `/etc/sddm.conf` dosyası da yedeklenir.

## 5. Ayarları Uygulama (apply_settings)
Seçilen tema seçeneklerine göre gündüz veya gece teması ayarları uygulanır. Temalar, Plasma masaüstü ortamına uygun araçlar kullanılarak ayarlanır:
- `lookandfeeltool` ile global tema.
- `plasma-apply-desktoptheme` ile Plasma stili.
- `kwriteconfig5` ile ikon ve fare teması ayarları.
- `kvantummanager` ile Kvantum teması.
- `qdbus-qt5` ile Plasma yeniden başlatılır.

## 6. Systemd Servisi Kurulumu (setup_systemd_service)
Eğer systemd servisi mevcut değilse, kullanıcıyı otomatik olarak gündüz ve gece temalarını değiştirmek için bir systemd servisi kurar. Bu servis, belirli aralıklarla temaların değiştirilmesi için sürekli çalışır.

## 7. Temayı Güncelleme (switch_theme)
Saat dilimine göre, betik gündüz (06:00 - 18:00) veya gece (18:00 - 06:00) temasını uygular.

## 8. Ana Program
Betik, önce konfigürasyon dosyasının var olup olmadığını kontrol eder. Eğer yoksa, kullanıcıdan tema seçeneklerini alır, yedekleme yapar ve systemd servisini kurar. Ardından, güncel saati kontrol ederek temayı günceller.

Bu betik, KDE Plasma masaüstü ortamında zaman dilimine göre temaların otomatik olarak değiştirilmesi için kapsamlı bir çözüm sunar. Kullanıcı, yalnızca başlangıçta seçim yapar ve sonrasında tema değişiklikleri otomatik olarak uygulanır.
