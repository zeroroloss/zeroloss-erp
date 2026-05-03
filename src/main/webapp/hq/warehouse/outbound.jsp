<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>본사 물류창고 출고 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.sidebar-open .sidebar { transform: translateX(0); }
.tab-link { transition: all 0.15s ease; }
.tab-link.active {
    background: #f3f6ff;
    color: #2563eb !important;
    box-shadow: inset 0 -2px 0 #4f7dff;
}
</style>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
</head>
<body class="bg-gray-50">

<%@ include file="/hq/common/sidebar.jsp"%>

<div class="lg:pl-72">
    <main class="p-6">

        <!-- ===== 페이지 헤더 ===== -->
        <div class="mb-6">
            <h2 class="text-3xl font-bold text-gray-900">본사 물류창고 출고</h2>
            <p class="text-gray-500 mt-1">지점 발주 요청에 대한 출고 내역을 확인하세요</p>
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
                <a href="#" class="tab-link text-center py-3 font-semibold text-blue-500" data-status="출고대기">
                    출고대기 <span id="countWaiting" class="text-xs text-blue-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-yellow-500" data-status="준비중">
                    준비중 <span id="countPreparing" class="text-xs text-yellow-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-green-600" data-status="출고완료">
                    출고완료 <span id="countCompleted" class="text-xs text-green-400">0건</span>
                </a>
            </div>
        </div>

        <!-- ===== 출고 목록 테이블 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
            <div class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                <h3 class="text-base font-semibold text-gray-900">출고 이력 리스트</h3>
                <p class="text-base text-gray-500">조회 건수 <span id="recordCount" class="font-semibold text-gray-700">0건</span></p>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">발주서 번호</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">지점</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">일시</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">처리자</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상태</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상세조회</th>
                        </tr>
                    </thead>
                    <tbody id="outboundTableBody"></tbody>
                </table>
            </div>
            <div id="emptyState" class="hidden py-12 text-center">
                <i class="fas fa-box text-4xl text-gray-300 mx-auto mb-4" style="display: block;"></i>
                <p class="text-gray-500 text-lg mb-2">조회 결과가 없습니다</p>
                <p class="text-gray-400 text-sm">선택한 필터 조건에 해당하는 출고 내역이 없습니다</p>
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

<!-- ===== 상세보기 모달 ===== -->
<div id="detailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-4xl w-full p-6 max-h-[90vh] overflow-y-auto">

        <!-- 모달 헤더 -->
        <div class="flex items-center justify-between mb-6">
            <div>
                <h3 class="text-xl font-bold text-gray-900">발주/출고 상세보기</h3>
                <p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
            </div>
            <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-6 h-6"></i>
            </button>
        </div>

        <!-- 기본 정보 그리드 -->
        <div class="grid grid-cols-2 gap-4 mb-6 bg-gray-50 rounded-lg p-4">
            <div><p class="text-sm text-gray-500">발주서 번호</p>  <p class="font-mono text-blue-600 mt-1"     id="detailOrderId"></p></div>
            <div><p class="text-sm text-gray-500">지점</p>         <p class="font-semibold text-gray-900 mt-1" id="detailBranch"></p></div>
            <div><p class="text-sm text-gray-500">일시</p>         <p class="text-gray-900 mt-1"               id="detailDate"></p></div>
            <div><p class="text-sm text-gray-500">처리자</p>       <p class="text-gray-900 mt-1"               id="detailHandler"></p></div>
            <div><p class="text-sm text-gray-500">상태</p>         <div id="detailStatus" class="mt-1"></div></div>
        </div>

        <!-- 품목 테이블 -->
        <div>
            <h4 class="font-semibold text-gray-900 mb-3" id="itemsTitle">품목 상세</h4>
            <div class="overflow-x-auto border border-gray-200 rounded-lg">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr id="itemsTableHeader"></tr>
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
        '출고대기': { label: '출고대기', badgeClass: 'bg-blue-100 text-blue-700',    icon: 'fa-box' },
        '준비중':   { label: '준비중',   badgeClass: 'bg-yellow-100 text-yellow-700', icon: 'fa-hourglass-half' },
        '출고완료': { label: '출고완료', badgeClass: 'bg-green-100 text-green-700',   icon: 'fa-check-circle' },
        'default':  { label: '-',       badgeClass: 'bg-gray-100 text-gray-700',     icon: 'fa-circle' }
    };

    // ============================================================
    // 전역 상태
    // ============================================================
    var allRecords          = [];
    var filteredRecords     = [];
    var currentStatusFilter = '전체';
    var currentPage         = 1;
    var itemsPerPage        = 10;

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
        var mm    = String(today.getMonth() + 1).padStart(2, '0');
        var dd    = String(today.getDate()).padStart(2, '0');
        var yyyy  = today.getFullYear();
        document.getElementById('filterStartDate').value = yyyy + '-' + mm + '-01';
        document.getElementById('filterEndDate').value   = yyyy + '-' + mm + '-' + dd;
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
        filteredRecords = (currentStatusFilter === '전체')
            ? allRecords
            : allRecords.filter(function(r) { return r.status === currentStatusFilter; });
        currentPage = 1;
        renderTable();
    }

    function updateStatusCounts() {
        var counts = { '출고대기': 0, '준비중': 0, '출고완료': 0 };
        allRecords.forEach(function(r) { if (r.status in counts) counts[r.status]++; });
        document.getElementById('countAll').textContent       = allRecords.length + '건';
        document.getElementById('countWaiting').textContent   = counts['출고대기'] + '건';
        document.getElementById('countPreparing').textContent = counts['준비중']   + '건';
        document.getElementById('countCompleted').textContent = counts['출고완료'] + '건';
    }

    // ============================================================
    // 데이터 조회 (API)
    // ============================================================
    async function applyFilters() {
        var params = new URLSearchParams({
            branchName: document.getElementById('filterBranch').value,
            startDate:  document.getElementById('filterStartDate').value,
            endDate:    document.getElementById('filterEndDate').value
        });

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/outbound?' + params);

            if (!res.ok) {
                let errMsg = 'HTTP ' + res.status;
                try {
                    const errData = await res.json();
                    errMsg = errData.message || errMsg;
                } catch (e) {}
                throw new Error(errMsg);
            }

            var result = await res.json();
            if (!result || result.status != 'success') {
                throw new Error((result && result.message) || '데이터 오류');
            }

            allRecords = result.data || [];

        } catch (err) {
            console.error('출고 목록 조회 실패:', err);
            allRecords = [];   // ⭐ 여기만 바꿈 (UI는 공통 처리)
        }

        currentPage = 1;
        applyStatusFilter();
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
        var tbody       = document.getElementById('outboundTableBody');
        var emptyState  = document.getElementById('emptyState');
        var pagination  = document.getElementById('pagination');
        tbody.innerHTML = '';

        document.getElementById('recordCount').textContent = filteredRecords.length + '건';

        if (filteredRecords.length === 0) {
            emptyState.classList.remove('hidden');
            pagination.classList.add('hidden');
            return;
        }

        emptyState.classList.add('hidden');

        var start       = (currentPage - 1) * itemsPerPage;
        var pageRecords = filteredRecords.slice(start, start + itemsPerPage);

        pageRecords.forEach(function(record) {
            var meta = STATUS_CONFIG[record.status] || STATUS_CONFIG['default'];
            var tr   = document.createElement('tr');
            tr.className = 'border-b border-gray-100 hover:bg-gray-50';
            tr.innerHTML =
                '<td class="py-4 px-6 font-mono text-sm text-blue-600">'    + record.poNo      + '</td>' +
                '<td class="py-4 px-6 font-medium text-gray-900"><i class="fas fa-map-pin text-gray-400 mr-2"></i>' + record.branchName  + '</td>' +
                '<td class="py-4 px-6 text-gray-700 text-sm"><i class="fas fa-calendar text-gray-400 mr-2"></i>'   + record.shippedAt  + '</td>' +
                '<td class="py-4 px-6 text-gray-700 text-sm">'              + (record.handler || '-') + '</td>' +
                '<td class="py-4 px-6 text-center"><span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium ' + meta.badgeClass + '"><i class="fas ' + meta.icon + '"></i>' + meta.label + '</span></td>' +
                '<td class="py-4 px-6 text-center"><button onclick="openDetail(\'' + record.hqOutboundNo + '\')" class="inline-flex items-center gap-1 px-3 py-1.5 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 transition-colors"><i class="fas fa-eye"></i>상세조회</button></td>';
            tbody.appendChild(tr);
        });

        // 페이지네이션
        var totalPages = Math.ceil(filteredRecords.length / itemsPerPage);
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
        var totalPages = Math.ceil(filteredRecords.length / itemsPerPage);
        if (currentPage < totalPages) {
            currentPage++; renderTable(); window.scrollTo(0, 0); 
        }
    }

    // ============================================================
    // 상세보기 모달
    // ============================================================
    async function openDetail(outboundId) {
        var tbody = document.getElementById('itemsTableBody');
        tbody.innerHTML = '<tr><td colspan="6" class="py-8 text-center text-gray-500">로딩 중...</td></tr>';
        document.getElementById('detailModal').classList.remove('hidden');

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/outbound/' + encodeURIComponent(outboundId));
            if (!res.ok) throw new Error('API 실패: ' + res.status);

            var json        = await res.json();
            var data        = json.data;
            var meta        = STATUS_CONFIG[data.status] || STATUS_CONFIG['default'];
            var isCompleted = (data.status === '출고완료');

            // 기본 정보
            document.getElementById('modalSubtitle').textContent  = data.branchName + ' · ' + data.poNo;
            document.getElementById('detailOrderId').textContent  = data.poNo;
            document.getElementById('detailBranch').textContent   = data.branchName;
            document.getElementById('detailDate').textContent     = data.outboundAt;
            document.getElementById('detailHandler').textContent  = data.handler || '-';
            document.getElementById('detailStatus').innerHTML =
                '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium ' + meta.badgeClass + '"><i class="fas ' + meta.icon + '"></i>' + meta.label + '</span>';

            // 품목 테이블 헤더
            document.getElementById('itemsTitle').textContent = isCompleted ? '출고 품목' : '발주 품목';
            document.getElementById('itemsTableHeader').innerHTML =
                '<th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">품목코드</th>'       +
                '<th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">품목명</th>'         +
                '<th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">카테고리</th>'       +
                '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">발주 요청 수량</th>' +
                '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">출고 수량</th>'      +
                (!isCompleted ? '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">창고 재고</th>' : '');

            // 품목 목록
            var items = data.items || [];
            if (items.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="py-8 text-center text-gray-500">품목 정보가 없습니다</td></tr>';
                return;
            }

            tbody.innerHTML = '';
            items.forEach(function(item) {
                var isInsufficient = !isCompleted && (item.warehouseStock < item.requestedQty);
                var tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100' + (isInsufficient ? ' bg-red-50' : '');
                var rowHtml =
                    '<td class="py-3 px-4 font-mono text-sm text-gray-600">' + item.itemCode + '</td>' +
                    '<td class="py-3 px-4 font-medium text-gray-900">'       + item.itemName + '</td>' +
                    '<td class="py-3 px-4 text-sm"><span class="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">' + item.category + '</span></td>' +
                    '<td class="py-3 px-4 text-right font-semibold text-blue-600">'  + item.requestedQty + item.unit + '</td>' +
                    '<td class="py-3 px-4 text-right font-semibold text-green-600">' + (item.confirmedQty != null ? item.confirmedQty : item.requestedQty) + item.unit + '</td>';
                if (!isCompleted) {
                    var stockClass = isInsufficient ? 'text-red-600' : 'text-green-600';
                    rowHtml += '<td class="py-3 px-4 text-right font-semibold ' + stockClass + '">' + item.warehouseStock + item.unit + '</td>';
                }
                tr.innerHTML = rowHtml;
                tbody.appendChild(tr);
            });

        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="6" class="py-8 text-center text-red-500">데이터를 불러오지 못했습니다: ' + err.message + '</td></tr>';
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