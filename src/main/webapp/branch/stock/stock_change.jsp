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
		.filter-line { display: grid; grid-template-columns: 1.1fr 1.1fr 1.8fr; gap: 16px; }
		.field label { display: block; font-size: 14px; font-weight: 700; color: #374151; margin-bottom: 8px; }
		.field select, .field input[type="date"] { width: 100%; box-sizing: border-box; height: 40px; border: 1px solid #d5dae4; border-radius: 10px; padding: 0 14px; font-size: 14px; color: #111827; background: #fff; }
		.date-range { display: flex; align-items: center; gap: 8px; }
		.date-range input { flex: 1; }
		.date-range span { color: #6b7280; flex-shrink: 0; }
		.filter-actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 14px; }
		.filter-btn { height: 40px; padding: 0 18px; border: 0; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; }
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
		.panel-head { padding: 16px 18px; border-bottom: 1px solid #eef2f7; }
		.panel-title { margin: 0; font-size: 18px; font-weight: 700; color: #111827; }
		.panel-sub { margin: 6px 0 0; font-size: 13px; color: #6b7280; }

		.table-wrap { overflow-x: auto; }
		table { width: 100%; border-collapse: collapse; }
		th, td { padding: 12px 14px; border-bottom: 1px solid #f1f5f9; text-align: left; font-size: 13px; }
		th { background: #f8fafc; color: #374151; font-weight: 700; }
		.center { text-align: center; }

		.badge { display: inline-block; padding: 3px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; }
		.badge-INBOUND  { background: #dcfce7; color: #166534; }
		.badge-OUTBOUND { background: #dbeafe; color: #1d4ed8; }
		.badge-DISPOSAL { background: #fee2e2; color: #b91c1c; }
		.badge-ADJUST   { background: #fef3c7; color: #b45309; }
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

		/* 페이징 */
		.paging-wrap { display: flex; justify-content: center; align-items: center; gap: 4px; padding: 14px; }
		.page-btn { min-width: 32px; height: 32px; padding: 0 8px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fff; color: #374151; font-size: 13px; font-weight: 500; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; }
		.page-btn:hover { background: #f3f4f6; }
		.page-btn.active { background: #00853d; color: #fff; border-color: #00853d; }
		.page-btn:disabled { background: #f9fafb; color: #d1d5db; cursor: not-allowed; }
		.page-info { font-size: 12px; color: #6b7280; margin: 0 8px; }

		@media (max-width: 1000px) { .filter-line { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
		@media (max-width: 640px)  { .filter-line { grid-template-columns: 1fr; } .tabs { grid-template-columns: 1fr; } .tab-link { height: 46px; } }
	</style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
<%
	LocalDate today = LocalDate.now();
	String defaultStartDate = today.withDayOfMonth(1).toString();
	String defaultEndDate   = today.withDayOfMonth(today.lengthOfMonth()).toString();
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
		<p class="page-sub">재고 이력과 폐기 처리 내역을 확인합니다.</p>
	</div>

	<div class="filter-card">
		<div class="filter-line">
			<div class="field">
				<label for="categoryFilter">카테고리</label>
				<select id="categoryFilter" onchange="onCategoryChange()">
					<option value="">전체</option>
				</select>
			</div>
			<div class="field">
				<label for="itemFilter">품목명</label>
				<select id="itemFilter">
					<option value="">전체</option>
				</select>
			</div>
			<div class="field">
				<label>일자 범위</label>
				<div class="date-range">
					<input type="date" id="filterStartDate" value="<%= defaultStartDate %>">
					<span>~</span>
					<input type="date" id="filterEndDate" value="<%= defaultEndDate %>">
				</div>
			</div>
		</div>
		<div class="filter-actions">
			<button type="button" class="filter-btn primary"    onclick="applyFilters()">조회하기</button>
			<button type="button" class="filter-btn secondary"  onclick="resetFilters()">초기화</button>
		</div>
	</div>

	<div class="table-card">
		<div class="tabs">
			<button class="tab-link active"    data-tab="history"  onclick="switchTab('history')">변동 이력</button>
			<button class="tab-link disposal"  data-tab="disposal" onclick="switchTab('disposal')">폐기 내역</button>
		</div>

		<!-- 변동 이력 탭 -->
		<div id="historyPanel" class="tab-panel active">
			<div class="panel">
				<div class="panel-head">
					<h2 class="panel-title">재고 변동 이력</h2>
					<p class="panel-sub">입고, 출고, 조정, 폐기 등 재고 변동 내역입니다.</p>
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
					<div id="historyEmptyState" class="empty-state">조회 결과가 없습니다.</div>
					<div class="paging-wrap" id="historyPaging" style="display:none;"></div>
				</div>
			</div>
		</div>

		<!-- 폐기 내역 탭 -->
		<div id="disposalPanel" class="tab-panel">
			<div class="disposal-banner">
				<div>
					<h2 class="disposal-title">재고 폐기 내역</h2>
					<p class="disposal-text">유통기한 만료, 품질 불량, 파손 등으로 폐기된 품목 내역입니다.</p>
				</div>
			</div>
			<div class="panel">
				<div class="panel-head">
					<h2 class="panel-title">폐기 처리 내역</h2>
					<p class="panel-sub">폐기 등록은 재고 현황 페이지에서 처리할 수 있습니다.</p>
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
					<div id="disposalEmptyState" class="empty-state">조회 결과가 없습니다.</div>
					<div class="paging-wrap" id="disposalPaging" style="display:none;"></div>
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
	var contextPath    = '<%= request.getContextPath() %>';
	var defaultStartDate = '<%= defaultStartDate %>';
	var defaultEndDate   = '<%= defaultEndDate %>';
	var currentTab     = 'history';
	var historyPage    = 1;
	var disposalPage   = 1;

	/* ── 유틸 ── */
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
			+ 'tab='             + encodeURIComponent(tab)
			+ '&materialGroupId='+ encodeURIComponent(materialGroupId)
			+ '&materialName='   + encodeURIComponent(materialName)
			+ '&startDate='      + encodeURIComponent(startDate)
			+ '&endDate='        + encodeURIComponent(endDate)
			+ '&page='           + p;

		fetch(url, { headers: { 'Accept': 'application/json' } })
			.then(function (res) { return res.json(); })
			.then(function (data) {
				if (tab === 'history') {
					renderHistory(data.list);
					renderPaging('historyPaging', data.totalCount, data.page, data.totalPages, 'history');
				} else {
					renderDisposal(data.list);
					renderPaging('disposalPaging', data.totalCount, data.page, data.totalPages, 'disposal');
				}
			})
			.catch(function () {
				alert('데이터를 불러오지 못했습니다.');
			});
	}

	/* ── 폐기 사유 한글 변환 ── */
	function getReasonLabel(reason) {
		var map = { 'EXPIRED': '유통기한 만료', 'DAMAGED': '파손', 'ETC': '기타' };
		return map[reason] || reason;
	}

	/* ── 변동 유형 한글 변환 ── */
	function getChangeTypeLabel(type) {
		var map = { 'INBOUND': '입고', 'OUTBOUND': '출고', 'DISPOSAL': '폐기', 'ADJUST': '조정' };
		return map[type] || type;
	}

	/* ── 변동 이력 렌더링 ── */
	function renderHistory(list) {
		var tbody  = document.getElementById('historyTableBody');
		var empty  = document.getElementById('historyEmptyState');
		tbody.innerHTML = '';
		if (!list || !list.length) { empty.classList.add('visible'); return; }
		empty.classList.remove('visible');
		list.forEach(function (r) {
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
		var tbody = document.getElementById('disposalTableBody');
		var empty = document.getElementById('disposalEmptyState');
		tbody.innerHTML = '';
		if (!list || !list.length) { empty.classList.add('visible'); return; }
		empty.classList.remove('visible');
		list.forEach(function (r) {
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
		if (!total || total <= 1) { wrap.style.display = 'none'; return; }
		wrap.style.display = 'flex';

		var html = '';
		html += '<button class="page-btn" onclick="loadTabData(\'' + tab + '\',' + (page - 1) + ')"' + (page <= 1 ? ' disabled' : '') + '>＜</button>';

		var startPage = Math.max(1, page - 2);
		var endPage   = Math.min(total, startPage + 4);
		if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);

		for (var i = startPage; i <= endPage; i++) {
			html += '<button class="page-btn' + (i === page ? ' active' : '') + '" onclick="loadTabData(\'' + tab + '\',' + i + ')">' + i + '</button>';
		}
		html += '<button class="page-btn" onclick="loadTabData(\'' + tab + '\',' + (page + 1) + ')"' + (page >= total ? ' disabled' : '') + '>＞</button>';
		html += '<span class="page-info">총 ' + totalCount + '건</span>';
		wrap.innerHTML = html;
	}

	/* ── 필터 ── */
	window.applyFilters  = function () { loadTabData(currentTab, 1); };
	window.loadTabData   = loadTabData;

	window.resetFilters = function () {
		document.getElementById('categoryFilter').value = '';
		document.getElementById('itemFilter').innerHTML = '<option value="">전체</option>';
		document.getElementById('filterStartDate').value = defaultStartDate;
		document.getElementById('filterEndDate').value   = defaultEndDate;
		loadTabData(currentTab, 1);
	};

	/* ── 초기 실행 ── */
	loadCategoryList();
	loadTabData('history', 1);
})();
</script>
</body>
</html>
