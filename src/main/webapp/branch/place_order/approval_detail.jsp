<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>발주서 상세 정보 - 승인</title>
    <style>
        body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: transparent; }
        .overlay { min-height: 100vh; background: transparent; display: flex; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box; }
        .modal { width: min(700px, 100%); background: #fff; border: 1px solid #e5e7eb; border-radius: 16px; padding: 22px 24px; box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22); }

        .head { display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; }
        .title { margin: 0; font-size: 24px; font-weight: 800; color: #111827; letter-spacing: -0.02em; }
        .order-no { margin-top: 6px; font-size: 14px; color: #64748b; }
        .close { border: 0; background: transparent; color: #94a3b8; text-decoration: none; font-size: 24px; line-height: 1; }

        .summary { margin-top: 18px; display: grid; grid-template-columns: 1fr 1fr; gap: 16px 20px; }
        .label { font-size: 14px; color: #475569; font-weight: 700; }
        .value { margin-top: 6px; font-size: 20px; color: #111827; font-weight: 800; }
        .value.blue { color: #2563eb; }
        .status { margin-top: 6px; display: inline-flex; align-items: center; gap: 6px; height: 26px; padding: 0 10px; border-radius: 999px; background: #dcfce7; color: #17803d; font-size: 13px; font-weight: 700; }

        .section-title { margin: 20px 0 10px; font-size: 18px; color: #111827; font-weight: 800; }
        .table-wrap { border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; background: #fff; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 14px; border-bottom: 1px solid #e6ebf2; font-size: 14px; text-align: left; }
        th { background: #f8fafc; color: #1f2937; font-weight: 800; }
        td.right, th.right { text-align: right; }
        .qty-approved { color: #16a34a; font-weight: 800; }
        .qty-remaining { color: #ef4444; font-weight: 800; }
        tbody tr:last-child td { border-bottom: 0; }

        .actions { margin-top: 20px; display: grid; grid-template-columns: 1fr; }
        .btn-close { height: 42px; border-radius: 10px; border: 1px solid #d1d5db; background: #f9fafb; color: #374151; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; font-weight: 700; }

        @media (max-width: 900px) {
            .title { font-size: 24px; }
            .order-no { font-size: 14px; }
            .label { font-size: 13px; }
            .value { font-size: 22px; }
            .status { font-size: 12px; height: 24px; }
            .section-title { font-size: 20px; }
            th, td { font-size: 13px; }
            .btn-close { font-size: 13px; height: 40px; }
            .close { font-size: 22px; }
        }
        @media (max-width: 560px) {
            .modal { padding: 16px; }
            .title { font-size: 22px; }
            .order-no { font-size: 15px; }
            .summary { grid-template-columns: 1fr; gap: 10px; }
            .label { font-size: 14px; }
            .value { font-size: 20px; }
            .status { font-size: 12px; }
            .section-title { font-size: 17px; margin-top: 14px; }
            th, td { font-size: 13px; padding: 9px; }
            .btn-close { font-size: 14px; height: 40px; }
            .close { font-size: 22px; }
        }
    </style>
</head>
<body>
<div class="overlay">
    <section class="modal" role="dialog" aria-modal="true" aria-label="발주서 상세 정보">
        <div class="head">
            <div>
                <h1 class="title">발주서 상세 정보 - 승인</h1>
                <div class="order-no" id="orderNo">-</div>
            </div>
            <a class="close" href="<%= request.getContextPath() %>/branch/place_order/history.jsp" aria-label="닫기">×</a>
        </div>

        <div class="summary">
            <div>
                <div class="label">작성 일시</div>
                <div class="value" id="createdAt">-</div>
            </div>
            <div>
                <div class="label">상태</div>
                <span class="status" id="statusText">✓ 승인</span>
            </div>
            <div>
                <div class="label">품목 수</div>
                <div class="value" id="itemCount">0개</div>
            </div>
            <div>
                <div class="label">총 요청 수량</div>
                <div class="value blue" id="totalQty">0</div>
            </div>
        </div>

        <h2 class="section-title">발주 품목 상세</h2>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>품목명</th>
                        <th class="right">요청 수량</th>
                        <th class="right">승인 수량</th>
                        <th class="right">미승인 수량</th>
                    </tr>
                </thead>
                <tbody id="detailBody"></tbody>
            </table>
        </div>

        <div class="actions">
            <a class="btn-close" href="<%= request.getContextPath() %>/branch/place_order/history.jsp">닫기</a>
        </div>
    </section>
</div>
<script>
    (function () {
        var contextPath = '<%= request.getContextPath() %>';

        function getPoNo() {
            var params = new URLSearchParams(window.location.search);
            return params.get('poNo') || '';
        }

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

        function formatQty(value) {
            if (value == null || value === '') return '0';
            var num = Number(value);
            if (isNaN(num)) return String(value);
            return Number.isInteger(num) ? String(num) : String(num);
        }

        async function loadDetail() {
            var poNo = getPoNo();
            if (!poNo) return;

            var response = await fetch(contextPath + '/api/branch/place_order/history?action=detail&poNo=' + encodeURIComponent(poNo));
            var payload  = await response.json();
            var data     = payload && payload.data ? payload.data : {};

            document.getElementById('orderNo').textContent    = toSafeText(data.poNo || poNo || '-');
            document.getElementById('createdAt').textContent  = toSafeText(data.createdAt || '-');
            document.getElementById('statusText').textContent = '✓ ' + toSafeText(data.status || '승인');
            document.getElementById('itemCount').textContent  = String(data.itemCount != null ? data.itemCount : 0) + '개';
            document.getElementById('totalQty').textContent   = formatQty(data.totalQty);
            renderDetailRows(data.details || []);
        }

        function renderDetailRows(details) {
            var tbody = document.getElementById('detailBody');
            if (!tbody) return;

            tbody.innerHTML = '';
            if (!Array.isArray(details) || details.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="center">상세 품목이 없습니다.</td></tr>';
                return;
            }

            details.forEach(function (detail) {
                var name      = escapeHtml(detail.materialName || detail.materialCode || '-');
                var unit      = escapeHtml(detail.unit || '');
                var requested = escapeHtml(formatQty(detail.requestedQty)) + (unit ? ' ' + unit : '');
                var approved  = escapeHtml(formatQty(detail.approvedQty))  + (unit ? ' ' + unit : '');
                var remaining = escapeHtml(formatQty(detail.remainingQty)) + (unit ? ' ' + unit : '');

                tbody.insertAdjacentHTML(
                    'beforeend',
                    '<tr>' +
                        '<td>' + name + '</td>' +
                        '<td class="right">' + requested + '</td>' +
                        '<td class="right qty-approved">' + approved + '</td>' +
                        '<td class="right qty-remaining">' + remaining + '</td>' +
                    '</tr>'
                );
            });
        }

        function closePopupOrFallback() {
            if (window.parent && window.parent !== window) {
                window.parent.postMessage({ type: 'close-place-order-popup' }, '*');
            }
        }

        var closeElements = document.querySelectorAll('.close, .btn-close');
        for (var i = 0; i < closeElements.length; i += 1) {
            closeElements[i].addEventListener('click', function (event) {
                event.preventDefault();
                closePopupOrFallback();
            });
        }

        loadDetail().catch(function () {
            document.getElementById('orderNo').textContent = '-';
            renderDetailRows([]);
        });
    })();
</script>
</body>
</html>
