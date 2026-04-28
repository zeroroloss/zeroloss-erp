<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>재고 변동</title>
	<style>
		body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #f4f7fb; color: #111827; }
		.wrap { width: 100%; max-width: none; margin: 0; }
		.page-head { padding: 18px 0 14px; }
		.page-title { margin: 0; font-size: 30px; line-height: 1.15; font-weight: 800; letter-spacing: -0.03em; }
		.page-sub { margin: 8px 0 0; font-size: 15px; color: #6b7280; }

		.filter-card { margin-top: 10px; background: #fff; border: 1px solid #e5e7eb; border-radius: 14px; padding: 14px 16px; box-shadow: 0 8px 20px rgba(15, 23, 42, 0.04); }
		.filter-head { display: flex; align-items: center; gap: 8px; margin-bottom: 10px; color: #111827; font-size: 18px; font-weight: 800; letter-spacing: -0.02em; }
		.filter-line { display: grid; grid-template-columns: 1.1fr 1.1fr 0.9fr 0.9fr; gap: 16px; }
		.field label { display: block; font-size: 14px; font-weight: 700; color: #374151; margin-bottom: 8px; }
		.field select, .date-input input { width: 100%; box-sizing: border-box; height: 40px; border: 1px solid #d5dae4; border-radius: 10px; padding: 0 14px; font-size: 14px; color: #111827; background: #fff; }
		.filter-actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 14px; }
		.filter-btn { height: 40px; padding: 0 18px; border: 0; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; transition: background 0.15s ease, color 0.15s ease; }
		.filter-btn.primary { background: #00853d; color: #fff; }
		.filter-btn.primary:hover { background: #006b2f; }
		.filter-btn.secondary { background: #eef2f7; color: #374151; }
		.filter-btn.secondary:hover { background: #e5e7eb; }
		.date-field { grid-column: span 2; }

		.table-card { margin-top: 18px; background: #fff; border: 1px solid #e5e7eb; border-radius: 14px; overflow: hidden; box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05); }
		.tabs { display: grid; grid-template-columns: repeat(2, 1fr); border-bottom: 1px solid #e6eaf0; }
		.tab-link { height: 52px; display: flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none; background: #fff; font-size: 16px; font-weight: 700; letter-spacing: -0.01em; color: #6b7280; }
		.tab-link.active { color: #2563eb; background: #f3f6ff; box-shadow: inset 0 -2px 0 #4f7dff; }
		.tab-link.disposal.active { color: #dc2626; background: #fff5f5; box-shadow: inset 0 -2px 0 #ef4444; }

		.tab-panel { display: none; }
		.tab-panel.active { display: block; }
		.panel { background: #fff; overflow: hidden; }
		.panel-head { padding: 16px 18px; border-bottom: 1px solid #eef2f7; }
		.panel-title { margin: 0; font-size: 18px; font-weight: 700; color: #111827; }
		.panel-sub { margin: 6px 0 0; font-size: 13px; color: #6b7280; }
		.panel-actions { margin-top: 12px; display: flex; justify-content: flex-end; gap: 10px; flex-wrap: wrap; }
		.btn { display: inline-flex; align-items: center; justify-content: center; padding: 10px 14px; border-radius: 10px; text-decoration: none; font-weight: 700; border: 0; cursor: pointer; }
		.btn-primary { background: #2563eb; color: #fff; }
		.btn-danger { background: #dc2626; color: #fff; }
		.btn-muted { background: #eef2f7; color: #374151; }

		.table-wrap { overflow-x: auto; }
		table { width: 100%; border-collapse: collapse; }
		th, td { padding: 12px 14px; border-bottom: 1px solid #f1f5f9; text-align: left; font-size: 13px; }
		th { background: #f8fafc; color: #374151; }
		.right { text-align: right; }
		.center { text-align: center; }
		.badge { display: inline-block; padding: 3px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; }
		.badge-in { background: #dcfce7; color: #166534; }
		.badge-out { background: #dbeafe; color: #1d4ed8; }
		.badge-disposal { background: #fee2e2; color: #b91c1c; }
		.badge-adjust { background: #fef3c7; color: #b45309; }
		.badge-state { background: #ecfeff; color: #0f766e; }
		.qty-plus { color: #16a34a; font-weight: 700; }
		.qty-minus { color: #dc2626; font-weight: 700; }
		.empty-state { display: none; padding: 34px 16px; text-align: center; color: #6b7280; }
		.empty-state.visible { display: block; }

		.disposal-banner { margin: 18px 18px 0; padding: 16px; border-radius: 14px; background: linear-gradient(135deg, #fff7ed, #fff); border: 1px solid #fed7aa; display: flex; justify-content: space-between; align-items: center; gap: 14px; }
		.disposal-title { margin: 0; font-size: 18px; font-weight: 700; color: #9a3412; }
		.disposal-text { margin: 6px 0 0; color: #7c2d12; font-size: 13px; }

		@media (max-width: 1000px) {
			.filter-line { grid-template-columns: repeat(2, minmax(0, 1fr)); }
		}
		@media (max-width: 640px) {
			.filter-line { grid-template-columns: 1fr; }
			.tabs { grid-template-columns: 1fr; }
			.tab-link { height: 46px; }
			.disposal-banner { flex-direction: column; align-items: stretch; }
		}
	</style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
<%
	String initialTab = "history";
	LocalDate today = LocalDate.now();
	String defaultStartDate = today.withDayOfMonth(1).toString();
	String defaultEndDate = today.withDayOfMonth(today.lengthOfMonth()).toString();
	String startDateValue = request.getParameter("startDate");
	if (startDateValue == null || startDateValue.isBlank()) startDateValue = defaultStartDate;
	String endDateValue = request.getParameter("endDate");
	if (endDateValue == null || endDateValue.isBlank()) endDateValue = defaultEndDate;
%>
</head>
<body>
<div class="zl-app">
<%@ include file="/branch/common/layout/sidebar.jsp" %>
<div class="zl-content">
<%@ include file="/branch/common/layout/topbar.jsp" %>
<div class="wrap p-6">
	<div class="page-head">
		<h1 class="page-title">재고 변동</h1>
		<p class="page-sub">재고 이력과 폐기 처리를 확인합니다.</p>
	</div>

	<div class="filter-card">
		<div class="filter-line">
			<div class="field">
				<label for="categoryFilter">카테고리</label>
				<select id="categoryFilter">
					<option value="">전체</option>
					<option value="단백질">단백질</option>
					<option value="야채">야채</option>
					<option value="치즈">치즈</option>
					<option value="빵류">빵류</option>
					<option value="소스">소스</option>
					<option value="쿠키">쿠키</option>
					<option value="음료">음료</option>
				</select>
			</div>
			<div class="field">
				<label for="itemFilter">상품명</label>
				<select id="itemFilter">
					<option value="">전체</option>
				</select>
			</div>
			<div class="field date-field">
				<label for="filterStartDate">일자 범위</label>
				<div class="flex items-center gap-2">
					<input type="date" id="filterStartDate"
						value="<%= startDateValue %>"
						class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">

					<span class="text-gray-500">~</span>

					<input type="date" id="filterEndDate"
						value="<%= endDateValue %>"
						class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
				</div>
			</div>
		</div>
		<div class="filter-actions">
			<button type="button" class="filter-btn primary" onclick="applyFilters()">조회하기</button>
			<button type="button" class="filter-btn secondary" onclick="resetFilters()">초기화</button>
		</div>
	</div>

	<div class="table-card">
		<div class="tabs">
			<a class="tab-link <%= "history".equals(initialTab) ? "active" : "" %>" href="<%= request.getContextPath() %>/branch/stock/stock_change.jsp" data-tab="history">변동 이력</a>
			<a class="tab-link disposal <%= "disposal".equals(initialTab) ? "active" : "" %>" href="<%= request.getContextPath() %>/branch/stock/stock_change.jsp" data-tab="disposal">폐기 내역</a>
		</div>

		<div id="historyPanel" class="tab-panel <%= "history".equals(initialTab) ? "active" : "" %>">
			<div class="panel">
				<div class="panel-head">
					<h2 class="panel-title">재고 이력</h2>
					<p class="panel-sub">지점장 계정에서 확인하는 최근 재고 입출고 이력입니다.</p>
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
								<th class="right">변동 수량</th>
								<th class="right">처리 후 수량</th>
								<th>유통기한</th>
							</tr>
						</thead>
						<tbody id="historyTableBody"></tbody>
					</table>
					<div id="historyEmptyState" class="empty-state">조회 결과가 없습니다.</div>
				</div>
			</div>
		</div>

		<div id="disposalPanel" class="tab-panel <%= "disposal".equals(initialTab) ? "active" : "" %>">
			<div class="disposal-banner">
				<div>
					<h2 class="disposal-title">재고 폐기 내역</h2>
					<p class="disposal-text">폐기 대상 품목과 등록 내역을 확인하고, 필요 시 폐기 등록 화면으로 이동할 수 있습니다.</p>
				</div>
				<div class="panel-actions" style="margin-top:0;">
					<a class="btn btn-muted" href="<%= request.getContextPath() %>/branch/stock/disposal_registration.jsp">폐기 등록</a>
				</div>
			</div>

			<div class="panel">
				<div class="panel-head">
					<h2 class="panel-title">폐기 처리 내역</h2>
					<p class="panel-sub">유통기한 만료, 품질 불량, 파손 등으로 폐기된 품목입니다.</p>
				</div>
				<div class="table-wrap">
					<table>
						<thead>
							<tr>
								<th>재고 번호</th>
								<th>카테고리</th>
								<th>품목명</th>
								<th>폐기 시점</th>
								<th class="right">폐기 수량</th>
								<th>폐기 사유</th>
								<th>유통기한</th>
							</tr>
						</thead>
						<tbody id="disposalTableBody"></tbody>
					</table>
					<div id="disposalEmptyState" class="empty-state">조회 결과가 없습니다.</div>
				</div>
			</div>
		</div>
	</div>
</div>
</main>
</div>
</div>

<script>
(function () {
	var contextPath = '<%= request.getContextPath() %>';
	var defaultStartDate = '<%= defaultStartDate %>';
	var defaultEndDate = '<%= defaultEndDate %>';
	var initialTab = '<%= initialTab %>';
	var currentTab = initialTab;
	var historyData = [];
	var disposalData = [];
	var historyLoaded = false;
	var disposalLoaded = false;
	var itemFilter = document.getElementById('itemFilter');

	function hasText(value) {
		return value !== null && value !== undefined && String(value).trim() !== '';
	}

	function getRecordValue(record, keys) {
		for (var i = 0; i < keys.length; i += 1) {
			var key = keys[i];
			if (record && hasText(record[key])) {
				return record[key];
			}
		}
		return '';
	}

	function getActiveFilters() {
		return {
			category: document.getElementById('categoryFilter').value,
			item: itemFilter.value,
			startDate: document.getElementById('filterStartDate').value,
			endDate: document.getElementById('filterEndDate').value
		};
	}

	function normalizeResponse(responseData) {
		if (Array.isArray(responseData)) {
			return responseData;
		}
		if (responseData && Array.isArray(responseData.data)) {
			return responseData.data;
		}
		return [];
	}

	function toDateKey(value) {
		if (!value) return '';
		return String(value).split(' ')[0].split('T')[0];
	}

	function applyLocalFilters(list) {
		var filters = getActiveFilters();
		var startDate = filters.startDate ? new Date(filters.startDate) : null;
		var endDate = filters.endDate ? new Date(filters.endDate) : null;
		if (endDate) {
			endDate.setHours(23, 59, 59, 999);
		}

		return list.filter(function (record) {
			var category = getRecordValue(record, ['categoryName', 'category', 'materialGroupName', 'materialGroup']);
			var itemName = getRecordValue(record, ['materialName', 'itemName', 'name', 'material']);
			var recordDate = getRecordValue(record, ['changedAt', 'disposedAt', 'createdAt', 'receivedAt', 'date', 'requestDate']);
			var parsedDate = new Date(toDateKey(recordDate));

			if (filters.category && category !== filters.category) {
				return false;
			}

			if (filters.item && itemName !== filters.item) {
				return false;
			}

			if (startDate && !isNaN(startDate.getTime()) && !isNaN(parsedDate.getTime()) && parsedDate < startDate) {
				return false;
			}

			if (endDate && !isNaN(endDate.getTime()) && !isNaN(parsedDate.getTime()) && parsedDate > endDate) {
				return false;
			}

			return true;
		});
	}

	function escapeHtml(value) {
		return String(value || '')
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#39;');
	}

	function syncItemOptions() {
		var source = currentTab === 'disposal' ? disposalData : historyData;
		var currentValue = itemFilter.value;
		var values = {};
		var options = ['<option value="">전체</option>'];

		source.forEach(function (record) {
			var itemName = getRecordValue(record, ['materialName', 'itemName', 'name', 'material']);
			if (!hasText(itemName) || values[itemName]) {
				return;
			}
			values[itemName] = true;
			options.push('<option value="' + escapeHtml(itemName) + '">' + escapeHtml(itemName) + '</option>');
		});

		itemFilter.innerHTML = options.join('');
		if (currentValue) {
			itemFilter.value = currentValue;
		}
	}

	function buildHistoryRow(record) {
		var type = getRecordValue(record, ['changeType', 'type', 'stockType']) || '조정';
		var typeClass = type === '입고' ? 'badge-in' : type === '출고' ? 'badge-out' : 'badge-adjust';
		var qty = getRecordValue(record, ['changeAmount', 'qtyChange', 'quantity', 'amount']);
		var afterQty = getRecordValue(record, ['afterQty', 'currentQty', 'remainQty']);
		var itemName = getRecordValue(record, ['materialName', 'itemName', 'name', 'material']);
		var stockCode = getRecordValue(record, ['branchStockCode', 'stockCode', 'stockNo']);
		var changedAt = getRecordValue(record, ['changedAt', 'createdAt', 'receivedAt', 'date']);
		var actor = getRecordValue(record, ['operator', 'handledBy', 'createdBy', 'managerName']);
		var note = getRecordValue(record, ['memo', 'remark', 'reason', 'note']);
		var qtyText = qty ? (String(qty).indexOf('-') === 0 ? '<span class="qty-minus">' + escapeHtml(qty) + '</span>' : '<span class="qty-plus">' + escapeHtml(qty) + '</span>') : '-';

		return '<tr>' +
			'<td>' + escapeHtml(stockCode) + '</td>' +
			'<td>' + escapeHtml(changedAt) + '</td>' +
			'<td>' + escapeHtml(itemName) + '</td>' +
			'<td><span class="badge ' + typeClass + '">' + escapeHtml(type) + '</span></td>' +
			'<td class="right">' + qtyText + '</td>' +
			'<td class="right">' + escapeHtml(afterQty || '-') + '</td>' +
			'<td>' + escapeHtml(actor || '-') + '</td>' +
			'<td>' + escapeHtml(note || '-') + '</td>' +
		'</tr>';
	}

	function buildDisposalRow(record) {
		var stockCode = getRecordValue(record, ['branchStockCode', 'stockCode', 'stockNo']);
		var disposedAt = getRecordValue(record, ['disposedAt', 'changedAt', 'createdAt', 'date']);
		var itemName = getRecordValue(record, ['materialName', 'itemName', 'name', 'material']);
		var category = getRecordValue(record, ['categoryName', 'category', 'materialGroupName', 'materialGroup']);
		var qty = getRecordValue(record, ['disposalQty', 'changeAmount', 'quantity', 'amount']);
		var reason = getRecordValue(record, ['reason', 'disposalReason', 'changeType']);
		var reasonDetail = getRecordValue(record, ['reasonDetail', 'detailReason', 'memo', 'remark']);
		var actor = getRecordValue(record, ['operator', 'handledBy', 'createdBy', 'managerName']);
		var state = getRecordValue(record, ['state', 'status', 'result']) || '완료';

		return '<tr>' +
			'<td>' + escapeHtml(stockCode) + '</td>' +
			'<td>' + escapeHtml(disposedAt) + '</td>' +
			'<td>' + escapeHtml(itemName) + '</td>' +
			'<td>' + escapeHtml(category) + '</td>' +
			'<td class="right"><strong>' + escapeHtml(qty || '-') + '</strong></td>' +
			'<td><span class="badge badge-disposal">' + escapeHtml(reason || '-') + '</span></td>' +
			'<td>' + escapeHtml(reasonDetail || '-') + '</td>' +
			'<td>' + escapeHtml(actor || '-') + '</td>' +
			'<td><span class="badge badge-state">' + escapeHtml(state) + '</span></td>' +
		'</tr>';
	}

	function renderHistory() {
		var tbody = document.getElementById('historyTableBody');
		var emptyState = document.getElementById('historyEmptyState');
		var filtered = applyLocalFilters(historyData);

		tbody.innerHTML = '';
		if (filtered.length === 0) {
			emptyState.classList.add('visible');
			return;
		}

		emptyState.classList.remove('visible');
		filtered.forEach(function (record) {
			tbody.insertAdjacentHTML('beforeend', buildHistoryRow(record));
		});
	}

	function renderDisposal() {
		var tbody = document.getElementById('disposalTableBody');
		var emptyState = document.getElementById('disposalEmptyState');
		var filtered = applyLocalFilters(disposalData);

		tbody.innerHTML = '';
		if (filtered.length === 0) {
			emptyState.classList.add('visible');
			return;
		}

		emptyState.classList.remove('visible');
		filtered.forEach(function (record) {
			tbody.insertAdjacentHTML('beforeend', buildDisposalRow(record));
		});
	}

	function updateActiveTab(tab) {
		currentTab = tab === 'disposal' ? 'disposal' : 'history';

		var tabLinks = document.querySelectorAll('.tab-link');
		for (var i = 0; i < tabLinks.length; i += 1) {
			var linkTab = tabLinks[i].getAttribute('data-tab');
			if (linkTab === currentTab) {
				tabLinks[i].classList.add('active');
			} else {
				tabLinks[i].classList.remove('active');
			}
		}

		document.getElementById('historyPanel').classList.toggle('active', currentTab === 'history');
		document.getElementById('disposalPanel').classList.toggle('active', currentTab === 'disposal');
		syncItemOptions();
		sessionStorage.setItem('branchStockChangeTab', currentTab);
	}

	function normalizeFilterDates() {
		var startDate = document.getElementById('filterStartDate');
		var endDate = document.getElementById('filterEndDate');
		if (!startDate.value) {
			startDate.value = defaultStartDate;
		}
		if (!endDate.value) {
			endDate.value = defaultEndDate;
		}
	}

	async function loadTabData(tab) {
		var filters = getActiveFilters();
		var url = contextPath + '/api/branch/stock/stock_change?tab=' + encodeURIComponent(tab) + '&category=' + encodeURIComponent(filters.category || '') + '&item=' + encodeURIComponent(filters.item || '') + '&startDate=' + encodeURIComponent(filters.startDate || '') + '&endDate=' + encodeURIComponent(filters.endDate || '');

		try {
			var response = await fetch(url, { headers: { 'Accept': 'application/json' } });
			if (!response.ok) {
				throw new Error('HTTP ' + response.status);
			}

			var data = normalizeResponse(await response.json());
			if (tab === 'history') {
				historyData = data;
				historyLoaded = true;
				renderHistory();
			} else {
				disposalData = data;
				disposalLoaded = true;
				renderDisposal();
			}
			syncItemOptions();
		} catch (error) {
			if (tab === 'history') {
				historyLoaded = true;
				historyData = [];
				renderHistory();
			} else {
				disposalLoaded = true;
				disposalData = [];
				renderDisposal();
			}
			syncItemOptions();
		}
	}

	window.applyFilters = async function () {
		normalizeFilterDates();
		if (currentTab === 'history') {
			await loadTabData('history');
			return;
		}
		await loadTabData('disposal');
	};

	window.resetFilters = async function () {
		document.getElementById('categoryFilter').value = '';
		itemFilter.value = '';
		document.getElementById('filterStartDate').value = defaultStartDate;
		document.getElementById('filterEndDate').value = defaultEndDate;
		if (currentTab === 'history') {
			await loadTabData('history');
			return;
		}
		await loadTabData('disposal');
	};

	var tabLinks = document.querySelectorAll('.tab-link');
	for (var i = 0; i < tabLinks.length; i += 1) {
		tabLinks[i].addEventListener('click', function (event) {
			event.preventDefault();
			var nextTab = this.getAttribute('data-tab') || 'history';
			updateActiveTab(nextTab);
			if (nextTab === 'history') {
				if (!historyLoaded) {
					loadTabData('history');
				} else {
					renderHistory();
				}
			} else {
				if (!disposalLoaded) {
					loadTabData('disposal');
				} else {
					renderDisposal();
				}
			}
		});
	}

	var storedTab = '';
	try {
		storedTab = sessionStorage.getItem('branchStockChangeTab') || '';
	} catch (error) {
		storedTab = '';
	}
	updateActiveTab(storedTab || initialTab);
	if (!historyLoaded) {
		loadTabData('history');
	}
	if (!disposalLoaded) {
		loadTabData('disposal');
	}
})();
</script>
</body>
</html>