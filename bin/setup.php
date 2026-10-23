<?php
/**
 * Menyiapkan aplikasi baru (dijalankan otomatis oleh `composer create-project`).
 * Aman dijalankan berulang: berkas yang sudah ada tidak ditimpa.
 *
 *   php bin/setup.php
 *
 * - menyalin cfg/*.example menjadi berkas konfigurasi lokal (diabaikan Git)
 * - mengisi nama aplikasi dan nama database dari nama folder
 * - membuat rahasia HMAC (cfg/security.yaml) acak
 * - memastikan direktori log/ dan upload/ ada
 */

$root  = dirname(__DIR__);
$name  = basename($root);
$slug  = strtolower(trim(preg_replace('/[^A-Za-z0-9]+/', '_', $name), '_'));
if ($slug === '') $slug = 'app';
$title = ucwords(str_replace('_', ' ', $slug));

$tokens = array(
    '__APP_NAME__'  => $slug,
    '__APP_TITLE__' => $title,
    '__DB_NAME__'   => 'lived_' . $slug,
);

function say($msg) { fwrite(STDOUT, $msg . PHP_EOL); }

// 1. berkas konfigurasi lokal
foreach (array('appl_config.php', 'security.yaml', 'mail.php', 'login_page_config.php') as $f) {
    $dst = "$root/cfg/$f";
    $src = "$dst.example";
    if (is_file($dst)) { say("  ada      cfg/$f"); continue; }
    if (!is_file($src)) { say("  lewati   cfg/$f (contoh tidak ditemukan)"); continue; }
    copy($src, $dst);
    say("  dibuat   cfg/$f");
}

// 2. rahasia HMAC acak (hanya bila masih nilai contoh)
$yaml = "$root/cfg/security.yaml";
if (is_file($yaml)) {
    $s = file_get_contents($yaml);
    if (strpos($s, 'GANTI_DENGAN_STRING_ACAK_MIN_32_KARAKTER') !== false) {
        file_put_contents($yaml, str_replace('GANTI_DENGAN_STRING_ACAK_MIN_32_KARAKTER', bin2hex(random_bytes(32)), $s));
        say("  diisi    cfg/security.yaml (hmac_secret acak)");
    }
}

// 3. nama aplikasi / database pada berkas yang memakai tanda __...__
foreach (array('cfg/appl_config.php', 'cfg/config_map.xml', 'cfg/login_page_config.php') as $f) {
    $path = "$root/$f";
    if (!is_file($path)) continue;
    $s = file_get_contents($path);
    $n = strtr($s, $tokens);
    if ($n !== $s) { file_put_contents($path, $n); say("  diisi    $f"); }
}

// 4. direktori kerja
foreach (array('log', 'upload', 'modul') as $d) {
    if (!is_dir("$root/$d") && mkdir("$root/$d", 0775, true)) say("  dibuat   $d/");
}

say('');
say("Aplikasi '$slug' siap. Langkah berikutnya:");
say("  1. Isi koneksi database di cfg/appl_config.php (db_host, db_user, db_pswd; db_appl = lived_$slug)");
say("  2. composer install-db         (membuat tabel inti + pengguna admin)");
say("  3. composer serve              (http://localhost:8000)");
say("Modul aplikasi diletakkan di modul/. Dokumen root web server harus mengarah ke public/.");
