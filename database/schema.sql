-- Skema tabel inti LIVED Framework (diambil dari aplikasi contoh LIVED V2).
-- Dipasang oleh `composer install-db` / `php bin/install-db.php`; tabel modul aplikasi ditambahkan sendiri.
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SESSION sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE IF NOT EXISTS `appl_group` (
  `group_name` varchar(30) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_group_members` (
  `group_name` varchar(30) NOT NULL,
  `login_name` varchar(30) NOT NULL,
  `default_login` char(1) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`group_name`,`login_name`),
  KEY `login_name` (`login_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_group_privileges` (
  `group_name` varchar(30) NOT NULL,
  `modul_id` int NOT NULL,
  `seq` int DEFAULT NULL,
  `access_type` varchar(5) NOT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`group_name`,`modul_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_klasf_wilayah` (
  `kode_klasf` varchar(10) NOT NULL,
  `nama_klasf` varchar(30) NOT NULL,
  `level` int NOT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`kode_klasf`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_kode_wilayah` (
  `kode_wilayah` varchar(30) NOT NULL,
  `nama_wilayah` varchar(50) NOT NULL,
  `klasifikasi` varchar(10) NOT NULL,
  `kode_induk` varchar(10) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`kode_wilayah`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_menu` (
  `id_menu` int NOT NULL AUTO_INCREMENT,
  `menu_name` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_menu`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_menu_item` (
  `id_menu_item` int NOT NULL AUTO_INCREMENT,
  `menu` int NOT NULL,
  `seq` int NOT NULL,
  `prompt` varchar(30) NOT NULL,
  `url` varchar(200) DEFAULT NULL,
  `modul_id` int DEFAULT NULL,
  `class_name` varchar(50) DEFAULT NULL,
  `document` varchar(200) DEFAULT NULL,
  `parameter` varchar(100) DEFAULT NULL,
  `submenu` int DEFAULT NULL,
  `target` varchar(25) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_menu_item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_menu_item_access` (
  `group_name` varchar(30) NOT NULL,
  `modul_id` int NOT NULL,
  `menu_item_id` int NOT NULL,
  `access_type` varchar(5) NOT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`group_name`,`modul_id`,`menu_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_modul` (
  `id_modul` int NOT NULL AUTO_INCREMENT,
  `kode_modul` varchar(20) NOT NULL,
  `modul_name` varchar(20) NOT NULL,
  `modul_path` varchar(50) DEFAULT NULL,
  `menu` int DEFAULT NULL,
  `db_driver` varchar(30) NOT NULL,
  `db_host` varchar(30) NOT NULL,
  `db_user` varchar(30) NOT NULL,
  `db_pswd` varchar(50) DEFAULT NULL,
  `db_name` varchar(60) NOT NULL,
  `db_options` varchar(100) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_modul`),
  UNIQUE KEY `kode_modul` (`kode_modul`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_themes` (
  `id_theme` int NOT NULL AUTO_INCREMENT,
  `theme_name` varchar(30) NOT NULL,
  `theme_path` varchar(50) NOT NULL,
  `author` varchar(30) DEFAULT NULL,
  `preview_image` varchar(30) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id_theme`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_unit_kerja` (
  `kode_unit` varchar(30) NOT NULL,
  `nama_unit` varchar(200) NOT NULL,
  `singkatan` varchar(30) DEFAULT NULL,
  `kode_induk` varchar(30) DEFAULT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`kode_unit`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_user` (
  `login_name` varchar(30) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(40) DEFAULT NULL,
  `NIP` varchar(18) DEFAULT NULL,
  `nik` varchar(20) DEFAULT NULL,
  `unit_kerja` varchar(30) DEFAULT NULL,
  `wilayah` varchar(10) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `hp` varchar(30) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `disabled` char(1) DEFAULT '0',
  `theme` varchar(30) NOT NULL,
  `created_by` varchar(20) NOT NULL DEFAULT '',
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_updated_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT '0000-00-00 00:00:00',
  `last_login` datetime DEFAULT NULL,
  `last_password_changed` datetime DEFAULT NULL,
  PRIMARY KEY (`login_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `appl_user_log` (
  `login_name` varchar(30) NOT NULL,
  `session_id` varchar(200) NOT NULL DEFAULT '',
  `ip_client` varchar(45) DEFAULT NULL,
  `login_error` varchar(20) DEFAULT NULL,
  `login_time` datetime DEFAULT NULL,
  `logout_time` datetime DEFAULT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `id_menu_item_seq` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `id_menu_seq` (
  `id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `id_modul_seq` (
  `id` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `id_theme_seq` (
  `id` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

SET FOREIGN_KEY_CHECKS = 1;
