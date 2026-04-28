<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>재고 현황 및 품목별 총 재고</title>
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

        .split-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .panel { background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; }
        .panel-head { padding: 14px 14px 10px; border-bottom: 1px solid #eef2f7; }
        .panel-title { margin: 0; font-size: 17px; font-weight: 800; color: #111827; }
        .panel-sub { margin: 6px 0 0; font-size: 12px; color: #6b7280; }

        .sort-row { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 10px; }
        .sort-btn { border: 1px solid #d1d5db; background: #fff; color: #374151; border-radius: 999px; padding: 6px 10px; font-size: 12px; font-weight: 700; cursor: pointer; }
        .sort-btn.active { border-color: #1d4ed8; background: #dbeafe; color: #1e40af; }

        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 12px; border-bottom: 1px solid #eef2f7; text-align: left; font-size: 13px; white-space: nowrap; }
        th { background: #f8fafc; color: #374151; font-weight: 700; }
        .right { text-align: right; }

        .badge { display: inline-block; padding: 3px 8px; border-radius: 999px; font-size: 11px; font-weight: 700; }
        .badge-exp-urgent { background: #fee2e2; color: #b91c1c; }
        .badge-exp-warning { background: #ffedd5; color: #c2410c; }
        .badge-exp-safe { background: #dcfce7; color: #166534; }
        .badge-stock-lack { background: #fee2e2; color: #b91c1c; }
        .badge-stock-warn { background: #fef3c7; color: #92400e; }
        .badge-stock-ok { background: #dcfce7; color: #166534; }

        .empty { padding: 24px 14px; text-align: center; color: #6b7280; font-size: 13px; }

        @media (max-width: 1200px) {
            .split-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 900px) {
            .filters { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 640px) {
            .filters { grid-template-columns: 1fr; }
            .btn { height: 38px; }
        }
    </style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
</head>
<body>
<div class="zl-app">
<%@ include file="/branch/common/layout/sidebar.jsp" %>
<div class="zl-content">
<%@ include file="/branch/common/layout/topbar.jsp" %>
<div class="wrap p-6">
    <div class="page-header">
        <h1 class="page-title">재고 현황</h1>
        <p class="page-sub">좌측은 유통기한 기준 재고 현황, 우측은 품목별 총 재고(안전재고 기준)입니다.</p>
    </div>

    <div class="filter-card">
        <div class="filters">
            <select id="categoryFilter" class="filter-select">
                <option value="">카테고리 전체</option>
            </select>
            <select id="itemFilter" class="filter-select">
                <option value="">품목 전체</option>
            </select>
            <input id="searchInput" class="filter-input" type="text" placeholder="재고 번호 또는 품목명 검색" />
            <div style="display:flex; gap:8px;">
                <button type="button" class="btn btn-primary" onclick="applyFilters()">조회하기</button>
                <button type="button" class="btn btn-muted" onclick="resetFilters()">초기화</button>
            </div>
        </div>
    </div>

    <div class="split-grid">
        <section class="panel" aria-label="재고 현황">
            <div class="panel-head">
                <h2 class="panel-title">재고 현황</h2>
                <p class="panel-sub">상태는 유통기한 기준으로 긴급 / 주의 / 안전으로 표시됩니다.</p>
                <div class="sort-row">
                    <button type="button" id="sortReceivedBtn" class="sort-btn active">입고 시점 오름차순</button>
                    <button type="button" id="sortExpireBtn" class="sort-btn">유통기한 오름차순</button>
                </div>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>재고 번호</th>
                            <th>카테고리</th>
                            <th>품목명</th>
                            <th>입고 시점</th>
                            <th class="right">현재 수량</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody id="inventoryTableBody"></tbody>
                </table>
                <div id="inventoryEmpty" class="empty" style="display:none;">조회 결과가 없습니다.</div>
            </div>
        </section>

        <section class="panel" aria-label="품목별 총 재고">
            <div class="panel-head">
                <h2 class="panel-title">품목별 총 재고</h2>
                <p class="panel-sub">전체 품목을 조회하며 상태는 안전재고 기준으로 부족 / 경고 / 정상으로 표시됩니다.</p>
            </div>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>재고 번호</th>
                            <th>카테고리</th>
                            <th>품목명</th>
                            <th>입고 시점</th>
                            <th class="right">현재 수량</th>
                            <th class="right">안전재고</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody id="totalStockTableBody"></tbody>
                </table>
                <div id="totalStockEmpty" class="empty" style="display:none;">조회 결과가 없습니다.</div>
            </div>
        </section>
    </div>
</div>
</main>
</div>
</div>

<script>
(function () {
    var stockData = [
        { stockNo: 'INV-2024-001', category: '단백질', itemName: '치킨 스트립', receivedAt: '2026-03-20 17:26', expireDate: '2026-03-30', currentQty: 45, safetyQty: 50, unit: 'kg' },
        { stockNo: 'INV-2024-002', category: '소스', itemName: '랜치 소스', receivedAt: '2026-03-25 17:26', expireDate: '2026-03-31', currentQty: 8, safetyQty: 15, unit: 'L' },
        { stockNo: 'INV-2024-003', category: '야채', itemName: '양상추', receivedAt: '2026-03-26 17:26', expireDate: '2026-04-01', currentQty: 8, safetyQty: 20, unit: 'kg' },
        { stockNo: 'INV-2024-004', category: '치즈', itemName: '아메리칸 치즈', receivedAt: '2026-03-24 08:50', expireDate: '2026-04-02', currentQty: 30, safetyQty: 25, unit: 'kg' },
        { stockNo: 'INV-2024-005', category: '야채', itemName: '토마토', receivedAt: '2026-03-26 09:40', expireDate: '2026-04-03', currentQty: 15, safetyQty: 10, unit: 'kg' },
        { stockNo: 'INV-2024-006', category: '빵류', itemName: '허니오트 빵', receivedAt: '2026-03-27 11:10', expireDate: '2026-04-05', currentQty: 80, safetyQty: 150, unit: '개' },
        { stockNo: 'INV-2024-007', category: '음료', itemName: '탄산음료', receivedAt: '2026-02-15 13:00', expireDate: '2026-08-15', currentQty: 3, safetyQty: 10, unit: '박스' },
        { stockNo: 'INV-2024-008', category: '소스', itemName: '올리브 오일', receivedAt: '2026-03-01 10:25', expireDate: '2027-03-01', currentQty: 5, safetyQty: 15, unit: 'L' },
        { stockNo: 'INV-2024-009', category: '쿠키', itemName: '초콜릿칩 쿠키', receivedAt: '2026-03-10 14:05', expireDate: '2027-03-10', currentQty: 120, safetyQty: 100, unit: '개' },
        { stockNo: 'INV-2024-010', category: '야채', itemName: '오이', receivedAt: '2026-03-15 16:45', expireDate: '2026-04-15', currentQty: 15, safetyQty: 50, unit: 'kg' }
    ];

    var filteredStock = stockData.slice();
    var sortState = { field: 'receivedAt', direction: 'asc' };

    var categoryFilter = document.getElementById('categoryFilter');
    var itemFilter = document.getElementById('itemFilter');
    var searchInput = document.getElementById('searchInput');
    var inventoryTableBody = document.getElementById('inventoryTableBody');
    var inventoryEmpty = document.getElementById('inventoryEmpty');
    var totalStockTableBody = document.getElementById('totalStockTableBody');
    var totalStockEmpty = document.getElementById('totalStockEmpty');
    var sortReceivedBtn = document.getElementById('sortReceivedBtn');
    var sortExpireBtn = document.getElementById('sortExpireBtn');

    function parseDate(dateTimeText) {
        return new Date(String(dateTimeText).replace(' ', 'T'));
    }

    function getExpiryStatus(expireDate) {
        var today = new Date('2026-03-29T00:00:00');
        var target = parseDate(expireDate + ' 00:00:00');
        var days = Math.ceil((target.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));

        if (days <= 3) {
            return { label: '긴급', className: 'badge-exp-urgent', rank: 0 };
        }
        if (days <= 7) {
            return { label: '주의', className: 'badge-exp-warning', rank: 1 };
        }
        return { label: '안전', className: 'badge-exp-safe', rank: 2 };
    }

    function getSafetyStatus(currentQty, safetyQty) {
        if (safetyQty <= 0) {
            return { label: '정상', className: 'badge-stock-ok', rank: 2 };
        }

        var ratio = currentQty / safetyQty;
        if (ratio < 0.7) {
            return { label: '부족', className: 'badge-stock-lack', rank: 0 };
        }
        if (ratio < 1) {
            return { label: '경고', className: 'badge-stock-warn', rank: 1 };
        }
        return { label: '정상', className: 'badge-stock-ok', rank: 2 };
    }

    function formatQty(value, unit) {
        return value + unit;
    }

    function escapeHtml(value) {
        return String(value == null ? '' : value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function buildFilterOptions() {
        var categories = {};
        var items = {};

        stockData.forEach(function (row) {
            categories[row.category] = true;
            items[row.itemName] = true;
        });

        Object.keys(categories).sort().forEach(function (category) {
            categoryFilter.insertAdjacentHTML('beforeend', '<option value="' + escapeHtml(category) + '">' + escapeHtml(category) + '</option>');
        });
        Object.keys(items).sort().forEach(function (itemName) {
            itemFilter.insertAdjacentHTML('beforeend', '<option value="' + escapeHtml(itemName) + '">' + escapeHtml(itemName) + '</option>');
        });
    }

    function applyCurrentFilters() {
        var category = categoryFilter.value;
        var itemName = itemFilter.value;
        var keyword = searchInput.value.trim().toLowerCase();

        filteredStock = stockData.filter(function (row) {
            if (category && row.category !== category) {
                return false;
            }
            if (itemName && row.itemName !== itemName) {
                return false;
            }
            if (keyword) {
                var haystack = (row.stockNo + ' ' + row.itemName).toLowerCase();
                if (haystack.indexOf(keyword) < 0) {
                    return false;
                }
            }
            return true;
        });
    }

    function sortInventoryRows(rows) {
        var sorted = rows.slice();
        var multiplier = sortState.direction === 'asc' ? 1 : -1;

        sorted.sort(function (a, b) {
            var av;
            var bv;

            if (sortState.field === 'expireDate') {
                av = parseDate(a.expireDate + ' 00:00:00').getTime();
                bv = parseDate(b.expireDate + ' 00:00:00').getTime();
            } else {
                av = parseDate(a.receivedAt).getTime();
                bv = parseDate(b.receivedAt).getTime();
            }

            if (av === bv) {
                return a.stockNo.localeCompare(b.stockNo) * multiplier;
            }
            return (av - bv) * multiplier;
        });

        return sorted;
    }

    function aggregateByItem(rows) {
        var map = {};

        rows.forEach(function (row) {
            var key = row.category + '|' + row.itemName;
            if (!map[key]) {
                map[key] = {
                    stockNo: row.stockNo,
                    category: row.category,
                    itemName: row.itemName,
                    receivedAt: row.receivedAt,
                    currentQty: 0,
                    safetyQty: 0,
                    unit: row.unit
                };
            }

            map[key].currentQty += row.currentQty;
            map[key].safetyQty += row.safetyQty;

            if (parseDate(row.receivedAt).getTime() > parseDate(map[key].receivedAt).getTime()) {
                map[key].receivedAt = row.receivedAt;
                map[key].stockNo = row.stockNo;
            }
        });

        return Object.keys(map).map(function (key) { return map[key]; }).sort(function (a, b) {
            var statusDiff = getSafetyStatus(a.currentQty, a.safetyQty).rank - getSafetyStatus(b.currentQty, b.safetyQty).rank;
            if (statusDiff !== 0) {
                return statusDiff;
            }
            return a.itemName.localeCompare(b.itemName);
        });
    }

    function renderInventoryTable() {
        var rows = sortInventoryRows(filteredStock);

        inventoryTableBody.innerHTML = '';
        if (rows.length === 0) {
            inventoryEmpty.style.display = 'block';
            return;
        }

        inventoryEmpty.style.display = 'none';
        rows.forEach(function (row) {
            var expiryStatus = getExpiryStatus(row.expireDate);
            inventoryTableBody.insertAdjacentHTML('beforeend',
                '<tr>' +
                    '<td>' + escapeHtml(row.stockNo) + '</td>' +
                    '<td>' + escapeHtml(row.category) + '</td>' +
                    '<td>' + escapeHtml(row.itemName) + '</td>' +
                    '<td>' + escapeHtml(row.receivedAt) + '</td>' +
                    '<td class="right">' + escapeHtml(formatQty(row.currentQty, row.unit)) + '</td>' +
                    '<td><span class="badge ' + expiryStatus.className + '">' + expiryStatus.label + '</span></td>' +
                '</tr>'
            );
        });
    }

    function renderTotalStockTable() {
        var rows = aggregateByItem(filteredStock);

        totalStockTableBody.innerHTML = '';
        if (rows.length === 0) {
            totalStockEmpty.style.display = 'block';
            return;
        }

        totalStockEmpty.style.display = 'none';
        rows.forEach(function (row) {
            var safetyStatus = getSafetyStatus(row.currentQty, row.safetyQty);
            totalStockTableBody.insertAdjacentHTML('beforeend',
                '<tr>' +
                    '<td>' + escapeHtml(row.stockNo) + '</td>' +
                    '<td>' + escapeHtml(row.category) + '</td>' +
                    '<td>' + escapeHtml(row.itemName) + '</td>' +
                    '<td>' + escapeHtml(row.receivedAt) + '</td>' +
                    '<td class="right">' + escapeHtml(formatQty(row.currentQty, row.unit)) + '</td>' +
                    '<td class="right">' + escapeHtml(formatQty(row.safetyQty, row.unit)) + '</td>' +
                    '<td><span class="badge ' + safetyStatus.className + '">' + safetyStatus.label + '</span></td>' +
                '</tr>'
            );
        });
    }

    function syncSortButtons() {
        var receivedText = '입고 시점 ' + (sortState.field === 'receivedAt' && sortState.direction === 'asc' ? '오름차순' : sortState.field === 'receivedAt' ? '내림차순' : '오름차순');
        var expireText = '유통기한 ' + (sortState.field === 'expireDate' && sortState.direction === 'asc' ? '오름차순' : sortState.field === 'expireDate' ? '내림차순' : '오름차순');

        sortReceivedBtn.textContent = receivedText;
        sortExpireBtn.textContent = expireText;
        sortReceivedBtn.classList.toggle('active', sortState.field === 'receivedAt');
        sortExpireBtn.classList.toggle('active', sortState.field === 'expireDate');
    }

    function renderAll() {
        applyCurrentFilters();
        syncSortButtons();
        renderInventoryTable();
        renderTotalStockTable();
    }

    window.applyFilters = function () {
        renderAll();
    };

    window.resetFilters = function () {
        categoryFilter.value = '';
        itemFilter.value = '';
        searchInput.value = '';
        sortState = { field: 'receivedAt', direction: 'asc' };
        renderAll();
    };

    sortReceivedBtn.addEventListener('click', function () {
        if (sortState.field === 'receivedAt') {
            sortState.direction = sortState.direction === 'asc' ? 'desc' : 'asc';
        } else {
            sortState.field = 'receivedAt';
            sortState.direction = 'asc';
        }
        renderAll();
    });

    sortExpireBtn.addEventListener('click', function () {
        if (sortState.field === 'expireDate') {
            sortState.direction = sortState.direction === 'asc' ? 'desc' : 'asc';
        } else {
            sortState.field = 'expireDate';
            sortState.direction = 'asc';
        }
        renderAll();
    });

    buildFilterOptions();
    renderAll();
})();
</script>
</body>
</html>