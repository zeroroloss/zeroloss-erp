<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>매출 순위 - ZERO LOSS 본사 관리 시스템</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    .sidebar-open .sidebar {
        transform: translateX(0);
    }

    .date-picker-wrap {
        position: relative;
        display: inline-block;
    }

    .date-picker-wrap input,
    #mainCategorySelect,
    #menuSelect {
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

    .date-picker-wrap input {
        padding: 0 38px 0 13px !important;
        cursor: pointer;
    }

    .date-picker-wrap input:focus,
    #mainCategorySelect:focus,
    #menuSelect:focus {
        border-color: #00853D;
    }

    .date-icon {
        position: absolute;
        right: 13px;
        top: 50%;
        transform: translateY(-50%);
        color: #9ca3af;
        pointer-events: none;
        font-size: 14px;
        z-index: 10;
    }

    .sort-btn.active {
        border-color: #00853D;
        background: rgba(0, 133, 61, 0.05);
        color: #00853D;
    }

    .rank-tab.active {
        border-color: #00853D;
        background: rgba(0, 133, 61, 0.05);
        color: #00853D;
    }

    .hidden-group {
        display: none !important;
    }

    .rank-list {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .rank-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px;
        border-radius: 10px;
        background: #f9fafb;
        border: 1px solid #f3f4f6;
    }

    .rank-no {
        min-width: 48px;
        white-space: nowrap;
        font-size: 15px;
        font-weight: 800;
        color: #00853D;
        text-align: center;
        flex-shrink: 0;
    }

    .item-main {
        flex: 1;
        min-width: 0;
    }

    .item-name {
        font-size: 15px;
        font-weight: 700;
        color: #111827;
        line-height: 1.3;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .item-value {
        font-size: 15px;
        font-weight: 700;
        white-space: nowrap;
        color: #111827;
        flex-shrink: 0;
    }

    .no-data {
        text-align: center;
        padding: 56px 20px;
        color: #6b7280;
        font-size: 14px;
    }

    /* 커스텀 날짜 선택기 */
    .custom-date-picker {
        position: fixed;
        width: 300px;
        background: #fff;
        border: 1px solid #d1d5db;
        border-radius: 0.75rem;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        z-index: 9999;
        padding: 14px;
    }

    .custom-date-picker.hidden {
        display: none;
    }

    .custom-date-picker-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 12px;
    }

    .custom-date-picker select {
        height: 30px;
        min-width: auto;
        width: auto;
        border-radius: 0.5rem;
        padding: 0 8px;
        font-size: 12px;
        font-weight: 600;
        background: #fff;
    }

    .custom-date-nav-btn {
        width: 30px;
        height: 30px;
        border-radius: 0.5rem;
        border: 1px solid #e5e7eb;
        color: #4b5563;
        background: #fff;
        cursor: pointer;
    }

    .custom-date-nav-btn:hover {
        background: #f3f4f6;
    }

    .custom-date-weekdays,
    .custom-date-days {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 4px;
    }

    .custom-date-weekdays div {
        text-align: center;
        font-size: 11px;
        font-weight: 700;
        color: #6b7280;
        padding: 4px 0;
    }

    .custom-date-day {
        height: 32px;
        border-radius: 0.5rem;
        border: none;
        background: #fff;
        font-size: 12px;
        cursor: pointer;
        color: #111827;
    }

    .custom-date-day:hover {
        background: #ecfdf3;
        color: #00853D;
        font-weight: 700;
    }

    .custom-date-day.other-month {
        color: #c4c4c4;
    }

    .custom-date-day.today {
        border: 1px solid #00853D;
        color: #00853D;
        font-weight: 700;
    }

    .custom-date-day.selected {
        background: #00853D;
        color: #fff;
        font-weight: 700;
    }
</style>
</head>
<body class="bg-gray-50">

<%@ include file="/hq/common/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">

            <!-- 페이지 헤더 -->
            <div>
                <h2 class="text-3xl font-bold text-gray-900">전사 매출 랭킹</h2>
                <p class="text-gray-500 mt-1">전국 직영점의 실적과 메뉴 트렌드를 분석합니다.</p>
            </div>

            <!-- 검색 영역 -->
            <div class="bg-white rounded-lg border border-gray-200 p-4">
                <div class="flex flex-wrap items-center gap-3">

                    <!-- 조회 기간 -->
                    <div class="flex items-center gap-2 flex-wrap">
                        <span class="text-sm font-semibold text-gray-700">조회기간</span>

                        <div class="date-picker-wrap">
                            <input type="text"
                                   id="period-start"
                                   readonly
                                   onclick="openCustomDatePicker('period-start', event)"
                                   placeholder="시작일">
                            <i class="fas fa-calendar-check date-icon"></i>
                        </div>

                        <span class="text-gray-500 flex items-center">~</span>

                        <div class="date-picker-wrap">
                            <input type="text"
                                   id="period-end"
                                   readonly
                                   onclick="openCustomDatePicker('period-end', event)"
                                   placeholder="종료일">
                            <i class="fas fa-calendar-check date-icon"></i>
                        </div>
                    </div>

                    <!-- 특정 메뉴 필터 -->
                    <div class="flex items-center gap-2 flex-wrap hidden-group" id="specific-menu-filter">
                        <span class="text-sm font-semibold text-gray-700">타겟 메뉴</span>

                        <select id="mainCategorySelect">
                            <option value="">카테고리 로딩...</option>
                        </select>

                        <select id="menuSelect">
                            <option value="">메뉴 로딩...</option>
                        </select>
                    </div>

                    <!-- 정렬 기준 -->
                    <div class="flex items-center gap-2 ml-auto flex-wrap">
                        <span class="text-sm font-semibold text-gray-700">정렬기준</span>

                        <button type="button"
                                class="px-3 py-2 rounded-lg border text-sm font-medium transition-all sort-btn active"
                                data-sort="sales">
                            매출액 순
                        </button>

                        <button type="button"
                                class="px-3 py-2 rounded-lg border text-sm font-medium transition-all sort-btn"
                                data-sort="quantity">
                            주문/판매량 순
                        </button>
                    </div>
                </div>
            </div>

            <!-- 랭킹 탭 -->
            <div class="bg-white rounded-lg border border-gray-200 p-4">
                <div class="flex flex-wrap gap-2" aria-label="랭킹 종류">
                    <button type="button"
                            class="px-3 py-2 rounded-lg border text-sm font-medium transition-all rank-tab active"
                            data-rank-type="branch">
                        지점 종합 랭킹
                    </button>

                    <button type="button"
                            class="px-3 py-2 rounded-lg border text-sm font-medium transition-all rank-tab"
                            data-rank-type="menu">
                        전사 메뉴별 랭킹
                    </button>

                    <button type="button"
                            class="px-3 py-2 rounded-lg border text-sm font-medium transition-all rank-tab"
                            data-rank-type="specific_menu">
                        특정 메뉴 집중 분석
                    </button>

                    <button type="button"
                            class="px-3 py-2 rounded-lg border text-sm font-medium transition-all rank-tab"
                            data-rank-type="trend">
                        전사 트렌드
                    </button>
                </div>
            </div>

            <!-- 랭킹 영역 -->
            <section class="grid grid-cols-1 lg:grid-cols-2 gap-6" id="ranking-grid">

                <article class="bg-white rounded-lg border border-gray-200 p-6">
                    <div class="flex items-center gap-2 mb-4">
                        <div class="w-1 h-5 bg-[#00853D] rounded-full"></div>
                        <h3 class="text-lg font-semibold text-gray-900" id="best-title"></h3>
                        <span class="ml-auto px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-[#00853D]">
                            TOP 10
                        </span>
                    </div>

                    <div class="rank-list" id="best-list">
                        <div class="no-data">조회된 데이터가 없습니다.</div>
                    </div>
                </article>

                <article class="bg-white rounded-lg border border-gray-200 p-6">
                    <div class="flex items-center gap-2 mb-4">
                        <div class="w-1 h-5 bg-orange-500 rounded-full"></div>
                        <h3 class="text-lg font-semibold text-gray-900" id="worst-title"></h3>
                        <span class="ml-auto px-3 py-1 rounded-full text-xs font-bold bg-orange-100 text-orange-600">
                            WORST 10
                        </span>
                    </div>

                    <div class="rank-list" id="worst-list">
                        <div class="no-data">조회된 데이터가 없습니다.</div>
                    </div>
                </article>

            </section>

            <!-- 전사 트렌드 영역 -->
            <section class="hidden-group" id="trend-data-section">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

                    <article class="bg-white rounded-lg border border-gray-200 p-6">
                        <div class="flex items-center gap-2 mb-4">
                            <div class="w-1 h-5 bg-[#00853D] rounded-full"></div>
                            <h3 class="text-lg font-semibold text-gray-900">시간대별 매출/판매량 트렌드</h3>
                            <span class="ml-auto px-3 py-1 rounded-full text-xs font-bold bg-green-100 text-[#00853D]">
                                24시간
                            </span>
                        </div>

                        <div class="rank-list" id="hourly-trend-list">
                            <div class="no-data">데이터를 분석 중입니다...</div>
                        </div>
                    </article>

                    <article class="bg-white rounded-lg border border-gray-200 p-6">
                        <div class="flex items-center gap-2 mb-4">
                            <div class="w-1 h-5 bg-orange-500 rounded-full"></div>
                            <h3 class="text-lg font-semibold text-gray-900">요일별 매출/판매량 트렌드</h3>
                            <span class="ml-auto px-3 py-1 rounded-full text-xs font-bold bg-orange-100 text-orange-600">
                                주 7일
                            </span>
                        </div>

                        <div class="rank-list" id="daily-trend-list">
                            <div class="no-data">데이터를 분석 중입니다...</div>
                        </div>
                    </article>

                </div>
            </section>

        </div>
    </main>
</div>

<!-- 커스텀 달력 -->
<div id="customDatePicker" class="custom-date-picker hidden" onclick="event.stopPropagation()">
    <div class="custom-date-picker-header">
        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(-1)">
            <i class="fas fa-chevron-left text-xs"></i>
        </button>

        <div class="flex items-center gap-2">
            <select id="customDatePickerYear"
                    onchange="changeCustomPickerYearMonth()"
                    class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
            </select>

            <select id="customDatePickerMonth"
                    onchange="changeCustomPickerYearMonth()"
                    class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
            </select>
        </div>

        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(1)">
            <i class="fas fa-chevron-right text-xs"></i>
        </button>
    </div>

    <div class="custom-date-weekdays">
        <div>일</div>
        <div>월</div>
        <div>화</div>
        <div>수</div>
        <div>목</div>
        <div>금</div>
        <div>토</div>
    </div>

    <div id="customDatePickerDays" class="custom-date-days"></div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
    	
    	// 커스텀 달력
		let customDateTargetId = null;
		let customPickerDate = new Date();
		
		function formatDateLocal(date) {
		    return date.getFullYear() + '-' +
		        String(date.getMonth() + 1).padStart(2, '0') + '-' +
		        String(date.getDate()).padStart(2, '0');
		}
		
		function parseDateLocal(dateStr) {
		    if (!dateStr) return null;
		
		    const parts = String(dateStr).split('-');
		
		    if (parts.length !== 3) {
		        return null;
		    }
		
		    return new Date(
		        Number(parts[0]),
		        Number(parts[1]) - 1,
		        Number(parts[2])
		    );
		}
		
		function setDefaultDateValues() {
		    const today = formatDateLocal(new Date());
		
		    const thirtyDaysAgo = new Date();
		    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
		
		    document.getElementById('period-start').value = formatDateLocal(thirtyDaysAgo);
		    document.getElementById('period-end').value = today;
		}
		
		window.openCustomDatePicker = function(inputId, event) {
		    if (event) {
		        event.stopPropagation();
		    }
		
		    customDateTargetId = inputId;
		
		    const input = document.getElementById(inputId);
		    const selectedDateObj = parseDateLocal(input.value);
		
		    customPickerDate = selectedDateObj || new Date();
		
		    renderCustomDatePicker();
		    positionCustomDatePicker(input);
		
		    document.getElementById('customDatePicker').classList.remove('hidden');
		};
		
		function positionCustomDatePicker(input) {
		    const picker = document.getElementById('customDatePicker');
		    const rect = input.getBoundingClientRect();
		
		    const pickerWidth = 300;
		    const pickerHeight = 330;
		
		    let top = rect.bottom + 6;
		    let left = rect.left;
		
		    picker.style.width = pickerWidth + 'px';
		
		    if (left + pickerWidth > window.innerWidth) {
		        left = window.innerWidth - pickerWidth - 12;
		    }
		
		    if (top + pickerHeight > window.innerHeight) {
		        top = rect.top - pickerHeight - 6;
		    }
		
		    picker.style.top = top + 'px';
		    picker.style.left = left + 'px';
		}
		
		window.changeCustomPickerMonth = function(amount) {
		    customPickerDate.setMonth(customPickerDate.getMonth() + amount);
		    renderCustomDatePicker();
		};
		
		window.changeCustomPickerYearMonth = function() {
		    const yearSelect = document.getElementById('customDatePickerYear');
		    const monthSelect = document.getElementById('customDatePickerMonth');
		
		    const selectedYear = Number(yearSelect.value);
		    const selectedMonth = Number(monthSelect.value);
		
		    customPickerDate = new Date(selectedYear, selectedMonth, 1);
		
		    renderCustomDatePicker();
		};
		
		function renderCustomPickerYearMonthSelect(year, month) {
		    const yearSelect = document.getElementById('customDatePickerYear');
		    const monthSelect = document.getElementById('customDatePickerMonth');
		
		    let yearHtml = '';
		    const startYear = year - 10;
		    const endYear = year + 10;
		
		    for (let y = startYear; y <= endYear; y++) {
		        yearHtml += '<option value="' + y + '"';
		
		        if (y === year) {
		            yearHtml += ' selected';
		        }
		
		        yearHtml += '>' + y + '년</option>';
		    }
		
		    let monthHtml = '';
		
		    for (let m = 0; m < 12; m++) {
		        monthHtml += '<option value="' + m + '"';
		
		        if (m === month) {
		            monthHtml += ' selected';
		        }
		
		        monthHtml += '>' + (m + 1) + '월</option>';
		    }
		
		    yearSelect.innerHTML = yearHtml;
		    monthSelect.innerHTML = monthHtml;
		}
		
		function renderCustomDatePicker() {
		    const year = customPickerDate.getFullYear();
		    const month = customPickerDate.getMonth();
		
		    renderCustomPickerYearMonthSelect(year, month);
		
		    const firstDay = new Date(year, month, 1);
		    const lastDay = new Date(year, month + 1, 0);
		    const prevLastDay = new Date(year, month, 0);
		
		    const startDay = firstDay.getDay();
		    const days = [];
		
		    for (let i = startDay - 1; i >= 0; i--) {
		        days.push({
		            date: new Date(year, month - 1, prevLastDay.getDate() - i),
		            currentMonth: false
		        });
		    }
		
		    for (let d = 1; d <= lastDay.getDate(); d++) {
		        days.push({
		            date: new Date(year, month, d),
		            currentMonth: true
		        });
		    }
		
		    let nextDay = 1;
		
		    while (days.length < 42) {
		        days.push({
		            date: new Date(year, month + 1, nextDay),
		            currentMonth: false
		        });
		        nextDay++;
		    }
		
		    const targetInput = customDateTargetId ? document.getElementById(customDateTargetId) : null;
		    const selectedValue = targetInput ? targetInput.value : '';
		    const todayValue = formatDateLocal(new Date());
		
		    let html = '';
		
		    for (let j = 0; j < days.length; j++) {
		        const dateValue = formatDateLocal(days[j].date);
		
		        let className = 'custom-date-day';
		
		        if (!days[j].currentMonth) {
		            className += ' other-month';
		        }
		
		        if (dateValue === todayValue) {
		            className += ' today';
		        }
		
		        if (dateValue === selectedValue) {
		            className += ' selected';
		        }
		
		        html += '<button type="button" class="' + className + '" onclick="selectCustomDate(\'' + dateValue + '\')">';
		        html += days[j].date.getDate();
		        html += '</button>';
		    }
		
		    document.getElementById('customDatePickerDays').innerHTML = html;
		}
		
		window.selectCustomDate = function(dateValue) {
		    if (!customDateTargetId) {
		        return;
		    }
		
		    document.getElementById(customDateTargetId).value = dateValue;
		
		    closeCustomDatePicker();
		    fetchData();
		};
		
		function closeCustomDatePicker() {
		    const picker = document.getElementById('customDatePicker');
		
		    if (picker) {
		        picker.classList.add('hidden');
		    }
		
		    customDateTargetId = null;
		}
		
		document.addEventListener('mousedown', function(event) {
		    const picker = document.getElementById('customDatePicker');
		
		    if (!picker || picker.classList.contains('hidden')) {
		        return;
		    }
		
		    if (picker.contains(event.target)) {
		        return;
		    }
		
		    if (
		        customDateTargetId &&
		        document.getElementById(customDateTargetId) &&
		        document.getElementById(customDateTargetId).contains(event.target)
		    ) {
		        return;
		    }
		
		    closeCustomDatePicker();
		});

        const sortButtons = document.querySelectorAll('.sort-btn[data-sort]');
        const rankTabs = document.querySelectorAll('.rank-tab');
        const specificMenuFilter = document.getElementById('specific-menu-filter');
        const mainCategorySelect = document.getElementById('mainCategorySelect');
        const menuSelect = document.getElementById('menuSelect');

        const rankingGrid = document.getElementById('ranking-grid');
        const trendDataSection = document.getElementById('trend-data-section');

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
                const selectedMenuText = menuSelect.options.length > 0 ? menuSelect.options[menuSelect.selectedIndex].text : '메뉴';
                prefix = '[' + selectedMenuText + '] 판매 지점';
            } else if (currentRankType === 'trend') {
                bestTitle.textContent = '시간대별 ' + sortText + ' 트렌드';
                worstTitle.textContent = '요일별 ' + sortText + ' 트렌드';
                return;
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

                return '<div class="rank-item">' +
                    '<div class="rank-no">' + rank + '위</div>' +
                    '<div class="item-main">' +
                    '<div class="item-name">' + itemName + '</div>' +
                    '</div>' +
                    '<div class="item-value">' + formatValue(item) + '</div>' +
                    '</div>';
            }).join('');
            container.innerHTML = itemsHtml;
        }

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

            const getMetricValue = (item) => Number((currentSort === 'sales' ? item.totalSales : item.totalQuantity) || 0);
            const sortByMetricDesc = (list) => (list || []).slice().sort((a, b) => getMetricValue(b) - getMetricValue(a));

            const sortedHourlyData = sortByMetricDesc(hourlyData);
            const sortedDailyData = sortByMetricDesc(dailyData);

            if (sortedHourlyData.length > 0) {
                sortedHourlyData.forEach((item, index) => {
                    const div = document.createElement('div');
                    div.className = 'rank-item';
                    div.innerHTML =
                        '<div class="rank-no">' + (index + 1) + '위</div>' +
                        '<div class="item-main">' +
                        '<div class="item-name">' + item.hour + '시</div>' +
                        '</div>' +
                        '<div class="item-value">' + formatValue(item) + '</div>';
                    hourlyTrendList.appendChild(div);
                });
            } else {
                hourlyTrendList.innerHTML = '<div class="no-data">조회된 시간별 데이터가 없습니다.</div>';
            }

            if (sortedDailyData.length > 0) {
                sortedDailyData.forEach((item, index) => {
                    const div = document.createElement('div');
                    div.className = 'rank-item';
                    div.innerHTML =
                        '<div class="rank-no">' + (index + 1) + '위</div>' +
                        '<div class="item-main">' +
                        '<div class="item-name">' + item.dayName + '</div>' +
                        '</div>' +
                        '<div class="item-value">' + formatValue(item) + '</div>';
                    dailyTrendList.appendChild(div);
                });
            } else {
                dailyTrendList.innerHTML = '<div class="no-data">조회된 요일별 데이터가 없습니다.</div>';
            }
        }

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

        function loadMenus() {
            const categoryCode = mainCategorySelect.value;
            if (!categoryCode) return;

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
                    fetchData();
                })
                .catch(error => {
                    console.error('Error fetching menus:', error);
                    menuSelect.innerHTML = '<option value="">로드 실패</option>';
                });
        }

        function fetchTrendData() {
            updateTitles();
            const startDate = document.getElementById('period-start').value;
            const endDate = document.getElementById('period-end').value;

            // 🟢 수정완료: 문자열 덧셈으로 변경
            const url = contextPath + '/hq/sales/ranking?action=getTrendData&startDate=' + startDate + '&endDate=' + endDate;

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

        function fetchData() {
            rankingGrid.classList.add('hidden-group');
            trendDataSection.classList.add('hidden-group');
            specificMenuFilter.classList.add('hidden-group');

            if (currentRankType === 'trend') {
                trendDataSection.classList.remove('hidden-group');
                fetchTrendData();
            } else {
                rankingGrid.classList.remove('hidden-group');
                if (currentRankType === 'specific_menu') {
                    specificMenuFilter.classList.remove('hidden-group');
                }

                updateTitles();
                bestList.innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';
                worstList.innerHTML = '<div class="no-data">데이터를 분석 중입니다...</div>';

                const startDate = document.getElementById('period-start').value;
                const endDate = document.getElementById('period-end').value;
                const recipeCode = menuSelect.value || '';

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

                // 🟢 수정완료: 문자열 덧셈으로 변경
                const url = contextPath + '/hq/sales/ranking?action=getRanking&rankType=' + currentRankType + '&sortType=' + currentSort + '&startDate=' + startDate + '&endDate=' + endDate + '&recipeCode=' + recipeCode;

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

                if (currentRankType === 'specific_menu') {
                    specificMenuFilter.classList.remove('hidden-group');
                    rankingGrid.classList.remove('hidden-group');
                    trendDataSection.classList.add('hidden-group');
                } else if (currentRankType === 'trend') {
                    specificMenuFilter.classList.add('hidden-group');
                    rankingGrid.classList.add('hidden-group');
                    trendDataSection.classList.remove('hidden-group');
                } else {
                    specificMenuFilter.classList.add('hidden-group');
                    rankingGrid.classList.remove('hidden-group');
                    trendDataSection.classList.add('hidden-group');
                }
                fetchData();
            });
        });

        mainCategorySelect.addEventListener('change', loadMenus);
        menuSelect.addEventListener('change', fetchData);

        setDefaultDateValues();
        loadCategories();
    });
</script>
</body>
</html>
