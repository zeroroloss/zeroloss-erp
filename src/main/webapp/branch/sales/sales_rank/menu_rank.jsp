<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>매출 순위</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
    <%-- flatpickr --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

    <%@ include file="/branch/common/layout/layout_head.jsp" %>
    <style>
        .head h1 { font-size: 1.875rem; line-height: 2.25rem; font-weight: 700; }
        .head p { color: #6b7280; }
        .search-panel { margin-top:24px; border:1px solid var(--line); border-radius:18px; background:#fff; box-shadow:0 1px 2px rgba(15,23,42,0.05); padding:18px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px; }
        .filters { display:flex; flex-wrap:wrap; align-items:center; gap:16px; }
        .filter-group { display:flex; align-items:center; gap: 8px; }
        .filter-group .label { font-size:14px; color:#374151; font-weight:700; flex-shrink: 0; }

        .date-picker-wrap input { height:38px; min-width:140px; border-radius:12px; border:1px solid #d1d5db; background:#fff; color:#1f2937; padding:0 13px 0 38px; font-size:13px; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af' class='w-5 h-5'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zM4.5 6.75A1.25 1.25 0 015.75 5.5h8.5A1.25 1.25 0 0115.5 6.75v8.5A1.25 1.25 0 0114.25 16.5h-8.5A1.25 1.25 0 014.5 15.25v-8.5zM7 10a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm-6 3a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2z' clip-rule='evenodd' /%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: 10px center; background-size: 20px; }

        .sort-btn { height:38px; border:1px solid #d1d5db; border-radius:12px; padding:0 14px; background:#f9fafb; color:#374151; font-size:13px; font-weight:700; cursor:pointer; }
        .sort-btn.active { border-color:var(--green); color:var(--green); background:#ecf8f1; }

        .rank-tabs { margin-top:24px; display:flex; gap:10px; border-bottom: 1px solid var(--line); }
        .rank-tab { padding:0 4px 12px; text-decoration:none; display:inline-flex; align-items:center; font-weight:700; font-size:16px; color:var(--muted); border-bottom: 3px solid transparent; cursor: pointer; }
        .rank-tab.active { color:var(--green); border-bottom-color: var(--green); }

        .grid { margin-top:24px; display:grid; grid-template-columns:1fr 1fr; gap:24px; }

        /* New Theme: Deep Green vs Gold */
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
        .rank-item { display:flex; align-items:center; gap:12px; padding:10px; border-radius:10px; }
        .item-main { flex:1; min-width:0; }
        .item-name { font-size:16px; font-weight:700; line-height:1.3; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .item-meta { margin-top:2px; font-size:13px; color:var(--muted); }
        .item-value { font-size:18px; font-weight:700; white-space:nowrap; color:#111827; flex-shrink: 0; }

        .no-data { text-align: center; padding: 60px 20px; color: var(--muted); }

        @media (max-width:960px){ .grid{grid-template-columns:1fr;} }
    </style>
</head>
<body>
<div class="zl-app">
<%@ include file="/branch/common/layout/sidebar.jsp" %>
<div class="zl-content">
<main class="p-6">
    <header class="head">
        <h1>매출 순위</h1>
        <p>설정된 기간의 메뉴, 일자, 요일, 시간대별 매출 순위를 분석합니다.</p>
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
            <div class="filter-group">
                <span class="label">정렬기준:</span>
                <button class="sort-btn active" data-sort="sales">매출액</button>
                <button class="sort-btn" data-sort="quantity">판매 수량</button>
            </div>
        </div>
    </section>

    <nav class="rank-tabs" aria-label="랭킹 종류">
        <a class="rank-tab active" data-rank-type="menu">메뉴별</a>
        <a class="rank-tab" data-rank-type="daily">일자별</a>
        <a class="rank-tab" data-rank-type="weekly">요일별</a>
        <a class="rank-tab" data-rank-type="hourly">시간대별</a>
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
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
    flatpickr.localize(flatpickr.l10ns.ko);

    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const periodStartPicker = flatpickr("#period-start", {
        defaultDate: thirtyDaysAgo,
        dateFormat: "Y-m-d",
        onChange: function(selectedDates, dateStr, instance) { fetchData(); }
    });
    const periodEndPicker = flatpickr("#period-end", {
        defaultDate: "today",
        dateFormat: "Y-m-d",
        onChange: function(selectedDates, dateStr, instance) { fetchData(); }
    });

    const sortButtons = document.querySelectorAll('.sort-btn');
    const rankTabs = document.querySelectorAll('.rank-tab');

    const bestList = document.getElementById('best-list');
    const worstList = document.getElementById('worst-list');
    const bestTitle = document.getElementById('best-title');
    const worstTitle = document.getElementById('worst-title');

    let currentSort = 'sales';
    let currentRankType = 'menu';

    function updateTitles() {
        const sortText = currentSort === 'sales' ? '매출액' : '판매 수량';
        const rankTypeText = {
            menu: '메뉴',
            daily: '일자',
            weekly: '요일',
            hourly: '시간대'
        }[currentRankType];

        bestTitle.textContent = `\${rankTypeText}별 \${sortText} TOP 10`;
        worstTitle.textContent = `\${rankTypeText}별 \${sortText} WORST 10`;
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
                ? `₩\${Math.round(numValue).toLocaleString('ko-KR')}`
                : `\${numValue.toLocaleString('ko-KR')}개`;
        };

        const itemsHtml = data.map((item, index) => {
            const rank = index + 1;
            return `
            <div class="rank-item">
                <div class="rank-no">\${rank}위</div>
                <div class="item-main">
                    <div class="item-name">\${item.name}</div>
                    <div class="item-meta">\${item.meta || ''}</div>
                </div>
                <div class="item-value">\${formatValue(item.value)}</div>
            </div>
            `;
        }).join('');
        container.innerHTML = itemsHtml;
    }

    function fetchData() {
        const startDate = periodStartPicker.input.value;
        const endDate = periodEndPicker.input.value;
        const contextPath = window.__ZEROLOSS_CP || '';

        updateTitles();

        bestList.innerHTML = '<div class="no-data">데이터를 불러오는 중...</div>';
        worstList.innerHTML = '<div class="no-data">데이터를 불러오는 중...</div>';

        const url = `\${contextPath}/branch/sales/rank?rankType=\${currentRankType}&sort=\${currentSort}&startDate=\${startDate}&endDate=\${endDate}`;

        fetch(url)
            .then(response => {
                if (response.status === 401) {
                    commonShowAlert('알림', '로그인 세션이 만료되었습니다. 다시 로그인해주세요.');
                    window.location.href = contextPath + '/login';
                    return Promise.reject('Unauthorized');
                }
                if (!response.ok) {
                    throw new Error('데이터를 불러오는 데 실패했습니다.');
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                renderList(bestList, data.top10);
                renderList(worstList, data.worst10);
            })
            .catch(error => {
                console.error('Error fetching rank data:', error);
                const errorMsg = `<div class="no-data">\${error.message}</div>`;
                bestList.innerHTML = errorMsg;
                worstList.innerHTML = errorMsg;
            });
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
            fetchData();
        });
    });

    // 초기 데이터 로드
    fetchData();
});
</script>
</body>
</html>
