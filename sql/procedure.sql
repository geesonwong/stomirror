-- TOOGLE_STOCK 函数，用来开关自选股
-- eg CALL TOOGLE_STOCK('600690');
DROP PROCEDURE IF EXISTS TOOGLE_STOCK;
DELIMITER $$
CREATE PROCEDURE TOOGLE_STOCK(
  IN joozy VARCHAR(20),
  IN is_on TINYINT
)
  BEGIN
    SET @qq = concat('UPDATE T_STOCK SET OPTIONAL = ', is_on, ' WHERE SYMBOL LIKE \'%', joozy, '%\' OR NAME LIKE \'%',
                     joozy,
                     '%\'');
    SELECT
      @qq;
    PREPARE stmt FROM @qq;
    EXECUTE stmt;
  END;
$$


-- REPORT 函数，用来看报表
-- eg CALL REPORT('2013-09-30');
DROP PROCEDURE IF EXISTS REPORT;
DELIMITER $$
CREATE PROCEDURE REPORT(
  IN `date` VARCHAR(20)
)
  BEGIN
    DECLARE ee TEXT;
    DECLARE done INT;
    DECLARE times INT;
    DECLARE item_id INT(11);
    DECLARE item_name VARCHAR(50);
    DECLARE cur CURSOR FOR SELECT
                             `ID`   AS `KEY`,
                             `NAME` AS VALUE
                           FROM T_163_ITEM
                           WHERE SHOW_CODE & 1 = 1;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
    SET times = 0;
    SET ee = '';

    OPEN cur;
    REPEAT
      IF times <> 0
      THEN
        SET ee = CONCAT(ee, 'SUM(IF(ITEM_KEY = \'', item_id, '\',ITEM_VALUE,0)) AS \'', item_name, '\',');
      END IF;
      SET times = times + 1;
      FETCH cur
      INTO item_id, item_name;
    UNTIL done END REPEAT;
    SET @qq = CONCAT('SELECT SYMBOL AS 股票代码, `NAME` AS 股票名称,', LEFT(ee, CHAR_LENGTH(ee) - 1),
                     ' FROM (SELECT T_163_DATA.SYMBOL,T_STOCK.`NAME`,`DATE`,ITEM_KEY,ITEM_VALUE FROM T_163_DATA LEFT JOIN T_STOCK ON T_163_DATA.SYMBOL = T_STOCK.SYMBOL WHERE T_STOCK.OPTIONAL = 1) A WHERE `DATE` = \'',
                     `date`, '\' GROUP BY SYMBOL');
    PREPARE stmt FROM @qq;
    EXECUTE stmt;
  END;
$$

CALL `REPORT`('2013-09-30')