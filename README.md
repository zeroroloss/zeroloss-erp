# 🌿 ZEROLOSS 프랜차이즈 ERP

> 본사와 지점을 연결하는 제로로스 프랜차이즈 운영 관리 시스템

📅 개발 기간 : 2025.04.16 ~ 2025.05.11  
👨‍👩‍👧‍👦 팀원 : 5명

<div align="center">

![Java](https://img.shields.io/badge/Java_11-007396?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Servlet](https://img.shields.io/badge/Servlet-6DB33F?style=for-the-badge)
![MyBatis](https://img.shields.io/badge/MyBatis-000000?style=for-the-badge)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)
![Tomcat](https://img.shields.io/badge/Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)

</div>

---

# 📌 프로젝트 소개

**ZEROLOSS ERP**는  
프랜차이즈 운영 전반을 관리하기 위한 **본사-지점 통합 ERP 시스템**입니다.

본사에서는 지점 관리, 인사, 배송, 발주 처리, 재고 조정, 레시피/자재 관리, 공지 및 고객 문의 대응을 수행할 수 있고,  
지점에서는 입고, 발주 요청, 매출/재고 관리, 교환, 레시피 조회, 지원 업무를 처리할 수 있습니다.

또한 키오스크 주문 데이터와 연동되어 주문과 재고 흐름을 하나의 운영 체계 안에서 관리할 수 있도록 구성했습니다.

---

# 🎬 시연 영상

> 시연 영상 링크를 프로젝트 자료에 맞게 추가하면 됩니다.

---

# 🖥 화면 미리보기

프로젝트 화면 캡처를 아래 항목에 맞춰 추가하면 좋습니다.

- 본사 메인
- 지점 메인
- 발주 처리
- 재고 관리

---

# 📖 주요 기능

## 기능 요약

| 구분 | 핵심 기능 |
|---|---|
| 로그인/권한 | 본사, 지점 계정 분기 및 메뉴 제어 |
| 본사 운영 | 지점 관리, 발주 승인/반려, 출고, 창고, 인사, 공지, 문의 관리 |
| 지점 운영 | 입고, 재고, 매출, 발주 요청, 교환, 고객지원 처리 |
| 발주/출고 | 승인 수량 기준 출고 생성, FIFO 재고 차감, 이력 저장 |
| 키오스크 연동 | 주문, 결제, 상태 정보를 ERP 재고 흐름과 연결 |

---

# 📖 사용 메뉴얼

## 1️⃣ 로그인 방법

1. `common/login.jsp`에서 공통 로그인 화면으로 접속합니다.
2. 본사 계정 또는 지점 계정을 선택하고 아이디와 비밀번호를 입력합니다.
3. 로그인 후 계정 권한에 맞는 메인 화면으로 이동합니다.
4. 접근 권한이 없는 메뉴는 표시되지 않거나 접근이 제한됩니다.

## 2️⃣ 공통 사용 순서

1. 메인 화면에서 오늘의 상태와 공지사항을 먼저 확인합니다.
2. 필요한 업무 메뉴로 이동합니다.
3. 조회 화면에서는 검색 조건을 입력하고 목록을 확인합니다.
4. 상세 화면에서는 승인, 저장, 반려, 수정 같은 처리 작업을 수행합니다.
5. 작업 완료 후에는 목록으로 돌아가 처리 결과를 다시 확인합니다.

## 3️⃣ 본사 계정 사용 메뉴얼

본사 계정은 지점 전체를 관리하는 관리자 역할입니다. 요청을 검토하고, 승인과 조정, 출고, 공지 처리까지 이어지는 흐름으로 사용합니다.

### 3-1. 본사 메인 화면

- 전체 지점의 상태를 요약해서 확인합니다.
- 발주 대기 건수, 매출 요약, 재고 흐름 같은 운영 지표를 먼저 봅니다.
- 바로 처리해야 할 업무가 있으면 해당 메뉴로 이동합니다.

### 3-2. 지점 관리

- 지점 목록을 조회하고 상세 정보를 확인합니다.
- 지점 상태를 통해 운영 가능 여부나 관리 대상 여부를 파악합니다.
- 지점별 정보를 검색해서 필요한 대상만 빠르게 찾습니다.

### 3-3. 발주 승인 및 출고 처리

- 지점에서 등록한 발주 요청을 확인합니다.
- 요청 상세에서 품목별 요청 수량과 승인 수량을 검토합니다.
- 승인 가능한 수량은 조정한 뒤 승인 처리합니다.
- 반려가 필요한 경우 사유를 입력하고 반려 처리합니다.
- 승인 처리 후에는 출고 헤더와 출고 상세가 생성되며, 창고 재고가 차감됩니다.
- 출고 완료 후에는 재고 이력과 처리 결과를 다시 확인합니다.

### 3-4. 배송 및 창고 관리

- 본사 창고의 입출고 현황을 확인합니다.
- 재고 부족 품목을 점검하고 지점 배분이나 출고 우선순위를 조정합니다.
- 배송 관련 목록에서 처리 진행 상태를 확인합니다.

### 3-5. 인사, 레시피, 지원 관리

- 본사 인사 메뉴에서 직원 정보를 관리합니다.
- 레시피와 자재 기준을 확인해 지점 운영 기준을 통일합니다.
- 공지사항과 문의를 관리해 각 지점에 전달해야 할 내용을 공유합니다.

## 4️⃣ 지점 계정 사용 메뉴얼

지점 계정은 매장 운영에 필요한 요청과 현장 처리를 중심으로 사용합니다. 본사 승인 없이도 가능한 조회와 등록 업무를 먼저 처리하고, 승인 결과를 기다리는 흐름으로 운영합니다.

### 4-1. 지점 메인 화면

- 오늘의 매출, 재고, 발주 상태를 확인합니다.
- 공지사항과 안내 메시지를 먼저 봅니다.
- 현재 지점에서 처리해야 할 업무가 있는지 점검합니다.

### 4-2. 입고 처리

- 본사에서 전달된 입고 내용을 확인합니다.
- 실제 입고 수량과 품목을 대조한 뒤 입고 처리합니다.
- 입고 후에는 지점 재고가 정상 반영되었는지 확인합니다.

### 4-3. 발주 요청 등록

- 부족한 자재나 물품을 확인한 뒤 발주 요청을 등록합니다.
- 수량과 품목을 정확히 입력하고 요청을 저장합니다.
- 등록 후에는 요청 목록에서 상태가 `PENDING`인지 확인합니다.
- 본사 승인 또는 반려 결과를 기다립니다.

### 4-4. 지점 재고 및 매출 확인

- 재고 메뉴에서 품목별 현재 수량을 확인합니다.
- 입고, 출고, 조정 이력이 필요한 경우 상세 내역을 조회합니다.
- 매출 메뉴에서 일자별 매출과 운영 흐름을 확인합니다.

### 4-5. 교환 및 고객지원

- 교환 메뉴에서 문제 발생 건을 등록하거나 처리 상태를 확인합니다.
- 고객지원 메뉴에서 문의를 등록하고 답변 여부를 확인합니다.
- 공지사항을 수시로 확인해 본사 안내를 놓치지 않도록 합니다.

## 5️⃣ 사용 시 주의사항

- 본사 계정은 승인과 출고 권한이 있으므로 지점 계정과 구분해서 사용해야 합니다.
- 발주 요청 수량과 승인 수량을 잘못 입력하면 재고 차감 결과가 달라질 수 있습니다.
- 입고와 출고 처리 후에는 항상 목록과 이력 화면에서 결과를 확인하는 것이 좋습니다.
- 오류가 발생하면 공통 오류 페이지의 안내를 확인하고 다시 로그인하거나 관리자에게 문의합니다.

---

# 🧩 사용 기술

- Java 11
- JSP / Servlet
- MyBatis
- MariaDB
- Apache Tomcat
- HTML / CSS / JavaScript
- Gson

---

# 📂 프로젝트 구조

## 루트 파일

| 경로 | 설명 |
|---|---|
| [README.md](README.md) | 프로젝트 소개와 실행 방법을 정리한 문서입니다. |

## Java 소스 구조

| 경로 | 설명 |
|---|---|
| [src/main/java/controller](src/main/java/controller) | HTTP 요청을 받아 서비스로 전달하는 서블릿 컨트롤러 폴더입니다. |
| [src/main/java/controller/common](src/main/java/controller/common) | 로그인, 공통 응답, 알림 같은 전체 공통 제어를 담당합니다. |
| [src/main/java/controller/hq](src/main/java/controller/hq) | 본사 화면과 본사 업무용 컨트롤러를 모아둔 폴더입니다. |
| [src/main/java/controller/branch](src/main/java/controller/branch) | 지점 화면과 지점 업무용 컨트롤러를 모아둔 폴더입니다. |
| [src/main/java/dao](src/main/java/dao) | MyBatis 세션을 사용해 DB 조회와 저장을 수행하는 데이터 접근 계층입니다. |
| [src/main/java/dto](src/main/java/dto) | 요청과 응답, 조회 결과를 담는 데이터 전달 객체 폴더입니다. |
| [src/main/java/exception](src/main/java/exception) | 삭제 실패나 비즈니스 예외처럼 공통 예외 클래스를 둔 폴더입니다. |
| [src/main/java/filter](src/main/java/filter) | 인증, 지점 데이터 검사 같은 요청 전처리를 담당하는 필터입니다. |
| [src/main/java/mapper](src/main/java/mapper) | MyBatis SQL 매퍼 XML 파일이 들어 있는 폴더입니다. |
| [src/main/java/resource](src/main/java/resource) | MyBatis 설정 파일처럼 실행 환경 설정을 담는 폴더입니다. |
| [src/main/java/service](src/main/java/service) | 업무 로직과 트랜잭션 흐름을 담당하는 서비스 계층입니다. |
| [src/main/java/util](src/main/java/util) | 공통 유틸리티, 세션 팩토리, Gson 설정 같은 재사용 코드를 둡니다. |

## 웹 화면 구조

| 경로 | 설명 |
|---|---|
| [src/main/webapp](src/main/webapp) | 실제 JSP 화면, 정적 리소스, 업로드 파일이 위치하는 웹 루트입니다. |
| [src/main/webapp/common](src/main/webapp/common) | 로그인, 에러 페이지, 공통 스크립트처럼 전체 화면에서 공유하는 파일입니다. |
| [src/main/webapp/hq](src/main/webapp/hq) | 본사 화면 JSP 폴더입니다. 본사 업무별 메뉴가 이 안에 정리되어 있습니다. |
| [src/main/webapp/branch](src/main/webapp/branch) | 지점 화면 JSP 폴더입니다. 지점 업무별 메뉴가 이 안에 정리되어 있습니다. |
| [src/main/webapp/upload](src/main/webapp/upload) | 업로드된 이미지, 첨부파일, 리소스 파일을 보관하는 폴더입니다. |
| [src/main/webapp/WEB-INF](src/main/webapp/WEB-INF) | 외부에서 직접 접근하지 못하도록 보호되는 설정과 배포 관련 파일이 위치합니다. |

## 본사 화면 폴더

| 경로 | 설명 |
|---|---|
| [src/main/webapp/hq/main](src/main/webapp/hq/main) | 본사 메인 대시보드 화면입니다. |
| [src/main/webapp/hq/place_order](src/main/webapp/hq/place_order) | 지점 발주 요청 승인 및 처리 화면입니다. |
| [src/main/webapp/hq/warehouse](src/main/webapp/hq/warehouse) | 창고 재고와 출고 관련 화면입니다. |
| [src/main/webapp/hq/delivery](src/main/webapp/hq/delivery) | 배송 관리 화면입니다. |
| [src/main/webapp/hq/hr](src/main/webapp/hq/hr) | 본사 인사 및 조직 관리 화면입니다. |
| [src/main/webapp/hq/recipe](src/main/webapp/hq/recipe) | 레시피와 자재 기준을 관리하는 화면입니다. |
| [src/main/webapp/hq/sales](src/main/webapp/hq/sales) | 본사 및 지점 매출 현황을 확인하는 화면입니다. |
| [src/main/webapp/hq/support](src/main/webapp/hq/support) | 공지와 문의, 지원 업무를 처리하는 화면입니다. |
| [src/main/webapp/hq/branch_stock](src/main/webapp/hq/branch_stock) | 지점 재고 현황을 본사 관점에서 조회하는 화면입니다. |

## 지점 화면 폴더

| 경로 | 설명 |
|---|---|
| [src/main/webapp/branch/main](src/main/webapp/branch/main) | 지점 메인 대시보드 화면입니다. |
| [src/main/webapp/branch/place_order](src/main/webapp/branch/place_order) | 지점 발주 요청 작성 및 조회 화면입니다. |
| [src/main/webapp/branch/inbound](src/main/webapp/branch/inbound) | 본사로부터 전달받은 입고 처리 화면입니다. |
| [src/main/webapp/branch/stock](src/main/webapp/branch/stock) | 지점 재고 확인 및 관리 화면입니다. |
| [src/main/webapp/branch/hr](src/main/webapp/branch/hr) | 지점 인사 관련 화면입니다. |
| [src/main/webapp/branch/recipe](src/main/webapp/branch/recipe) | 레시피 조회 및 자재 확인 화면입니다. |
| [src/main/webapp/branch/sales](src/main/webapp/branch/sales) | 지점 매출 조회 화면입니다. |
| [src/main/webapp/branch/support](src/main/webapp/branch/support) | 고객지원 문의와 공지 확인 화면입니다. |
| [src/main/webapp/branch/swap](src/main/webapp/branch/swap) | 교환 처리 화면입니다. |
| [src/main/webapp/branch/icons](src/main/webapp/branch/icons) | 지점 화면에서 사용하는 아이콘 리소스 폴더입니다. |

## 공통 설정 파일

| 경로 | 설명 |
|---|---|
| [src/main/webapp/WEB-INF/web.xml](src/main/webapp/WEB-INF/web.xml) | 서블릿, 필터, 에러 페이지 같은 웹 애플리케이션 설정 파일입니다. |
| [src/main/java/resource/mybatis-config.xml](src/main/java/resource/mybatis-config.xml) | MyBatis 전역 설정 파일입니다. 매퍼와 타입 설정을 관리합니다. |
| [src/main/webapp/common/login.jsp](src/main/webapp/common/login.jsp) | 공통 로그인 화면입니다. |
| [src/main/webapp/common/404.jsp](src/main/webapp/common/404.jsp) | 페이지가 없을 때 표시되는 공통 오류 화면입니다. |
| [src/main/webapp/common/500.jsp](src/main/webapp/common/500.jsp) | 서버 오류가 발생했을 때 표시되는 공통 오류 화면입니다. |

## SQL 스크립트

| 경로 | 설명 |
|---|---|
| [sql](sql) | DB 초기화와 샘플 데이터가 담긴 폴더입니다. |
| [sql/init.sql](sql/init.sql) | DB와 테이블을 생성합니다. |
| [sql/Essential_data.sql](sql/Essential_data.sql) | 필수 기초 데이터를 넣습니다. |
| [sql/order_stock_data.sql](sql/order_stock_data.sql) | 주문/재고 더미 데이터를 넣습니다. |

---

# 📌 화면 구성

## 본사

- 메인
- 지점 관리
- 배송
- 인사
- 발주 처리
- 레시피
- 매출
- 고객지원
- 창고

## 지점

- 메인
- 인사
- 입고
- 발주 요청
- 레시피
- 매출
- 재고
- 고객지원
- 교환

---

# ⚙️ 실행 환경

- JDK 11
- Apache Tomcat
- MariaDB

---

# 🚀 실행 방법

1. 저장소를 클론합니다.
2. MariaDB에서 `sql/init.sql`을 먼저 실행해 데이터베이스와 테이블을 생성합니다.
3. `sql/Essential_data.sql`을 실행해 필수 기초 데이터를 넣습니다.
4. 필요하면 `sql/order_stock_data.sql`을 실행해 주문/재고 더미 데이터를 추가합니다.
5. MariaDB 연결 정보와 MyBatis 설정을 환경에 맞게 조정합니다.
6. Tomcat에 배포한 뒤 웹 애플리케이션을 실행합니다.

---

# 🔎 구현 포인트

- 본사와 지점을 분리한 권한 기반 화면 구성
- 지점 발주에서 본사 승인 및 출고까지 이어지는 업무 흐름
- 재고 차감과 이력 저장을 함께 처리하는 운영 구조
- 키오스크 주문 데이터와 ERP 운영 데이터를 연결한 통합 관리

---

# 📝 참고

- 시연 영상, 화면 캡처, ERD 이미지는 프로젝트 자료에 맞게 교체하면 됩니다.
- 배포 환경에 따라 데이터베이스 접속 정보와 서버 경로는 수정이 필요할 수 있습니다.

---

# 📞 팀 정보

ZEROLOSS ERP는 프랜차이즈 매장 운영을 위한 본사-지점 통합 관리 시스템으로 제작되었습니다.
