<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직영점 매출 조회 - ZERO LOSS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.4.0/dist/chartjs-plugin-annotation.min.js"></script>

    <%-- flatpickr --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

    <%-- 직영점 layout_head.jsp 내용 하드코딩 시작 --%>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
          --green: #00853D;
          --line: #e5e7eb;
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
        .zl-app { min-height: 100vh; background: #f3f4f6; font-size: 16px; color: #111827; display: flex; }
        .zl-sidebar { position: fixed; top: 0; left: 0; width: 288px; height: 100vh; background: #ffffff; border-right: 1px solid var(--line); overflow-y: auto; z-index: 40; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04); }
        .zl-content { flex-grow: 1; margin-left: 288px; display: flex; flex-direction: column; }
        main { flex-grow: 1; }

        @media (max-width: 1200px) {
          .zl-sidebar {
            transform: translateX(-100%);
            transition: transform 0.3s ease-in-out;
            z-index: 50;
          }
          .sidebar-open .zl-sidebar {
            transform: translateX(0);
          }
          .zl-content {
            margin-left: 0;
          }
        }
    </style>
    <script>
        window.__ZEROLOSS_CP = '<%= request.getContextPath() %>';
        document.addEventListener('DOMContentLoaded', function () {
          var cp = window.__ZEROLOSS_CP || '';
          if (!cp) {
            return;
          }
          // 본사(hq) 경로에 맞게 수정
          document.querySelectorAll('a[href^="/hq/"]').forEach(function (link) {
            var originalHref = link.getAttribute('href');
            if(originalHref.startsWith(cp)) return;
            link.href = cp + originalHref;
          });

          document.querySelectorAll('form[action^="/hq/"]').forEach(function (form) {
            var originalAction = form.getAttribute('action');
            if(originalAction.startsWith(cp)) return;
            form.action = cp + originalAction;
          });
        });
    </script>
    <%-- 직영점 layout_head.jsp 내용 하드코딩 끝 --%>


    <style>
        /* 페이지 전용 스타일 */
        .head h1 { font-size: 1.875rem; line-height: 2.25rem; font-weight: 700; }
        .head p { color: #6b7280; }
        .search-panel { margin-top:24px; border:1px solid var(--line); border-radius:18px; background:#fff; box-shadow:0 1px 2px rgba(15,23,42,0.05); padding:18px; display: flex; align-items: center; justify-content: space-between; }
        .filters { display:flex; flex-wrap:wrap; align-items:center; gap:12px; }
        .tabs { display:flex; align-items:center; gap:10px; }
        .tabs::after { content:""; width:1px; height:42px; background:#d1d5db; margin-left:4px; }
        .tab { height:38px; border-radius:12px; border:1px solid #d1d5db; background:#f9fafb; color:#374151; font-size:14px; font-weight:700; padding:0 16px; cursor:pointer; }
        .tab.active { border-color:var(--green); color:var(--green); background:#ecf8f1; }
        .filter-inputs { display:flex; align-items:center; gap:10px; }
        .filter-inputs input, .filter-inputs select { height:38px; min-width:180px; border-radius:12px; border:1px solid #d1d5db; background:#fff; color:#1f2937; padding:0 13px; font-size:13px; }

        .date-picker-wrap { position:relative; }
        .date-picker-wrap input { padding-left: 38px !important; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af' class='w-5 h-5'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zM4.5 6.75A1.25 1.25 0 015.75 5.5h8.5A1.25 1.25 0 0115.5 6.75v8.5A1.25 1.25 0 0114.25 16.5h-8.5A1.25 1.25 0 014.5 15.25v-8.5zM7 10a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm-6 3a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2z' clip-rule='evenodd' /%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: 10px center; background-size: 20px; }

        .btn-group { display:flex; gap:8px; }
        .btn { height:38px; border-radius:12px; padding:0 18px; font-size:14px; font-weight:700; cursor:pointer; display:inline-flex; align-items:center; gap:8px; border:1px solid transparent; }
        .btn-search { background:var(--green); color:#fff; border-color:var(--green); }
        .btn-reset { background:#f3f4f6; color:#374151; border-color:#e5e7eb; }

        .tab-content { margin-top:18px; display:none; }
        .tab-content.active { display:block; }
        .chart-wrap{border:1px solid #d9dee5;border-radius:16px;padding:20px; background:#fff; height: 450px; }
        .period-summary { margin-bottom: 16px; text-align: center; font-size: 1.1rem; font-weight: 500; color: #374151; }
        .chart-title{font-size:22px;font-weight:700;margin-bottom:14px;}
        .result-card{margin-top:18px;border:1px solid #d9dee5;border-radius:16px;overflow:hidden; background:#fff;}
        .result-head{padding:18px 20px;font-size:20px;font-weight:700;border-bottom:1px solid #e5e7eb;}
        table{width:100%;border-collapse:collapse;} th,td{padding:14px 18px;border-bottom:1px solid #e5e7eb;font-size:15px;text-align:right;} th{background:#f9fafb;color:#6b7280;font-weight:700;} th:first-child,td:first-child{text-align:left;} th:nth-child(2),td:nth-child(2){text-align:left;}
        .weekend-row { color: #2563eb; font-weight: 500; }
        .pager{display:flex;justify-content:center;align-items:center;padding:16px 20px;font-size:14px;color:#6b7280;}
        .pages{display:flex;gap:8px;align-items:center;} .p{width:34px;height:34px;border:1px solid #d1d5db;border-radius:12px;background:#fff;color:#374151;display:grid;place-items:center;font-size:14px;font-weight:700; cursor:pointer;} .p.active{background:var(--green);color:#fff;border-color:var(--green);}
        .is-hidden { display:none !important; }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/hq/common/sidebar.jsp" %>
	<div class="lg:pl-72">
		<main class="p-6">
			<header class="head">
				<h1 class="text-3xl font-bold">직영점 매출 조회</h1>
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
					<div class="filter-inputs">
						<select id="branch-selector">
							<option value="" disabled selected>직영점을 선택하세요</option>
						</select>
					</div>
					<div class="filter-inputs" data-input="daily">
						<div class="date-picker-wrap">
							<input type="text" id="daily-date" placeholder="날짜 선택">
						</div>
					</div>
					<div class="filter-inputs is-hidden" data-input="period">
						<div class="date-picker-wrap">
							<input type="text" id="period-start" placeholder="시작일 선택">
						</div>
						<span class="text-gray-500">~</span>
						<div class="date-picker-wrap">
							<input type="text" id="period-end" placeholder="종료일 선택">
						</div>
					</div>
					<div class="filter-inputs is-hidden" data-input="hourly">
						<div class="date-picker-wrap">
							<input type="text" id="hourly-date" placeholder="날짜 선택">
						</div>
					</div>
					<div class="filter-inputs is-hidden" data-input="menu">
						<div class="date-picker-wrap">
							<input type="text" id="menu-date" placeholder="날짜 선택">
						</div>
					</div>
				</div>
				<div class="btn-group">
					<button class="btn btn-search" id="searchButton" type="button">
						<i class="fas fa-search mr-2"></i>검색
					</button>
				</div>
			</section>

			<div id="daily-content" class="tab-content">
				<div class="chart-wrap">
					<canvas id="daily-chart"></canvas>
				</div>
				<div class="result-card">
					<div class="result-head">일별 매출 상세</div>
					<table>
						<thead>
							<tr>
								<th>일자</th>
								<th>요일</th>
								<th>매출액</th>
								<th>주문 건수</th>
								<th>누적 매출</th>
							</tr>
						</thead>
						<tbody id="daily-table"></tbody>
					</table>
				</div>
			</div>

			<div id="period-content" class="tab-content">
				<div class="chart-wrap">
					<div id="period-summary" class="period-summary"></div>
					<canvas id="period-chart"></canvas>
				</div>
				<div class="result-card">
					<div class="result-head">기간별 매출 상세</div>
					<table>
						<thead>
							<tr>
								<th>일자</th>
								<th>요일</th>
								<th>매출액</th>
								<th>주문 건수</th>
								<th>누적 매출</th>
							</tr>
						</thead>
						<tbody id="period-table"></tbody>
					</table>
				</div>
			</div>
			<div id="hourly-content" class="tab-content">
				<div class="chart-wrap">
					<canvas id="hourly-chart"></canvas>
				</div>
				<div class="result-card">
					<div class="result-head">시간대별 매출 상세</div>
					<table>
						<thead>
							<tr>
								<th>시간대</th>
								<th>매출액</th>
								<th>주문수</th>
								<th>평균 객단가</th>
							</tr>
						</thead>
						<tbody id="hourly-table"></tbody>
					</table>
				</div>
			</div>
			<div id="menu-content" class="tab-content">
				<div class="chart-wrap">
					<canvas id="menu-chart"></canvas>
				</div>
				<div class="result-card">
					<div class="result-head">메뉴별 매출 상세</div>
					<table>
						<thead>
							<tr>
								<th>메뉴명</th>
								<th>판매량</th>
								<th>매출액</th>
								<th>매출 비중</th>
							</tr>
						</thead>
						<tbody id="menu-table"></tbody>
					</table>
				</div>
			</div>
		</main>
	</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');
        const inputGroups = document.querySelectorAll('.filter-inputs[data-input]');
        const searchButton = document.getElementById('searchButton');
        const branchSelector = document.getElementById('branch-selector');

        flatpickr.localize(flatpickr.l10ns.ko);

        const commonDateConfig = {
            dateFormat: "Y-m-d",
            allowInput: true,
        };

        flatpickr("#daily-date", {...commonDateConfig, defaultDate: "today"});
        flatpickr("#hourly-date", {...commonDateConfig, defaultDate: "today"});
        flatpickr("#menu-date", {...commonDateConfig, defaultDate: "today"});

        const oneMonthAgo = new Date();
        oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);

        flatpickr("#period-start", {...commonDateConfig, defaultDate: oneMonthAgo});
        flatpickr("#period-end", {...commonDateConfig, defaultDate: "today"});

        const charts = {};

        function createOrUpdateChart(canvasId, config) {
            if (charts[canvasId]) {
                charts[canvasId].destroy();
            }
            const ctx = document.getElementById(canvasId).getContext('2d');
            charts[canvasId] = new Chart(ctx, config);
        }

        // 지점 목록 로드 함수
        function loadBranches() {
            const contextPath = window.__ZEROLOSS_CP || '';
            fetch(contextPath + '/hq/sales/branches')
                .then(response => response.json())
                .then(data => {
                    data.forEach(branch => {
                        if (branch.name !== '본사') {
                            const option = document.createElement('option');
                            option.value = branch.branchCode;
                            option.textContent = branch.name;
                            branchSelector.appendChild(option);
                        }
                    });
                })
                .catch(error => console.error('Error fetching branches:', error));
        }

        tabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                const selectedTab = e.currentTarget.dataset.tab;
                tabs.forEach(t => t.classList.remove('active'));
                e.currentTarget.classList.add('active');

                // 데이터 표시 영역은 그대로 두고, 날짜 필터만 교체
                inputGroups.forEach(input => {
                    input.classList.toggle('is-hidden', input.dataset.input !== selectedTab);
                });
            });
        });

        searchButton.addEventListener('click', fetchData);

        function fetchData() {
            const activeTabEl = document.querySelector('.tabs .tab.active');
            const activeTab = activeTabEl.dataset.tab;

            const branchCode = document.getElementById('branch-selector').value;
            if (!branchCode) {
                alert('직영점을 먼저 선택해주세요.');
                return;
            }

            tabContents.forEach(content => content.classList.remove('active'));
            const activeContent = document.getElementById(activeTab + '-content');
            if (activeContent) {
                activeContent.classList.add('active');
            }

            console.log(`[검색] 탭: \${activeTab}, 지점: \${branchCode}`);

            switch(activeTab) {
                case 'daily':
                    fetchDailyData();
                    break;
                case 'period':
                    fetchPeriodData();
                    break;
                case 'hourly':
                    fetchHourlyData();
                    break;
                case 'menu':
                    fetchMenuData();
                    break;
            }
        }

        function fetchDailyData() {
            const branchCode = document.getElementById('branch-selector').value;
            const targetDate = document.getElementById('daily-date').value;
            const contextPath = window.__ZEROLOSS_CP || '';
            const url = `${contextPath}/hq/sales/daily?branchCode=${branchCode}&date=${targetDate}`;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if(data.error) { alert(data.error); return; }
                    renderDailyChart(data);
                    renderDailyTable(data);
                })
                .catch(error => console.error('Error fetching daily sales:', error));
        }

        function fetchPeriodData() {
            const branchCode = document.getElementById('branch-selector').value;
            const startDate = document.getElementById('period-start').value;
            const endDate = document.getElementById('period-end').value;
            const contextPath = window.__ZEROLOSS_CP || '';
            const url = `${contextPath}/hq/sales/period?branchCode=${branchCode}&startDate=${startDate}&endDate=${endDate}`;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if(data.error) { alert(data.error); return; }
                    renderPeriodChart(data);
                    renderPeriodTable(data);
                })
                .catch(error => console.error('Error fetching period sales:', error));
        }

        function fetchDailyData() {
            const branchCode = document.getElementById('branch-selector').value;
            const targetDate = document.getElementById('daily-date').value;
            const contextPath = window.__ZEROLOSS_CP || '';
            // JSP EL 충돌 방지를 위해 + 연산자로 문자열 결합
            const url = contextPath + '/hq/sales/daily?branchCode=' + branchCode + '&date=' + targetDate;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if(data.error) { alert(data.error); return; }
                    renderDailyChart(data);
                    renderDailyTable(data);
                })
                .catch(error => console.error('Error fetching daily sales:', error));
        }

        function fetchPeriodData() {
            const branchCode = document.getElementById('branch-selector').value;
            const startDate = document.getElementById('period-start').value;
            const endDate = document.getElementById('period-end').value;
            const contextPath = window.__ZEROLOSS_CP || '';
            // JSP EL 충돌 방지를 위해 + 연산자로 문자열 결합
            const url = contextPath + '/hq/sales/period?branchCode=' + branchCode + '&startDate=' + startDate + '&endDate=' + endDate;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if(data.error) { alert(data.error); return; }
                    renderPeriodChart(data);
                    renderPeriodTable(data);
                })
                .catch(error => console.error('Error fetching period sales:', error));
        }

        function fetchHourlyData() {
            const branchCode = document.getElementById('branch-selector').value;
            const targetDate = document.getElementById('hourly-date').value;
            const contextPath = window.__ZEROLOSS_CP || '';
            // JSP EL 충돌 방지를 위해 + 연산자로 문자열 결합
            const url = contextPath + '/hq/sales/hourly?branchCode=' + branchCode + '&date=' + targetDate;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if(data.error) { alert(data.error); return; }
                    renderHourlyChart(data);
                    renderHourlyTable(data);
                })
                .catch(error => console.error('Error fetching hourly sales:', error));
        }

        function fetchMenuData() {
            const branchCode = document.getElementById('branch-selector').value;
            const targetDate = document.getElementById('menu-date').value;
            const contextPath = window.__ZEROLOSS_CP || '';
            // JSP EL 충돌 방지를 위해 + 연산자로 문자열 결합
            const url = contextPath + '/hq/sales/menu?branchCode=' + branchCode + '&date=' + targetDate;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if(data.error) { alert(data.error); return; }
                    renderMenuChart(data);
                    renderMenuTable(data);
                })
                .catch(error => console.error('Error fetching menu sales:', error));
        }

        function renderMenuChart(data) {
            const topN = 10;
            const topData = data.slice(0, topN);
            const labels = topData.map(d => d.menuName);
            const salesData = topData.map(d => d.totalSales);
            const maxSales = data.length > 0 ? Math.max(...salesData) : 0;

            const chartConfig = {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '매출액',
                        data: salesData,
                        backgroundColor: 'rgba(0, 133, 61, 0.7)',
                        borderColor: 'var(--green)',
                        borderWidth: 1
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        title: { display: true, text: `매출 상위 \${topN} 메뉴` }
                    },
                    scales: {
                        x: { beginAtZero: true, max: maxSales * 1.2, title: { display: true, text: '매출액 (원)' } }
                    }
                }
            };
            createOrUpdateChart('menu-chart', chartConfig);
        }

        function renderMenuTable(data) {
            const tableBody = document.getElementById('menu-table');
            tableBody.innerHTML = '';
            const formatCurrency = (amount) => new Intl.NumberFormat('ko-KR').format(amount);

            data.forEach(item => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>\${item.menuName}</td>
                    <td>\${item.quantity}개</td>
                    <td>₩\${formatCurrency(item.totalSales)}</td>
                    <td>\${item.salesShare.toFixed(2)}%</td>
                `;
                tableBody.appendChild(row);
            });
        }

        function renderHourlyChart(data) {
            const labels = data.map(d => d.hour + '시');
            const salesData = data.map(d => d.totalSales);
            const ordersData = data.map(d => d.totalOrders);
            const maxSales = data.length > 0 ? Math.max(...salesData) : 0;
            const maxOrders = data.length > 0 ? Math.max(...ordersData) : 0;

            const chartConfig = {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        { type: 'bar', label: '매출액', data: salesData, backgroundColor: 'rgba(0, 133, 61, 0.7)', yAxisID: 'y-sales' },
                        { type: 'line', label: '주문 건수', data: ordersData, borderColor: 'rgb(255, 99, 132)', backgroundColor: 'rgba(255, 99, 132, 0.2)', fill: true, tension: 0.3, yAxisID: 'y-orders' }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'top' }, title: { display: true, text: document.getElementById('hourly-date').value + ' 시간대별 매출 및 주문 건수' } },
                    scales: {
                        'y-sales': { type: 'linear', position: 'left', title: { display: true, text: '매출액 (원)' }, beginAtZero: true, max: maxSales * 1.2 },
                        'y-orders': { type: 'linear', position: 'right', title: { display: true, text: '주문 건수' }, beginAtZero: true, grid: { drawOnChartArea: false }, max: maxOrders * 1.2 }
                    }
                }
            };
            createOrUpdateChart('hourly-chart', chartConfig);
        }

        function renderHourlyTable(data) {
            const tableBody = document.getElementById('hourly-table');
            tableBody.innerHTML = '';
            const formatCurrency = (amount) => new Intl.NumberFormat('ko-KR').format(amount);
            let maxSales = 0;
            let peakHour = -1;

            data.forEach(item => { if (item.totalSales > maxSales) { maxSales = item.totalSales; peakHour = item.hour; } });

            const fullHourlyData = Array.from({length: 24}, (_, i) => ({ hour: i, totalSales: 0, totalOrders: 0 }));
            data.forEach(item => { fullHourlyData[item.hour] = item; });

            fullHourlyData.forEach(item => {
                const row = document.createElement('tr');
                const avgOrderValue = item.totalOrders > 0 ? item.totalSales / item.totalOrders : 0;
                if (item.hour === peakHour && maxSales > 0) { row.style.backgroundColor = '#ecf8f1'; row.style.fontWeight = 'bold'; }
                row.innerHTML = `<td>\${item.hour}시</td><td>₩\${formatCurrency(item.totalSales)}</td><td>\${item.totalOrders}건</td><td>₩\${formatCurrency(Math.round(avgOrderValue))}</td>`;
                tableBody.appendChild(row);
            });
        }

        function renderDailyChart(data) {
            const labels = data.map(d => d.saleDate.substring(5));
            const salesData = data.map(d => d.totalSales);
            const ordersData = data.map(d => d.totalOrders);
            const maxSales = data.length > 0 ? Math.max(...salesData) : 0;
            const maxOrders = data.length > 0 ? Math.max(...ordersData) : 0;

            const chartConfig = {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        { type: 'line', label: '매출액', data: salesData, borderColor: 'var(--green)', backgroundColor: 'var(--green)', yAxisID: 'y-sales', tension: 0.1 },
                        { type: 'bar', label: '주문 건수', data: ordersData, backgroundColor: 'rgba(0, 133, 61, 0.2)', yAxisID: 'y-orders' }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        'y-sales': { type: 'linear', position: 'left', title: { display: true, text: '매출액 (원)' }, max: maxSales * 1.2 },
                        'y-orders': { type: 'linear', position: 'right', title: { display: true, text: '주문 건수' }, grid: { drawOnChartArea: false }, max: maxOrders * 1.2 }
                    }
                }
            };
            createOrUpdateChart('daily-chart', chartConfig);
        }

        function renderDailyTable(data) {
            const tableBody = document.getElementById('daily-table');
            tableBody.innerHTML = '';
            const formatCurrency = (amount) => new Intl.NumberFormat('ko-KR').format(amount);
            const dayNames = ['일', '월', '화', '수', '목', '금', '토'];

            data.forEach(item => {
                const row = document.createElement('tr');
                const date = new Date(item.saleDate);
                const dayOfWeek = dayNames[date.getDay()];
                const isWeekend = date.getDay() === 0 || date.getDay() === 6;
                if (isWeekend) row.classList.add('weekend-row');
                row.innerHTML = `<td>\${item.saleDate}</td><td>\${dayOfWeek}</td><td>₩\${formatCurrency(item.totalSales)}</td><td>\${item.totalOrders}건</td><td>₩\${formatCurrency(item.cumulativeSales)}</td>`;
                tableBody.appendChild(row);
            });
        }

        function renderPeriodChart(data) {
            if (!data || data.length === 0) {
                document.getElementById('period-summary').textContent = '해당 기간에 매출 데이터가 없습니다.';
                createOrUpdateChart('period-chart', {type: 'bar', data: {labels:[], datasets:[]}});
                return;
            }
            const labels = data.map(d => d.saleDate.substring(5));
            const salesData = data.map(d => d.totalSales);
            const totalSales = data.reduce((sum, item) => sum + item.totalSales, 0);
            const avgSales = totalSales / data.length;
            const maxSales = data.length > 0 ? Math.max(...salesData) : 0;

            document.getElementById('period-summary').textContent = `선택한 기간(\${data.length}일) 동안 총 매출: ₩\${new Intl.NumberFormat('ko-KR').format(totalSales)}`;
            const chartType = data.length > 15 ? 'line' : 'bar';
            const chartConfig = {
                type: chartType,
                data: {
                    labels: labels,
                    datasets: [{ label: '매출액', data: salesData, borderColor: 'var(--green)', backgroundColor: chartType === 'line' ? 'transparent' : 'rgba(0, 133, 61, 0.7)', tension: 0.1 }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: { y: { max: maxSales * 1.2 } },
                    plugins: {
                        annotation: {
                            annotations: {
                                line1: { type: 'line', yMin: avgSales, yMax: avgSales, borderColor: 'rgb(255, 99, 132)', borderWidth: 2, borderDash: [5, 5], label: { content: `일평균: ₩\${new Intl.NumberFormat('ko-KR').format(Math.round(avgSales))}`, enabled: true, position: 'end' } }
                            }
                        }
                    }
                }
            };
            createOrUpdateChart('period-chart', chartConfig);
        }

        function renderPeriodTable(data) {
            const tableBody = document.getElementById('period-table');
            tableBody.innerHTML = '';
            const formatCurrency = (amount) => new Intl.NumberFormat('ko-KR').format(amount);
            const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
            data.forEach(item => {
                const row = document.createElement('tr');
                const date = new Date(item.saleDate);
                const dayOfWeek = dayNames[date.getDay()];
                if (date.getDay() === 0 || date.getDay() === 6) row.classList.add('weekend-row');
                row.innerHTML = `<td>\${item.saleDate}</td><td>\${dayOfWeek}</td><td>₩\${formatCurrency(item.totalSales)}</td><td>\${item.totalOrders}건</td><td>₩\${formatCurrency(item.cumulativeSales)}</td>`;
                tableBody.appendChild(row);
            });
        }

        // 페이지 초기화
        loadBranches();
    });
</script>
</body>
</html>
