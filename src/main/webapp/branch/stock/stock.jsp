<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>재고 현황</title>
    <style>
        .wrap { width: 100%; max-width: none; margin: 0; }
        .page-header { margin-bottom: 20px; }
        .page-title { margin: 0; font-size: 28px; font-weight: 700; color: #111827; }
        .page-sub { margin: 8px 0 0; color: #6b7280; font-size: 14px; }

        .filter-card { background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; padding: 14px; margin-bottom: 16px; }
        .filters { display: grid; grid-template-columns: 1fr 1fr 1.2fr auto; gap: 10px; }
        .filter-input, .filter-select { width: 100%; box-sizing: border-box; padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 8px; font-size: 13px; background: #fff; }
        .btn { border: 0; border-radius: 8px; padding: 0 14px; font-size: 13px; font-weight: 700; cursor: pointer; }
        .btn-primary { background: #00853d; color: #fff; }
        .btn-muted { background: #eef2f7; color: #374151; }

        /* ── 핵심: 그리드 아이템은 왼쪽래퍼 + 상세패널 2개만 ── */
        .stock-layout { display: grid; grid-template-columns: 1fr; gap: 14px; align-items: start; }
        .stock-layout.panel-open { grid-template-columns: 1fr 360px; }

        .panel { background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; min-width: 0; }
        .panel-head { padding: 14px 14px 10px; border-bottom: 1px solid #eef2f7; }
        .panel-title { margin: 0; font-size: 17px; font-weight: 800; color: #111827; }
        .panel-sub { margin: 6px 0 0; font-size: 12px; color: #6b7280; }
        .sort-row { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 10px; }
        .sort-btn { border: 1px solid #d1d5db; background: #fff; color: #374151; border-radius: 999px; padding: 6px 10px; font-size: 12px; font-weight: 700; cursor: pointer; }
        .sort-btn.active { border-color: #1d4ed8; background: #dbeafe; color: #1e40af; }

        .table-wrap { overflow-x: auto; -webkit-overflow-scrolling: touch; }
        table { width: 100%; border-collapse: collapse; table-layout: fixed; }
        colgroup col:nth-child(1) { width: 160px; }
        colgroup col:nth-child(2) { width: 80px; }
        colgroup col:nth-child(3) { width: 130px; }
        colgroup col:nth-child(4) { width: 100px; }
        colgroup col:nth-child(5) { width: 160px; }
        colgroup col:nth-child(6) { width: 95px; }
        colgroup col:nth-child(7) { width: 65px; }
        th, td { padding: 10px 12px; border-bottom: 1px solid #eef2f7; text-align: center; font-size: 13px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        th { background: #f8fafc; color: #374151; font-weight: 700; }
        tbody tr { cursor: pointer; transition: background 0.1s; }
        tbody tr:hover td { background: #f8fafc; }

        tr.row-expired td { background: #fecaca; }
        tr.row-expired:hover td { background: #fca5a5; }
        tr.row-expired.row-sel td { background: #f87171 !important; }
        tr.row-urgent td { background: #fff1f1; }
        tr.row-urgent:hover td { background: #ffe4e4; }
        tr.row-urgent.row-sel td { background: #ffd7d7 !important; }
        tr.row-warn td { background: #fffbeb; }
        tr.row-warn:hover td { background: #fef3c7; }
        tr.row-warn.row-sel td { background: #fde68a44 !important; }
        tr.row-sel td { background: #f0fdf4 !important; }

        .badge { display: inline-block; padding: 3px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; }
        .badge-urgent   { background: #fee2e2; color: #b91c1c; }
        .badge-warn     { background: #ffedd5; color: #c2410c; }
        .badge-safe     { background: #dcfce7; color: #166534; }
        .badge-expired  { background: #f55656; color: #991b1b; }
        .badge-disposal { background: #f1f5f9; color: #475569; }
        .badge-lack     { background: #fee2e2; color: #b91c1c; }
        .badge-caution  { background: #fef3c7; color: #92400e; }
        .badge-ok       { background: #dcfce7; color: #166534; }
        .badge-unset    { background: #f1f5f9; color: #6b7280; }

        .empty { padding: 24px 14px; text-align: center; color: #6b7280; font-size: 13px; }

        /* 페이징 */
        #pagingWrap { display: none; justify-content: center; padding: 16px 14px; }
        
        .detail-panel { display: none; background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; flex-direction: column; position: sticky; top: 16px; max-height: calc(100vh - 80px); min-width: 0; }
        .detail-panel.open { display: flex; }
        .dp-head { padding: 14px 16px; border-bottom: 1px solid #eef2f7; display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .dp-name { font-size: 16px; font-weight: 800; color: #111827; }
        .dp-cat  { font-size: 12px; color: #6b7280; margin-top: 2px; }
        .dp-close { background: none; border: none; font-size: 20px; color: #9ca3af; cursor: pointer; padding: 2px 6px; border-radius: 4px; line-height: 1; }
        .dp-close:hover { background: #f3f4f6; }
        .dp-summary { padding: 14px 16px; background: #f8fafc; border-bottom: 1px solid #eef2f7; flex-shrink: 0; }
        .dp-total-box { background: #fff; border: 1px solid #e5e7eb; border-radius: 8px; padding: 10px 12px; margin-bottom: 8px; }
        .dp-total-label { font-size: 11px; color: #6b7280; }
        .dp-total-val   { font-size: 18px; font-weight: 800; color: #111827; margin-top: 2px; }
        .dp-total-sub   { font-size: 11px; color: #16a34a; margin-top: 2px; }
        .dp-total-sub.has-expired { color: #dc2626; }
        .dp-ratio-box { background: #fff; border: 1px solid #e5e7eb; border-radius: 8px; padding: 10px 12px; }
        .dp-ratio-label { font-size: 11px; color: #6b7280; margin-bottom: 7px; }
        .dp-ratio-row { display: flex; align-items: center; gap: 8px; }
        .dp-prog-bg { flex: 1; height: 6px; background: #e5e7eb; border-radius: 3px; overflow: hidden; }
        .dp-prog-fill { height: 6px; border-radius: 3px; transition: width 0.3s; }
        .dp-ratio-pct { font-size: 13px; font-weight: 700; min-width: 38px; text-align: right; }
        .dp-body { padding: 14px 16px; flex: 1; overflow-y: auto; min-height: 0; display: flex; flex-direction: column; gap: 8px; }
        .dp-sec-title { font-size: 11px; font-weight: 700; color: #6b7280; padding: 4px 10px; background: #f1f5f9; border-radius: 6px; display: inline-block; margin-bottom: 2px; }
        .dp-sec-title.disposal { color: #fff; background: #dc2626; }
        .sec-divider { border: none; border-top: 3px solid #dc2626; margin: 6px 0; }

        .lot-card { border: 1px solid #e5e7eb; border-radius: 10px; padding: 12px 14px; }
        .lot-card.lot-urgent  { border-color: #fca5a5; background: #fff8f8; }
        .lot-card.lot-warn    { border-color: #fde68a; background: #fffdf0; }
        .lot-card.lot-sel     { border-color: #00853d; border-width: 2px; }
        .lot-card.lot-expired { border-color: #e2e8f0; background: #f8fafc; }
        .lot-no   { font-size: 10px; color: #9ca3af; margin-bottom: 6px; font-family: monospace; }
        .lot-main { display: flex; justify-content: space-between; align-items: center; }
        .lot-qty  { font-size: 15px; font-weight: 700; color: #111827; }
        .lot-expired .lot-qty { color: #94a3b8; text-decoration: line-through; }
        .lot-bottom { margin-top: 6px; display: flex; justify-content: space-between; align-items: center; }
        .lot-date  { font-size: 11px; color: #9ca3af; }
        .lot-days-r { font-size: 11px; color: #dc2626; font-weight: 700; }
        .lot-days-a { font-size: 11px; color: #d97706; font-weight: 700; }
        .lot-days-g { font-size: 11px; color: #9ca3af; }
        .lot-action { margin-top: 10px; display: flex; justify-content: flex-end; }
        .btn-disposal         { border: 0; border-radius: 6px; padding: 5px 12px; font-size: 11px; font-weight: 700; cursor: pointer; background: #fee2e2; color: #b91c1c; }
        .btn-disposal:hover   { background: #fecaca; }
        .btn-disposal-outline { border: 1px solid #d1d5db; border-radius: 6px; padding: 5px 12px; font-size: 11px; font-weight: 700; cursor: pointer; background: #fff; color: #374151; }
        .btn-disposal-outline:hover { background: #f3f4f6; }
        .disposal-banner { padding: 8px 12px; background: #fff1f0; border: 1px solid #fca5a5; border-radius: 8px; }
        .disposal-banner-title { font-size: 12px; font-weight: 700; color: #991b1b; }
        .disposal-banner-sub   { font-size: 11px; color: #b91c1c; margin-top: 2px; }

        .modal-backdrop { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 50; align-items: center; justify-content: center; padding: 16px; }
        .modal-backdrop.open { display: flex; }
        .modal-box { background: #fff; border-radius: 12px; width: 100%; max-width: 480px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.15); }
        .modal-head { padding: 16px 18px; border-bottom: 1px solid #eef2f7; display: flex; align-items: center; justify-content: space-between; }
        .modal-title { font-size: 16px; font-weight: 800; color: #111827; }
        .modal-close { background: none; border: none; font-size: 20px; color: #9ca3af; cursor: pointer; padding: 2px 6px; border-radius: 4px; line-height: 1; }
        .modal-close:hover { background: #f3f4f6; }
        .modal-body { padding: 18px; }
        .modal-foot { padding: 12px 18px; border-top: 1px solid #eef2f7; display: flex; justify-content: flex-end; gap: 8px; }
        .warn-banner { background: #fff1f0; border: 1px solid #fca5a5; border-radius: 8px; padding: 10px 14px; margin-bottom: 16px; }
        .warn-banner-title { font-size: 12px; font-weight: 700; color: #991b1b; }
        .warn-banner-sub   { font-size: 11px; color: #b91c1c; margin-top: 3px; }
        .info-box { background: #f8fafc; border: 1px solid #e5e7eb; border-radius: 8px; padding: 12px 14px; margin-bottom: 16px; display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; }
        .info-item .il { font-size: 11px; color: #6b7280; }
        .info-item .iv { font-size: 13px; font-weight: 700; color: #111827; margin-top: 2px; }
        .mfield { margin-bottom: 12px; }
        .mfield label { display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px; }
        .mfield input, .mfield select, .mfield textarea { width: 100%; box-sizing: border-box; padding: 9px 12px; border: 1px solid #d1d5db; border-radius: 8px; font-size: 13px; background: #fff; color: #111827; }
        .mfield input[readonly], .mfield select[disabled] { background: #f3f4f6; color: #6b7280; cursor: not-allowed; }
        .mfield textarea { resize: vertical; min-height: 72px; font-family: inherit; }
        .mfield-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .mbtn { height: 36px; padding: 0 18px; border: 0; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; }
        .mbtn-cancel { background: #eef2f7; color: #374151; }
        .mbtn-danger { background: #dc2626; color: #fff; }

        @media (max-width: 900px) { .filters { grid-template-columns: 1fr 1fr; } }
        @media (max-width: 640px) { .filters { grid-template-columns: 1fr; } .btn { height: 38px; } }
    </style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
</head>
<body>
	<div class="zl-app">
		<%@ include file="/branch/common/layout/sidebar.jsp"%>
		<div class="zl-content">
			<div class="wrap p-6">
				<div class="page-header">
					<h1 class="page-title">재고 현황</h1>
					<p class="page-sub">유통기한 임박 시 행이 강조됩니다. 품목 클릭 시 우측에서 상세를 확인하세요.</p>
				</div>

				<div class="filter-card">
					<div class="filters">
						<select id="categoryFilter" class="filter-select"
							onchange="onCategoryChange()">
							<option value="">카테고리 전체</option>
						</select> <select id="itemFilter" class="filter-select"
							onchange="applyFilters()">
							<option value="">품목명 전체</option>
						</select> <input id="searchInput" class="filter-input" type="text"
							placeholder="재고 번호 또는 품목명 검색" />
						<div style="display: flex; gap: 8px;">
							<button type="button" class="btn btn-primary"
								onclick="applyFilters()">조회하기</button>
							<button type="button" class="btn btn-muted"
								onclick="resetFilters()">초기화</button>
						</div>
					</div>
				</div>

				<div class="stock-layout" id="stockLayout">

					<!-- ★ 왼쪽 래퍼: 테이블 패널 + 페이징을 하나로 묶음 -->
					<div>
						<div class="panel">
							<div class="panel-head">
								<h2 class="panel-title">재고 목록</h2>
								<p class="panel-sub">유통기한 임박 행 강조 · 품목 클릭 시 우측에서 상세 확인</p>
								<div class="sort-row">
									<button type="button" id="sortReceivedBtn"
										class="sort-btn active" onclick="onSortClick('receivedAt')">입고
										시점 오름차순</button>
									<button type="button" id="sortExpireBtn" class="sort-btn"
										onclick="onSortClick('expireDate')">유통기한 오름차순</button>
								</div>
							</div>
							<div class="table-wrap">
								<table>
									<colgroup>
										<col>
										<col>
										<col>
										<col>
										<col>
										<col>
										<col>
									</colgroup>
									<thead>
										<tr>
											<th>재고 번호</th>
											<th>카테고리</th>
											<th>품목명</th>
											<th>입고 시점</th>
											<th>유통기한</th>
											<th>현재 수량</th>
											<th>상태</th>
										</tr>
									</thead>
									<tbody id="stockTableBody"></tbody>
								</table>
								<div id="stockEmpty" class="empty" style="display: none;">조회
									결과가 없습니다.</div>
							</div>
						</div>
						<!-- ★ 페이징: panel 바깥, 왼쪽 래퍼 안 -->
						<div id="pagingWrap"></div>
					</div>

					<!-- ★ 오른쪽: 상세 패널 -->
					<div class="detail-panel" id="detailPanel">
						<div class="dp-head">
							<div>
								<div class="dp-name" id="dpName">-</div>
								<div class="dp-cat" id="dpCat">-</div>
							</div>
							<button class="dp-close" onclick="closePanel()">✕</button>
						</div>
						<div class="dp-summary">
							<div class="dp-total-box">
								<div class="dp-total-label">유효 재고 합산 수량</div>
								<div class="dp-total-val" id="dpTotal">-</div>
								<div class="dp-total-sub" id="dpTotalSub"></div>
							</div>
							<div class="dp-ratio-box">
								<div class="dp-ratio-label">
									안전재고 대비 비율 · 안전재고 <span id="dpSaf">-</span>
								</div>
								<div class="dp-ratio-row">
									<div class="dp-prog-bg">
										<div class="dp-prog-fill" id="dpProgFill" style="width: 0%"></div>
									</div>
									<div class="dp-ratio-pct" id="dpPct">-</div>
									<span class="badge" id="dpBadge">-</span>
								</div>
							</div>
						</div>
						<div class="dp-body" id="dpBody"></div>
					</div>

				</div>
			</div>
		</div>
	</div>

	<div class="modal-backdrop" id="disposalModal"
		onclick="onBackdropClick(event)">
		<div class="modal-box">
			<div class="modal-head">
				<span class="modal-title">폐기 등록</span>
				<button class="modal-close" onclick="closeDisposalModal()">✕</button>
			</div>
			<div class="modal-body" id="modalBody"></div>
			<div class="modal-foot">
				<button class="mbtn mbtn-cancel" onclick="closeDisposalModal()">취소</button>
				<button class="mbtn mbtn-danger" onclick="submitDisposal()">폐기
					등록</button>
			</div>
		</div>
	</div>

	<script>
	(function () {
	    var TODAY = new Date();
	    TODAY.setHours(0, 0, 0, 0);
	    var contextPath = '<%=request.getContextPath()%>';
	
	    var stockData           = [];
	    var filteredData        = [];
	    var currentPage         = 1;
	    var totalPages          = 1;
	    var selectedStockNo     = null;
	    var currentModalStockNo = null;
	    var sortState           = { field: 'receivedAt', direction: 'asc' };
	
	    function daysUntil(dateStr) {
	        var d = new Date(dateStr); d.setHours(0, 0, 0, 0);
	        return Math.ceil((d - TODAY) / 86400000);
	    }
	    function isExpired(dateStr) { return daysUntil(dateStr) <= 0; }
	
	    function getExpiryStatus(dateStr) {
	        var d = daysUntil(dateStr);
	        if (d <= 0) return { label: '만료', cls: 'badge-expired', rowCls: 'row-expired', lotCls: 'lot-urgent' };
	        if (d <= 1) return { label: '긴급', cls: 'badge-urgent',  rowCls: 'row-urgent',  lotCls: 'lot-urgent' };
	        if (d <= 3) return { label: '경고', cls: 'badge-warn',    rowCls: 'row-warn',    lotCls: 'lot-warn'   };
	        return             { label: '정상', cls: 'badge-safe',    rowCls: '',            lotCls: ''           };
	    }
	
	    function getSafetyStatus(validQty, safetyQty) {
	        if (!safetyQty) return { label: '미설정', cls: 'badge-unset', color: '#94a3b8' };
	        var r = validQty / safetyQty;
	        if (r < 0.7) return { label: '부족', cls: 'badge-lack',    color: '#dc2626' };
	        if (r < 1.0) return { label: '경고', cls: 'badge-caution', color: '#d97706' };
	        return               { label: '정상', cls: 'badge-ok',      color: '#16a34a' };
	    }
	
	    function escapeHtml(v) {
	        return String(v == null ? '' : v)
	            .replace(/&/g,'&amp;').replace(/</g,'&lt;')
	            .replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
	    }
	
	    function syncSortButtons() {
	        var rBtn = document.getElementById('sortReceivedBtn');
	        var eBtn = document.getElementById('sortExpireBtn');
	        rBtn.textContent = '입고 시점 ' + (sortState.field === 'receivedAt' ? (sortState.direction === 'asc' ? '오름차순' : '내림차순') : '오름차순');
	        eBtn.textContent = '유통기한 ' + (sortState.field === 'expireDate'  ? (sortState.direction === 'asc' ? '오름차순' : '내림차순') : '오름차순');
	        rBtn.classList.toggle('active', sortState.field === 'receivedAt');
	        eBtn.classList.toggle('active', sortState.field === 'expireDate');
	    }
	
	    window.onSortClick = function (field) {
	        if (sortState.field === field) { sortState.direction = sortState.direction === 'asc' ? 'desc' : 'asc'; }
	        else { sortState.field = field; sortState.direction = 'asc'; }
	        syncSortButtons();
	        loadStockList(1);
	    };
	
	    function loadCategoryList() {
	        fetch(contextPath + '/branch/stock/categories')
	            .then(function (res) { return res.json(); })
	            .then(function (data) {
	                var el = document.getElementById('categoryFilter');
	                el.innerHTML = '<option value="">카테고리 전체</option>';
	                data.forEach(function (item) {
	                    el.insertAdjacentHTML('beforeend',
	                        '<option value="' + escapeHtml(item.materialGroupId) + '">' + escapeHtml(item.groupName) + '</option>');
	                });
	            })
	            .catch(function () { alert('카테고리 목록을 불러오지 못했습니다.'); });
	    }
	
	    window.onCategoryChange = function () {
	        var materialGroupId = document.getElementById('categoryFilter').value;
	        var sel = document.getElementById('itemFilter');
	        sel.innerHTML = '<option value="">품목명 전체</option>';
	        if (!materialGroupId) { loadStockList(1); return; }
	        fetch(contextPath + '/branch/stock/materials?materialGroupId=' + encodeURIComponent(materialGroupId))
	            .then(function (res) { return res.json(); })
	            .then(function (data) {
	                data.forEach(function (item) {
	                    sel.insertAdjacentHTML('beforeend',
	                        '<option value="' + escapeHtml(item.materialName) + '">' + escapeHtml(item.materialName) + '</option>');
	                });
	                loadStockList(1);
	            })
	            .catch(function () { alert('품목 목록을 불러오지 못했습니다.'); });
	    };
	
	    function loadStockList(page) {
	        currentPage = page || 1;
	        var materialGroupId = document.getElementById('categoryFilter').value;
	        var materialName    = document.getElementById('itemFilter').value;
	        var keyword         = document.getElementById('searchInput').value.trim();
	
	        var url = contextPath + '/branch/stock/status?'
	            + 'materialGroupId=' + encodeURIComponent(materialGroupId)
	            + '&materialName='   + encodeURIComponent(materialName)
	            + '&keyword='        + encodeURIComponent(keyword)
	            + '&page='           + currentPage
	            + '&sortField='      + sortState.field
	            + '&sortDir='        + sortState.direction;
	
	        fetch(url)
	            .then(function (res) { return res.json(); })
	            .then(function (data) {
	                stockData    = data.list;
	                filteredData = data.list;
	                totalPages   = data.totalPages;
	                renderTable();
	                renderPaging(data.totalCount, data.page, data.totalPages);
	            })
	            .catch(function () { alert('재고 목록을 불러오지 못했습니다.'); });
	    }
	
	    window.applyFilters  = function () { loadStockList(1); };
	    window.loadStockList = loadStockList;
	
	    window.resetFilters = function () {
	        document.getElementById('categoryFilter').value = '';
	        document.getElementById('itemFilter').innerHTML = '<option value="">품목명 전체</option>';
	        document.getElementById('searchInput').value = '';
	        sortState = { field: 'receivedAt', direction: 'asc' };
	        syncSortButtons();
	        selectedStockNo = null;
	        closePanel();
	        loadStockList(1);
	    };
	
	    function renderTable() {
	        var tbody = document.getElementById('stockTableBody');
	        var empty = document.getElementById('stockEmpty');
	        tbody.innerHTML = '';
	        if (!filteredData.length) { empty.style.display = 'block'; return; }
	        empty.style.display = 'none';
	        filteredData.forEach(function (row) {
	            var es     = getExpiryStatus(row.expireDate);
	            var d      = daysUntil(row.expireDate);
	            var dayTxt = d <= 0 ? '만료 ' + Math.abs(d) + '일' : d + '일 남음';
	            var isSel  = selectedStockNo === row.branchStockCode;
	            tbody.insertAdjacentHTML('beforeend',
	                '<tr class="' + es.rowCls + (isSel ? ' row-sel' : '') + '" onclick="selectStock(\'' + escapeHtml(row.branchStockCode) + '\')">' +
	                    '<td style="font-family:monospace;font-size:12px">' + escapeHtml(row.branchStockCode) + '</td>' +
	                    '<td style="color:#6b7280;font-size:12px">'         + escapeHtml(row.groupName)       + '</td>' +
	                    '<td style="font-weight:700">'                       + escapeHtml(row.materialName)    + '</td>' +
	                    '<td style="color:#6b7280;font-size:12px">'         + escapeHtml(row.receivedAt)      + '</td>' +
	                    '<td><strong>' + escapeHtml(row.expireDate) + '</strong> <span style="font-size:11px;opacity:.75">(' + escapeHtml(dayTxt) + ')</span></td>' +
	                    '<td><strong>' + escapeHtml(row.currentQty + ' ' + row.unit) + '</strong></td>' +
	                    '<td><span class="badge ' + es.cls + '">' + es.label + '</span></td>' +
	                '</tr>'
	            );
	        });
	    }
	
	    function renderPaging(totalCount, page, total) {
	        var wrap = document.getElementById('pagingWrap');
	        if (total <= 1) { wrap.style.display = 'none'; return; }
	        wrap.style.display = 'flex';
	
	        var PAGE_SIZE  = 5;
	        var blockStart = Math.floor((page - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
	        var blockEnd   = Math.min(blockStart + PAGE_SIZE - 1, total);
	
	        var base   = 'w-8 h-8 flex items-center justify-center border rounded-lg text-sm hover:bg-gray-100';
	        var active = 'w-8 h-8 flex items-center justify-center border rounded-lg text-sm bg-[#00853D] text-white font-bold';
	        var arrow  = 'w-8 h-8 flex items-center justify-center border rounded-lg hover:bg-gray-100';
	
	        var html = '<div class="flex justify-center items-center gap-1">';
	
	     	// 맨 첫 페이지
	      html += '<button class="' + arrow + '" onclick="loadStockList(1)"><i class="fas fa-angles-left text-xs"></i></button>';
	
	        // 이전 블록
	        html += '<button class="' + arrow + '" onclick="loadStockList(' + (blockStart - 1) + ')"><i class="fas fa-chevron-left text-xs"></i></button>';
	
	        // 페이지 번호
	        for (var i = blockStart; i <= blockEnd; i++) {
	            html += '<button class="' + (i === page ? active : base) + '" onclick="loadStockList(' + i + ')">' + i + '</button>';
	        }
	
	        // 다음 블록
	        html += '<button class="' + arrow + '" onclick="loadStockList(' + (blockEnd + 1) + ')"><i class="fas fa-chevron-right text-xs"></i></button>';
	
	    	// 맨 마지막 페이지
	        html += '<button class="' + arrow + '" onclick="loadStockList(' + total + ')"><i class="fas fa-angles-right text-xs"></i></button>';
	
	        html += '</div>';
	        wrap.innerHTML = html;
	    }
	
	    window.selectStock = function (branchStockCode) {
	        if (selectedStockNo === branchStockCode) { closePanel(); return; }
	        selectedStockNo = branchStockCode;
	
	        var clicked     = stockData.find(function (x) { return x.branchStockCode === branchStockCode; });
	        if (!clicked) return;
	
	        var sameName    = stockData.filter(function (x) { return x.materialName === clicked.materialName; });
	        var validList   = sameName.filter(function (x) { return !isExpired(x.expireDate); });
	        var expiredList = sameName.filter(function (x) { return  isExpired(x.expireDate); });
	        var validQty    = validList.reduce(function (a, b) { return a + parseInt(b.currentQty); }, 0);
	        var expiredQty  = expiredList.reduce(function (a, b) { return a + parseInt(b.currentQty); }, 0);
	        var safetyQty   = clicked.safeStockQty;
	        var st          = getSafetyStatus(validQty, safetyQty);
	        var pct         = safetyQty ? Math.min(Math.round(validQty / safetyQty * 100), 100) : 100;
	
	        document.getElementById('dpName').textContent  = clicked.materialName;
	        document.getElementById('dpCat').textContent   = clicked.groupName;
	        document.getElementById('dpTotal').textContent = validQty + ' ' + clicked.unit;
	
	        var subEl = document.getElementById('dpTotalSub');
	        if (expiredList.length) {
	            subEl.textContent = '만료 재고 ' + expiredQty + ' ' + clicked.unit + ' 제외';
	            subEl.className = 'dp-total-sub has-expired';
	        } else {
	            subEl.textContent = '유효 재고 전체 합산';
	            subEl.className = 'dp-total-sub';
	        }
	
	        document.getElementById('dpSaf').textContent           = safetyQty ? safetyQty + ' ' + clicked.unit : '미설정';
	        document.getElementById('dpProgFill').style.width      = pct + '%';
	        document.getElementById('dpProgFill').style.background = st.color;
	        document.getElementById('dpPct').textContent           = safetyQty ? Math.round(validQty / safetyQty * 100) + '%' : '-';
	        document.getElementById('dpPct').style.color           = st.color;
	        document.getElementById('dpBadge').textContent         = st.label;
	        document.getElementById('dpBadge').className           = 'badge ' + st.cls;
	
	        var html = '';
	
	        if (validList.length) {
	            html += '<div class="dp-sec-title">유효 재고 ' + validList.length + '건</div>';
	            validList.forEach(function (x) {
	                var es     = getExpiryStatus(x.expireDate);
	                var d      = daysUntil(x.expireDate);
	                var dayCls = d <= 3 ? 'lot-days-r' : d <= 7 ? 'lot-days-a' : 'lot-days-g';
	                var isCur  = x.branchStockCode === branchStockCode;
	                html +=
	                    '<div class="lot-card ' + es.lotCls + (isCur ? ' lot-sel' : '') + '">' +
	                        '<div class="lot-no">' + escapeHtml(x.branchStockCode) + (isCur ? ' · 현재 선택' : '') + '</div>' +
	                        '<div class="lot-main">' +
	                            '<span class="lot-qty">' + escapeHtml(x.currentQty + ' ' + x.unit) + '</span>' +
	                            '<span class="badge ' + es.cls + '">' + es.label + '</span>' +
	                        '</div>' +
	                        '<div class="lot-bottom">' +
	                            '<span class="lot-date">입고 ' + escapeHtml(x.receivedAt) + ' · 유통기한 ' + escapeHtml(x.expireDate) + '</span>' +
	                            '<span class="' + dayCls + '">' + d + '일 남음</span>' +
	                        '</div>' +
	                        '<div class="lot-action">' +
	                            '<button class="btn-disposal-outline" onclick="openDisposalModal(\'' + escapeHtml(x.branchStockCode) + '\', false)">폐기 등록</button>' +
	                        '</div>' +
	                    '</div>';
	            });
	        }
	
	        if (expiredList.length) {
	            html += '<hr class="sec-divider">';
	            html += '<div class="dp-sec-title disposal">폐기 필요 ' + expiredList.length + '건</div>';
	            html +=
	                '<div class="disposal-banner">' +
	                    '<div class="disposal-banner-title">폐기 처리가 필요한 재고가 있습니다.</div>' +
	                    '<div class="disposal-banner-sub">아래 폐기 등록 버튼을 눌러 처리해 주세요.</div>' +
	                '</div>';
	            expiredList.forEach(function (x) {
	                var d    = daysUntil(x.expireDate);
	                var isCur = x.branchStockCode === branchStockCode;
	                html +=
	                    '<div class="lot-card lot-expired' + (isCur ? ' lot-sel' : '') + '">' +
	                        '<div class="lot-no">' + escapeHtml(x.branchStockCode) + '</div>' +
	                        '<div class="lot-main">' +
	                            '<span class="lot-qty" style="color:#94a3b8;text-decoration:line-through">' + escapeHtml(x.currentQty + ' ' + x.unit) + '</span>' +
	                            '<span class="badge badge-disposal">폐기 필요</span>' +
	                        '</div>' +
	                        '<div class="lot-bottom">' +
	                            '<span class="lot-date">입고 ' + escapeHtml(x.receivedAt) + ' · 유통기한 ' + escapeHtml(x.expireDate) + '</span>' +
	                            '<span class="lot-days-r">' + Math.abs(d) + '일 경과</span>' +
	                        '</div>' +
	                        '<div class="lot-action">' +
	                            '<button class="btn-disposal" onclick="openDisposalModal(\'' + escapeHtml(x.branchStockCode) + '\', true)">폐기 등록</button>' +
	                        '</div>' +
	                    '</div>';
	            });
	        }
	
	        document.getElementById('dpBody').innerHTML = html;
	        document.getElementById('detailPanel').classList.add('open');
	        document.getElementById('stockLayout').classList.add('panel-open');
	        renderTable();
	    };
	
	    window.closePanel = function () {
	        selectedStockNo = null;
	        document.getElementById('detailPanel').classList.remove('open');
	        document.getElementById('stockLayout').classList.remove('panel-open');
	        renderTable();
	    };
	
	    window.openDisposalModal = function (branchStockCode, expired) {
	        var row = stockData.find(function (x) { return x.branchStockCode === branchStockCode; });
	        if (!row) return;
	        currentModalStockNo = branchStockCode;
	        var html = '';
	
	        if (expired) {
	            var d = daysUntil(row.expireDate);
	            html +=
	                '<div class="warn-banner">' +
	                    '<div class="warn-banner-title">유통기한이 만료된 재고입니다.</div>' +
	                    '<div class="warn-banner-sub">' + escapeHtml(row.branchStockCode) + ' · ' + escapeHtml(row.materialName) + ' · 만료 ' + Math.abs(d) + '일 경과 · 현재 수량 ' + escapeHtml(row.currentQty + ' ' + row.unit) + '</div>' +
	                '</div>' +
	                '<div class="mfield-row">' +
	                    '<div class="mfield"><label>재고 번호</label><input type="text" value="' + escapeHtml(row.branchStockCode) + '" readonly></div>' +
	                    '<div class="mfield"><label>품목명</label><input type="text" value="' + escapeHtml(row.materialName) + '" readonly></div>' +
	                '</div>' +
	                '<div class="mfield-row">' +
	                    '<div class="mfield"><label>폐기 수량</label><input type="text" id="mQty" value="' + escapeHtml(row.currentQty + ' ' + row.unit) + '" readonly></div>' +
	                    '<div class="mfield"><label>폐기 사유</label><select id="mReason" disabled><option value="EXPIRED">유통기한 만료</option></select></div>' +
	                '</div>' +
	                '<div class="mfield"><label>상세 내용</label><textarea id="mDetail" placeholder="추가 내용을 입력하세요"></textarea></div>';
	        } else {
	            html +=
	                '<div class="info-box">' +
	                    '<div class="info-item"><div class="il">재고 번호</div><div class="iv">' + escapeHtml(row.branchStockCode) + '</div></div>' +
	                    '<div class="info-item"><div class="il">품목명</div><div class="iv">' + escapeHtml(row.materialName) + '</div></div>' +
	                    '<div class="info-item"><div class="il">현재 수량</div><div class="iv">' + escapeHtml(row.currentQty + ' ' + row.unit) + '</div></div>' +
	                '</div>' +
	                '<div class="mfield-row">' +
	                    '<div class="mfield"><label>폐기 수량 *</label><input type="number" id="mQty" min="1" max="' + row.currentQty + '" placeholder="수량 입력"></div>' +
	                    '<div class="mfield"><label>폐기 사유 *</label>' +
	                        '<select id="mReason">' +
	                            '<option value="">선택하세요</option>' +
	                            '<option value="DAMAGED">파손</option>' +
	                            '<option value="EXPIRED">유통기한 만료</option>' +
	                            '<option value="ETC">기타</option>' +
	                        '</select>' +
	                    '</div>' +
	                '</div>' +
	                '<div class="mfield"><label>상세 내용</label><textarea id="mDetail" placeholder="추가 내용을 입력하세요"></textarea></div>';
	        }
	
	        document.getElementById('modalBody').innerHTML = html;
	        document.getElementById('disposalModal').classList.add('open');
	    };
	
	    window.closeDisposalModal = function () {
	        document.getElementById('disposalModal').classList.remove('open');
	        currentModalStockNo = null;
	    };
	
	    window.onBackdropClick = function (e) {
	        if (e.target === document.getElementById('disposalModal')) closeDisposalModal();
	    };
	
	    window.submitDisposal = function () {
	        var qty    = document.getElementById('mQty');
	        var reason = document.getElementById('mReason');
	        var detail = document.getElementById('mDetail');
	
	        if (!qty.readOnly && (!qty.value || parseInt(qty.value) <= 0)) { alert('폐기 수량을 입력해주세요.'); return; }
	        if (!reason.disabled && !reason.value) { alert('폐기 사유를 선택해주세요.'); return; }
	
	        var row = stockData.find(function (x) { return x.branchStockCode === currentModalStockNo; });
	        var disposalQty = qty.readOnly ? row.currentQty : qty.value;
	
	        var formData = new URLSearchParams();
	        formData.append('branchStockCode', currentModalStockNo);
	        formData.append('disposalQty',     disposalQty);
	        formData.append('disposalReason',  reason.value);
	        formData.append('reasonDetail',    detail.value || '');
	
	        fetch(contextPath + '/branch/stock/disposal', {
	            method: 'POST',
	            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	            body: formData.toString()
	        })
	        .then(function (res) { return res.json(); })
	        .then(function (data) {
	            if (data.success) {
	                alert('폐기 등록이 완료되었습니다.');
	                closeDisposalModal();
	                loadStockList(currentPage);
	            } else {
	                alert(data.error || '폐기 등록에 실패했습니다.');
	            }
	        })
	        .catch(function () {
	            alert('폐기 등록 중 오류가 발생했습니다.');
	        });
	    };
	
	    /* ── 초기 실행 ── */
	    loadCategoryList();
	    /* loadStockList(1); */
	})();
	</script>
</body>
</html>
