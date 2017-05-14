-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET FOREIGN_KEY_CHECKS = 0;

-- ---
-- Table 'client'
--
-- ---

DROP TABLE IF EXISTS `client`;

CREATE TABLE `client` (
  `id`                  INT(11)      NOT NULL AUTO_INCREMENT,
  `random_id`           VARCHAR(255) NOT NULL,
  `redirect_uris`       MEDIUMTEXT   NOT NULL
  COMMENT '(DC2Type:array)',
  `secret`              VARCHAR(255) NOT NULL,
  `allowed_grant_types` MEDIUMTEXT   NOT NULL
  COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'fos_user'
--
-- ---

DROP TABLE IF EXISTS `fos_user`;

CREATE TABLE `fos_user` (
  `id`                    INT(11)      NOT NULL AUTO_INCREMENT,
  `username`              VARCHAR(255) NOT NULL,
  `username_canonical`    VARCHAR(255) NOT NULL,
  `email`                 VARCHAR(255) NOT NULL,
  `email_canonical`       VARCHAR(255) NOT NULL,
  `enabled`               TINYINT(1)   NOT NULL,
  `salt`                  VARCHAR(255) NOT NULL,
  `password`              VARCHAR(255) NOT NULL,
  `last_login`            DATETIME     NULL     DEFAULT NULL,
  `locked`                TINYINT(1)   NOT NULL,
  `expired`               TINYINT(1)   NOT NULL,
  `expires_at`            DATETIME     NULL     DEFAULT NULL,
  `confirmation_token`    VARCHAR(255) NULL     DEFAULT NULL,
  `password_requested_at` DATETIME     NULL     DEFAULT NULL,
  `roles`                 MEDIUMTEXT   NOT NULL
  COMMENT '(DC2Type:array)',
  `credentials_expired`   TINYINT(1)   NOT NULL,
  `credentials_expire_at` DATETIME     NULL     DEFAULT NULL,
  `realname`              VARCHAR(255) NULL     DEFAULT NULL,
  UNIQUE KEY (`email_canonical`),
  PRIMARY KEY (`id`),
  UNIQUE KEY (`username_canonical`)
);

-- ---
-- Table 'access_token'
--
-- ---

DROP TABLE IF EXISTS `access_token`;

CREATE TABLE `access_token` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `client_id`  INT(11)      NOT NULL,
  `user_id`    INT(11)      NULL     DEFAULT NULL,
  `token`      VARCHAR(255) NOT NULL,
  `expires_at` INT(11)      NULL     DEFAULT NULL,
  `scope`      VARCHAR(255) NULL     DEFAULT NULL,
  UNIQUE KEY (`token`),
  KEY (`client_id`),
  PRIMARY KEY (`id`),
  KEY (`user_id`)
);

-- ---
-- Table 'auth_code'
--
-- ---

DROP TABLE IF EXISTS `auth_code`;

CREATE TABLE `auth_code` (
  `id`           INT(11)      NOT NULL AUTO_INCREMENT,
  `client_id`    INT(11)      NOT NULL,
  `user_id`      INT(11)      NULL     DEFAULT NULL,
  `token`        VARCHAR(255) NOT NULL,
  `redirect_uri` MEDIUMTEXT   NOT NULL,
  `expires_at`   INT(11)      NULL     DEFAULT NULL,
  `scope`        VARCHAR(255) NULL     DEFAULT NULL,
  UNIQUE KEY (`token`),
  KEY (`client_id`),
  PRIMARY KEY (`id`),
  KEY (`user_id`)
);

-- ---
-- Table 'refresh_token'
--
-- ---

DROP TABLE IF EXISTS `refresh_token`;

CREATE TABLE `refresh_token` (
  `id`         INT(11)      NOT NULL AUTO_INCREMENT,
  `client_id`  INT(11)      NOT NULL,
  `user_id`    INT(11)      NULL     DEFAULT NULL,
  `token`      VARCHAR(255) NOT NULL,
  `expires_at` INT(11)      NULL     DEFAULT NULL,
  `scope`      VARCHAR(255) NULL     DEFAULT NULL,
  UNIQUE KEY (`token`),
  KEY (`client_id`),
  PRIMARY KEY (`id`),
  KEY (`user_id`)
);

-- ---
-- Foreign Keys
-- ---

SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE `access_token`
  ADD FOREIGN KEY (client_id) REFERENCES `client` (`id`)
  ON UPDATE CASCADE
  ON DELETE CASCADE;
ALTER TABLE `access_token`
  ADD FOREIGN KEY (user_id) REFERENCES `fos_user` (`id`)
  ON UPDATE CASCADE
  ON DELETE SET NULL;
ALTER TABLE `auth_code`
  ADD FOREIGN KEY (client_id) REFERENCES `client` (`id`)
  ON UPDATE CASCADE
  ON DELETE CASCADE;
ALTER TABLE `auth_code`
  ADD FOREIGN KEY (user_id) REFERENCES `fos_user` (`id`)
  ON UPDATE CASCADE
  ON DELETE SET NULL;
ALTER TABLE `refresh_token`
  ADD FOREIGN KEY (client_id) REFERENCES `client` (`id`)
  ON UPDATE CASCADE
  ON DELETE CASCADE;
ALTER TABLE `refresh_token`
  ADD FOREIGN KEY (user_id) REFERENCES `fos_user` (`id`)
  ON UPDATE CASCADE
  ON DELETE SET NULL;

-- ---
-- Table Properties
-- ---

ALTER TABLE `client`
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_bin;
ALTER TABLE `fos_user`
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_bin;
ALTER TABLE `access_token`
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_bin;
ALTER TABLE `auth_code`
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_bin;
ALTER TABLE `refresh_token`
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `client` (`id`,`random_id`,`redirect_uris`,`secret`,`allowed_grant_types`) VALUES
-- ('','','','','');
-- INSERT INTO `fos_user` (`id`,`username`,`username_canonical`,`email`,`email_canonical`,`enabled`,`salt`,`password`,`last_login`,`locked`,`expired`,`expires_at`,`confirmation_token`,`password_requested_at`,`roles`,`credentials_expired`,`credentials_expire_at`,`realname`) VALUES
-- ('','','','','','','','','','','','','','','','','','');
-- INSERT INTO `access_token` (`id`,`client_id`,`user_id`,`token`,`expires_at`,`scope`) VALUES
-- ('','','','','','');
-- INSERT INTO `auth_code` (`id`,`client_id`,`user_id`,`token`,`redirect_uri`,`expires_at`,`scope`) VALUES
-- ('','','','','','','');
-- INSERT INTO `refresh_token` (`id`,`client_id`,`user_id`,`token`,`expires_at`,`scope`) VALUES
-- ('','','','','','');