<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>본사 물류창고 재고 조회 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.sidebar-open .sidebar { transform: translateX(0); }
</style>
<script>
	const categoryMaterialMap = JSON.parse('${categoryMaterialMapJson}');
</script>
</head>
<body class="bg-gray-50">

<%@ include file="/hq/common/sidebar.jsp"%>

<div class="lg:pl-72">
    <main class="p-6">

        <!-- ===== 페이지 헤더 ===== -->
        <div class="mb-6">
            <h2 class="text-3xl font-bold text-gray-900">본사 물류창고 재고 조회</h2>
            <p class="text-gray-500 mt-1">현재고와 변동이력을 함께 확인하세요</p>
        </div>

        <!-- ===== 검색 필터 영역 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">카테고리</label>
                    <select id="filterCategory" onchange="updateStockItemNames()"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
					    <option value="전체">전체</option>
					</select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">품목명</label>
                    <select id="filterItemName"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                        <option value="전체">전체</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">검색</label>
                    <input type="text" id="filterSearch" placeholder="재고코드, 카테고리, 품목 검색"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                </div>
            </div>
            <div class="flex items-center gap-2">
                <button onclick="applyFilters()"
                    class="px-6 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] font-medium transition-colors">조회하기</button>
                <button onclick="resetFilters()"
                    class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium transition-colors">초기화</button>
            </div>
        </div>

        <!-- ===== 상태 필터 버튼 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
            <div class="flex flex-wrap gap-3" id="statusFilterButtons">
                <button type="button" data-status="전체" onclick="setStatusFilter('전체')"
                    class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-gray-300 text-sm font-medium text-gray-700 hover:bg-gray-50">
                    전체 <span id="countAll" class="text-xs text-gray-500">0건</span>
                </button>
                <button type="button" data-status="AVAILABLE" onclick="setStatusFilter('AVAILABLE')"
                    class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-green-200 text-sm font-medium text-green-700 hover:bg-green-50">
                    사용 가능 <span id="countAvailable" class="text-xs text-green-600">0건</span>
                </button>
                <button type="button" data-status="OUT_OF_STOCK" onclick="setStatusFilter('OUT_OF_STOCK')"
                    class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-yellow-200 text-sm font-medium text-yellow-700 hover:bg-yellow-50">
                    재고 없음 <span id="outOfStockCount" class="text-xs text-yellow-600">0건</span>
                </button>
                <button type="button" data-status="DISPOSED" onclick="setStatusFilter('DISPOSED')"
                    class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-red-200 text-sm font-medium text-red-700 hover:bg-red-50">
                    폐기됨 <span id="countDisposed" class="text-xs text-red-600">0건</span>
                </button>
            </div>
        </div>

        <!-- ===== 재고 테이블 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
            <div class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                <h3 class="text-base font-semibold text-gray-900">본사 물류창고 재고 리스트</h3>
                <p class="text-base text-gray-500">조회 건수 <span id="recordCount" class="font-semibold text-gray-700">0건</span></p>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left   py-4 px-6 text-sm font-semibold text-gray-900">재고코드</th>
                            <th class="text-left   py-4 px-6 text-sm font-semibold text-gray-900">카테고리</th>
                            <th class="text-left   py-4 px-6 text-sm font-semibold text-gray-900">품목명</th>
                            <th class="text-right  py-4 px-6 text-sm font-semibold text-gray-900">현재 재고</th>
                            <th class="text-left   py-4 px-6 text-sm font-semibold text-gray-900">입고 시점</th>
                            <th class="text-center py-4 px-6 text-sm font-semibold text-gray-900">상태</th>
                            <th class="text-center py-4 px-6 text-sm font-semibold text-gray-900">상세정보</th>
                        </tr>
                    </thead>
                    <tbody id="stockTableBody"></tbody>
                </table>
            </div>
            <div id="emptyState" class="hidden py-12 text-center">
                <i class="fas fa-boxes-stacked w-16 h-16 text-gray-300 mx-auto mb-4"></i>
                <p class="text-gray-500 text-lg mb-2">조회 결과가 없습니다</p>
                <p class="text-gray-400 text-sm">다른 조건으로 검색해보세요</p>
            </div>
        </div>

    </main>
</div>

<!-- ===== 상세정보 모달 ===== -->
<div id="detailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-4xl w-full p-6 max-h-[90vh] overflow-y-auto">

        <!-- 모달 헤더 -->
        <div class="flex items-center justify-between mb-6">
            <div>
                <h3 class="text-xl font-bold text-gray-900">재고 상세 정보</h3>
                <p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
            </div>
            <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-6 h-6"></i>
            </button>
        </div>

        <!-- 기본 정보 그리드 -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6 bg-gray-50 rounded-lg p-4">
            <div><p class="text-sm text-gray-500">재고코드</p>   <p class="font-semibold text-gray-900" id="detailStockCode"></p></div>
            <div><p class="text-sm text-gray-500">재료코드</p>   <p class="font-semibold text-gray-900" id="detailMaterialCode"></p></div>
            <div><p class="text-sm text-gray-500">재료명</p>     <p class="font-semibold text-gray-900" id="detailMaterialName"></p></div>
            <div><p class="text-sm text-gray-500">현재 재고</p>  <p class="font-semibold text-gray-900" id="detailQty"></p></div>
            <div><p class="text-sm text-gray-500">입고시점</p>   <p class="font-semibold text-gray-900" id="detailReceivedAt"></p></div>
            <div><p class="text-sm text-gray-500">유통기한</p>   <p class="font-semibold text-gray-900" id="detailExpiryDate"></p></div>
        </div>

        <!-- 변동 이력 테이블 -->
        <div>
            <h4 class="font-semibold text-gray-900 mb-3">변동 이력</h4>
            <div class="overflow-x-auto border border-gray-200 rounded-lg">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">시점</th>
                            <th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">유형</th>
                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">변동량</th>
                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">변동 후 재고</th>
                        </tr>
                    </thead>
                    <tbody id="movementTableBody"></tbody>
                </table>
            </div>
        </div>

        <div class="flex justify-end mt-6">
            <button onclick="closeDetailModal()"
                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">닫기</button>
        </div>
    </div>
</div>

<script>
    // ============================================================
    // 상수 / 설정
    // ============================================================
    var STATUS_CONFIG = {
        'AVAILABLE':    { label: '사용 가능', badgeClass: 'bg-green-100 text-green-700',   btnClass: 'bg-green-50 border-green-200 text-green-700' },
        'OUT_OF_STOCK': { label: '재고 없음', badgeClass: 'bg-yellow-100 text-yellow-700', btnClass: 'bg-yellow-50 border-yellow-200 text-yellow-700' },
        'DISPOSED':     { label: '폐기됨',   badgeClass: 'bg-red-100 text-red-700',       btnClass: 'bg-red-50 border-red-200 text-red-700' },
        'default':      { label: '-',       badgeClass: 'bg-gray-100 text-gray-700',      btnClass: 'bg-gray-50 border-gray-300 text-gray-700' }
    };

    var CHANGE_TYPE_CONFIG = {
        'INBOUND':  { label: '입고', colorClass: 'text-green-700 bg-green-50' },
        'OUTBOUND': { label: '출고', colorClass: 'text-red-700 bg-red-50' },
        'ADJUST':   { label: '조정', colorClass: 'text-amber-700 bg-amber-50' },
        'DISPOSAL': { label: '폐기', colorClass: 'text-red-700 bg-red-50' }
    };

    // ============================================================
    // 전역 상태
    // ============================================================
    var allStocks = [];
    var filteredStocks = [];
    var currentStatusFilter = '전체';

    // ============================================================
    // 사이드바 / 네비게이션
    // ============================================================
    function toggleSidebar() {
        var sidebar  = document.getElementById('sidebar');
        var backdrop = document.getElementById('sidebarBackdrop');
        var menuIcon = document.getElementById('menuIcon');
        sidebar.classList.toggle('-translate-x-full');
        backdrop.classList.toggle('hidden');
        var isOpen = !backdrop.classList.contains('hidden');
        menuIcon.classList.toggle('fa-bars', !isOpen);
        menuIcon.classList.toggle('fa-xmark', isOpen);
    }

    function toggleMenu(button) {
        var submenu = button.nextElementSibling;
        if (submenu && submenu.classList.contains('submenu')) {
            submenu.classList.toggle('hidden');
            var icon = button.querySelector('i:last-child');
            icon.classList.toggle('fa-chevron-down');
            icon.classList.toggle('fa-chevron-right');
        }
    }

    function toggleUserMenu() { document.getElementById('userMenu').classList.toggle('hidden'); }

    function logout() {
        alert('로그아웃되었습니다.');
        window.location.href = '<%=request.getContextPath()%>/common/login.jsp';
    }

    document.getElementById('sidebarBackdrop').addEventListener('click', toggleSidebar);

    document.addEventListener('click', function(e) {
        if (!e.target.closest('button[onclick="toggleUserMenu()"]') && !e.target.closest('#userMenu')) {
            document.getElementById('userMenu').classList.add('hidden');
        }
    });

    // ============================================================
    // 필터 / 상태 관리
    // ============================================================
    function initCategoryOptions() {
        var select = document.getElementById('filterCategory');

        // 기존 옵션 초기화 (전체만 유지)
        select.innerHTML = '<option value="전체">전체</option>';

        Object.keys(categoryMaterialMap || {}).forEach(function(category) {
            var opt = document.createElement('option');
            opt.value = category;
            opt.textContent = category;
            select.appendChild(opt);
        });	
	}
    	
    function getStatusMeta(status) {
        return STATUS_CONFIG[status] || STATUS_CONFIG['default'];
    }

    function updateStockItemNames() {
        var select   = document.getElementById('filterItemName');
        var category = document.getElementById('filterCategory').value;
        select.innerHTML = '<option value="전체">전체</option>';
        (categoryMaterialMap[category] || []).forEach(function(item) {
            var opt = document.createElement('option');
            opt.value = item;
            opt.textContent = item;
            select.appendChild(opt);
        });
    }

    function setStatusFilter(status) {
        currentStatusFilter = status;
        updateStatusButtonStyles();
        applyFilters();
    }

    function updateStatusButtonStyles() {
        document.querySelectorAll('.status-filter-btn').forEach(function(btn) {
            var status   = btn.getAttribute('data-status');
            var isActive = (status == currentStatusFilter);
            btn.className = 'status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border text-sm font-medium';
            if (isActive) {
                btn.className += (status == '전체')
                    ? ' bg-gray-900 text-white border-gray-900'
                    : ' ' + getStatusMeta(status).btnClass;
            } else {
                btn.className += ' border-gray-300 text-gray-700 hover:bg-gray-50';
            }
        });
    }

    function updateStatusCounts() {
        var counts = { AVAILABLE: 0, OUT_OF_STOCK: 0, DISPOSED: 0 };
        allStocks.forEach(function(s) { if (s.status in counts) counts[s.status]++; });
        document.getElementById('countAll').textContent        = allStocks.length + '건';
        document.getElementById('countAvailable').textContent  = counts.AVAILABLE + '건';
        document.getElementById('outOfStockCount').textContent = counts.OUT_OF_STOCK + '건';
        document.getElementById('countDisposed').textContent   = counts.DISPOSED + '건';
    }

    function resetFilters() {
        document.getElementById('filterSearch').value   = '';
        document.getElementById('filterCategory').value = '전체';
        updateStockItemNames();
        document.getElementById('filterItemName').value = '전체';
        currentStatusFilter = '전체';
        applyFilters();
    }

    // ============================================================
    // 데이터 조회 (API)
    // ============================================================
    async function applyFilters() {
        var params = new URLSearchParams({
            categoryName: document.getElementById('filterCategory').value,
            itemName:     document.getElementById('filterItemName').value,
            keyword:      document.getElementById('filterSearch').value.trim()
        });

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/stock?' + params);
            if (!res.ok) {
                var errData = await res.json();
                throw new Error(errData.message || 'HTTP ' + res.status);
            }
            var result = await res.json();
            if (!result || result.status != 'success') throw new Error((result && result.message) || '데이터 오류');

            allStocks = result.data || [];
            filteredStocks = (currentStatusFilter == '전체')
                ? allStocks
                : allStocks.filter(function(s) { return s.status == currentStatusFilter; });

        } catch (err) {
            allStocks = [];
            filteredStocks = [];
        }

        renderTable();
        updateStatusCounts();
        updateStatusButtonStyles();
        document.getElementById('recordCount').textContent = filteredStocks.length + '건';
    }

    // ============================================================
    // 테이블 렌더링
    // ============================================================
    function renderTable() {
        var tbody   = document.getElementById('stockTableBody');
        tbody.innerHTML = '';
        var isEmpty = (filteredStocks.length == 0);
        document.getElementById('emptyState').classList.toggle('hidden', !isEmpty);
        if (isEmpty) { document.getElementById('recordCount').textContent = '0건'; return; }

        filteredStocks.forEach(function(stock) {
            var meta = getStatusMeta(stock.status);
            var qty  = (stock.currentQty != null) ? stock.currentQty : 0;
            var unit = stock.unit || '';
            var tr   = document.createElement('tr');
            tr.className = 'border-b border-gray-100 hover:bg-gray-50';
            tr.innerHTML =
                '<td class="py-4 px-6 text-sm text-gray-900 font-mono">' + stock.stockNo + '</td>' +
                '<td class="py-4 px-6 text-sm text-gray-600"><span class="px-2 py-0.5 rounded bg-gray-100">' + stock.category + '</span></td>' +
                '<td class="py-4 px-6 text-sm font-medium text-gray-900">' + stock.materialName + '</td>' +
                '<td class="py-4 px-6 text-right text-sm font-semibold text-gray-900">' + qty + ' ' + unit + '</td>' +
                '<td class="py-4 px-6 text-sm text-gray-600">' + stock.receivedAt + '</td>' +
                '<td class="py-4 px-6 text-center"><span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ' + meta.badgeClass + '">' + meta.label + '</span></td>' +
                '<td class="py-4 px-6 text-center"><button onclick="openDetail(\'' + stock.stockNo + '\')" class="px-3 py-1.5 text-sm text-[#00853D] hover:bg-green-50 rounded-lg transition-colors">상세정보</button></td>';
            tbody.appendChild(tr);
        });
    }

    // ============================================================
    // 상세정보 모달
    // ============================================================
    async function openDetail(stockNo) {
        var tbody = document.getElementById('movementTableBody');
        tbody.innerHTML = '<tr><td colspan="4" class="py-8 text-center text-gray-500">로딩 중...</td></tr>';
        document.getElementById('detailModal').classList.remove('hidden');

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/stock/' + encodeURIComponent(stockNo));
            if (!res.ok) throw new Error('API 실패: ' + res.status);

            var json = await res.json();
            var data = json.data;

            // 기본 정보 채우기
            document.getElementById('detailStockCode').textContent    = data.stockNo;
            document.getElementById('detailMaterialCode').textContent = data.materialCode;
            document.getElementById('detailMaterialName').textContent = data.materialName;
            document.getElementById('detailQty').textContent          = data.currentQty + ' ' + data.unit;
            document.getElementById('detailReceivedAt').textContent   = data.receivedAt;
            document.getElementById('detailExpiryDate').textContent   = data.expiryDate;
            document.getElementById('modalSubtitle').textContent      = data.category + ' · ' + data.materialName;

            // 변동 이력 렌더링
            var movements = data.movements;
            if (!movements || !movements.length) {
                tbody.innerHTML = '<tr><td colspan="4" class="py-8 text-center text-gray-500">이력이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = '';
            var unit = data.unit ? ' ' + data.unit : '';

            movements.forEach(function(c) {
                var typeCfg     = CHANGE_TYPE_CONFIG[c.changeType] || { label: c.changeType, colorClass: 'text-gray-700 bg-gray-50' };
                var amount      = Number((c.changeAmount != null) ? c.changeAmount : 0);
                var afterQty    = (c.afterQty != null) ? c.afterQty : 0;
                var changedAt   = c.changedAt || '-';
                var isInbound   = (c.changeType == 'INBOUND');
                var isDecrease  = (c.changeType == 'OUTBOUND' || c.changeType == 'DISPOSAL');
                var signed      = isInbound  ? '+' + Math.abs(amount)
                                : isDecrease ? '-' + Math.abs(amount)
                                : (amount >= 0 ? '+' + amount : String(amount));
                var amountColor = isInbound  ? 'text-green-700'
                                : isDecrease ? 'text-red-700'
                                : 'text-amber-700';

                var tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100';
                tr.innerHTML =
                    '<td class="py-3 px-4 text-base text-gray-800">' + changedAt + '</td>' +
                    '<td class="py-3 px-4 text-base"><span class="inline-flex items-center px-2 py-0.5 rounded font-semibold ' + typeCfg.colorClass + '">' + typeCfg.label + '</span></td>' +
                    '<td class="py-3 px-4 text-base text-right font-semibold ' + amountColor + '">' + signed + unit + '</td>' +
                    '<td class="py-3 px-4 text-base text-right text-gray-800 font-medium">' + afterQty + unit + '</td>';
                tbody.appendChild(tr);
            });

        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="4" class="py-8 text-center text-red-500">데이터를 불러오지 못했습니다: ' + err.message + '</td></tr>';
        }
    }

    function closeDetailModal() {
        document.getElementById('detailModal').classList.add('hidden');
    }

    document.getElementById('detailModal').addEventListener('click', function(e) {
        if (e.target == this) closeDetailModal();
    });

    // ============================================================
    // 초기화
    // ============================================================
    window.addEventListener('DOMContentLoaded', function() {
    	initCategoryOptions();
        updateStockItemNames();
        applyFilters();
    });
</script>
</body>
</html>
