<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>재고 교환/요청</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <!-- Font Awesome CDN 추가 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --line: #d1d5db; --bg: #f3f4f6; --text: #111827; --muted: #6b7280; --blue: #2563eb; --green: #16a34a; --purple: #9333ea; --orange: #f97316; }
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: var(--bg); color: var(--text); }
        .wrap { width: 100%; max-width: none; margin: 0; padding: 24px; }

        .page-header { display: flex; justify-content: space-between; align-items: flex-end; gap: 24px; margin-bottom: 24px; }
        .head { flex-shrink: 0; }
        .head h1 { font-size: 1.875rem; line-height: 2.25rem; font-weight: 700; margin: 0; }
        .head p { color: #6b7280; margin: 4px 0 0; }

        /* --- 카드 디자인 개선 --- */
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; flex-grow: 1; max-width: 720px; }
        .stat {
            background: #fff; border: 1px solid var(--line); border-radius: 14px;
            padding: 14px 16px; display: flex; align-items: center; gap: 12px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .stat .n { font-size: 1.375rem; font-weight: 700; line-height: 1; color: var(--text); }
        .stat .l { font-size: 0.875rem; color: var(--muted); margin-top: 3px; }
        .stat-ico {
            width: 36px; height: 36px; border-radius: 10px;
            display: grid; place-items: center; flex-shrink: 0;
            font-size: 16px; /* 아이콘 크기 */
        }
        .s1 { background: #e0e7ff; color: #3730a3; }
        .s2 { background: #dcfce7; color: #166534; }
        .s3 { background: #f3e8ff; color: #6b21a8; }
        .s4 { background: #ffedd5; color: #9a3412; }
        .stat-text { display: flex; flex-direction: column; min-width: 0; }

        /* 탭 디자인 */
        .tabs { display: flex; gap: 0; border-bottom: 2px solid var(--line); margin-top: 24px; }
        .tab {
            height: auto; border: none; border-bottom: 3px solid transparent; border-radius: 0;
            background: transparent; color: var(--muted); font-size: 1rem; font-weight: 700;
            padding: 10px 20px; cursor: pointer; display: inline-flex; align-items: center; gap: 8px;
            transition: color .2s ease, border-color .2s ease;
            margin-bottom: -2px;
        }
        .tab:hover { color: var(--text); }
        .tab.active { color: var(--green); border-color: var(--green); background: transparent; }
        .tab-ico { width: 16px; height: 16px; display: block; flex: 0 0 auto; }
        .tab.active .tab-ico { filter: none; }
        .tab .badge { background: #e5e7eb; color: #374151; border-radius: 999px; padding: 2px 8px; font-size: 12px; font-weight: 700; }
        .tab.active .badge { background: var(--green); color: #fff; }

        /* 나머지 스타일 */
        .panel { margin-top: 18px; background: #fff; border: 1px solid var(--line); border-radius: 18px; overflow: hidden; box-shadow: 0 1px 2px rgba(15,23,42,0.05); }
        .panel-head { padding: 18px 20px; border-bottom: 1px solid #e5e7eb; }
        .panel-title { font-size: 1.25rem; line-height: 1.75rem; font-weight: 700; margin: 0; }
        .panel-sub { font-size: 0.9375rem; color: var(--muted); margin-top: 4px; }
        .form { padding: 18px 20px; display: grid; grid-template-columns: 1.2fr 1.2fr 1fr; gap: 12px; align-items: end; }
        .label { font-size: 0.875rem; font-weight: 700; color: #374151; display: block; margin-bottom: 6px; }
        .req { color: #ef4444; }
        .input { width: 100%; height: 38px; border: 1px solid #cfd6dd; border-radius: 12px; padding: 0 13px; font-size: 0.8125rem; background: #fff; color: #111827; }
        .split { display: grid; grid-template-columns: 1fr 64px; gap: 8px; }
        .unit { height: 38px; border-radius: 12px; background: #f3f4f6; color: #6b7280; display: grid; place-items: center; font-size: 0.8125rem; font-weight: 700; border: 1px solid #e5e7eb; }
        .actions { grid-column: 1 / -1; display: flex; justify-content: flex-end; }
        .search-btn { height: 38px; padding: 0 18px; border: none; border-radius: 12px; background: var(--green); color: #fff; font-size: 0.875rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; }
        .search-btn-ico { width: 16px; height: 16px; display: block; filter: brightness(0) invert(1); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 18px; border-bottom: 1px solid #e5e7eb; font-size: 0.9375rem; text-align: left; }
        th { background: #f9fafb; color: #6b7280; font-weight: 700; }
        td:nth-child(4), th:nth-child(4), td:nth-child(6), th:nth-child(6), td:nth-child(7), th:nth-child(7) { text-align: center; }
        .badge-state { display: inline-block; padding: 4px 10px; border-radius: 999px; font-size: 0.75rem; font-weight: 700; }
        .pending { background: #fef3c7; color: #b45309; }
        .approved, .done { background: #dcfce7; color: #15803d; }
        .btn { border: none; border-radius: 8px; padding: 7px 12px; color: #fff; font-size: 0.75rem; font-weight: 700; cursor: pointer; }
        .ok { background: #16a34a; }
        .no { background: #dc2626; }
        .filter { margin-top: 18px; background: #fff; border: 1px solid var(--line); border-radius: 18px; padding: 18px 20px; box-shadow: 0 1px 2px rgba(15,23,42,0.05); }
        .f-title { font-size: 1.25rem; font-weight: 700; margin: 0 0 10px; }
        .row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .info { margin-top: 18px; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 18px; padding: 18px 20px; }
        .info h4 { margin: 0; font-size: 1rem; color: #1e3a8a; }
        .info p { margin: 8px 0 0; font-size: 0.8125rem; color: #1e40af; line-height: 1.6; }
        .map-box, .table-box { margin-top: 18px; background: #fff; border: 1px solid var(--line); border-radius: 18px; overflow: hidden; box-shadow: 0 1px 2px rgba(15,23,42,0.05); }
        .map-head, .tb-head { padding: 18px 20px; border-bottom: 1px solid #e5e7eb; font-size: 1.25rem; font-weight: 700; }
        .map-head small { font-size: 0.875rem; color: #6b7280; font-weight: 600; }
        #map { height: 320px; }
        .ask { background: #2563eb; color: #fff; border: none; border-radius: 10px; padding: 8px 12px; font-size: 0.8125rem; font-weight: 700; cursor: pointer; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }

        @media (max-width: 1280px) {
            .page-header { flex-direction: column; align-items: flex-start; }
            .stats { grid-template-columns: repeat(4, 1fr); width: 100%; max-width: none; }
        }
        @media (max-width: 768px) {
            .stats { grid-template-columns: repeat(2, 1fr); }
            .form { grid-template-columns: 1fr; }
            .tabs { flex-wrap: wrap; }
        }
    </style>
    <%@ include file="/branch/common/layout/layout_head.jsp" %>
</head>
<body>
<div class="zl-app">
    <%@ include file="/branch/common/layout/sidebar.jsp" %>
    <div class="zl-content">
        <%@ include file="/branch/common/layout/topbar.jsp" %>
        <div class="wrap p-6">
            <div class="page-header">
                <header class="head">
                    <h1 class="title">재고 교환/요청</h1>
                    <p class="sub">지점 간 재고를 교환하고 요청을 관리하세요</p>
                </header>
                <section class="stats">
                    <article class="stat">
                        <div class="stat-ico s1" aria-hidden="true"><i class="fa-solid fa-paper-plane"></i></div>
                        <div class="stat-text"><span class="n">1건</span><div class="l">보낸 요청</div></div>
                    </article>
                    <article class="stat">
                        <div class="stat-ico s2" aria-hidden="true"><i class="fa-solid fa-inbox"></i></div>
                        <div class="stat-text"><span class="n">2건</span><div class="l">받은 요청</div></div>
                    </article>
                    <article class="stat">
                        <div class="stat-ico s3" aria-hidden="true"><i class="fa-solid fa-clock-rotate-left"></i></div>
                        <div class="stat-text"><span class="n">3건</span><div class="l">교환 내역</div></div>
                    </article>
                    <article class="stat">
                        <div class="stat-ico s4" aria-hidden="true"><i class="fa-solid fa-map-marker-alt"></i></div>
                        <div class="stat-text"><span class="n">5개</span><div class="l">주변 지점</div></div>
                    </article>
                </section>
            </div>

            <nav class="tabs" aria-label="재고교환 탭">
                <a class="tab active" data-tab="check_stock"><img class="tab-ico" src="<%= request.getContextPath() %>/branch/icons/swap/map-search.svg" alt="">재고 조회 및 요청</a>
                <a class="tab" data-tab="send_request"><img class="tab-ico" src="<%= request.getContextPath() %>/branch/icons/swap/send.svg" alt="">보낸 요청 <span class="badge">1</span></a>
                <a class="tab" data-tab="received_request"><img class="tab-ico" src="<%= request.getContextPath() %>/branch/icons/swap/inbox.svg" alt="">받은 요청 <span class="badge">2</span></a>
                <a class="tab" data-tab="swap_history"><img class="tab-ico" src="<%= request.getContextPath() %>/branch/icons/hr/clock.svg" alt="">교환 내역</a>
            </nav>

            <!-- 재고 조회 및 요청 (기본 main.jsp + check_stock.jsp) -->
            <div id="tab-content-check_stock" class="tab-content active">
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">주변 지점 재고 조회</h2></div>
                    <form class="form" id="searchForm">
                        <div>
                            <label class="label" for="item">필요한 품목 <span class="req">*</span></label>
                            <select class="input" id="item" name="item" required>
                                <option value="">품목 선택</option>
                                <option value="소고기 패티">소고기 패티</option>
                                <option value="치킨 패티">치킨 패티</option>
                                <option value="양상추">양상추</option>
                                <option value="토마토">토마토</option>
                                <option value="감자">감자</option>
                                <option value="양파">양파</option>
                            </select>
                        </div>
                        <div>
                            <label class="label" for="qty">필요 수량 <span class="req">*</span></label>
                            <div class="split">
                                <input class="input" id="qty" name="qty" type="number" min="1" placeholder="수량" required>
                                <div class="unit">단위</div>
                            </div>
                        </div>
                        <div>
                            <label class="label" for="dist">최대 거리 (km)</label>
                            <input class="input" id="dist" name="dist" type="number" min="1" value="10">
                        </div>
                        <div class="actions">
                            <button class="search-btn" type="submit"><img class="search-btn-ico" src="<%= request.getContextPath() %>/branch/icons/swap/map-search.svg" alt="">재고 조회</button>
                        </div>
                    </form>
                </section>
                <div id="check_stock_result" style="display:none;">
                    <section class="map-box">
                        <div class="map-head">주변 지점 지도<small>(5개 지점 발견)</small></div>
                        <div id="map"></div>
                    </section>
                    <section class="table-box">
                        <div class="tb-head">상세 지점 정보</div>
                        <table>
                            <thead><tr><th>지점명</th><th>주소</th><th>거리</th><th style="text-align:center;">액션</th></tr></thead>
                            <tbody>
                                <tr><td>강남점</td><td>서울 강남구 테헤란로 123</td><td>2.5km</td><td><button class="ask" onclick="requestStock('강남점','2.5km')">요청하기</button></td></tr>
                                <tr><td>홍대점</td><td>서울 마포구 양화로 456</td><td>5.3km</td><td><button class="ask" onclick="requestStock('홍대점','5.3km')">요청하기</button></td></tr>
                                <tr><td>잠실점</td><td>서울 송파구 올림픽로 789</td><td>3.8km</td><td><button class="ask" onclick="requestStock('잠실점','3.8km')">요청하기</button></td></tr>
                                <tr><td>신촌점</td><td>서울 서대문구 신촌로 321</td><td>6.1km</td><td><button class="ask" onclick="requestStock('신촌점','6.1km')">요청하기</button></td></tr>
                                <tr><td>판교점</td><td>경기 성남시 분당구 판교역로 654</td><td>8.7km</td><td><button class="ask" onclick="requestStock('판교점','8.7km')">요청하기</button></td></tr>
                            </tbody>
                        </table>
                    </section>
                </div>
            </div>

            <!-- 보낸 요청 (send_request.jsp) -->
            <div id="tab-content-send_request" class="tab-content">
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">보낸 요청</h2><div class="panel-sub">내가 다른 지점에 요청한 내역입니다</div></div>
                    <table>
                        <thead><tr><th>요청일시</th><th>받는 지점</th><th>품목</th><th>수량</th><th>상태</th><th>응답일시</th></tr></thead>
                        <tbody>
                            <tr><td>2026. 04. 15. 오전 01:51</td><td>신촌점</td><td>소고기 패티</td><td>1개</td><td><span class="badge-state pending">대기중</span></td><td>-</td></tr>
                            <tr><td>2026-04-03 10:30</td><td>강남점</td><td>소고기 패티</td><td>20개</td><td><span class="badge-state pending">대기중</span></td><td>-</td></tr>
                            <tr><td>2026-04-02 14:20</td><td>홍대점</td><td>양상추</td><td>5kg</td><td><span class="badge-state approved">승인됨</span></td><td>2026-04-02 15:45</td></tr>
                        </tbody>
                    </table>
                </section>
            </div>

            <!-- 받은 요청 (received_request.jsp) -->
            <div id="tab-content-received_request" class="tab-content">
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">받은 요청</h2><div class="panel-sub">다른 지점에서 요청한 내역입니다</div></div>
                    <table>
                        <thead><tr><th>요청일시</th><th>요청 지점</th><th>품목</th><th>수량</th><th>메시지</th><th>상태</th><th>액션</th></tr></thead>
                        <tbody>
                            <tr><td>2026-04-04 09:15</td><td>부산점</td><td>토마토</td><td>10kg</td><td>급하게 필요합니다</td><td><span class="badge-state pending">대기중</span></td><td><button class="btn ok">승인</button> <button class="btn no">거절</button></td></tr>
                            <tr><td>2026-04-03 16:20</td><td>인천점</td><td>감자</td><td>15kg</td><td>-</td><td><span class="badge-state pending">대기중</span></td><td><button class="btn ok">승인</button> <button class="btn no">거절</button></td></tr>
                            <tr><td>2026-04-01 11:10</td><td>대전점</td><td>양파</td><td>8kg</td><td>-</td><td><span class="badge-state done">승인됨</span></td><td>처리완료</td></tr>
                        </tbody>
                    </table>
                </section>
            </div>

            <!-- 교환 내역 (swap_history.jsp) -->
            <div id="tab-content-swap_history" class="tab-content">
                <section class="filter">
                    <h2 class="f-title">기간별 조회</h2>
                    <div class="row">
                        <div><label class="label">시작일</label><input class="input" type="date" value="2026-03-16"></div>
                        <div><label class="label">종료일</label><input class="input" type="date" value="2026-04-15"></div>
                    </div>
                </section>
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">교환 내역</h2><div class="panel-sub">완료된 재고 교환 내역입니다</div></div>
                    <table>
                        <thead><tr><th>날짜</th><th>보낸 지점</th><th>받은 지점</th><th>품목</th><th>수량</th><th>상태</th></tr></thead>
                        <tbody>
                            <tr><td>2026-03-28</td><td>강남점</td><td>홍대점</td><td>치킨 패티</td><td>30개</td><td><span class="badge-state done">완료</span></td></tr>
                            <tr><td>2026-03-25</td><td>신촌점</td><td>강남점</td><td>양상추</td><td>10kg</td><td><span class="badge-state done">완료</span></td></tr>
                            <tr><td>2026-03-20</td><td>홍대점</td><td>신촌점</td><td>소고기 패티</td><td>15개</td><td><span class="badge-state done">완료</span></td></tr>
                        </tbody>
                    </table>
                </section>
                <section class="info">
                    <h4>정산 안내</h4>
                    <p>직영점 간 재고 교환은 당장 현금 거래가 발생하지 않지만, 월말 정산 시 본사 재무팀이 각 지점의 원가를 정확히 계산하는 데 활용됩니다. 모든 교환 내역은 자동으로 기록되며, 증빙 자료로 보관됩니다.</p>
                </section>
            </div>
        </div>
    </div>
</div>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    (function () {
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');
        const searchForm = document.getElementById('searchForm');
        const checkStockResult = document.getElementById('check_stock_result');
        let map;

        function showTab(tabName) {
            tabs.forEach(tab => {
                tab.classList.toggle('active', tab.dataset.tab === tabName);
            });
            tabContents.forEach(content => {
                content.classList.toggle('active', content.id === 'tab-content-' + tabName);
            });
            window.history.pushState({tab: tabName}, '', '?tab=' + tabName);
        }

        tabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                e.preventDefault();
                const tabName = e.currentTarget.dataset.tab;
                showTab(tabName);
            });
        });

        searchForm.addEventListener('submit', function (e) {
            e.preventDefault();
            checkStockResult.style.display = 'block';
            if (!map) {
                map = L.map('map').setView([37.52, 127.02], 11);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '&copy; OpenStreetMap contributors' }).addTo(map);
                [[37.4979, 127.0276, '강남점'], [37.5563, 126.9239, '홍대점'], [37.5133, 127.1028, '잠실점'], [37.5559, 126.9368, '신촌점'], [37.3952, 127.1112, '판교점']].forEach(function (m) { L.marker([m[0], m[1]]).addTo(map).bindPopup(m[2]); });
            }
        });

        window.requestStock = function(branch, distance) {
            const item = encodeURIComponent(document.getElementById('item').value || '소고기 패티');
            const qty = encodeURIComponent(document.getElementById('qty').value || '1');
            // 실제 상세 요청 페이지가 없으므로 alert로 대체합니다.
            alert(`'${branch}'에 '${item}' ${qty}개 요청 페이지로 이동합니다. (거리: ${distance})`);
        }

        // 페이지 로드 시 URL 파라미터 확인
        const urlParams = new URLSearchParams(window.location.search);
        const initialTab = urlParams.get('tab') || 'check_stock';
        showTab(initialTab);

    })();
</script>
</body>
</html>
