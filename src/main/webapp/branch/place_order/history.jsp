<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
        .status.sent { background: #e8f0ff; color: #2563eb; }
        .status.approved { background: #ddf6e5; color: #17803d; }
        .status.rejected { background: #ffe4e6; color: #dc2626; }

        .work { display: inline-flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 700; text-decoration: none; margin-right: 10px; }
        .work.view { color: #2563eb; }
        .work.cancel { color: #ef4444; }

        .empty-state { display: none; padding: 34px 16px; text-align: center; color: #6b7280; }
        .empty-state.visible { display: block; }

        .place-order-popup-overlay { position: fixed; inset: 0; z-index: 3000; background: rgba(0, 0, 0, 0.72); display: none; align-items: center; justify-content: center; padding: 18px; box-sizing: border-box; }
        .place-order-popup-overlay.active { display: flex; }
        .place-order-popup-frame { width: min(980px, 100%); height: min(94vh, 920px); border: 0; border-radius: 14px; background: transparent; }

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
        <div class="filter-head">⌄ 일자 범위</div>
        <div class="filter-line">
            <div class="field">
                <label for="filterStartDate">시작일</label>
                <div class="date-input">
                    <span class="date-icon">📅</span>
                    <input type="date" id="filterStartDate" value="<%= escapeHtml(startDateValue) %>" />
                </div>
            </div>
            <div class="field">
                <label for="filterEndDate">종료일</label>
                <div class="date-input">
                    <span class="date-icon">📅</span>
                    <input type="date" id="filterEndDate" value="<%= escapeHtml(endDateValue) %>" />
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
            <a class="tab-link active" href="#" data-status="전체">전체 <span id="tabCountAll">0건</span></a>
            <a class="tab-link sent" href="#" data-status="전송">전송 <span id="tabCountSent">0건</span></a>
            <a class="tab-link approved" href="#" data-status="승인">승인 <span id="tabCountApproved">0건</span></a>
            <a class="tab-link rejected" href="#" data-status="반려">반려 <span id="tabCountRejected">0건</span></a>
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
        currentStatus: '전체'
    };

    // =========================
    // 공통 유틸
    // =========================
	const utils = {
	    getStatus: function (r) {
	        return r.statusKey || r.status || '전체';
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
	            status === '승인' ? '/approval_detail.jsp' :
	            status === '반려' ? '/rejection_detail.jsp' :
	            '/request_detail.jsp';
	
	        return contextPath
	            + '/branch/place_order'
	            + page
	            + '?poNo='
	            + encodeURIComponent(this.getPoNo(r));
	    },
	
	    buildCancelUrl: function (r) {
	        if (this.getStatus(r) !== '전송') return '';
	
	        return contextPath
	            + '/branch/place_order/cancel_request.jsp'
	            + '?poNo='
	            + encodeURIComponent(this.getPoNo(r));
	    }
	};

    // =========================
    // API
    // =========================
    async function fetchHistory() {
        const start = els.start.value;
        const end = els.end.value;

        // 데이터 가져오기
        const res = await fetch(
		    contextPath
		    + '/api/branch/place_order?startDate='
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

            if (state.currentStatus !== '전체' && status !== state.currentStatus)
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
	
	    var statusMap = {
	        '전송': { cls: 'sent', icon: '✈' },
	        '승인': { cls: 'approved', icon: '✓' },
	        '반려': { cls: 'rejected', icon: '⊗' }
	    };
	
	    var s = statusMap[status] || statusMap['전송'];
	
	    var rowClass = status === '반려' ? 'row-rejected' : '';
	    var detailUrl = utils.buildDetailUrl(r);
	    var cancelUrl = utils.buildCancelUrl(r);
	
	    var html = '';
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
	    html += s.icon + ' ' + status;
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
        bindPopup();
    }

    // =========================
    // 탭 카운트
    // =========================
    function updateTabs() {
        const counts = { 전체: 0, 전송: 0, 승인: 0, 반려: 0 };

        state.historyData.forEach(r => {
            const s = utils.getStatus(r);
            if (counts[s] !== undefined) counts[s]++;
            counts.전체++;
        });

        document.getElementById('tabCountAll').textContent = counts.전체 + '건';
        document.getElementById('tabCountSent').textContent = counts.전송 + '건';
        document.getElementById('tabCountApproved').textContent = counts.승인 + '건';
        document.getElementById('tabCountRejected').textContent = counts.반려 + '건';

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

    function bindPopup() {
        document.querySelectorAll('.open-popup').forEach(el => {
            el.onclick = e => {
                e.preventDefault();
                openPopup(el.href);
            };
        });
    }

    // =========================
    // 이벤트
    // =========================
    window.applyFilters = async () => {
    	// 발주 내역 데이터 조회하기
        state.historyData = await fetchHistory();
        render();
    };

    window.resetFilters = async () => {
    	// 발주 내역 데이터 초기화하기
        els.start.value = '<%= defaultStartDate %>';
        els.end.value = '<%= defaultEndDate %>';
        state.currentStatus = '전체';

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
