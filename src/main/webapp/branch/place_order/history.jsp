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
        .status-pending  { background: #fff7e6; color: #d97706; }
        .status-approved { background: #e8f5e9; color: #16a34a; }
        .status-rejected { background: #ffe4e6; color: #dc2626; }
        .status-canceled { background: #f3f4f6; color: #6b7280; }
        .status-delivered{ background: #e0f2fe; color: #0284c7; }
        .status-completed{ background: #ede9fe; color: #7c3aed; }

        .work { display: inline-flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 700; text-decoration: none; margin-right: 10px; cursor: pointer; background: none; border: none; padding: 0; }
        .work.view   { color: #2563eb; }
        .work.cancel { color: #ef4444; }

        .empty-state { display: none; padding: 34px 16px; text-align: center; color: #6b7280; }
        .empty-state.visible { display: block; }

        .filter-group { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .date-picker-wrap input {
            height: 38px; width: 115px; border-radius: 12px; border: 1px solid #d1d5db;
            background: #fff; color: #1f2937; padding: 0 8px; font-size: 13px; outline: none;
            padding-left: 30px !important;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zM4.5 6.75A1.25 1.25 0 015.75 5.5h8.5A1.25 1.25 0 0115.5 6.75v8.5A1.25 1.25 0 0114.25 16.5h-8.5A1.25 1.25 0 014.5 15.25v-8.5zM7 10a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm-6 3a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2zm3 0a1 1 0 100-2 1 1 0 000 2z' clip-rule='evenodd' /%3E%3C/svg%3E");
            background-repeat: no-repeat; background-position: 8px center; background-size: 16px;
        }

        /* =====================
           상세 모달
        ===================== */
        .detail-modal-overlay {
            position: fixed; inset: 0; z-index: 4000;
            background: rgba(0, 0, 0, 0.60);
            display: none; align-items: center; justify-content: center;
            padding: 18px; box-sizing: border-box;
            animation: fadeIn 0.18s ease;
        }
        .detail-modal-overlay.active { display: flex; }

        @keyframes fadeIn  { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(24px); } to { opacity: 1; transform: translateY(0); } }

        .detail-modal {
            width: min(700px, 100%); max-height: 92vh; overflow-y: auto;
            background: #fff; border: 1px solid #e5e7eb; border-radius: 16px;
            padding: 22px 24px;
            box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22);
            animation: slideUp 0.22s ease;
        }

        .dm-head { display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; }
        .dm-title { margin: 0; font-size: 24px; font-weight: 800; color: #111827; letter-spacing: -0.02em; }
        .dm-order-no { margin-top: 6px; font-size: 14px; color: #64748b; }
        .dm-close-btn {
            border: 0; background: transparent; color: #94a3b8;
            font-size: 26px; line-height: 1; cursor: pointer; padding: 0;
        }
        .dm-close-btn:hover { color: #374151; }

        .dm-summary { margin-top: 18px; display: grid; grid-template-columns: 1fr 1fr; gap: 16px 20px; }
        .dm-label { font-size: 14px; color: #475569; font-weight: 700; }
        .dm-value { margin-top: 6px; font-size: 20px; color: #111827; font-weight: 800; }
        .dm-value.blue { color: #2563eb; }

        .dm-section-title { margin: 20px 0 10px; font-size: 18px; color: #111827; font-weight: 800; }

        .dm-table-wrap { border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; background: #fff; }
        .dm-table-wrap table { width: 100%; border-collapse: collapse; }
        .dm-table-wrap th,
        .dm-table-wrap td { padding: 12px 14px; border-bottom: 1px solid #e6ebf2; font-size: 14px; text-align: left; }
        .dm-table-wrap th { background: #f8fafc; color: #1f2937; font-weight: 800; }
        .dm-table-wrap td.right,
        .dm-table-wrap th.right { text-align: right; }
        .dm-table-wrap tbody tr:last-child td { border-bottom: 0; }

        /* 상태별 수량 색상 */
        .qty-requested { color: #2563eb; font-weight: 800; }
        .qty-approved  { color: #16a34a; font-weight: 800; }
        .qty-remaining { color: #ef4444; font-weight: 800; }

        /* 반려 사유 박스 */
        .dm-reason-box { margin-top: 18px; border: 1px solid #fecaca; border-radius: 12px; background: #fff1f2; padding: 14px; }
        .dm-reason-title { display: flex; align-items: center; gap: 8px; margin: 0; color: #b91c1c; font-size: 17px; font-weight: 800; }
        .dm-reason-text { margin: 8px 0 0; color: #dc2626; font-size: 14px; line-height: 1.6; }

        /* 모달 하단 버튼 */
        .dm-actions { margin-top: 20px; display: flex; gap: 12px; }
        .dm-btn { height: 42px; border-radius: 10px; border: 0; padding: 0 20px; font-size: 14px; font-weight: 700; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .dm-btn-cancel { background: #dc2626; color: #fff; flex: 1; }
        .dm-btn-cancel:hover { background: #b91c1c; }
        .dm-btn-close  { border: 1px solid #d1d5db; background: #f9fafb; color: #374151; flex: 1; }
        .dm-btn-close:hover { background: #e5e7eb; }

        /* 로딩 스피너 */
        .dm-loading { padding: 40px 0; text-align: center; color: #6b7280; font-size: 14px; }

        /* =====================
           취소 모달
        ===================== */
        .cancel-modal-overlay {
            position: fixed; inset: 0; z-index: 5000;
            background: rgba(0, 0, 0, 0.65);
            display: none; align-items: center; justify-content: center;
            padding: 18px; box-sizing: border-box;
        }
        .cancel-modal-overlay.active { display: flex; }

        .cancel-modal {
            width: min(560px, 100%);
            background: #fff; border: 1px solid #e5e7eb; border-radius: 16px;
            padding: 22px;
            box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22);
            animation: slideUp 0.22s ease;
        }

        .cm-head { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; }
        .cm-icon {
            flex-shrink: 0;
            width: 52px; height: 52px; border-radius: 50%;
            background: #fee2e2; color: #dc2626;
            display: grid; place-items: center;
            font-size: 28px; line-height: 1;
        }
        .cm-title { margin: 0; font-size: 22px; font-weight: 900; color: #111827; letter-spacing: -0.02em; }
        .cm-order-no { margin: 4px 0 0; font-size: 13px; color: #64748b; }

        .cm-field { margin-top: 4px; }
        .cm-field label { display: block; font-size: 14px; font-weight: 700; color: #1f2937; margin-bottom: 8px; }
        .cm-field label .req { color: #ef4444; }
        .cm-field textarea {
            width: 100%; min-height: 140px; box-sizing: border-box;
            border: 1px solid #d1d5db; border-radius: 12px;
            background: #f9fafb; padding: 12px 14px;
            font-size: 14px; color: #334155; resize: vertical;
            font-family: inherit;
            transition: border-color 0.15s;
        }
        .cm-field textarea:focus { outline: none; border-color: #ef4444; background: #fff; }
        .cm-field textarea::placeholder { color: #8f98a7; }

        .cm-notice {
            margin-top: 14px;
            border: 1px solid #fde68a; background: #fffbeb;
            border-radius: 10px; padding: 10px 14px;
            color: #b45309; font-size: 12px; line-height: 1.5;
        }

        .cm-actions { margin-top: 18px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .cm-btn {
            height: 46px; border-radius: 10px; border: 0;
            font-size: 15px; font-weight: 700; cursor: pointer;
            display: inline-flex; align-items: center; justify-content: center;
            transition: background 0.15s;
        }
        .cm-btn-close  { border: 1px solid #d1d5db; background: #f9fafb; color: #374151; }
        .cm-btn-close:hover  { background: #e5e7eb; }
        .cm-btn-submit { background: #dc2626; color: #fff; }
        .cm-btn-submit:hover  { background: #b91c1c; }
        .cm-btn-submit:disabled { background: #fca5a5; cursor: not-allowed; }

        @media (max-width: 560px) {
            .cancel-modal { padding: 16px; }
            .cm-icon { width: 42px; height: 42px; font-size: 22px; }
            .cm-title { font-size: 19px; }
            .cm-actions { grid-template-columns: 1fr; }
            .cm-btn { height: 42px; font-size: 14px; }
        }

        /* Custom date picker */
        .custom-date-picker {
            position: fixed; width: 300px; background: #fff;
            border: 1px solid #d1d5db; border-radius: 0.75rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            z-index: 9999; padding: 14px;
        }
        .custom-date-picker.hidden { display: none; }
        .custom-date-picker-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; }
        .custom-date-picker select { height: 30px; min-width: auto; width: auto; border-radius: 0.5rem; padding: 0 8px; font-size: 12px; font-weight: 600; background: #fff; border: 1px solid #e5e7eb; }
        .custom-date-nav-btn { width: 30px; height: 30px; border-radius: 0.5rem; border: 1px solid #e5e7eb; color: #4b5563; background: #fff; cursor: pointer; }
        .custom-date-nav-btn:hover { background: #f3f4f6; }
        .custom-date-weekdays, .custom-date-days { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; }
        .custom-date-weekdays div { text-align: center; font-size: 11px; font-weight: 700; color: #6b7280; padding: 4px 0; }
        .custom-date-day { height: 32px; border-radius: 0.5rem; border: none; background: #fff; font-size: 12px; cursor: pointer; color: #111827; }
        .custom-date-day:hover { background: #ecfdf3; color: #00853D; font-weight: 700; }
        .custom-date-day.other-month { color: #c4c4c4; }
        .custom-date-day.today  { border: 1px solid #00853D; color: #00853D; font-weight: 700; }
        .custom-date-day.selected { background: #00853D; color: #fff; font-weight: 700; }

        @media (max-width: 980px) {
            .page-title { font-size: 26px; }
            .filter-head { font-size: 16px; }
            .filter-line { grid-template-columns: 1fr; }
            .tab-link { font-size: 14px; height: 46px; }
            th, td { font-size: 13px; padding: 12px; }
        }
        @media (max-width: 560px) {
            .detail-modal { padding: 16px; }
            .dm-title { font-size: 22px; }
            .dm-summary { grid-template-columns: 1fr; gap: 10px; }
            .dm-value { font-size: 18px; }
            .dm-section-title { font-size: 16px; }
            .dm-table-wrap th,
            .dm-table-wrap td { font-size: 13px; padding: 9px; }
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
    Object historyListAttr = request.getAttribute("placeOrderHistoryList");
    String historyJson = new com.google.gson.Gson().toJson(historyListAttr != null ? historyListAttr : java.util.Collections.emptyList());

    java.time.LocalDate today = java.time.LocalDate.now();
    String defaultStartDate = today.withDayOfMonth(1).toString();
    String defaultEndDate   = today.withDayOfMonth(today.lengthOfMonth()).toString();

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
        <h1 class="page-title">발주 내역</h1>
        <p class="page-sub">일자 범위로 발주 내역을 확인하세요</p>
    </div>

    <div class="filter-card">
        <div class="filter-head">발주내역 조회기간</div>
        <div class="filter-group">
            <div class="date-picker-wrap">
                <input type="text" id="filterStartDate" value="<%= escapeHtml(startDateValue) %>" readonly onclick="openCustomDatePicker('filterStartDate', event)" />
            </div>
            <span class="text-gray-500">~</span>
            <div class="date-picker-wrap">
                <input type="text" id="filterEndDate" value="<%= escapeHtml(endDateValue) %>" readonly onclick="openCustomDatePicker('filterEndDate', event)" />
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
            <a class="tab-link sent"     href="#" data-status="PENDING">승인 대기 <span id="tabCountSent">0건</span></a>
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

<!-- =====================
     상세 모달 (인라인)
     - PENDING  : 취소 버튼 표시, 요청수량만 표시
     - APPROVED : 요청/승인/미승인 수량 표시
     - REJECTED : 요청/승인/미승인 수량 + 반려 사유 표시
===================== -->
<div id="detailModalOverlay" class="detail-modal-overlay" onclick="if(event.target===this) closeDetailModal()">
    <section class="detail-modal" role="dialog" aria-modal="true" aria-labelledby="dmTitle">

        <!-- 헤더 -->
        <div class="dm-head">
            <div>
                <h2 class="dm-title" id="dmTitle">발주서 상세 정보</h2>
                <div class="dm-order-no" id="dmOrderNo"></div>
            </div>
            <button type="button" class="dm-close-btn" onclick="closeDetailModal()" aria-label="닫기">×</button>
        </div>

        <!-- 로딩 -->
        <div id="dmLoading" class="dm-loading">불러오는 중...</div>

        <!-- 본문 (로딩 후 표시) -->
        <div id="dmBody" style="display:none;">

            <!-- 요약 -->
            <div class="dm-summary">
                <div>
                    <div class="dm-label">작성 일시</div>
                    <div class="dm-value" id="dmCreatedAt">-</div>
                </div>
                <div>
                    <div class="dm-label">상태</div>
                    <span class="status" id="dmStatus"></span>
                </div>
                <div>
                    <div class="dm-label">품목 수</div>
                    <div class="dm-value" id="dmItemCount">-</div>
                </div>
                <div>
                    <div class="dm-label">총 요청 수량</div>
                    <div class="dm-value blue" id="dmTotalQty">-</div>
                </div>
            </div>

            <!-- 품목 상세 테이블 -->
            <h3 class="dm-section-title">발주 품목 상세</h3>
            <div class="dm-table-wrap">
                <table>
                    <thead id="dmTableHead"></thead>
                    <tbody id="dmTableBody"></tbody>
                </table>
            </div>

            <!-- 반려 사유 (REJECTED 전용) -->
            <div id="dmReasonBox" class="dm-reason-box" style="display:none;">
                <h3 class="dm-reason-title">❗ 반려 사유</h3>
                <p class="dm-reason-text" id="dmReasonText">반려 사유가 없습니다.</p>
            </div>

            <!-- 하단 버튼 -->
            <div class="dm-actions" id="dmActions"></div>

        </div>
    </section>
</div>

<!-- =====================
     취소 모달 (인라인)
     cancel_request.jsp 대체
===================== -->
<div id="cancelModalOverlay" class="cancel-modal-overlay" onclick="if(event.target===this) closeCancelModal()">
    <section class="cancel-modal" role="dialog" aria-modal="true" aria-labelledby="cmTitle">

        <div class="cm-head">
            <div class="cm-icon">×</div>
            <div>
                <h2 class="cm-title" id="cmTitle">발주 취소</h2>
                <p class="cm-order-no" id="cmOrderNo"></p>
            </div>
        </div>

        <div class="cm-field">
            <label for="cmReason">취소 사유 <span class="req">*</span></label>
            <textarea id="cmReason" maxlength="500" placeholder="취소 사유를 입력해주세요..."></textarea>
        </div>

        <div class="cm-notice"><strong>안내:</strong> 확인 후 해당 발주서는 취소 처리됩니다.</div>

        <div class="cm-actions">
            <button type="button" class="cm-btn cm-btn-close"  onclick="closeCancelModal()">닫기</button>
            <button type="button" class="cm-btn cm-btn-submit" id="cmSubmitBtn">취소 확인</button>
        </div>
    </section>
</div>

<script type="application/json" id="historyDataJson"><%= historyJson %></script>

<script>
(function () {

    var contextPath = '<%= request.getContextPath() %>';

    var els = {
        tbody : document.getElementById('historyTableBody'),
        empty : document.getElementById('emptyState'),
        start : document.getElementById('filterStartDate'),
        end   : document.getElementById('filterEndDate'),
        tabs  : document.querySelectorAll('.tab-link'),
        overlay: document.getElementById('detailModalOverlay')
    };

    var state = {
        historyData   : [],
        currentStatus : 'ALL'
    };

    /* =====================
       공통 유틸
    ===================== */
    var utils = {
        getStatus: function (r) {
            return (r.statusKey || r.status || '').toUpperCase();
        },
        getStatusLabel: function (s) {
            return ({ PENDING:'승인 대기', APPROVED:'승인됨', REJECTED:'반려됨',
                      CANCELED:'취소됨', DELIVERED:'지점 배송 완료', COMPLETED:'지점 입고 완료' })[s] || s;
        },
        getDate: function (r) {
            return (r.createdAt || r.requestDate || r.releaseDate || r.date || '').split(' ')[0];
        },
        getPoNo: function (r) {
            return r.poNo || r.orderId || '';
        },
        formatQty: function (v) {
            if (v == null || v === '') return '0';
            var n = Number(v);
            return isNaN(n) ? String(v) : String(n);
        }
    };

    var STATUS_META = {
        PENDING  : { cls: 'status-pending',  icon: '⏳' },
        APPROVED : { cls: 'status-approved', icon: '✓'  },
        REJECTED : { cls: 'status-rejected', icon: '⊗'  },
        CANCELED : { cls: 'status-canceled', icon: '✕'  },
        DELIVERED: { cls: 'status-delivered',icon: '📦' },
        COMPLETED: { cls: 'status-completed',icon: '🏁' }
    };

    /* =====================
       발주내역 API
    ===================== */
    async function fetchHistory() {
        var res = await fetch(
            contextPath + '/api/branch/place_order/history?startDate='
            + encodeURIComponent(els.start.value)
            + '&endDate='
            + encodeURIComponent(els.end.value)
        );
        var json = await res.json();
        return Array.isArray(json) ? json : (json.data || []);
    }

    /* =====================
       필터
    ===================== */
    function filterData() {
        var s = new Date(els.start.value);
        var e = new Date(els.end.value);
        e.setHours(23, 59, 59, 999);

        return state.historyData.filter(function (r) {
            var st = utils.getStatus(r);
            if (state.currentStatus !== 'ALL' && st !== state.currentStatus) return false;
            var d = new Date(utils.getDate(r));
            return d >= s && d <= e;
        });
    }

    /* =====================
       테이블 렌더링
    ===================== */
    function createRow(r) {
        var status = utils.getStatus(r);
        var meta   = STATUS_META[status] || { cls: '', icon: '' };
        var label  = utils.getStatusLabel(status);
        var poNo   = utils.getPoNo(r);

        var rowClass = status === 'REJECTED' ? 'row-rejected' : '';
        var html = '<tr class="' + rowClass + '">';

        // 발주서 번호 (클릭 → 모달)
        html += '<td>'
             +  '<button class="mono-link work view open-detail" data-pono="' + poNo + '" type="button">'
             +  poNo
             +  '</button>'
             +  '</td>';

        html += '<td>📅 ' + utils.getDate(r) + '</td>';

        html += '<td class="right value-strong">' + (r.itemCount != null ? r.itemCount : 0) + '개</td>';

        html += '<td class="right value-blue">'  + (r.totalQty  != null ? r.totalQty  : 0) + '</td>';

        html += '<td class="center">'
             +  '<span class="status ' + meta.cls + '">' + meta.icon + ' ' + label + '</span>'
             +  '</td>';

        // 작업 버튼
        html += '<td class="center">';
        html += '<button class="work view open-detail" data-pono="' + poNo + '" type="button">◎ 상세</button>';
        if (status === 'PENDING') {
            html += '<button class="work cancel open-cancel" data-pono="' + poNo + '" type="button">✕ 취소</button>';
        }
        html += '</td>';

        html += '</tr>';
        return html;
    }

    function render() {
        var list = filterData();
        els.tbody.innerHTML = list.map(createRow).join('');
        els.empty.classList.toggle('visible', list.length === 0);
        updateTabs();
    }

    /* =====================
       탭 카운트
    ===================== */
    function updateTabs() {
        var counts = { ALL: 0, PENDING: 0, APPROVED: 0, REJECTED: 0 };
        state.historyData.forEach(function (r) {
            var s = utils.getStatus(r);
            counts.ALL++;
            if (counts[s] !== undefined) counts[s]++;
        });
        document.getElementById('tabCountAll').textContent      = counts.ALL     + '건';
        document.getElementById('tabCountSent').textContent     = counts.PENDING  + '건';
        document.getElementById('tabCountApproved').textContent = counts.APPROVED + '건';
        document.getElementById('tabCountRejected').textContent = counts.REJECTED + '건';

        els.tabs.forEach(function (tab) {
            tab.classList.toggle('active', tab.dataset.status === state.currentStatus);
        });
    }

    /* =====================
       상세 모달
    ===================== */
    async function openDetailModal(poNo) {
        var overlay = document.getElementById('detailModalOverlay');
        var loading = document.getElementById('dmLoading');
        var body    = document.getElementById('dmBody');

        // 모달 열기 & 로딩 상태
        overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
        loading.style.display = 'block';
        body.style.display    = 'none';

        try {
            var res = await fetch(
                contextPath + '/api/branch/place_order/history?action=detail&poNo='
                + encodeURIComponent(poNo)
            );
            if (!res.ok) throw new Error('API 오류: ' + res.status);

            var payload = await res.json();
            var data    = payload && payload.data ? payload.data : {};

            renderDetailModal(data, poNo);

        } catch (err) {
            loading.textContent = '데이터를 불러오지 못했습니다: ' + err.message;
        }
    }

    function renderDetailModal(data, poNo) {
        var loading = document.getElementById('dmLoading');
        var body    = document.getElementById('dmBody');

        var status = (data.status || 'PENDING').toUpperCase();
        var meta   = STATUS_META[status] || { cls: '', icon: '' };
        var label  = utils.getStatusLabel(status);

        // 기본 정보
        document.getElementById('dmOrderNo').textContent  = data.poNo || poNo || '-';
        document.getElementById('dmCreatedAt').textContent = data.createdAt || '-';
        document.getElementById('dmItemCount').textContent = (data.itemCount != null ? data.itemCount : 0) + '개';
        document.getElementById('dmTotalQty').textContent  = utils.formatQty(data.totalQty);

        var statusEl = document.getElementById('dmStatus');
        statusEl.className   = 'status ' + meta.cls;
        statusEl.textContent = meta.icon + ' ' + label;

        // 테이블 헤더 (상태에 따라 컬럼 다름)
        var thead = document.getElementById('dmTableHead');
        var isPending  = (status === 'PENDING');
        var isApproved = (status === 'APPROVED');
        var isRejected = (status === 'REJECTED');

        if (isPending) {
            thead.innerHTML =
                '<tr>'
                + '<th>품목명</th>'
                + '<th class="right">요청 수량</th>'
                + '</tr>';
        } else {
            thead.innerHTML =
                '<tr>'
                + '<th>품목명</th>'
                + '<th class="right">요청 수량</th>'
                + '<th class="right">승인 수량</th>'
                + '<th class="right">미승인 수량</th>'
                + '</tr>';
        }

        // 테이블 바디
        var tbody   = document.getElementById('dmTableBody');
        var details = data.details || [];
        if (!details.length) {
            tbody.innerHTML = '<tr><td colspan="' + (isPending ? 2 : 4) + '" style="text-align:center;padding:20px;color:#6b7280;">상세 품목이 없습니다.</td></tr>';
        } else {
            tbody.innerHTML = details.map(function (d) {
                var name      = d.materialName || d.materialCode || '-';
                var unit      = d.unit ? ' ' + d.unit : '';
                var requested = utils.formatQty(d.requestedQty) + unit;
                if (isPending) {
                    return '<tr>'
                         + '<td>' + name + '</td>'
                         + '<td class="right qty-requested">' + requested + '</td>'
                         + '</tr>';
                }
                var approved  = utils.formatQty(d.approvedQty)  + unit;
                var remaining = utils.formatQty(d.remainingQty) + unit;
                return '<tr>'
                     + '<td>' + name + '</td>'
                     + '<td class="right qty-requested">' + requested + '</td>'
                     + '<td class="right qty-approved">'  + approved  + '</td>'
                     + '<td class="right qty-remaining">' + remaining + '</td>'
                     + '</tr>';
            }).join('');
        }

        // 반려 사유 박스 (REJECTED 전용)
        var reasonBox = document.getElementById('dmReasonBox');
        if (isRejected) {
            document.getElementById('dmReasonText').textContent = data.rejectReason || '반려 사유가 없습니다.';
            reasonBox.style.display = 'block';
        } else {
            reasonBox.style.display = 'none';
        }

        // 하단 버튼 (PENDING 이면 취소 버튼 추가)
        var actionsEl = document.getElementById('dmActions');
        actionsEl.innerHTML = '';
        if (isPending) {
            var cancelBtn = document.createElement('button');
            cancelBtn.type      = 'button';
            cancelBtn.className = 'dm-btn dm-btn-cancel';
            cancelBtn.textContent = '✕ 취소 요청';
            cancelBtn.onclick = function () {
                openCancelModal(data.poNo || poNo);
            };
            actionsEl.appendChild(cancelBtn);
        }
        var closeBtn = document.createElement('button');
        closeBtn.type      = 'button';
        closeBtn.className = 'dm-btn dm-btn-close';
        closeBtn.textContent = '닫기';
        closeBtn.onclick = closeDetailModal;
        actionsEl.appendChild(closeBtn);

        // 로딩 숨기고 본문 표시
        loading.style.display = 'none';
        body.style.display    = 'block';
    }

    window.closeDetailModal = function () {
        var overlay = document.getElementById('detailModalOverlay');
        overlay.classList.remove('active');
        document.body.style.overflow = '';
    };

    /* =====================
       취소 모달 (인라인)
    ===================== */
    var cancelTargetPoNo = null;

    function openCancelModal(poNo) {
        cancelTargetPoNo = poNo;
        document.getElementById('cmOrderNo').textContent = '발주서 번호: ' + poNo;
        document.getElementById('cmReason').value = '';
        var submitBtn = document.getElementById('cmSubmitBtn');
        submitBtn.disabled = false;
        submitBtn.textContent = '취소 확인';
        document.getElementById('cancelModalOverlay').classList.add('active');
        document.body.style.overflow = 'hidden';
        setTimeout(function () { document.getElementById('cmReason').focus(); }, 80);
    }

    window.closeCancelModal = function () {
        document.getElementById('cancelModalOverlay').classList.remove('active');
        // 상세 모달도 열려 있으면 스크롤 잠금 유지, 아니면 해제
        if (!document.getElementById('detailModalOverlay').classList.contains('active')) {
            document.body.style.overflow = '';
        }
        cancelTargetPoNo = null;
    };

    document.getElementById('cmSubmitBtn').addEventListener('click', async function () {
        var reason = document.getElementById('cmReason').value.trim();
        if (!reason) {
            document.getElementById('cmReason').focus();
            document.getElementById('cmReason').style.borderColor = '#ef4444';
            setTimeout(function () {
                document.getElementById('cmReason').style.borderColor = '';
            }, 1800);
            return;
        }

        var submitBtn = document.getElementById('cmSubmitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = '처리 중...';

        try {
            var res = await fetch(contextPath + '/api/branch/place_order/cancel', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ poNo: cancelTargetPoNo, cancelReason: reason })
            });

            if (!res.ok) throw new Error('요청 실패: ' + res.status);

            var result = await res.json();

            if (result.status === 'success') {
                closeCancelModal();
                closeDetailModal();
                // 목록 새로고침
                applyFilters();
            } else {
                alert(result.message || '취소 요청에 실패했습니다.');
                submitBtn.disabled = false;
                submitBtn.textContent = '취소 확인';
            }
        } catch (err) {
            alert('취소 요청 중 오류가 발생했습니다.');
            console.error(err);
            submitBtn.disabled = false;
            submitBtn.textContent = '취소 확인';
        }
    });

    /* =====================
       이벤트 위임
    ===================== */
    document.addEventListener('click', function (e) {
        var target = e.target.closest('.open-detail');
        if (target) {
            e.preventDefault();
            openDetailModal(target.dataset.pono);
            return;
        }
        var cancelTarget = e.target.closest('.open-cancel');
        if (cancelTarget) {
            e.preventDefault();
            openCancelModal(cancelTarget.dataset.pono);
        }
    });

    window.addEventListener('message', function (e) {
        // iframe 방식 제거 후에도 혹시 외부 메시지가 오는 경우 대비해 유지
        if (e.data && e.data.type === 'close-place-order-popup') {
            applyFilters();
        }
    });

    /* =====================
       필터 액션
    ===================== */
    window.applyFilters = async function () {
        state.historyData = await fetchHistory();
        render();
    };

    window.resetFilters = async function () {
        var today = new Date();
        var first = new Date(today.getFullYear(), today.getMonth(), 1);
        document.getElementById('filterStartDate').value = first.toISOString().slice(0, 10);
        document.getElementById('filterEndDate').value   = today.toISOString().slice(0, 10);
        state.historyData = await fetchHistory();
        render();
    };

    els.tabs.forEach(function (tab) {
        tab.addEventListener('click', function (e) {
            e.preventDefault();
            state.currentStatus = tab.dataset.status;
            render();
        });
    });

    /* =====================
       Custom Date Picker
    ===================== */
    var customDateTargetId = null;
    var customPickerDate   = new Date();

    function parseDateLocal(str) {
        if (!str) return null;
        var p = String(str).split('-');
        return p.length === 3 ? new Date(+p[0], +p[1]-1, +p[2]) : null;
    }
    function formatDateLocal(d) {
        return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
    }

    window.openCustomDatePicker = function (inputId, event) {
        if (event) event.stopPropagation();
        customDateTargetId = inputId;
        var input = document.getElementById(inputId);
        var sel   = parseDateLocal(input.value);
        customPickerDate = sel || new Date();
        renderCustomDatePicker();
        var picker = document.getElementById('customDatePicker');
        var rect   = input.getBoundingClientRect();
        var top    = rect.bottom + 6;
        var left   = rect.left;
        if (left + 300 > window.innerWidth) left = window.innerWidth - 312;
        if (top  + 330 > window.innerHeight) top = rect.top - 336;
        picker.style.top  = top  + 'px';
        picker.style.left = left + 'px';
        picker.classList.remove('hidden');
    };

    window.changeCustomPickerMonth = function (amount) {
        customPickerDate.setMonth(customPickerDate.getMonth() + amount);
        renderCustomDatePicker();
    };
    window.changeCustomPickerYearMonth = function () {
        customPickerDate = new Date(
            +document.getElementById('customDatePickerYear').value,
            +document.getElementById('customDatePickerMonth').value,
            1
        );
        renderCustomDatePicker();
    };

    function renderCustomDatePicker() {
        var year  = customPickerDate.getFullYear();
        var month = customPickerDate.getMonth();
        var ys = document.getElementById('customDatePickerYear');
        var ms = document.getElementById('customDatePickerMonth');
        var htmlY = '', htmlM = '';
        for (var y = year-10; y <= year+10; y++) htmlY += '<option value="'+y+'"'+(y===year?' selected':'')+'>'+y+'년</option>';
        for (var m = 0; m < 12; m++) htmlM += '<option value="'+m+'"'+(m===month?' selected':'')+'>'+( m+1)+'월</option>';
        ys.innerHTML = htmlY; ms.innerHTML = htmlM;

        var firstDay = new Date(year, month, 1);
        var lastDay  = new Date(year, month+1, 0);
        var prevLast = new Date(year, month, 0);
        var days = [];
        for (var i = firstDay.getDay()-1; i >= 0; i--) days.push({ date: new Date(year, month-1, prevLast.getDate()-i), cur: false });
        for (var d = 1; d <= lastDay.getDate(); d++) days.push({ date: new Date(year, month, d), cur: true });
        var nd = 1;
        while (days.length < 42) { days.push({ date: new Date(year, month+1, nd++), cur: false }); }

        var input    = customDateTargetId ? document.getElementById(customDateTargetId) : null;
        var selVal   = input ? input.value : '';
        var todayVal = formatDateLocal(new Date());
        var html = '';
        for (var j = 0; j < days.length; j++) {
            var dv  = formatDateLocal(days[j].date);
            var cls = 'custom-date-day';
            if (!days[j].cur) cls += ' other-month';
            if (dv === todayVal) cls += ' today';
            if (dv === selVal)   cls += ' selected';
            html += '<button type="button" class="'+cls+'" onclick="selectCustomDate(\''+dv+'\')">'+days[j].date.getDate()+'</button>';
        }
        document.getElementById('customDatePickerDays').innerHTML = html;
    }

    window.selectCustomDate = function (dateValue) {
        if (!customDateTargetId) return;
        document.getElementById(customDateTargetId).value = dateValue;
        if (customDateTargetId === 'filterStartDate') {
            var sd = parseDateLocal(dateValue);
            var ed = parseDateLocal(document.getElementById('filterEndDate').value);
            if (ed && ed < sd) document.getElementById('filterEndDate').value = dateValue;
        } else {
            var ed2 = parseDateLocal(dateValue);
            var sd2 = parseDateLocal(document.getElementById('filterStartDate').value);
            if (sd2 && sd2 > ed2) document.getElementById('filterStartDate').value = dateValue;
        }
        document.getElementById('customDatePicker').classList.add('hidden');
        customDateTargetId = null;
        if (typeof applyFilters === 'function') applyFilters();
    };

    document.addEventListener('mousedown', function (e) {
        var picker = document.getElementById('customDatePicker');
        if (!picker || picker.classList.contains('hidden')) return;
        if (picker.contains(e.target)) return;
        if (customDateTargetId && document.getElementById(customDateTargetId) && document.getElementById(customDateTargetId).contains(e.target)) return;
        picker.classList.add('hidden');
        customDateTargetId = null;
    });

    /* =====================
       초기화
    ===================== */
    async function init() {
        var el = document.getElementById('historyDataJson');
        try { state.historyData = JSON.parse(el.textContent || '[]'); } catch(e) { state.historyData = []; }
        if (!state.historyData.length) state.historyData = await fetchHistory();
        render();
    }

    init();

})();
</script>

<!-- Custom Date Picker DOM -->
<div id="customDatePicker" class="custom-date-picker hidden" onclick="event.stopPropagation()">
    <div class="custom-date-picker-header">
        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(-1)">&#8249;</button>
        <div style="display:flex;align-items:center;gap:8px;">
            <select id="customDatePickerYear"  onchange="changeCustomPickerYearMonth()"></select>
            <select id="customDatePickerMonth" onchange="changeCustomPickerYearMonth()"></select>
        </div>
        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(1)">&#8250;</button>
    </div>
    <div class="custom-date-weekdays">
        <div>일</div><div>월</div><div>화</div><div>수</div><div>목</div><div>금</div><div>토</div>
    </div>
    <div id="customDatePickerDays" class="custom-date-days"></div>
</div>
</body>
</html>
