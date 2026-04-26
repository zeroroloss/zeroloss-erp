<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>매출 조회</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <%-- 공통 레이아웃 헤더 포함 --%>
    <%@ include file="/branch/common/layout/layout_head.jsp" %>

    <style>
        /* 페이지 전용 스타일 */
        .head h1 { font-size: 1.875rem; line-height: 2.25rem; font-weight: 800; } /* 3xl, font-extrabold */
        .head p { color: #6b7280; } /* text-gray-500 */
        .search-panel { margin-top:24px; border:1px solid var(--line); border-radius:18px; background:#fff; box-shadow:0 1px 2px rgba(15,23,42,0.05); padding:18px; }
        .filters { display:flex; flex-wrap:wrap; align-items:center; gap:12px; }
        .tabs { display:flex; align-items:center; gap:10px; }
        .tabs::after { content:""; width:1px; height:42px; background:#d1d5db; margin-left:4px; }
        .tab { height:38px; border-radius:12px; border:1px solid #d1d5db; background:#f9fafb; color:#374151; font-size:14px; font-weight:700; padding:0 16px; cursor:pointer; }
        .tab.active { border-color:var(--green); color:var(--green); background:#ecf8f1; }
        .filter-inputs { display:flex; align-items:center; gap:10px; }
        .filter-inputs input, .filter-inputs select { height:38px; min-width:180px; border-radius:12px; border:1px solid #d1d5db; background:#fff; color:#1f2937; padding:0 13px; font-size:13px; }
        .search { margin-left:auto; height:38px; border-radius:12px; border:1px solid var(--green); background:var(--green); color:#fff; padding:0 18px; font-size:14px; font-weight:700; cursor:pointer; display:inline-flex; align-items:center; gap:8px; }

        .summary-title { margin:24px 0 12px; font-size:23px; letter-spacing:-0.2px; }
        .stats { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; }
        .stat { border:1px solid var(--line); border-radius:16px; background:#fff; padding:20px 22px; box-shadow:0 1px 2px rgba(15,23,42,0.04); }
        .stat .meta { display:flex; align-items:flex-start; justify-content:space-between; gap:10px; }
        .stat em { font-style:normal; color:#6b7280; font-size:14px; }
        .stat strong { display:block; margin-top:8px; font-size:26px; letter-spacing:-0.2px; }
        .icon-chip { width:40px; height:40px; border-radius:10px; display:grid; place-items:center; font-size:18px; }
        .chip-money { background:#e7f4ec; color:#11894a; }
        .chip-order { background:#f8f0da; color:#c08b00; }
        .chip-trend { background:#e8edf6; color:#2563eb; }
        .chip-menu { background:#eaf3ec; color:#b07a00; }

        .tab-content { margin-top:18px; display:none; }
        .tab-content.active { display:block; }
        .chart-wrap{border:1px solid #d9dee5;border-radius:16px;padding:20px; background:#fff;}
        .chart-title{font-size:22px;font-weight:700;margin-bottom:14px;}
        .result-card{margin-top:18px;border:1px solid #d9dee5;border-radius:16px;overflow:hidden; background:#fff;}
        .result-head{padding:18px 20px;font-size:20px;font-weight:700;border-bottom:1px solid #e5e7eb;}
        table{width:100%;border-collapse:collapse;} th,td{padding:14px 18px;border-bottom:1px solid #e5e7eb;font-size:15px;text-align:right;} th{background:#f9fafb;color:#6b7280;font-weight:700;} th:first-child,td:first-child{text-align:left;} th:nth-child(2),td:nth-child(2){text-align:left;}
        .pager{display:flex;justify-content:center;align-items:center;padding:16px 20px;font-size:14px;color:#6b7280;}
        .pages{display:flex;gap:8px;align-items:center;} .p{width:34px;height:34px;border:1px solid #d1d5db;border-radius:12px;background:#fff;color:#374151;display:grid;place-items:center;font-size:14px;font-weight:700; cursor:pointer;} .p.active{background:var(--green);color:#fff;border-color:var(--green);}
        .is-hidden { display:none !important; }
    </style>
</head>
<body>
<div class="zl-app">
    <%@ include file="/branch/common/layout/sidebar.jsp" %>
    <div class="zl-content">
        <%@ include file="/branch/common/layout/topbar.jsp" %>
        <main class="p-6">
            <header class="head">
                <h1 class="text-3xl font-bold">매출 조회</h1>
                <p>일별, 기간별, 시간대별, 메뉴별 매출 데이터를 조회하고 분석합니다.</p>
            </header>

            <section class="search-panel">
                <div class="filters">
                    <div class="tabs" role="tablist">
                        <button class="tab active" type="button" data-tab="daily">일별</button>
                        <button class="tab" type="button" data-tab="period">기간별</button>
                        <button class="tab" type="button" data-tab="hourly">시간대별</button>
                        <button class="tab" type="button" data-tab="menu">메뉴별</button>
                    </div>
                    <div class="filter-inputs" data-input="daily">
                        <input type="date" id="daily-date" value="2026-04-19">
                    </div>
                    <div class="filter-inputs is-hidden" data-input="period">
                        <input type="date" id="period-start" value="2026-04-01">
                        <input type="date" id="period-end" value="2026-04-19">
                    </div>
                    <div class="filter-inputs is-hidden" data-input="hourly">
                        <input type="date" id="hourly-date" value="2026-04-19">
                    </div>
                    <div class="filter-inputs is-hidden" data-input="menu">
                         <input type="date" id="menu-date" value="2026-04-19">
                    </div>
                    <button class="search" id="searchButton" type="button"><i class="fas fa-search mr-2"></i>검색</button>
                </div>
            </section>

            <div id="main-summary" class="tab-content active">
                <h2 class="summary-title">오늘의 매출 요약</h2>
                <section class="stats">
                    <article class="stat"><div class="meta"><em>총 매출</em><span class="icon-chip chip-money"><i class="fas fa-won-sign"></i></span></div><strong id="summary-sales">₩0</strong></article>
                    <article class="stat"><div class="meta"><em>총 주문수</em><span class="icon-chip chip-order"><i class="fas fa-receipt"></i></span></div><strong id="summary-orders">0건</strong></article>
                    <article class="stat"><div class="meta"><em>평균 객단가</em><span class="icon-chip chip-trend"><i class="fas fa-chart-line"></i></span></div><strong id="summary-avg-price">₩0</strong></article>
                    <article class="stat"><div class="meta"><em>인기 메뉴</em><span class="icon-chip chip-menu"><i class="fas fa-star"></i></span></div><strong id="summary-top-menu">-</strong></article>
                </section>
            </div>

            <div id="daily-content" class="tab-content">
                <div class="chart-wrap"><canvas id="daily-chart"></canvas></div>
                <div class="result-card"><div class="result-head">일별 매출 상세</div><table><thead><tr><th>날짜</th><th>매출액</th><th>주문수</th><th>평균 객단가</th></tr></thead><tbody id="daily-table"></tbody></table></div>
            </div>
            <div id="period-content" class="tab-content">
                <div class="chart-wrap"><canvas id="period-chart"></canvas></div>
                <div class="result-card"><div class="result-head">기간별 매출 상세</div><table><thead><tr><th>날짜</th><th>매출액</th><th>주문수</th><th>평균 객단가</th></tr></thead><tbody id="period-table"></tbody></table></div>
            </div>
            <div id="hourly-content" class="tab-content">
                <div class="chart-wrap"><canvas id="hourly-chart"></canvas></div>
                <div class="result-card"><div class="result-head">시간대별 매출 상세</div><table><thead><tr><th>시간대</th><th>매출액</th><th>주문수</th><th>평균 객단가</th></tr></thead><tbody id="hourly-table"></tbody></table></div>
            </div>
            <div id="menu-content" class="tab-content">
                <div class="chart-wrap"><canvas id="menu-chart"></canvas></div>
                <div class="result-card"><div class="result-head">메뉴별 매출 상세</div><table><thead><tr><th>메뉴명</th><th>판매량</th><th>매출액</th><th>매출 비중</th></tr></thead><tbody id="menu-table"></tbody></table></div>
            </div>
        </main>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const tabs = document.querySelectorAll('.tab');
    const tabContents = document.querySelectorAll('.tab-content');
    const inputGroups = document.querySelectorAll('.filter-inputs');
    const searchButton = document.getElementById('searchButton');

    let activeTab = 'daily';
    const charts = {};

    function createOrUpdateChart(canvasId, type, data, options) {
        if (charts[canvasId]) {
            charts[canvasId].destroy();
        }
        const ctx = document.getElementById(canvasId).getContext('2d');
        charts[canvasId] = new Chart(ctx, { type, data, options });
    }

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const tabName = tab.dataset.tab;
            document.getElementById('main-summary').classList.remove('active');
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            tabContents.forEach(content => {
                if(content.id !== 'main-summary') {
                    content.classList.toggle('active', content.id === `${tabName}-content`);
                }
            });
            inputGroups.forEach(input => {
                input.classList.toggle('is-hidden', input.dataset.input !== tabName);
            });
            activeTab = tabName;
            fetchData();
        });
    });

    searchButton.addEventListener('click', fetchData);

    function fetchData() {
        console.log(`Fetching data for: ${activeTab}`);
        switch(activeTab) {
            case 'daily': renderDailyData(); break;
            case 'period': renderPeriodData(); break;
            case 'hourly': renderHourlyData(); break;
            case 'menu': renderMenuData(); break;
        }
    }

    function renderDailyData() {
        // 백엔드 연동 시 이 부분에 API 호출 및 데이터 처리 로직 추가
        createOrUpdateChart('daily-chart', 'bar', {
            labels: [], datasets: [{ label: '일별 매출', data: [], backgroundColor: 'rgba(0, 133, 61, 0.7)' }]
        }, {});
        document.getElementById('daily-table').innerHTML = '';
    }

    function renderPeriodData() {
        createOrUpdateChart('period-chart', 'line', {
            labels: [], datasets: [{ label: '기간별 매출', data: [], borderColor: 'rgba(0, 133, 61, 1)', tension: 0.1 }]
        }, {});
        document.getElementById('period-table').innerHTML = '';
    }

    function renderHourlyData() {
        createOrUpdateChart('hourly-chart', 'bar', {
            labels: [], datasets: [{ label: '시간대별 매출', data: [], backgroundColor: 'rgba(247, 204, 0, 0.7)' }]
        }, {});
        document.getElementById('hourly-table').innerHTML = '';
    }

    function renderMenuData() {
        createOrUpdateChart('menu-chart', 'pie', {
            labels: [], datasets: [{ label: '메뉴별 매출', data: [], backgroundColor: ['#00853d', '#ffc72c', '#a50034', '#cccccc'] }]
        }, {});
        document.getElementById('menu-table').innerHTML = '';
    }

    function loadMainSummary() {
        // 백엔드 연동 시 이 부분에 API 호출 및 데이터 처리 로직 추가
        document.getElementById('summary-sales').textContent = '₩0';
        document.getElementById('summary-orders').textContent = '0건';
        document.getElementById('summary-avg-price').textContent = '₩0';
        document.getElementById('summary-top-menu').textContent = '-';
    }

    loadMainSummary();
});
</script>
</body>
</html>
