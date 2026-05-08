<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>직영점 매출 조회 - ZERO LOSS</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.4.0/dist/chartjs-plugin-annotation.min.js"></script>

<%-- 직영점 layout_head.jsp 내용 하드코딩 시작 --%>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<%-- Chart.js --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.4.0/dist/chartjs-plugin-annotation.min.js"></script>
<script>
        window.__ZEROLOSS_CP = '<%=request.getContextPath()%>';
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
.head h1 {
	font-size: 1.875rem;
	line-height: 2.25rem;
	font-weight: 700;
}

.head p {
	color: #6b7280;
}

.search-panel {
	margin-top: 24px;
	border: 1px solid var(- -line);
	border-radius: 18px;
	background: #fff;
	box-shadow: 0 1px 2px rgba(15, 23, 42, 0.05);
	padding: 18px;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.filters {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: 12px;
}

.tabs {
	display: flex;
	align-items: center;
	gap: 10px;
}

.tabs::after {
	content: "";
	width: 1px;
	height: 42px;
	background: #d1d5db;
	margin-left: 4px;
}

.tab {
	height: 38px;
	border-radius: 12px;
	border: 1px solid #d1d5db;
	background: #f9fafb;
	color: #374151;
	font-size: 14px;
	font-weight: 700;
	padding: 0 16px;
	cursor: pointer;
}

.filter-inputs {
	display: flex;
	align-items: center;
	gap: 10px;
}

.filter-inputs input, .filter-inputs select {
	height: 38px;
	min-width: 180px;
	border-radius: 12px;
	border: 1px solid #d1d5db;
	background: #fff;
	color: #1f2937;
	padding: 0 13px;
	font-size: 13px;
}

.btn-group {
	display: flex;
	gap: 8px;
}

.btn {
	height: 38px;
	border-radius: 12px;
	padding: 0 18px;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	border: 1px solid transparent;
}

.btn-search {
	background: var(- -green);
	color: #fff;
	border-color: var(- -green);
}

.btn-reset {
	background: #f3f4f6;
	color: #374151;
	border-color: #e5e7eb;
}

.chart-wrap {
	border: 1px solid #d9dee5;
	border-radius: 16px;
	padding: 20px;
	background: #fff;
	height: 450px;
}

.period-summary {
	margin-bottom: 16px;
	text-align: center;
	font-size: 1.1rem;
	font-weight: 500;
	color: #374151;
}

.chart-title {
	font-size: 22px;
	font-weight: 700;
	margin-bottom: 14px;
}

.result-card {
	margin-top: 18px;
	border: 1px solid #d9dee5;
	border-radius: 16px;
	overflow: hidden;
	background: #fff;
}

.result-head {
	padding: 18px 20px;
	font-size: 20px;
	font-weight: 700;
	border-bottom: 1px solid #e5e7eb;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th, td {
	padding: 14px 18px;
	border-bottom: 1px solid #e5e7eb;
	font-size: 15px;
	text-align: right;
}

th {
	background: #f9fafb;
	color: #6b7280;
	font-weight: 700;
}

th:first-child, td:first-child {
	text-align: left;
}

th:nth-child(2), td:nth-child(2) {
	text-align: left;
}

.pager {
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 16px 20px;
	font-size: 14px;
	color: #6b7280;
}

.pages {
	display: flex;
	gap: 8px;
	align-items: center;
}

.p {
	width: 34px;
	height: 34px;
	border: 1px solid #d1d5db;
	border-radius: 12px;
	background: #fff;
	color: #374151;
	display: grid;
	place-items: center;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
}

.p.active {
	background: var(- -green);
	color: #fff;
	border-color: var(- -green);
}

.sidebar-open .sidebar {
	transform: translateX(0);
}

.tab.active {
	border-color: #00853D;
	background: rgba(0, 133, 61, 0.05);
	color: #00853D;
}

.tab-content {
	display: none;
}

.tab-content.active {
	display: block;
}

.is-hidden {
	display: none !important;
}

.weekend-row {
	color: #2563eb;
	font-weight: 500;
}

tbody tr:hover {
	background-color: #f9fafb;
}

/* 커스텀 달력 */
.date-picker-wrap {
	position: relative;
	display: inline-block;
}

.date-picker-wrap input, #branch-selector {
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

.date-picker-wrap input, #branch-selector {
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

.date-picker-wrap input:focus, #branch-selector:focus {
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

.custom-date-weekdays, .custom-date-days {
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
	<%@ include file="/hq/common/sidebar.jsp"%>

	<div class="lg:pl-72">
		<main class="p-6">
			<div class="space-y-6">

				<!-- 페이지 헤더 -->
				<div>
					<h2 class="text-3xl font-bold text-gray-900">직영점 매출 조회</h2>
					<p class="text-gray-500 mt-1">일별, 기간별, 시간대별, 메뉴별 매출 데이터를 조회하고
						분석합니다.</p>
				</div>

				<!-- 검색 영역 -->
				<div class="bg-white rounded-lg border border-gray-200 p-4">
					<div class="flex flex-wrap items-center gap-3">

						<!-- 필터 타입 버튼 -->
						<div class="flex gap-2 tabs" role="tablist">
							<button
								class="px-3 py-2 rounded-lg border text-sm font-medium transition-all tab active"
								type="button" data-tab="daily">일별</button>
							<button
								class="px-3 py-2 rounded-lg border text-sm font-medium transition-all tab"
								type="button" data-tab="period">기간별</button>
							<button
								class="px-3 py-2 rounded-lg border text-sm font-medium transition-all tab"
								type="button" data-tab="hourly">시간대별</button>
							<button
								class="px-3 py-2 rounded-lg border text-sm font-medium transition-all tab"
								type="button" data-tab="menu">메뉴별</button>
						</div>

						<!-- Divider -->
						<div class="h-8 w-px bg-gray-300 hidden sm:block"></div>

						<!-- 지점 선택 -->
						<div class="flex gap-2 flex-wrap">
							<select id="branch-selector"
								class="h-[38px] min-w-[180px] rounded-xl border border-gray-300 bg-white px-3 text-sm text-gray-800 outline-none focus:border-[#00853D]">
								<option value="" disabled selected>직영점을 선택하세요</option>
							</select>
						</div>

						<!-- 날짜 입력 -->
						<div class="flex gap-2 flex-wrap filter-inputs" data-input="daily">
							<div class="date-picker-wrap">
								<input type="text" id="daily-date" readonly
									onclick="openCustomDatePicker('daily-date', event)"
									placeholder="날짜 선택"> <i
									class="fas fa-calendar-check date-icon"></i>
							</div>
						</div>

						<div class="flex gap-2 flex-wrap filter-inputs is-hidden"
							data-input="period">
							<div class="date-picker-wrap">
								<input type="text" id="period-start" readonly
									onclick="openCustomDatePicker('period-start', event)"
									placeholder="시작일 선택"> <i
									class="fas fa-calendar-check date-icon"></i>
							</div>

							<span class="text-gray-500 flex items-center">~</span>

							<div class="date-picker-wrap">
								<input type="text" id="period-end" readonly
									onclick="openCustomDatePicker('period-end', event)"
									placeholder="종료일 선택"> <i
									class="fas fa-calendar-check date-icon"></i>
							</div>
						</div>

						<div class="flex gap-2 flex-wrap filter-inputs is-hidden"
							data-input="hourly">
							<div class="date-picker-wrap">
								<input type="text" id="hourly-date" readonly
									onclick="openCustomDatePicker('hourly-date', event)"
									placeholder="날짜 선택"> <i
									class="fas fa-calendar-check date-icon"></i>
							</div>
						</div>

						<div class="flex gap-2 flex-wrap filter-inputs is-hidden"
							data-input="menu">
							<div class="date-picker-wrap">
								<input type="text" id="menu-date" readonly
									onclick="openCustomDatePicker('menu-date', event)"
									placeholder="날짜 선택"> <i
									class="fas fa-calendar-check date-icon"></i>
							</div>
						</div>

						<!-- 액션 버튼 -->
						<div class="flex gap-2 ml-auto">
							<button id="searchButton" type="button"
								class="flex items-center gap-2 px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors font-medium text-sm">
								<i class="fas fa-search"></i> 검색
							</button>
							<button id="resetBtn" type="button"
								class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors font-medium text-sm hidden">
								초기화</button>
						</div>
					</div>
				</div>

				<!-- 검색 전 안내 카드 -->
				<div id="emptyGuideCards"
					class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
					<div class="bg-white rounded-lg border border-gray-200 p-5">
						<div class="flex items-center gap-3 mb-2">
							<div
								class="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center">
								<i class="fas fa-store w-5 h-5 text-blue-600"></i>
							</div>
							<p class="text-sm text-gray-500">조회 대상</p>
						</div>
						<p class="text-2xl font-bold text-gray-900">직영점</p>
					</div>

					<div class="bg-white rounded-lg border border-gray-200 p-5">
						<div class="flex items-center gap-3 mb-2">
							<div
								class="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
								<i class="fas fa-chart-line w-5 h-5 text-green-600"></i>
							</div>
							<p class="text-sm text-gray-500">조회 항목</p>
						</div>
						<p class="text-2xl font-bold text-gray-900">매출</p>
					</div>

					<div class="bg-white rounded-lg border border-gray-200 p-5">
						<div class="flex items-center gap-3 mb-2">
							<div
								class="w-10 h-10 rounded-lg bg-purple-100 flex items-center justify-center">
								<i class="fas fa-clock w-5 h-5 text-purple-600"></i>
							</div>
							<p class="text-sm text-gray-500">분석 유형</p>
						</div>
						<p class="text-2xl font-bold text-gray-900">시간대</p>
					</div>

					<div class="bg-white rounded-lg border border-gray-200 p-5">
						<div class="flex items-center gap-3 mb-2">
							<div
								class="w-10 h-10 rounded-lg bg-orange-100 flex items-center justify-center">
								<i class="fas fa-utensils w-5 h-5 text-orange-600"></i>
							</div>
							<p class="text-sm text-gray-500">메뉴 분석</p>
						</div>
						<p class="text-2xl font-bold text-gray-900">가능</p>
					</div>
				</div>

				<!-- 검색 결과 영역 -->
				<div id="searchResultsSection" class="space-y-6 hidden">

					<!-- 일별 -->
					<div id="daily-content" class="tab-content">
						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">일별 매출
								현황</h3>
							<div
								class="w-full h-96 flex items-center justify-center rounded-lg bg-gray-50 border border-gray-200">
								<canvas id="daily-chart"></canvas>
							</div>
						</div>

						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">일별 매출
								상세</h3>
							<div class="overflow-x-auto">
								<table class="w-full">
									<thead class="bg-gray-50 border-b border-gray-200">
										<tr>
											<th
												class="px-4 py-3 text-left text-sm font-semibold text-gray-900">일자</th>
											<th
												class="px-4 py-3 text-left text-sm font-semibold text-gray-900">요일</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출액</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">주문
												건수</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">누적
												매출</th>
										</tr>
									</thead>
									<tbody id="daily-table" class="divide-y divide-gray-200"></tbody>
								</table>
							</div>
							<div id="daily-pagination"
								class="px-6 py-4 border-t border-gray-200 flex flex-col items-center justify-center gap-3 hidden">
								<div id="daily-pagination-info" class="text-sm text-gray-600"></div>
								<div class="flex items-center justify-center gap-2">
									<div id="daily-page-buttons" class="flex items-center gap-1"></div>
								</div>
							</div>
						</div>
					</div>

					<!-- 기간별 -->
					<div id="period-content" class="tab-content">
						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">기간별 매출
								현황</h3>
							<div id="period-summary"
								class="mb-4 text-center text-base font-medium text-gray-700"></div>
							<div
								class="w-full h-96 flex items-center justify-center rounded-lg bg-gray-50 border border-gray-200">
								<canvas id="period-chart"></canvas>
							</div>
						</div>

						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">기간별 매출
								상세</h3>
							<div class="overflow-x-auto">
								<table class="w-full">
									<thead class="bg-gray-50 border-b border-gray-200">
										<tr>
											<th
												class="px-4 py-3 text-left text-sm font-semibold text-gray-900">일자</th>
											<th
												class="px-4 py-3 text-left text-sm font-semibold text-gray-900">요일</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출액</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">주문
												건수</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">누적
												매출</th>
										</tr>
									</thead>
									<tbody id="period-table" class="divide-y divide-gray-200"></tbody>
								</table>
							</div>
							<div id="period-pagination"
								class="px-6 py-4 border-t border-gray-200 flex flex-col items-center justify-center gap-3 hidden">
								<div id="period-pagination-info" class="text-sm text-gray-600"></div>
								<div class="flex items-center justify-center gap-2">
									<div id="period-page-buttons" class="flex items-center gap-1"></div>
								</div>
							</div>
						</div>
					</div>

					<!-- 시간대별 -->
					<div id="hourly-content" class="tab-content">
						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">시간대별 매출
								현황</h3>
							<div
								class="w-full h-96 flex items-center justify-center rounded-lg bg-gray-50 border border-gray-200">
								<canvas id="hourly-chart"></canvas>
							</div>
						</div>

						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">시간대별 매출
								상세</h3>
							<div class="overflow-x-auto">
								<table class="w-full">
									<thead class="bg-gray-50 border-b border-gray-200">
										<tr>
											<th
												class="px-4 py-3 text-left text-sm font-semibold text-gray-900">시간대</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출액</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">주문수</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">평균
												객단가</th>
										</tr>
									</thead>
									<tbody id="hourly-table" class="divide-y divide-gray-200"></tbody>
								</table>
							</div>
							<div id="hourly-pagination"
								class="px-6 py-4 border-t border-gray-200 flex flex-col items-center justify-center gap-3 hidden">
								<div id="hourly-pagination-info" class="text-sm text-gray-600"></div>
								<div class="flex items-center justify-center gap-2">
									<div id="hourly-page-buttons" class="flex items-center gap-1"></div>
								</div>
							</div>
						</div>
					</div>

					<!-- 메뉴별 -->
					<div id="menu-content" class="tab-content">
						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">메뉴별 매출
								현황</h3>
							<div
								class="w-full h-96 flex items-center justify-center rounded-lg bg-gray-50 border border-gray-200">
								<canvas id="menu-chart"></canvas>
							</div>
						</div>

						<div class="bg-white rounded-lg border border-gray-200 p-6">
							<h3 class="text-lg font-semibold text-gray-900 mb-4">메뉴별 매출
								상세</h3>
							<div class="overflow-x-auto">
								<table class="w-full">
									<thead class="bg-gray-50 border-b border-gray-200">
										<tr>
											<th
												class="px-4 py-3 text-left text-sm font-semibold text-gray-900">메뉴명</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">판매량</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출액</th>
											<th
												class="px-4 py-3 text-right text-sm font-semibold text-gray-900">매출
												비중</th>
										</tr>
									</thead>
									<tbody id="menu-table" class="divide-y divide-gray-200"></tbody>
								</table>
							</div>
							<div id="menu-pagination"
								class="px-6 py-4 border-t border-gray-200 flex flex-col items-center justify-center gap-3 hidden">
								<div id="menu-pagination-info" class="text-sm text-gray-600"></div>
								<div class="flex items-center justify-center gap-2">
									<div id="menu-page-buttons" class="flex items-center gap-1"></div>
								</div>
							</div>
						</div>
					</div>

				</div>
			</div>
		</main>
	</div>

	<!-- 커스텀 달력 -->
	<div id="customDatePicker" class="custom-date-picker hidden"
		onclick="event.stopPropagation()">
		<div class="custom-date-picker-header">
			<button type="button" class="custom-date-nav-btn"
				onclick="changeCustomPickerMonth(-1)">
				<i class="fas fa-chevron-left text-xs"></i>
			</button>

			<div class="flex items-center gap-2">
				<select id="customDatePickerYear"
					onchange="changeCustomPickerYearMonth()"
					class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
				</select> <select id="customDatePickerMonth"
					onchange="changeCustomPickerYearMonth()"
					class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
				</select>
			</div>

			<button type="button" class="custom-date-nav-btn"
				onclick="changeCustomPickerMonth(1)">
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
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');
        const inputGroups = document.querySelectorAll('.filter-inputs[data-input]');
        const searchButton = document.getElementById('searchButton');
        const branchSelector = document.getElementById('branch-selector');

        // 커스텀 달력
        let customDateTargetId = null;
        let customPickerDate = new Date();
        let currentPageMap = {
        	    daily: 1,
        	    period: 1,
        	    hourly: 1,
        	    menu: 1
        	};

        	let currentDataMap = {
        	    daily: [],
        	    period: [],
        	    hourly: [],
        	    menu: []
        	};

       	const itemsPerPage = 10;
        const PAGE_SIZE = 5;

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

            const oneMonthAgo = new Date();
            oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);

            document.getElementById('daily-date').value = today;
            document.getElementById('hourly-date').value = today;
            document.getElementById('menu-date').value = today;
            document.getElementById('period-start').value = formatDateLocal(oneMonthAgo);
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

        setDefaultDateValues();
        
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
                commonShowAlert('알림', '직영점을 먼저 선택해주세요.');
                return;
            }
            
            document.getElementById('emptyGuideCards').classList.add('hidden');
            document.getElementById('searchResultsSection').classList.remove('hidden');
            document.getElementById('resetBtn').classList.remove('hidden');

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
        
        const resetBtn = document.getElementById('resetBtn');

        resetBtn.addEventListener('click', function () {
            document.getElementById('emptyGuideCards').classList.remove('hidden');
            document.getElementById('searchResultsSection').classList.add('hidden');
            resetBtn.classList.add('hidden');

            document.getElementById('branch-selector').value = '';

            setDefaultDateValues();

            tabs.forEach(function(t) {
                t.classList.remove('active');
            });

            document.querySelector('.tab[data-tab="daily"]').classList.add('active');

            inputGroups.forEach(function(input) {
                input.classList.toggle('is-hidden', input.dataset.input !== 'daily');
            });

            tabContents.forEach(function(content) {
                content.classList.remove('active');
            });

            currentPageMap = {
                daily: 1,
                period: 1,
                hourly: 1,
                menu: 1
            };

            currentDataMap = {
                daily: [],
                period: [],
                hourly: [],
                menu: []
            };

            Object.keys(charts).forEach(function(key) {
                if (charts[key]) {
                    charts[key].destroy();
                    delete charts[key];
                }
            });
        });

        function fetchDailyData() {
            const branchCode = document.getElementById('branch-selector').value;
            const targetDate = document.getElementById('daily-date').value;
            const contextPath = window.__ZEROLOSS_CP || '';
            // JSP EL 충돌 방지를 위해 + 연산자로 문자열 결합
            const url = contextPath + '/hq/sales/daily?branchCode=' + branchCode + '&date=' + targetDate;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if(data.error) { commonShowAlert('알림', data.error); return; }
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
                    if(data.error) { commonShowAlert('알림', data.error); return; }
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
                    if(data.error) { commonShowAlert('알림', data.error); return; }
                    renderHourlyChart(data);
                    renderHourlyTable(data);
                })
                .catch(error => console.error('Error fetching hourly sales:', error));
        }

        function fetchMenuData() {
            const branchCode = document.getElementById('branch-selector').value;
            const targetDate = document.getElementById('menu-date').value;
            const contextPath = window.__ZEROLOSS_CP || '';

            const url = contextPath + '/hq/sales/menu?branchCode=' + branchCode + '&date=' + targetDate;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        commonShowAlert('알림', data.error);
                        return;
                    }

                    currentPageMap.menu = 1;
                    renderMenuChart(data);
                    renderMenuTable(data);
                })
                .catch(error => console.error('Error fetching menu sales:', error));
        }
        
        // 페이징
        function getPaginatedData(type, data) {
		    const currentPage = currentPageMap[type];
		    const startIndex = (currentPage - 1) * itemsPerPage;
		    const endIndex = startIndex + itemsPerPage;
		
		    return data.slice(startIndex, endIndex);
		}
		
        function renderPagination(type, totalItems) {
            const totalPages = Math.ceil(totalItems / itemsPerPage);

            const paginationContainer = document.getElementById(type + '-pagination');
            const paginationInfo = document.getElementById(type + '-pagination-info');
            const pageButtons = document.getElementById(type + '-page-buttons');

            if (!paginationContainer || !paginationInfo || !pageButtons) {
                return;
            }

            if (totalPages <= 1) {
                paginationContainer.classList.add('hidden');
                paginationInfo.textContent = '';
                pageButtons.innerHTML = '';
                return;
            }

            paginationContainer.classList.remove('hidden');

            const currentPage = currentPageMap[type];

            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = Math.min(startIndex + itemsPerPage, totalItems);

            paginationInfo.textContent =
                (startIndex + 1) + '-' + endIndex + ' / ' + totalItems + '개';

            const baseClass =
                'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 transition-colors';

            const activeClass =
                'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white border border-[#00853D]';

            const disabledClass =
                'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-200 text-gray-300 cursor-not-allowed bg-gray-50';

            let html = '';

            const startPage = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
            const endPage = Math.min(startPage + PAGE_SIZE - 1, totalPages);

            const prevGroupPage = Math.max(1, startPage - PAGE_SIZE);
            const nextGroupPage = Math.min(totalPages, endPage + 1);

            // 처음 버튼
            html += '<button type="button" class="' + (currentPage === 1 ? disabledClass : baseClass) + '" ' +
                (currentPage === 1 ? 'disabled' : '') +
                ' onclick="changeSalesPage(\'' + type + '\', 1)">' +
                '<i class="fas fa-angles-left text-xs"></i>' +
                '</button>';

            // 이전 묶음 버튼: 6~10에서 누르면 5로 이동
            html += '<button type="button" class="' + (startPage === 1 ? disabledClass : baseClass) + '" ' +
                (startPage === 1 ? 'disabled' : '') +
                ' onclick="changeSalesPage(\'' + type + '\', ' + prevGroupPage + ')">' +
                '<i class="fas fa-chevron-left text-xs"></i>' +
                '</button>';

            // 페이지 번호
            for (let i = startPage; i <= endPage; i++) {
                html += '<button type="button" class="' + (i === currentPage ? activeClass : baseClass) + '" ' +
                    'onclick="changeSalesPage(\'' + type + '\', ' + i + ')">' +
                    i +
                    '</button>';
            }

            // 다음 묶음 버튼: 1~5에서 누르면 6으로 이동
            html += '<button type="button" class="' + (endPage >= totalPages ? disabledClass : baseClass) + '" ' +
                (endPage >= totalPages ? 'disabled' : '') +
                ' onclick="changeSalesPage(\'' + type + '\', ' + nextGroupPage + ')">' +
                '<i class="fas fa-chevron-right text-xs"></i>' +
                '</button>';

            // 마지막 버튼
            html += '<button type="button" class="' + (currentPage === totalPages ? disabledClass : baseClass) + '" ' +
                (currentPage === totalPages ? 'disabled' : '') +
                ' onclick="changeSalesPage(\'' + type + '\', ' + totalPages + ')">' +
                '<i class="fas fa-angles-right text-xs"></i>' +
                '</button>';

            pageButtons.innerHTML = html;
        }
        
        window.changeSalesPage = function(pageType, page) {
            const data = currentDataMap[pageType] || [];
            const maxPage = Math.ceil(data.length / itemsPerPage);

            if (page < 1 || page > maxPage) {
                return;
            }

            currentPageMap[pageType] = page;

            if (pageType === 'daily') {
                renderDailyTable(data);
            } else if (pageType === 'period') {
                renderPeriodTable(data);
            } else if (pageType === 'hourly') {
                renderHourlyTable(data);
            } else if (pageType === 'menu') {
                renderMenuTable(data);
            }
        };

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

            currentDataMap.menu = data;

            const paginatedData = getPaginatedData('menu', data);
            const formatCurrency = (amount) => new Intl.NumberFormat('ko-KR').format(amount);

            paginatedData.forEach(item => {
                const row = document.createElement('tr');
                row.className = 'hover:bg-gray-50';

                row.innerHTML =
                    '<td class="px-4 py-3 text-sm text-gray-900">' + item.menuName + '</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-600">' + item.quantity + '개</td>' +
                    '<td class="px-4 py-3 text-sm text-right font-semibold text-gray-900">₩' + formatCurrency(item.totalSales) + '</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-900">' + item.salesShare.toFixed(2) + '%</td>';

                tableBody.appendChild(row);
            });

            renderPagination('menu', data.length);
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

            data.forEach(item => {
                if (item.totalSales > maxSales) {
                    maxSales = item.totalSales;
                    peakHour = item.hour;
                }
            });

            const fullHourlyData = Array.from({length: 24}, (_, i) => ({
                hour: i,
                totalSales: 0,
                totalOrders: 0
            }));

            data.forEach(item => {
                fullHourlyData[item.hour] = item;
            });

            currentDataMap.hourly = fullHourlyData;

            const paginatedData = getPaginatedData('hourly', fullHourlyData);

            paginatedData.forEach(item => {
                const row = document.createElement('tr');
                row.className = 'hover:bg-gray-50';

                const avgOrderValue = item.totalOrders > 0 ? item.totalSales / item.totalOrders : 0;

                if (item.hour === peakHour && maxSales > 0) {
                    row.style.backgroundColor = '#ecf8f1';
                    row.style.fontWeight = 'bold';
                }

                row.innerHTML =
                    '<td class="px-4 py-3 text-sm text-gray-900">' + item.hour + '시</td>' +
                    '<td class="px-4 py-3 text-sm text-right font-semibold text-gray-900">₩' + formatCurrency(item.totalSales) + '</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-600">' + item.totalOrders + '건</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-600">₩' + formatCurrency(Math.round(avgOrderValue)) + '</td>';

                tableBody.appendChild(row);
            });

            renderPagination('hourly', fullHourlyData.length);
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

            currentDataMap.daily = data;

            const paginatedData = getPaginatedData('daily', data);
            const formatCurrency = (amount) => new Intl.NumberFormat('ko-KR').format(amount);
            const dayNames = ['일', '월', '화', '수', '목', '금', '토'];

            paginatedData.forEach(item => {
                const row = document.createElement('tr');
                row.className = 'hover:bg-gray-50';

                const date = new Date(item.saleDate);
                const dayOfWeek = dayNames[date.getDay()];
                const isWeekend = date.getDay() === 0 || date.getDay() === 6;

                if (isWeekend) {
                    row.classList.add('weekend-row');
                }

                row.innerHTML =
                    '<td class="px-4 py-3 text-sm text-gray-900">' + item.saleDate + '</td>' +
                    '<td class="px-4 py-3 text-sm text-gray-900">' + dayOfWeek + '</td>' +
                    '<td class="px-4 py-3 text-sm text-right font-semibold text-gray-900">₩' + formatCurrency(item.totalSales) + '</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-600">' + item.totalOrders + '건</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-600">₩' + formatCurrency(item.cumulativeSales) + '</td>';

                tableBody.appendChild(row);
            });

            renderPagination('daily', data.length);
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

            currentDataMap.period = data || [];

            const paginatedData = getPaginatedData('period', currentDataMap.period);
            const formatCurrency = (amount) => new Intl.NumberFormat('ko-KR').format(amount || 0);
            const dayNames = ['일', '월', '화', '수', '목', '금', '토'];

            if (!paginatedData || paginatedData.length === 0) {
                tableBody.innerHTML =
                    '<tr>' +
                        '<td colspan="5" class="px-4 py-8 text-center text-sm text-gray-500">' +
                            '조회된 기간별 매출 데이터가 없습니다.' +
                        '</td>' +
                    '</tr>';

                renderPagination('period', 0);
                return;
            }

            paginatedData.forEach(item => {
                const row = document.createElement('tr');
                row.className = 'hover:bg-gray-50';

                const date = new Date(item.saleDate);
                const dayOfWeek = dayNames[date.getDay()];
                const isWeekend = date.getDay() === 0 || date.getDay() === 6;

                if (isWeekend) {
                    row.classList.add('weekend-row');
                }

                row.innerHTML =
                    '<td class="px-4 py-3 text-sm text-gray-900">' + item.saleDate + '</td>' +
                    '<td class="px-4 py-3 text-sm text-gray-900">' + dayOfWeek + '</td>' +
                    '<td class="px-4 py-3 text-sm text-right font-semibold text-gray-900">₩' + formatCurrency(item.totalSales) + '</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-600">' + (item.totalOrders || 0).toLocaleString() + '건</td>' +
                    '<td class="px-4 py-3 text-sm text-right text-gray-600">₩' + formatCurrency(item.cumulativeSales) + '</td>';

                tableBody.appendChild(row);
            });

            renderPagination('period', currentDataMap.period.length);
        }

        // 페이지 초기화
        loadBranches();
    });
</script>
</body>
</html>
