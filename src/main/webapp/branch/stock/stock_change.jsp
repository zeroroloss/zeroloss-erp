<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>재고 변동</title>

	<!-- custom date picker (copied design from sales-headquarters.jsp) -->

	<style>
		body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #f4f7fb; color: #111827; }
		.wrap { width: 100%; max-width: none; margin: 0; }
		.page-head { padding: 18px 0 14px; }
		.page-title { margin: 0; font-size: 30px; line-height: 1.15; font-weight: 800; letter-spacing: -0.03em; }
		.page-sub { margin: 8px 0 0; font-size: 15px; color: #6b7280; }

		.filter-card { margin-top: 10px; background: #fff; border: 1px solid #e5e7eb; border-radius: 14px; padding: 14px 16px; box-shadow: 0 8px 20px rgba(15, 23, 42, 0.04); }

		/* 필터 + 버튼 한 줄 */
		.filter-line { display: flex; align-items: flex-end; gap: 16px; }
		.filter-fields { display: grid; grid-template-columns: 1.1fr 1.1fr 1.8fr; gap: 16px; flex: 1; }
		.filter-actions { display: flex; gap: 10px; flex-shrink: 0; }

		.field label { display: block; font-size: 14px; font-weight: 700; color: #374151; margin-bottom: 8px; }
		.field select, .field input[type="text"] { width: 100%; box-sizing: border-box; height: 40px; border: 1px solid #d5dae4; border-radius: 10px; padding: 0 14px; font-size: 14px; color: #111827; background: #fff; }
		.date-range { display: flex; align-items: center; gap: 8px; }
		.date-range span { color: #6b7280; flex-shrink: 0; }

		/* flatpickr 아이콘 */
		.date-picker-wrap { position: relative; flex: 1; }
		.date-picker-wrap input {
			width: 100%; box-sizing: border-box;
			padding-left: 38px !important;
			background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zM4.5 6.75A1.25 1.25 0 015.75 5.5h8.5A1.25 1.25 0 0115.5 6.75v8.5A1.25 1.25 0 0114.25 16.5h-8.5A1.25 1.25 0 014.5 15.25v-8.5zM7 10a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm-6 3a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2z' clip-rule='evenodd' /%3E%3C/svg%3E");
			background-repeat: no-repeat;
			background-position: 10px center;
			background-size: 20px;
		}

		/* Custom date picker (sales style) */
		.custom-date-picker {
		    position: fixed;
		    width: 500px;
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

		.custom-date-nav-btn:hover { background: #f3f4f6; }

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

		.custom-date-day.other-month { color: #c4c4c4; }
		.custom-date-day.today { border: 1px solid #00853D; color: #00853D; font-weight: 700; }
		.custom-date-day.selected { background: #00853D; color: #fff; font-weight: 700; }

		.filter-btn { height: 40px; padding: 0 18px; border: 0; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; white-space: nowrap; }
		.filter-btn.primary { background: #00853d; color: #fff; }
		.filter-btn.primary:hover { background: #006b2f; }
		.filter-btn.secondary { background: #eef2f7; color: #374151; }
		.filter-btn.secondary:hover { background: #e5e7eb; }

		.table-card { margin-top: 18px; background: #fff; border: 1px solid #e5e7eb; border-radius: 14px; overflow: hidden; box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05); }
		.tabs { display: grid; grid-template-columns: repeat(2, 1fr); border-bottom: 1px solid #e6eaf0; }
		.tab-link { height: 52px; display: flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none; background: #fff; font-size: 16px; font-weight: 700; letter-spacing: -0.01em; color: #6b7280; cursor: pointer; border: none; }
		.tab-link.active { color: #2563eb; background: #f3f6ff; box-shadow: inset 0 -2px 0 #4f7dff; }
		.tab-link.disposal.active { color: #dc2626; background: #fff5f5; box-shadow: inset 0 -2px 0 #ef4444; }

		.tab-panel { display: none; }
		.tab-panel.active { display: block; }
		.panel { background: #fff; overflow: hidden; }
		.panel-head { padding: 16px 18px; border-bottom: 1px solid #eef2f7; display: flex; align-items: center; justify-content: space-between; }
		.panel-head-info .panel-title { margin: 0; font-size: 18px; font-weight: 700; color: #111827; }
		.panel-head-info .panel-sub   { margin: 4px 0 0; font-size: 13px; color: #6b7280; }

		.stock-search { position: relative; }
		.stock-search input { height: 34px; padding: 0 12px 0 32px; border: 1px solid #d1d5db; border-radius: 8px; font-size: 13px; width: 200px; background: #fff; color: #111827; }
		.stock-search input:focus { outline: none; border-color: #00853d; }
		.stock-search input::placeholder { color: #9ca3af; }
		.stock-search::before { content: ''; position: absolute; left: 10px; top: 50%; transform: translateY(-50%); width: 14px; height: 14px; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%239ca3af' stroke-width='2'%3E%3Ccircle cx='11' cy='11' r='8'/%3E%3Cline x1='21' y1='21' x2='16.65' y2='16.65'/%3E%3C/svg%3E") no-repeat center; pointer-events: none; }

		.table-wrap { overflow-x: auto; }
		table { width: 100%; border-collapse: collapse; }
		th, td { padding: 12px 14px; border-bottom: 1px solid #f1f5f9; text-align: left; font-size: 13px; }
		th { background: #f8fafc; color: #374151; font-weight: 700; }

		.badge { display: inline-block; padding: 3px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; }
		.badge-INBOUND     { background: #dcfce7; color: #166534; }
		.badge-EXCHANGEIN  { background: #dcfce7; color: #166534; }
		.badge-EXCHANGEOUT { background: #ede9fe; color: #6d28d9; }
		.badge-DISPOSAL    { background: #fee2e2; color: #b91c1c; }
		.badge-EXPIRED  { background: #fee2e2; color: #b91c1c; }
		.badge-DAMAGED  { background: #ffedd5; color: #c2410c; }
		.badge-ETC      { background: #f1f5f9; color: #475569; }
		.qty-plus  { color: #16a34a; font-weight: 700; }
		.qty-minus { color: #dc2626; font-weight: 700; }

		.empty-state { display: none; padding: 34px 16px; text-align: center; color: #6b7280; }
		.empty-state.visible { display: block; }

		.disposal-banner { margin: 18px 18px 0; padding: 16px; border-radius: 14px; background: linear-gradient(135deg, #fff7ed, #fff); border: 1px solid #fed7aa; display: flex; justify-content: space-between; align-items: center; gap: 14px; }
		.disposal-title { margin: 0; font-size: 18px; font-weight: 700; color: #9a3412; }
		.disposal-text  { margin: 6px 0 0; color: #7c2d12; font-size: 13px; }

		.paging-wrap { display: flex; justify-content: center; align-items: center; gap: 4px; padding: 16px 14px; }
		.page-btn { min-width: 40px; height: 38px; padding: 0 12px; border: 1px solid #d1d5db; border-radius: 8px; background: #fff; color: #374151; font-size: 14px; font-weight: 500; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; }
		.page-btn:hover { background: #f9fafb; }
		.page-btn.active { background: #00853D; color: #fff; border-color: #00853D; font-weight: 700; }
		.page-btn:disabled { opacity: 0.4; cursor: not-allowed; background: #fff; }
		.page-btn:disabled:hover { background: #fff; }
		.page-info { font-size: 13px; color: #6b7280; margin: 0 8px; }

		@media (max-width: 1000px) { .filter-fields { grid-template-columns: repeat(2, minmax(0, 1fr)); } .filter-line { flex-wrap: wrap; } }
		@media (max-width: 640px)  { .filter-fields { grid-template-columns: 1fr; } .filter-actions { width: 100%; } .tabs { grid-template-columns: 1fr; } .tab-link { height: 46px; } }
	</style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
<%
	LocalDate today = LocalDate.now();
	String defaultStartDate = today.withDayOfMonth(1).toString();
	String defaultEndDate   = today.toString();
%>
</head>
<body>
	<div class="zl-app">
		<%@ include file="/branch/common/layout/sidebar.jsp"%>
		<div class="zl-content">
			<div class="wrap p-6">
				<div class="page-head">
					<h1 class="page-title">재고 변동</h1>
					<p class="page-sub">재고 이력과 폐기 처리 내역을 확인합니다.</p>
				</div>

				<div class="filter-card">
					<div class="filter-line">
						<!-- 필터 필드 -->
						<div class="filter-fields">
							<div class="field">
								<label for="categoryFilter">카테고리</label> <select
									id="categoryFilter" onchange="onCategoryChange()">
									<option value="">전체</option>
								</select>
							</div>
							<div class="field">
								<label for="itemFilter">품목명</label> <select id="itemFilter">
									<option value="">전체</option>
								</select>
							</div>
							<div class="field">
								<label>변동 시점</label>
								<div class="date-range">
									<div class="date-picker-wrap">
										<input type="text" id="filterStartDate" placeholder="시작일"
											readonly onclick="openCustomDatePicker('filterStartDate', event)">
									</div>
									<span>~</span>
									<div class="date-picker-wrap">
										<input type="text" id="filterEndDate" placeholder="종료일"
											readonly onclick="openCustomDatePicker('filterEndDate', event)">
									</div>
								</div>
							</div>
						</div>
						<!-- 버튼 오른쪽 정렬 -->
						<div class="filter-actions">
							<button type="button" class="filter-btn primary"
								onclick="applyFilters()">조회하기</button>
							<button type="button" class="filter-btn secondary"
								onclick="resetFilters()">초기화</button>
						</div>
					</div>
				</div>

				<div class="table-card" id="tableCard" style="display: none;">
					<div class="tabs">
						<button class="tab-link active" data-tab="history"
							onclick="switchTab('history')">변동 이력</button>
						<button class="tab-link disposal" data-tab="disposal"
							onclick="switchTab('disposal')">폐기 내역</button>
					</div>

					<!-- 변동 이력 탭 -->
					<div id="historyPanel" class="tab-panel active">
						<div class="panel">
							<div class="panel-head">
								<div class="panel-head-info">
									<h2 class="panel-title">재고 변동 이력</h2>
									<p class="panel-sub">입고, 교환, 폐기 등 재고 변동 내역입니다.</p>
								</div>
								<div class="stock-search">
									<input type="text" id="historyStockSearch"
										placeholder="재고 번호 검색" oninput="onStockSearch('history')">
								</div>
							</div>
							<div class="table-wrap">
								<table>
									<thead>
										<tr>
											<th>재고 번호</th>
											<th>카테고리</th>
											<th>품목명</th>
											<th>변동 시점</th>
											<th>변동 유형</th>
											<th>변동 수량</th>
											<th>처리 후 수량</th>
											<th>유통기한</th>
										</tr>
									</thead>
									<tbody id="historyTableBody"></tbody>
								</table>
								<div id="historyEmptyState" class="empty-state">조회 결과가
									없습니다.</div>
								<div class="paging-wrap" id="historyPaging"
									style="display: none;"></div>
							</div>
						</div>
					</div>

					<!-- 폐기 내역 탭 -->
					<div id="disposalPanel" class="tab-panel">
						<div class="disposal-banner">
							<div>
								<h2 class="disposal-title">재고 폐기 내역</h2>
								<p class="disposal-text">유통기한 만료, 품질 불량, 파손 등으로 폐기된 품목
									내역입니다.</p>
							</div>
						</div>
						<div class="panel">
							<div class="panel-head">
								<div class="panel-head-info">
									<h2 class="panel-title">폐기 처리 내역</h2>
									<p class="panel-sub">폐기 등록은 재고 현황 페이지에서 처리할 수 있습니다.</p>
								</div>
								<div class="stock-search">
									<input type="text" id="disposalStockSearch"
										placeholder="재고 번호 검색" oninput="onStockSearch('disposal')">
								</div>
							</div>
							<div class="table-wrap">
								<table>
									<thead>
										<tr>
											<th>재고 번호</th>
											<th>카테고리</th>
											<th>품목명</th>
											<th>폐기 시점</th>
											<th>폐기 수량</th>
											<th>폐기 사유</th>
											<th>상세 내용</th>
											<th>유통기한</th>
										</tr>
									</thead>
									<tbody id="disposalTableBody"></tbody>
								</table>
								<div id="disposalEmptyState" class="empty-state">조회 결과가
									없습니다.</div>
								<div class="paging-wrap" id="disposalPaging"
									style="display: none;"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
(function () {
	var contextPath      = '<%= request.getContextPath() %>';
	var defaultStartDate = '<%= defaultStartDate %>';
	var defaultEndDate   = '<%= defaultEndDate %>';
	var currentTab       = 'history';
	var historyPage      = 1;
	var disposalPage     = 1;
	var lastHistoryData  = [];
	var lastDisposalData = [];

	function escapeHtml(v) {
		return String(v == null ? '' : v)
			.replace(/&/g,'&amp;').replace(/</g,'&lt;')
			.replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
	}

	/* ── 카테고리 / 품목 필터 ── */
	function loadCategoryList() {
		fetch(contextPath + '/branch/stock/categories')
			.then(function (res) { return res.json(); })
			.then(function (data) {
				var el = document.getElementById('categoryFilter');
				el.innerHTML = '<option value="">전체</option>';
				data.forEach(function (item) {
					el.insertAdjacentHTML('beforeend',
						'<option value="' + escapeHtml(item.materialGroupId) + '">' + escapeHtml(item.groupName) + '</option>');
				});
			});
	}

	window.onCategoryChange = function () {
		var materialGroupId = document.getElementById('categoryFilter').value;
		var sel = document.getElementById('itemFilter');
		sel.innerHTML = '<option value="">전체</option>';
		if (!materialGroupId) return;
		fetch(contextPath + '/branch/stock/materials?materialGroupId=' + encodeURIComponent(materialGroupId))
			.then(function (res) { return res.json(); })
			.then(function (data) {
				data.forEach(function (item) {
					sel.insertAdjacentHTML('beforeend',
						'<option value="' + escapeHtml(item.materialName) + '">' + escapeHtml(item.materialName) + '</option>');
				});
			});
	};

	/* ── 탭 전환 ── */
	window.switchTab = function (tab) {
		currentTab = tab;
		document.querySelectorAll('.tab-link').forEach(function (btn) {
			btn.classList.toggle('active', btn.getAttribute('data-tab') === tab);
		});
		document.getElementById('historyPanel').classList.toggle('active',  tab === 'history');
		document.getElementById('disposalPanel').classList.toggle('active', tab === 'disposal');
		loadTabData(tab, 1);
	};

	/* ── 재고 번호 검색 (클라이언트) ── */
	window.onStockSearch = function (tab) {
		if (tab === 'history') renderHistory(lastHistoryData);
		else                   renderDisposal(lastDisposalData);
	};

	function filterByStockCode(list, tab) {
		var inputId = tab === 'history' ? 'historyStockSearch' : 'disposalStockSearch';
		var keyword = document.getElementById(inputId).value.trim().toLowerCase();
		if (!keyword) return list;
		return list.filter(function (r) {
			return r.branchStockCode && r.branchStockCode.toLowerCase().indexOf(keyword) >= 0;
		});
	}

	/* ── 데이터 로드 ── */
	function loadTabData(tab, page) {
		if (tab === 'history') historyPage  = page || 1;
		else                   disposalPage = page || 1;

		var materialGroupId = document.getElementById('categoryFilter').value;
		var materialName    = document.getElementById('itemFilter').value;
		var startDate       = document.getElementById('filterStartDate').value;
		var endDate         = document.getElementById('filterEndDate').value;
		var p               = tab === 'history' ? historyPage : disposalPage;

		var url = contextPath + '/branch/stock_change/view?'
			+ 'tab='              + encodeURIComponent(tab)
			+ '&materialGroupId=' + encodeURIComponent(materialGroupId)
			+ '&materialName='    + encodeURIComponent(materialName)
			+ '&startDate='       + encodeURIComponent(startDate)
			+ '&endDate='         + encodeURIComponent(endDate)
			+ '&page='            + p;

		fetch(url, { headers: { 'Accept': 'application/json' } })
			.then(function (res) { return res.json(); })
			.then(function (data) {
				if (tab === 'history') {
					lastHistoryData = data.list || [];
					renderHistory(lastHistoryData);
					renderPaging('historyPaging', data.totalCount, data.page, data.totalPages, 'history');
				} else {
					lastDisposalData = data.list || [];
					renderDisposal(lastDisposalData);
					renderPaging('disposalPaging', data.totalCount, data.page, data.totalPages, 'disposal');
				}
			})
			.catch(function () {
				commonShowAlert('알림', '데이터를 불러오지 못했습니다.');
			});
	}

	/* ── 한글 변환 ── */
	function getReasonLabel(reason) {
		var map = { 'EXPIRED': '유통기한 만료', 'DAMAGED': '파손', 'ETC': '기타' };
		return map[reason] || reason;
	}

	function getChangeTypeLabel(type) {
		var map = { 'INBOUND': '입고', 'EXCHANGEIN': '입고', 'EXCHANGEOUT': '교환', 'DISPOSAL': '폐기' };
		return map[type] || type;
	}

	/* ── 변동 이력 렌더링 ── */
	function renderHistory(list) {
		var filtered = filterByStockCode(list, 'history');
		var tbody    = document.getElementById('historyTableBody');
		var empty    = document.getElementById('historyEmptyState');
		tbody.innerHTML = '';
		if (!filtered.length) { empty.classList.add('visible'); return; }
		empty.classList.remove('visible');
		filtered.forEach(function (r) {
			var qtyClass = parseFloat(r.changeAmount) >= 0 ? 'qty-plus' : 'qty-minus';
			tbody.insertAdjacentHTML('beforeend',
				'<tr>' +
					'<td style="font-family:monospace;font-size:12px">' + escapeHtml(r.branchStockCode) + '</td>' +
					'<td>' + escapeHtml(r.groupName) + '</td>' +
					'<td style="font-weight:700">' + escapeHtml(r.materialName) + '</td>' +
					'<td>' + escapeHtml(r.changedAt) + '</td>' +
					'<td><span class="badge badge-' + escapeHtml(r.changeType) + '">' + escapeHtml(getChangeTypeLabel(r.changeType)) + '</span></td>' +
					'<td><span class="' + qtyClass + '">' + escapeHtml(r.changeAmount) + '</span></td>' +
					'<td>' + escapeHtml(r.afterQty) + '</td>' +
					'<td>' + escapeHtml(r.expireDate) + '</td>' +
				'</tr>'
			);
		});
	}

	/* ── 폐기 내역 렌더링 ── */
	function renderDisposal(list) {
		var filtered = filterByStockCode(list, 'disposal');
		var tbody    = document.getElementById('disposalTableBody');
		var empty    = document.getElementById('disposalEmptyState');
		tbody.innerHTML = '';
		if (!filtered.length) { empty.classList.add('visible'); return; }
		empty.classList.remove('visible');
		filtered.forEach(function (r) {
			tbody.insertAdjacentHTML('beforeend',
				'<tr>' +
					'<td style="font-family:monospace;font-size:12px">' + escapeHtml(r.branchStockCode) + '</td>' +
					'<td>' + escapeHtml(r.groupName) + '</td>' +
					'<td style="font-weight:700">' + escapeHtml(r.materialName) + '</td>' +
					'<td>' + escapeHtml(r.changedAt) + '</td>' +
					'<td><strong>' + escapeHtml(r.changeAmount) + '</strong></td>' +
					'<td><span class="badge badge-' + escapeHtml(r.reason) + '">' + escapeHtml(getReasonLabel(r.reason)) + '</span></td>' +
					'<td>' + escapeHtml(r.reasonDetail || '-') + '</td>' +
					'<td>' + escapeHtml(r.expireDate) + '</td>' +
				'</tr>'
			);
		});
	}

	/* ── 페이징 ── */
	function renderPaging(wrapperId, totalCount, page, total, tab) {
	    var wrap = document.getElementById(wrapperId);

	    page = parseInt(page || 1);
	    total = parseInt(total || 1);
	    totalCount = parseInt(totalCount || 0);

	    if (total <= 1) {
	        wrap.style.display = 'none';
	        wrap.innerHTML = '';
	        return;
	    }

	    wrap.style.display = 'flex';

	    var PAGE_SIZE = 5;
	    var blockStart = Math.floor((page - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
	    var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, total);

	    // 블록 이동
	    // 1 2 3 4 5 에서 > 클릭 → 6
	    // 6 7 8 9 10 에서 < 클릭 → 1
	    var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
	    var nextBlockPage = Math.min(total, blockEnd + 1);

	    var html = '';

	    // 맨 첫 페이지
	    html += '<button type="button" class="page-btn" onclick="loadTabData(\'' + tab + '\', 1)" ' +
	            (page === 1 ? 'disabled' : '') + '>';
	    html += '<i class="fas fa-angles-left" style="font-size:11px"></i>';
	    html += '</button>';

	    // 이전 블록
	    html += '<button type="button" class="page-btn" onclick="loadTabData(\'' + tab + '\', ' + prevBlockPage + ')" ' +
	            (blockStart === 1 ? 'disabled' : '') + '>';
	    html += '<i class="fas fa-chevron-left" style="font-size:11px"></i>';
	    html += '</button>';

	    // 페이지 번호
	    for (var i = blockStart; i <= blockEnd; i++) {
	        html += '<button type="button" class="page-btn' + (i === page ? ' active' : '') + '" ';
	        html += 'onclick="loadTabData(\'' + tab + '\', ' + i + ')">';
	        html += i;
	        html += '</button>';
	    }

	    // 다음 블록
	    html += '<button type="button" class="page-btn" onclick="loadTabData(\'' + tab + '\', ' + nextBlockPage + ')" ' +
	            (blockEnd === total ? 'disabled' : '') + '>';
	    html += '<i class="fas fa-chevron-right" style="font-size:11px"></i>';
	    html += '</button>';

	    // 맨 마지막 페이지
	    html += '<button type="button" class="page-btn" onclick="loadTabData(\'' + tab + '\', ' + total + ')" ' +
	            (page === total ? 'disabled' : '') + '>';
	    html += '<i class="fas fa-angles-right" style="font-size:11px"></i>';
	    html += '</button>';

	    wrap.innerHTML = html;
	}

	/* ── 필터 ── */
	window.applyFilters = function () {
		document.getElementById('tableCard').style.display = 'block';
		loadTabData(currentTab, 1);
	};
	window.loadTabData = loadTabData;

	window.resetFilters = function () {
		document.getElementById('categoryFilter').value = '';
		document.getElementById('itemFilter').innerHTML = '<option value="">전체</option>';
		document.getElementById('historyStockSearch').value  = '';
		document.getElementById('disposalStockSearch').value = '';
		document.getElementById('tableCard').style.display = 'none';
		document.getElementById('filterStartDate').value = defaultStartDate;
		document.getElementById('filterEndDate').value = defaultEndDate;
		closeCustomDatePicker();
	};

	/* ── 초기 실행 ── */
	loadCategoryList();

	// initialize inputs with default dates
	document.getElementById('filterStartDate').value = defaultStartDate;
	document.getElementById('filterEndDate').value = defaultEndDate;

	// Custom date picker state
	var customDateTargetId = null;
	var customPickerDate = new Date();

	function parseDateLocal(dateStr) {
		if (!dateStr) return null;
		var parts = String(dateStr).split('-');
		if (parts.length !== 3) return null;
		return new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2]));
	}

	function formatDateLocal(date) {
		return date.getFullYear() + '-' + String(date.getMonth() + 1).padStart(2, '0') + '-' + String(date.getDate()).padStart(2, '0');
	}

	window.openCustomDatePicker = function(inputId, event) {
		if (event) event.stopPropagation();
		customDateTargetId = inputId;
		var input = document.getElementById(inputId);
		var selected = parseDateLocal(input.value);
		customPickerDate = selected || new Date();
		renderCustomDatePicker();
		positionCustomDatePicker(input);
		document.getElementById('customDatePicker').classList.remove('hidden');
	};

	function positionCustomDatePicker(input) {
		var picker = document.getElementById('customDatePicker');
		var rect = input.getBoundingClientRect();
		var pickerWidth = 300; var pickerHeight = 330;
		var top = rect.bottom + 6; var left = rect.left;
		picker.style.width = pickerWidth + 'px';
		if (left + pickerWidth > window.innerWidth) left = window.innerWidth - pickerWidth - 12;
		if (top + pickerHeight > window.innerHeight) top = rect.top - pickerHeight - 6;
		picker.style.top = top + 'px'; picker.style.left = left + 'px';
	}

	window.changeCustomPickerMonth = function(amount) { customPickerDate.setMonth(customPickerDate.getMonth() + amount); renderCustomDatePicker(); };

	window.changeCustomPickerYearMonth = function() {
		var ys = document.getElementById('customDatePickerYear');
		var ms = document.getElementById('customDatePickerMonth');
		customPickerDate = new Date(Number(ys.value), Number(ms.value), 1);
		renderCustomDatePicker();
	};

	function renderCustomPickerYearMonthSelect(year, month) {
		var yearSelect = document.getElementById('customDatePickerYear');
		var monthSelect = document.getElementById('customDatePickerMonth');
		var htmlY = '';
		for (var y = year - 10; y <= year + 10; y++) htmlY += '<option value="'+y+'"' + (y===year? ' selected': '') + '>' + y + '년</option>';
		var htmlM = '';
		for (var m = 0; m < 12; m++) htmlM += '<option value="'+m+'"' + (m===month? ' selected': '') + '>' + (m+1) + '월</option>';
		yearSelect.innerHTML = htmlY; monthSelect.innerHTML = htmlM;
	}

	function renderCustomDatePicker() {
		var year = customPickerDate.getFullYear(); var month = customPickerDate.getMonth();
		renderCustomPickerYearMonthSelect(year, month);
		var firstDay = new Date(year, month, 1); var lastDay = new Date(year, month + 1, 0); var prevLast = new Date(year, month, 0);
		var startDay = firstDay.getDay(); var days = [];
		for (var i = startDay - 1; i >= 0; i--) days.push({ date: new Date(year, month - 1, prevLast.getDate() - i), currentMonth: false });
		for (var d = 1; d <= lastDay.getDate(); d++) days.push({ date: new Date(year, month, d), currentMonth: true });
		var nextDay = 1; while (days.length < 42) { days.push({ date: new Date(year, month + 1, nextDay), currentMonth: false }); nextDay++; }
		var targetInput = customDateTargetId ? document.getElementById(customDateTargetId) : null;
		var selectedValue = targetInput ? targetInput.value : '';
		var todayValue = formatDateLocal(new Date());
		var html = '';
		for (var j = 0; j < days.length; j++) {
			var dateValue = formatDateLocal(days[j].date);
			var className = 'custom-date-day';
			if (!days[j].currentMonth) className += ' other-month';
			if (dateValue === todayValue) className += ' today';
			if (dateValue === selectedValue) className += ' selected';
			html += '<button type="button" class="' + className + '" onclick="selectCustomDate(\'' + dateValue + '\')">';
			html += days[j].date.getDate(); html += '</button>';
		}
		document.getElementById('customDatePickerDays').innerHTML = html;
	}

	window.selectCustomDate = function(dateValue) {
		if (!customDateTargetId) return;
		document.getElementById(customDateTargetId).value = dateValue;
		if (customDateTargetId === 'filterStartDate') {
			// enforce endDate >= startDate
			var sd = parseDateLocal(dateValue);
			var edVal = document.getElementById('filterEndDate').value;
			var ed = parseDateLocal(edVal);
			if (ed && ed < sd) { document.getElementById('filterEndDate').value = dateValue; }
		} else if (customDateTargetId === 'filterEndDate') {
			var ed = parseDateLocal(dateValue);
			var sdVal = document.getElementById('filterStartDate').value;
			var sd = parseDateLocal(sdVal);
			if (sd && sd > ed) { document.getElementById('filterStartDate').value = dateValue; }
		}
		closeCustomDatePicker();
	};

	function closeCustomDatePicker() { var p = document.getElementById('customDatePicker'); if (p) p.classList.add('hidden'); customDateTargetId = null; }

	document.addEventListener('mousedown', function(event) {
		var picker = document.getElementById('customDatePicker');
		if (!picker || picker.classList.contains('hidden')) return;
		if (picker.contains(event.target)) return;
		if (customDateTargetId && document.getElementById(customDateTargetId) && document.getElementById(customDateTargetId).contains(event.target)) return;
		closeCustomDatePicker();
	});
})();
</script>

	<!-- custom date picker element -->
	<div id="customDatePicker" class="custom-date-picker hidden" onclick="event.stopPropagation()">
		<div class="custom-date-picker-header">
			<button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(-1)">
				<i class="fas fa-chevron-left text-xs"></i>
			</button>

			<div class="flex items-center gap-2">
				<select id="customDatePickerYear" onchange="changeCustomPickerYearMonth()" class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold outline-none"></select>

				<select id="customDatePickerMonth" onchange="changeCustomPickerYearMonth()" class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold outline-none"></select>
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
</body>
</html>