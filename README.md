# Kerangka aplikasi LIVED

Titik awal aplikasi baru di atas [LIVED Framework](https://github.com/agussutejo73/LIVED_V2) (paket Composer `lived/framework`).
Framework dipasang di `vendor/`; yang Anda kembangkan hanya `modul/`, `cfg/`, dan `public/`.

## Membuat aplikasi baru

```bash
composer create-project lived/app-skeleton namaapp
cd namaapp
```

`create-project` memasang dependensi, menyalin aset framework ke `public/`, lalu menjalankan `bin/setup.php`
yang membuat `cfg/appl_config.php`, `cfg/security.yaml` (rahasia HMAC acak) dan `cfg/mail.php` dari contohnya.

Lalu:

1. Isi koneksi database di `cfg/appl_config.php` (`db_host`, `db_user`, `db_pswd`; nama database bawaan `lived_<namaapp>`).
2. `composer install-db`: membuat database, tabel inti, menu administrator, dan pengguna `admin`
   (kata sandi acak dicetak sekali; atau `php bin/install-db.php --admin-password=...`).
3. `composer serve` lalu buka http://localhost:8000.

### Tanpa konfigurasi Composer global

Bila paket belum ada di Packagist, beri tahu Composer lokasinya pada perintah itu sendiri:

```bash
# repositori publik, atau privat dengan token (lihat di bawah)
composer create-project lived/app-skeleton namaapp \
  --repository='{"type":"vcs","url":"https://github.com/agussutejo73/lived-app-skeleton"}' \
  --stability=dev

# repositori GitHub privat: sediakan token untuk satu perintah saja
COMPOSER_AUTH='{"github-oauth":{"github.com":"TOKEN_ANDA"}}' \
  composer create-project lived/app-skeleton namaapp --repository=...
```

Tanpa Composer `create-project` sama sekali:

```bash
git clone https://github.com/agussutejo73/lived-app-skeleton namaapp
cd namaapp && rm -rf .git
composer install && php bin/setup.php
```

## Struktur

| Jalur | Isi |
|---|---|
| `public/` | satu-satunya document root web server; `index.php` + aset (symlink/salinan dari framework, tidak di-commit) |
| `cfg/` | konfigurasi; `*.example` di-commit, hasil salinan (`appl_config.php`, `security.yaml`, `mail.php`, `login_page_config.php`) tidak |
| `modul/` | kode modul aplikasi (halaman, form, model, laporan `.jasper`) |
| `database/` | `schema.sql` dan `seed.sql` tabel inti |
| `log/`, `upload/` | ditulis aplikasi; tertutup untuk web (`.htaccess`) dan tidak di-commit |
| `vendor/` | framework dan pustaka (tidak di-commit) |

Server produksi: arahkan document root ke `public/` (Apache/Nginx). Jangan mengekspos folder lain.

## Memperbarui framework

```bash
composer update lived/framework
```

Aset di `public/` dipublikasikan ulang otomatis. Di Windows tanpa hak symlink: `composer publish-assets -- --copy`.
Commit `composer.lock` supaya semua anggota tim dan server memakai versi yang sama.

## Versi framework

`composer.json` saat ini memakai cabang pengembangan (`dev-split-framework`). Setelah framework diberi tag
(mis. `v2.1.0`), ubah menjadi `"lived/framework": "^2.1"` dan hapus `minimum-stability`.

## Menulis modul

Konvensi modul (path `modul/...`, kelas turunan `BasePage`/`BaseForm`/`BaseReport`, `LivedModel`) sama dengan
LIVED V1; lihat dokumentasi framework dan folder `modul/` aplikasi contoh.
