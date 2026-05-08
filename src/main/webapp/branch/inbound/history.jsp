<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
    <title>입고 내역</title>
    <style>
        body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #f4f7fb; color: #111827; }
        .wrap { width: 100%; max-width: none; margin: 0; }
        .page-head { padding: 18px 0 16px; }
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
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 16px; border-bottom: 1px solid #edf0f5; text-align: left; font-size: 14px; }
        th { background: #fafbfc; color: #1f2937; font-weight: 900; }
        tbody tr:hover { background: #fbfdff; }
        .right { text-align: right; }
        .center { text-align: center; }
        .mono-link { color: #2563eb; font-weight: 800; text-decoration: none; letter-spacing: 0.02em; }
        .empty-state { display: none; padding: 34px 16px; text-align: center; color: #6b7280; }
        .empty-state.visible { display: block; }

        .detail-btn { height: 32px; padding: 0 12px; border: 0; border-radius: 9px; background: #eff6ff; color: #2563eb; font-size: 13px; font-weight: 800; cursor: pointer; }

        .summary { margin-top: 14px; background: #eef4ff; border: 1px solid #c7d7fe; border-radius: 14px; padding: 16px 18px; display: flex; justify-content: space-between; align-items: center; gap: 12px; color: #1d4ed8; }
        .summary-left { display: flex; align-items: center; gap: 10px; font-weight: 700; }
        .summary-right { font-weight: 700; }

        .modal-overlay { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box; background: rgba(15, 23, 42, 0.68); z-index: 2000; }
        .modal-overlay.active { display: flex; }
        .modal { width: min(860px, 100%); max-height: 92vh; overflow: hidden; background: #fff; border-radius: 18px; box-shadow: 0 28px 70px rgba(15, 23, 42, 0.28); display: flex; flex-direction: column; }
        .modal-head { display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; padding: 20px 22px 16px; border-bottom: 1px solid #e5e7eb; }
        .modal-title { margin: 0; font-size: 22px; font-weight: 900; letter-spacing: -0.03em; color: #111827; }
        .modal-sub { margin-top: 6px; color: #6b7280; font-size: 14px; }
        .modal-close { border: 0; background: transparent; color: #94a3b8; font-size: 28px; line-height: 1; cursor: pointer; }
        .modal-body { padding: 18px 22px 22px; overflow: auto; }
        .detail-summary { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; margin-bottom: 16px; }
        .detail-box { background: #f8fafc; border: 1px solid #e5e7eb; border-radius: 12px; padding: 12px 14px; }
        .detail-label { font-size: 13px; color: #6b7280; font-weight: 700; }
        .detail-value { margin-top: 6px; font-size: 16px; color: #111827; font-weight: 800; }
        .detail-table { width: 100%; border-collapse: collapse; }
        .detail-table th, .detail-table td { padding: 12px 14px; border-bottom: 1px solid #edf0f5; font-size: 14px; }
        .detail-table th { background: #f8fafc; font-weight: 800; }
        .detail-table tbody tr:last-child td { border-bottom: 0; }
        .detail-table .right { text-align: right; }
        
        .paging-wrap { display: flex; justify-content: center; align-items: center; gap: 4px; padding: 16px 14px; border-top: 1px solid #e5e7eb; }
		.page-btn { min-width: 40px; height: 38px; padding: 0 12px; border: 1px solid #d1d5db; border-radius: 8px; background: #fff; color: #374151; font-size: 14px; font-weight: 500; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; }
		.page-btn:hover { background: #f9fafb; }
		.page-btn.active { background: #00853D; color: #fff; border-color: #00853D; font-weight: 700; }
		.page-btn:disabled { opacity: 0.4; cursor: not-allowed; background: #fff; }
		.page-btn:disabled:hover { background: #fff; }
		.page-info { font-size: 13px; color: #6b7280; margin: 0 8px; }

        @media (max-width: 980px) {
            .filter-line { grid-template-columns: 1fr; }
            .detail-summary { grid-template-columns: 1fr; }
            .summary { flex-direction: column; align-items: flex-start; }
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
<div class="wrap p-6">
    <div class="page-head">
        <h1 class="page-title">입고 내역</h1>
        <p class="page-sub">입고된 발주 내역을 조회하고 상세를 확인하세요</p>
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

    <div class="summary">
        <div class="summary-left">총 <span id="summaryCount">0</span>건의 입고 내역</div>
        <div class="summary-right">총 금액: <span id="summaryAmount">0원</span></div>
    </div>

    <div class="table-card">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>발주 번호</th>
                        <th>입고시점</th>
                        <th class="right">품목 수</th>
                        <th class="right">총 금액</th>
                        <th class="center">상세 보기</th>
                    </tr>
                </thead>
                <tbody id="historyTableBody"></tbody>
            </table>
            <div id="emptyState" class="empty-state">조회 결과가 없습니다</div>
        </div>
        <div class="paging-wrap" id="historyPaging" style="display: none;"></div>
    </div>
</div>
</div>
</div>

<div id="detailModal" class="modal-overlay" aria-hidden="true">
    <section class="modal" role="dialog" aria-modal="true" aria-label="입고 상세 정보">
        <div class="modal-head">
            <div>
                <h2 class="modal-title">입고 상세 보기</h2>
                <div class="modal-sub" id="modalSubtitle"></div>
            </div>
            <button type="button" class="modal-close" onclick="closeDetailModal()" aria-label="닫기">×</button>
        </div>
        <div class="modal-body">
            <div class="detail-summary">
                <div class="detail-box">
                    <div class="detail-label">발주 번호</div>
                    <div class="detail-value" id="detailPoNo">-</div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">입고 시점</div>
                    <div class="detail-value" id="detailReceivedAt">-</div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">총 금액</div>
                    <div class="detail-value" id="detailTotalAmount">0원</div>
                </div>
            </div>

            <table class="detail-table">
                <thead>
                    <tr>
                        <th>지점 재고 번호</th>
                        <th>카테고리명</th>
                        <th>재료명</th>
                        <th class="right">입고 수량</th>
                    </tr>
                </thead>
                <tbody id="detailTableBody"></tbody>
            </table>
        </div>
    </section>
</div>

<script>
    (function () {
        var contextPath = '<%= request.getContextPath() %>';
        
        var historyData = [];
        var currentPage = 1;
        var itemsPerPage = 10;

        function toSafeText(value) {
            return value == null ? '' : String(value);
        }

        function escapeHtml(value) {
            return toSafeText(value)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function formatNumber(value) {
            var num = Number(value || 0);
            if (isNaN(num)) return '0';
            return new Intl.NumberFormat('ko-KR').format(num);
        }

        function formatQty(value) {
            if (value == null || value === '') return '0';
            var num = Number(value);
            if (isNaN(num)) return String(value);
            return Number.isInteger(num) ? String(num) : String(num);
        }

        function openDetailModal() {
            var modal = document.getElementById('detailModal');
            modal.classList.add('active');
            modal.setAttribute('aria-hidden', 'false');
        }

        window.closeDetailModal = function () {
            var modal = document.getElementById('detailModal');
            modal.classList.remove('active');
            modal.setAttribute('aria-hidden', 'true');
        };

        function renderHistoryTable(rows) {
            var tbody = document.getElementById('historyTableBody');
            var emptyState = document.getElementById('emptyState');
            var summaryCount = document.getElementById('summaryCount');
            var summaryAmount = document.getElementById('summaryAmount');

            tbody.innerHTML = '';

            if (!Array.isArray(rows) || rows.length === 0) {
                emptyState.classList.add('visible');
                summaryCount.textContent = '0';
                summaryAmount.textContent = '0원';
                renderPaging(0);
                return;
            }

            emptyState.classList.remove('visible');

            var totalAmount = 0;
            rows.forEach(function (row) {
                var amount = Number(row.totalAmount || 0);
                totalAmount += isNaN(amount) ? 0 : amount;
            });

            var totalPages = Math.max(1, Math.ceil(rows.length / itemsPerPage));

            if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            var startIndex = (currentPage - 1) * itemsPerPage;
            var endIndex = startIndex + itemsPerPage;
            var currentRows = rows.slice(startIndex, endIndex);

            currentRows.forEach(function (row) {
                var poNo = toSafeText(row.poNo || '-');
                var receivedAt = toSafeText(row.receivedAt || '-');
                var itemCount = Number(row.itemCount || 0);
                var amount = Number(row.totalAmount || 0);

                tbody.insertAdjacentHTML('beforeend',
                    '<tr>' +
                        '<td><span class="mono-link">' + escapeHtml(poNo) + '</span></td>' +
                        '<td>' + escapeHtml(receivedAt) + '</td>' +
                        '<td class="right">' + formatNumber(itemCount) + '개</td>' +
                        '<td class="right">' + formatNumber(amount) + '원</td>' +
                        '<td class="center"><button type="button" class="detail-btn" data-po-no="' + escapeHtml(poNo) + '">상세 보기</button></td>' +
                    '</tr>'
                );
            });

            summaryCount.textContent = String(rows.length);
            summaryAmount.textContent = formatNumber(totalAmount) + '원';

            tbody.querySelectorAll('.detail-btn').forEach(function (button) {
                button.addEventListener('click', function () {
                    loadDetail(button.getAttribute('data-po-no'));
                });
            });

            renderPaging(rows.length);
        }
        
        // 페이징
        function renderPaging(totalCount) {
		    var wrap = document.getElementById('historyPaging');
		
		    totalCount = parseInt(totalCount || 0);
		    var totalPages = Math.max(1, Math.ceil(totalCount / itemsPerPage));
		
		    if (totalPages <= 1) {
		        wrap.style.display = 'none';
		        wrap.innerHTML = '';
		        return;
		    }
		
		    wrap.style.display = 'flex';
		
		    var PAGE_SIZE = 5;
		    var blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
		    var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);
		
		    var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
		    var nextBlockPage = Math.min(totalPages, blockEnd + 1);
		
		    var html = '';
		
		    html += '<button type="button" class="page-btn" onclick="goToPage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-angles-left" style="font-size:11px"></i>';
		    html += '</button>';
		
		    html += '<button type="button" class="page-btn" onclick="goToPage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-chevron-left" style="font-size:11px"></i>';
		    html += '</button>';
		
		    for (var i = blockStart; i <= blockEnd; i++) {
		        html += '<button type="button" class="page-btn' + (i === currentPage ? ' active' : '') + '" onclick="goToPage(' + i + ')">';
		        html += i;
		        html += '</button>';
		    }
		
		    html += '<button type="button" class="page-btn" onclick="goToPage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-chevron-right" style="font-size:11px"></i>';
		    html += '</button>';
		
		    html += '<button type="button" class="page-btn" onclick="goToPage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-angles-right" style="font-size:11px"></i>';
		    html += '</button>';
		
		    wrap.innerHTML = html;
		}
		
		window.goToPage = function (page) {
		    var totalPages = Math.max(1, Math.ceil(historyData.length / itemsPerPage));
		
		    page = parseInt(page || 1);
		
		    if (page < 1) {
		        page = 1;
		    }
		
		    if (page > totalPages) {
		        page = totalPages;
		    }
		
		    currentPage = page;
		    renderHistoryTable(historyData);
		};

        function renderDetailRows(details) {
            var tbody = document.getElementById('detailTableBody');
            tbody.innerHTML = '';

            if (!Array.isArray(details) || details.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="center">상세 내역이 없습니다.</td></tr>';
                return;
            }

            details.forEach(function (detail) {
                var branchStockCode = toSafeText(detail.branchStockCode || '-');
                var categoryName = toSafeText(detail.categoryName || '-');
                var materialName = toSafeText(detail.materialName || '-');
                var qty = formatQty(detail.receivedQty);
                var unit = toSafeText(detail.unit || '');

                tbody.insertAdjacentHTML('beforeend',
                    '<tr>' +
                        '<td>' + escapeHtml(branchStockCode) + '</td>' +
                        '<td>' + escapeHtml(categoryName) + '</td>' +
                        '<td>' + escapeHtml(materialName) + '</td>' +
                        '<td class="right">' + escapeHtml(qty + (unit ? ' ' + unit : '')) + '</td>' +
                    '</tr>'
                );
            });
        }

        async function loadHistory() {
            var startDate = document.getElementById('filterStartDate').value;
            var endDate = document.getElementById('filterEndDate').value;

            var url = contextPath + '/api/branch/inbound/history?startDate=' + encodeURIComponent(startDate) + '&endDate=' + encodeURIComponent(endDate);
            var response = await fetch(url, { headers: { 'Accept': 'application/json' } });
            var payload = await response.json();

            if (!response.ok || !payload || payload.status !== 'success') {
                throw new Error((payload && payload.message) || '입고 내역 조회 실패');
            }

            historyData = payload.data || [];
            currentPage = 1;
            renderHistoryTable(historyData);
        }

        async function loadDetail(poNo) {
            if (!poNo) return;

            var url = contextPath + '/api/branch/inbound/history?action=detail&poNo=' + encodeURIComponent(poNo);
            var response = await fetch(url, { headers: { 'Accept': 'application/json' } });
            var payload = await response.json();

            if (!response.ok || !payload || payload.status !== 'success') {
                commonShowAlert('알림', (payload && payload.message) || '상세 조회에 실패했습니다.');
                return;
            }

            var data = payload.data || {};
            document.getElementById('detailPoNo').textContent = toSafeText(data.poNo || poNo || '-');
            document.getElementById('detailReceivedAt').textContent = toSafeText(data.receivedAt || '-');
            document.getElementById('detailTotalAmount').textContent = formatNumber(data.totalAmount) + '원';
            document.getElementById('modalSubtitle').textContent = '품목 수 ' + formatNumber(data.itemCount || 0) + '개';
            renderDetailRows(data.items || []);
            openDetailModal();
        }

        window.applyFilters = function () {
            loadHistory().catch(function (error) {
                console.error(error);
                commonShowAlert('알림', error.message || '입고 내역 조회 중 오류가 발생했습니다.');
            });
        };

        window.resetFilters = function () {
            var today = new Date();
            var start = new Date(today.getFullYear(), today.getMonth(), 1);
            var end = new Date(today.getFullYear(), today.getMonth() + 1, 0);

            function pad(value) {
                return String(value).padStart(2, '0');
            }

            document.getElementById('filterStartDate').value = start.getFullYear() + '-' + pad(start.getMonth() + 1) + '-' + pad(start.getDate());
            document.getElementById('filterEndDate').value = end.getFullYear() + '-' + pad(end.getMonth() + 1) + '-' + pad(end.getDate());
            window.applyFilters();
        };

        document.getElementById('detailModal').addEventListener('click', function (event) {
            if (event.target === this) {
                window.closeDetailModal();
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                window.closeDetailModal();
            }
        });

        window.applyFilters();
    })();
</script>
</body>
</html>