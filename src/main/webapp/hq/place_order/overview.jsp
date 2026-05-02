<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>발주 요청 취합 및 조회 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.sidebar-open .sidebar { transform: translateX(0); }

.tab-link {
    transition: all 0.15s ease;
}

.tab-link.active {
    background: #f3f6ff;
    color: #2563eb !important;
    box-shadow: inset 0 -2px 0 #4f7dff;
}
</style>
<!-- 넘어온 데이터를 js로 반들기 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
</head>

<body class="bg-gray-50">

<%@ include file="/hq/common/sidebar.jsp"%>

<div class="lg:pl-72">
    <main class="p-6">

        <!-- ===== 페이지 헤더 ===== -->
        <div class="mb-6">
            <h2 class="text-3xl font-bold text-gray-900">발주 요청 취합 및 조회</h2>
            <p class="text-gray-500 mt-1">전체 지점의 발주 요청을 통합 관리하세요</p>
        </div>

        <!-- ===== 검색 필터 영역 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">지점 선택</label>
                    <select id="filterBranch"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">

                        <option value="전체">전체</option>

                        <c:if test="${not empty branchNames}">
                            <c:forEach var="name" items="${branchNames}">
                                <option value="${name}"
                                    <c:if test="${param.branchName == name}">selected</c:if>>
                                    ${name}
                                </option>
                            </c:forEach>
                        </c:if>

                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">일자 범위 선택</label>
                    <div class="flex items-center gap-2">
                        <input type="date" id="filterStartDate"
                            class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                        <span class="text-gray-500">~</span>
                        <input type="date" id="filterEndDate"
                            class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                    </div>
                </div>
            </div>
            <div class="flex items-center gap-2">
                <button onclick="applyFilters()"
                    class="px-6 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] font-medium transition-colors">조회하기</button>
                <button onclick="resetFilters()"
                    class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium transition-colors">초기화</button>
            </div>
        </div>

        <!-- ===== 탭 UI ===== -->
        <div class="bg-white rounded-lg border border-gray-200 mb-6 overflow-hidden">
            <div class="grid grid-cols-4 border-b border-gray-200">
                <a href="#" class="tab-link active text-center py-3 font-semibold text-gray-500" data-status="전체">
                    전체 <span id="countAll">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-yellow-500" data-status="PENDING">
                    대기 <span id="countPending" class="text-xs text-yellow-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-green-600" data-status="APPROVED">
                    승인 <span id="countApproved" class="text-xs text-green-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-red-500" data-status="REJECTED">
                    반려 <span id="countRejected" class="text-xs text-red-400">0건</span>
                </a>
            </div>
        </div>

        <!-- ===== 발주 요청 테이블 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
            <div class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                <h3 class="text-base font-semibold text-gray-900">발주 요청/이력</h3>
                <p class="text-base text-gray-500">조회 건수 <span id="recordCount" class="font-semibold text-gray-700">0건</span></p>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">발주서 번호</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">요청 지점</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">요청 일시</th>
                            <th class="text-right  py-3 px-6 text-sm font-semibold text-gray-900">품목 수</th>
                            <th class="text-right  py-3 px-6 text-sm font-semibold text-gray-900">총 수량</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상태</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상세조회</th>
                        </tr>
                    </thead>
                    <tbody id="orderTableBody"></tbody>
                </table>
            </div>
            <div id="emptyState" class="hidden py-12 text-center">
                <i class="fas fa-folder-open text-4xl text-gray-300 mx-auto mb-4" style="display: block;"></i>
                <p class="text-gray-500 text-lg mb-2">발주 요청이 없습니다</p>
                <p class="text-gray-400 text-sm">선택한 필터 조건에 해당하는 발주가 없습니다</p>
            </div>

            <!-- 페이지네이션 -->
            <div id="pagination" class="px-6 py-4 bg-gray-50 border-t border-gray-200 flex items-center justify-between hidden">
                <button onclick="previousPage()" id="prevBtn"
                    class="inline-flex items-center gap-2 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 transition-colors disabled:opacity-50">
                    <i class="fas fa-chevron-left"></i> 이전
                </button>
                <p class="text-sm text-gray-500">
                    <span id="currentPageNum">1</span> / <span id="totalPageNum">1</span>
                </p>
                <button onclick="nextPage()" id="nextBtn"
                    class="inline-flex items-center gap-2 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-100 transition-colors disabled:opacity-50">
                    다음 <i class="fas fa-chevron-right"></i>
                </button>
            </div>
        </div>

    </main>
</div>

<!-- ===== 상세정보 모달 ===== -->
<div id="detailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-2xl w-full p-6 max-h-[90vh] overflow-y-auto">

        <!-- 모달 헤더 -->
        <div class="flex items-center justify-between mb-6">
            <div>
                <h3 class="text-xl font-bold text-gray-900">발주서 상세 정보</h3>
                <p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
            </div>
            <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-6 h-6"></i>
            </button>
        </div>

        <!-- 기본 정보 그리드 -->
        <div class="grid grid-cols-2 gap-4 mb-6 bg-gray-50 rounded-lg p-4">
            <div><p class="text-sm text-gray-500">발주서 번호</p> <p class="font-semibold text-gray-900 mt-1" id="detailOrderNumber"></p></div>
            <div><p class="text-sm text-gray-500">요청 지점</p>   <p class="font-semibold text-gray-900 mt-1" id="detailBranch"></p></div>
            <div><p class="text-sm text-gray-500">요청 일시</p>   <p class="font-semibold text-gray-900 mt-1" id="detailDate"></p></div>
            <div><p class="text-sm text-gray-500">상태</p>        <div id="detailStatus" class="mt-1"></div></div>
            <div><p class="text-sm text-gray-500">품목 수</p>     <p class="font-semibold text-gray-900 mt-1" id="detailItemCount"></p></div>
            <div><p class="text-sm text-gray-500">총 요청 수량</p><p class="font-semibold text-blue-600 mt-1" id="detailTotalQty"></p></div>
        </div>

        <!-- 발주 품목 테이블 -->
        <div>
            <h4 class="font-semibold text-gray-900 mb-3">발주 품목 상세</h4>
            <div class="overflow-x-auto border border-gray-200 rounded-lg">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">품목명</th>
                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">요청 수량</th>
                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">현재 재고</th>
                        </tr>
                    </thead>
                    <tbody id="itemsTableBody"></tbody>
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
        'PENDING':  { label: '대기', badgeClass: 'bg-yellow-100 text-yellow-700', rowClass: 'bg-yellow-50' },
        'APPROVED': { label: '승인', badgeClass: 'bg-green-100 text-green-700',  rowClass: '' },
        'REJECTED': { label: '반려', badgeClass: 'bg-red-100 text-red-700',      rowClass: 'bg-red-50' },
        'default':  { label: '-',   badgeClass: 'bg-gray-100 text-gray-700',     rowClass: '' }
    };

    // ============================================================
    // 전역 상태
    // ============================================================
    var allOrders      = [];
    var filteredOrders = [];
    var currentStatusFilter = '전체';
    var currentPage    = 1;
    var itemsPerPage   = 10;

    // ============================================================
    // 사이드바 / 네비게이션
    // ============================================================
    function toggleSidebar() {
        var sidebar  = document.getElementById('sidebar');
        var backdrop = document.getElementById('sidebarBackdrop');
        var menuIcon = document.getElementById('menuIcon');
        if (!sidebar || !backdrop || !menuIcon) return;

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
    // 날짜 기본값 (이번달 1일 ~ 오늘)
    // ============================================================
    function initDateRange() {
		var today = new Date();

		var mm = String(today.getMonth() + 1).padStart(2, '0');
		var dd = String(today.getDate()).padStart(2, '0');
		var yyyy = today.getFullYear();
		var firstDay = yyyy + '-' + mm + '-01';
		var todayStr = yyyy + '-' + mm + '-' + dd;
		document.getElementById('filterStartDate').value = firstDay;
		document.getElementById('filterEndDate').value = todayStr;
    }

    // ============================================================
    // 탭 / 상태 관리
    // ============================================================
    document.querySelectorAll('.tab-link').forEach(function(tab) {
        tab.addEventListener('click', function(e) {
            e.preventDefault();
            currentStatusFilter = this.getAttribute('data-status');
            updateActiveTab();
            applyStatusFilter();
        });
    });

    function updateActiveTab() {
        document.querySelectorAll('.tab-link').forEach(function(tab) {
            if (tab.getAttribute('data-status') === currentStatusFilter) {
                tab.classList.add('active');
            } else {
                tab.classList.remove('active');
            }
        });
    }

    function applyStatusFilter() {
        filteredOrders = (currentStatusFilter === '전체')
            ? allOrders
            : allOrders.filter(function(o) { return o.status === currentStatusFilter; });
        currentPage = 1;
        renderTable();
    }

    function updateStatusCounts() {
        var counts = { PENDING: 0, APPROVED: 0, REJECTED: 0 };
        allOrders.forEach(function(o) { if (o.status in counts) counts[o.status]++; });
        document.getElementById('countAll').textContent      = allOrders.length + '건';
        document.getElementById('countPending').textContent  = counts.PENDING   + '건';
        document.getElementById('countApproved').textContent = counts.APPROVED  + '건';
        document.getElementById('countRejected').textContent = counts.REJECTED  + '건';
    }

    // ============================================================
    // 데이터 조회 (API)
    // ============================================================
    async function applyFilters() {
        console.log("🔥 applyFilters 실행됨");
        var params = new URLSearchParams({
            branchName:    document.getElementById('filterBranch').value,
            startDate: document.getElementById('filterStartDate').value,
            endDate:   document.getElementById('filterEndDate').value
        });

        try {
            // 요청
            var res = await fetch('<%=request.getContextPath()%>/api/hq/place_order/overview?' + params);
            if (!res.ok) {
                var errData = await res.json();
                throw new Error(errData.message || 'HTTP ' + res.status);
            }
            // 응답
            var result = await res.json();
            console.log(result.data);
            if (!result || result.status != 'success') throw new Error((result && result.message) || '데이터 오류');

            allOrders = result.data || [];
            filteredOrders = (currentStatusFilter === '전체')
                ? allOrders
                : allOrders.filter(function(o) { return o.status === currentStatusFilter; });

        } catch (err) {
            console.error('발주 요청 조회 실패:', err);
            allOrders      = [];
            filteredOrders = [];
        }

        currentPage = 1;
        renderTable();
        updateStatusCounts();
        updateActiveTab();
    }

    function resetFilters() {
        document.getElementById('filterBranch').value = '전체';
        initDateRange();
        currentStatusFilter = '전체';
        updateActiveTab();
        applyFilters();
    }

    // ============================================================
    // 테이블 렌더링
    // ============================================================
    function renderTable() {
        var tbody      = document.getElementById('orderTableBody');
        var emptyState = document.getElementById('emptyState');
        var pagination = document.getElementById('pagination');
        tbody.innerHTML = '';

        document.getElementById('recordCount').textContent = filteredOrders.length + '건';

        if (filteredOrders.length === 0) {
            emptyState.classList.remove('hidden');
            pagination.classList.add('hidden');
            return;
        }

        emptyState.classList.add('hidden');

        var start      = (currentPage - 1) * itemsPerPage;
        var pageOrders = filteredOrders.slice(start, start + itemsPerPage);

        pageOrders.forEach(function(order) {
            var meta = STATUS_CONFIG[order.status] || STATUS_CONFIG['default'];
            var tr   = document.createElement('tr');
            tr.className = 'border-b border-gray-100 hover:bg-gray-50 ' + meta.rowClass;
            tr.innerHTML =
                '<td class="py-4 px-6 font-mono text-sm text-blue-600">' + order.poNo + '</td>' +
                '<td class="py-4 px-6 font-medium text-gray-900"><i class="fas fa-map-pin text-gray-400 mr-2"></i>' + order.branchName + '</td>' +
                '<td class="py-4 px-6 text-gray-700 text-sm"><i class="fas fa-calendar text-gray-400 mr-2"></i>' + order.requestedAt + '</td>' +
                '<td class="py-4 px-6 text-right font-semibold text-gray-900">' + order.totalItemCnt + '개</td>' +
                '<td class="py-4 px-6 text-right font-semibold text-blue-600">' + order.totalAmounts + '</td>' +
                '<td class="py-4 px-6 text-center"><span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ' + meta.badgeClass + '">' + meta.label + '</span></td>' +
                '<td class="py-4 px-6 text-center"><button onclick="openDetail(\'' + order.poId + '\')" class="inline-flex items-center gap-1 px-3 py-1.5 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 transition-colors"><i class="fas fa-eye"></i>상세조회</button></td>';
            tbody.appendChild(tr);
        });

        // 페이지네이션
        var totalPages = Math.ceil(filteredOrders.length / itemsPerPage);
        if (totalPages > 1) {
            pagination.classList.remove('hidden');
            document.getElementById('currentPageNum').textContent = currentPage;
            document.getElementById('totalPageNum').textContent   = totalPages;
            document.getElementById('prevBtn').disabled = (currentPage === 1);
            document.getElementById('nextBtn').disabled = (currentPage === totalPages);
        } else {
            pagination.classList.add('hidden');
        }
    }

    function previousPage() {
        if (currentPage > 1) { currentPage--; renderTable(); window.scrollTo(0, 0); }
    }
    function nextPage() {
        if (currentPage < Math.ceil(filteredOrders.length / itemsPerPage)) { currentPage++; renderTable(); window.scrollTo(0, 0); }
    }

    // ============================================================
    // 상세정보 모달
    // ============================================================
    async function openDetail(orderId) {
        var tbody = document.getElementById('itemsTableBody');
        tbody.innerHTML = '<tr><td colspan="3" class="py-8 text-center text-gray-500">로딩 중...</td></tr>';
        document.getElementById('detailModal').classList.remove('hidden');

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/place_order/overview/' + encodeURIComponent(orderId));
            if (!res.ok) throw new Error('API 실패: ' + res.status);

            var json   = await res.json();
            var data   = json.data;
            var meta   = STATUS_CONFIG[data.status] || STATUS_CONFIG['default'];

            // 기본 정보
            document.getElementById('modalSubtitle').textContent    = data.branchName + ' · ' + data.poNo;
            document.getElementById('detailOrderNumber').textContent = data.poNo;
            document.getElementById('detailBranch').textContent      = data.branchName;
            document.getElementById('detailDate').textContent        = data.requestedAt;
            document.getElementById('detailItemCount').textContent   = data.totalItemCnt + '개';
            document.getElementById('detailTotalQty').textContent    = data.totalAmounts;

            // 품목 목록
            var items = data.items || [];
            if (items.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3" class="py-8 text-center text-gray-500">품목 정보가 없습니다</td></tr>';
                return;
            }

            tbody.innerHTML = '';
            items.forEach(function(item) {
                var stockColor = (item.currentStock < item.safetyStock) ? 'text-red-600' : 'text-green-600';
                var tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100';
                tr.innerHTML =
                    '<td class="py-3 px-4 text-gray-900">' + item.materialName + '</td>' +
                    '<td class="py-3 px-4 text-right font-semibold text-blue-600">' + item.requestedQty + item.unit + '</td>' +
                    '<td class="py-3 px-4 text-right font-semibold ' + stockColor + '">' + item.currentStock + item.unit + '</td>';
                tbody.appendChild(tr);
            });

        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="3" class="py-8 text-center text-red-500">데이터를 불러오지 못했습니다: ' + err.message + '</td></tr>';
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
        initDateRange();
        updateActiveTab();
        applyFilters();
    });
</script>
</body>
</html>
