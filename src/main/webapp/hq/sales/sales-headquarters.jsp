<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>본사 매출 조회 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <%-- flatpickr --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

    <%-- Chart.js --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.4.0/dist/chartjs-plugin-annotation.min.js"></script>

    <style>
        .sidebar-open .sidebar {
            transform: translateX(0);
        }
        .date-picker-wrap { position:relative; }
        .date-picker-wrap input, select {
            height: 38px;
            min-width: 180px;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            background: #fff;
            color: #1f2937;
            padding: 0 13px;
            font-size: 13px;
            outline: none;
            transition: border-color 0.2s;
        }
        .date-picker-wrap input:focus, select:focus {
            border-color: #00853D;
        }
        .date-picker-wrap input {
            padding-left: 38px !important;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af' class='w-5 h-5'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zM4.5 6.75A1.25 1.25 0 015.75 5.5h8.5A1.25 1.25 0 0115.5 6.75v8.5A1.25 1.25 0 0114.25 16.5h-8.5A1.25 1.25 0 014.5 15.25v-8.5zM7 10a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm-6 3a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2z' clip-rule='evenodd' /%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: 10px center;
            background-size: 20px;
            cursor: pointer;
        }
    </style>
</head>
<body class="bg-gray-50">
	    <%@ include file="/hq/common/sidebar.jsp" %>
        <!-- 메인 콘텐츠 -->
        <div class="lg:pl-72">

            <!-- 페이지 콘텐츠 -->
            <main class="p-6">
                <!-- 메인 컨테이너 -->
                <div class="space-y-6">

                    <!-- 페이지 헤더 -->
                    <div>
                        <h2 class="text-3xl font-bold text-gray-900">본사 매출 조회</h2>
                        <p class="text-gray-500 mt-1">본사 전체 매출 및 수익성을 분석합니다.</p>
                    </div>

                    <!-- 검색 영역 -->
                    <div class="bg-white rounded-lg border border-gray-200 p-4">
                        <div class="flex flex-wrap items-center gap-3">
                            <!-- 필터 타입 버튼 -->
                            <div class="flex gap-2">
                                <button class="px-3 py-2 rounded-lg border text-sm font-medium transition-all filterBtn" data-filter="date">
                                    날짜별
                                </button>
                                <button class="px-3 py-2 rounded-lg border text-sm font-medium transition-all filterBtn" data-filter="period">
                                    기간별
                                </button>
                                <button class="px-3 py-2 rounded-lg border text-sm font-medium transition-all filterBtn" data-filter="menu">
                                    메뉴별
                                </button>
                            </div>

                            <!-- Divider -->
                            <div class="h-8 w-px bg-gray-300 hidden sm:block"></div>

                            <!-- 필터 입력 -->
                            <div class="flex gap-2 flex-wrap" id="filterInputs"></div>

                            <!-- 액션 버튼 -->
                            <div class="flex gap-2 ml-auto">
                                <button id="searchButton" class="flex items-center gap-2 px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors font-medium text-sm">
                                    <i class="fas fa-search"></i>
                                    검색
                                </button>
                                <button id="resetBtn" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors font-medium text-sm">
                                    초기화
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 오늘의 매출 요약 -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4" id="todaySummaryCards">
                        <!-- 전지점 통합 총 매출 -->
                        <div class="bg-white rounded-lg border border-gray-200 p-5">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center">
                                    <i class="fas fa-dollar-sign w-5 h-5 text-blue-600"></i>
                                </div>
                                <p class="text-sm text-gray-500">전지점 통합 총 매출(일)</p>
                            </div>
                            <p class="text-2xl font-bold text-gray-900" id="totalSalesToday">₩0</p>
                        </div>

                        <!-- 총 주문건 수 -->
                        <div class="bg-white rounded-lg border border-gray-200 p-5">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
                                    <i class="fas fa-shopping-cart w-5 h-5 text-green-600"></i>
                                </div>
                                <p class="text-sm text-gray-500">총 주문건 수</p>
                            </div>
                            <p class="text-2xl font-bold text-gray-900" id="totalOrdersToday">0건</p>
                        </div>

                        <!-- 인기 메뉴 -->
                        <div class="bg-white rounded-lg border border-gray-200 p-5">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 rounded-lg bg-purple-100 flex items-center justify-center">
                                    <i class="fas fa-star w-5 h-5 text-purple-600"></i>
                                </div>
                                <p class="text-sm text-gray-500">인기 메뉴</p>
                            </div>
                            <p class="text-2xl font-bold text-gray-900" id="popularMenuToday">N/A</p>
                        </div>

                        <!-- 이번달 누적 매출 -->
                        <div class="bg-white rounded-lg border border-gray-200 p-5">
                            <div class="flex items-center gap-3 mb-2">
                                <div class="w-10 h-10 rounded-lg bg-orange-100 flex items-center justify-center">
                                    <i class="fas fa-calendar-alt w-5 h-5 text-orange-600"></i>
                                </div>
                                <p class="text-sm text-gray-500">이번달 누적 매출</p>
                            </div>
                            <p class="text-2xl font-bold text-gray-900" id="monthlyCumulativeSales">₩0</p>
                        </div>
                    </div>

                    <!-- 검색 결과 영역 -->
                    <div id="searchResultsSection" class="space-y-6 hidden">
                        <!-- 차트 영역 -->
                        <div class="bg-white rounded-lg border border-gray-200 p-6">
                            <h3 class="text-lg font-semibold text-gray-900 mb-4" id="chartTitle">주간 본사 전체 매출 현황</h3>
                            <div class="w-full h-96 flex items-center justify-center rounded-lg bg-gray-50 border border-gray-200">
                                <canvas id="salesChart"></canvas>
                            </div>
                        </div>

                        <!-- 상세 매출 내역 테이블 -->
                        <div id="dataTableSection" class="bg-white rounded-lg border border-gray-200 p-6">
                            <h3 class="text-lg font-semibold text-gray-900 mb-4" id="tableTitle">상세 매출 내역</h3>
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead id="tableHeader" class="bg-gray-50 border-b border-gray-200">
                                    </thead>
                                    <tbody id="tableBody" class="divide-y divide-gray-200"></tbody>
                                </table>
                            </div>

                            <!-- 페이지네이션 -->
							<div id="paginationContainer"
							     class="px-6 py-4 border-t border-gray-200 flex flex-col items-center justify-center gap-3 hidden">
							    <div id="paginationInfo" class="text-sm text-gray-600">
							        <!-- 동적으로 생성됨 -->
							    </div>
							
							    <div class="flex items-center justify-center gap-2">
							        <div id="pageButtons" class="flex items-center gap-1">
							            <!-- 동적으로 생성됨 -->
							        </div>
							    </div>
							</div>
                        </div>
                    </div>

                </div>
            </main>
        </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            let currentFilterType = null;
            let selectedDate = new Date().toISOString().split('T')[0];
            let startDate = new Date(new Date().setDate(new Date().getDate() - 6)).toISOString().split('T')[0];
            let endDate = new Date().toISOString().split('T')[0];
            let searched = false;
            let currentPage = 1;
            const itemsPerPage = 10;
            const PAGE_SIZE = 5;
            let currentSearchResults = [];

            let datePickerInstance;
            let startDatePickerInstance;
            let endDatePickerInstance;
            let salesChart;

            function formatCurrency(value) {
                return "₩" + (value || 0).toLocaleString();
            }

            function renderTodaySummary() {
                fetch("<%= request.getContextPath() %>/hq/sales/headquarters?action=summary")
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('totalSalesToday').textContent = formatCurrency(data.totalSales);
                        document.getElementById('totalOrdersToday').textContent = (data.totalOrders || 0).toLocaleString() + '건';
                        document.getElementById('popularMenuToday').textContent = data.popularMenu || 'N/A';
                        document.getElementById('monthlyCumulativeSales').textContent = formatCurrency(data.monthlyCumulativeSales);
                    })
                    .catch(error => console.error("매출 요약 데이터 조회 실패:", error));
            }

            function setFilterType(type, isInitialLoad = false) {
                if (!isInitialLoad && currentFilterType === type) return;

                currentFilterType = type;
                currentPage = 1;

                document.querySelectorAll('.filterBtn').forEach(btn => {
                    btn.classList.toggle('border-[#00853D]', btn.dataset.filter === type);
                    btn.classList.toggle('bg-[#00853D]/5', btn.dataset.filter === type);
                    btn.classList.toggle('text-[#00853D]', btn.dataset.filter === type);
                });

                renderFilterInputs();

                if (!searched) {
                    updateChartAndTableTitle();
                    document.getElementById("searchResultsSection").classList.add("hidden");
                    document.getElementById("todaySummaryCards").classList.remove("hidden");
                    document.getElementById("resetBtn").classList.add("hidden");
                }
            }

            function renderFilterInputs() {
                const container = document.getElementById("filterInputs");
                container.innerHTML = "";

                if (datePickerInstance) datePickerInstance.destroy();
                if (startDatePickerInstance) startDatePickerInstance.destroy();
                if (endDatePickerInstance) endDatePickerInstance.destroy();

                let html = "";
                const commonDateConfig = { dateFormat: "Y-m-d", allowInput: true, locale: "ko" };

                if (currentFilterType === 'date') {
                    html = '<div class="date-picker-wrap"><input type="text" id="dateInput" placeholder="날짜 선택"></div>';
                } else if (currentFilterType === 'period') {
                    html = '<div class="date-picker-wrap"><input type="text" id="startDateInput" placeholder="시작일 선택"></div>' +
                           '<span class="text-gray-500">~</span>' +
                           '<div class="date-picker-wrap"><input type="text" id="endDateInput" placeholder="종료일 선택"></div>';
                } else if (currentFilterType === 'menu') {
                    html = '<div class="date-picker-wrap"><input type="text" id="dateInput" placeholder="날짜 선택"></div>' +
                           '<select id="mainCategorySelect"></select>' +
                           '<select id="menuSelect"></select>';
                }

                container.innerHTML = html;

                if (currentFilterType === 'date') {
                    datePickerInstance = flatpickr("#dateInput", { ...commonDateConfig, defaultDate: selectedDate, onChange: (d, str) => selectedDate = str });
                } else if (currentFilterType === 'period') {
                    startDatePickerInstance = flatpickr("#startDateInput", { ...commonDateConfig, defaultDate: startDate, onChange: (d, str) => startDate = str });
                    endDatePickerInstance = flatpickr("#endDateInput", { ...commonDateConfig, defaultDate: endDate, onChange: (d, str) => endDate = str });
                } else if (currentFilterType === 'menu') {
                    datePickerInstance = flatpickr("#dateInput", { ...commonDateConfig, defaultDate: selectedDate, onChange: (d, str) => selectedDate = str });
                    loadMainCategoriesForMenuFilter();
                }
            }

            function loadMainCategoriesForMenuFilter() {
                const mainCategorySelect = document.getElementById('mainCategorySelect');
                fetch("<%= request.getContextPath() %>/hq/sales/headquarters?action=mainCategories")
                    .then(response => response.json())
                    .then(data => {
                        mainCategorySelect.innerHTML = '<option value="0" disabled selected>카테고리 선택</option>';
                        data.forEach(cat => {
                            mainCategorySelect.innerHTML += '<option value="' + cat.categoryId + '">' + cat.name + '</option>';
                        });
                        mainCategorySelect.onchange = () => loadMenusForCategory(mainCategorySelect.value);
                        loadMenusForCategory(mainCategorySelect.value);
                    });
            }

            function loadMenusForCategory(categoryId) {
                const menuSelect = document.getElementById('menuSelect');
                if (!categoryId || categoryId === "0") {
                    menuSelect.innerHTML = '<option value="all">전체 메뉴</option>';
                    return;
                }
                fetch("<%= request.getContextPath() %>/hq/sales/headquarters?action=menus&categoryId=" + categoryId)
                    .then(response => response.json())
                    .then(data => {
                        menuSelect.innerHTML = '<option value="all">전체 메뉴</option>';
                        data.forEach(menu => {
                            console.log("Populating menu:", menu.menuName, "with code:", menu.recipeCode); // Debugging
                            menuSelect.innerHTML += '<option value="' + menu.recipeCode + '">' + menu.menuName + '</option>';
                        });
                        menuSelect.value = "all"; // Ensure default is selected
                    });
            }

            function updateChartAndTableTitle() {
                const chartTitleEl = document.getElementById("chartTitle");
                const tableTitleEl = document.getElementById("tableTitle");

                if (!searched) {
                    chartTitleEl.textContent = "본사 전체 매출 현황";
                    tableTitleEl.textContent = "상세 매출 내역";
                    return;
                }

                if (currentFilterType === 'date') {
                    chartTitleEl.textContent = selectedDate + ' 기준 본사 매출';
                    tableTitleEl.textContent = "일별 상세 매출";
                } else if (currentFilterType === 'period') {
                    chartTitleEl.textContent = startDate + ' ~ ' + endDate + ' 기간별 본사 매출';
                    tableTitleEl.textContent = "기간별 상세 매출";
                } else if (currentFilterType === 'menu') {
                    const categoryName = document.getElementById('mainCategorySelect').selectedOptions[0].text;
                    const menuName = document.getElementById('menuSelect').selectedOptions[0].text;
                    const menuValue = document.getElementById('menuSelect').value;

                    if (menuValue === 'all') { // 시나리오 1
                        chartTitleEl.textContent = selectedDate + ' | ' + categoryName + ' 내 메뉴별 판매량 랭킹';
                        tableTitleEl.textContent = "메뉴별 상세 매출 및 카테고리 점유율";
                    } else { // 시나리오 2
                        const tempDate = new Date(selectedDate);
                        const weekStartDate = new Date(tempDate.setDate(tempDate.getDate() - 6)).toISOString().split('T')[0];
                        chartTitleEl.textContent = weekStartDate + ' ~ ' + selectedDate + ' | 메뉴 [' + menuName + '] 주간 판매량 랭킹';
                        tableTitleEl.textContent = "지점별 상세 매출 및 전사 기여도";
                    }
                }
            }

            function handleSearch() {
                if (currentFilterType === 'menu') {
                    const categoryId = document.getElementById('mainCategorySelect').value;
                    if (!categoryId || categoryId === "0") {
                        alert("카테고리를 선택해주세요.");
                        return;
                    }
                }

                searched = true;
                currentPage = 1;
                document.getElementById("resetBtn").classList.remove("hidden");
                document.getElementById("searchResultsSection").classList.remove("hidden");
                document.getElementById("todaySummaryCards").classList.add("hidden");
                updateChartAndTableTitle();
                fetchSearchResults();
            }

            function handleReset() {
                searched = false;
                currentPage = 1;
                selectedDate = new Date().toISOString().split('T')[0];
                startDate = new Date(new Date().setDate(new Date().getDate() - 6)).toISOString().split('T')[0];
                endDate = new Date().toISOString().split('T')[0];

                if (salesChart) salesChart.destroy();

                setFilterType('date', true);
                renderTodaySummary();
            }

            function fetchSearchResults() {
                let url = new URL("<%= request.getContextPath() %>/hq/sales/headquarters", window.location.origin);
                url.searchParams.append('action', 'search');
                url.searchParams.append('filterType', currentFilterType);

                if (currentFilterType === 'date') {
                    url.searchParams.append('dateInput', selectedDate);
                } else if (currentFilterType === 'period') {
                    url.searchParams.append('startDateInput', startDate);
                    url.searchParams.append('endDateInput', endDate);
                } else if (currentFilterType === 'menu') {
                    const recipeCode = document.getElementById('menuSelect').value;
                    console.log("Searching with recipeCode:", recipeCode); // Debugging

                    url.searchParams.append('dateInput', selectedDate);
                    url.searchParams.append('categoryId', document.getElementById('mainCategorySelect').value);
                    url.searchParams.append('recipeCode', recipeCode || 'all'); // Defensive check
                }

                fetch(url)
                    .then(response => response.json())
                    .then(data => {
                        currentSearchResults = data;
                        renderChart(data);
                        renderDataTable(data);
                    })
                    .catch(error => console.error("검색 결과 조회 실패:", error));
            }

            function renderChart(data) {
                if (salesChart) salesChart.destroy();
                const ctx = document.getElementById('salesChart').getContext('2d');
                let chartConfig = {};

                if (currentFilterType === 'date' || currentFilterType === 'period') {
                    chartConfig = getDailyPeriodChartConfig(data);
                } else if (currentFilterType === 'menu') {
                    const menuValue = document.getElementById('menuSelect').value;
                    if (menuValue === 'all') { // 시나리오 1
                        chartConfig = getMenuRankChartConfig(data);
                    } else { // 시나리오 2
                        chartConfig = getBranchRankChartConfig(data);
                    }
                }
                salesChart = new Chart(ctx, chartConfig);
            }

            function getDailyPeriodChartConfig(data) {
                const labels = data.map(item => item.saleDate);
                const salesData = data.map(item => item.totalSales);
                const ordersData = data.map(item => item.totalOrders);
                const chartType = (currentFilterType === 'period' && data.length > 15) ? 'line' : 'bar';

                return {
                    type: 'bar',
                    data: {
                        labels,
                        datasets: [
                            { type: chartType, label: '매출액', data: salesData, backgroundColor: 'rgba(0, 133, 61, 0.7)', borderColor: 'rgba(0, 133, 61, 1)', yAxisID: 'y-sales', tension: 0.1 },
                            { type: 'line', label: '주문 건수', data: ordersData, borderColor: 'rgb(255, 99, 132)', backgroundColor: 'rgba(255, 99, 132, 0.2)', fill: true, tension: 0.3, yAxisID: 'y-orders' }
                        ]
                    },
                    options: {
                        responsive: true, maintainAspectRatio: false,
                        plugins: { legend: { position: 'top' }, title: { display: true, text: document.getElementById('chartTitle').textContent } },
                        scales: {
                            'y-sales': { type: 'linear', position: 'left', beginAtZero: true, title: { display: true, text: '매출액 (원)' } },
                            'y-orders': { type: 'linear', position: 'right', beginAtZero: true, grid: { drawOnChartArea: false }, title: { display: true, text: '주문 건수' } }
                        }
                    }
                };
            }

            function getMenuRankChartConfig(data) {
                const labels = data.map(item => item.menuName);
                const salesData = data.map(item => item.totalSales);
                return {
                    type: 'bar',
                    data: { labels, datasets: [{ label: '매출액', data: salesData, backgroundColor: 'rgba(0, 133, 61, 0.7)' }] },
                    options: { indexAxis: 'y', responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false }, title: { display: true, text: document.getElementById('chartTitle').textContent } } }
                };
            }

            function getBranchRankChartConfig(data) {
                const labels = data.map(item => item.branchName);
                const quantityData = data.map(item => item.quantity);
                return {
                    type: 'bar',
                    data: { labels, datasets: [{ label: '판매량', data: quantityData, backgroundColor: 'rgba(54, 162, 235, 0.7)' }] },
                    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false }, title: { display: true, text: document.getElementById('chartTitle').textContent } } }
                };
            }

            function renderDataTable(data) {
                const tableHeader = document.getElementById("tableHeader");
                const tableBody = document.getElementById("tableBody");
                tableHeader.innerHTML = "";
                tableBody.innerHTML = "";

                let headerHtml = '<tr>';
                if (currentFilterType === 'date' || currentFilterType === 'period') {
                    headerHtml += '<th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">날짜</th>' +
                                   '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출액</th>' +
                                   '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">주문수</th>' +
                                   '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">누적 매출</th>';
                } else if (currentFilterType === 'menu') {
                    const menuValue = document.getElementById('menuSelect').value;
                    if (menuValue === 'all') { // 시나리오 1
                        headerHtml += '<th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">순위</th>' +
                                       '<th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">메뉴명</th>' +
                                       '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">판매량</th>' +
                                       '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출액</th>' +
                                       '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">카테고리 내 비중(%)</th>';
                    } else { // 시나리오 2
                        headerHtml += '<th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">순위</th>' +
                                       '<th class="px-4 py-3 text-left text-sm font-semibold text-gray-900">지점명</th>' +
                                       '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">판매량</th>' +
                                       '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출액</th>' +
                                       '<th class="px-4 py-3 text-right text-sm font-semibold text-gray-900">전사 판매 기여도(%)</th>';
                    }
                }
                headerHtml += '</tr>';
                tableHeader.innerHTML = headerHtml;

                const paginatedResults = data.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

                paginatedResults.forEach(item => {
                    let rowHtml = "<tr class='hover:bg-gray-50'>";
                    if (currentFilterType === 'date' || currentFilterType === 'period') {
                        rowHtml += '<td class="px-4 py-3 text-sm text-gray-900">' + item.saleDate + '</td>' +
                                    '<td class="px-4 py-3 text-sm text-right font-semibold text-gray-900">' + formatCurrency(item.totalSales) + '</td>' +
                                    '<td class="px-4 py-3 text-sm text-right text-gray-600">' + (item.totalOrders || 0).toLocaleString() + '건</td>' +
                                    '<td class="px-4 py-3 text-sm text-right text-gray-600">' + formatCurrency(item.cumulativeSales) + '</td>';
                    } else if (currentFilterType === 'menu') {
                        const menuValue = document.getElementById('menuSelect').value;
                        if (menuValue === 'all') { // 시나리오 1
                            rowHtml += '<td class="px-4 py-3 text-sm text-gray-900">' + item.rank + '</td>' +
                                        '<td class="px-4 py-3 text-sm text-gray-900">' + item.menuName + '</td>' +
                                        '<td class="px-4 py-3 text-sm text-right text-gray-600">' + (item.quantity || 0).toLocaleString() + '개</td>' +
                                        '<td class="px-4 py-3 text-sm text-right font-semibold text-gray-900">' + formatCurrency(item.totalSales) + '</td>' +
                                        '<td class="px-4 py-3 text-sm text-right text-gray-900">' + (item.categoryShare || 0).toFixed(2) + '%</td>';
                        } else { // 시나리오 2
                            rowHtml += '<td class="px-4 py-3 text-sm text-gray-900">' + item.rank + '</td>' +
                                        '<td class="px-4 py-3 text-sm text-gray-900">' + item.branchName + '</td>' +
                                        '<td class="px-4 py-3 text-sm text-right text-gray-600">' + (item.quantity || 0).toLocaleString() + '개</td>' +
                                        '<td class="px-4 py-3 text-sm text-right font-semibold text-gray-900">' + formatCurrency(item.totalSales) + '</td>' +
                                        '<td class="px-4 py-3 text-sm text-right text-gray-900">' + (item.companyShare || 0).toFixed(2) + '%</td>';
                        }
                    }
                    rowHtml += "</tr>";
                    tableBody.innerHTML += rowHtml;
                });
                renderPagination(data.length);
            }

            function renderPagination(totalItems) {
                const totalPages = Math.ceil(totalItems / itemsPerPage);
                const paginationContainer = document.getElementById("paginationContainer");
                const paginationInfo = document.getElementById("paginationInfo");
                const pageButtons = document.getElementById("pageButtons");

                if (totalPages <= 1) {
                    paginationContainer.classList.add("hidden");
                    pageButtons.innerHTML = "";
                    paginationInfo.textContent = "";
                    return;
                }

                paginationContainer.classList.remove("hidden");

                const startIndex = (currentPage - 1) * itemsPerPage;
                const endIndex = Math.min(startIndex + itemsPerPage, totalItems);

                paginationInfo.textContent =
                    (startIndex + 1) + '-' + endIndex + ' / ' + totalItems + '개';

                const base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
                const active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
                const arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';

                const blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
                const blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

                let html = '';

                html += '<button class="' + arrow + '" onclick="changePage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
                html += '<i class="fas fa-angles-left text-xs"></i>';
                html += '</button>';

                const prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
                html += '<button class="' + arrow + '" onclick="changePage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
                html += '<i class="fas fa-chevron-left text-xs"></i>';
                html += '</button>';

                for (let i = blockStart; i <= blockEnd; i++) {
                    html += '<button class="' + (i === currentPage ? active : base) + '" onclick="changePage(' + i + ')">';
                    html += i;
                    html += '</button>';
                }

                const nextBlockPage = Math.min(totalPages, blockEnd + 1);
                html += '<button class="' + arrow + '" onclick="changePage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
                html += '<i class="fas fa-chevron-right text-xs"></i>';
                html += '</button>';

                html += '<button class="' + arrow + '" onclick="changePage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
                html += '<i class="fas fa-angles-right text-xs"></i>';
                html += '</button>';

                pageButtons.innerHTML = html;
            }

            window.changePage = function(page) {
                currentPage = page;
                renderDataTable(currentSearchResults);

                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            };

            // Event Listeners
            document.querySelectorAll('.filterBtn').forEach(btn => {
                btn.addEventListener('click', () => setFilterType(btn.dataset.filter));
            });
            document.getElementById('searchButton').addEventListener('click', handleSearch);
            document.getElementById('resetBtn').addEventListener('click', handleReset);

            // Initial Load
            flatpickr.localize(flatpickr.l10ns.ko);
            setFilterType('date', true);
            renderTodaySummary();
        });
    </script>
</body>
</html>
