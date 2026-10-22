<?php
/**
 * Memasang database framework: tabel inti, data awal, modul APPL, grup & pengguna administrator.
 *
 *   php bin/install-db.php [--user=admin] [--admin-password=RAHASIA] [--force]
 *
 * Tanpa --admin-password, kata sandi acak dibuat dan dicetak SEKALI. Database dibuat bila belum ada.
 * Bila tabel appl_user sudah berisi data, perintah berhenti kecuali --force (data inti tidak dihapus,
 * hanya dilengkapi bila belum ada).
 */

$root = dirname(__DIR__);
define('APP_PATH', $root);

$opts = array('user' => 'admin', 'admin-password' => null, 'force' => false);
foreach (array_slice($argv, 1) as $a) {
    if ($a === '--force') $opts['force'] = true;
    elseif (preg_match('/^--(user|admin-password)=(.*)$/s', $a, $m)) $opts[$m[1]] = $m[2];
    else { fwrite(STDERR, "Argumen tidak dikenal: $a\n"); exit(2); }
}
if (!preg_match('/^[A-Za-z0-9_.-]{1,30}$/', $opts['user'])) { fwrite(STDERR, "Nama pengguna tidak valid.\n"); exit(2); }

// --- konfigurasi
if (!is_file("$root/cfg/appl_config.php")) { fwrite(STDERR, "cfg/appl_config.php belum ada. Jalankan: php bin/setup.php\n"); exit(1); }
$cfg = (function () use ($root) { include "$root/cfg/appl_config.php"; return get_defined_vars(); })();
foreach (array('db_type', 'db_host', 'db_user', 'db_pswd', 'db_appl') as $k) {
    if (!isset($cfg[$k])) { fwrite(STDERR, "Variabel \$$k tidak ada di cfg/appl_config.php\n"); exit(1); }
}
if (!preg_match('/^[A-Za-z0-9_]{1,64}$/', $cfg['db_appl'])) { fwrite(STDERR, "Nama database (\$db_appl) hanya boleh huruf, angka, dan _.\n"); exit(1); }

// --- memuat kelas framework yang dibutuhkan (kata sandi & enkripsi mengikuti kode framework)
$autoload = "$root/vendor/autoload.php";
$fw = "$root/vendor/lived/framework";
if (!is_file($autoload) || !is_dir($fw)) { fwrite(STDERR, "Jalankan `composer install` lebih dulu.\n"); exit(1); }
define('LIVED_PATH', realpath($fw));
set_include_path(APP_PATH . PATH_SEPARATOR . LIVED_PATH . PATH_SEPARATOR . get_include_path());
chdir(APP_PATH);
require $autoload;
require_once 'lib/appl/appl_modul.php';
require_once 'lib/appl/appl_user.php';

// --- koneksi
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$host = $cfg['db_host']; $port = 3306;
if (strpos($host, ':') !== false && substr_count($host, ':') === 1) list($host, $port) = explode(':', $host, 2);
try {
    $db = new mysqli($host, $cfg['db_user'], $cfg['db_pswd'], '', (int)$port);
    $db->set_charset('utf8mb4');
    $db->query("CREATE DATABASE IF NOT EXISTS `{$cfg['db_appl']}` CHARACTER SET utf8mb4");
    $db->select_db($cfg['db_appl']);
} catch (mysqli_sql_exception $e) {
    fwrite(STDERR, "Koneksi database gagal: " . $e->getMessage() . "\n");
    exit(1);
}

$exists = $db->query("SHOW TABLES LIKE 'appl_user'")->num_rows > 0;
if ($exists) {
    $n = (int)$db->query("SELECT COUNT(*) FROM appl_user")->fetch_row()[0];
    if ($n > 0 && !$opts['force']) {
        fwrite(STDERR, "Database '{$cfg['db_appl']}' sudah berisi $n pengguna. Gunakan --force untuk melengkapi data awal.\n");
        exit(1);
    }
}

function run_file(mysqli $db, $file) {
    if (!$db->multi_query(file_get_contents($file))) return;
    do { if ($r = $db->store_result()) $r->free(); } while ($db->more_results() && $db->next_result());
}

// --- skema & data awal (INSERT IGNORE agar --force tidak gagal pada baris yang sudah ada)
run_file($db, "$root/database/schema.sql");
$seed = file_get_contents("$root/database/seed.sql");
file_put_contents($tmp = sys_get_temp_dir() . '/lived_seed_' . getmypid() . '.sql', preg_replace('/^INSERT INTO/m', 'INSERT IGNORE INTO', $seed));
try { run_file($db, $tmp); } finally { @unlink($tmp); }

// --- modul APPL, hak grup, pengguna
$password = $opts['admin-password'];
$generated = false;
if ($password === null || $password === '') {
    $password = rtrim(strtr(base64_encode(random_bytes(12)), '+/', 'Ab'), '=');
    $generated = true;
}
$hash   = ApplUser::encryptPassword($password, $opts['user']);
$dbPswd = ApplModul::encrypt($cfg['db_pswd']);
$user   = $opts['user'];

$st = $db->prepare("INSERT IGNORE INTO appl_modul (id_modul, kode_modul, modul_name, modul_path, menu, db_driver, db_host, db_user, db_pswd, db_name, db_options, description, created_by, creation_date)
                    VALUES (1, 'APPL', 'Administrator', 'admin', 1, ?, ?, ?, ?, ?, '', '', 'setup', NOW())");
$st->bind_param('sssss', $cfg['db_type'], $cfg['db_host'], $cfg['db_user'], $dbPswd, $cfg['db_appl']);
$st->execute();

$db->query("INSERT IGNORE INTO appl_group_privileges (group_name, modul_id, seq, access_type, created_by, creation_date) VALUES ('Administrator', 1, 1, 'rw', 'setup', NOW())");

$st = $db->prepare("INSERT INTO appl_user (login_name, password, full_name, unit_kerja, wilayah, disabled, theme, created_by, creation_date)
                    VALUES (?, ?, 'Administrator', '000', '00', '0', '3', 'setup', NOW())
                    ON DUPLICATE KEY UPDATE password = VALUES(password), disabled = '0'");
$st->bind_param('ss', $user, $hash);
$st->execute();

$st = $db->prepare("INSERT IGNORE INTO appl_group_members (group_name, login_name, default_login, created_by, creation_date) VALUES ('Administrator', ?, '1', 'setup', NOW())");
$st->bind_param('s', $user);
$st->execute();

echo "Database '{$cfg['db_appl']}' siap.\n";
echo "Pengguna : $user\n";
echo "Kata sandi: $password" . ($generated ? "   (dibuat otomatis; catat sekarang, tidak ditampilkan lagi)" : "") . "\n";
echo "Setelah masuk, ganti kata sandi dan buat modul aplikasi lewat menu Administrator > Modul.\n";
