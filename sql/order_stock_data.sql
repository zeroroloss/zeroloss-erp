-- ============================================================
-- 키오스크 주문 대량 더미 생성
-- 자연스러운 매출 패턴 + 신메뉴 효과 + 08~23시 영업 반영
-- 기간: 2026-01-01 ~ 2026-05-07
-- 대상: 본사 제외 전체 지점
-- 생성: orders -> order_menu -> order_option
-- ============================================================

SET @start_date = '2026-03-10';

SET @end_datetime = DATE_SUB(
    DATE_FORMAT(NOW(), '%Y-%m-%d %H:00:00'),
    INTERVAL 1 SECOND
);

SET @end_date = DATE(@end_datetime);

-- 재생성 시 사용
-- DELETE oo FROM order_option oo
-- JOIN order_menu om ON om.order_menu_id = oo.order_menu_id
-- JOIN orders o ON o.order_id = om.order_id
-- WHERE o.order_date BETWEEN @start_date AND @end_date;

-- DELETE om FROM order_menu om
-- JOIN orders o ON o.order_id = om.order_id
-- WHERE o.order_date BETWEEN @start_date AND @end_date;

-- DELETE FROM orders
-- WHERE order_date BETWEEN @start_date AND @end_date;


-- ============================================================
-- 1. 숫자 테이블
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_digits;
CREATE TEMPORARY TABLE tmp_digits (n INT PRIMARY KEY);

INSERT INTO tmp_digits (n) VALUES
(0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

DROP TEMPORARY TABLE IF EXISTS tmp_seq;
CREATE TEMPORARY TABLE tmp_seq (n INT PRIMARY KEY);

INSERT INTO tmp_seq (n)
SELECT a.n + b.n * 10 + c.n * 100 + 1 AS n
FROM tmp_digits a
CROSS JOIN tmp_digits b
CROSS JOIN tmp_digits c
WHERE a.n + b.n * 10 + c.n * 100 + 1 <= 700;


-- ============================================================
-- 2. 날짜 테이블
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_dates;
CREATE TEMPORARY TABLE tmp_dates (
    work_date DATE PRIMARY KEY,
    date_factor INT,
    event_factor INT,
    week_no INT
);

INSERT INTO tmp_dates (work_date, date_factor, event_factor, week_no)
SELECT
    base.work_date,
    MOD(
        DAYOFYEAR(base.work_date) * 37
        + DAYOFMONTH(base.work_date) * 19
        + MONTH(base.work_date) * 23,
        100
    ) AS date_factor,
    CASE
        WHEN base.work_date BETWEEN '2026-03-12' AND '2026-03-20' THEN 45
        WHEN base.work_date BETWEEN '2026-03-21' AND '2026-03-31' THEN 25
        WHEN base.work_date BETWEEN '2026-04-10' AND '2026-04-18' THEN 40
        WHEN base.work_date BETWEEN '2026-04-19' AND '2026-04-30' THEN 20
        WHEN DAYOFMONTH(base.work_date) IN (5, 15, 25) THEN 30
        WHEN DAYOFMONTH(base.work_date) IN (10, 20) THEN -18
        WHEN MOD(DAYOFYEAR(base.work_date), 17) = 0 THEN 35
        WHEN MOD(DAYOFYEAR(base.work_date), 13) = 0 THEN -22
        ELSE 0
    END AS event_factor,
    CASE
        WHEN DAYOFMONTH(base.work_date) BETWEEN 1 AND 7 THEN 1
        WHEN DAYOFMONTH(base.work_date) BETWEEN 8 AND 14 THEN 2
        WHEN DAYOFMONTH(base.work_date) BETWEEN 15 AND 21 THEN 3
        ELSE 4
    END AS week_no
FROM (
    SELECT DATE(@start_date) + INTERVAL (a.n + b.n * 10 + c.n * 100) DAY AS work_date
    FROM tmp_digits a
    CROSS JOIN tmp_digits b
    
    CROSS JOIN tmp_digits c
    WHERE DATE(@start_date) + INTERVAL (a.n + b.n * 10 + c.n * 100) DAY <= @end_date
) base;


-- ============================================================
-- 2-1. 영업 시간대 테이블
-- 영업시간: 08:00 ~ 23:00
-- 마지막 주문은 22시대까지 생성
-- ============================================================

-- ============================================================
-- 2-1. 영업 시간대 테이블
-- 영업시간: 08:00 ~ 23:00
-- 평일 / 토요일 / 일요일 시간대 분포 분리
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_time_pick;

CREATE TEMPORARY TABLE tmp_time_pick (
    day_type VARCHAR(10) NOT NULL,
    pick_no INT NOT NULL,
    hour_no INT NOT NULL,
    PRIMARY KEY (day_type, pick_no)
);

INSERT INTO tmp_time_pick (day_type, pick_no, hour_no) VALUES

-- ============================================================
-- WEEKDAY
-- 평일: 출근 전 소량 + 점심 피크 + 퇴근/저녁 피크
-- ============================================================

('WEEKDAY',0,8),('WEEKDAY',1,8),('WEEKDAY',2,8),
('WEEKDAY',3,9),('WEEKDAY',4,9),('WEEKDAY',5,9),
('WEEKDAY',6,10),('WEEKDAY',7,10),

('WEEKDAY',8,11),('WEEKDAY',9,11),('WEEKDAY',10,11),('WEEKDAY',11,11),('WEEKDAY',12,11),('WEEKDAY',13,11),
('WEEKDAY',14,12),('WEEKDAY',15,12),('WEEKDAY',16,12),('WEEKDAY',17,12),('WEEKDAY',18,12),('WEEKDAY',19,12),('WEEKDAY',20,12),('WEEKDAY',21,12),
('WEEKDAY',22,13),('WEEKDAY',23,13),('WEEKDAY',24,13),('WEEKDAY',25,13),('WEEKDAY',26,13),

('WEEKDAY',27,14),('WEEKDAY',28,14),('WEEKDAY',29,14),
('WEEKDAY',30,15),('WEEKDAY',31,15),
('WEEKDAY',32,16),('WEEKDAY',33,16),

('WEEKDAY',34,17),('WEEKDAY',35,17),('WEEKDAY',36,17),('WEEKDAY',37,17),
('WEEKDAY',38,18),('WEEKDAY',39,18),('WEEKDAY',40,18),('WEEKDAY',41,18),('WEEKDAY',42,18),
('WEEKDAY',43,19),('WEEKDAY',44,19),('WEEKDAY',45,19),('WEEKDAY',46,19),

('WEEKDAY',47,20),('WEEKDAY',48,20),('WEEKDAY',49,20),
('WEEKDAY',50,21),('WEEKDAY',51,21),
('WEEKDAY',52,22),

-- 평일 잔여 분산
('WEEKDAY',53,11),('WEEKDAY',54,12),('WEEKDAY',55,12),('WEEKDAY',56,13),
('WEEKDAY',57,17),('WEEKDAY',58,18),('WEEKDAY',59,19),
('WEEKDAY',60,8),('WEEKDAY',61,9),('WEEKDAY',62,10),
('WEEKDAY',63,14),('WEEKDAY',64,15),('WEEKDAY',65,16),
('WEEKDAY',66,20),('WEEKDAY',67,21),('WEEKDAY',68,22),
('WEEKDAY',69,11),('WEEKDAY',70,12),('WEEKDAY',71,13),
('WEEKDAY',72,17),('WEEKDAY',73,18),('WEEKDAY',74,19),
('WEEKDAY',75,12),('WEEKDAY',76,12),('WEEKDAY',77,13),
('WEEKDAY',78,18),('WEEKDAY',79,18),('WEEKDAY',80,19),
('WEEKDAY',81,14),('WEEKDAY',82,15),('WEEKDAY',83,16),
('WEEKDAY',84,8),('WEEKDAY',85,9),('WEEKDAY',86,10),
('WEEKDAY',87,20),('WEEKDAY',88,21),('WEEKDAY',89,22),
('WEEKDAY',90,11),('WEEKDAY',91,12),('WEEKDAY',92,13),
('WEEKDAY',93,17),('WEEKDAY',94,18),('WEEKDAY',95,19),
('WEEKDAY',96,12),('WEEKDAY',97,13),('WEEKDAY',98,18),('WEEKDAY',99,19),


-- ============================================================
-- SATURDAY
-- 토요일: 점심부터 저녁까지 넓게 분산, 밤 매출도 어느 정도 있음
-- ============================================================

('SAT',0,9),('SAT',1,10),('SAT',2,10),
('SAT',3,11),('SAT',4,11),('SAT',5,11),('SAT',6,11),('SAT',7,11),
('SAT',8,12),('SAT',9,12),('SAT',10,12),('SAT',11,12),('SAT',12,12),('SAT',13,12),
('SAT',14,13),('SAT',15,13),('SAT',16,13),('SAT',17,13),('SAT',18,13),('SAT',19,13),
('SAT',20,14),('SAT',21,14),('SAT',22,14),('SAT',23,14),('SAT',24,14),
('SAT',25,15),('SAT',26,15),('SAT',27,15),('SAT',28,15),('SAT',29,15),
('SAT',30,16),('SAT',31,16),('SAT',32,16),('SAT',33,16),('SAT',34,16),
('SAT',35,17),('SAT',36,17),('SAT',37,17),('SAT',38,17),('SAT',39,17),
('SAT',40,18),('SAT',41,18),('SAT',42,18),('SAT',43,18),('SAT',44,18),('SAT',45,18),
('SAT',46,19),('SAT',47,19),('SAT',48,19),('SAT',49,19),('SAT',50,19),
('SAT',51,20),('SAT',52,20),('SAT',53,20),('SAT',54,20),
('SAT',55,21),('SAT',56,21),('SAT',57,21),
('SAT',58,22),('SAT',59,22),

-- 토요일 잔여 분산
('SAT',60,11),('SAT',61,12),('SAT',62,13),('SAT',63,14),('SAT',64,15),
('SAT',65,16),('SAT',66,17),('SAT',67,18),('SAT',68,19),('SAT',69,20),
('SAT',70,12),('SAT',71,13),('SAT',72,14),('SAT',73,15),('SAT',74,16),
('SAT',75,17),('SAT',76,18),('SAT',77,19),('SAT',78,20),('SAT',79,21),
('SAT',80,10),('SAT',81,11),('SAT',82,12),('SAT',83,13),('SAT',84,14),
('SAT',85,15),('SAT',86,16),('SAT',87,17),('SAT',88,18),('SAT',89,19),
('SAT',90,20),('SAT',91,21),('SAT',92,22),
('SAT',93,12),('SAT',94,13),('SAT',95,14),
('SAT',96,17),('SAT',97,18),('SAT',98,19),('SAT',99,20),


-- ============================================================
-- SUNDAY
-- 일요일: 늦은 점심~이른 저녁 중심, 토요일보다 야간 약함
-- ============================================================

('SUN',0,9),('SUN',1,10),('SUN',2,10),
('SUN',3,11),('SUN',4,11),('SUN',5,11),('SUN',6,11),
('SUN',7,12),('SUN',8,12),('SUN',9,12),('SUN',10,12),('SUN',11,12),('SUN',12,12),
('SUN',13,13),('SUN',14,13),('SUN',15,13),('SUN',16,13),('SUN',17,13),('SUN',18,13),
('SUN',19,14),('SUN',20,14),('SUN',21,14),('SUN',22,14),('SUN',23,14),('SUN',24,14),
('SUN',25,15),('SUN',26,15),('SUN',27,15),('SUN',28,15),('SUN',29,15),
('SUN',30,16),('SUN',31,16),('SUN',32,16),('SUN',33,16),('SUN',34,16),
('SUN',35,17),('SUN',36,17),('SUN',37,17),('SUN',38,17),('SUN',39,17),
('SUN',40,18),('SUN',41,18),('SUN',42,18),('SUN',43,18),
('SUN',44,19),('SUN',45,19),('SUN',46,19),
('SUN',47,20),('SUN',48,20),
('SUN',49,21),
('SUN',50,22),

-- 일요일 잔여 분산
('SUN',51,11),('SUN',52,12),('SUN',53,13),('SUN',54,14),('SUN',55,15),
('SUN',56,16),('SUN',57,17),('SUN',58,18),('SUN',59,19),
('SUN',60,12),('SUN',61,13),('SUN',62,14),('SUN',63,15),('SUN',64,16),
('SUN',65,17),('SUN',66,18),
('SUN',67,10),('SUN',68,11),('SUN',69,12),
('SUN',70,13),('SUN',71,14),('SUN',72,15),
('SUN',73,16),('SUN',74,17),('SUN',75,18),
('SUN',76,19),('SUN',77,20),
('SUN',78,12),('SUN',79,13),('SUN',80,14),('SUN',81,15),
('SUN',82,16),('SUN',83,17),('SUN',84,18),
('SUN',85,11),('SUN',86,12),('SUN',87,13),
('SUN',88,14),('SUN',89,15),('SUN',90,16),
('SUN',91,17),('SUN',92,18),('SUN',93,19),
('SUN',94,12),('SUN',95,13),('SUN',96,14),
('SUN',97,15),('SUN',98,16),('SUN',99,18);

-- ============================================================
-- 3. 메뉴 선택 풀
-- 전체 메뉴 등장 + 인기 메뉴 약한 가중
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_recipe_pick;
CREATE TEMPORARY TABLE tmp_recipe_pick (
    pick_no INT PRIMARY KEY,
    recipe_code VARCHAR(50) NOT NULL
);

INSERT INTO tmp_recipe_pick (pick_no, recipe_code) VALUES
(0,'1001'),(1,'1002'),(2,'1003'),(3,'1004'),(4,'1005'),
(5,'1006'),(6,'1007'),(7,'1008'),(8,'1009'),(9,'1010'),
(10,'1011'),(11,'1012'),(12,'1013'),(13,'1014'),(14,'1015'),
(15,'1016'),(16,'1017'),(17,'1018'),(18,'1019'),(19,'1020'),
(20,'1021'),(21,'1022'),(22,'1023'),(23,'1024'),(24,'1025'),
(25,'1026'),(26,'1027'),

(27,'1002'),(28,'1007'),(29,'1010'),(30,'1012'),(31,'1015'),
(32,'1001'),(33,'1006'),(34,'1018'),(35,'1020'),(36,'1007'),

(37,'2001'),(38,'2002'),(39,'2003'),(40,'2004'),(41,'2005'),
(42,'2006'),(43,'2007'),(44,'2008'),(45,'2009'),(46,'2010'),
(47,'2011'),(48,'2012'),(49,'2013'),(50,'2014'),(51,'2015'),
(52,'2016'),(53,'2017'),(54,'2018'),(55,'2019'),(56,'2020'),
(57,'2021'),(58,'2022'),(59,'2023'),(60,'2024'),(61,'2025'),
(62,'2026'),(63,'2027'),

(64,'2001'),(65,'2003'),(66,'2009'),(67,'2015'),

(68,'3001'),(69,'3002'),(70,'3003'),(71,'3004'),(72,'3005'),
(73,'3006'),(74,'3007'),(75,'3008'),(76,'3009'),(77,'3010'),
(78,'3011'),(79,'3012'),(80,'3013'),(81,'3014'),(82,'3015'),
(83,'3001'),(84,'3009'),(85,'3010'),

(86,'4001'),(87,'4002'),(88,'4003'),(89,'4004'),(90,'4005'),
(91,'4006'),

(92,'1002'),(93,'1007'),(94,'1010'),(95,'1012'),
(96,'2001'),(97,'2003'),(98,'3001'),(99,'4005');


-- ============================================================
-- 4. 주문 임시 테이블
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_orders;
CREATE TEMPORARY TABLE tmp_orders (
    order_id VARCHAR(36) PRIMARY KEY,
    branch_code INT,
    kiosk_id INT,
    order_type VARCHAR(20),
    total_amount INT,
    status VARCHAR(20),
    order_date DATE,
    created_at TIME,
    item_count INT,
    seed_no INT
);


-- ============================================================
-- 5. tmp_orders 생성
-- 08:00~23:00 전체 영업시간 반영
-- ============================================================

INSERT INTO tmp_orders
(order_id, branch_code, kiosk_id, order_type, total_amount, status, order_date, created_at, item_count, seed_no)
SELECT
    UUID(),
    x.branch_code,
    x.kiosk_id,
    x.order_type,
    0 AS total_amount,
    x.status,
    x.work_date AS order_date,
    x.created_at,
    x.item_count,
    x.seed_no
FROM (
    SELECT
        b.branch_code,
        d.work_date,
        s.n,

        CASE
            WHEN MOD(s.n, 2) = 0 THEN
                COALESCE((SELECT MAX(k.kiosk_id) FROM kiosk k WHERE k.branch_code = b.branch_code), 1)
            ELSE
                COALESCE((SELECT MIN(k.kiosk_id) FROM kiosk k WHERE k.branch_code = b.branch_code), 1)
        END AS kiosk_id,

        CASE
            WHEN MOD(b.branch_code * 7 + DAYOFYEAR(d.work_date) * 11 + s.n * 13, 100) < 42 THEN 'TOGO'
            ELSE 'HERE'
        END AS order_type,

        CASE
            WHEN TIMESTAMP(
        				d.work_date,
        				MAKETIME(tp.hour_no, MOD(s.n * 13 + d.date_factor, 60), 0)
     				 ) > @end_datetime
                THEN 'PREPARING'
            WHEN MOD(b.branch_code * 3 + s.n * 5 + DAYOFYEAR(d.work_date), 220) = 0 THEN 'CANCEL'
            WHEN MOD(b.branch_code * 5 + s.n * 7 + DAYOFYEAR(d.work_date), 280) = 0 THEN 'FAIL'
            WHEN MOD(b.branch_code + s.n + DAYOFYEAR(d.work_date), 13) = 0 THEN 'PREPARING'
            ELSE 'PAID'
        END AS status,

        MAKETIME(tp.hour_no, MOD(s.n * 13 + d.date_factor, 60), 0) AS created_at,

        CASE
            WHEN MOD(b.branch_code * 5 + s.n * 7 + d.date_factor, 100) < 55 THEN 1
            WHEN MOD(b.branch_code * 5 + s.n * 7 + d.date_factor, 100) < 86 THEN 2
            WHEN MOD(b.branch_code * 5 + s.n * 7 + d.date_factor, 100) < 97 THEN 3
            ELSE 4
        END AS item_count,

        b.branch_code * 100000 + DAYOFYEAR(d.work_date) * 1000 + s.n AS seed_no

    FROM branch b
    CROSS JOIN tmp_dates d
    CROSS JOIN tmp_seq s
    JOIN tmp_time_pick tp
    ON tp.day_type =
        CASE
            WHEN DAYOFWEEK(d.work_date) = 7 THEN 'SAT'
            WHEN DAYOFWEEK(d.work_date) = 1 THEN 'SUN'
            ELSE 'WEEKDAY'
        END
   AND tp.pick_no = MOD(b.branch_code * 11 + d.date_factor * 7 + s.n * 17, 100)

    WHERE b.branch_code <> 1
      AND b.status = 'ACTIVE'
      AND TIMESTAMP(
        d.work_date,
        MAKETIME(tp.hour_no, MOD(s.n * 13 + d.date_factor, 60), 0)
    	) <= @end_datetime
      AND s.n <= GREATEST(
    20,
    CASE
        -- ====================================================
        -- 서울 핵심 상권 지점: 주문량 많음
        -- 강남 / 잠실 / 홍대 / 명동 / 여의도
        -- ====================================================
        WHEN b.branch_code IN (2001, 2002, 2004, 2009, 2011) THEN
            CASE d.week_no
                WHEN 1 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 320
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 275
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 260
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 165
                        ELSE 230
                    END
                WHEN 2 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 340
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 285
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 280
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 160
                        ELSE 235
                    END
                WHEN 3 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 325
                        WHEN DAYOFWEEK(d.work_date) = 5 THEN 285
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 300
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 290
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 155
                        ELSE 245
                    END
                ELSE
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 315
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 320
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 270
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 170
                        ELSE 250
                    END
            END
            + MOD(b.branch_code * 3 + d.date_factor * 5 + DAYOFMONTH(d.work_date) * 17, 90)
            + d.event_factor

        -- ====================================================
        -- 서울 중간 상권 지점: 주문량 중간
        -- 사당 / 합정 / 신촌 / 종로 / 서울역 / 건대 / 왕십리 / 서울숲
        -- ====================================================
        WHEN b.branch_code IN (
            2003, 2005, 2006, 2008, 2010, 2013, 2014, 2015
        ) THEN
            CASE d.week_no
                WHEN 1 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 155
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 135
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 130
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 78
                        ELSE 112
                    END
                WHEN 2 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 168
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 148
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 140
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 75
                        ELSE 116
                    END
                WHEN 3 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 158
                        WHEN DAYOFWEEK(d.work_date) = 5 THEN 138
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 150
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 145
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 72
                        ELSE 118
                    END
                ELSE
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 155
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 160
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 138
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 82
                        ELSE 122
                    END
            END
            + MOD(b.branch_code * 5 + d.date_factor * 7 + DAYOFMONTH(d.work_date) * 13, 58)
            + ROUND(d.event_factor * 0.6)

        -- ====================================================
        -- 일반 지점: 주문량 적당
        -- 마곡 / 구로디지털 / 노원 등
        -- ====================================================
        ELSE
            CASE d.week_no
                WHEN 1 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 90
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 82
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 78
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 40
                        ELSE 58
                    END
                WHEN 2 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 100
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 86
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 86
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 39
                        ELSE 60
                    END
                WHEN 3 THEN
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 94
                        WHEN DAYOFWEEK(d.work_date) = 5 THEN 78
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 88
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 85
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 37
                        ELSE 63
                    END
                ELSE
                    CASE
                        WHEN DAYOFWEEK(d.work_date) = 6 THEN 90
                        WHEN DAYOFWEEK(d.work_date) = 7 THEN 94
                        WHEN DAYOFWEEK(d.work_date) = 1 THEN 80
                        WHEN DAYOFWEEK(d.work_date) = 2 THEN 43
                        ELSE 66
                    END
            END
            + MOD(b.branch_code * 7 + d.date_factor * 11 + DAYOFMONTH(d.work_date) * 19, 40)
            + ROUND(d.event_factor * 0.4)
    END
)
) x;


-- ============================================================
-- 5-1. orders 실제 테이블 입력
-- order_menu FK 부모 데이터 생성
-- ============================================================

INSERT INTO orders
(order_id, branch_code, kiosk_id, order_type, total_amount, status, order_date, created_at)
SELECT
    t.order_id,
    t.branch_code,
    t.kiosk_id,
    t.order_type,
    t.total_amount,
    t.status,
    t.order_date,
    t.created_at
FROM tmp_orders t
LEFT JOIN orders o
    ON o.order_id = t.order_id
WHERE o.order_id IS NULL;


-- ============================================================
-- 6. order_menu 생성
-- 전체 메뉴 등장 + 신메뉴 출시 효과
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_order_menu_source;
CREATE TEMPORARY TABLE tmp_order_menu_source (
    order_id VARCHAR(36),
    recipe_code VARCHAR(50),
    qty INT,
    multiplier INT
);

INSERT INTO tmp_order_menu_source
(order_id, recipe_code, qty, multiplier)
SELECT
    t.order_id,

    CASE
        WHEN t.order_date BETWEEN '2026-03-12' AND '2026-03-20'
         AND MOD(t.seed_no * 31 + s.n * 17, 100) < 32 THEN
            CASE MOD(t.seed_no + s.n, 3)
                WHEN 0 THEN '1001'
                WHEN 1 THEN '1003'
                ELSE '1010'
            END

        WHEN t.order_date BETWEEN '2026-03-21' AND '2026-03-31'
         AND MOD(t.seed_no * 31 + s.n * 17, 100) < 20 THEN
            CASE MOD(t.seed_no + s.n, 3)
                WHEN 0 THEN '1001'
                WHEN 1 THEN '1003'
                ELSE '1010'
            END

        WHEN t.order_date BETWEEN '2026-04-01' AND '2026-04-09'
         AND MOD(t.seed_no * 31 + s.n * 17, 100) < 12 THEN
            CASE MOD(t.seed_no + s.n, 3)
                WHEN 0 THEN '1001'
                WHEN 1 THEN '1003'
                ELSE '1010'
            END

        WHEN t.order_date BETWEEN '2026-04-10' AND '2026-04-18'
         AND MOD(t.seed_no * 37 + s.n * 19, 100) < 30 THEN
            CASE MOD(t.seed_no + s.n, 3)
                WHEN 0 THEN '1011'
                WHEN 1 THEN '1012'
                ELSE '3009'
            END

        WHEN t.order_date BETWEEN '2026-04-19' AND '2026-04-30'
         AND MOD(t.seed_no * 37 + s.n * 19, 100) < 18 THEN
            CASE MOD(t.seed_no + s.n, 3)
                WHEN 0 THEN '1011'
                WHEN 1 THEN '1012'
                ELSE '3009'
            END

        WHEN t.order_date BETWEEN '2026-05-01' AND @end_date
         AND MOD(t.seed_no * 37 + s.n * 19, 100) < 10 THEN
            CASE MOD(t.seed_no + s.n, 3)
                WHEN 0 THEN '1011'
                WHEN 1 THEN '1012'
                ELSE '3009'
            END

        ELSE rp.recipe_code
    END AS recipe_code,

    CASE
        WHEN s.n = 1 THEN 1
        WHEN MOD(t.seed_no * 13 + s.n * 17, 100) < 91 THEN 1
        WHEN MOD(t.seed_no * 13 + s.n * 17, 100) < 98 THEN 2
        ELSE 3
    END AS qty,

    CASE
        WHEN MOD(t.seed_no * 19 + s.n * 23, 100) < 13 THEN 2
        ELSE 1
    END AS multiplier

FROM tmp_orders t
JOIN tmp_seq s
    ON s.n <= t.item_count
JOIN tmp_recipe_pick rp
    ON rp.pick_no = MOD(t.seed_no * 17 + s.n * 31 + DAYOFYEAR(t.order_date) * 7, 100);


INSERT INTO order_menu
(order_id, recipe_code, qty, unit_price, line_total_amount, multiplier)
SELECT
    src.order_id,
    src.recipe_code,
    src.qty,
    r.price,
    0,
    CASE
        WHEN r.category_id IN (1, 2) THEN src.multiplier
        ELSE 1
    END AS multiplier
FROM tmp_order_menu_source src
JOIN recipe r
    ON r.recipe_code = src.recipe_code;


-- ============================================================
-- 7. order_option 생성
-- 7-1. 레시피 기본 재료
-- ============================================================

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    rd.material_code,
    0
FROM order_menu om
JOIN recipe_detail rd
    ON rd.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id;


-- ============================================================
-- 7-2. 빵 옵션
-- ============================================================

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    CASE MOD(om.order_menu_id * 7 + t.seed_no, 6)
        WHEN 0 THEN 101
        WHEN 1 THEN 102
        WHEN 2 THEN 103
        WHEN 3 THEN 104
        WHEN 4 THEN 105
        ELSE 106
    END AS material_code,
    0
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id
WHERE r.category_id = 1;


-- ============================================================
-- 7-3. 치즈 옵션
-- ============================================================

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    CASE MOD(om.order_menu_id * 11 + t.seed_no, 3)
        WHEN 0 THEN 201
        WHEN 1 THEN 202
        ELSE 203
    END AS material_code,
    0
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 13 + t.seed_no, 100) < 76;


-- ============================================================
-- 7-4. 야채 옵션
-- ============================================================

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 301, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 11 + t.seed_no, 100) < 68;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 302, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 13 + t.seed_no, 100) < 58;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 303, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 17 + t.seed_no, 100) < 66;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 304, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 19 + t.seed_no, 100) < 56;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 305, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 23 + t.seed_no, 100) < 48;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 306, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 29 + t.seed_no, 100) < 92;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 307, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 31 + t.seed_no, 100) < 42;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 308, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 37 + t.seed_no, 100) < 28;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 310, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 41 + t.seed_no, 100) < 32;

INSERT INTO order_option (order_menu_id, material_code, extra_price)
SELECT om.order_menu_id, 311, 0
FROM order_menu om
JOIN recipe r ON r.recipe_code = om.recipe_code
JOIN tmp_orders t ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 43 + t.seed_no, 100) < 24;


-- ============================================================
-- 7-5. 소스 옵션
-- 기본 1개 + 추가 소스 조합
-- ============================================================

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    CASE MOD(om.order_menu_id * 47 + t.seed_no, 14)
        WHEN 0 THEN 501
        WHEN 1 THEN 502
        WHEN 2 THEN 503
        WHEN 3 THEN 504
        WHEN 4 THEN 505
        WHEN 5 THEN 506
        WHEN 6 THEN 507
        WHEN 7 THEN 508
        WHEN 8 THEN 509
        WHEN 9 THEN 510
        WHEN 10 THEN 511
        WHEN 11 THEN 512
        WHEN 12 THEN 513
        ELSE 514
    END AS material_code,
    0
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2);

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    CASE MOD(om.order_menu_id * 53 + t.seed_no, 14)
        WHEN 0 THEN 501
        WHEN 1 THEN 502
        WHEN 2 THEN 503
        WHEN 3 THEN 504
        WHEN 4 THEN 505
        WHEN 5 THEN 506
        WHEN 6 THEN 507
        WHEN 7 THEN 508
        WHEN 8 THEN 509
        WHEN 9 THEN 510
        WHEN 10 THEN 511
        WHEN 11 THEN 512
        WHEN 12 THEN 513
        ELSE 514
    END AS material_code,
    0
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 59 + t.seed_no, 100) < 36;

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    CASE MOD(om.order_menu_id * 61 + t.seed_no, 14)
        WHEN 0 THEN 501
        WHEN 1 THEN 502
        WHEN 2 THEN 503
        WHEN 3 THEN 504
        WHEN 4 THEN 505
        WHEN 5 THEN 506
        WHEN 6 THEN 507
        WHEN 7 THEN 508
        WHEN 8 THEN 509
        WHEN 9 THEN 510
        WHEN 10 THEN 511
        WHEN 11 THEN 512
        WHEN 12 THEN 513
        ELSE 514
    END AS material_code,
    0
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 67 + t.seed_no, 100) < 19;


-- ============================================================
-- 7-6. 유료 추가재료 옵션
-- ============================================================

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    CASE MOD(om.order_menu_id * 71 + t.seed_no, 6)
        WHEN 0 THEN 402
        WHEN 1 THEN 403
        WHEN 2 THEN 404
        WHEN 3 THEN 405
        WHEN 4 THEN 406
        ELSE 408
    END AS material_code,
    CASE
        WHEN MOD(om.order_menu_id * 71 + t.seed_no, 6) = 3 THEN 2000
        ELSE 1500
    END AS extra_price
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 73 + t.seed_no, 100) < 24;

INSERT INTO order_option
(order_menu_id, material_code, extra_price)
SELECT
    om.order_menu_id,
    CASE MOD(om.order_menu_id * 79 + t.seed_no, 6)
        WHEN 0 THEN 402
        WHEN 1 THEN 403
        WHEN 2 THEN 404
        WHEN 3 THEN 405
        WHEN 4 THEN 406
        ELSE 408
    END AS material_code,
    CASE
        WHEN MOD(om.order_menu_id * 79 + t.seed_no, 6) = 3 THEN 2000
        ELSE 1500
    END AS extra_price
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN tmp_orders t
    ON t.order_id = om.order_id
WHERE r.category_id IN (1, 2)
  AND MOD(om.order_menu_id * 83 + t.seed_no, 100) < 8;


-- ============================================================
-- 8. 메뉴 금액 갱신
-- ============================================================

UPDATE order_menu om
JOIN (
    SELECT
        om.order_menu_id,
        (
            om.unit_price * om.qty * om.multiplier
            + IFNULL(SUM(oo.extra_price), 0) * om.qty
        ) AS new_line_total
    FROM order_menu om
    JOIN tmp_orders t
        ON t.order_id = om.order_id
    LEFT JOIN order_option oo
        ON oo.order_menu_id = om.order_menu_id
    GROUP BY
        om.order_menu_id,
        om.unit_price,
        om.qty,
        om.multiplier
) x
ON x.order_menu_id = om.order_menu_id
SET om.line_total_amount = x.new_line_total;


-- ============================================================
-- 9. 주문 총액 갱신
-- ============================================================

UPDATE orders o
JOIN (
    SELECT
        om.order_id,
        SUM(om.line_total_amount) AS total_amount
    FROM order_menu om
    JOIN tmp_orders t
        ON t.order_id = om.order_id
    GROUP BY om.order_id
) x
ON x.order_id = o.order_id
SET o.total_amount = x.total_amount;


-- ============================================================
-- 10. 확인용
-- ============================================================

SELECT
    o.branch_code,
    b.name AS branch_name,
    o.order_date,
    COUNT(*) AS order_count,
    SUM(o.total_amount) AS sales_amount,
    ROUND(SUM(o.total_amount) / COUNT(*), 0) AS avg_order_amount
FROM orders o
JOIN branch b
    ON b.branch_code = o.branch_code
WHERE o.order_date BETWEEN '2026-05-01' AND @end_date
GROUP BY o.branch_code, b.name, o.order_date
ORDER BY o.order_date, sales_amount DESC;

SELECT
    HOUR(o.created_at) AS hour_no,
    COUNT(*) AS order_count,
    SUM(o.total_amount) AS sales_amount
FROM orders o
WHERE o.order_date BETWEEN '2026-05-01' AND @end_date
GROUP BY HOUR(o.created_at)
ORDER BY hour_no;

SELECT
    r.name AS menu_name,
    SUM(om.line_total_amount) AS menu_sales,
    COUNT(*) AS order_menu_count
FROM order_menu om
JOIN recipe r
    ON r.recipe_code = om.recipe_code
JOIN orders o
    ON o.order_id = om.order_id
WHERE o.order_date BETWEEN '2026-03-01' AND @end_date
GROUP BY r.recipe_code, r.name
ORDER BY menu_sales DESC;

SELECT '✅ zeroloss order 더미 데이터 입력 완료 - 08~23시 영업/신메뉴 효과/전체 메뉴/전체 옵션 반영' AS result;