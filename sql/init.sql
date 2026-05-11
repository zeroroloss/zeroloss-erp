DROP DATABASE IF EXISTS zeroloss;
CREATE DATABASE zeroloss;
USE zeroloss;

SET FOREIGN_KEY_CHECKS = 0;
SET NAMES UTF8MB4;

START TRANSACTION;

-- ============================================================
-- 1. 독립 테이블
-- ============================================================

CREATE TABLE region (
    region_code VARCHAR(20) NOT NULL,
    name        VARCHAR(50) NOT NULL,
    PRIMARY KEY (region_code),
    UNIQUE KEY uq_region_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지역 관리';

CREATE TABLE role (
    role_id   INT         NOT NULL,
    role_name VARCHAR(20) NOT NULL,
    PRIMARY KEY (role_id),
    UNIQUE KEY uq_role_name (role_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='권한';

CREATE TABLE grade (
    grade_code  VARCHAR(20) NOT NULL,
    grade_name  VARCHAR(50) NOT NULL,
    grade_order INT         NOT NULL,
    PRIMARY KEY (grade_code),
    CONSTRAINT chk_grade_code CHECK (grade_code IN ('GR_DIR','GR_DPT','GR_MGR','GR_AST','GR_STF','GR_DRV','GR_CEO'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='직급';

CREATE TABLE `position` (
    position_code  VARCHAR(20) NOT NULL,
    position_name  VARCHAR(50) NOT NULL,
    position_level INT         NOT NULL,
    PRIMARY KEY (position_code),
    CONSTRAINT chk_position_code CHECK (position_code IN ('POS_MGR','POS_SUP','POS_STF','POS_PTM'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 역할';

CREATE TABLE material_group (
    material_group_id INT          NOT NULL AUTO_INCREMENT,
    group_name        VARCHAR(100) NOT NULL,
    group_min         INT          NOT NULL,
    group_max         INT          NOT NULL,
    PRIMARY KEY (material_group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='재료 그룹';

CREATE TABLE supplier (
    supplier_id   INT         NOT NULL AUTO_INCREMENT,
    supplier_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (supplier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공급사';


-- ============================================================
-- 2. 1단계 의존 테이블
-- ============================================================

CREATE TABLE branch (
    branch_code INT          NOT NULL,
    region_code VARCHAR(20)  NOT NULL,
    name        VARCHAR(100) NOT NULL,
    address     VARCHAR(255),
    lat         DECIMAL(10, 7) NULL COMMENT '위도',
    lng         DECIMAL(11, 7) NULL COMMENT '경도',
    phone       VARCHAR(20),
    status      VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (branch_code),
    CONSTRAINT fk_branch_region FOREIGN KEY (region_code) REFERENCES region(region_code),
    CONSTRAINT chk_branch_status CHECK (status IN ('ACTIVE','INACTIVE','CLOSED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점';

CREATE TABLE material (
    material_code     VARCHAR(50)  NOT NULL,
    material_group_id INT          NOT NULL,
    material_name     VARCHAR(100) NOT NULL,
    material_price    INT          NOT NULL,
    price             INT,
    deduct_qty        INT, 
    unit              VARCHAR(20)  NOT NULL,
    
    PRIMARY KEY (material_code),
    CONSTRAINT fk_material_group FOREIGN KEY (material_group_id) REFERENCES material_group(material_group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='재료';


-- ============================================================
-- 3. 2단계 의존 테이블
-- ============================================================

CREATE TABLE hq (
    hq_id       INT         NOT NULL AUTO_INCREMENT,
    branch_code INT         NOT NULL,
    address     VARCHAR(255),
    phone       VARCHAR(20),
    region_code VARCHAR(20) NOT NULL,
    PRIMARY KEY (hq_id),
    CONSTRAINT fk_hq_branch FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT fk_hq_region FOREIGN KEY (region_code) REFERENCES region(region_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='본사';

CREATE TABLE employee (
    emp_no        INT          NOT NULL AUTO_INCREMENT,
    branch_code   INT          NOT NULL,
    dept          VARCHAR(20)      NULL,
    grade_code    VARCHAR(20)      NULL,
    position_code VARCHAR(20)      NULL,
    name          VARCHAR(50)  NOT NULL,
    phone         VARCHAR(20)  NOT NULL,
    email         VARCHAR(255) NOT NULL,
    hire_date     DATE         NOT NULL,
    status        VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (emp_no),
    CONSTRAINT fk_emp_branch   FOREIGN KEY (branch_code)   REFERENCES branch(branch_code),
    CONSTRAINT fk_emp_grade    FOREIGN KEY (grade_code)    REFERENCES grade(grade_code),
    CONSTRAINT fk_emp_position FOREIGN KEY (position_code) REFERENCES `position`(position_code),
    CONSTRAINT chk_emp_status  CHECK (status IN ('ACTIVE','LEAVE','RESIGNED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='직원';

CREATE TABLE main_category (
    category_id INT         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50) NOT NULL,
    is_active   BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메인 카테고리';

CREATE TABLE sub_category (
    sub_category_code VARCHAR(20) NOT NULL,
    main_category_id  INT         NOT NULL,
    name              VARCHAR(50) NOT NULL,
    PRIMARY KEY (sub_category_code),
    CONSTRAINT fk_subcat_maincat FOREIGN KEY (main_category_id) REFERENCES main_category(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='서브 카테고리';

CREATE TABLE category_material_group (
    ca_ma_id          INT NOT NULL AUTO_INCREMENT,
    category_id       INT,
    material_group_id INT,
    PRIMARY KEY (ca_ma_id),
    CONSTRAINT fk_cmg_category FOREIGN KEY (category_id)       REFERENCES main_category(category_id),
    CONSTRAINT fk_cmg_group    FOREIGN KEY (material_group_id) REFERENCES material_group(material_group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='카테고리-재료그룹 매핑';

CREATE TABLE recipe (
    recipe_code       VARCHAR(50) NOT NULL,
    category_id       INT         NOT NULL,
    sub_category_code VARCHAR(20) NOT NULL,
    name              VARCHAR(50) NOT NULL,
    price             INT         NOT NULL,
    instruction       TEXT,
    img_url           VARCHAR(255),
    is_active         BOOLEAN     NOT NULL DEFAULT TRUE,
    cost              INT                  DEFAULT 0,
    PRIMARY KEY (recipe_code),
    CONSTRAINT fk_recipe_category     FOREIGN KEY (category_id)       REFERENCES main_category(category_id),
    CONSTRAINT fk_recipe_sub_category FOREIGN KEY (sub_category_code) REFERENCES sub_category(sub_category_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='레시피';

CREATE TABLE recipe_detail (
    recipe_detail_id INT         NOT NULL AUTO_INCREMENT,
    recipe_code      VARCHAR(50) NOT NULL,
    material_code    VARCHAR(50) NOT NULL,
    required_qty     INT NOT NULL,
    PRIMARY KEY (recipe_detail_id),
    CONSTRAINT fk_rdetail_recipe    FOREIGN KEY (recipe_code)   REFERENCES recipe(recipe_code) ON DELETE CASCADE,
    CONSTRAINT fk_rdetail_material  FOREIGN KEY (material_code) REFERENCES material(material_code),
    CONSTRAINT chk_required_qty     CHECK (required_qty > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='레시피 상세';

CREATE TABLE material_order_limit (
    mo_limit_id   INT           NOT NULL AUTO_INCREMENT,
    material_code VARCHAR(50)   NOT NULL,
    min_qty       INT NOT NULL,
    max_qty       INT NOT NULL,
    PRIMARY KEY (mo_limit_id),
    CONSTRAINT fk_mol_material FOREIGN KEY (material_code) REFERENCES material(material_code),
    CONSTRAINT chk_mol_min CHECK (min_qty >= 0),
    CONSTRAINT chk_mol_max CHECK (max_qty >= min_qty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='품목별 발주 수량 설정';

CREATE TABLE kiosk (
    kiosk_id    INT NOT NULL AUTO_INCREMENT,
    branch_code INT NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'NORMAL',
    start_seq   INT,
    PRIMARY KEY (kiosk_id),
    CONSTRAINT fk_kiosk_branch  FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT chk_kiosk_status CHECK (status IN ('NORMAL','ERROR'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='키오스크 장비';

CREATE TABLE kiosk_banner (
    banner_id INT          NOT NULL AUTO_INCREMENT,
    kiosk_id  INT          NOT NULL,
    media_url VARCHAR(255) NOT NULL,
    is_active BOOLEAN      NOT NULL DEFAULT TRUE,
    PRIMARY KEY (banner_id),
    CONSTRAINT fk_banner_kiosk FOREIGN KEY (kiosk_id) REFERENCES kiosk(kiosk_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='키오스크 배너';

CREATE TABLE driver (
    driver_id   INT         NOT NULL AUTO_INCREMENT,
    emp_no      INT         NOT NULL,
    region_code VARCHAR(20) NOT NULL,
    is_active   BOOLEAN     NOT NULL DEFAULT TRUE,
    PRIMARY KEY (driver_id),
    UNIQUE KEY uq_driver_emp (emp_no),
    CONSTRAINT fk_driver_emp FOREIGN KEY (emp_no) REFERENCES employee(emp_no),
    CONSTRAINT fk_driver_region FOREIGN KEY (region_code) REFERENCES region(region_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='배송 기사';

CREATE TABLE vehicle (
    vehicle_id   INT         NOT NULL AUTO_INCREMENT,
    region_code  VARCHAR(20) NOT NULL,
    plate_number VARCHAR(20) NOT NULL,
    capacity     INT         NOT NULL COMMENT '크기/적재용량 (kg 단위, 1톤=1000)',
    temp_type    VARCHAR(20) NOT NULL DEFAULT '일반' COMMENT '온도 (냉장, 냉동, 냉장/냉동, 일반)',
    status       VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE' COMMENT '차량 상태',
    is_active    BOOLEAN     NOT NULL DEFAULT TRUE,
    
    PRIMARY KEY (vehicle_id),
    UNIQUE KEY uq_plate_number (plate_number),
    CONSTRAINT fk_vehicle_region FOREIGN KEY (region_code) REFERENCES region(region_code),
    CONSTRAINT chk_vehicle_status CHECK (status IN ('AVAILABLE', 'IN_TRANSIT', 'MAINTENANCE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='차량';

CREATE TABLE hq_inbound (
    hq_inbound_id INT           NOT NULL AUTO_INCREMENT,
    supplier_id   INT           NOT NULL,
    received_at   DATETIME      NOT NULL,
    material_code VARCHAR(50)   NOT NULL,
    qty           INT NOT NULL,
    expiry_date   DATE          NOT NULL,
    PRIMARY KEY (hq_inbound_id),
    CONSTRAINT fk_hqin_supplier FOREIGN KEY (supplier_id)   REFERENCES supplier(supplier_id),
    CONSTRAINT fk_hqin_material FOREIGN KEY (material_code) REFERENCES material(material_code),
    CONSTRAINT chk_hqin_qty     CHECK (qty > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='본사 입고';


-- ============================================================
-- 4. 3단계 의존 테이블
-- ============================================================

CREATE TABLE account (
    account_id   INT          NOT NULL AUTO_INCREMENT,
    emp_no       INT          NOT NULL,
    branch_code  INT              NULL,
    hq_id        INT              NULL,
    role_id      INT          NOT NULL,
    login_id     VARCHAR(50)  NOT NULL,
    password     VARCHAR(255) NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login_at DATETIME,
    PRIMARY KEY (account_id),
    UNIQUE KEY uq_emp_no   (emp_no),
    UNIQUE KEY uq_login_id (login_id),
    CONSTRAINT fk_account_emp    FOREIGN KEY (emp_no)      REFERENCES employee(emp_no),
    CONSTRAINT fk_account_branch FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT fk_account_hq     FOREIGN KEY (hq_id)       REFERENCES hq(hq_id),
    CONSTRAINT fk_account_role   FOREIGN KEY (role_id)     REFERENCES role(role_id),
    CONSTRAINT chk_account_status CHECK (status IN ('ACTIVE','INACTIVE','LOCKED')),
    CONSTRAINT chk_account_scope  CHECK (
        (branch_code = 1 AND hq_id IS NOT NULL) OR
        (branch_code IS NOT NULL AND hq_id IS NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='계정';

CREATE TABLE orders (
    order_id     VARCHAR(255) NOT NULL,       
    branch_code  INT          NOT NULL,
    kiosk_id     INT          NOT NULL,
    order_type   VARCHAR(20)  NOT NULL,
    total_amount INT          NOT NULL DEFAULT 0,
    status       VARCHAR(25)  NOT NULL DEFAULT 'PREPARING', 
    order_date   DATE         NOT NULL DEFAULT (CURRENT_DATE),
    created_at   TIME         NOT NULL DEFAULT (CURRENT_TIME),
    PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_branch FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT fk_orders_kiosk  FOREIGN KEY (kiosk_id)    REFERENCES kiosk(kiosk_id),
    CONSTRAINT chk_orders_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_orders_status CHECK (status IN ('PREPARING','PAID','FAIL','CANCEL')),
    CONSTRAINT chk_orders_type   CHECK (order_type IN ('HERE','TOGO'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='주문';

CREATE TABLE warehouse_stock (
    id            INT           NOT NULL AUTO_INCREMENT,
    stock_no      VARCHAR(30)   NOT NULL,
    material_code VARCHAR(50)   NOT NULL,
    hq_inbound_id INT           NOT NULL,
    qty           INT NOT NULL DEFAULT 0,
    received_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiry_date   DATE,
    status        ENUM('AVAILABLE','DISPOSED','OUT_OF_STOCK') NOT NULL DEFAULT 'AVAILABLE',
    PRIMARY KEY (id),
    UNIQUE KEY uk_stock_no (stock_no),
    CONSTRAINT fk_wstock_material  FOREIGN KEY (material_code)  REFERENCES material(material_code),
    CONSTRAINT fk_wstock_hqinbound FOREIGN KEY (hq_inbound_id) REFERENCES hq_inbound(hq_inbound_id),
    CONSTRAINT chk_wstock_qty      CHECK (qty >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='본사 재고';

CREATE TABLE place_order (
    po_id               INT           NOT NULL AUTO_INCREMENT,
    po_no               VARCHAR(30)   NOT NULL,
    branch_code         INT           NOT NULL,
    status              ENUM('PENDING','APPROVED','REJECTED','CANCELED','DELIVERED','COMPLETED') NOT NULL DEFAULT 'PENDING',
    
    total_material_cnt  INT           NOT NULL,
    total_amount        INT           NOT NULL DEFAULT 0,
    request_date        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reject_reason       VARCHAR(50),
    PRIMARY KEY (po_id),
    UNIQUE KEY uq_po_no (po_no),
    CONSTRAINT fk_po_branch  FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT chk_po_amount CHECK (total_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 발주서';


-- ============================================================
-- 5. 4단계 의존 테이블
-- ============================================================

CREATE TABLE notification (
    notification_id INT NOT NULL AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    message VARCHAR(500) NOT NULL,
    target_type VARCHAR(50),
    target_id INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (notification_id),
    CONSTRAINT chk_notif_ctg  CHECK (category  IN ('INVENTORY', 'ORDER', 'SWAP', 'BOARD', 'SYSTEM'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='알림';


CREATE TABLE notification_receiver (
    notification_receiver_id INT NOT NULL AUTO_INCREMENT,
    notification_id INT NOT NULL,
    account_id INT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at DATETIME NULL,
    PRIMARY KEY (notification_receiver_id),
    CONSTRAINT fk_notif_id FOREIGN KEY (notification_id) REFERENCES notification(notification_id) ON DELETE CASCADE,
    CONSTRAINT fk_notif_acc FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='알림수신';

CREATE TABLE notice (
    notice_id  INT          NOT NULL AUTO_INCREMENT,
    author_id  INT          NOT NULL,
    title      VARCHAR(200) NOT NULL,
    content    TEXT         NOT NULL,
    `type`     VARCHAR(20)  NOT NULL DEFAULT '일반 공지',
    last_date  DATETIME,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    view_count INT          NOT NULL DEFAULT 0,
    is_pinned  BOOLEAN      NOT NULL DEFAULT FALSE,
    PRIMARY KEY (notice_id),
    CONSTRAINT fk_notice_author FOREIGN KEY (author_id) REFERENCES account(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공지사항';

CREATE TABLE inquiry (
    inquiry_id INT          NOT NULL AUTO_INCREMENT,
    branch_code INT         NOT NULL,
    title      VARCHAR(200) NOT NULL,
    content    TEXT         NOT NULL,
    category   VARCHAR(20)  NOT NULL,
    urgency    VARCHAR(10)  NOT NULL DEFAULT '일반',
    status     VARCHAR(20)  NOT NULL DEFAULT '대기 중',
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME,
    PRIMARY KEY (inquiry_id),
    CONSTRAINT fk_inquiry_branch   FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT chk_inquiry_status  CHECK (status  IN ('대기 중','처리 중','답변 완료')),
    CONSTRAINT chk_inquiry_urgency CHECK (urgency IN ('일반','긴급'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='문의';

CREATE TABLE order_menu (
    order_menu_id     INT          NOT NULL AUTO_INCREMENT,
    order_id          VARCHAR(255) NOT NULL,       
    recipe_code       VARCHAR(50)  NOT NULL,
    qty               INT          NOT NULL,
    unit_price        INT          NOT NULL,
    line_total_amount INT          NOT NULL,
    multiplier        INT          NOT NULL DEFAULT 1,
    PRIMARY KEY (order_menu_id),
    CONSTRAINT fk_omenu_order  FOREIGN KEY (order_id)    REFERENCES orders(order_id),
    CONSTRAINT fk_omenu_recipe FOREIGN KEY (recipe_code) REFERENCES recipe(recipe_code),
    CONSTRAINT chk_omenu_qty   CHECK (qty > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='주문 메뉴';

CREATE TABLE hq_schedule (
    schedule_id INT         NOT NULL AUTO_INCREMENT,
    emp_no      INT         NOT NULL,
    branch_code INT         NOT NULL,
    start_day   DATE			 NOT NULL,
    end_day     DATE 		 NOT NULL,
    memo        TEXT                          COMMENT '메모',
    work_type   VARCHAR(20) NOT NULL,
    PRIMARY KEY (schedule_id),
    CONSTRAINT fk_hq_schedule_emp    FOREIGN KEY (emp_no)      REFERENCES employee(emp_no),
    CONSTRAINT fk_hq_schedule_branch FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT chk_hq_schedule_day CHECK (end_day >= start_day),
    CONSTRAINT chk_hq_schedule_work_type   CHECK (work_type IN (
        'VISIT','TRAINING','BUSINESS_TRIP','OFF','ETC'
    ))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='본사스케줄';

CREATE TABLE branch_schedule (
    schedule_id INT         NOT NULL AUTO_INCREMENT,
    emp_no      INT         NOT NULL,
    branch_code INT         NOT NULL,
    work_date   DATE        NOT NULL,
    start_time  TIME        NOT NULL,
    end_time    TIME        NOT NULL,
    is_repeat   TINYINT     NOT NULL DEFAULT 1 COMMENT '1:반복없음, 2:매주반복, 3:매월반복',
    repeat_group_id VARCHAR(50) NULL,
	 memo        TEXT                          COMMENT '메모',
    work_type   VARCHAR(20) NOT NULL,
    PRIMARY KEY (schedule_id),
    CONSTRAINT fk_branch_schedule_emp    FOREIGN KEY (emp_no)      REFERENCES employee(emp_no),
    CONSTRAINT fk_branch_schedule_branch FOREIGN KEY (branch_code) REFERENCES branch(branch_code),
    CONSTRAINT chk_branch_schedule_time  CHECK (end_time > start_time),
    CONSTRAINT chk_branch_schedule_repeat CHECK (is_repeat IN (1, 2, 3)),
    CONSTRAINT chk_branch_schedule_work_type CHECK (work_type IN (
        'OPEN','MIDDLE','CLOSE','ETC'
    ))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='직영점스케줄';

-- hq_outbound는 place_order 생성 후 선언
CREATE TABLE hq_outbound (
    hq_outbound_no INT         NOT NULL AUTO_INCREMENT,
    po_no          VARCHAR(30) NOT NULL,
    branch_code    INT         NOT NULL,
    status         ENUM('PENDING','PREPARING','SHIPPED') NOT NULL DEFAULT 'PENDING',
    handler        VARCHAR(20),
    shipped_at     DATETIME,
    PRIMARY KEY (hq_outbound_no),
    CONSTRAINT fk_hqout_po     FOREIGN KEY (po_no)       REFERENCES place_order(po_no),
    CONSTRAINT fk_hqout_branch FOREIGN KEY (branch_code) REFERENCES branch(branch_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='본사 출고';

-- dispatch도 place_order 생성 후 선언
CREATE TABLE dispatch (
    delivery_id INT         NOT NULL AUTO_INCREMENT,
    po_no       VARCHAR(30) NOT NULL,
    driver_id   INT         NOT NULL,
    vehicle_id  INT         NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'HOLD',
    PRIMARY KEY (delivery_id),
    CONSTRAINT fk_dispatch_po      FOREIGN KEY (po_no)      REFERENCES place_order(po_no),
    CONSTRAINT fk_dispatch_driver  FOREIGN KEY (driver_id)  REFERENCES driver(driver_id),
    CONSTRAINT fk_dispatch_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id),
    CONSTRAINT chk_dispatch_status CHECK (status IN ('HOLD','IN_TRANSIT','DELIVERED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='배차';

CREATE TABLE branch_stock (
    branch_stock_id   INT           NOT NULL AUTO_INCREMENT,
    branch_stock_code VARCHAR(30),
    branch_code       INT           NOT NULL,
    material_code     VARCHAR(50)   NOT NULL,
    expire_date       DATE,
    received_at       DATETIME      NOT NULL,
    current_qty       INT NOT NULL DEFAULT 0,
    PRIMARY KEY (branch_stock_id),
    UNIQUE KEY uq_branch_stock_code (branch_stock_code),
    CONSTRAINT fk_bstock_branch   FOREIGN KEY (branch_code)   REFERENCES branch(branch_code),
    CONSTRAINT fk_bstock_material FOREIGN KEY (material_code) REFERENCES material(material_code),
    CONSTRAINT chk_bstock_qty     CHECK (current_qty >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 재고';

CREATE TABLE branch_material_safety_stock (
    branch_code   INT           NOT NULL,
    material_code VARCHAR(50)   NOT NULL,
    safe_stock_qty INT NOT NULL DEFAULT 0,
    PRIMARY KEY (branch_code, material_code),
    CONSTRAINT fk_safety_branch   FOREIGN KEY (branch_code)   REFERENCES branch(branch_code),
    CONSTRAINT fk_safety_material FOREIGN KEY (material_code) REFERENCES material(material_code),
    CONSTRAINT chk_safety_qty     CHECK (safe_stock_qty >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 안전재고';

CREATE TABLE material_swap (
    swap_id         INT           NOT NULL AUTO_INCREMENT,
    req_branch_code INT           NOT NULL,
    res_branch_code INT           NOT NULL,
    material_code   VARCHAR(50)   NOT NULL,
    qty             INT NOT NULL,
    status          VARCHAR(20)   NOT NULL DEFAULT 'PENDING',
    req_date        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    res_date        DATETIME      NULL,
    PRIMARY KEY (swap_id),
    CONSTRAINT fk_swap_req_branch FOREIGN KEY (req_branch_code) REFERENCES branch(branch_code),
    CONSTRAINT fk_swap_res_branch FOREIGN KEY (res_branch_code) REFERENCES branch(branch_code),
    CONSTRAINT fk_swap_material   FOREIGN KEY (material_code)   REFERENCES material(material_code),
    CONSTRAINT chk_swap_status    CHECK (status IN ('PENDING','APPROVED','REJECTED','COMPLETED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 간 스왑';

-- ============================================================
-- 6. 5단계 의존 테이블
-- ============================================================

CREATE TABLE warehouse_stock_change_history (
    change_history_id INT           NOT NULL AUTO_INCREMENT,
    stock_no          VARCHAR(30)   NOT NULL,
    changed_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    change_type       ENUM('INBOUND','OUTBOUND','ADJUST','DISPOSAL') NOT NULL,
    change_amount     INT NOT NULL,
    after_qty         INT NOT NULL,
    PRIMARY KEY (change_history_id),
    CONSTRAINT fk_wsch_stock    FOREIGN KEY (stock_no) REFERENCES warehouse_stock(stock_no),
    CONSTRAINT chk_wsch_after_qty CHECK (after_qty >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='본사 재고 변동 이력';

CREATE TABLE inquiry_reply (
    reply_id   INT  NOT NULL AUTO_INCREMENT,
    inquiry_id INT  NOT NULL,
    author_id  INT  NOT NULL,
    content    TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (reply_id),
    CONSTRAINT fk_reply_inquiry FOREIGN KEY (inquiry_id) REFERENCES inquiry(inquiry_id) ON DELETE CASCADE,
    CONSTRAINT fk_reply_author  FOREIGN KEY (author_id)  REFERENCES account(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='문의 답변';

CREATE TABLE order_option (
    order_option_id INT         NOT NULL AUTO_INCREMENT,
    order_menu_id   INT         NOT NULL,
    material_code   VARCHAR(50) NOT NULL,
    extra_price     INT         NOT NULL DEFAULT 0,
    PRIMARY KEY (order_option_id),
    CONSTRAINT fk_oopt_omenu    FOREIGN KEY (order_menu_id)  REFERENCES order_menu(order_menu_id),
    CONSTRAINT fk_oopt_material FOREIGN KEY (material_code) REFERENCES material(material_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='주문 옵션';

CREATE TABLE hq_outbound_detail (
    hq_outbound_detail_id INT           NOT NULL AUTO_INCREMENT,
    hq_outbound_no        INT           NOT NULL,
    stock_no              VARCHAR(30)   NOT NULL,
    qty                   INT NOT NULL,
    PRIMARY KEY (hq_outbound_detail_id),
    CONSTRAINT fk_hqoutd_outbound FOREIGN KEY (hq_outbound_no) REFERENCES hq_outbound(hq_outbound_no),
    CONSTRAINT fk_hqoutd_stock    FOREIGN KEY (stock_no)       REFERENCES warehouse_stock(stock_no),
    CONSTRAINT chk_hqoutd_qty     CHECK (qty > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='본사 출고 상세';

CREATE TABLE place_order_detail (
    po_detail_id  INT           NOT NULL AUTO_INCREMENT,
    po_id         INT           NOT NULL,
    material_code VARCHAR(50)   NOT NULL,
    requested_qty INT NOT NULL,
    approved_qty  INT,
    remaining_qty INT,
    PRIMARY KEY (po_detail_id),
    CONSTRAINT fk_pod_po       FOREIGN KEY (po_id)         REFERENCES place_order(po_id),
    CONSTRAINT fk_pod_material FOREIGN KEY (material_code) REFERENCES material(material_code),
    CONSTRAINT chk_pod_req_qty       CHECK (requested_qty > 0),
    CONSTRAINT chk_pod_approved_qty  CHECK (approved_qty  IS NULL OR approved_qty  >= 0),
    CONSTRAINT chk_pod_remaining_qty CHECK (remaining_qty IS NULL OR remaining_qty >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 발주 상세';

CREATE TABLE branch_stock_change_history (
    change_id         INT           NOT NULL AUTO_INCREMENT,
    branch_stock_code VARCHAR(30)   NOT NULL,
    change_amount     INT NOT NULL,
    change_type       ENUM('INBOUND','EXCHANGEIN','EXCHANGEOUT','DISPOSAL') NOT NULL,
    changed_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    after_qty         INT NOT NULL,
    PRIMARY KEY (change_id),
    CONSTRAINT fk_change_stock FOREIGN KEY (branch_stock_code) REFERENCES branch_stock(branch_stock_code),
    CONSTRAINT chk_after_qty   CHECK (after_qty >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 재고 변동 이력';

CREATE TABLE branch_stock_inbound (
    inbound_id     INT      NOT NULL AUTO_INCREMENT,
    hq_outbound_no INT      NOT NULL,
    branch_code    INT      NOT NULL,
    received_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (inbound_id),
    CONSTRAINT fk_inbound_outbound FOREIGN KEY (hq_outbound_no) REFERENCES hq_outbound(hq_outbound_no),
    CONSTRAINT fk_inbound_branch   FOREIGN KEY (branch_code)    REFERENCES branch(branch_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 입고';


-- ============================================================
-- 7. 6단계 의존 테이블
-- ============================================================

CREATE TABLE branch_stock_disposal_history (
    disposal_id INT  NOT NULL AUTO_INCREMENT,
    change_id   INT  NOT NULL,
    reason      ENUM('EXPIRED','DAMAGED','ETC') NOT NULL COMMENT '폐기 사유',
    reason_detail VARCHAR(100),
    PRIMARY KEY (disposal_id),
    CONSTRAINT fk_disposal_change FOREIGN KEY (change_id) REFERENCES branch_stock_change_history(change_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 재고 폐기 이력';

CREATE TABLE branch_stock_inbound_detail (
    inbound_detail_id     INT           NOT NULL AUTO_INCREMENT,
    inbound_id            INT           NOT NULL,
    hq_outbound_detail_id INT           NOT NULL,
    qty                   INT NOT NULL,
    branch_stock_code     VARCHAR(30)   NOT NULL,
    PRIMARY KEY (inbound_detail_id),
    CONSTRAINT fk_inbound_detail_inbound         FOREIGN KEY (inbound_id)            REFERENCES branch_stock_inbound(inbound_id) ON DELETE CASCADE,
    CONSTRAINT fk_inbound_detail_outbound_detail FOREIGN KEY (hq_outbound_detail_id) REFERENCES hq_outbound_detail(hq_outbound_detail_id),
    CONSTRAINT fk_inbound_detail_stock           FOREIGN KEY (branch_stock_code)     REFERENCES branch_stock(branch_stock_code),
    CONSTRAINT chk_inbound_detail_qty            CHECK (qty > 0),
    CONSTRAINT uq_inbound_detail_outbound_detail UNIQUE (hq_outbound_detail_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='지점 입고 상세';

CREATE TABLE place_order_draft (
    draft_id      INT NOT NULL AUTO_INCREMENT,
    branch_code   INT NOT NULL,

    status        ENUM('IN_PROGRESS','COMPLETED','ABANDONED') NOT NULL DEFAULT 'IN_PROGRESS',

    po_id         INT NULL,

    created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (draft_id),

    CONSTRAINT fk_draft_branch
        FOREIGN KEY (branch_code) REFERENCES branch(branch_code),

    CONSTRAINT fk_draft_po
        FOREIGN KEY (po_id) REFERENCES place_order(po_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='발주 임시 저장';

CREATE TABLE place_order_draft_detail (
	draft_detail_id INT NOT NULL AUTO_INCREMENT,
	draft_id        INT NOT NULL,
	
	material_code   VARCHAR(50) NOT NULL,
	requested_qty   INT NOT NULL DEFAULT 0,
	
	source_type     ENUM('LOW_STOCK','MANUAL') NOT NULL,
	
	PRIMARY KEY (draft_detail_id),
	UNIQUE KEY uq_draft_material (draft_id, material_code),
	
	CONSTRAINT fk_draft_detail_draft
		FOREIGN KEY (draft_id) REFERENCES place_order_draft(draft_id)
		ON DELETE CASCADE,
	
	CONSTRAINT fk_draft_detail_material
		FOREIGN KEY (material_code) REFERENCES material(material_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='발주 임시 상세';



SET FOREIGN_KEY_CHECKS = 1;

COMMIT;

SELECT '✅ zeroloss DDL v4 생성 완료 (FK 순서 정렬)' AS result;