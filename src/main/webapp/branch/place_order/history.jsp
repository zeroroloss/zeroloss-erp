<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
	<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

    <title>발주 내역</title>
    <style>
        body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #f4f7fb; color: #111827; }
        .wrap { width: 100%; max-width: none; margin: 0; }
        .page-head { padding: 18px 0 14px; }
        .page-title { margin: 0; font-size: 30px; line-height: 1.15; font-weight: 800; letter-spacing: -0.03em; }
        .page-sub { margin: 8px 0 0; font-size: 15px; color: #6b7280; }

        .filter-card { margin-top: 10px; background: #fff; border: 1px solid #e5e7eb; border-radius: 14px; padding: 14px 16px; box-shadow: 0 8px 20px rgba(15, 23, 42, 0.04); }
        .filter-head { display: flex; align-items: center; gap: 8px; margin-bottom: 10px; color: #111827; font-size: 18px; font-weight: 800; letter-spacing: -0.02em; }
        .filter-line { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .field label { display: block; font-size: 14px; font-weight: 700; color: #374151; margin-bottom: 8px; }
        .date-input { position: relative; }
        .date-input input { width: 100%; box-sizing: border-box; height: 40px; border: 1px solid #d5dae4; border-radius: 10px; padding: 0 14px 0 40px; font-size: 14px; color: #111827; background: #fff; }
        .date-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #9aa3af; font-size: 18px; }
        .filter-actions { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 14px; }
        .filter-btn { height: 40px; padding: 0 18px; border: 0; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; transition: background 0.15s ease, color 0.15s ease; }
        .filter-btn.primary { background: #00853d; color: #fff; }
        .filter-btn.primary:hover { background: #006b2f; }
        .filter-btn.secondary { background: #eef2f7; color: #374151; }
        .filter-btn.secondary:hover { background: #e5e7eb; }

        .table-card { margin-top: 18px; background: #fff; border: 1px solid #e5e7eb; border-radius: 14px; overflow: hidden; box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05); }
        .tabs { display: grid; grid-template-columns: repeat(4, 1fr); border-bottom: 1px solid #e6eaf0; }
        .tab-link { height: 52px; display: flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none; background: #fff; font-size: 16px; font-weight: 700; letter-spacing: -0.01em; color: #6b7280; }
        .tab-link.active { color: #2563eb; background: #f3f6ff; box-shadow: inset 0 -2px 0 #4f7dff; }
        .tab-link.sent { color: #2563eb; }
        .tab-link.approved { color: #16a34a; }
        .tab-link.rejected { color: #ef4444; }

        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 16px; border-bottom: 1px solid #edf0f5; text-align: left; font-size: 14px; }
        th { background: #fafbfc; color: #1f2937; font-weight: 900; }
        tbody tr:hover { background: #fbfdff; }
        .row-rejected { background: #fff3f3; }

        .mono-link { color: #2563eb; font-weight: 800; text-decoration: none; letter-spacing: 0.02em; }
        .value-strong { font-weight: 800; }
        .value-blue { color: #2563eb; font-weight: 900; }
        .center { text-align: center; }
        .right { text-align: right; }

        .status { display: inline-flex; align-items: center; gap: 6px; padding: 5px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
        .status-pending { background: #fff7e6; color: #d97706; }
		.status-approved { background: #e8f5e9; color: #16a34a; }
		.status-rejected { background: #ffe4e6; color: #dc2626; }
		.status-canceled { background: #f3f4f6; color: #6b7280; }
		.status-delivered { background: #e0f2fe; color: #0284c7; }
		.status-completed { background: #ede9fe; color: #7c3aed; }

        .work { display: inline-flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 700; text-decoration: none; margin-right: 10px; }
        .work.view { color: #2563eb; }
        .work.cancel { color: #ef4444; }

        .empty-state { display: none; padding: 34px 16px; text-align: center; color: #6b7280; }
        .empty-state.visible { display: block; }

        .place-order-popup-overlay { position: fixed; inset: 0; z-index: 3000; background: rgba(0, 0, 0, 0.72); display: none; align-items: center; justify-content: center; padding: 18px; box-sizing: border-box; }
        .place-order-popup-overlay.active { display: flex; }
        .place-order-popup-frame { width: min(980px, 100%); height: min(94vh, 920px); border: 0; border-radius: 14px; background: transparent; }
        
        .filter-group {
		    display: flex;
		    align-items: center;
		    gap: 10px;
		    flex-wrap: wrap;
		}
		.date-picker-wrap input, select.sort-btn, select#mainCategorySelect, select#menuSelect {
            height:38px;
            width:115px;
            border-radius:12px;
            border:1px solid #d1d5db;
            background:#fff;
            color:#1f2937;
            padding:0 8px;
            font-size:13px;
            outline:none;
        }

        .date-picker-wrap input {
            padding-left: 30px !important;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af' class='w-5 h-5'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zM4.5 6.75A1.25 1.25 0 015.75 5.5h8.5A1.25 1.25 0 0115.5 6.75v8.5A1.25 1.25 0 0114.25 16.5h-8.5A1.25 1.25 0 014.5 15.25v-8.5zM7 10a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm-6 3a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2z' clip-rule='evenodd' /%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: 8px center;
            background-size: 16px;
        }

        @media (max-width: 980px) {
            .page-title { font-size: 26px; }
            .filter-head { font-size: 16px; }
            .filter-line { grid-template-columns: 1fr; }
            .tab-link { font-size: 14px; height: 46px; }
            th, td { font-size: 13px; padding: 12px; }
        }
    </style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
<%! 
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
	// 서버에서 전달된 발주 내역 리스트를 JSON으로 변환
    Object historyListAttr = request.getAttribute("placeOrderHistoryList");
    String historyJson = new com.google.gson.Gson().toJson(historyListAttr != null ? historyListAttr : java.util.Collections.emptyList());

    java.time.LocalDate today = java.time.LocalDate.now();
    String defaultStartDate = today.withDayOfMonth(1).toString();
    String defaultEndDate = today.withDayOfMonth(today.lengthOfMonth()).toString();

    String startDateValue = request.getAttribute("startDate") != null ? String.valueOf(request.getAttribute("startDate")) : request.getParameter("startDate");
    if (startDateValue == null || startDateValue.isBlank()) startDateValue = defaultStartDate;

    String endDateValue = request.getAttribute("endDate") != null ? String.valueOf(request.getAttribute("endDate")) : request.getParameter("endDate");
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
        <h1 class="page-title">발주 내역</h1>
        <p class="page-sub">일자 범위로 발주 내역을 확인하세요</p>
    </div>

    <div class="filter-card">
        <div class="filter-head">발주내역 조회기간</div>
        <div class="filter-group">
		    <div class="date-picker-wrap">
		        <input type="text" id="filterStartDate" value="<%= escapeHtml(startDateValue) %>" />
		    </div>
		
		    <span class="text-gray-500">~</span>
		
		    <div class="date-picker-wrap">
		        <input type="text" id="filterEndDate" value="<%= escapeHtml(endDateValue) %>" />
		    </div>
		</div>
        <div class="filter-actions">
            <button type="button" class="filter-btn primary" onclick="applyFilters()">조회하기</button>
            <button type="button" class="filter-btn secondary" onclick="resetFilters()">초기화</button>
        </div>
    </div>

    <div class="table-card">
        <div class="tabs">
            <a class="tab-link active" href="#" data-status="ALL">전체 <span id="tabCountAll">0건</span></a>
            <a class="tab-link sent" href="#" data-status="PENDING">승인 대기 <span id="tabCountSent">0건</span></a>
            <a class="tab-link approved" href="#" data-status="APPROVED">승인됨 <span id="tabCountApproved">0건</span></a>
            <a class="tab-link rejected" href="#" data-status="REJECTED">반려됨 <span id="tabCountRejected">0건</span></a>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>발주서 번호</th>
                        <th>작성 일시</th>
                        <th class="right">품목 수</th>
                        <th class="right">총 수량</th>
                        <th class="center">상태</th>
                        <th class="center">작업</th>
                    </tr>
                </thead>
                <tbody id="historyTableBody"></tbody>
            </table>
            <div id="emptyState" class="empty-state">조회 결과가 없습니다</div>
        </div>
    </div>
</div>
</div>
</div>

<!-- 상세정보 모달 -->
<div id="detailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4" style="display: none;">
    <div class="bg-white rounded-lg max-w-4xl w-full p-6 max-h-[90vh] overflow-y-auto">
        <!-- 모달 헤더 -->
        <div class="flex items-center justify-between mb-6">
            <div>
                <h3 class="text-xl font-bold text-gray-900">발주서 상세정보</h3>
                <p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
            </div>
            <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-6 h-6"></i>
            </button>
        </div>

        <!-- 기본 정보 그리드 -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6 bg-gray-50 rounded-lg p-4">
            <div><p class="text-sm text-gray-500">발주서번호</p>   <p class="font-semibold text-gray-900" id="detailPoNo"></p></div>
            <div><p class="text-sm text-gray-500">상태</p>   <p class="font-semibold text-gray-900" id="detailStatus"></p></div>
            <div><p class="text-sm text-gray-500">작성일시</p>   <p class="font-semibold text-gray-900" id="detailCreatedAt"></p></div>
            <div><p class="text-sm text-gray-500">총 품목수</p>  <p class="font-semibold text-gray-900" id="detailItemCount"></p></div>
            <div><p class="text-sm text-gray-500">총 수량</p>   <p class="font-semibold text-gray-900" id="detailTotalQty"></p></div>
            <div><p class="text-sm text-gray-500">총 금액</p>   <p class="font-semibold text-gray-900" id="detailTotalAmount"></p></div>
        </div>

        <!-- 발주 상세 테이블 -->
        <div>
            <h4 class="font-semibold text-gray-900 mb-3">발주 상세</h4>
            <div class="overflow-x-auto border border-gray-200 rounded-lg">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">재료코드</th>
                            <th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">재료명</th>
                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">신청수량</th>
                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">승인수량</th>
                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">남은수량</th>
                        </tr>
                    </thead>
                    <tbody id="detailTableBody"></tbody>
                </table>
            </div>
        </div>

        <!-- 반려사유 (반려 상태일 때만) -->
        <div id="rejectReasonDiv" class="hidden mt-6 p-4 bg-red-50 rounded-lg border border-red-200">
            <p class="text-sm text-gray-500">반려 사유</p>
            <p class="font-semibold text-red-700" id="detailRejectReason"></p>
        </div>

        <div class="flex justify-end mt-6">
            <button onclick="closeDetailModal()"
                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">닫기</button>
        </div>
    </div>
</div>

<div id="placeOrderPopupOverlay" class="place-order-popup-overlay" aria-hidden="true">
        <iframe id="placeOrderPopupFrame" class="place-order-popup-frame" title="발주 팝업"></iframe>
</div>

<script type="application/json" id="historyDataJson"><%= historyJson %></script>

<script>
(function () {

    const contextPath = '<%= request.getContextPath() %>';

    const els = {
        overlay: document.getElementById('placeOrderPopupOverlay'),
        frame: document.getElementById('placeOrderPopupFrame'),
        tbody: document.getElementById('historyTableBody'),
        empty: document.getElementById('emptyState'),
        start: document.getElementById('filterStartDate'),
        end: document.getElementById('filterEndDate'),
        tabs: document.querySelectorAll('.tab-link')
    };

    const state = {
        historyData: [],
        currentStatus: 'ALL'
    };
    
    // =========================
    // 공통 유틸
    // =========================
	const utils = {
		getStatus: function (r) {
		    return (r.statusKey || r.status || '').toUpperCase();
		},
		
		getStatusLabel: function (status) {
			const map = {
			    PENDING:   '승인 대기',
			    APPROVED:  '승인됨',
			    REJECTED:  '반려됨',
			    CANCELED:  '취소됨',
			    DELIVERED: '지점 배송 완료',
			    COMPLETED: '지점 입고 완료'
			};

		    return map[status] || status;
		},
	
	    getDate: function (r) {
	        var raw = r.createdAt || r.requestDate || r.releaseDate || r.date || '';
	        return raw.split(' ')[0];
	    },
	
	    getPoNo: function (r) {
	        return r.poNo || r.orderId || '';
	    },
	
	    buildDetailUrl: function (r) {
	        var status = this.getStatus(r);
	
	        var page =
	            status === 'APPROVED' ? '/approval_detail.jsp' :
	            status === 'REJECTED' ? '/rejection_detail.jsp' :
	            '/request_detail.jsp';
	
	        return contextPath
	            + '/branch/place_order'
	            + page
	            + '?poNo='
	            + encodeURIComponent(this.getPoNo(r));
	    },
	
	    buildCancelUrl: function (r) {
	    	if (this.getStatus(r) !== 'PENDING') return '';
	
	        return contextPath
	            + '/branch/place_order/cancel_request.jsp'
	            + '?poNo='
	            + encodeURIComponent(this.getPoNo(r));
	    }
	};

    // =========================
    // 발주내역 조회하기 API
    // =========================
    async function fetchHistory() {
        const start = els.start.value;
        const end = els.end.value;

        // 데이터 가져오기
        const res = await fetch(
		    contextPath
		    + '/api/branch/place_order/history?startDate='
		    + encodeURIComponent(start)
		    + '&endDate='
		    + encodeURIComponent(end)
		);

        const json = await res.json();
        return Array.isArray(json) ? json : (json.data || []);
    }

    // =========================
    // 필터
    // =========================
    function filterData() {
	    const start = new Date(els.start.value);
	    const end = new Date(els.end.value);
	    end.setHours(23, 59, 59, 999);
	
	    return state.historyData.filter(r => {
	        const status = utils.getStatus(r);
	
	        if (state.currentStatus !== 'ALL' && status !== state.currentStatus)
	            return false;
	
	        const date = new Date(utils.getDate(r));
	        return date >= start && date <= end;
	    });
	}

    // =========================
    // 렌더링
    // =========================
	function createRow(r) {
	    var status = utils.getStatus(r);
	    console.log(status);
	
	    var statusMap = {
    	    PENDING:   { cls: 'status-pending', icon: '⏳' },
    	    APPROVED:  { cls: 'status-approved', icon: '✓' },
    	    REJECTED:  { cls: 'status-rejected', icon: '⊗' },
    	    CANCELED:  { cls: 'status-canceled', icon: '✕' },
    	    DELIVERED: { cls: 'status-delivered', icon: '📦' },
    	    COMPLETED: { cls: 'status-completed', icon: '🏁' }
    	};
	
	    var s = statusMap[status] || { cls: '', icon: '' };
	
	    var rowClass = status === 'REJECTED' ? 'row-rejected' : '';
	    var detailUrl = utils.buildDetailUrl(r);
	    var cancelUrl = utils.buildCancelUrl(r);
	
	    var html = '';
	    
	    const label = utils.getStatusLabel(status);
	    
	    html += '<tr class="' + rowClass + '">';
	
	    html += '<td>';
	    html += '<a class="mono-link open-popup" href="' + detailUrl + '">';
	    html += (utils.getPoNo(r) || '');
	    html += '</a>';
	    html += '</td>';
	
	    html += '<td>📅 ' + (utils.getDate(r) || '') + '</td>';
	
	    html += '<td class="right value-strong">';
	    html += (r.itemCount != null ? r.itemCount : 0) + '개';
	    html += '</td>';
	
	    html += '<td class="right value-blue">';
	    html += (r.totalQty != null ? r.totalQty : 0);
	    html += '</td>';
	
	    html += '<td class="center">';
	    html += '<span class="status ' + s.cls + '">';
	    html += s.icon + ' ' + label;
	    html += '</span>';
	    html += '</td>';
	
	    html += '<td class="center">';
	    html += '<a class="work view open-popup" href="' + detailUrl + '">◎ 상세</a>';
	
	    if (cancelUrl) {
	        html += '<a class="work cancel open-popup" href="' + cancelUrl + '">✕ 취소</a>';
	    }
	
	    html += '</td>';
	
	    html += '</tr>';
	
	    return html;
	}
    
    function render() {
        const list = filterData();

        els.tbody.innerHTML = list.map(createRow).join('');
        els.empty.classList.toggle('visible', list.length === 0);

        updateTabs();
    }

    // =========================
    // 탭 카운트
    // =========================
    function updateTabs() {
    	const counts = { ALL: 0, PENDING: 0, APPROVED: 0, REJECTED: 0 };

    	state.historyData.forEach(r => {
    	    const s = utils.getStatus(r);
    	    counts.ALL++;
    	    if (counts[s] !== undefined) counts[s]++;
    	});

    	document.getElementById('tabCountAll').textContent = counts.ALL + '건';
    	document.getElementById('tabCountSent').textContent = counts.PENDING + '건';
    	document.getElementById('tabCountApproved').textContent = counts.APPROVED + '건';
    	document.getElementById('tabCountRejected').textContent = counts.REJECTED + '건';

        els.tabs.forEach(tab => {
            tab.classList.toggle(
                'active',
                tab.dataset.status === state.currentStatus
            );
        });
    }

    // =========================
    // 팝업
    // =========================
    function openPopup(url) {
        els.frame.src = url;
        els.overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closePopup() {
        els.overlay.classList.remove('active');
        els.frame.src = '';
        document.body.style.overflow = '';
    }

    // =========================
    // 상세정보 모달
    // =========================
    async function openDetail(poNo) {
        var tbody = document.getElementById('detailTableBody');
        tbody.innerHTML = '<tr><td colspan="5" class="py-8 text-center text-gray-500">로딩 중...</td></tr>';
        document.getElementById('detailModal').style.display = 'flex';

        try {
            var res = await fetch(contextPath + '/api/branch/place_order/history?action=detail&poNo=' + encodeURIComponent(poNo));
            if (!res.ok) throw new Error('API 실패: ' + res.status);

            var json = await res.json();
            var data = json.data;
            console.log('발주 상태:', data.status);

            // 기본 정보 채우기
            document.getElementById('detailPoNo').textContent = data.poNo;
            document.getElementById('detailStatus').textContent = data.status || '-';
            document.getElementById('detailCreatedAt').textContent = data.createdAt || '-';
            document.getElementById('detailItemCount').textContent = (data.itemCount || 0) + '개';
            document.getElementById('detailTotalQty').textContent = (data.totalQty || 0);
            document.getElementById('detailTotalAmount').textContent = (data.totalAmount || 0) + '원';
            document.getElementById('modalSubtitle').textContent = '발주번호: ' + data.poNo + ' · ' + (data.status || '-');

            // 반려사유 표시 (REJECTED 상태일 때만)
            var rejectDiv = document.getElementById('rejectReasonDiv');
            if (data.status === 'REJECTED' && data.rejectReason) {
                rejectDiv.classList.remove('hidden');
                document.getElementById('detailRejectReason').textContent = data.rejectReason;
            } else {
                rejectDiv.classList.add('hidden');
            }

            // 발주 상세 테이블 렌더링
            var details = data.details;
            if (!details || !details.length) {
                tbody.innerHTML = '<tr><td colspan="5" class="py-8 text-center text-gray-500">상세 항목이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = '';
            details.forEach(function(detail) {
                var tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100';
                tr.innerHTML =
                    '<td class="py-3 px-4 text-base text-gray-800 font-mono">' + (detail.materialCode || '-') + '</td>' +
                    '<td class="py-3 px-4 text-base text-gray-800">' + (detail.materialName || '-') + '</td>' +
                    '<td class="py-3 px-4 text-base text-right font-semibold text-gray-800">' + (detail.requestedQty || 0) + ' ' + (detail.unit || '') + '</td>' +
                    '<td class="py-3 px-4 text-base text-right font-semibold text-gray-800">' + (detail.approvedQty || '-') + '</td>' +
                    '<td class="py-3 px-4 text-base text-right font-semibold text-gray-800">' + (detail.remainingQty || '-') + '</td>';
                tbody.appendChild(tr);
            });

        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="5" class="py-8 text-center text-red-500">데이터를 불러오지 못했습니다: ' + err.message + '</td></tr>';
        }
    }

    function closeDetailModal() {
        document.getElementById('detailModal').style.display = 'none';
    }

    document.getElementById('detailModal').addEventListener('click', function(e) {
        if (e.target === this) closeDetailModal();
    });
    

    // =========================
    // 이벤트
    // =========================
    	
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('open-popup')) {
            e.preventDefault();
            openPopup(e.target.href);
        }
    });
    
    window.applyFilters = async () => {
    	// 발주 내역 데이터 조회하기
        state.historyData = await fetchHistory();
        render();
    };

    window.resetFilters = async () => {

        const today = new Date();
        const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);

        document.getElementById("filterStartDate").value = firstDayOfMonth.toISOString().slice(0, 10);
        document.getElementById("filterEndDate").value = today.toISOString().slice(0, 10);

        state.historyData = await fetchHistory();
        render();
    };

    els.overlay.addEventListener('click', e => {
        if (e.target === els.overlay) closePopup();
    });

    els.tabs.forEach(tab => {
        tab.addEventListener('click', e => {
            e.preventDefault();
            state.currentStatus = tab.dataset.status;
            render();
        });
    });

    window.addEventListener('message', e => {
        if (e.data?.type === 'close-place-order-popup') {
            closePopup();
        }
    });
    
    document.addEventListener("DOMContentLoaded", function () {

        flatpickr.localize(flatpickr.l10ns.ko);

        // 현재 달 1일 / 오늘
        const today = new Date();
        const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);

        let startPicker, endPicker;

        // START
        startPicker = flatpickr("#filterStartDate", {
            dateFormat: "Y-m-d",
            defaultDate: firstDayOfMonth,
            onChange: function (selectedDates) {
                if (selectedDates.length > 0) {
                    endPicker.set("minDate", selectedDates[0]); // start ≤ end 강제
                }
                applyFilters(); // 자동 조회
            }
        });

        // END
        endPicker = flatpickr("#filterEndDate", {
            dateFormat: "Y-m-d",
            defaultDate: today,
            maxDate: "today", // 🚨 미래 날짜 선택 방지
            onChange: function () {
                applyFilters(); // 자동 조회
            }
        });

    });

    // =========================
    // 초기화
    // =========================
    async function init() {
        const initialDataEl = document.getElementById('historyDataJson');

        try {
            state.historyData = JSON.parse(initialDataEl.textContent || '[]');
        } catch {
            state.historyData = [];
        }

        if (state.historyData.length === 0) {
            state.historyData = await fetchHistory();
        }

        render();
    }

    init();

})();
</script>
</body>
</html>
