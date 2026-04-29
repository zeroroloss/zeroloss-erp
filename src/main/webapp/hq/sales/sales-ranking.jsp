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
                        <option value="">카테고리 로딩...</option>
                    </select>
                    <select id="menuSelect" class="sort-btn bg-white">
                        <option value="">메뉴 로딩...</option>
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

        <section class="grid" id="ranking-grid">
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

        <!-- 🟢 추가: 전사 트렌드 (시간/요일) 데이터를 표시할 영역 -->
        <section class="hidden-group" id="trend-data-section">
            <div class="grid mt-6">
                <article class="panel">
                    <div class="panel-head">
                        <div class="panel-title">시간대별 매출/판매량 트렌드</div>
                        <span class="badge green">24시간</span>
                    </div>
                    <div class="rank-list" id="hourly-trend-list">
                        <div class="no-data">데이터를 분석 중입니다...</div>
                    </div>
                </article>

                <article class="panel orange">
                    <div class="panel-head">
                        <div class="panel-title">요일별 매출/판매량 트렌드</div>
                        <span class="badge orange">주 7일</span>
                    </div>
                    <div class="rank-list" id="daily-trend-list">
                        <div class="no-data">데이터를 분석 중입니다...</div>
                    </div>
                </article>
            </div>
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

        const rankingGrid = document.getElementById('ranking-grid'); // 🟢 추가
        const trendDataSection = document.getElementById('trend-data-section'); // 🟢 추가

        const bestList = document.getElementById('best-list');
        const worstList = document.getElementById('worst-list');
        const bestTitle = document.getElementById('best-title');
        const worstTitle = document.getElementById('worst-title');

        let currentSort = 'sales';
        let currentRankType = 'branch';
        const contextPath = "<%= request.getContextPath() %>";

        function updateTitles() {
            const sortText = currentSort === 'sales' ? '매출액' : '판매량';
            let prefix = '';

            if (currentRankType === 'branch') {
                prefix = '지점 종합';
            } else if (currentRankType === 'menu') {
                prefix = '전사 메뉴';
            } else if (currentRankType === 'specific_menu') {
                // 메뉴가 로딩되지 않았을 때를 대비한 안전 처리
                const selectedMenuText = menuSelect.options.length > 0 ? menuSelect.options[menuSelect.selectedIndex].text : '메뉴';
                prefix = '[' + selectedMenuText + '] 판매 지점';
            } else if (currentRankType === 'trend') { // 🟢 추가
                // 트렌드 탭에서는 TOP/WORST 개념이 없으므로 제목을 다르게 설정
                bestTitle.textContent = '시간대별 ' + sortText + ' 트렌드';
                worstTitle.textContent = '요일별 ' + sortText + ' 트렌드';
                return; // 기존 TOP/WORST 10 제목 업데이트 로직 건너뛰기
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

            const formatValue = (item) => {
                const val = currentSort === 'sales' ? (item.totalSales || item.value) : (item.totalQuantity || item.value);
                const numValue = Number(val || 0);
                return currentSort === 'sales'
                    ? '₩' + Math.round(numValue).toLocaleString('ko-KR')
                    : numValue.toLocaleString('ko-KR') + '건(개)';
            };

            const itemsHtml = data.map((item, index) => {
                const rank = index + 1;
                const itemName = item.branchName || item.menuName || item.name || '알 수 없음';

                // 🟢 JSP EL 에러를 막기 위해 백틱(`) 대신 문자열 덧셈(+) 기호로 HTML 생성
                return '<div class="rank-item">' +
                    '<div class="rank-no">' + rank + '</div>' +
                    '<div class="item-main">' +
                    '<div class="item-name">' + itemName + '</div>' +
                    '</div>' +
                    '<div class="item-value">' + formatValue(item) + '</div>' +
                    '</div>';
            }).join('');

            container.innerHTML = itemsHtml;
        }

        // 🟢 새로운 트렌드 데이터 렌더링 함수
        function renderTrendData(hourlyData, dailyData) {
            const hourlyTrendList = document.getElementById('hourly-trend-list');
            const dailyTrendList = document.getElementById('daily-trend-list');

            hourlyTrendList.innerHTML = '';
            dailyTrendList.innerHTML = '';

            const formatValue = (item) => {
                const val = currentSort === 'sales' ? item.totalSales : item.totalQuantity;
                const numValue = Number(val || 0);
                return currentSort === 'sales'
                    ? '₩' + Math.round(numValue).toLocaleString('ko-KR')
                    : numValue.toLocaleString('ko-KR') + '건(개)';
            };

            // 시간별 트렌드 렌더링
            if (hourlyData && hourlyData.length > 0) {
                hourlyData.forEach(item => {
                    const div = document.createElement('div');
                    div.className = 'rank-item';
                    div.innerHTML = `
                        <div class="rank-no">${item.hour}시</div>
                        <div class="item-main">
                            <div class="item-name">총 ${currentSort === 'sales' ? '매출' : '판매량'}</div>
                        </div>
                        <div class="item-value">${formatValue(item)}</div>
                    `;
                    hourlyTrendList.appendChild(div);
                });
            } else {
                hourlyTrendList.innerHTML = '<div class="no-data">조회된 시간별 데이터가 없습니다.</div>';
            }

            // 요일별 트렌드 렌더링
            if (dailyData && dailyData.length > 0) {
                dailyData.forEach(item => {
                    const div = document.createElement('div');
                    div.className = 'rank-item';
                    div.innerHTML = `
                        <div class="rank-no">${item.dayName}</div>
                        <div class="item-main">
                            <div class="item-name">총 ${currentSort === 'sales' ? '매출' : '판매량'}</div>
                        </div>
                        <div class="item-value">${formatValue(item)}</div>
                    `;
                    dailyTrendList.appendChild(div);
                });
            } else {
                dailyTrendList.innerHTML = '<div class="no-data">조회된 요일별 데이터가 없습니다.</div>';
            }
        }

        // 🟢 1. 대분류 카테고리 로드
        function loadCategories() {
            const url = contextPath + '/hq/sales/ranking?action=getMenuCategories';

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    mainCategorySelect.innerHTML = '';
                    if(data && data.length > 0) {
                        data.forEach(cat => {
                            const option = document.createElement('option');
                            option.value = cat.categoryCode;
                            option.textContent = cat.categoryName;
                            mainCategorySelect.appendChild(option);
                        });
                        // 카테고리 로드가 끝나면 바로 그 카테고리에 맞는 메뉴 로드 실행
                        loadMenus();
                    } else {
                        mainCategorySelect.innerHTML = '<option value="">카테고리 없음</option>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching categories:', error);
                    mainCategorySelect.innerHTML = '<option value="">로드 실패</option>';
                });
        }

        // 🟢 2. 특정 카테고리의 하위 메뉴 로드
        function loadMenus() {
            const categoryCode = mainCategorySelect.value;
            if (!categoryCode) return;

            // JSP EL 에러 방지를 위해 문자열 덧셈 적용
            const url = contextPath + '/hq/sales/ranking?action=getMenusByCategory&categoryCode=' + categoryCode;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    menuSelect.innerHTML = '';
                    if(data && data.length > 0) {
                        data.forEach(menu => {
                            const option = document.createElement('option');
                            option.value = menu.recipeCode;
                            option.textContent = menu.recipeName;
                            menuSelect.appendChild(option);
                        });
                    } else {
                        menuSelect.innerHTML = '<option value="">메뉴 없음</option>';
                    }
                    // 하위 메뉴까지 세팅이 끝나면 마침내 전체 데이터(랭킹) 패치
                    fetchData();
                })
                .catch(error => {
                    console.error('Error fetching menus:', error);
                    menuSelect.innerHTML = '<option value="">로드 실패</option>';
                });
        }

        // 🟢 트렌드 데이터 패치 함수
        function fetchTrendData() {
            updateTitles(); // 트렌드 탭에 맞는 제목으로 업데이트

            const startDate = periodStartPicker.input.value;
            const endDate = periodEndPicker.input.value;

            const url = `${contextPath}/hq/sales/ranking?action=getTrendData&startDate=${startDate}&endDate=${endDate}`;

            document.getElementById('hourly-trend-list').innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';
            document.getElementById('daily-trend-list').innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    renderTrendData(data.hourly, data.daily);
                })
                .catch(error => {
                    console.error('Error fetching trend data:', error);
                    document.getElementById('hourly-trend-list').innerHTML = '<div class="no-data">데이터 로드 실패</div>';
                    document.getElementById('daily-trend-list').innerHTML = '<div class="no-data">데이터 로드 실패</div>';
                });
        }

        // 🟢 3. 최종 데이터(랭킹 순위 또는 트렌드) 로드
        function fetchData() {
            // 기존 랭킹/트렌드 섹션 숨기기
            rankingGrid.classList.add('hidden-group');
            trendDataSection.classList.add('hidden-group');
            specificMenuFilter.classList.add('hidden-group'); // 특정 메뉴 필터도 숨김

            if (currentRankType === 'trend') {
                trendDataSection.classList.remove('hidden-group');
                fetchTrendData();
            } else {
                rankingGrid.classList.remove('hidden-group');
                if (currentRankType === 'specific_menu') {
                    specificMenuFilter.classList.remove('hidden-group');
                }

                // 기존 랭킹 데이터 로직
                updateTitles();

                bestList.innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';
                worstList.innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';

                const startDate = periodStartPicker.input.value;
                const endDate = periodEndPicker.input.value;
                const recipeCode = menuSelect.value || ''; // 선택된 타겟 메뉴 코드

                const supportedTabs = ['branch', 'menu', 'specific_menu'];
                if (!supportedTabs.includes(currentRankType)) {
                    setTimeout(() => {
                        bestList.innerHTML = '<div class="no-data">해당 랭킹 데이터는 준비 중입니다.</div>';
                        worstList.innerHTML = '<div class="no-data">해당 랭킹 데이터는 준비 중입니다.</div>';
                    }, 300);
                    return;
                }

                if (currentRankType === 'specific_menu' && !recipeCode) {
                    setTimeout(() => {
                        bestList.innerHTML = '<div class="no-data">분석할 메뉴를 선택해주세요.</div>';
                        worstList.innerHTML = '<div class="no-data"></div>';
                    }, 300);
                    return;
                }

                const url = `${contextPath}/hq/sales/ranking?action=getRanking&rankType=${currentRankType}&sortType=${currentSort}&startDate=${startDate}&endDate=${endDate}&recipeCode=${recipeCode}`;

                fetch(url)
                    .then(response => response.json())
                    .then(data => {
                        const top10 = data.slice(0, 10);
                        const worst10 = data.slice(-10).reverse();

                        renderList(bestList, top10);
                        renderList(worstList, worst10);
                    })
                    .catch(error => {
                        console.error('Error fetching rank data:', error);
                        bestList.innerHTML = '<div class="no-data">데이터 로드 실패</div>';
                        worstList.innerHTML = '<div class="no-data">데이터 로드 실패</div>';
                    });
            }
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

                // 🟢 탭 변경 시 필터 및 데이터 섹션 가시성 제어
                if (currentRankType === 'specific_menu') {
                    specificMenuFilter.classList.remove('hidden-group');
                    rankingGrid.classList.remove('hidden-group');
                    trendDataSection.classList.add('hidden-group');
                } else if (currentRankType === 'trend') {
                    specificMenuFilter.classList.add('hidden-group');
                    rankingGrid.classList.add('hidden-group');
                    trendDataSection.classList.remove('hidden-group');
                } else { // branch, menu 탭
                    specificMenuFilter.classList.add('hidden-group');
                    rankingGrid.classList.remove('hidden-group');
                    trendDataSection.classList.add('hidden-group');
                }

                fetchData();
            });
        });

        // 🟢 이벤트 리스너 연결
        mainCategorySelect.addEventListener('change', loadMenus);
        menuSelect.addEventListener('change', fetchData);

        // 🟢 초기 페이지 진입 시 로드 순서: 카테고리 불러오기 -> 메뉴 불러오기 -> 데이터(랭킹) 불러오기
        loadCategories();
    });
</script>

</body>
</html>