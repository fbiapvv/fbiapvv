/*
 Navicat MySQL Data Transfer

 Source Server         : becotrack
 Source Server Type    : MySQL
 Source Server Version : 100902
 Source Host           : 192.168.31.200:15001
 Source Schema         : becotrack

 Target Server Type    : MySQL
 Target Server Version : 100902
 File Encoding         : 65001

 Date: 29/03/2023 12:30:42
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`) USING BTREE,
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
BEGIN;
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add beacon readers', 7, 'add_beaconreaders');
INSERT INTO `auth_permission` VALUES (26, 'Can change beacon readers', 7, 'change_beaconreaders');
INSERT INTO `auth_permission` VALUES (27, 'Can delete beacon readers', 7, 'delete_beaconreaders');
INSERT INTO `auth_permission` VALUES (28, 'Can view beacon readers', 7, 'view_beaconreaders');
INSERT INTO `auth_permission` VALUES (29, 'Can add beacon tags', 8, 'add_beacontags');
INSERT INTO `auth_permission` VALUES (30, 'Can change beacon tags', 8, 'change_beacontags');
INSERT INTO `auth_permission` VALUES (31, 'Can delete beacon tags', 8, 'delete_beacontags');
INSERT INTO `auth_permission` VALUES (32, 'Can view beacon tags', 8, 'view_beacontags');
INSERT INTO `auth_permission` VALUES (33, 'Can add loaded beacon tags', 9, 'add_loadedbeacontags');
INSERT INTO `auth_permission` VALUES (34, 'Can change loaded beacon tags', 9, 'change_loadedbeacontags');
INSERT INTO `auth_permission` VALUES (35, 'Can delete loaded beacon tags', 9, 'delete_loadedbeacontags');
INSERT INTO `auth_permission` VALUES (36, 'Can view loaded beacon tags', 9, 'view_loadedbeacontags');
INSERT INTO `auth_permission` VALUES (37, 'Can add vw readtags', 10, 'add_vwreadtags');
INSERT INTO `auth_permission` VALUES (38, 'Can change vw readtags', 10, 'change_vwreadtags');
INSERT INTO `auth_permission` VALUES (39, 'Can delete vw readtags', 10, 'delete_vwreadtags');
INSERT INTO `auth_permission` VALUES (40, 'Can view vw readtags', 10, 'view_vwreadtags');
INSERT INTO `auth_permission` VALUES (41, 'Can add vw tagslastrssi', 11, 'add_vwtagslastrssi');
INSERT INTO `auth_permission` VALUES (42, 'Can change vw tagslastrssi', 11, 'change_vwtagslastrssi');
INSERT INTO `auth_permission` VALUES (43, 'Can delete vw tagslastrssi', 11, 'delete_vwtagslastrssi');
INSERT INTO `auth_permission` VALUES (44, 'Can view vw tagslastrssi', 11, 'view_vwtagslastrssi');
COMMIT;

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
BEGIN;
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$320000$Fs8ZRvi7rYcKRgLIza0Hg7$NIqg4JNOdlYiwMF+UKPvLlwfYK1bblvejBClkoWfuBk=', '2022-09-24 16:04:59.756586', 1, 'root', '', '', '', 1, 1, '2022-09-22 13:44:12.678853');
COMMIT;

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`) USING BTREE,
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`) USING BTREE,
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for base_beaconreaders
-- ----------------------------
DROP TABLE IF EXISTS `base_beaconreaders`;
CREATE TABLE `base_beaconreaders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `uid` varchar(200) NOT NULL,
  `last_connected` datetime(6) DEFAULT NULL,
  `created` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `modified` datetime(6) DEFAULT NULL ON UPDATE current_timestamp(6),
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `base_beaconreaders_uid_a071281d_uniq` (`uid`) USING BTREE,
  KEY `base_beacon_uid_261492_idx` (`uid`) USING BTREE,
  KEY `base_beacon_active_f3d1a4_idx` (`active`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of base_beaconreaders
-- ----------------------------
BEGIN;
INSERT INTO `base_beaconreaders` VALUES (15, 'ino-01', 'ino-4ed4de3a50553441', '2022-10-05 14:03:01.689526', '2022-09-28 11:50:04.493387', '2022-10-04 18:25:02.524741', 1);
INSERT INTO `base_beaconreaders` VALUES (16, 'ino-02', 'ino-63a3ae7d50553441', '2022-10-05 14:02:58.686034', '2022-09-29 08:25:37.684988', '2022-10-04 18:25:09.450503', 1);
INSERT INTO `base_beaconreaders` VALUES (17, 'ino-03', 'ino-599ee42350553441', '2022-10-05 14:02:52.103779', '2022-09-29 08:29:22.883691', '2022-10-04 18:25:15.110045', 1);
INSERT INTO `base_beaconreaders` VALUES (18, 'ino-04', 'ino-dfb77d50553441', '2022-10-06 18:15:16.226404', '2022-09-29 15:57:34.486527', '2022-10-04 18:25:21.594400', 1);
INSERT INTO `base_beaconreaders` VALUES (19, 'rpi-01', 'rpi-000000001fac6512', '2023-03-28 16:09:36.966604', '2022-10-04 18:05:23.884202', '2022-10-04 18:24:53.295022', 1);
INSERT INTO `base_beaconreaders` VALUES (20, 'rpi-02', 'rpi-000000008debf1fa', '2023-03-28 15:58:51.907905', '2022-10-04 18:23:51.009739', '2022-10-04 18:24:17.156835', 1);
INSERT INTO `base_beaconreaders` VALUES (21, 'rpi-04', 'rpi-00000000fb88e104', '2023-03-28 15:51:43.856975', '2022-10-04 18:27:13.218331', '2022-10-04 18:27:24.338015', 1);
INSERT INTO `base_beaconreaders` VALUES (22, 'rpi-03', 'rpi-0000000037163288', '2023-03-29 10:05:16.119687', '2022-10-04 18:28:57.213861', '2022-10-04 18:29:08.210179', 1);
INSERT INTO `base_beaconreaders` VALUES (23, 'rpi-05', 'rpi-0000000055d761a0', '2023-03-28 15:56:45.237010', '2023-03-28 15:56:45.240251', '2023-03-28 15:57:03.638092', 1);
INSERT INTO `base_beaconreaders` VALUES (24, 'rpi-06', 'rpi-000000000157e5e4', '2023-03-28 16:05:24.710260', '2023-03-28 16:05:24.712488', '2023-03-28 16:05:36.265691', 1);
INSERT INTO `base_beaconreaders` VALUES (25, 'rpi-07', 'rpi-000000005ed841b6', '2023-03-28 16:08:23.508140', '2023-03-28 16:08:23.510956', '2023-03-28 16:08:35.289202', 1);
INSERT INTO `base_beaconreaders` VALUES (26, 'rpi-08', 'rpi-0000000035c3cc67', '2023-03-29 10:05:15.220678', '2023-03-28 16:46:31.180825', '2023-03-28 16:46:42.017750', 1);
COMMIT;

-- ----------------------------
-- Table structure for base_beacontags
-- ----------------------------
DROP TABLE IF EXISTS `base_beacontags`;
CREATE TABLE `base_beacontags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `uid` varchar(200) NOT NULL,
  `created` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `modified` datetime(6) DEFAULT NULL ON UPDATE current_timestamp(6),
  `active` tinyint(1) NOT NULL,
  `last_rssi` int(11) DEFAULT NULL,
  `last_read` datetime(6) NOT NULL,
  `UUIDs` varchar(200) DEFAULT NULL,
  `local_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `base_beacontags_uid_8adeafb5_uniq` (`uid`) USING BTREE,
  KEY `base_beacon_last_re_bc968e_idx` (`last_read`) USING BTREE,
  KEY `base_beacon_active_66b08a_idx` (`active`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of base_beacontags
-- ----------------------------
BEGIN;
INSERT INTO `base_beacontags` VALUES (1, 'R-01', '7c:2f:80:c4:5e:84', '2023-03-28 15:45:38.098042', '2023-03-29 12:29:27.724568', 1, -38, '2023-03-29 12:29:27.724559', '', '');
INSERT INTO `base_beacontags` VALUES (2, 'G', 'd2:a6:37:7f:3c:a1', '2022-10-06 16:55:20.836059', '2023-03-29 12:29:27.727267', 1, -28, '2023-03-29 12:29:27.727258', '', '');
INSERT INTO `base_beacontags` VALUES (3, 'G', '47:0d:f1:b5:0e:1a', '2023-03-28 15:45:28.143932', '2023-03-28 15:47:43.143489', 1, -38, '2023-03-28 15:47:43.143473', '', '');
INSERT INTO `base_beacontags` VALUES (4, 'B', 'dc:0d:b5:68:47:5d', '2022-10-05 12:15:05.586312', '2023-03-29 12:29:27.673307', 1, -50, '2023-03-29 12:29:27.673299', NULL, '');
COMMIT;

-- ----------------------------
-- Table structure for base_loadedbeacontags
-- ----------------------------
DROP TABLE IF EXISTS `base_loadedbeacontags`;
CREATE TABLE `base_loadedbeacontags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `reader_uid` varchar(200) NOT NULL,
  `tag_uid` varchar(200) NOT NULL,
  `rssi` varchar(200) NOT NULL,
  `read_datetime` datetime(6) NOT NULL,
  `created` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `modified` datetime(6) DEFAULT NULL ON UPDATE current_timestamp(6),
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `base_loaded_reader__82471b_idx` (`reader_uid`) USING BTREE,
  KEY `base_loaded_tag_uid_2b5be2_idx` (`tag_uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of base_loadedbeacontags
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`) USING BTREE,
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
BEGIN;
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (7, 'base', 'beaconreaders');
INSERT INTO `django_content_type` VALUES (8, 'base', 'beacontags');
INSERT INTO `django_content_type` VALUES (9, 'base', 'loadedbeacontags');
INSERT INTO `django_content_type` VALUES (10, 'base', 'vwreadtags');
INSERT INTO `django_content_type` VALUES (11, 'base', 'vwtagslastrssi');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');
COMMIT;

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
BEGIN;
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2022-09-22 13:42:32.039072');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2022-09-22 13:42:32.684495');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2022-09-22 13:42:32.857946');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2022-09-22 13:42:32.907674');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2022-09-22 13:42:32.958014');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2022-09-22 13:42:33.129343');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2022-09-22 13:42:33.206947');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2022-09-22 13:42:33.280523');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2022-09-22 13:42:33.330207');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2022-09-22 13:42:33.406928');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2022-09-22 13:42:33.454496');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2022-09-22 13:42:33.504199');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2022-09-22 13:42:33.580376');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2022-09-22 13:42:33.656368');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2022-09-22 13:42:33.731496');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2022-09-22 13:42:33.843652');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2022-09-22 13:42:33.917923');
INSERT INTO `django_migrations` VALUES (18, 'base', '0001_initial', '2022-09-22 13:42:34.013937');
INSERT INTO `django_migrations` VALUES (19, 'sessions', '0001_initial', '2022-09-22 13:42:34.130647');
INSERT INTO `django_migrations` VALUES (20, 'base', '0002_alter_beaconreaders_name_alter_beaconreaders_uid_and_more', '2022-09-24 17:54:44.976190');
INSERT INTO `django_migrations` VALUES (21, 'base', '0003_loadedbeacontags', '2022-09-25 08:58:55.122954');
INSERT INTO `django_migrations` VALUES (22, 'base', '0004_vwreadtags', '2022-09-25 09:21:06.906096');
INSERT INTO `django_migrations` VALUES (23, 'base', '0005_beaconreaders_active_beacontags_active_and_more', '2022-09-28 12:21:28.736770');
INSERT INTO `django_migrations` VALUES (24, 'base', '0006_beacontags_last_rssi', '2022-09-28 12:23:45.103328');
INSERT INTO `django_migrations` VALUES (25, 'base', '0007_beacontags_last_read', '2022-09-28 12:33:48.698476');
INSERT INTO `django_migrations` VALUES (26, 'base', '0008_alter_beacontags_name', '2022-09-28 12:52:48.454927');
INSERT INTO `django_migrations` VALUES (27, 'base', '0009_alter_beacontags_active', '2022-09-28 13:37:08.714160');
INSERT INTO `django_migrations` VALUES (28, 'base', '0010_alter_beacontags_options_beacontags_uuids_and_more', '2022-09-29 09:24:49.985041');
INSERT INTO `django_migrations` VALUES (29, 'base', '0011_beaconreaders_is_setting_reader_and_more', '2022-10-06 16:29:32.950559');
INSERT INTO `django_migrations` VALUES (30, 'base', '0012_vwtagslastrssi_and_more', '2022-10-06 17:35:51.180421');
INSERT INTO `django_migrations` VALUES (31, 'base', '0013_alter_vwtagslastrssi_options', '2022-10-06 18:20:55.231335');
COMMIT;

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  KEY `django_session_expire_date_a5c62663` (`expire_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of django_session
-- ----------------------------
BEGIN;
INSERT INTO `django_session` VALUES ('j2k2f4hivtocdhhq9718lmzf8fh3mvy3', '.eJxVjDEOwjAMRe-SGUVOE2LCyM4ZKttxSAG1UtNOiLtDpQ6w_vfef5me1qX2a9O5H7I5G2cOvxuTPHTcQL7TeJusTOMyD2w3xe602euU9XnZ3b-DSq1-6-AlAnUFu-iOmNWxwimicvQFPURynCBIcZA9hCgoKQARsqbEWMS8P8-YN8g:1oc7eF:mhyvQEJLd7LZueejAs2icJpcN1uz8MJevlcFj0rmGfg', '2022-10-08 16:04:59.772982');
COMMIT;

-- ----------------------------
-- View structure for vw_readtags
-- ----------------------------
DROP VIEW IF EXISTS `vw_readtags`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `vw_readtags` AS select `base_loadedbeacontags`.`id` AS `id`,`base_loadedbeacontags`.`rssi` AS `rssi`,`base_loadedbeacontags`.`read_datetime` AS `read_datetime`,`base_loadedbeacontags`.`created` AS `created`,`base_loadedbeacontags`.`modified` AS `modified`,ifnull(`base_beaconreaders`.`name`,`base_loadedbeacontags`.`reader_uid`) AS `reader_name`,ifnull(`base_beacontags`.`name`,`base_loadedbeacontags`.`tag_uid`) AS `tag_name`,`base_beacontags`.`active` AS `active` from ((`base_loadedbeacontags` join `base_beaconreaders` on(`base_beaconreaders`.`uid` = `base_loadedbeacontags`.`reader_uid`)) join `base_beacontags` on(`base_loadedbeacontags`.`tag_uid` = `base_beacontags`.`uid`)) where `base_beacontags`.`active` = 1 order by `base_loadedbeacontags`.`id` desc limit 10000;

-- ----------------------------
-- View structure for vw_tagslastrssi
-- ----------------------------
DROP VIEW IF EXISTS `vw_tagslastrssi`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `vw_tagslastrssi` AS select `base_beacontags`.`id` AS `id`,`base_beacontags`.`name` AS `name`,`base_beacontags`.`uid` AS `uid`,`base_beacontags`.`created` AS `created`,`base_beacontags`.`modified` AS `modified`,`base_beacontags`.`active` AS `active`,`base_beacontags`.`UUIDs` AS `UUIDs`,`base_beacontags`.`local_name` AS `local_name`,`base_beacontags`.`last_rssi` AS `last_rssi`,`base_beacontags`.`last_read` AS `last_read` from `base_beacontags` order by `base_beacontags`.`last_rssi` desc;

-- ----------------------------
-- Triggers structure for table base_loadedbeacontags
-- ----------------------------
DROP TRIGGER IF EXISTS `is_in_active`;
delimiter ;;
CREATE TRIGGER `is_in_active` BEFORE INSERT ON `base_loadedbeacontags` FOR EACH ROW BEGIN
IF
		NEW.tag_uid NOT IN ( SELECT uid FROM base_beacontags WHERE active = 1 ) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TAG ID NOT IN';
END IF;


END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
