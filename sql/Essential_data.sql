USE zeroloss;

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. 기본 코드 테이블 (독립적)
-- ============================================================

INSERT INTO role (role_id, role_name) VALUES
(1, '본사 관리자'), (2, '점장'), (3, '매니저');

INSERT INTO grade (grade_code, grade_name, grade_order) VALUES
('GR_DIR', '부장', 6), ('GR_DPT', '차장', 5), ('GR_MGR', '과장', 4),
('GR_AST', '대리', 3), ('GR_STF', '사원', 2), ('GR_DRV', '배달기사', 1),
('GR_CEO', '대표이사', 7);

INSERT INTO `position` (position_code, position_name, position_level) VALUES
('POS_MGR', '점장', 4), ('POS_SUP', '매니저', 3),
('POS_STF', '직원', 2), ('POS_PTM', '알바', 1);

INSERT INTO region (region_code, name) VALUES
('02','서울권'), ('031','경기남부권'), ('032','인천권'), ('033','강원권'),
('041','충남권'), ('042','대전권'), ('043','충북권'), ('044','세종권'),
('051','부산권'), ('052','울산권'), ('053','대구권'), ('054','경북권'),
('055','경남권'), ('061','전남권'), ('062','광주권'), ('063','전북권'), ('064','제주권');

-- ============================================================
-- 2. 지점 & 본사
-- 서울권 16개 지점 + 본사
-- ============================================================

INSERT INTO branch (
    branch_code,
    region_code,
    name,
    address,
    lat,
    lng,
    phone,
    status,
    created_at
) VALUES
-- 본사
(1,    '02', '본사',         '서울 강남구 테헤란로 123',       37.4979000, 127.0276000, '02-1000-0000', 'ACTIVE', DEFAULT),

-- 강남/송파/서초권
(2001, '02', '강남점',       '서울 강남구 역삼동 123',         37.4985000, 127.0300000, '02-2001-1000', 'ACTIVE', DEFAULT),
(2002, '02', '잠실점',       '서울 송파구 올림픽로 240',       37.5133000, 127.1002000, '02-2002-1000', 'ACTIVE', DEFAULT),
(2003, '02', '사당점',       '서울 동작구 동작대로 3',         37.4765000, 126.9816000, '02-2003-1000', 'ACTIVE', DEFAULT),

-- 마포/서대문/강서권
(2004, '02', '홍대점',       '서울 마포구 홍익로 45',          37.5563000, 126.9239000, '02-2004-1000', 'ACTIVE', DEFAULT),
(2005, '02', '합정점',       '서울 마포구 양화로 45',          37.5495000, 126.9136000, '02-2005-1000', 'ACTIVE', DEFAULT),
(2006, '02', '신촌점',       '서울 서대문구 연세로 13',        37.5568000, 126.9368000, '02-2006-1000', 'ACTIVE', DEFAULT),
(2007, '02', '마곡점',       '서울 강서구 마곡중앙로 161',     37.5602000, 126.8331000, '02-2007-1000', 'ACTIVE', DEFAULT),

-- 도심권
(2008, '02', '종로점',       '서울 종로구 종로 51',            37.5704000, 126.9831000, '02-2008-1000', 'ACTIVE', DEFAULT),
(2009, '02', '명동점',       '서울 중구 명동길 14',            37.5636000, 126.9822000, '02-2009-1000', 'ACTIVE', DEFAULT),
(2010, '02', '서울역점',     '서울 용산구 한강대로 405',       37.5547000, 126.9707000, '02-2010-1000', 'ACTIVE', DEFAULT),

-- 여의도/구로권
(2011, '02', '여의도점',     '서울 영등포구 여의대로 108',     37.5258000, 126.9241000, '02-2011-1000', 'ACTIVE', DEFAULT),
(2012, '02', '구로디지털점', '서울 구로구 디지털로 300',       37.4853000, 126.9015000, '02-2012-1000', 'ACTIVE', DEFAULT),

-- 동북/동부권
(2013, '02', '건대점',       '서울 광진구 아차산로 272',       37.5404000, 127.0692000, '02-2013-1000', 'ACTIVE', DEFAULT),
(2014, '02', '왕십리점',     '서울 성동구 왕십리광장로 17',    37.5615000, 127.0379000, '02-2014-1000', 'ACTIVE', DEFAULT),
(2015, '02', '서울숲점',     '서울 성동구 왕십리로 83',        37.5446000, 127.0448000, '02-2015-1000', 'ACTIVE', DEFAULT),
(2016, '02', '노원점',       '서울 노원구 상계로 69',          37.6542000, 127.0605000, '02-2016-1000', 'ACTIVE', DEFAULT);


-- ============================================================
-- 본사
-- ============================================================

INSERT INTO hq (
    branch_code,
    address,
    phone,
    region_code
) VALUES
(1, '서울 강남구 테헤란로 123', '02-1000-0000', '02');

-- ============================================================
-- 3. 직원
-- 시연용 서울 16지점 기준
-- 본사 로그인용 16명 + 배송기사 4명 + 지점 직원 64명
-- ============================================================

INSERT INTO employee
(branch_code, dept, grade_code, position_code, name, phone, email, hire_date, status)
VALUES

-- ============================================================
-- 본사 로그인용 직원 16명
-- 임의 이름 버전
-- ============================================================

(1, '경영',     'GR_CEO', NULL, '강태윤', '010-1000-0001', 'ceo@zeroloss.com',        '2010-01-01', 'ACTIVE'),

(1, '인사',     'GR_DIR', NULL, '한서진', '010-1000-0002', 'hq_01@zeroloss.com', '2012-03-12', 'ACTIVE'),
(1, '재무회계', 'GR_DIR', NULL, '오민재', '010-1000-0003', 'hq_02@zeroloss.com', '2012-04-10', 'ACTIVE'),
(1, '영업관리', 'GR_DIR', NULL, '윤지후', '010-1000-0004', 'hq_03@zeroloss.com', '2012-05-15', 'ACTIVE'),
(1, '물류재고', 'GR_DIR', NULL, '백도현', '010-1000-0005', 'hq_04@zeroloss.com', '2012-06-20', 'ACTIVE'),
(1, '운영지원', 'GR_DIR', NULL, '서하린', '010-1000-0006', 'hq_05@zeroloss.com', '2012-07-25', 'ACTIVE'),

(1, '인사',     'GR_DPT', NULL, '문시우', '010-1000-0007', 'hq_06@zeroloss.com', '2015-03-12', 'ACTIVE'),
(1, '재무회계', 'GR_DPT', NULL, '권유나', '010-1000-0008', 'hq_07@zeroloss.com', '2015-07-21', 'ACTIVE'),
(1, '영업관리', 'GR_DPT', NULL, '임준서', '010-1000-0009', 'hq_08@zeroloss.com', '2015-09-01', 'ACTIVE'),
(1, '물류재고', 'GR_DPT', NULL, '정하율', '010-1000-0010', 'hq_09@zeroloss.com', '2015-11-14', 'ACTIVE'),
(1, '운영지원', 'GR_DPT', NULL, '신예찬', '010-1000-0011', 'hq_10@zeroloss.com', '2016-01-18', 'ACTIVE'),

(1, '인사',     'GR_MGR', NULL, '조아린', '010-1000-0012', 'hq_11@zeroloss.com', '2018-04-11', 'ACTIVE'),
(1, '재무회계', 'GR_MGR', NULL, '남도윤', '010-1000-0013', 'hq_12@zeroloss.com', '2018-08-22', 'ACTIVE'),
(1, '영업관리', 'GR_MGR', NULL, '배서율', '010-1000-0014', 'hq_13@zeroloss.com', '2018-12-03', 'ACTIVE'),
(1, '물류재고', 'GR_MGR', NULL, '차현우', '010-1000-0015', 'hq_14@zeroloss.com', '2019-03-14', 'ACTIVE'),
(1, '운영지원', 'GR_MGR', NULL, '유채원', '010-1000-0016', 'hq_15@zeroloss.com', '2019-07-07', 'ACTIVE'),

-- ============================================================
-- 배송기사 4명
-- 임의 이름 버전
-- ============================================================

(1, '물류', 'GR_DRV', NULL, '박건호', '010-1100-0001', 'driver_01@zeroloss.com', '2021-06-05', 'ACTIVE'),
(1, '물류', 'GR_DRV', NULL, '이재윤', '010-1100-0002', 'driver_02@zeroloss.com', '2022-09-02', 'ACTIVE'),
(1, '물류', 'GR_DRV', NULL, '최민규', '010-1100-0003', 'driver_03@zeroloss.com', '2023-02-17', 'ACTIVE'),
(1, '물류', 'GR_DRV', NULL, '김하람', '010-1100-0004', 'driver_04@zeroloss.com', '2024-05-03', 'ACTIVE'),
-- ============================================================
-- 서울 16지점 직원
-- 지점별 점장 1명, 매니저 1명, 직원 1명, 알바 1명
-- ============================================================

-- 강남점 2001
(2001, NULL, NULL, 'POS_MGR', '오지훈', '010-2001-0001', 'branch_01@zeroloss.com', '2019-08-14', 'ACTIVE'),
(2001, NULL, NULL, 'POS_SUP', '신가영', '010-2001-0002', 'gangnam_sup@zeroloss.com',    '2021-02-09', 'ACTIVE'),
(2001, NULL, NULL, 'POS_STF', '윤성민', '010-2001-0003', 'gangnam_stf@zeroloss.com',    '2024-01-10', 'ACTIVE'),
(2001, NULL, NULL, 'POS_PTM', '임수아', '010-2001-0004', 'gangnam_ptm@zeroloss.com',    '2024-05-27', 'ACTIVE'),

-- 잠실점 2002
(2002, NULL, NULL, 'POS_MGR', '김하준', '010-2002-0001', 'branch_02@zeroloss.com', '2020-01-13', 'ACTIVE'),
(2002, NULL, NULL, 'POS_SUP', '이지아', '010-2002-0002', 'jamsil_sup@zeroloss.com',     '2021-06-07', 'ACTIVE'),
(2002, NULL, NULL, 'POS_STF', '박도윤', '010-2002-0003', 'jamsil_stf@zeroloss.com',     '2023-02-20', 'ACTIVE'),
(2002, NULL, NULL, 'POS_PTM', '최서아', '010-2002-0004', 'jamsil_ptm@zeroloss.com',     '2023-11-11', 'ACTIVE'),

-- 사당점 2003
(2003, NULL, NULL, 'POS_MGR', '조민재', '010-2003-0001', 'branch_03@zeroloss.com', '2019-05-20', 'ACTIVE'),
(2003, NULL, NULL, 'POS_SUP', '윤서연', '010-2003-0002', 'sadang_sup@zeroloss.com',     '2021-09-01', 'ACTIVE'),
(2003, NULL, NULL, 'POS_STF', '한유준', '010-2003-0003', 'sadang_stf@zeroloss.com',     '2022-12-14', 'ACTIVE'),
(2003, NULL, NULL, 'POS_PTM', '오다인', '010-2003-0004', 'sadang_ptm@zeroloss.com',     '2023-07-29', 'ACTIVE'),

-- 홍대점 2004
(2004, NULL, NULL, 'POS_MGR', '서다은', '010-2004-0001', 'branch_04@zeroloss.com', '2020-09-01', 'ACTIVE'),
(2004, NULL, NULL, 'POS_SUP', '조현우', '010-2004-0002', 'hongdae_sup@zeroloss.com',    '2022-12-12', 'ACTIVE'),
(2004, NULL, NULL, 'POS_STF', '배지환', '010-2004-0003', 'hongdae_stf@zeroloss.com',    '2023-03-20', 'ACTIVE'),
(2004, NULL, NULL, 'POS_PTM', '문예린', '010-2004-0004', 'hongdae_ptm@zeroloss.com',    '2024-07-08', 'ACTIVE'),

-- 합정점 2005
(2005, NULL, NULL, 'POS_MGR', '홍지완', '010-2005-0001', 'branch_05@zeroloss.com', '2018-11-19', 'ACTIVE'),
(2005, NULL, NULL, 'POS_SUP', '안예림', '010-2005-0002', 'hapjeong_sup@zeroloss.com',   '2021-08-09', 'ACTIVE'),
(2005, NULL, NULL, 'POS_STF', '백건희', '010-2005-0003', 'hapjeong_stf@zeroloss.com',   '2023-09-12', 'ACTIVE'),
(2005, NULL, NULL, 'POS_PTM', '노수빈', '010-2005-0004', 'hapjeong_ptm@zeroloss.com',   '2024-05-01', 'ACTIVE'),

-- 신촌점 2006
(2006, NULL, NULL, 'POS_MGR', '김은우', '010-2006-0001', 'branch_06@zeroloss.com', '2020-10-05', 'ACTIVE'),
(2006, NULL, NULL, 'POS_SUP', '이하은', '010-2006-0002', 'sinchon_sup@zeroloss.com',    '2022-02-14', 'ACTIVE'),
(2006, NULL, NULL, 'POS_STF', '박시온', '010-2006-0003', 'sinchon_stf@zeroloss.com',    '2023-04-07', 'ACTIVE'),
(2006, NULL, NULL, 'POS_PTM', '최나윤', '010-2006-0004', 'sinchon_ptm@zeroloss.com',    '2024-08-26', 'ACTIVE'),

-- 마곡점 2007
(2007, NULL, NULL, 'POS_MGR', '정로운', '010-2007-0001', 'branch_07@zeroloss.com', '2019-12-09', 'ACTIVE'),
(2007, NULL, NULL, 'POS_SUP', '강민서', '010-2007-0002', 'magok_sup@zeroloss.com',      '2021-03-22', 'ACTIVE'),
(2007, NULL, NULL, 'POS_STF', '조현준', '010-2007-0003', 'magok_stf@zeroloss.com',      '2023-06-19', 'ACTIVE'),
(2007, NULL, NULL, 'POS_PTM', '윤아린', '010-2007-0004', 'magok_ptm@zeroloss.com',      '2024-11-04', 'ACTIVE'),

-- 종로점 2008
(2008, NULL, NULL, 'POS_MGR', '한지후', '010-2008-0001', 'branch_08@zeroloss.com', '2020-04-16', 'ACTIVE'),
(2008, NULL, NULL, 'POS_SUP', '오서영', '010-2008-0002', 'jongno_sup@zeroloss.com',     '2022-01-03', 'ACTIVE'),
(2008, NULL, NULL, 'POS_STF', '신유찬', '010-2008-0003', 'jongno_stf@zeroloss.com',     '2023-05-15', 'ACTIVE'),
(2008, NULL, NULL, 'POS_PTM', '문소율', '010-2008-0004', 'jongno_ptm@zeroloss.com',     '2024-02-27', 'ACTIVE'),

-- 명동점 2009
(2009, NULL, NULL, 'POS_MGR', '남도윤', '010-2009-0001', 'branch_09@zeroloss.com', '2019-07-08', 'ACTIVE'),
(2009, NULL, NULL, 'POS_SUP', '권나은', '010-2009-0002', 'myeongdong_sup@zeroloss.com', '2021-12-01', 'ACTIVE'),
(2009, NULL, NULL, 'POS_STF', '송민준', '010-2009-0003', 'myeongdong_stf@zeroloss.com', '2023-08-03', 'ACTIVE'),
(2009, NULL, NULL, 'POS_PTM', '유서아', '010-2009-0004', 'myeongdong_ptm@zeroloss.com', '2024-06-17', 'ACTIVE'),

-- 서울역점 2010
(2010, NULL, NULL, 'POS_MGR', '김민준', '010-2010-0001', 'branch_10@zeroloss.com', '2021-09-01', 'ACTIVE'),
(2010, NULL, NULL, 'POS_SUP', '이서연', '010-2010-0002', 'seoulstation_sup@zeroloss.com', '2023-01-15', 'ACTIVE'),
(2010, NULL, NULL, 'POS_STF', '박지훈', '010-2010-0003', 'seoulstation_stf@zeroloss.com', '2023-06-10', 'ACTIVE'),
(2010, NULL, NULL, 'POS_PTM', '최유진', '010-2010-0004', 'seoulstation_ptm@zeroloss.com', '2024-02-20', 'ACTIVE'),

-- 여의도점 2011
(2011, NULL, NULL, 'POS_MGR', '홍시우', '010-2011-0001', 'branch_11@zeroloss.com', '2020-02-25', 'ACTIVE'),
(2011, NULL, NULL, 'POS_SUP', '안지민', '010-2011-0002', 'yeouido_sup@zeroloss.com',    '2022-07-11', 'ACTIVE'),
(2011, NULL, NULL, 'POS_STF', '백유준', '010-2011-0003', 'yeouido_stf@zeroloss.com',    '2023-10-23', 'ACTIVE'),
(2011, NULL, NULL, 'POS_PTM', '노예은', '010-2011-0004', 'yeouido_ptm@zeroloss.com',    '2024-03-04', 'ACTIVE'),

-- 구로디지털점 2012
(2012, NULL, NULL, 'POS_MGR', '김준우', '010-2012-0001', 'branch_12@zeroloss.com', '2018-09-17', 'ACTIVE'),
(2012, NULL, NULL, 'POS_SUP', '이서아', '010-2012-0002', 'guro_sup@zeroloss.com',       '2021-05-24', 'ACTIVE'),
(2012, NULL, NULL, 'POS_STF', '박민규', '010-2012-0003', 'guro_stf@zeroloss.com',       '2023-03-13', 'ACTIVE'),
(2012, NULL, NULL, 'POS_PTM', '최하린', '010-2012-0004', 'guro_ptm@zeroloss.com',       '2024-08-08', 'ACTIVE'),

-- 건대점 2013
(2013, NULL, NULL, 'POS_MGR', '정유준', '010-2013-0001', 'branch_13@zeroloss.com', '2020-11-02', 'ACTIVE'),
(2013, NULL, NULL, 'POS_SUP', '강다연', '010-2013-0002', 'konkuk_sup@zeroloss.com',     '2022-06-06', 'ACTIVE'),
(2013, NULL, NULL, 'POS_STF', '조서준', '010-2013-0003', 'konkuk_stf@zeroloss.com',     '2023-12-18', 'ACTIVE'),
(2013, NULL, NULL, 'POS_PTM', '윤채은', '010-2013-0004', 'konkuk_ptm@zeroloss.com',     '2024-04-22', 'ACTIVE'),

-- 왕십리점 2014
(2014, NULL, NULL, 'POS_MGR', '한도윤', '010-2014-0001', 'branch_14@zeroloss.com', '2019-01-28', 'ACTIVE'),
(2014, NULL, NULL, 'POS_SUP', '오하윤', '010-2014-0002', 'wangsimni_sup@zeroloss.com',  '2021-10-15', 'ACTIVE'),
(2014, NULL, NULL, 'POS_STF', '신준호', '010-2014-0003', 'wangsimni_stf@zeroloss.com',  '2023-02-06', 'ACTIVE'),
(2014, NULL, NULL, 'POS_PTM', '문서현', '010-2014-0004', 'wangsimni_ptm@zeroloss.com',  '2024-01-29', 'ACTIVE'),

-- 서울숲점 2015
(2015, NULL, NULL, 'POS_MGR', '남시온', '010-2015-0001', 'branch_15@zeroloss.com', '2020-08-10', 'ACTIVE'),
(2015, NULL, NULL, 'POS_SUP', '권수아', '010-2015-0002', 'seoulforest_sup@zeroloss.com', '2022-03-28', 'ACTIVE'),
(2015, NULL, NULL, 'POS_STF', '송지훈', '010-2015-0003', 'seoulforest_stf@zeroloss.com', '2023-09-04', 'ACTIVE'),
(2015, NULL, NULL, 'POS_PTM', '유나연', '010-2015-0004', 'seoulforest_ptm@zeroloss.com', '2024-07-01', 'ACTIVE'),

-- 노원점 2016
(2016, NULL, NULL, 'POS_MGR', '홍민성', '010-2016-0001', 'branch_16@zeroloss.com', '2018-04-23', 'ACTIVE'),
(2016, NULL, NULL, 'POS_SUP', '안서윤', '010-2016-0002', 'nowon_sup@zeroloss.com',      '2021-01-18', 'ACTIVE'),
(2016, NULL, NULL, 'POS_STF', '백도윤', '010-2016-0003', 'nowon_stf@zeroloss.com',      '2022-11-07', 'ACTIVE'),
(2016, NULL, NULL, 'POS_PTM', '노지안', '010-2016-0004', 'nowon_ptm@zeroloss.com',      '2024-02-15', 'ACTIVE');
-- ============================================================
-- 4. 계정 (account)
-- 시연용 계정
-- 본사 계정 16개 + 지점 계정 16개
-- ============================================================

-- ============================================================
-- 본사 계정 16개
-- branch_code = 1, hq_id IS NOT NULL
-- role_id = 본사 관리자
-- ============================================================

INSERT INTO account (emp_no, branch_code, hq_id, role_id, login_id, password, status)
VALUES
((SELECT emp_no FROM employee WHERE name = '강태윤' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_01', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '한서진' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_02', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '오민재' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_03', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '윤지후' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_04', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '백도현' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_05', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '서하린' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_06', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '문시우' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_07', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '권유나' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_08', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '임준서' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_09', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '정하율' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_10', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '신예찬' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_11', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '조아린' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_12', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '남도윤' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_13', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '배서율' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_14', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '차현우' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_15', '000000', 'ACTIVE'),

((SELECT emp_no FROM employee WHERE name = '유채원' AND branch_code = 1 LIMIT 1),
 1,
 (SELECT hq_id FROM hq WHERE branch_code = 1 LIMIT 1),
 (SELECT role_id FROM role WHERE role_name = '본사 관리자' LIMIT 1),
 'hq_16', '000000', 'ACTIVE');


-- ============================================================
-- 지점 계정 16개
-- branch_code = 2001 ~ 2016
-- hq_id = NULL
-- 점장/매니저 계정 섞어서 생성
-- ============================================================

INSERT INTO account (emp_no, branch_code, hq_id, role_id, login_id, password, status)
VALUES

-- 2001 강남점 / 점장
((SELECT emp_no FROM employee WHERE name = '오지훈' AND branch_code = 2001 LIMIT 1),
 2001, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_01', '000000', 'ACTIVE'),

-- 2002 잠실점 / 매니저
((SELECT emp_no FROM employee WHERE name = '이지아' AND branch_code = 2002 LIMIT 1),
 2002, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_02', '000000', 'ACTIVE'),

-- 2003 사당점 / 점장
((SELECT emp_no FROM employee WHERE name = '조민재' AND branch_code = 2003 LIMIT 1),
 2003, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_03', '000000', 'ACTIVE'),

-- 2004 홍대점 / 매니저
((SELECT emp_no FROM employee WHERE name = '조현우' AND branch_code = 2004 LIMIT 1),
 2004, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_04', '000000', 'ACTIVE'),

-- 2005 합정점 / 점장
((SELECT emp_no FROM employee WHERE name = '홍지완' AND branch_code = 2005 LIMIT 1),
 2005, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_05', '000000', 'ACTIVE'),

-- 2006 신촌점 / 매니저
((SELECT emp_no FROM employee WHERE name = '이하은' AND branch_code = 2006 LIMIT 1),
 2006, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_06', '000000', 'ACTIVE'),

-- 2007 마곡점 / 점장
((SELECT emp_no FROM employee WHERE name = '정로운' AND branch_code = 2007 LIMIT 1),
 2007, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_07', '000000', 'ACTIVE'),

-- 2008 종로점 / 매니저
((SELECT emp_no FROM employee WHERE name = '오서영' AND branch_code = 2008 LIMIT 1),
 2008, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_08', '000000', 'ACTIVE'),

-- 2009 명동점 / 점장
((SELECT emp_no FROM employee WHERE name = '남도윤' AND branch_code = 2009 LIMIT 1),
 2009, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_09', '000000', 'ACTIVE'),

-- 2010 서울역점 / 매니저
((SELECT emp_no FROM employee WHERE name = '이서연' AND branch_code = 2010 LIMIT 1),
 2010, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_10', '000000', 'ACTIVE'),

-- 2011 여의도점 / 점장
((SELECT emp_no FROM employee WHERE name = '홍시우' AND branch_code = 2011 LIMIT 1),
 2011, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_11', '000000', 'ACTIVE'),

-- 2012 구로디지털점 / 매니저
((SELECT emp_no FROM employee WHERE name = '이서아' AND branch_code = 2012 LIMIT 1),
 2012, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_12', '000000', 'ACTIVE'),

-- 2013 건대점 / 점장
((SELECT emp_no FROM employee WHERE name = '정유준' AND branch_code = 2013 LIMIT 1),
 2013, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_13', '000000', 'ACTIVE'),

-- 2014 왕십리점 / 매니저
((SELECT emp_no FROM employee WHERE name = '오하윤' AND branch_code = 2014 LIMIT 1),
 2014, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_14', '000000', 'ACTIVE'),

-- 2015 서울숲점 / 점장
((SELECT emp_no FROM employee WHERE name = '남시온' AND branch_code = 2015 LIMIT 1),
 2015, NULL,
 (SELECT role_id FROM role WHERE role_name = '점장' LIMIT 1),
 'branch_15', '000000', 'ACTIVE'),

-- 2016 노원점 / 매니저
((SELECT emp_no FROM employee WHERE name = '안서윤' AND branch_code = 2016 LIMIT 1),
 2016, NULL,
 (SELECT role_id FROM role WHERE role_name = '매니저' LIMIT 1),
 'branch_16', '000000', 'ACTIVE');
-- ============================================================
-- 5. 메뉴/레시피 관련
-- ============================================================

INSERT INTO material_group (group_name, group_min, group_max) VALUES
('빵', 1, 1), ('치즈', 0, 1), ('야채', 0, 999), ('추가재료', 0, 999),
('소스', 1, 3), ('육류', 1, 1), ('사이드', 0, 999), ('음료', 0, 999), ('수프', 0, 999);

INSERT INTO material 
(material_code, material_group_id, material_name, material_price, price, deduct_qty, unit) 
VALUES
(101, 1, '플랫', 1000, NULL, 1, '개'),
(102, 1, '위트', 1000, NULL, 1, '개'),
(103, 1, '그레인', 1000, NULL, 1, '개'),
(104, 1, '파마산 오레가노', 1000, NULL, 1, '개'),
(105, 1, '화이트', 1000, NULL, 1, '개'),
(106, 1, '허니오트', 1000, NULL, 1, '개'),

(201, 2, '슈레드 치즈', 500, NULL, 1, '장'),
(202, 2, '아메리칸 치즈', 500, NULL, 1, '장'),
(203, 2, '모차렐라 치즈', 500, NULL, 1, '장'),

(301, 3, '피클', 100, NULL, 20, 'g'),
(302, 3, '오이', 100, NULL, 20, 'g'),
(303, 3, '양파', 100, NULL, 20, 'g'),
(304, 3, '올리브', 100, NULL, 20, 'g'),
(305, 3, '토마토', 100, NULL, 30, 'g'),
(306, 3, '양상추', 100, NULL, 30, 'g'),
(307, 3, '피망', 100, NULL, 20, 'g'),
(308, 3, '할라피뇨', 100, NULL, 10, 'g'),
(310, 3, '머쉬룸', 100, NULL, 20, 'g'),
(311, 3, '채소믹스', 100, NULL, 30, 'g'),

(402, 4, '베이컨', 1500, 1500, 40, 'g'),
(403, 4, '페퍼로니', 1500, 1500, 30, 'g'),
(404, 4, '아보카도', 1500, 1500, 50, 'g'),
(405, 4, '에그마요', 2000, 2000, 50, 'g'),
(406, 4, '오믈렛', 1500, 1500, 1, '개'),
(408, 4, '에그 슬라이스', 1500, 1500, 1, '개'),

(501, 5, '랜치', 300, NULL, 10, 'ml'),
(502, 5, '홀스래디쉬', 300, NULL, 10, 'ml'),
(503, 5, '저당 크리미 어니언', 300, NULL, 10, 'ml'),
(504, 5, '스위트 어니언', 300, NULL, 10, 'ml'),
(505, 5, '마요네즈', 300, NULL, 10, 'ml'),
(506, 5, '스위트 칠리', 300, NULL, 10, 'ml'),
(507, 5, '스모크 바비큐', 300, NULL, 10, 'ml'),
(508, 5, '핫칠리', 300, NULL, 10, 'ml'),
(509, 5, '허니 머스타드', 300, NULL, 10, 'ml'),
(510, 5, '사우스웨스트 치폴레', 300, NULL, 10, 'ml'),
(511, 5, '엑스트라 버진 올리브 오일', 300, NULL, 5, 'ml'),
(512, 5, '레드 와인 식초', 300, NULL, 5, 'ml'),
(513, 5, '후추', 100, NULL, 1, 'g'),
(514, 5, '소금', 100, NULL, 1, 'g'),

(601, 6, '잠봉 햄', 1200, NULL, 80, 'g'),
(602, 6, '안창살', 2000, NULL, 90, 'g'),
(603, 6, '우둔', 1800, NULL, 90, 'g'),
(604, 6, '설도', 1800, NULL, 90, 'g'),
(606, 6, '살라미', 1200, NULL, 40, 'g'),
(607, 6, '돼지고기 햄', 1200, NULL, 80, 'g'),
(609, 6, '칠면조 가슴살', 1500, NULL, 80, 'g'),
(611, 6, '닭다리살', 1400, NULL, 90, 'g'),
(612, 6, '닭가슴살', 1300, NULL, 90, 'g'),
(613, 6, '돼지 어깨 살', 1500, NULL, 90, 'g'),
(614, 6, '새우', 2000, NULL, 70, 'g'),
(615, 6, '참치', 1800, NULL, 80, 'g'),
(617, 6, '베지 패티', 1500, NULL, 1, '개'),

(701, 7, '초코칩', 800, NULL, 1, '개'),
(702, 7, '베이컨 치즈 웨지 포테이토', 2500, NULL, 1, '개'),
(703, 7, '치즈 웨지 포테이토', 2300, NULL, 1, '개'),
(704, 7, '웨지 포테이토', 2000, NULL, 1, '개'),
(705, 7, '스테이크&치즈 아보카도 랩', 4500, NULL, 1, '개'),
(706, 7, '쉬림프 에그마요 랩', 4200, NULL, 1, '개'),
(707, 7, '치킨 베이컨 미니 랩', 4000, NULL, 1, '개'),
(708, 7, '잠봉, 에그&치즈 랩', 4200, NULL, 1, '개'),
(709, 7, '웨스턴 에그 & 치즈 랩', 4100, NULL, 1, '개'),
(710, 7, '더블 초코칩', 900, NULL, 1, '개'),
(711, 7, '오렌지 초코칩', 900, NULL, 1, '개'),
(712, 7, '라즈베리 치즈케익', 1200, NULL, 1, '개'),
(713, 7, '오트밀 레이즌', 1100, NULL, 1, '개'),
(714, 7, '화이트 초코 마카다미아', 1200, NULL, 1, '개'),
(715, 7, '칩', 500, NULL, 1, '개'),

(801, 8, '커피', 1000, NULL, 1, '개'),
(802, 8, '콜라', 1000, NULL, 1, '개'),
(803, 8, '사이다', 1000, NULL, 1, '개'),

(901, 9, '머쉬룸 수프', 2000, NULL, 1, '개'),
(902, 9, '콘 수프', 2000, NULL, 1, '개'),
(903, 9, '포테이토 베이컨 수프', 2500, NULL, 1, '개');

INSERT INTO main_category (category_id, name) VALUES
(1, '샌드위치'), (2, '샐러드'), (3, '사이드'), (4, '음료/수프');

INSERT INTO category_material_group (category_id, material_group_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 2), (2, 3), (2, 4), (2, 5);

INSERT INTO sub_category (sub_category_code, main_category_id, name) VALUES
(101, 1, '전체'), (111, 1, '클래식'), (112, 1, '프레시&라이트'), (113, 1, '프리미엄'),
(201, 2, '전체'), (211, 2, '클래식'), (212, 2, '프레시&라이트'), (213, 2, '프리미엄'),
(301, 3, '전체'), (311, 3, '감자'), (312, 3, '쿠키'), (313, 3, '랩'),
(401, 4, '전체'), (411, 4, '수프'), (412, 4, '음료');

INSERT INTO recipe (recipe_code, category_id, sub_category_code, name, price, instruction, img_url, is_active) VALUES
-- 1. 샌드위치 (sandwich 폴더)
('1001', 1, '113', '잠봉 플러스', 8900, NULL, 'upload/recipe/sandwich/jambon_plus.png', TRUE),
('1002', 1, '111', '잠봉', 7400, NULL, 'upload/recipe/sandwich/jambon.png', TRUE),
('1003', 1, '112', '머쉬룸', 6200, NULL, 'upload/recipe/sandwich/mushroom.png', TRUE),
('1004', 1, '113', '안창 비프&머쉬룸', 8900, NULL, 'upload/recipe/sandwich/beef_mushroom.png', TRUE),
('1005', 1, '113', '스테이크&치즈', 7400, NULL, 'upload/recipe/sandwich/steak_cheese.png', TRUE),
('1006', 1, '111', '이탈리안 비엠티', 7200, NULL, 'upload/recipe/sandwich/italian_bmt.png', TRUE),
('1007', 1, '112', '로티세리 바비큐 치킨', 6200, NULL, 'upload/recipe/sandwich/rotisserie_chicken.png', TRUE),
('1008', 1, '111', '에그마요', 8600, NULL, 'upload/recipe/sandwich/egg_mayo.png', TRUE),
('1009', 1, '113', '안창 비프', 10400, NULL, 'upload/recipe/sandwich/diaphragm_beef.png', TRUE),
('1010', 1, '113', '터키 베이컨 아보카도', 8700, NULL, 'upload/recipe/sandwich/turkey_bacon_avocado.png', TRUE),
('1011', 1, '113', '스파이시 쉬림프', 8100, NULL, 'upload/recipe/sandwich/spicy_shrimp.png', TRUE),
('1012', 1, '112', '쉬림프', 7600, NULL, 'upload/recipe/sandwich/shrimp.png', TRUE),
('1013', 1, '112', '로스트 치킨', 7500, NULL, 'upload/recipe/sandwich/roast_chicken.png', TRUE),
('1014', 1, '113', '폴드포크 바비큐', 6300, NULL, 'upload/recipe/sandwich/pulled_pork.png', TRUE),
('1015', 1, '111', '제로 클럽', 7100, NULL, 'upload/recipe/sandwich/zero_club.png', TRUE),
('1016', 1, '112', '치킨 데리야끼', 7000, NULL, 'upload/recipe/sandwich/chicken_teriyaki.png', TRUE),
('1017', 1, '111', '스파이시 이탈리안', 8100, NULL, 'upload/recipe/sandwich/spicy_italian.png', TRUE),
('1018', 1, '111', '비엘티', 6600, NULL, 'upload/recipe/sandwich/blt.png', TRUE),
('1019', 1, '112', '터키', 6900, NULL, 'upload/recipe/sandwich/turkey.png', TRUE),
('1020', 1, '112', '참치', 5800, NULL, 'upload/recipe/sandwich/tuna.png', TRUE),
('1021', 1, '111', '햄', 7100, NULL, 'upload/recipe/sandwich/ham.png', TRUE),
('1022', 1, '111', '에그 슬라이스', 5200, NULL, 'upload/recipe/sandwich/egg_slice.png', TRUE),
('1023', 1, '112', '베지', 5000, NULL, 'upload/recipe/sandwich/veggie.png', TRUE),
('1024', 1, '112', '치킨 슬라이스', 6500, NULL, 'upload/recipe/sandwich/chicken_slice.png', TRUE),
('1025', 1, '113', '치킨 베이컨 아보카도', 8000, NULL, 'upload/recipe/sandwich/chicken_bacon_avocado.png', TRUE),
('1026', 1, '111', '웨스턴 에그&치즈', 3900, NULL, 'upload/recipe/sandwich/western_egg_cheese.png', TRUE),
('1027', 1, '111', '햄 에그&치즈', 3900, NULL, 'upload/recipe/sandwich/ham_egg_cheese.png', TRUE),

-- 2. 샐러드 (salad 폴더)
('2001', 2, '211', '잠봉', 7400, NULL, 'upload/recipe/salad/jambon_salad.png', TRUE),
('2002', 2, '213', '잠봉 플러스', 8900, NULL, 'upload/recipe/salad/jambon_plus_salad.png', TRUE),
('2003', 2, '213', '로티세리 치킨 타코', 12500, NULL, 'upload/recipe/salad/rotisserie_chicken_taco.png', TRUE),
('2004', 2, '213', '폴드포크 타코', 11900, NULL, 'upload/recipe/salad/pulled_pork_taco.png', TRUE),
('2005', 2, '213', '스파이시 쉬림프 타코', 12800, NULL, 'upload/recipe/salad/spicy_shrimp_taco.png', TRUE),
('2006', 2, '213', '안창 비프', 12800, NULL, 'upload/recipe/salad/diaphragm_beef_salad.png', TRUE),
('2007', 2, '213', '안창 비프&NEW 머쉬룸', 11400, NULL, 'upload/recipe/salad/beef_new_mushroom_salad.png', TRUE),
('2008', 2, '212', 'NEW 머쉬룸', 8000, NULL, 'upload/recipe/salad/new_mushroom_salad.png', TRUE),
('2009', 2, '211', '이탈리안 비엠티', 7200, NULL, 'upload/recipe/salad/italian_bmt_salad.png', TRUE),
('2010', 2, '211', '비엘티', 8000, NULL, 'upload/recipe/salad/blt_salad.png', TRUE),
('2011', 2, '211', '햄', 7700, NULL, 'upload/recipe/salad/ham_salad.png', TRUE),
('2012', 2, '212', '참치', 8200, NULL, 'upload/recipe/salad/tuna_salad.png', TRUE),
('2013', 2, '211', '에그마요', 7500, NULL, 'upload/recipe/salad/egg_mayo_salad.png', TRUE),
('2014', 2, '213', '폴드포크 바비큐', 9900, NULL, 'upload/recipe/salad/pulled_pork_barbecue_salad.png', TRUE),
('2015', 2, '212', '로티세리 바비큐 치킨', 9100, NULL, 'upload/recipe/salad/rotisserie_chicken_salad.png', TRUE),
('2016', 2, '212', '쉬림프', 9400, NULL, 'upload/recipe/salad/shrimp_salad.png', TRUE),
('2017', 2, '213', '터키 베이컨 아보카도', 11200, NULL, 'upload/recipe/salad/turkey_bacon_avocado_salad.png', TRUE),
('2018', 2, '211', '제로 클럽', 9500, NULL, 'upload/recipe/salad/zero_club_salad.png', TRUE),
('2019', 2, '211', '에그 슬라이스', 7000, NULL, 'upload/recipe/salad/egg_slice_salad.png', TRUE),
('2020', 2, '213', '스파이시 쉬림프', 8000, NULL, 'upload/recipe/salad/spicy_shrimp_salad.png', TRUE),
('2021', 2, '213', '스테이크&치즈', 8200, NULL, 'upload/recipe/salad/steak_cheese_salad.png', TRUE),
('2022', 2, '212', '로스트 치킨', 9100, NULL, 'upload/recipe/salad/roast_chicken_salad.png', TRUE),
('2023', 2, '212', '치킨 데리야끼', 9900, NULL, 'upload/recipe/salad/chicken_teriyaki_salad.png', TRUE),
('2024', 2, '212', '터키', 9000, NULL, 'upload/recipe/salad/turkey_salad.png', TRUE),
('2025', 2, '212', '베지', 6700, NULL, 'upload/recipe/salad/veggie_salad.png', TRUE),
('2026', 2, '211', '스파이시 이탈리안', 8700, NULL, 'upload/recipe/salad/spicy_italian_salad.png', TRUE),
('2027', 2, '212', '미니 로티세리 치킨 샐러드', 2900, NULL, 'upload/recipe/salad/mini_rotisserie_chicken_salad.png', TRUE),

-- 3. 사이드 (side 폴더)
('3001', 3, '311', '베이컨 치즈 웨지 포테이토', 2300, NULL, 'upload/recipe/side/bacon_cheese_wedge_potato.png', TRUE),
('3002', 3, '311', '치즈 웨지 포테이토', 2000, NULL, 'upload/recipe/side/cheese_wedge_potato.png', TRUE),
('3003', 3, '311', '웨지 포테이토', 1500, NULL, 'upload/recipe/side/wedge_potato.png', TRUE),
('3004', 3, '313', '스테이크&치즈 아보카도 랩', 6600, NULL, 'upload/recipe/side/steak_cheese_avocado_wrap.png', TRUE),
('3005', 3, '313', '쉬림프 에그마요 랩', 6200, NULL, 'upload/recipe/side/shrimp_egg_mayo_wrap.png', TRUE),
('3006', 3, '313', '치킨 베이컨 미니 랩', 3900, NULL, 'upload/recipe/side/chicken_bacon_mini_wrap.png', TRUE),
('3007', 3, '313', '잠봉, 에그&치즈 랩', 3900, NULL, 'upload/recipe/side/jambon_egg_cheese_wrap.png', TRUE),
('3008', 3, '313', '웨스턴 에그&치즈 랩', 3900, NULL, 'upload/recipe/side/western_egg_cheese_wrap.png', TRUE),
('3009', 3, '312', '초코칩', 1000, NULL, 'upload/recipe/side/chocolate_chip.png', TRUE),
('3010', 3, '312', '더블 초코칩', 1500, NULL, 'upload/recipe/side/double_chocolate_chip.png', TRUE),
('3011', 3, '312', '오렌지 초코칩', 1500, NULL, 'upload/recipe/side/orange_chocolate_chip.png', TRUE),
('3012', 3, '312', '라즈베리 치즈케익', 1300, NULL, 'upload/recipe/side/raspberry_cheesecake.png', TRUE),
('3013', 3, '312', '오트밀 레이즌', 1500, NULL, 'upload/recipe/side/oatmeal_raisin.png', TRUE),
('3014', 3, '312', '화이트 초코 마카다미아', 1500, NULL, 'upload/recipe/side/white_choco_macadamia.png', TRUE),
('3015', 3, '312', '칩', 1500, NULL, 'upload/recipe/side/chips.png', TRUE),

-- 4. 음료/수프 (drink 폴더 & side 폴더 혼합)
('4001', 4, '411', '머쉬룸 수프', 3000, NULL, 'upload/recipe/drink/mushroom_soup.png', TRUE),
('4002', 4, '411', '콘 수프', 4100, NULL, 'upload/recipe/drink/corn_soup.png', TRUE),
('4003', 4, '411', '포테이토 베이컨 수프', 4100, NULL, 'upload/recipe/drink/potato_bacon_soup.png', TRUE),
('4004', 4, '412', '커피', 2000, NULL, 'upload/recipe/drink/coffee.png', TRUE),
('4005', 4, '412', '콜라', 2000, NULL, 'upload/recipe/drink/soda.png', TRUE),
('4006', 4, '412', '사이다', 2000, NULL, 'upload/recipe/drink/soda.png', TRUE);

INSERT INTO recipe_detail (recipe_code, material_code, required_qty) VALUES
('1001', 601, 1),
('1002', 601, 1),
('1003', 310, 1),
('1004', 602, 1),
('1004', 310, 1),
('1005', 603, 1),
('1005', 201, 1),
('1006', 403, 1),
('1006', 606, 1),
('1006', 607, 1),
('1007', 611, 1),
('1008', 408, 1),
('1009', 602, 1),
('1010', 609, 1),
('1010', 402, 1),
('1010', 404, 1),
('1011', 614, 1),
('1012', 614, 1),
('1013', 612, 1),
('1014', 613, 1),
('1015', 609, 1),
('1015', 607, 1),
('1016', 611, 1),
('1017', 403, 1),
('1017', 606, 1),
('1018', 402, 1),
('1019', 609, 1),
('1020', 615, 1),
('1021', 607, 1),
('1022', 408, 1),
('1023', 617, 1),
('1024', 612, 1),
('1025', 612, 1),
('1025', 402, 1),
('1025', 404, 1),
('1026', 408, 1),
('1026', 201, 1),
('1027', 607, 1),
('1027', 408, 1),
('1027', 201, 1),

('2001', 601, 1),
('2002', 601, 1),
('2003', 611, 1),
('2004', 613, 1),
('2005', 614, 1),
('2006', 602, 1),
('2007', 602, 1),
('2007', 310, 1),
('2008', 310, 1),
('2009', 403, 1),
('2009', 606, 1),
('2009', 607, 1),
('2010', 402, 1),
('2011', 607, 1),
('2012', 615, 1),
('2013', 408, 1),
('2014', 613, 1),
('2015', 611, 1),
('2016', 614, 1),
('2017', 609, 1),
('2017', 402, 1),
('2017', 404, 1),
('2018', 609, 1),
('2018', 607, 1),
('2019', 408, 1),
('2020', 614, 1),
('2021', 603, 1),
('2021', 201, 1),
('2022', 612, 1),
('2023', 611, 1),
('2024', 609, 1),
('2025', 617, 1),
('2026', 403, 1),
('2026', 606, 1),
('2027', 612, 1),
('2027', 306, 1), -- 양상추
('2027', 302, 1), -- 오이
('2027', 305, 1), -- 토마토
('2027', 201, 1), -- 슈레드 치즈
('2027', 304, 1), -- 올리브

('3001', 702, 1),
('3002', 703, 1),
('3003', 704, 1),
('3004', 705, 1),
('3005', 706, 1),
('3006', 707, 1),
('3007', 708, 1),
('3008', 709, 1),
('3009', 701, 1),
('3010', 710, 1),
('3011', 711, 1),
('3012', 712, 1),
('3013', 713, 1),
('3014', 714, 1),
('3015', 715, 1),

('4001', 901, 1),
('4002', 902, 1),
('4003', 903, 1),
('4004', 801, 1),
('4005', 802, 1),
('4006', 803, 1);

-- ============================================================
-- material_order_limit 신규 생성
-- 재료 그룹/단위 기준 최소·최대 발주 수량 설정
-- ============================================================

INSERT INTO material_order_limit (
    material_code,
    min_qty,
    max_qty
)
SELECT
    m.material_code,

    CASE
        -- 빵
        WHEN m.material_group_id = 1 THEN 10

        -- 치즈
        WHEN m.material_group_id = 2 THEN 20

        -- 야채
        WHEN m.material_group_id = 3 THEN 500

        -- 추가재료
        WHEN m.material_group_id = 4 AND m.unit = 'g' THEN 300
        WHEN m.material_group_id = 4 AND m.unit = '개' THEN 10

        -- 소스
        WHEN m.material_group_id = 5 THEN 500

        -- 육류
        WHEN m.material_group_id = 6 THEN 500

        -- 사이드 / 음료 / 수프
        WHEN m.material_group_id IN (7, 8, 9) THEN 10

        ELSE 10
    END AS min_qty,

    CASE
        -- g/ml 단위는 대량 발주 가능
        WHEN m.unit IN ('g', 'ml') THEN 99999

        -- 개/장 단위는 적당히 제한
        WHEN m.unit IN ('개', '장') THEN 9999

        ELSE 9999
    END AS max_qty

FROM material m
ORDER BY m.material_code;
-- ============================================================
-- 6. 키오스크
-- 서울 16지점 기준 / 지점별 2대
-- ============================================================

INSERT INTO kiosk (branch_code, status) VALUES

-- 강남점
(2001, 'NORMAL'), (2001, 'NORMAL'),

-- 잠실점
(2002, 'NORMAL'), (2002, 'NORMAL'),

-- 사당점
(2003, 'NORMAL'), (2003, 'NORMAL'),

-- 홍대점
(2004, 'NORMAL'), (2004, 'NORMAL'),

-- 합정점
(2005, 'NORMAL'), (2005, 'NORMAL'),

-- 신촌점
(2006, 'NORMAL'), (2006, 'NORMAL'),

-- 마곡점
(2007, 'NORMAL'), (2007, 'NORMAL'),

-- 종로점
(2008, 'NORMAL'), (2008, 'NORMAL'),

-- 명동점
(2009, 'NORMAL'), (2009, 'NORMAL'),

-- 서울역점
(2010, 'NORMAL'), (2010, 'NORMAL'),

-- 여의도점
(2011, 'NORMAL'), (2011, 'NORMAL'),

-- 구로디지털점
(2012, 'NORMAL'), (2012, 'NORMAL'),

-- 건대점
(2013, 'NORMAL'), (2013, 'NORMAL'),

-- 왕십리점
(2014, 'NORMAL'), (2014, 'NORMAL'),

-- 서울숲점
(2015, 'NORMAL'), (2015, 'NORMAL'),

-- 노원점
(2016, 'NORMAL'), (2016, 'NORMAL');
-- ============================================================
-- 9. 소통 (notice, inquiry, notification)
-- ============================================================

INSERT INTO notice (author_id, title, content, `type`, created_at, last_date, view_count, is_pinned) VALUES
(1, '신메뉴 출시 안내', '잠봉 플러스, 스테이크&치즈 등 신메뉴가 출시되었습니다.', '운영 지침', '2026-04-20 09:00:00', '2026-04-22 14:30:00', 98, TRUE),
(2, '4월 매출 목표 달성 안내', '강남점과 홍대점이 목표를 초과 달성하였습니다.', '일반 공지', '2026-04-21 10:15:00', NULL, 112, FALSE),
(1, '재고 관리 주의사항', '유통기한 임박 재료를 우선 사용해 주세요.', '긴급 공지', '2026-04-22 11:30:00', '2026-04-23 09:45:00', 145, TRUE),
(3, '5월 운영 일정 공지', '5월 연휴 기간 운영 시간 변경 사항을 확인해 주세요.', '일반 공지', '2026-04-23 13:00:00', '2026-04-23 15:20:00', 76, FALSE),
(1, '위생 점검 안내', '4월 마지막 주 위생 점검이 예정되어 있습니다.', '위생 가이드', '2026-04-24 08:30:00', NULL, 89, FALSE),
(2, '키오스크 점검 안내', '일부 지점 키오스크 네트워크 점검이 예정되어 있습니다.', '운영 지침', '2026-04-25 09:10:00', '2026-04-25 10:42:00', 67, FALSE),
(1, '여름철 식재료 보관 안내', '냉장 재료 보관 온도를 반드시 확인해 주세요.', '위생 가이드', '2026-04-25 14:00:00', NULL, 91, FALSE),
(3, '5월 프로모션 운영 공지', '5월 한정 세트메뉴 프로모션이 진행됩니다.', '일반 공지', '2026-04-26 08:30:00', '2026-04-26 11:15:00', 123, TRUE),
(1, '발주 마감 시간 변경 안내', '물류센터 시스템 점검으로 인해 금일 발주 마감 시간이 변경됩니다.', '긴급 공지', '2026-04-26 13:45:00', NULL, 154, TRUE),
(2, '냉장고 온도 점검 요청', '모든 지점은 영업 종료 후 냉장고 온도를 기록해 주세요.', '운영 지침', '2026-04-27 09:25:00', NULL, 82, FALSE),
(3, '신입 직원 위생 교육 안내', '신규 입사 직원 대상 위생 교육 일정이 등록되었습니다.', '위생 가이드', '2026-04-27 15:00:00', '2026-04-27 16:12:00', 59, FALSE),
(1, 'POS 및 ERP 서버 점검 예정', '4월 마지막 주 서버 안정화 작업이 진행될 예정입니다.', '긴급 공지', '2026-04-28 07:50:00', NULL, 171, TRUE), 
(2, '재고 실사 일정 안내', '월말 재고 실사가 예정되어 있으니 재고 정리를 진행해 주세요.', '운영 지침', '2026-04-28 10:30:00', NULL, 95, FALSE);

INSERT INTO inquiry (branch_code, title, content, category, urgency, status, created_at, updated_at) VALUES
(2001, '키오스크 1번 화면 오류', '터치가 안 되고 계속 깜빡입니다. 재부팅해도 동일합니다.', '설비 문의', '긴급', '처리 중', '2026-04-20 09:00:00', '2026-04-20 10:30:00'),
(2002, '발주 승인 지연 문의', '지난주 목요일에 요청한 발주가 아직 승인되지 않았습니다. 확인 부탁드립니다.', '재고 문의', '일반', '답변 완료', '2026-04-21 11:15:00', '2026-04-21 13:40:00'),
(2003, '재료 부족 알림', '주말 대비 빵 재고가 부족할 것으로 예상됩니다. 추가 공급 가능할까요?', '재고 문의', '긴급', '대기 중', '2026-04-22 14:00:00', NULL),
(2004, '직원 스케줄 변경 요청', '다음주 수요일 근무자 A와 B의 근무 시간을 맞바꾸고 싶습니다.', '인사 문의', '일반', '처리 중', '2026-04-23 08:30:00', '2026-04-23 09:15:00'),

(2005, '냉장고 온도 이상', '주방 쪽 냉장고 온도가 기준치를 초과하고 있습니다. 긴급 점검 필요합니다.', '설비 문의', '긴급', '대기 중', '2026-04-24 10:20:00', NULL),
(2006, '포스 시스템 오류', '특정 카드사 결제 시 포스 시스템에서 오류가 발생하며 멈춥니다.', '설비 문의', '일반', '답변 완료', '2026-04-24 13:40:00', '2026-04-24 15:05:00'),
(2007, '안전재고 설정 변경 요청', '신메뉴 재료인 머쉬룸의 안전재고 수량을 10개에서 20개로 조정을 요청드립니다.', '운영 건의', '일반', '대기 중', '2026-04-24 15:10:00', NULL),
(2008, '배송 지연 문의', '3일 전 발주한 식자재가 아직 도착하지 않았습니다. 배송 현황 확인 부탁드립니다.', '재고 문의', '일반', '답변 완료', '2026-04-24 16:50:00', '2026-04-24 18:20:00'),

(2009, '영수증 출력 오류', '결제는 정상 처리되지만 영수증 출력이 되지 않습니다.', '설비 문의', '일반', '처리 중', '2026-04-25 09:12:00', '2026-04-25 10:01:00'),
(2010, 'ERP 로그인 오류', '일부 직원 계정이 로그인되지 않는 문제가 발생하고 있습니다.', '시스템 문의', '긴급', '처리 중', '2026-04-25 11:35:00', '2026-04-25 12:10:00'),
(2011, '발주 수량 수정 요청', '잘못 입력한 발주 수량 수정이 가능한지 문의드립니다.', '재고 문의', '일반', '답변 완료', '2026-04-25 13:44:00', '2026-04-25 15:02:00'),
(2012, '키오스크 결제 속도 저하', '점심시간대 카드 결제 승인 속도가 평소보다 느립니다.', '시스템 문의', '긴급', '대기 중', '2026-04-26 12:18:00', NULL),

(2013, '신입 직원 계정 생성 요청', '새로 입사한 직원 ERP 계정 생성을 요청드립니다.', '인사 문의', '일반', '답변 완료', '2026-04-26 14:26:00', '2026-04-26 15:00:00'),
(2014, '냉동 창고 문 손상', '냉동 창고 문이 완전히 닫히지 않아 확인 요청드립니다.', '설비 문의', '긴급', '처리 중', '2026-04-27 08:42:00', '2026-04-27 09:30:00'),
(2015, '스왑 요청 처리 문의', '인근 지점에 요청한 식자재 스왑 건이 아직 처리되지 않았습니다. 확인 부탁드립니다.', '재고 문의', '일반', '대기 중', '2026-04-27 13:20:00', NULL),
(2016, '공지사항 확인 권한 문의', '지점 계정으로 일부 공지사항이 보이지 않아 권한 확인을 요청드립니다.', '시스템 문의', '일반', '답변 완료', '2026-04-28 10:10:00', '2026-04-28 11:00:00');

INSERT INTO inquiry_reply (inquiry_id, author_id, content, created_at) VALUES
(
  2,
  (SELECT account_id FROM account WHERE login_id = 'hq_01' LIMIT 1),
  '발주가 오늘 오전에 승인되었습니다. 내일 오전 중으로 출고될 예정입니다.',
  '2026-04-21 13:00:00'
),
(
  1,
  (SELECT account_id FROM account WHERE login_id = 'hq_02' LIMIT 1),
  '키오스크 업체에 문의한 결과, 금일 오후 3시경 방문하여 점검할 예정이라고 합니다.',
  '2026-04-20 11:00:00'
),
(
  6,
  (SELECT account_id FROM account WHERE login_id = 'hq_01' LIMIT 1),
  '해당 카드사 연동 모듈 업데이트 후 시스템 재시작했습니다. 현재 정상 처리되는 것 확인했습니다. 다시 한번 테스트 부탁드립니다.',
  '2026-04-24 14:10:00'
),
(
  8,
  (SELECT account_id FROM account WHERE login_id = 'hq_01' LIMIT 1),
  '물류팀에 확인 결과, 해당 지역 배송 물량 증가로 지연이 있었습니다. 금일 중으로 배송 완료될 예정입니다. 불편을 드려 죄송합니다.',
  '2026-04-24 17:30:00'
),

(
  10,
  (SELECT account_id FROM account WHERE login_id = 'hq_02' LIMIT 1),
  '로그인 권한 캐시 초기화 후 정상 접속 확인되었습니다. 동일 문제가 발생하면 다시 문의 부탁드립니다.',
  '2026-04-25 12:32:00'
),
(
  11,
  (SELECT account_id FROM account WHERE login_id = 'hq_01' LIMIT 1),
  '발주 수량 수정 요청 반영 완료되었습니다. ERP에서 수정된 수량을 다시 확인해 주세요.',
  '2026-04-25 15:20:00'
),
(
  13,
  (SELECT account_id FROM account WHERE login_id = 'hq_03' LIMIT 1),
  '신규 직원 계정 생성 완료되었습니다. 초기 비밀번호는 000000으로 설정되었습니다.',
  '2026-04-26 15:18:00'
),
(
  14,
  (SELECT account_id FROM account WHERE login_id = 'hq_02' LIMIT 1),
  '시설관리팀에 전달 완료했으며 금일 오후 방문 점검 예정입니다.',
  '2026-04-27 09:52:00'
);

/* 1. [본사] 본사 물류창고 유통기한 경고 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('INVENTORY', '본사 물류창고 유통기한 경고', '본사 물류창고의 일부 재료 유통기한이 3일 이내로 남았습니다.', 'HQ_INVENTORY', 1, NOW() - INTERVAL 3 HOUR);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 1;


/* 2. [본사] 본사 물류창고 유통기한 긴급 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('INVENTORY', '본사 물류창고 유통기한 긴급', '본사 물류창고의 일부 재료 유통기한이 1일 이내로 남았습니다.', 'HQ_INVENTORY', 2, NOW() - INTERVAL 2 HOUR);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 1;


/* 3. [본사] 본사 물류창고 유통기한 만료 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('INVENTORY', '본사 물류창고 유통기한 만료', '본사 물류창고의 일부 재료 유통기한이 만료되었습니다.', 'HQ_INVENTORY', 3, NOW() - INTERVAL 1 HOUR);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 1;


/* 4. [지점] 강남점 재고 유통기한 경고 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('INVENTORY', '지점 재고 유통기한 경고', '강남점의 재고 중 유통기한이 3일 이내로 남은 재료가 있습니다.', 'BRANCH_INVENTORY', 11, NOW() - INTERVAL 50 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2001;


/* 5. [지점] 잠실점 재고 유통기한 긴급 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('INVENTORY', '지점 재고 유통기한 긴급', '잠실점의 재고 중 유통기한이 1일 이내로 남은 재료가 있습니다.', 'BRANCH_INVENTORY', 12, NOW() - INTERVAL 45 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2002;


/* 6. [지점] 사당점 재고 유통기한 만료 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('INVENTORY', '지점 재고 유통기한 만료', '사당점의 재고 중 유통기한이 만료된 재료가 있습니다.', 'BRANCH_INVENTORY', 13, NOW() - INTERVAL 40 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2003;


/* 7. [지점] 홍대점 재고 소진 알림 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('INVENTORY', '재고 소진 알림', '홍대점의 일부 재료 재고가 안전재고 이하입니다.', 'BRANCH_INVENTORY', 14, NOW() - INTERVAL 35 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2004;


/* 8. [본사] 강남점에서 발주 요청 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('ORDER', '발주 요청', '강남점에서 식자재 발주 요청을 보냈습니다.', 'ORDER', 101, NOW() - INTERVAL 30 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 1;


/* 9. [본사] 잠실점 입고 처리 완료 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('ORDER', '배송 완료', '잠실점에서 발주 건 입고 처리를 완료했습니다.', 'ORDER', 102, NOW() - INTERVAL 25 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read, read_at)
SELECT @notification_id, account_id, TRUE, NOW() - INTERVAL 20 MINUTE
FROM account
WHERE branch_code = 1;


/* 10. [지점] 강남점 발주 승인 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('ORDER', '발주 승인', '요청한 발주가 본사에 의해 승인되었습니다.', 'ORDER', 101, NOW() - INTERVAL 20 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2001;


/* 11. [지점] 사당점 발주 반려 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('ORDER', '발주 반려', '요청한 발주가 본사에 의해 반려되었습니다. 반려 사유를 확인해 주세요.', 'ORDER', 103, NOW() - INTERVAL 18 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2003;


/* 12. [지점] 홍대점 입고 처리 요청 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('ORDER', '입고 처리 요청', '본사에서 배송한 발주 건의 입고 처리가 필요합니다.', 'ORDER', 104, NOW() - INTERVAL 15 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2004;


/* 13. [지점] 강남점 -> 잠실점 스왑 요청 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('SWAP', '스왑 요청', '강남점에서 잠실점으로 식자재 스왑 요청을 보냈습니다.', 'SWAP', 201, NOW() - INTERVAL 12 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2002;


/* 14. [지점] 잠실점이 강남점 스왑 요청 승인 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('SWAP', '스왑 승인', '잠실점에서 보낸 스왑 요청을 승인했습니다.', 'SWAP', 201, NOW() - INTERVAL 10 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2001;


/* 15. [본사] 지점 문의사항 등록 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('BOARD', '문의사항 등록', '강남점에서 새로운 문의사항을 작성했습니다.', 'INQUIRY', 301, NOW() - INTERVAL 8 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 1;


/* 16. [지점 전체] 공지사항 등록 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('BOARD', '공지사항 등록', '본사에서 새로운 공지사항을 등록했습니다.', 'NOTICE', 401, NOW() - INTERVAL 6 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code <> 1;


/* 17. [지점] 문의사항 답변 완료 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('BOARD', '문의사항 답변 완료', '본인이 작성한 문의사항에 본사 답변이 등록되었습니다.', 'INQUIRY', 301, NOW() - INTERVAL 4 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code = 2001;


/* 18. [지점 전체] 레시피 등록 */
INSERT INTO notification (category, title, message, target_type, target_id, created_at) VALUES
('SYSTEM', '레시피 갱신', '본사에서 새로운 레시피를 등록했습니다. 최신 레시피를 확인해 주세요.', 'RECIPE', 501, NOW() - INTERVAL 2 MINUTE);

SET @notification_id = LAST_INSERT_ID();

INSERT INTO notification_receiver (notification_id, account_id, is_read)
SELECT @notification_id, account_id, FALSE
FROM account
WHERE branch_code <> 1;

-- ============================================================
-- 10. 스케줄
-- 본사 스케줄
-- ============================================================

INSERT INTO hq_schedule (emp_no, branch_code, start_day, end_day, memo, work_type)
VALUES
-- 4월
((SELECT emp_no FROM employee WHERE name = '문시우' AND branch_code = 1 LIMIT 1), 1, '2026-04-20', '2026-04-20', '휴가', 'OFF'),
((SELECT emp_no FROM employee WHERE name = '문시우' AND branch_code = 1 LIMIT 1), 1, '2026-04-22', '2026-04-22', '거래처 출장', 'BUSINESS_TRIP'),
((SELECT emp_no FROM employee WHERE name = '문시우' AND branch_code = 1 LIMIT 1), 1, '2026-04-24', '2026-04-25', '본사 교육 일정', 'TRAINING'),

((SELECT emp_no FROM employee WHERE name = '권유나' AND branch_code = 1 LIMIT 1), 1, '2026-04-27', '2026-04-27', '신규 직원 온보딩 교육', 'TRAINING'),

((SELECT emp_no FROM employee WHERE name = '임준서' AND branch_code = 1 LIMIT 1), 1, '2026-04-23', '2026-04-23', '직영점 운영 점검', 'VISIT'),
((SELECT emp_no FROM employee WHERE name = '임준서' AND branch_code = 1 LIMIT 1), 1, '2026-04-28', '2026-04-29', '서울권 운영 회의 출장', 'BUSINESS_TRIP'),

((SELECT emp_no FROM employee WHERE name = '정하율' AND branch_code = 1 LIMIT 1), 1, '2026-04-22', '2026-04-22', '운영 매뉴얼 교육', 'TRAINING'),
((SELECT emp_no FROM employee WHERE name = '조아린' AND branch_code = 1 LIMIT 1), 1, '2026-04-30', '2026-04-30', '휴가', 'OFF'),

-- 5월 1주차
((SELECT emp_no FROM employee WHERE name = '오민재' AND branch_code = 1 LIMIT 1), 1, '2026-05-06', '2026-05-06', '운영팀 직영점 방문', 'VISIT'),
((SELECT emp_no FROM employee WHERE name = '윤지후' AND branch_code = 1 LIMIT 1), 1, '2026-05-08', '2026-05-08', '운영 교육 참석', 'TRAINING'),

-- 5월 2주차
((SELECT emp_no FROM employee WHERE name = '임준서' AND branch_code = 1 LIMIT 1), 1, '2026-05-13', '2026-05-13', '강남점 운영 점검 방문', 'VISIT'),
((SELECT emp_no FROM employee WHERE name = '정하율' AND branch_code = 1 LIMIT 1), 1, '2026-05-14', '2026-05-15', '지점 관리자 교육', 'TRAINING'),

-- 5월 3주차
((SELECT emp_no FROM employee WHERE name = '배서율' AND branch_code = 1 LIMIT 1), 1, '2026-05-20', '2026-05-20', '잠실점 운영 점검 방문', 'VISIT'),
((SELECT emp_no FROM employee WHERE name = '차현우' AND branch_code = 1 LIMIT 1), 1, '2026-05-21', '2026-05-22', 'ERP 사용 교육 지원', 'TRAINING'),

-- 5월 4주차
((SELECT emp_no FROM employee WHERE name = '문시우' AND branch_code = 1 LIMIT 1), 1, '2026-05-25', '2026-05-26', '서울권 운영 회의 출장', 'BUSINESS_TRIP'),
((SELECT emp_no FROM employee WHERE name = '임준서' AND branch_code = 1 LIMIT 1), 1, '2026-05-28', '2026-05-28', '홍대점 운영 점검 방문', 'VISIT'),

-- 6월
((SELECT emp_no FROM employee WHERE name = '조아린' AND branch_code = 1 LIMIT 1), 1, '2026-06-02', '2026-06-02', '인사팀 내부 교육', 'TRAINING'),
((SELECT emp_no FROM employee WHERE name = '남도윤' AND branch_code = 1 LIMIT 1), 1, '2026-06-03', '2026-06-04', '서울권 지점 운영 점검 출장', 'BUSINESS_TRIP'),
((SELECT emp_no FROM employee WHERE name = '차현우' AND branch_code = 1 LIMIT 1), 1, '2026-06-05', '2026-06-05', '지점 관리자 화상 교육', 'TRAINING'),

((SELECT emp_no FROM employee WHERE name = '임준서' AND branch_code = 1 LIMIT 1), 1, '2026-06-09', '2026-06-09', '여의도점 운영 점검 방문', 'VISIT'),
((SELECT emp_no FROM employee WHERE name = '정하율' AND branch_code = 1 LIMIT 1), 1, '2026-06-11', '2026-06-12', '신규 메뉴 운영 교육', 'TRAINING');

-- 5~6월 지점 근무표 자동 생성
-- 필요하면 기존 5~6월 데이터 삭제 후 실행
-- DELETE FROM branch_schedule
-- WHERE work_date BETWEEN '2026-05-01' AND '2026-06-30';

INSERT INTO branch_schedule
(emp_no, branch_code, work_date, start_time, end_time, is_repeat, repeat_group_id, memo, work_type)

WITH RECURSIVE dates AS (
    SELECT DATE('2026-05-01') AS work_date
    UNION ALL
    SELECT DATE_ADD(work_date, INTERVAL 1 DAY)
    FROM dates
    WHERE work_date < '2026-06-30'
),
slots AS (
    SELECT 1 AS slot_no, 'OPEN' AS work_type, '08:00:00' AS start_time, '17:00:00' AS end_time
    UNION ALL SELECT 2, 'MIDDLE', '10:00:00', '19:00:00'
    UNION ALL SELECT 3, 'MIDDLE', '12:00:00', '21:00:00'
    UNION ALL SELECT 4, 'CLOSE', '14:00:00', '23:00:00'
),
emp_pool AS (
    SELECT
        e.emp_no,
        e.branch_code,
        e.position_code,
        ROW_NUMBER() OVER (
            PARTITION BY e.branch_code
            ORDER BY
                CASE e.position_code
                    WHEN 'POS_MGR' THEN 1
                    WHEN 'POS_SUP' THEN 2
                    WHEN 'POS_STF' THEN 3
                    WHEN 'POS_PTM' THEN 4
                    ELSE 5
                END,
                e.emp_no
        ) AS emp_idx,
        COUNT(*) OVER (PARTITION BY e.branch_code) AS emp_cnt
    FROM employee e
    WHERE e.branch_code <> 1
      AND e.status = 'ACTIVE'
),
schedule_base AS (
    SELECT
        b.branch_code,
        d.work_date,
        s.slot_no,
        s.work_type,
        s.start_time,
        s.end_time,
        ((DAYOFYEAR(d.work_date) + s.slot_no - 2) MOD ep.emp_cnt) + 1 AS target_emp_idx
    FROM branch b
    JOIN dates d
    JOIN slots s
    JOIN (
        SELECT branch_code, MAX(emp_cnt) AS emp_cnt
        FROM emp_pool
        GROUP BY branch_code
    ) ep ON ep.branch_code = b.branch_code
    WHERE b.branch_code <> 1
      AND b.status = 'ACTIVE'
      AND ep.emp_cnt >= 4
)
SELECT
    e.emp_no,
    sb.branch_code,
    sb.work_date,
    sb.start_time,
    sb.end_time,
    1 AS is_repeat,
    NULL AS repeat_group_id,
    CONCAT(
        b.name, ' ',
        CASE sb.work_type
            WHEN 'OPEN' THEN '오픈 근무'
            WHEN 'MIDDLE' THEN
                CASE sb.slot_no
                    WHEN 2 THEN '미들 근무 1'
                    ELSE '미들 근무 2'
                END
            WHEN 'CLOSE' THEN '마감 근무'
            ELSE '지점 근무'
        END
    ) AS memo,
    sb.work_type
FROM schedule_base sb
JOIN emp_pool e
    ON e.branch_code = sb.branch_code
   AND e.emp_idx = sb.target_emp_idx
JOIN branch b
    ON b.branch_code = sb.branch_code
ORDER BY sb.work_date, sb.branch_code, sb.slot_no;

-- ============================================================
-- 11. 물류
-- 서울권 배송기사 4명
-- driver는 GR_DRV 인원만 연결
-- ============================================================

INSERT INTO driver (emp_no, region_code, is_active) VALUES
((SELECT emp_no FROM employee WHERE name = '박건호' AND branch_code = 1 AND grade_code = 'GR_DRV' LIMIT 1), '02', TRUE),
((SELECT emp_no FROM employee WHERE name = '이재윤' AND branch_code = 1 AND grade_code = 'GR_DRV' LIMIT 1), '02', TRUE),
((SELECT emp_no FROM employee WHERE name = '최민규' AND branch_code = 1 AND grade_code = 'GR_DRV' LIMIT 1), '02', TRUE),
((SELECT emp_no FROM employee WHERE name = '김하람' AND branch_code = 1 AND grade_code = 'GR_DRV' LIMIT 1), '02', TRUE);

-- ============================================================
-- 11. 물류 차량
-- 서울권 차량 5대
-- ============================================================

INSERT INTO vehicle
(region_code, plate_number, capacity, temp_type, status, is_active)
VALUES
('02', '12가3456', 1000, '냉장',      'AVAILABLE',   TRUE),
('02', '23나4567', 2500, '냉동',      'AVAILABLE',   TRUE),
('02', '34다5678', 5000, '냉장/냉동', 'AVAILABLE',   TRUE),
('02', '45라6789', 2500, '냉장',      'IN_TRANSIT',  TRUE),
('02', '56마7890', 1000, '냉장/냉동', 'MAINTENANCE', TRUE);

-- ============================================================
-- 12. 공급사 (supplier) - 신규 테이블
-- ============================================================
INSERT INTO supplier (supplier_name) VALUES
('CJ푸드'),        -- 1
('서울유제품'),    -- 2
('농협유통'),      -- 3
('푸드코리아'),    -- 4
('오뚜기'),        -- 5
('미트원'),        -- 6
('롯데푸드'),      -- 7
('하림'),          -- 8
('씨푸드코리아'),  -- 9
('동원'),          -- 10
('계란유통'),      -- 11
('베지푸드'),      -- 12
('롯데제과'),      -- 13
('랩팩토리'),      -- 14
('스타음료'),      -- 15
('코카콜라'),      -- 16
('청정원'),        -- 17
('풀무원'),        -- 18
('신선채소유통'),  -- 19
('베이커리코리아'),-- 20
('소스팩토리');    -- 21

-- ============================================================
-- 본사 입고 (hq_inbound) - 오늘 기준 자동 더미
-- ============================================================
-- 모든 material에 대해 2개 lot 생성
-- 본사 입고: 재료 단위/그룹별로 수량 차등 생성
INSERT INTO hq_inbound
(supplier_id, received_at, material_code, qty, expiry_date)
SELECT 
    FLOOR(1 + RAND() * 21),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 10) DAY),
    m.material_code,

    CASE
        WHEN m.unit = 'g'  THEN FLOOR(800 + RAND() * 2200)   -- 800~2999g
        WHEN m.unit = 'ml' THEN FLOOR(1000 + RAND() * 3000)  -- 1000~3999ml
        WHEN m.unit = '장' THEN FLOOR(80 + RAND() * 170)     -- 80~249장
        WHEN m.unit = '개' THEN FLOOR(60 + RAND() * 160)     -- 60~219개
        ELSE FLOOR(100 + RAND() * 200)
    END,

    DATE_ADD(CURDATE(), INTERVAL FLOOR(-3 + RAND() * 25) DAY)
FROM material m

UNION ALL

SELECT 
    FLOOR(1 + RAND() * 21),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 20) DAY),
    m.material_code,

    CASE
        WHEN m.unit = 'g'  THEN FLOOR(500 + RAND() * 1800)   -- 500~2299g
        WHEN m.unit = 'ml' THEN FLOOR(800 + RAND() * 2500)   -- 800~3299ml
        WHEN m.unit = '장' THEN FLOOR(50 + RAND() * 130)     -- 50~179장
        WHEN m.unit = '개' THEN FLOOR(40 + RAND() * 120)     -- 40~159개
        ELSE FLOOR(80 + RAND() * 150)
    END,

    DATE_ADD(CURDATE(), INTERVAL FLOOR(1 + RAND() * 35) DAY)
FROM material m;

-- hq_inbound 기반 → warehouse_stock 자동 생성
INSERT INTO warehouse_stock (
    stock_no,
    material_code,
    hq_inbound_id,
    qty,
    received_at,
    expiry_date,
    status
)
SELECT
    CONCAT('STK-', LPAD(i.hq_inbound_id, 5, '0')),
    i.material_code,
    i.hq_inbound_id,
    i.qty,
    i.received_at,
    i.expiry_date,

    CASE
    WHEN i.expiry_date < CURDATE()
        THEN 'DISPOSED'

    WHEN i.qty <= 0
        THEN 'OUT_OF_STOCK'

    ELSE 'AVAILABLE'
END

FROM hq_inbound i;
 
-- ============================================================
-- 15. 본사 재고 변동 이력 (warehouse_stock_change_history)
-- ============================================================

-- 최초 입고 이력
INSERT INTO warehouse_stock_change_history
(stock_no, change_type, change_amount, after_qty, changed_at)
SELECT
    stock_no,
    'INBOUND',
    qty,
    qty,
    received_at
FROM warehouse_stock;


-- OUTBOUND 처리: 일부 재고 랜덤 출고
UPDATE warehouse_stock
SET qty = FLOOR(qty * 0.7)
WHERE status = 'AVAILABLE'
  AND qty > 0
  AND RAND() < 0.5;


-- OUTBOUND 이력 생성
INSERT INTO warehouse_stock_change_history
(stock_no, change_type, change_amount, after_qty, changed_at)
SELECT
    w.stock_no,
    'OUTBOUND',
    -(h.before_qty - w.qty),
    w.qty,
    NOW()
FROM warehouse_stock w
JOIN (
    SELECT
        stock_no,
        MAX(after_qty) AS before_qty
    FROM warehouse_stock_change_history
    GROUP BY stock_no
) h ON w.stock_no = h.stock_no
WHERE w.qty < h.before_qty
  AND w.qty > 0;


-- DISPOSAL 처리: 유통기한 만료 재고 폐기
UPDATE warehouse_stock
SET qty = 0,
    status = 'DISPOSED'
WHERE expiry_date < CURDATE()
  AND qty > 0;


-- DISPOSAL 이력 생성
INSERT INTO warehouse_stock_change_history
(stock_no, change_type, change_amount, after_qty, changed_at)
SELECT
    w.stock_no,
    'DISPOSAL',
    -h.before_qty,
    0,
    NOW()
FROM warehouse_stock w
JOIN (
    SELECT
        stock_no,
        MAX(after_qty) AS before_qty
    FROM warehouse_stock_change_history
    GROUP BY stock_no
) h ON w.stock_no = h.stock_no
WHERE w.status = 'DISPOSED'
  AND w.qty = 0
  AND h.before_qty > 0;


-- 최종 상태 보정
UPDATE warehouse_stock
SET status = CASE
    WHEN expiry_date < CURDATE() THEN 'DISPOSED'
    WHEN qty <= 0 THEN 'OUT_OF_STOCK'
    ELSE 'AVAILABLE'
END;

-- ============================================================
-- 16. 지점 발주서 (place_order)
-- 전국 지점 기준 더미 확장
-- ============================================================

-- ============================================================
-- 16. 지점 발주서 (place_order)
-- 서울 16지점 기준 더미
-- 지점별 2건씩 / 총 32건
-- ============================================================

INSERT INTO place_order
(po_no, branch_code, status, total_material_cnt, total_amount, reject_reason)
VALUES

-- 강남점 2001
('PO-20260507001', 2001, 'APPROVED', 3, 520000, NULL),
('PO-20260508001', 2001, 'PENDING',  4, 610000, NULL),

-- 잠실점 2002
('PO-20260507002', 2002, 'PENDING',  2, 310000, NULL),
('PO-20260508002', 2002, 'APPROVED', 3, 480000, NULL),

-- 사당점 2003
('PO-20260507003', 2003, 'APPROVED', 4, 680000, NULL),
('PO-20260508003', 2003, 'REJECTED', 2, 180000, '안전재고 충분'),

-- 홍대점 2004
('PO-20260507004', 2004, 'APPROVED', 3, 450000, NULL),
('PO-20260508004', 2004, 'PENDING',  3, 390000, NULL),

-- 합정점 2005
('PO-20260507005', 2005, 'REJECTED', 2, 180000, '최근 동일 발주 존재'),
('PO-20260508005', 2005, 'APPROVED', 4, 570000, NULL),

-- 신촌점 2006
('PO-20260507006', 2006, 'APPROVED', 2, 240000, NULL),
('PO-20260508006', 2006, 'PENDING',  3, 390000, NULL),

-- 마곡점 2007
('PO-20260507007', 2007, 'APPROVED', 4, 720000, NULL),
('PO-20260508007', 2007, 'PENDING',  3, 450000, NULL),

-- 종로점 2008
('PO-20260507008', 2008, 'PENDING',  2, 260000, NULL),
('PO-20260508008', 2008, 'APPROVED', 4, 640000, NULL),

-- 명동점 2009
('PO-20260507009', 2009, 'APPROVED', 3, 410000, NULL),
('PO-20260508009', 2009, 'REJECTED', 2, 210000, '최소 발주 수량 미달'),

-- 서울역점 2010
('PO-20260507010', 2010, 'PENDING',  2, 300000, NULL),
('PO-20260508010', 2010, 'APPROVED', 3, 420000, NULL),

-- 여의도점 2011
('PO-20260507011', 2011, 'APPROVED', 2, 280000, NULL),
('PO-20260508011', 2011, 'PENDING',  3, 340000, NULL),

-- 구로디지털점 2012
('PO-20260507012', 2012, 'REJECTED', 2, 160000, '재고 과다 보유'),
('PO-20260508012', 2012, 'APPROVED', 4, 530000, NULL),

-- 건대점 2013
('PO-20260507013', 2013, 'APPROVED', 2, 230000, NULL),
('PO-20260508013', 2013, 'PENDING',  3, 370000, NULL),

-- 왕십리점 2014
('PO-20260507014', 2014, 'APPROVED', 3, 360000, NULL),
('PO-20260508014', 2014, 'APPROVED', 2, 250000, NULL),

-- 서울숲점 2015
('PO-20260507015', 2015, 'PENDING',  4, 690000, NULL),
('PO-20260508015', 2015, 'APPROVED', 4, 620000, NULL),

-- 노원점 2016
('PO-20260507016', 2016, 'APPROVED', 3, 540000, NULL),
('PO-20260508016', 2016, 'PENDING',  2, 260000, NULL);

-- ============================================================
-- 17. 지점 발주 상세 (place_order_detail)
-- 지점 발주서 전체 대응
-- ============================================================

-- ============================================================
-- 17. 지점 발주 상세 (place_order_detail)
-- 서울 16지점 / place_order 32건 기준
-- po_id 1 ~ 32
-- ============================================================

INSERT INTO place_order_detail
(po_id, material_code, requested_qty, approved_qty, remaining_qty)
VALUES

-- 1. PO-20260507001 / 강남점 / APPROVED / 3개 품목
(1, 101, 1200, 1200, 0),
(1, 601, 2500, 2400, 100),
(1, 501, 800, 800, 0),

-- 2. PO-20260508001 / 강남점 / PENDING / 4개 품목
(2, 201, 180, NULL, NULL),
(2, 301, 3500, NULL, NULL),
(2, 306, 5000, NULL, NULL),
(2, 611, 2200, NULL, NULL),

-- 3. PO-20260507002 / 잠실점 / PENDING / 2개 품목
(3, 102, 1200, NULL, NULL),
(3, 402, 2400, NULL, NULL),

-- 4. PO-20260508002 / 잠실점 / APPROVED / 3개 품목
(4, 611, 4200, 4200, 0),
(4, 306, 5000, 4800, 200),
(4, 511, 1200, 1200, 0),

-- 5. PO-20260507003 / 사당점 / APPROVED / 4개 품목
(5, 201, 200, 200, 0),
(5, 408, 300, 300, 0),
(5, 801, 120, 120, 0),
(5, 802, 160, 160, 0),

-- 6. PO-20260508003 / 사당점 / REJECTED / 2개 품목
(6, 614, 1200, 0, 1200),
(6, 404, 1500, 0, 1500),

-- 7. PO-20260507004 / 홍대점 / APPROVED / 3개 품목
(7, 701, 150, 150, 0),
(7, 702, 80, 80, 0),
(7, 703, 100, 100, 0),

-- 8. PO-20260508004 / 홍대점 / PENDING / 3개 품목
(8, 601, 1800, NULL, NULL),
(8, 305, 2500, NULL, NULL),
(8, 306, 4000, NULL, NULL),

-- 9. PO-20260507005 / 합정점 / REJECTED / 2개 품목
(9, 501, 1800, 0, 1800),
(9, 510, 1600, 0, 1600),

-- 10. PO-20260508005 / 합정점 / APPROVED / 4개 품목
(10, 101, 1300, 1300, 0),
(10, 202, 240, 240, 0),
(10, 514, 500, 500, 0),
(10, 601, 1800, 1800, 0),

-- 11. PO-20260507006 / 신촌점 / APPROVED / 2개 품목
(11, 611, 2200, 2200, 0),
(11, 612, 2200, 2200, 0),

-- 12. PO-20260508006 / 신촌점 / PENDING / 3개 품목
(12, 601, 1800, NULL, NULL),
(12, 402, 1200, NULL, NULL),
(12, 306, 4000, NULL, NULL),

-- 13. PO-20260507007 / 마곡점 / APPROVED / 4개 품목
(13, 301, 4200, 4200, 0),
(13, 302, 3500, 3500, 0),
(13, 305, 2500, 2500, 0),
(13, 306, 4000, 4000, 0),

-- 14. PO-20260508007 / 마곡점 / PENDING / 3개 품목
(14, 801, 180, NULL, NULL),
(14, 802, 220, NULL, NULL),
(14, 803, 150, NULL, NULL),

-- 15. PO-20260507008 / 종로점 / PENDING / 2개 품목
(15, 701, 150, NULL, NULL),
(15, 710, 120, NULL, NULL),

-- 16. PO-20260508008 / 종로점 / APPROVED / 4개 품목
(16, 901, 80, 80, 0),
(16, 902, 70, 70, 0),
(16, 903, 50, 50, 0),
(16, 501, 1700, 1700, 0),

-- 17. PO-20260507009 / 명동점 / APPROVED / 3개 품목
(17, 602, 2500, 2500, 0),
(17, 603, 2500, 2400, 100),
(17, 604, 2500, 2500, 0),

-- 18. PO-20260508009 / 명동점 / REJECTED / 2개 품목
(18, 501, 2000, 0, 2000),
(18, 502, 1600, 0, 1600),

-- 19. PO-20260507010 / 서울역점 / PENDING / 2개 품목
(19, 611, 2200, NULL, NULL),
(19, 306, 4000, NULL, NULL),

-- 20. PO-20260508010 / 서울역점 / APPROVED / 3개 품목
(20, 614, 1500, 1500, 0),
(20, 404, 1200, 1200, 0),
(20, 501, 1700, 1700, 0),

-- 21. PO-20260507011 / 여의도점 / APPROVED / 2개 품목
(21, 101, 1200, 1200, 0),
(21, 102, 1200, 1200, 0),

-- 22. PO-20260508011 / 여의도점 / PENDING / 3개 품목
(22, 601, 2200, NULL, NULL),
(22, 201, 300, NULL, NULL),
(22, 501, 1700, NULL, NULL),

-- 23. PO-20260507012 / 구로디지털점 / REJECTED / 2개 품목
(23, 305, 2500, 0, 2500),
(23, 306, 4000, 0, 4000),

-- 24. PO-20260508012 / 구로디지털점 / APPROVED / 4개 품목
(24, 801, 150, 150, 0),
(24, 803, 150, 150, 0),
(24, 702, 120, 120, 0),
(24, 703, 100, 100, 0),

-- 25. PO-20260507013 / 건대점 / APPROVED / 2개 품목
(25, 611, 2200, 2200, 0),
(25, 510, 1600, 1600, 0),

-- 26. PO-20260508013 / 건대점 / PENDING / 3개 품목
(26, 701, 150, NULL, NULL),
(26, 712, 120, NULL, NULL),
(26, 713, 120, NULL, NULL),

-- 27. PO-20260507014 / 왕십리점 / APPROVED / 3개 품목
(27, 501, 1700, 1700, 0),
(27, 503, 1800, 1800, 0),
(27, 504, 1600, 1600, 0),

-- 28. PO-20260508014 / 왕십리점 / APPROVED / 2개 품목
(28, 614, 1500, 1500, 0),
(28, 615, 1800, 1800, 0),

-- 29. PO-20260507015 / 서울숲점 / PENDING / 4개 품목
(29, 101, 1200, NULL, NULL),
(29, 601, 2200, NULL, NULL),
(29, 306, 4000, NULL, NULL),
(29, 501, 1700, NULL, NULL),

-- 30. PO-20260508015 / 서울숲점 / APPROVED / 4개 품목
(30, 901, 60, 60, 0),
(30, 903, 50, 50, 0),
(30, 611, 2200, 2200, 0),
(30, 510, 1600, 1600, 0),

-- 31. PO-20260507016 / 노원점 / APPROVED / 3개 품목
(31, 601, 2200, 2200, 0),
(31, 201, 300, 300, 0),
(31, 501, 1700, 1700, 0),

-- 32. PO-20260508016 / 노원점 / PENDING / 2개 품목
(32, 801, 150, NULL, NULL),
(32, 802, 160, NULL, NULL);

-- ============================================================
-- 18. 배차 (dispatch)
-- 서울 16지점 발주 기준 배차 더미
-- APPROVED 발주 일부만 배차
-- ============================================================

-- 강남점 승인 발주 / 배송 중
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260507001', d.driver_id, v.vehicle_id, 'IN_TRANSIT'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '박건호'
  AND v.plate_number = '12가3456'
LIMIT 1;

-- 잠실점 승인 발주 / 배송 완료
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260508002', d.driver_id, v.vehicle_id, 'DELIVERED'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '이재윤'
  AND v.plate_number = '23나4567'
LIMIT 1;

-- 사당점 승인 발주 / 배차 대기
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260507003', d.driver_id, v.vehicle_id, 'HOLD'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '최민규'
  AND v.plate_number = '34다5678'
LIMIT 1;

-- 홍대점 승인 발주 / 배송 완료
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260507004', d.driver_id, v.vehicle_id, 'DELIVERED'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '김하람'
  AND v.plate_number = '12가3456'
LIMIT 1;

-- 종로점 승인 발주 / 배송 중
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260508008', d.driver_id, v.vehicle_id, 'IN_TRANSIT'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '박건호'
  AND v.plate_number = '45라6789'
LIMIT 1;

-- 서울역점 승인 발주 / 배송 완료
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260508010', d.driver_id, v.vehicle_id, 'DELIVERED'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '이재윤'
  AND v.plate_number = '34다5678'
LIMIT 1;

-- 왕십리점 승인 발주 / 배차 대기
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260508014', d.driver_id, v.vehicle_id, 'HOLD'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '최민규'
  AND v.plate_number = '23나4567'
LIMIT 1;

-- 서울숲점 승인 발주 / 배송 완료
INSERT INTO dispatch
(po_no, driver_id, vehicle_id, status)
SELECT 'PO-20260508015', d.driver_id, v.vehicle_id, 'DELIVERED'
FROM driver d
JOIN employee e ON e.emp_no = d.emp_no
JOIN vehicle v ON v.region_code = d.region_code
WHERE e.name = '김하람'
  AND v.plate_number = '12가3456'
LIMIT 1;

-- ============================================================
-- 19. 본사 출고 (hq_outbound)
-- 서울 16지점 승인 발주 기준 출고 더미
-- APPROVED 발주만 출고 생성
-- ============================================================

INSERT INTO hq_outbound
(po_no, branch_code, status, handler, shipped_at)
VALUES

-- 강남점
('PO-20260507001', 2001, 'SHIPPED',   '문시우', '2026-05-07 09:10:00'),

-- 잠실점
('PO-20260508002', 2002, 'SHIPPED',   '임준서', '2026-05-08 10:20:00'),

-- 사당점
('PO-20260507003', 2003, 'PREPARING', '정하율', NULL),

-- 홍대점
('PO-20260507004', 2004, 'SHIPPED',   '차현우', '2026-05-07 11:00:00'),

-- 합정점
('PO-20260508005', 2005, 'PREPARING', '문시우', NULL),

-- 신촌점
('PO-20260507006', 2006, 'SHIPPED',   '임준서', '2026-05-07 13:30:00'),

-- 마곡점
('PO-20260507007', 2007, 'PENDING',   '정하율', NULL),

-- 종로점
('PO-20260508008', 2008, 'SHIPPED',   '차현우', '2026-05-08 09:40:00'),

-- 명동점
('PO-20260507009', 2009, 'PREPARING', '문시우', NULL),

-- 서울역점
('PO-20260508010', 2010, 'SHIPPED',   '임준서', '2026-05-08 14:10:00'),

-- 여의도점
('PO-20260507011', 2011, 'PENDING',   '정하율', NULL),

-- 구로디지털점
('PO-20260508012', 2012, 'SHIPPED',   '차현우', '2026-05-08 15:20:00'),

-- 건대점
('PO-20260507013', 2013, 'PREPARING', '문시우', NULL),

-- 왕십리점
('PO-20260507014', 2014, 'SHIPPED',   '임준서', '2026-05-07 16:00:00'),
('PO-20260508014', 2014, 'PENDING',   '정하율', NULL),

-- 서울숲점
('PO-20260508015', 2015, 'SHIPPED',   '차현우', '2026-05-08 16:30:00'),

-- 노원점
('PO-20260507016', 2016, 'PREPARING', '문시우', NULL);

-- ============================================================
-- 20. 본사 출고 상세 (hq_outbound_detail)
-- SHIPPED 상태의 hq_outbound 기준 상세 생성
-- stock_no는 warehouse_stock에서 material_code 기준으로 안전하게 선택
-- qty 조건 제거: 랜덤 재고 수량 부족으로 stock_no NULL 방지
-- ============================================================

-- outbound 1 / PO-20260507001 / 강남점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(1, (SELECT stock_no FROM warehouse_stock WHERE material_code = 101 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1200),
(1, (SELECT stock_no FROM warehouse_stock WHERE material_code = 601 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 2400),
(1, (SELECT stock_no FROM warehouse_stock WHERE material_code = 501 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 800);

-- outbound 2 / PO-20260508002 / 잠실점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(2, (SELECT stock_no FROM warehouse_stock WHERE material_code = 611 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 4200),
(2, (SELECT stock_no FROM warehouse_stock WHERE material_code = 306 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 4800),
(2, (SELECT stock_no FROM warehouse_stock WHERE material_code = 511 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1200);

-- outbound 4 / PO-20260507004 / 홍대점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(4, (SELECT stock_no FROM warehouse_stock WHERE material_code = 701 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 150),
(4, (SELECT stock_no FROM warehouse_stock WHERE material_code = 702 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 80),
(4, (SELECT stock_no FROM warehouse_stock WHERE material_code = 703 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 100);

-- outbound 6 / PO-20260507006 / 신촌점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(6, (SELECT stock_no FROM warehouse_stock WHERE material_code = 611 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 2200),
(6, (SELECT stock_no FROM warehouse_stock WHERE material_code = 612 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 2200);

-- outbound 8 / PO-20260508008 / 종로점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(8, (SELECT stock_no FROM warehouse_stock WHERE material_code = 901 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 80),
(8, (SELECT stock_no FROM warehouse_stock WHERE material_code = 902 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 70),
(8, (SELECT stock_no FROM warehouse_stock WHERE material_code = 903 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 50),
(8, (SELECT stock_no FROM warehouse_stock WHERE material_code = 501 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1700);

-- outbound 10 / PO-20260508010 / 서울역점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(10, (SELECT stock_no FROM warehouse_stock WHERE material_code = 614 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1500),
(10, (SELECT stock_no FROM warehouse_stock WHERE material_code = 404 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1200),
(10, (SELECT stock_no FROM warehouse_stock WHERE material_code = 501 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1700);

-- outbound 12 / PO-20260508012 / 구로디지털점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(12, (SELECT stock_no FROM warehouse_stock WHERE material_code = 801 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 150),
(12, (SELECT stock_no FROM warehouse_stock WHERE material_code = 803 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 150),
(12, (SELECT stock_no FROM warehouse_stock WHERE material_code = 702 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 120),
(12, (SELECT stock_no FROM warehouse_stock WHERE material_code = 703 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 100);

-- outbound 14 / PO-20260507014 / 왕십리점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(14, (SELECT stock_no FROM warehouse_stock WHERE material_code = 501 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1700),
(14, (SELECT stock_no FROM warehouse_stock WHERE material_code = 503 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1800),
(14, (SELECT stock_no FROM warehouse_stock WHERE material_code = 504 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1600);

-- outbound 16 / PO-20260508015 / 서울숲점
INSERT INTO hq_outbound_detail (hq_outbound_no, stock_no, qty)
VALUES
(16, (SELECT stock_no FROM warehouse_stock WHERE material_code = 901 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 60),
(16, (SELECT stock_no FROM warehouse_stock WHERE material_code = 903 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 50),
(16, (SELECT stock_no FROM warehouse_stock WHERE material_code = 611 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 2200),
(16, (SELECT stock_no FROM warehouse_stock WHERE material_code = 510 ORDER BY status = 'AVAILABLE' DESC, qty DESC LIMIT 1), 1600);

-- ============================================================
-- 21. 지점 재고 (branch_stock)
-- 서울 16지점 기준
-- 지점별 전체 material 재고 생성
-- 유통기한은 현재 날짜 기준으로 생성
-- 대부분 정상 / 일부 임박만 포함
-- ============================================================

INSERT INTO branch_stock (
    branch_stock_code,
    branch_code,
    material_code,
    expire_date,
    received_at,
    current_qty
)
SELECT
    CONCAT('B-STK-', b.branch_code, '-', m.material_code) AS branch_stock_code,
    b.branch_code,
    m.material_code,

    /* =========================
       유통기한
       - 만료 재고는 기본 생성하지 않음
       - 일부만 1~3일 임박
       - 대부분은 15~60일 정상 재고
       ========================= */
    CASE
        -- 강남/잠실/사당: 시연 핵심 지점, 대부분 정상
        WHEN b.branch_code IN (2001, 2002, 2003) THEN
            CASE
                WHEN m.material_code % 25 = 0 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)
                WHEN m.material_code % 25 IN (1, 2) THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)
                WHEN m.material_code % 25 IN (3, 4, 5) THEN DATE_ADD(CURDATE(), INTERVAL 7 DAY)
                WHEN m.material_code % 25 IN (6, 7, 8, 9, 10) THEN DATE_ADD(CURDATE(), INTERVAL 15 DAY)
                ELSE DATE_ADD(CURDATE(), INTERVAL 45 DAY)
            END

        -- 홍대/합정/신촌/마곡: 일부 임박, 대부분 정상
        WHEN b.branch_code IN (2004, 2005, 2006, 2007) THEN
            CASE
                WHEN m.material_code % 30 = 0 THEN DATE_ADD(CURDATE(), INTERVAL 1 DAY)
                WHEN m.material_code % 30 IN (1, 2, 3) THEN DATE_ADD(CURDATE(), INTERVAL 4 DAY)
                WHEN m.material_code % 30 IN (4, 5, 6, 7) THEN DATE_ADD(CURDATE(), INTERVAL 10 DAY)
                WHEN m.material_code % 30 IN (8, 9, 10, 11, 12) THEN DATE_ADD(CURDATE(), INTERVAL 20 DAY)
                ELSE DATE_ADD(CURDATE(), INTERVAL 50 DAY)
            END

        -- 종로/명동/서울역: 재료 단위별 차등
        WHEN b.branch_code IN (2008, 2009, 2010) THEN
            CASE
                WHEN m.unit = '장' THEN DATE_ADD(CURDATE(), INTERVAL 5 + (m.material_code % 10) DAY)
                WHEN m.unit = 'g' THEN DATE_ADD(CURDATE(), INTERVAL 7 + (m.material_code % 15) DAY)
                WHEN m.unit = 'ml' THEN DATE_ADD(CURDATE(), INTERVAL 30 + (m.material_code % 40) DAY)
                ELSE DATE_ADD(CURDATE(), INTERVAL 15 + (m.material_code % 25) DAY)
            END

        -- 여의도/구로디지털: 업무지구권, 안정적인 유통기한
        WHEN b.branch_code IN (2011, 2012) THEN
            CASE
                WHEN m.unit = 'g' AND m.material_code % 20 = 0 THEN DATE_ADD(CURDATE(), INTERVAL 3 DAY)
                WHEN m.unit = 'g' THEN DATE_ADD(CURDATE(), INTERVAL 12 + (m.material_code % 15) DAY)
                WHEN m.unit = 'ml' THEN DATE_ADD(CURDATE(), INTERVAL 45 + (m.material_code % 45) DAY)
                WHEN m.unit = '장' THEN DATE_ADD(CURDATE(), INTERVAL 7 + (m.material_code % 10) DAY)
                ELSE DATE_ADD(CURDATE(), INTERVAL 20 + (m.material_code % 25) DAY)
            END

        -- 건대/왕십리/서울숲/노원: 일부 임박, 대부분 장기
        WHEN b.branch_code IN (2013, 2014, 2015, 2016) THEN
            CASE
                WHEN m.material_code % 35 = 0 THEN DATE_ADD(CURDATE(), INTERVAL 2 DAY)
                WHEN m.material_code % 35 IN (1, 2, 3) THEN DATE_ADD(CURDATE(), INTERVAL 5 DAY)
                WHEN m.material_code % 35 IN (4, 5, 6, 7) THEN DATE_ADD(CURDATE(), INTERVAL 12 DAY)
                WHEN m.material_code % 35 IN (8, 9, 10, 11, 12) THEN DATE_ADD(CURDATE(), INTERVAL 25 DAY)
                ELSE DATE_ADD(CURDATE(), INTERVAL 60 DAY)
            END

        ELSE DATE_ADD(CURDATE(), INTERVAL 30 DAY)
    END AS expire_date,

    /* =========================
       입고일
       - 현재 기준 과거 입고일로 자연스럽게 생성
       ========================= */
    CASE
        WHEN b.branch_code IN (2001, 2002, 2003) THEN DATE_SUB(NOW(), INTERVAL (m.material_code % 7) DAY)
        WHEN b.branch_code IN (2004, 2005, 2006, 2007) THEN DATE_SUB(NOW(), INTERVAL (m.material_code % 9) DAY)
        WHEN b.branch_code IN (2008, 2009, 2010) THEN DATE_SUB(NOW(), INTERVAL (m.material_code % 11) DAY)
        WHEN b.branch_code IN (2011, 2012) THEN DATE_SUB(NOW(), INTERVAL (m.material_code % 13) DAY)
        WHEN b.branch_code IN (2013, 2014, 2015, 2016) THEN DATE_SUB(NOW(), INTERVAL (m.material_code % 15) DAY)
        ELSE NOW()
    END AS received_at,

    /* 초기값은 0 → 이후 23번 UPDATE로 수량 세팅 */
    0 AS current_qty

FROM branch b
CROSS JOIN material m
WHERE b.status = 'ACTIVE'
  AND b.branch_code <> 1;

-- ============================================================
-- 22. 안전재고 생성
-- 시연용 넉넉한 안전재고
-- 발주 후 입고까지의 리드타임 동안 판매 가능한 수량 기준
-- ============================================================

INSERT INTO branch_material_safety_stock (
    branch_code,
    material_code,
    safe_stock_qty
)
SELECT
    b.branch_code,
    m.material_code,
    CASE
        -- 빵: 샌드위치 기본 재료라 넉넉하게
        WHEN m.material_group_id = 1 THEN 180

        -- 치즈: 장 단위, 선택률 높음
        WHEN m.material_group_id = 2 THEN 220

        -- 야채: g 단위, 샌드위치/샐러드 공통 사용
        WHEN m.material_group_id = 3 THEN 5000

        -- 추가재료: 유료 옵션, 부족하면 옵션 선택 제한됨
        WHEN m.material_group_id = 4 AND m.unit = 'g' THEN 3000
        WHEN m.material_group_id = 4 AND m.unit = '개' THEN 180

        -- 소스: ml/g 단위, 거의 모든 샌드위치/샐러드에 사용
        WHEN m.material_group_id = 5 AND m.unit = 'ml' THEN 3500
        WHEN m.material_group_id = 5 AND m.unit = 'g' THEN 800

        -- 육류: 핵심 메뉴 재료, 가장 넉넉하게
        WHEN m.material_group_id = 6 AND m.unit = 'g' THEN 6000
        WHEN m.material_group_id = 6 AND m.unit = '개' THEN 150

        -- 사이드: 개 단위
        WHEN m.material_group_id = 7 THEN 120

        -- 음료: 개 단위
        WHEN m.material_group_id = 8 THEN 150

        -- 수프: 개 단위
        WHEN m.material_group_id = 9 THEN 100

        ELSE 100
    END AS safe_stock_qty
FROM branch b
CROSS JOIN material m
LEFT JOIN branch_material_safety_stock ss
    ON ss.branch_code = b.branch_code
   AND ss.material_code = m.material_code
WHERE b.status = 'ACTIVE'
  AND ss.material_code IS NULL
  AND b.branch_code <> 1;

-- ============================================================
-- 23. 재고 수량 세팅
-- 대부분 정상/넉넉, 일부만 부족 상태
-- ============================================================

-- 전체 기본 재고 넉넉하게 세팅
UPDATE branch_stock bs
JOIN branch_material_safety_stock ss
    ON ss.branch_code = bs.branch_code
   AND ss.material_code = bs.material_code
SET bs.current_qty = FLOOR(ss.safe_stock_qty * (3 + RAND() * 3));


-- 일부 5%만 부족 상태
UPDATE branch_stock bs
JOIN branch_material_safety_stock ss
    ON ss.branch_code = bs.branch_code
   AND ss.material_code = bs.material_code
SET bs.current_qty = GREATEST(
    FLOOR(ss.safe_stock_qty * (0.5 + RAND() * 0.4)),
    1
)
WHERE RAND() < 0.05;


-- 일부 1~2%만 품절 상태
UPDATE branch_stock
SET current_qty = 0
WHERE RAND() < 0.015;


-- ============================================================
-- 시연용 특정 재료 부족 상태 강제 세팅
-- 키오스크/재고 부족/발주 흐름 테스트용
-- ============================================================

-- 강남점, 잠실점, 홍대점의 핵심 재료 일부를 낮게 설정
UPDATE branch_stock
SET current_qty = FLOOR(10 + RAND() * 40)
WHERE material_code IN (601, 611, 306, 501)
  AND branch_code IN (2001, 2002, 2004);


-- 사당점, 노원점의 특정 추가재료/육류 품절 처리
UPDATE branch_stock
SET current_qty = 0
WHERE material_code IN (402, 614)
  AND branch_code IN (2003, 2016);

-- ============================================================
-- 24. 본사 출고 → 지점 입고 헤더 자동 생성
-- SHIPPED 출고건만 지점 입고 처리
-- ============================================================

INSERT INTO branch_stock_inbound
(hq_outbound_no, branch_code, received_at)
SELECT
    hq_outbound_no,
    branch_code,
    DATE_ADD(shipped_at, INTERVAL 2 HOUR)
FROM hq_outbound
WHERE status = 'SHIPPED';


-- ============================================================
-- 24-1. 본사 출고 → 지점 입고 상세 자동 생성
-- ============================================================

INSERT INTO branch_stock_inbound_detail
(inbound_id, hq_outbound_detail_id, qty, branch_stock_code)
SELECT
    bsi.inbound_id,
    hod.hq_outbound_detail_id,
    hod.qty,
    CONCAT('B-STK-', bsi.branch_code, '-', ws.material_code)
FROM branch_stock_inbound bsi
JOIN hq_outbound ho
    ON ho.hq_outbound_no = bsi.hq_outbound_no
JOIN hq_outbound_detail hod
    ON hod.hq_outbound_no = ho.hq_outbound_no
JOIN warehouse_stock ws
    ON ws.stock_no = hod.stock_no;
    
-- ============================================================
-- 24-2. 지점 입고 수량을 branch_stock 현재 재고에 반영
-- ============================================================

UPDATE branch_stock bs
JOIN (
    SELECT
        branch_stock_code,
        SUM(qty) AS inbound_qty
    FROM branch_stock_inbound_detail
    GROUP BY branch_stock_code
) x
    ON x.branch_stock_code = bs.branch_stock_code
SET bs.current_qty = bs.current_qty + x.inbound_qty;

-- ============================================================
-- 25. 지점 재고 변동 이력
-- branch_stock 현재 재고 기준 최초 이력 생성
-- ============================================================

INSERT INTO branch_stock_change_history
(branch_stock_code, change_amount, change_type, after_qty, changed_at)
SELECT
    branch_stock_code,
    current_qty,
    'INBOUND',
    current_qty,
    received_at
FROM branch_stock
WHERE current_qty > 0;


-- ============================================================
-- 25-1. 유통기한 만료 재고 폐기 대상 고정
-- 만료 재고 중 일부를 완전 폐기 처리
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_branch_disposal_full;

CREATE TEMPORARY TABLE tmp_branch_disposal_full AS
SELECT
    branch_stock_code,
    current_qty AS before_qty,
    0 AS after_qty,
    NOW() - INTERVAL FLOOR(1 + RAND() * 48) HOUR AS changed_at
FROM branch_stock
WHERE expire_date < CURDATE()
  AND current_qty > 0
  AND RAND() < 0.3;


-- DISPOSAL 이력 생성
INSERT INTO branch_stock_change_history
(branch_stock_code, change_amount, change_type, after_qty, changed_at)
SELECT
    branch_stock_code,
    -before_qty,
    'DISPOSAL',
    after_qty,
    changed_at
FROM tmp_branch_disposal_full;


-- 실제 재고 수량 반영
UPDATE branch_stock bs
JOIN tmp_branch_disposal_full t
    ON t.branch_stock_code = bs.branch_stock_code
SET bs.current_qty = t.after_qty;


-- ============================================================
-- 25-2. 일부 재고 조정 폐기 대상 고정
-- 품질 불량 / 파손 / 일부 폐기 상황용
-- ============================================================

DROP TEMPORARY TABLE IF EXISTS tmp_branch_disposal_partial;

CREATE TEMPORARY TABLE tmp_branch_disposal_partial AS
SELECT
    branch_stock_code,
    current_qty AS before_qty,
    FLOOR(current_qty * 0.9) AS after_qty,
    NOW() - INTERVAL FLOOR(1 + RAND() * 72) HOUR AS changed_at
FROM branch_stock
WHERE current_qty > 0
  AND RAND() < 0.05;


-- 일부 재고 조정 이력 생성
INSERT INTO branch_stock_change_history
(branch_stock_code, change_amount, change_type, after_qty, changed_at)
SELECT
    branch_stock_code,
    -(before_qty - after_qty),
    'DISPOSAL',
    after_qty,
    changed_at
FROM tmp_branch_disposal_partial
WHERE before_qty > after_qty;


-- 실제 재고 수량 반영
UPDATE branch_stock bs
JOIN tmp_branch_disposal_partial t
    ON t.branch_stock_code = bs.branch_stock_code
SET bs.current_qty = t.after_qty
WHERE t.before_qty > t.after_qty;

-- ============================================================
-- 26. 지점 재고 폐기 이력
-- DISPOSAL change_id 기준 자동 생성
-- ============================================================

INSERT INTO branch_stock_disposal_history
(change_id, reason, reason_detail)
SELECT
    bsch.change_id,

    CASE MOD(bsch.change_id, 3)
        WHEN 0 THEN 'EXPIRED'
        WHEN 1 THEN 'DAMAGED'
        ELSE 'ETC'
    END AS reason,

    CASE MOD(bsch.change_id, 6)
        WHEN 0 THEN '유통기한 초과'
        WHEN 1 THEN '냉장 보관 불량'
        WHEN 2 THEN '포장 파손'
        WHEN 3 THEN '재고 실사 후 폐기'
        WHEN 4 THEN '운송 중 훼손'
        ELSE '기타 폐기 처리'
    END AS reason_detail
FROM branch_stock_change_history bsch
LEFT JOIN branch_stock_disposal_history bsdh
    ON bsdh.change_id = bsch.change_id
WHERE bsch.change_type = 'DISPOSAL'
  AND bsdh.change_id IS NULL;

-- ============================================================
-- 27. 지점 간 스왑 (material_swap)
-- 서울 16지점 기준
-- 가까운 거리 / 중간 거리 / 먼 거리 스왑 섞어서 구성
-- ============================================================

INSERT INTO material_swap
(req_branch_code, res_branch_code, material_code, qty, status, req_date)
VALUES

-- ============================================================
-- 가까운 거리 스왑
-- 홍대 ↔ 합정, 건대 ↔ 서울숲, 종로 ↔ 명동
-- ============================================================

(2004, 2005, 301, 1500, 'PENDING',   '2026-05-07 09:00:00'), -- 홍대점 → 합정점 / 피클
(2005, 2004, 601, 1200, 'APPROVED',  '2026-05-07 09:30:00'), -- 합정점 → 홍대점 / 잠봉 햄
(2013, 2015, 101,   40, 'COMPLETED', '2026-05-07 10:00:00'), -- 건대점 → 서울숲점 / 플랫
(2015, 2013, 201,   80, 'PENDING',   '2026-05-07 10:15:00'), -- 서울숲점 → 건대점 / 슈레드 치즈
(2008, 2009, 402,  600, 'APPROVED',  '2026-05-07 11:00:00'), -- 종로점 → 명동점 / 베이컨
(2009, 2008, 501, 1200, 'COMPLETED', '2026-05-07 11:30:00'), -- 명동점 → 종로점 / 랜치

-- ============================================================
-- 중간 거리 스왑
-- 강남 ↔ 사당, 여의도 ↔ 홍대, 잠실 ↔ 건대
-- ============================================================

(2001, 2003, 701,   25, 'PENDING',   '2026-05-07 12:00:00'), -- 강남점 → 사당점 / 초코칩
(2003, 2001, 801,   30, 'APPROVED',  '2026-05-07 13:00:00'), -- 사당점 → 강남점 / 커피
(2011, 2004, 408,   20, 'COMPLETED', '2026-05-07 13:45:00'), -- 여의도점 → 홍대점 / 에그 슬라이스
(2004, 2011, 404,  800, 'PENDING',   '2026-05-07 14:20:00'), -- 홍대점 → 여의도점 / 아보카도
(2002, 2013, 310, 1800, 'APPROVED',  '2026-05-07 15:00:00'), -- 잠실점 → 건대점 / 머쉬룸
(2013, 2002, 102,   50, 'COMPLETED', '2026-05-07 16:00:00'), -- 건대점 → 잠실점 / 위트

-- ============================================================
-- 먼 거리 스왑
-- 마곡 ↔ 잠실, 노원 ↔ 구로디지털, 서울역 ↔ 노원
-- ============================================================

(2007, 2002, 611, 1500, 'PENDING',   '2026-05-07 16:30:00'), -- 마곡점 → 잠실점 / 닭다리살
(2002, 2007, 602, 1200, 'APPROVED',  '2026-05-07 17:00:00'), -- 잠실점 → 마곡점 / 안창살
(2016, 2012, 802,   40, 'COMPLETED', '2026-05-07 17:30:00'), -- 노원점 → 구로디지털점 / 콜라
(2012, 2016, 305, 1800, 'PENDING',   '2026-05-07 18:00:00'), -- 구로디지털점 → 노원점 / 토마토
(2010, 2016, 614, 1000, 'APPROVED',  '2026-05-07 18:30:00'), -- 서울역점 → 노원점 / 새우
(2016, 2010, 803,   35, 'COMPLETED', '2026-05-07 19:00:00'); -- 노원점 → 서울역점 / 사이다


SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

SELECT '✅ zeroloss 더미 데이터 입력 완료!' AS result;