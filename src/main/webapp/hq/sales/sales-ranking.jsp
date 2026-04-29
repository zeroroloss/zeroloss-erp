<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>매출 순위 - ZERO LOSS 본사 관리 시스템</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">

    <%-- flatpickr --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --green: #00853D;
            --line: #e5e7eb;
            --muted: #6b7280;
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }

        .sidebar-open .sidebar {
            transform: translateX(0);
        }

        .head h1 { font-size: 1.875rem; line-height: 2.25rem; font-weight: 700; }
        .head p { color: #6b7280; }

        .search-panel { margin-top:24px; border:1px solid var(--line); border-radius:18px; background:#fff; box-shadow:0 1px 2px rgba(15,23,42,0.05); padding:14px 18px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px; }
        .filters { display:flex; flex-wrap:wrap; align-items:center; gap:10px; }
        .filter-group { display:flex; align-items:center; gap: 6px; }
        .filter-group .label { font-size:13px; color:#374151; font-weight:700; flex-shrink: 0; }

        .date-picker-wrap input, select.sort-btn, select#mainCategorySelect, select#menuSelect {
            height:38px;
            width:115px;
            border-radius:12px;
            border:1px solid #d1d5db;
            background:#fff;
            color:#1f2937;
            padding:0 8px;
            font-size:13px;
            outline:none;
        }

        .date-picker-wrap input {
            padding-left: 30px !important;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af' class='w-5 h-5'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zM4.5 6.75A1.25 1.25 0 015.75 5.5h8.5A1.25 1.25 0 0115.5 6.75v8.5A1.25 1.25 0 0114.25 16.5h-8.5A1.25 1.25 0 014.5 15.25v-8.5zM7 10a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm-6 3a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2z' clip-rule='evenodd' /%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: 8px center;
            background-size: 16px;
        }

        .sort-btn { height:38px; border:1px solid #d1d5db; border-radius:12px; padding:0 10px; background:#f9fafb; color:#374151; font-size:13px; font-weight:700; cursor:pointer; }
        .sort-btn.active { border-color:var(--green); color:var(--green); background:#ecf8f1; }

        .rank-tabs { margin-top:24px; display:flex; gap:10px; border-bottom: 1px solid var(--line); }
        .rank-tab { padding:0 4px 12px; text-decoration:none; display:inline-flex; align-items:center; font-weight:700; font-size:16px; color:var(--muted); border-bottom: 3px solid transparent; cursor: pointer; }
        .rank-tab.active { color:var(--green); border-bottom-color: var(--green); }

        .grid { margin-top:24px; display:grid; grid-template-columns:1fr 1fr; gap:24px; }

        .panel { background:#fff; border:1px solid #009223; border-radius:16px; }
        .panel-head { display:flex; align-items:center; gap:8px; padding: 18px 20px; border-bottom: 1px solid #009223; }
        .panel-title { font-size:20px; font-weight:700; }
        .badge { margin-left:auto; padding:4px 10px; border-radius:999px; font-size:12px; font-weight:700; }
        .badge.green { background:#e6f4ea; color:#009223; }
        .rank-no { width:28px; font-size:18px; font-weight:800; color:#009223; text-align:center; flex-shrink: 0; }

        .panel.orange { border-color: #FFA940; background-color: #FFF7E6; }
        .panel.orange .panel-head { border-bottom-color: #FFA940; }
        .badge.orange { background:#fff1de; color:#d97706; }
        .panel.orange .rank-no { color: #d97706; }

        .rank-list { display:flex; flex-direction:column; gap:6px; padding: 12px; }
        .rank-item { display:flex; align-items:center; gap:12px; padding:10px; border-radius:10px; background: #fff; }
        .item-main { flex:1; min-width:0; }
        .item-name { font-size:16px; font-weight:700; line-height:1.3; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .item-value { font-size:18px; font-weight:700; white-space:nowrap; color:#111827; flex-shrink: 0; }

        .no-data { text-align: center; padding: 60px 20px; color: var(--muted); }

        .hidden-group { display: none !important; }

        @media (max-width:960px){ .grid{grid-template-columns:1fr;} }
    </style>
</head>
<body class="bg-gray-50">

<%@ include file="/hq/common/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <header class="head">
            <h1>전사 매출 랭킹</h1>
            <p>전국 직영점의 실적과 메뉴 트렌드를 분석합니다.</p>
        </header>

        <section class="search-panel">
            <div class="filters">
                <div class="filter-group">
                    <span class="label">조회기간:</span>
                    <div class="date-picker-wrap">
                        <input type="text" id="period-start" placeholder="시작일">
                    </div>
                    <span class="text-gray-500">~</span>
                    <div class="date-picker-wrap">
                        <input type="text" id="period-end" placeholder="종료일">
                    </div>
                </div>

                <div class="filter-group hidden-group" id="specific-menu-filter">
                    <span class="label ml-4">타겟 메뉴:</span>
                    <select id="mainCategorySelect" class="sort-btn bg-white">
                        <option value="1">샌드위치</option>
                        <option value="2">샐러드</option>
                        <option value="3">사이드</option>
                        <option value="4">음료/수프</option>
                    </select>
                    <select id="menuSelect" class="sort-btn bg-white">
                        <option value="1001">잠봉 플러스</option>
                        <option value="1008">에그마요</option>
                        <option value="1006">이탈리안 비엠티</option>
                    </select>
                </div>

                <div class="filter-group ml-auto">
                    <span class="label">정렬기준:</span>
                    <button class="sort-btn active" data-sort="sales">매출액 순</button>
                    <button class="sort-btn" data-sort="quantity">주문/판매량 순</button>
                </div>
            </div>
        </section>

        <nav class="rank-tabs" aria-label="랭킹 종류">
            <a class="rank-tab active" data-rank-type="branch">지점 종합 랭킹</a>
            <a class="rank-tab" data-rank-type="menu">전사 메뉴별 랭킹</a>
            <a class="rank-tab" data-rank-type="specific_menu">특정 메뉴 집중 분석</a>
            <a class="rank-tab" data-rank-type="trend">전사 트렌드 (시간/요일)</a>
        </nav>

        <section class="grid">
            <article class="panel">
                <div class="panel-head">
                    <div class="panel-title" id="best-title"></div>
                    <span class="badge green">TOP 10</span>
                </div>
                <div class="rank-list" id="best-list">
                    <div class="no-data">조회된 데이터가 없습니다.</div>
                </div>
            </article>

            <article class="panel orange">
                <div class="panel-head">
                    <div class="panel-title" id="worst-title"></div>
                    <span class="badge orange">WORST 10</span>
                </div>
                <div class="rank-list" id="worst-list">
                    <div class="no-data">조회된 데이터가 없습니다.</div>
                </div>
            </article>
        </section>
    </main>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        flatpickr.localize(flatpickr.l10ns.ko);

        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

        const periodStartPicker = flatpickr("#period-start", {
            defaultDate: thirtyDaysAgo,
            dateFormat: "Y-m-d",
            onChange: () => fetchData()
        });
        const periodEndPicker = flatpickr("#period-end", {
            defaultDate: "today",
            dateFormat: "Y-m-d",
            onChange: () => fetchData()
        });

        const sortButtons = document.querySelectorAll('.sort-btn[data-sort]');
        const rankTabs = document.querySelectorAll('.rank-tab');
        const specificMenuFilter = document.getElementById('specific-menu-filter');
        const mainCategorySelect = document.getElementById('mainCategorySelect');
        const menuSelect = document.getElementById('menuSelect');

        const bestList = document.getElementById('best-list');
        const worstList = document.getElementById('worst-list');
        const bestTitle = document.getElementById('best-title');
        const worstTitle = document.getElementById('worst-title');

        let currentSort = 'sales';
        let currentRankType = 'branch';

        function updateTitles() {
            const sortText = currentSort === 'sales' ? '매출액' : '판매량';
            let prefix = '';

            if (currentRankType === 'branch') {
                prefix = '지점 종합';
            } else if (currentRankType === 'menu') {
                prefix = '전사 메뉴';
            } else if (currentRankType === 'specific_menu') {
                const selectedMenuText = menuSelect.options[menuSelect.selectedIndex].text;
                prefix = '[' + selectedMenuText + '] 판매 지점';
            } else if (currentRankType === 'trend') {
                prefix = '피크/데드 타임';
            }

            bestTitle.textContent = prefix + ' ' + sortText + ' TOP 10';
            worstTitle.textContent = prefix + ' ' + sortText + ' WORST 10';
        }

        function renderList(container, data) {
            container.innerHTML = '';
            if (!data || data.length === 0) {
                container.innerHTML = '<div class="no-data">조회된 데이터가 없습니다.</div>';
                return;
            }

            const formatValue = (value) => {
                const numValue = Number(value);
                return currentSort === 'sales'
                    ? '₩' + Math.round(numValue).toLocaleString('ko-KR')
                    : numValue.toLocaleString('ko-KR') + '건(개)';
            };

            const itemsHtml = data.map((item, index) => {
                const rank = index + 1;
                return (
                    '<div class="rank-item">' +
                    '<div class="rank-no">' + rank + '</div>' +
                    '<div class="item-main">' +
                    '<div class="item-name">' + item.name + '</div>' +
                    '</div>' +
                    '<div class="item-value">' + formatValue(item.value) + '</div>' +
                    '</div>'
                );
            }).join('');
            container.innerHTML = itemsHtml;
        }

        function fetchData() {
            updateTitles();

            bestList.innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';
            worstList.innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';

            setTimeout(() => {
                const mockData = generateMockData(currentRankType, currentSort, mainCategorySelect.value, menuSelect.value);
                renderList(bestList, mockData.top10);
                renderList(worstList, mockData.worst10);
            }, 300);
        }

        function generateMockData(rankType, sort, categoryId, menuId) {
            const top10 = [];
            const worst10 = [];

            let bestNames = [], worstNames = [];

            if (rankType === 'branch') {
                bestNames = ['강남점', '수원점', '홍대점', '대구점', '서면점', '대전점', '울산점', '제주점', '해운대점', '천안점'];
                worstNames = ['조치원점', '아산점', '강릉점', '진주점', '구미점', '충주점', '순천점', '여수점', '군산점', '포항점'];
            } else if (rankType === 'menu') {
                bestNames = ['잠봉 플러스', '에그마요', '이탈리안 비엠티', '스테이크&치즈', '로스트 치킨', '베이컨 치즈 웨지', '참치', '쉬림프', '아메리카노', '쿠키 세트'];
                worstNames = ['베지', '오트밀 레이즌', '미니 로티세리', '칩', '초코칩', '라즈베리 치즈케익', '에그 슬라이스', '햄', '스파이시 이탈리안', '터키'];
            } else if (rankType === 'specific_menu') {
                bestNames = ['강남점', '홍대점', '수원점', '대전점', '대구점', '인천점', '성남점', '천안점', '서면점', '울산점'];
                worstNames = ['조치원점', '아산점', '강릉점', '진주점', '구미점', '충주점', '순천점', '여수점', '군산점', '포항점'];
            } else if (rankType === 'trend') {
                bestNames = ['금요일 18시~20시', '목요일 12시~14시', '토요일 13시~15시', '수요일 18시~20시', '금요일 12시~14시', '화요일 12시~14시', '일요일 14시~16시', '목요일 18시~20시', '월요일 12시~14시', '토요일 18시~20시'];
                worstNames = ['월요일 15시~17시', '화요일 15시~17시', '수요일 15시~17시', '목요일 15시~17시', '월요일 10시~11시', '화요일 10시~11시', '수요일 10시~11시', '목요일 10시~11시', '금요일 10시~11시', '일요일 10시~11시'];
            }

            for (let i = 0; i < 10; i++) {
                top10.push({
                    name: bestNames[i],
                    value: sort === 'sales' ? Math.floor(Math.random() * 5000000) + 10000000 : Math.floor(Math.random() * 1500) + 1000
                });
                worst10.push({
                    name: worstNames[i],
                    value: sort === 'sales' ? Math.floor(Math.random() * 800000) + 200000 : Math.floor(Math.random() * 50) + 20
                });
            }

            top10.sort((a, b) => b.value - a.value);
            worst10.sort((a, b) => a.value - b.value);

            return { top10, worst10 };
        }

        sortButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                currentSort = btn.dataset.sort;
                sortButtons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                fetchData();
            });
        });

        rankTabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                e.preventDefault();
                currentRankType = tab.dataset.rankType;
                rankTabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');

                if (currentRankType === 'specific_menu') {
                    specificMenuFilter.classList.remove('hidden-group');
                } else {
                    specificMenuFilter.classList.add('hidden-group');
                }

                fetchData();
            });
        });

        mainCategorySelect.addEventListener('change', fetchData);
        menuSelect.addEventListener('change', fetchData);

        fetchData();
    });
</script>
</body>
</html>