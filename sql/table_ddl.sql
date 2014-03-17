-- 建库
CREATE DATABASE investment;

-- 创建网易财报数据表
DROP TABLE IF EXISTS `t_163_data`;
CREATE TABLE `t_163_data` (
  `symbol`     VARCHAR(11) DEFAULT NULL
  COMMENT '股票代码',
  `date`       DATE DEFAULT NULL
  COMMENT '报表日期',
  `item_key`   INT(11) DEFAULT NULL
  COMMENT '条目类型',
  `item_value` FLOAT DEFAULT NULL
  COMMENT '条目值',
  KEY `symbol` (`symbol`, `date`)
)
  ENGINE =InnoDB
  DEFAULT CHARSET =utf8;

-- 创建网易财报类目表
DROP TABLE IF EXISTS `t_163_item`;
CREATE TABLE `t_163_item` (
  `id`        INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '条目id',
  `group`     VARCHAR(100) DEFAULT NULL
  COMMENT '组',
  `name`      VARCHAR(100) DEFAULT NULL
  COMMENT '条目名字',
  `parents`   INT(11) DEFAULT NULL,
  `show_code` INT(11) DEFAULT '0'
  COMMENT '展示开关',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_group_name` (`group`, `name`)
)
  ENGINE =InnoDB
  DEFAULT CHARSET =utf8;

-- 创建K线数据表
DROP TABLE IF EXISTS `t_k_line`;
CREATE TABLE `t_k_line` (
  `symbol`   VARCHAR(20) NOT NULL DEFAULT ''
  COMMENT '股票代码',
  `date`     DATE        NOT NULL DEFAULT '0000-00-00'
  COMMENT '日期',
  `open`     FLOAT DEFAULT NULL
  COMMENT '开盘价',
  `close`    FLOAT DEFAULT NULL
  COMMENT '收盘价',
  `high`     FLOAT DEFAULT NULL
  COMMENT '最高价',
  `low`      FLOAT DEFAULT NULL
  COMMENT '最低价',
  `chg`      FLOAT DEFAULT NULL
  COMMENT '涨跌价格',
  `percent`  FLOAT DEFAULT NULL
  COMMENT '涨跌率',
  `turnrate` FLOAT DEFAULT NULL
  COMMENT '换手率',
  `ma5`      FLOAT DEFAULT NULL
  COMMENT '5日均价',
  `ma10`     FLOAT DEFAULT NULL
  COMMENT '10日均价',
  `ma20`     FLOAT DEFAULT NULL
  COMMENT '20日均价',
  `ma30`     FLOAT DEFAULT NULL
  COMMENT '30日均价',
  PRIMARY KEY (`symbol`, `date`)
)
  ENGINE =InnoDB
  DEFAULT CHARSET =utf8;

-- 创建股票代码对应表
DROP TABLE IF EXISTS `t_stock`;
CREATE TABLE `t_stock` (
  `symbol`   VARCHAR(11) NOT NULL DEFAULT '',
  `name`     VARCHAR(11) DEFAULT NULL,
  `optional` TINYINT(2)  NOT NULL,
  PRIMARY KEY (`symbol`)
)
  ENGINE =InnoDB
  DEFAULT CHARSET =utf8;