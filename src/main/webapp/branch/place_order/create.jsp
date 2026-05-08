<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
    <title>발주서 작성</title>
    <style>
        :root {
            --bg: #f4f7fb;
            --panel: #ffffff;
            --line: #e5e7eb;
            --muted: #6b7280;
            --text: #111827;
            --blue: #2563eb;
            --blue-dark: #1d4ed8;
            --red: #ef4444;
            --green: #16a34a;
            --amber: #f59e0b;
            --chip: #eef2f7;
        }

        html, body { height: 100%; }
        body {
            margin: 0;
            font-family: "Malgun Gothic", sans-serif;
            background: var(--bg);
            color: var(--text);
            overflow: hidden;
        }

        .zl-app, .zl-content { height: 100%; }

        .wrap.place-wrap {
            padding-top: 18px;
            padding-bottom: 18px;
            height: 96%;
            display: flex;
            flex-direction: column;
            min-height: 0;
            overflow: hidden;
            box-sizing: border-box;
        }

        .page-head {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 14px;
            flex-shrink: 0;
        }

        .page-title {
            margin: 0;
            font-size: 30px;
            line-height: 1.15;
            font-weight: 800;
            letter-spacing: -0.03em;
        }

        .page-sub {
            margin: 8px 0 0;
            font-size: 14px;
            color: var(--muted);
            font-weight: 700;
        }

        .btn {
            height: 42px;
            padding: 0 16px;
            border-radius: 12px;
            border: 1px solid #d6dae3;
            background: #fff;
            color: var(--text);
            font-size: 14px;
            font-weight: 800;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .btn-primary {
            border-color: var(--blue);
            background: var(--blue);
            color: #fff;
        }

        .btn-primary:hover { background: var(--blue-dark); }

        .editor-shell {
            flex: 1;
            min-height: 0;
            display: grid;
            grid-template-columns: 1.18fr 40px 1fr;
            gap: 10px;
            overflow: hidden;
        }

        .editor-divider {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1e3a8a;
            font-size: 16px;
            font-weight: 700;
            user-select: none;
        }

        .panel {
            border: 1px solid var(--line);
            border-radius: 14px;
            background: var(--panel);
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
            display: flex;
            flex-direction: column;
            min-height: 0;
            overflow: hidden;
        }

        .panel-head {
            padding: 12px 14px;
            border-bottom: 1px solid var(--line);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            background: #fafbfd;
            flex-shrink: 0;
        }

        .panel-title {
            margin: 0;
            font-size: 18px;
            font-weight: 900;
            letter-spacing: -0.02em;
        }

        .panel-sub {
            margin: 4px 0 0;
            color: var(--muted);
            font-size: 12px;
            font-weight: 700;
        }

        .count-badge {
            min-width: 34px;
            height: 30px;
            border-radius: 999px;
            padding: 0 10px;
            background: #dbeafe;
            color: var(--blue);
            font-size: 13px;
            font-weight: 900;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .filter-wrap {
            padding: 10px;
            border-bottom: 1px solid var(--line);
            background: #f8fafc;
            flex-shrink: 0;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 8px;
        }

        .filter-group label {
            display: block;
            margin-bottom: 4px;
            font-size: 12px;
            font-weight: 800;
            color: var(--muted);
        }

        .filter-select,
        .filter-input {
            width: 100%;
            height: 36px;
            border: 1px solid #cfd6e2;
            border-radius: 8px;
            padding: 0 10px;
            background: #fff;
            color: var(--text);
            font-size: 13px;
            font-weight: 700;
        }

        .toggle-wrap {
            height: 36px;
            border: 1px solid #cfd6e2;
            border-radius: 8px;
            padding: 0 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            background: #fff;
            font-size: 13px;
            font-weight: 800;
            color: #374151;
        }

        .panel-body {
            flex: 1;
            min-height: 0;
            overflow: auto;
            padding: 0 10px;
            box-sizing: border-box;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid #edf0f5;
            text-align: left;
            font-size: 12px;
            vertical-align: middle;
        }

        th {
            position: sticky;
            top: 0;
            z-index: 2;
            background: #fafbfc;
            color: #111827;
            font-weight: 900;
        }

        .chip {
            display: inline-flex;
            align-items: center;
            height: 22px;
            padding: 0 8px;
            border-radius: 999px;
            background: var(--chip);
            color: #475569;
            font-size: 11px;
            font-weight: 700;
        }

        .status-low {
            display: inline-flex;
            align-items: center;
            height: 22px;
            border-radius: 999px;
            padding: 0 8px;
            background: #fef3c7;
            color: #92400e;
            font-size: 11px;
            font-weight: 900;
        }

        .status-normal {
            display: inline-flex;
            align-items: center;
            height: 22px;
            border-radius: 999px;
            padding: 0 8px;
            background: #e5e7eb;
            color: #4b5563;
            font-size: 11px;
            font-weight: 800;
        }

        .code-cell {
            white-space: nowrap;
            word-break: keep-all;
            overflow-wrap: normal;
            font-variant-numeric: tabular-nums;
            letter-spacing: 0.01em;
        }

        .stock-low { color: var(--red); font-weight: 900; }
        .center { text-align: center; }

        .btn-add-item,
        .btn-remove-item {
            height: 30px;
            border-radius: 999px;
            border: 0;
            padding: 0 10px;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-add-item {
            background: var(--green);
            color: #fff;
        }

        .btn-add-item.is-added {
            background: #d1d5db;
            color: #6b7280;
            cursor: default;
        }

        .btn-remove-item {
            background: var(--red);
            color: #fff;
        }

        .qty-cell {
            display: flex;
            flex-direction: column;
            gap: 3px;
            min-width: 132px;
        }

        .qty-input-wrap {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .qty-input {
            width: 78px;
            height: 32px;
            border: 1px solid #cfd6e2;
            border-radius: 8px;
            padding: 0 8px;
            font-size: 12px;
            font-weight: 800;
            color: var(--blue);
        }

        .qty-limit {
            color: var(--muted);
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .unit {
            color: #475569;
            font-size: 12px;
            font-weight: 800;
        }

        .panel-foot {
            padding: 10px 12px;
            border-top: 1px solid var(--line);
            background: #fbfcff;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            flex-shrink: 0;
        }

        .foot-summary {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
            flex-wrap: wrap;
        }

        .foot-chip {
            height: 30px;
            padding: 0 10px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #fff;
            border: 1px solid var(--line);
            color: #374151;
            font-size: 12px;
            font-weight: 800;
        }

        .foot-chip strong {
            color: var(--text);
            font-weight: 900;
        }

        .empty-row {
            color: #9ca3af;
            text-align: center;
            font-weight: 700;
        }

        .place-popup-overlay {
            position: fixed;
            inset: 0;
            z-index: 3000;
            background: rgba(0, 0, 0, 0.72);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 18px;
            box-sizing: border-box;
        }

        .place-popup-overlay.active { display: flex; }

        .place-popup-frame {
            width: min(980px, 100%);
            height: min(94vh, 920px);
            border: 0;
            border-radius: 14px;
            background: transparent;
        }

        @media (max-width: 1200px) {
            .editor-shell { grid-template-columns: 1fr 1fr; }
            .filter-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        }

        @media (max-width: 900px) {
            body { overflow: auto; }
            .wrap.place-wrap {
                height: auto;
                min-height: 0;
                overflow: visible;
            }
            .editor-shell {
                grid-template-columns: 1fr;
                overflow: visible;
            }
            .panel { min-height: 380px; }
            .panel-body { overflow: auto; }
        }
    </style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
<%
    Integer lowStockTotalCount = (Integer) request.getAttribute("lowStockTotalCount");
    if (lowStockTotalCount == null) lowStockTotalCount = 0;
    
	@SuppressWarnings("unchecked")
    Map<String, List<String>> categoryMaterialMap = (Map<String, List<String>>) request.getAttribute("categoryMaterialMap");
    if (categoryMaterialMap == null) categoryMaterialMap = new java.util.LinkedHashMap<>();

    Object draftAttr = request.getAttribute("draft");
    String draftJson = new com.google.gson.Gson().toJson(
        draftAttr != null ? draftAttr : new dto.branch.place_order.PlaceOrderDraftDTO()
    );
    String categoryJson = new com.google.gson.Gson().toJson(categoryMaterialMap);
%>
<script type="application/json" id="categoryMaterialJson"><%=categoryJson%></script>
</head>

<body>
<div class="zl-app">
    <%@ include file="/branch/common/layout/sidebar.jsp" %>
    <div class="zl-content">
        <div class="wrap p-6 place-wrap">
            <div class="page-head">
                <div>
                    <h1 class="page-title">발주서 작성</h1>
                    <p class="page-sub">좌측에서 발주할 품목을 확인하고 우측의 발주서에 추가해 전송하세요.</p>
                </div>
            </div>

            <div class="editor-shell">
                <section class="panel" aria-label="품목 탐색">
                    <div class="panel-head">
                        <div>
                            <h2 class="panel-title">전체 품목</h2>
                            <p class="panel-sub">발주할 품목을 우측의 발주서에 추가하세요</p>
                        </div>
                    </div>

                    <div class="filter-wrap">
                        <div class="filter-grid">
                            <div class="filter-group">
                                <label for="categoryFilter">카테고리</label>
                                <select id="categoryFilter" class="filter-select">
                                    <option value="">카테고리 전체</option>
                                    <%
                                    for (String categoryName : categoryMaterialMap.keySet()) {
                                    %>
                                    <option value="<%=categoryName%>"><%=categoryName%></option>
                                    <%
                                    }
                                    %>
                                </select>
                            </div>
                            <div class="filter-group">
                                <label for="itemFilter">품목명</label>
                                <select id="itemFilter" class="filter-select"></select>
                            </div>
                            <div class="filter-group">
                                <label for="searchFilter">검색</label>
                                <input id="searchFilter" class="filter-input" type="text" placeholder="품목코드, 카테고리, 품목 검색" />
                            </div>
                            <div class="filter-group">
                                <label for="lowStockOnly">재고 필터</label>
                                <div class="toggle-wrap">
                                    <input id="lowStockOnly" type="checkbox" />
                                    <span>안전재고 미달만 보기</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="panel-body">
                        <table>
                            <thead>
                            <tr>
                                <th>품목코드</th>
                                <th>품목명</th>
                                <th>카테고리</th>
                                <th>현재 재고</th>
                                <th>안전 재고</th>
                                <th>상태</th>
                                <th class="center">추가</th>
                            </tr>
                            </thead>
                            <tbody id="materialTbody"></tbody>
                        </table>
                    </div>
                </section>

                <div class="editor-divider">
                    ⇄
                </div>

                <section class="panel" aria-label="발주서 편집">
                    <div class="panel-head">
                        <div>
                            <h2 class="panel-title">발주서</h2>
                            <p class="panel-sub">요청 수량을 조정하고 추가한 품목을 삭제할 수 있습니다</p>
                        </div>

                        <div class="foot-summary" aria-label="발주 요약">
                            <span class="foot-chip">
                                안전재고 미달
                                <strong id="lowStockSummary" data-total="<%= lowStockTotalCount %>">0/0개</strong>
                            </span>

                            <span class="foot-chip">
                                그 외 품목
                                <strong id="manualSummary">0개</strong>
                            </span>
                        </div>
                    </div>

                    <div class="panel-body">
                        <table>
                            <thead>
                            <tr>
                                <th>품목코드</th>
                                <th>품목명</th>
                                <th>카테고리</th>
                                <th>현재 재고</th>
                                <th>안전 재고</th>
                                <th>요청 수량</th>
                                <th class="center">삭제</th>
                            </tr>
                            </thead>
                            <tbody id="orderTbody"></tbody>
                        </table>
                    </div>

                    <div class="panel-foot">
                        <a class="btn btn-primary open-place-popup" data-type="send" href="<%= request.getContextPath() %>/branch/place_order/send.jsp">본사 전송</a>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>

<div id="placePopupOverlay" class="place-popup-overlay" aria-hidden="true">
    <iframe id="placePopupFrame" class="place-popup-frame" title="발주 전송 팝업"></iframe>
</div>

<script type="application/json" id="draftJson"><%= draftJson %></script>
<script>
(function() {
    var itemsApiUrl = '<%= request.getContextPath() %>/api/branch/place_order/draft/items';
    var draftApiUrl = '<%= request.getContextPath() %>/api/branch/place_order/draft';

    var allMaterials = [];
    var orderItemsByCode = {};

    var selectedCategoryName = '';
    var selectedItemName = '';
    var searchText = '';
    var lowStockOnly = false;
    var searchTimer = null;

    var categoryFilter = document.getElementById('categoryFilter');
    var itemFilter = document.getElementById('itemFilter');
    var searchFilter = document.getElementById('searchFilter');
    var lowStockOnlyFilter = document.getElementById('lowStockOnly');

    var materialTbody = document.getElementById('materialTbody');
    var orderTbody = document.getElementById('orderTbody');
    var lowStockSummary = document.getElementById('lowStockSummary');
    var manualSummary = document.getElementById('manualSummary');
    var totalLowStockCount = Number((lowStockSummary && lowStockSummary.dataset && lowStockSummary.dataset.total) || 0);
    var categoryMaterialMap = JSON.parse(document.getElementById('categoryMaterialJson').textContent || '{}');

    var overlay = document.getElementById('placePopupOverlay');
    var frame = document.getElementById('placePopupFrame');

    function hasText(value) {
        return value !== null && value !== undefined && String(value).trim() !== '';
    }

    function toNumber(value) {
        var parsed = Number(value);
        return isNaN(parsed) ? 0 : parsed;
    }

    function escapeHtml(value) {
        return String(value || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function normalizeResponse(payload) {
        if (!payload) { return []; }
        if (payload.status === 'success' && Array.isArray(payload.data)) { return payload.data; }
        if (Array.isArray(payload)) { return payload; }
        if (Array.isArray(payload.data)) { return payload.data; }
        return [];
    }

    function normalizeMaterial(item) {
        var minQty = Math.max(0, toNumber(item.minQty));
        var maxQty = Math.max(0, toNumber(item.maxQty));
        if (maxQty > 0 && maxQty < minQty) {
            maxQty = minQty;
        }

        return {
            materialCode: item.materialCode,
            materialName: item.materialName || '',
            categoryName: item.categoryName || '',
            unit: item.unit || '',
            currentStock: toNumber(item.currentStock),
            safeStock: toNumber(item.safeStock),
            minQty: minQty,
            maxQty: maxQty,
            isLowStock: String(item.isLowStock) === '1' || item.isLowStock === true,
            sourceType: item.sourceType || ((String(item.isLowStock) === '1' || item.isLowStock === true) ? 'LOW_STOCK' : 'MANUAL')
        };
    }

    function normalizeOrderItem(item) {
        var normalized = normalizeMaterial(item);
        normalized.sourceType = item.sourceType || normalized.sourceType || 'MANUAL';
        normalized.requestedQty = toNumber(item.requestedQty);
        normalized.requestedQty = clampQty(normalized, normalized.requestedQty);
        return normalized;
    }

    function clampQty(item, qty) {
        var minQty = Math.max(0, toNumber(item.minQty));
        var maxQty = Math.max(0, toNumber(item.maxQty));
        var adjusted = Math.max(0, toNumber(qty));

        if (adjusted < minQty) {
            adjusted = minQty;
        }
        if (maxQty > 0 && adjusted > maxQty) {
            adjusted = maxQty;
        }
        return adjusted;
    }

    function buildOptionHtml(values) {
        return values.map(function(value) {
            return '<option value="' + escapeHtml(value) + '">' + escapeHtml(value) + '</option>';
        }).join('');
    }

    function buildMaterialOption(item, isSelected) {
        var materialName = escapeHtml(item.materialName);
        var selectedAttr = isSelected ? ' selected' : '';
        return '<option value="' + materialName + '"' + selectedAttr + '>' + materialName + '</option>';
    }

    function updateFilterItemNames() {
        var select = itemFilter;
        var categoryName = categoryFilter.value || '';
        select.innerHTML = '<option value="">품목명 전체</option>';

        (categoryMaterialMap[categoryName] || []).forEach(function(itemName) {
            var opt = document.createElement('option');
            opt.value = itemName;
            opt.textContent = itemName;
            select.appendChild(opt);
        });

        if (selectedItemName && (categoryMaterialMap[categoryName] || []).indexOf(selectedItemName) < 0) {
            selectedItemName = '';
        }
        itemFilter.value = selectedItemName;
    }

    function persistDraftChange(action, item) {
        return fetch(draftApiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ action: action, item: item })
        }).then(function(response) {
            if (!response.ok) {
                return response.json().catch(function() { return {}; }).then(function(payload) {
                    throw new Error((payload && payload.message) || '발주 임시저장 반영에 실패했습니다.');
                });
            }
            return response.json().catch(function() { return {}; });
        });
    }

    function findMaterialByCode(materialCode) {
        for (var i = 0; i < allMaterials.length; i += 1) {
            if (String(allMaterials[i].materialCode) === String(materialCode)) {
                return allMaterials[i];
            }
        }
        return null;
    }

    function getOrderList() {
        return Object.keys(orderItemsByCode).map(function(code) {
            return orderItemsByCode[code];
        });
    }

    function getLowStockAndManualLists() {
        var lowStock = [];
        var added = [];

        getOrderList().forEach(function(item) {
            if (item.sourceType === 'LOW_STOCK') {
                lowStock.push(item);
            } else {
                added.push(item);
            }
        });

        return {
            lowStock: lowStock,
            added: added
        };
    }

    function mergeOrderInfoWithLatestMaterials() {
        Object.keys(orderItemsByCode).forEach(function(code) {
            var orderItem = orderItemsByCode[code];
            var latest = findMaterialByCode(code);
            if (!latest) {
                return;
            }

            orderItem.materialName = latest.materialName;
            orderItem.categoryName = latest.categoryName;
            orderItem.unit = latest.unit;
            orderItem.currentStock = latest.currentStock;
            orderItem.safeStock = latest.safeStock;
            orderItem.minQty = latest.minQty;
            orderItem.maxQty = latest.maxQty;
            if (orderItem.sourceType !== 'MANUAL') {
                orderItem.sourceType = latest.isLowStock ? 'LOW_STOCK' : 'MANUAL';
            }
            orderItem.requestedQty = clampQty(orderItem, orderItem.requestedQty);
        });
    }

    function renderMaterialTable() {
        var filtered = allMaterials.filter(function(item) {
            if (lowStockOnly && !item.isLowStock) {
                return false;
            }
            return true;
        });

        filtered.sort(function(a, b) {
            var aAdded = !!orderItemsByCode[a.materialCode];
            var bAdded = !!orderItemsByCode[b.materialCode];
            if (aAdded !== bAdded) {
                return aAdded ? -1 : 1;
            }
            if (a.isLowStock !== b.isLowStock) {
                return a.isLowStock ? -1 : 1;
            }
            return String(a.materialName).localeCompare(String(b.materialName), 'ko');
        });

        if (!filtered.length) {
            materialTbody.innerHTML = '<tr><td class="empty-row" colspan="7">조회 결과가 없습니다.</td></tr>';
            return;
        }

        materialTbody.innerHTML = filtered.map(function(item) {
            var isAdded = !!orderItemsByCode[item.materialCode];
            var stockClass = item.isLowStock ? 'stock-low' : '';
            var statusHtml = item.isLowStock
                ? '<span class="status-low">안전재고 미달</span>'
                : '<span class="status-normal">정상</span>';
            var buttonClass = isAdded ? 'btn-add-item is-added' : 'btn-add-item';
            var buttonLabel = isAdded ? '추가됨' : '추가';
            var buttonDisabled = isAdded ? 'disabled' : '';

            return '<tr data-code="' + escapeHtml(item.materialCode) + '">' +
                '<td class="code-cell">' + escapeHtml(item.materialCode) + '</td>' +
                '<td>' + escapeHtml(item.materialName) + '</td>' +
                '<td><span class="chip">' + escapeHtml(item.categoryName) + '</span></td>' +
                '<td class="' + stockClass + '">' + item.currentStock + escapeHtml(item.unit) + '</td>' +
                '<td>' + item.safeStock + escapeHtml(item.unit) + '</td>' +
                '<td>' + statusHtml + '</td>' +
                '<td class="center"><button type="button" class="' + buttonClass + '" data-action="add" data-code="' + escapeHtml(item.materialCode) + '" ' + buttonDisabled + '>' + buttonLabel + '</button></td>' +
                '</tr>';
        }).join('');
    }

    function renderOrderTable() {
        var orderList = getOrderList();

        orderList.sort(function(a, b) {
            var aLow = a.sourceType === 'LOW_STOCK';
            var bLow = b.sourceType === 'LOW_STOCK';
            if (aLow !== bLow) {
                return aLow ? -1 : 1;
            }
            return String(a.materialName).localeCompare(String(b.materialName), 'ko');
        });

        var lowStockCount = 0;
        var manualCount = 0;

        orderList.forEach(function(item) {
            if (item.sourceType === 'LOW_STOCK') {
                lowStockCount += 1;
            } else {
                manualCount += 1;
            }
        });

        lowStockSummary.textContent = lowStockCount + '/' + totalLowStockCount + '개';
        manualSummary.textContent = manualCount + '개';

        if (!orderList.length) {
            orderTbody.innerHTML = '<tr><td class="empty-row" colspan="7">발주 품목이 없습니다.</td></tr>';
            return;
        }

        orderTbody.innerHTML = orderList.map(function(item) {
            var minQty = Math.max(0, toNumber(item.minQty));
            var maxQty = Math.max(0, toNumber(item.maxQty));
            var hasMax = maxQty > 0;
            var limitText = hasMax
                ? ('최소 ' + minQty + ' / 최대 ' + maxQty)
                : ('최소 ' + minQty);
            var stockClass = item.sourceType === 'LOW_STOCK' ? 'stock-low' : '';

            return '<tr data-code="' + escapeHtml(item.materialCode) + '">' +
                '<td class="code-cell">' + escapeHtml(item.materialCode) + '</td>' +
                '<td>' + escapeHtml(item.materialName) + '</td>' +
                '<td><span class="chip">' + escapeHtml(item.categoryName) + '</span></td>' +
                '<td class="' + stockClass + '">' + item.currentStock + escapeHtml(item.unit) + '</td>' +
                '<td>' + item.safeStock + escapeHtml(item.unit) + '</td>' +
                '<td>' +
                    '<div class="qty-cell">' +
                        '<span class="qty-input-wrap">' +
                            '<input class="qty-input" type="number" min="' + minQty + '" ' + (hasMax ? ('max="' + maxQty + '"') : '') + ' step="1" value="' + item.requestedQty + '" data-code="' + escapeHtml(item.materialCode) + '">' +
                            '<span class="unit">' + escapeHtml(item.unit) + '</span>' +
                        '</span>' +
                        '<span class="qty-limit">' + limitText + '</span>' +
                    '</div>' +
                '</td>' +
                '<td class="center"><button type="button" class="btn-remove-item" data-action="remove" data-code="' + escapeHtml(item.materialCode) + '">삭제</button></td>' +
                '</tr>';
        }).join('');
    }

    function renderAll() {
        renderMaterialTable();
        renderOrderTable();
    }

    function loadItems() {
        var params = [];

        if (selectedCategoryName) {
            params.push('category=' + encodeURIComponent(selectedCategoryName));
        }
        if (selectedItemName) {
            params.push('item=' + encodeURIComponent(selectedItemName));
        }
        if (hasText(searchText)) {
            params.push('search=' + encodeURIComponent(searchText));
        }

        var requestUrl = itemsApiUrl + (params.length ? ('?' + params.join('&')) : '');

        fetch(requestUrl, { headers: { 'Accept': 'application/json' } })
            .then(function(response) { return response.json(); })
            .then(function(payload) {
                allMaterials = normalizeResponse(payload).map(normalizeMaterial);
                mergeOrderInfoWithLatestMaterials();
                renderAll();
            })
            .catch(function() {
                allMaterials = [];
                renderAll();
                materialTbody.innerHTML = '<tr><td class="empty-row" colspan="7">데이터를 불러오지 못했습니다.</td></tr>';
            });
    }

    function initializeDraft() {
        try {
            var draftData = JSON.parse(document.getElementById('draftJson').textContent || '{}');
            var details = draftData.details || [];

            details.forEach(function(item) {
                if (!item || !item.materialCode) {
                    return;
                }
                var normalized = normalizeOrderItem(item);
                if (!normalized.requestedQty) {
                    normalized.requestedQty = clampQty(normalized, normalized.safeStock);
                }
                orderItemsByCode[normalized.materialCode] = normalized;
            });
        } catch (error) {
            orderItemsByCode = {};
        }
    }

    function openPopup(url, popupType) {
        if (!overlay || !frame || !url) {
            return;
        }

        frame.src = url;
        overlay.classList.add('active');
        overlay.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';

        frame.onload = function() {
            if (popupType !== 'send') {
                return;
            }

            frame.contentWindow.postMessage({
                type: 'init-order-data',
                data: {
                        lowStock: getLowStockAndManualLists().lowStock,
                        added: getLowStockAndManualLists().added,
                        totalLowStockCount: totalLowStockCount
                    }
            }, '*');
        };
    }

    function closePopup() {
        if (!overlay || !frame) {
            return;
        }

        overlay.classList.remove('active');
        overlay.setAttribute('aria-hidden', 'true');
        frame.src = '';
        document.body.style.overflow = '';
    }

    document.addEventListener('click', function(event) {
        var sendButton = event.target.closest('.open-place-popup');
        if (!sendButton) {
            return;
        }

        event.preventDefault();

        if (!getOrderList().length) {
            commonShowAlert('알림','발주 품목이 없습니다. 품목을 추가한 뒤 전송하세요.');
            return;
        }

        openPopup(sendButton.getAttribute('href'), sendButton.dataset.type);
    });

    materialTbody.addEventListener('click', function(event) {
        var addButton = event.target.closest('button[data-action="add"]');
        if (!addButton || addButton.disabled) {
            return;
        }

        var code = addButton.dataset.code;
        var baseMaterial = findMaterialByCode(code);
        if (!baseMaterial) {
            return;
        }

        var sourceType = baseMaterial.isLowStock ? 'LOW_STOCK' : 'MANUAL';
        var requestedQty = clampQty(baseMaterial, baseMaterial.safeStock);

        var payload = {
            materialCode: baseMaterial.materialCode,
            materialName: baseMaterial.materialName,
            categoryName: baseMaterial.categoryName,
            currentStock: baseMaterial.currentStock,
            safeStock: baseMaterial.safeStock,
            minQty: baseMaterial.minQty,
            maxQty: baseMaterial.maxQty,
            unit: baseMaterial.unit,
            sourceType: sourceType,
            requestedQty: requestedQty
        };

        persistDraftChange('add', payload)
            .then(function() {
                orderItemsByCode[code] = normalizeOrderItem(payload);
                renderAll();
            })
            .catch(function(error) {
                commonShowAlert('알림',error.message || '품목 추가에 실패했습니다.');
            });
    });

    orderTbody.addEventListener('click', function(event) {
        var removeButton = event.target.closest('button[data-action="remove"]');
        if (!removeButton) {
            return;
        }

        var code = removeButton.dataset.code;
        if (!orderItemsByCode[code]) {
            return;
        }

        persistDraftChange('remove', { materialCode: code })
            .then(function() {
                delete orderItemsByCode[code];
                renderAll();
            })
            .catch(function(error) {
                commonShowAlert('알림',error.message || '품목 삭제에 실패했습니다.');
            });
    });

    orderTbody.addEventListener('input', function(event) {
        if (!event.target.classList.contains('qty-input')) {
            return;
        }

        var input = event.target;
        var code = input.dataset.code;
        var item = orderItemsByCode[code];
        if (!item) {
            return;
        }

        var adjustedQty = clampQty(item, input.value);
        item.requestedQty = adjustedQty;
        input.value = adjustedQty;
    });

    orderTbody.addEventListener('focusout', function(event) {
        if (!event.target.classList.contains('qty-input')) {
            return;
        }

        var input = event.target;
        var code = input.dataset.code;
        var item = orderItemsByCode[code];
        if (!item) {
            return;
        }

        var adjustedQty = clampQty(item, input.value);
        item.requestedQty = adjustedQty;
        input.value = adjustedQty;

        persistDraftChange('update-qty', {
            materialCode: code,
            requestedQty: adjustedQty
        }).catch(function(error) {
            commonShowAlert('알림',error.message || '요청 수량 반영에 실패했습니다.');
        });
    });

    categoryFilter.addEventListener('change', function() {
        selectedCategoryName = categoryFilter.value || '';
        selectedItemName = '';
        updateFilterItemNames();
        loadItems();
    });

    itemFilter.addEventListener('change', function() {
        selectedItemName = itemFilter.value || '';
        loadItems();
    });

    searchFilter.addEventListener('input', function() {
        searchText = String(searchFilter.value || '').trim();
        clearTimeout(searchTimer);
        searchTimer = setTimeout(loadItems, 250);
    });

    lowStockOnlyFilter.addEventListener('change', function() {
        lowStockOnly = !!lowStockOnlyFilter.checked;
        renderMaterialTable();
    });

    if (overlay) {
        overlay.addEventListener('click', function(event) {
            if (event.target === overlay) {
                closePopup();
            }
        });
    }

    window.addEventListener('message', function(event) {
        if (!event.data || !event.data.type) {
            return;
        }

        if (event.data.type === 'close-place-popup') {
            closePopup();
        }
    });

    initializeDraft();
    updateFilterItemNames();
    loadItems();
})();
</script>
</body>
</html>
