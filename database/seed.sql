-- Data awal: tema, menu administrator, wilayah/unit kerja contoh, grup Administrator.
-- Modul APPL, pengguna admin, dan hak grup dibuat oleh bin/install-db.php (butuh kata sandi).
SET NAMES utf8mb4;
SET SESSION sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

INSERT INTO `appl_themes` (`id_theme`, `theme_name`, `theme_path`, `author`, `preview_image`, `description`, `created_by`, `creation_date`, `last_updated_by`, `last_updated_date`) VALUES
	(1, 'LIVED Standard', 'themes/default', 'LIVED', 'themes/default/preview.jpg', 'Standar theme LIVED Application Framework', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(3, 'LIVED Office', 'themes/office', 'LIVED', 'themes/office/preview.jpg', 'Thema Perkantoran', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(4, 'LIVED Yellow', 'themes/yellow', 'LIVED', 'themes/yellow/preview.jpg', 'Everything yellow', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(5, 'LIVED SkyTech', 'themes/skytech', 'LIVED', 'themes/skytech/preview.jpg', 'Thema SkyTech', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(7, 'LIVED Batik', 'themes/batik', 'LIVED', 'themes/batik/preview.jpg', 'Thema batik Kawung: soga dan emas di atas putih gading', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(8, 'LIVED Teknologi', 'themes/teknologi', 'LIVED', 'themes/teknologi/preview.jpg', 'Thema teknologi: biru dengan jalur sirkuit PCB', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00');

INSERT INTO `appl_menu` (`id_menu`, `menu_name`, `description`, `created_by`, `creation_date`, `last_updated_by`, `last_updated_date`) VALUES
	(1, 'Menu Administrator', '', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(2, 'Admin Submenu Setup Aplikasi', '', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(3, 'Admin Submenu Setup Kode Aplikasi', '', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(14, 'Admin Submenu Tools', '', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00');

INSERT INTO `appl_menu_item` (`id_menu_item`, `menu`, `seq`, `prompt`, `url`, `modul_id`, `class_name`, `document`, `parameter`, `submenu`, `target`, `created_by`, `creation_date`, `last_updated_by`, `last_updated_date`) VALUES
	(1, 1, 10, 'Setup Aplikasi', NULL, NULL, NULL, NULL, NULL, 2, 'content', '', '0000-00-00 00:00:00', NULL, '0000-00-00 00:00:00'),
	(2, 2, 10, 'Pengguna', NULL, 1, 'LivedUser', 'admin/lived_user.php', NULL, 0, 'content', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(3, 2, 20, 'Group', NULL, 1, 'LivedGroup', 'admin/lived_group.php', NULL, 0, 'content', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(4, 2, 30, 'Modul', NULL, 1, 'LivedModul', 'admin/lived_modul.php', NULL, 0, 'content', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(5, 2, 40, 'Menu Aplikasi', NULL, 1, 'LivedMenu', 'admin/lived_menu.php', NULL, 0, 'content', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(6, 1, 20, 'Setup Kode Aplikasi', NULL, NULL, NULL, NULL, NULL, 3, NULL, '', '0000-00-00 00:00:00', NULL, '0000-00-00 00:00:00'),
	(7, 3, 10, 'Unit Kerja', '', 1, 'LivedUnitKerja', 'admin/lived_unit_kerja.php', NULL, 0, 'content', '', '0000-00-00 00:00:00', 'agus', '0000-00-00 00:00:00'),
	(8, 3, 20, 'Kode Wilayah', '', 1, 'LivedWilayah', 'admin/lived_wilayah.php', NULL, 0, 'content', '', '0000-00-00 00:00:00', 'agus', '0000-00-00 00:00:00'),
	(34, 2, 50, 'Themes', '', 1, 'LivedThemes', 'admin/lived_themes.php', '', 0, 'content', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(35, 1, 30, 'Tools', '', 1, '', '', '', 14, 'content', '', '0000-00-00 00:00:00', '', '0000-00-00 00:00:00'),
	(38, 14, 30, 'User Log', '', 1, 'ListUserLog', 'admin/list_user_log.php', '', 0, 'content', 'agus', '2008-01-17 09:33:33', '', '0000-00-00 00:00:00');

INSERT INTO `appl_klasf_wilayah` (`kode_klasf`, `nama_klasf`, `level`, `created_by`, `creation_date`) VALUES
	('NAS', 'Nasional', 0, 'setup', NOW());

INSERT INTO `appl_kode_wilayah` (`kode_wilayah`, `nama_wilayah`, `klasifikasi`, `kode_induk`, `created_by`, `creation_date`) VALUES
	('00', 'NASIONAL', 'NAS', '', 'setup', NOW());

INSERT INTO `appl_unit_kerja` (`kode_unit`, `nama_unit`, `singkatan`, `kode_induk`, `created_by`, `creation_date`) VALUES
	('000', 'Unit Kerja Utama', 'UTAMA', '', 'setup', NOW());

INSERT INTO `appl_group` (`group_name`, `description`, `created_by`, `creation_date`) VALUES
	('Administrator', 'Group Administrator', 'setup', NOW());

INSERT INTO `appl_menu_item_access` (`group_name`, `modul_id`, `menu_item_id`, `access_type`, `created_by`, `creation_date`) VALUES
	('Administrator', 1, 1, 'rw', 'setup', NOW()),
	('Administrator', 1, 2, 'rw', 'setup', NOW()),
	('Administrator', 1, 3, 'rw', 'setup', NOW()),
	('Administrator', 1, 4, 'rw', 'setup', NOW()),
	('Administrator', 1, 5, 'rw', 'setup', NOW()),
	('Administrator', 1, 6, 'rw', 'setup', NOW()),
	('Administrator', 1, 7, 'rw', 'setup', NOW()),
	('Administrator', 1, 8, 'rw', 'setup', NOW()),
	('Administrator', 1, 34, 'rw', 'setup', NOW()),
	('Administrator', 1, 35, 'rw', 'setup', NOW()),
	('Administrator', 1, 38, 'rw', 'setup', NOW());

INSERT INTO `id_menu_item_seq` (`id`) VALUES (1000);

INSERT INTO `id_menu_seq` (`id`) VALUES (100);

INSERT INTO `id_modul_seq` (`id`) VALUES (10);

INSERT INTO `id_theme_seq` (`id`) VALUES (10);
