<?php
/**
 * Ubah password DB modul (appl_modul.db_pswd) dari format lama (sandi geser) ke format v2 (AES-256-CBC + HMAC).
 *
 *   php bin/migrasi-modul-pswd.php            (uji coba, tidak menulis)
 *   php bin/migrasi-modul-pswd.php --apply    (menulis)
 *
 * Syarat: 'modul_key' sudah diisi di cfg/secrets.php (min. 32 karakter acak; untuk data dari V1, salin kunci V1).
 * Aman diulang (baris v2 dilewati). Cadangkan tabel appl_modul lebih dulu. Password tidak pernah dicetak.
 */
if (php_sapi_name() !== 'cli') { http_response_code(404); exit; }

$root = dirname(__DIR__);
define('APP_PATH', $root);
$apply = in_array('--apply', $argv, true);

if (!is_file("$root/cfg/appl_config.php")) { fwrite(STDERR, "cfg/appl_config.php belum ada.\n"); exit(1); }
$cfg = (function () use ($root) { include "$root/cfg/appl_config.php"; return get_defined_vars(); })();

$autoload = "$root/vendor/autoload.php";
$fw = "$root/vendor/lived/framework";
if (!is_file($autoload) || !is_dir($fw)) { fwrite(STDERR, "Jalankan `composer install` lebih dulu.\n"); exit(1); }
define('LIVED_PATH', realpath($fw));
set_include_path(APP_PATH . PATH_SEPARATOR . LIVED_PATH . PATH_SEPARATOR . get_include_path());
chdir(APP_PATH);
require $autoload;
require_once 'lib/appl/appl_modul.php';

$secret = LivedSecrets::get('modul_key');
if (!is_string($secret) || strlen($secret) < 32 || strpos($secret, 'GANTI-') === 0) {
    fwrite(STDERR, "modul_key belum diisi di cfg/secrets.php (min. 32 karakter acak). Dibatalkan.\n"); exit(1);
}

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$host = $cfg['db_host']; $port = 3306;
if (substr_count($host, ':') === 1) list($host, $port) = explode(':', $host, 2);
try {
    $db = new mysqli($host, $cfg['db_user'], $cfg['db_pswd'], $cfg['db_appl'], (int) $port);
} catch (mysqli_sql_exception $e) {
    fwrite(STDERR, "Koneksi database gagal: " . $e->getMessage() . "\n"); exit(1);
}

$rows = $db->query("SELECT id_modul, kode_modul, db_pswd FROM appl_modul")->fetch_all(MYSQLI_NUM);
$n = array('v2' => 0, 'kosong' => 0, 'lama' => 0, 'diubah' => 0, 'gagal' => 0);
$upd = $db->prepare("UPDATE appl_modul SET db_pswd = ? WHERE id_modul = ?");
foreach ($rows as $r) {
    list($id, $kode, $stored) = array($r[0], $r[1], (string) $r[2]);
    if ($stored === '') { $n['kosong']++; continue; }
    if (!ApplModul::isLegacyPassword($stored)) { $n['v2']++; continue; }
    $n['lama']++;
    $plain = ApplModul::decrypt($stored);
    $new = ($plain === '') ? '' : ApplModul::encrypt($plain);
    if ($new === '' || ApplModul::isLegacyPassword($new) || ApplModul::decrypt($new) !== $plain) {
        $n['gagal']++; echo "GAGAL   modul $kode (id $id): tidak dapat dikonversi\n"; continue;
    }
    if ($apply) {
        $upd->bind_param('si', $new, $id);
        $upd->execute();
        $n['diubah']++; echo "DIUBAH  modul $kode (id $id)\n";
    } else {
        echo "AKAN DIUBAH modul $kode (id $id)\n";
    }
}
printf("\n%s: sudah v2=%d, kosong=%d, format lama=%d, diubah=%d, gagal=%d\n",
    $apply ? 'SELESAI' : 'UJI COBA (tidak ada yang ditulis)', $n['v2'], $n['kosong'], $n['lama'], $n['diubah'], $n['gagal']);
exit($n['gagal'] ? 1 : 0);
