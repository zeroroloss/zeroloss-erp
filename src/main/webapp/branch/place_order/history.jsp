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
</main>
</div>
</div>
<div id="placeOrderPopupOverlay" class="place-order-popup-overlay" aria-hidden="true">
        <iframe id="placeOrderPopupFrame" class="place-order-popup-frame" title="발주 팝업"></iframe>
</div>
<script type="application/json" id="historyDataJson"><%= historyJson %></script>
<script>

	// 페이지 로딩 시 (JS 초기화 영역)
    (function () {
        var overlay = document.getElementById('placeOrderPopupOverlay');
        var frame = document.getElementById('placeOrderPopupFrame');
        var historyData = [];
        var historyDataElement = document.getElementById('historyDataJson');

        if (historyDataElement) {
            try {
                historyData = JSON.parse(historyDataElement.textContent || '[]');
            } catch (error) {
                historyData = [];
            }
        }
        var contextPath = '<%= request.getContextPath() %>';

        // 현재 선택된 탭 상태 (전체 / 전송 / 승인 / 반려)
        var currentStatusFilter = '전체';

        function normalizeHistoryResponse(responseData) {
            if (Array.isArray(responseData)) {
                return responseData;
            }

            if (responseData && Array.isArray(responseData.data)) {
                return responseData.data;
            }

            return [];
        }

        // 발주 내역 조회 API 호출 (GET)
        // 백엔드: /api/branch/place_order?startDate=...&endDate=...
        async function loadHistoryData() {
            var startDate = document.getElementById('filterStartDate').value;
            var endDate = document.getElementById('filterEndDate').value;

            var response = await fetch('<%= request.getContextPath() %>/api/branch/place_order?startDate=' + encodeURIComponent(startDate) + '&endDate=' + encodeURIComponent(endDate));
            var data = await response.json();
            historyData = normalizeHistoryResponse(data);
            renderHistoryTable();
        }

        function openPopup(url) {
            if (!overlay || !frame || !url) return;
            // iframe에 URL 넣음
            frame.src = url; 
            overlay.classList.add('active'); // 팝업 띄움
            overlay.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';
        }

        function closePopup() {
            if (!overlay || !frame) return;
            overlay.classList.remove('active');
            overlay.setAttribute('aria-hidden', 'true');
            frame.src = '';
            document.body.style.overflow = '';
        }

        function toDateKey(value) {
            if (!value) return '';
            return String(value).split(' ')[0];
        }

        function getStatusKey(record) {
            return record.statusKey || record.status || '전체';
        }

        function resolveDetailUrl(record) {
            if (record && record.detailUrl) {
                return record.detailUrl;
            }

            var statusKey = getStatusKey(record);
            if (statusKey === '승인') {
                return contextPath + '/branch/place_order/approval_detail.jsp';
            }
            if (statusKey === '반려') {
                return contextPath + '/branch/place_order/rejection_detail.jsp';
            }
            return contextPath + '/branch/place_order/request_detail.jsp';
        }

        function resolveCancelUrl(record) {
            if (record && record.cancelUrl) {
                return record.cancelUrl;
            }

            var statusKey = getStatusKey(record);
            if (statusKey === '전송') {
                return contextPath + '/branch/place_order/cancel_request.jsp';
            }
            return '';
        }

        function withPoNo(url, record) {
            var poNo = (record && (record.poNo || record.orderId)) ? String(record.poNo || record.orderId) : '';
            if (!url || !poNo) {
                return url;
            }
            return url + (url.indexOf('?') >= 0 ? '&' : '?') + 'poNo=' + encodeURIComponent(poNo);
        }

        function syncTabCounts(list) {
            var counts = { 전체: list.length, 전송: 0, 승인: 0, 반려: 0 };

            list.forEach(function (record) {
                var statusKey = getStatusKey(record);
                if (counts.hasOwnProperty(statusKey)) counts[statusKey] += 1;
            });

            document.getElementById('tabCountAll').textContent = counts.전체 + '건';
            document.getElementById('tabCountSent').textContent = counts.전송 + '건';
            document.getElementById('tabCountApproved').textContent = counts.승인 + '건';
            document.getElementById('tabCountRejected').textContent = counts.반려 + '건';
        }

        function updateActiveTab() {
            var tabs = document.querySelectorAll('.tab-link');
            var activeStatus = currentStatusFilter;

            for (var i = 0; i < tabs.length; i += 1) {
                var tab = tabs[i];
                var tabStatus = tab.getAttribute('data-status');
                if (tabStatus === activeStatus) {
                    tab.classList.add('active');
                } else {
                    tab.classList.remove('active');
                }
            }
        }

        // 발주 내역 데이터에 날짜 + 상태 필터 적용하기
        function getFilteredHistoryList() {
            var startDate = new Date(document.getElementById('filterStartDate').value);
            var endDate = new Date(document.getElementById('filterEndDate').value);
            endDate.setHours(23, 59, 59, 999);

            // isNaN 예외 처리
            if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
                return historyData.slice();
            }

            return historyData.filter(function (record) {
                var recordStatus = getStatusKey(record);
                if (currentStatusFilter !== '전체' && recordStatus !== currentStatusFilter) {
                    return false;
                }

                var recordDate = new Date(toDateKey(record.createdAt || record.requestDate || record.releaseDate || record.date));
                return recordDate >= startDate && recordDate <= endDate;
            });
        }

        function buildRow(record) {
            var statusKey = getStatusKey(record);
            var statusClass = statusKey === '전송' ? 'sent' : statusKey === '승인' ? 'approved' : 'rejected';
            var statusIcon = statusKey === '전송' ? '✈' : statusKey === '승인' ? '✓' : '⊗';
            var rowClass = statusKey === '반려' ? 'row-rejected' : '';
            var detailUrl = withPoNo(resolveDetailUrl(record), record);
            var cancelUrl = withPoNo(resolveCancelUrl(record), record);
            var actionHtml = '<a class="work view open-place-order-popup" href="' + detailUrl + '">◎ 상세</a>';

            if (cancelUrl) {
                actionHtml += '<a class="work cancel open-place-order-popup" href="' + cancelUrl + '">✕ 취소</a>';
            }

            return '<tr class="' + rowClass + '">' +
                '<td><a class="mono-link open-place-order-popup" href="' + detailUrl + '">' + (record.orderId || record.poNo || '') + '</a></td>' +
                '<td>📅 ' + (record.createdAt || record.requestDate || record.releaseDate || record.date || '') + '</td>' +
                '<td class="right value-strong">' + (record.itemCount != null ? record.itemCount : 0) + '개</td>' +
                '<td class="right value-blue">' + (record.totalQty != null ? record.totalQty : 0) + '</td>' +
                '<td class="center"><span class="status ' + statusClass + '">' + statusIcon + ' ' + statusKey + '</span></td>' +
                '<td class="center">' + actionHtml + '</td>' +
            '</tr>';
        }

        function bindPopupTriggers() {
            var triggers = document.querySelectorAll('.open-place-order-popup');

            for (var i = 0; i < triggers.length; i += 1) {
                triggers[i].addEventListener('click', function (event) {
                    event.preventDefault(); //기본 이동 막음
                    openPopup(this.getAttribute('href'));
                });
            }
        }

        // 화면에 테이블 렌더링
        function renderHistoryTable() {
            var tbody = document.getElementById('historyTableBody');
            var emptyState = document.getElementById('emptyState');
            var filteredList = getFilteredHistoryList();

            syncTabCounts(historyData);
            updateActiveTab();
            tbody.innerHTML = '';

            if (filteredList.length === 0) {
                emptyState.classList.add('visible');
                bindPopupTriggers();
                return;
            }

            emptyState.classList.remove('visible');
            filteredList.forEach(function (record) {
                tbody.insertAdjacentHTML('beforeend', buildRow(record));
            });
            bindPopupTriggers();
        }

        // 조회 버튼 → 필터 적용
        window.applyFilters = async function () {
            await loadHistoryData();
        };

        // 초기화 버튼 → 기본값 + 전체
        window.resetFilters = async function () {
            document.getElementById('filterStartDate').value = '<%= escapeHtml(defaultStartDate) %>';
            document.getElementById('filterEndDate').value = '<%= escapeHtml(defaultEndDate) %>';
            currentStatusFilter = '전체';
            await loadHistoryData();
        };

        // 폼 바깥 오버레이 클릭 시 -> closePopup
        if (overlay) {
            overlay.addEventListener('click', function (event) {
                if (event.target === overlay) closePopup();
            });
        }

        // 탭 버튼 클릭 시 -> 탭 전환
        var tabs = document.querySelectorAll('.tab-link');
        for (var j = 0; j < tabs.length; j += 1) {
            tabs[j].addEventListener('click', function (event) {
                event.preventDefault();
                currentStatusFilter = this.getAttribute('data-status') || '전체';
                renderHistoryTable();
            });
        }

        // iframe 내부에서 postMessage로 닫기 요청 받음
        window.addEventListener('message', function (event) {
            if (event.data && event.data.type === 'close-place-order-popup') {
                closePopup();
            }
        });

        if (historyData.length === 0) {
            loadHistoryData();
        } else {
            renderHistoryTable();
        }
    })();
</script>
</body>
</html>
