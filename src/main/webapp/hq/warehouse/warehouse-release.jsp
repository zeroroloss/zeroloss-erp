<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>본사 물류창고 출고 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar {
            transform: translateX(0);
        }
    </style>
</head>
<body class="bg-gray-50">
	    <%@ include file="/hq/common/sidebar.jsp" %>
        <!-- 메인 콘텐츠 -->
        <div class="lg:pl-72">

            <!-- 페이지 콘텐츠 -->
            <main class="p-6">
                <!-- 헤더 -->
                <div class="mb-6">
                    <h2 class="text-3xl font-bold text-gray-900">본사 물류창고 출고</h2>
                    <p class="text-gray-500 mt-1">지점 발주 요청에 따라 출고 처리를 진행하세요</p>
                </div>

                <!-- 필터 -->
                <div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- 지점 선택 -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">지점 선택</label>
                            <select id="filterBranch" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                                <option value="전체">전체</option>
                                <option value="강남점">강남점</option>
                                <option value="홍대점">홍대점</option>
                                <option value="신촌점">신촌점</option>
                                <option value="이대점">이대점</option>
                            </select>
                        </div>

                        <!-- 일자 범위 -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">일자 범위</label>
                            <div class="flex items-center gap-2">
                                <input type="date" id="filterStartDate" value="2026-03-01" class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                                <span class="text-gray-500">~</span>
                                <input type="date" id="filterEndDate" value="2026-04-05" class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                            </div>
                        </div>
                    </div>

                    <div class="flex items-center gap-2 mt-4">
                        <button onclick="applyFilters()" class="px-6 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] font-medium transition-colors">
                            조회하기
                        </button>
                        <button onclick="resetFilters()" class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium transition-colors">
                            초기화
                        </button>
                    </div>
                </div>

                <!-- 상태 버튼 -->
                <div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
                    <div class="flex flex-wrap gap-3" id="statusFilterButtons">
                        <button type="button" data-status="전체" onclick="setStatusFilter('전체')" class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-gray-300 text-sm font-medium text-gray-700 hover:bg-gray-50">
                            전체 <span id="countAll" class="text-xs text-gray-500">0건</span>
                        </button>
                        <button type="button" data-status="출고대기" onclick="setStatusFilter('출고대기')" class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-blue-200 bg-blue-50 text-sm font-medium text-blue-700">
                            출고대기 <span id="countWaiting" class="text-xs text-blue-600">0건</span>
                        </button>
                        <button type="button" data-status="준비중" onclick="setStatusFilter('준비중')" class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-yellow-200 text-sm font-medium text-yellow-700 hover:bg-yellow-50">
                            준비중 <span id="countPreparing" class="text-xs text-yellow-600">0건</span>
                        </button>
                        <button type="button" data-status="출고 완료" onclick="setStatusFilter('출고 완료')" class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-green-200 text-sm font-medium text-green-700 hover:bg-green-50">
                            출고완료 <span id="countCompleted" class="text-xs text-green-600">0건</span>
                        </button>
                    </div>
                </div>

                <!-- 목록 -->
                <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50 border-b border-gray-200">
                                <tr>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">발주서 번호</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">지점</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">일시</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">처리자</th>
                                    <th class="text-center py-4 px-6 text-sm font-semibold text-gray-900">상태</th>
                                    <th class="text-center py-4 px-6 text-sm font-semibold text-gray-900">작업</th>
                                </tr>
                            </thead>
                            <tbody id="releaseTableBody">
                                <!-- 동적으로 생성됨 -->
                            </tbody>
                        </table>
                    </div>

                    <div id="emptyState" class="hidden py-12 text-center">
                        <i class="fas fa-box w-12 h-12 mx-auto mb-3 text-gray-400"></i>
                        <p class="text-gray-500">조회 결과가 없습니다</p>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- 상세보기 모달 -->
    <div id="detailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-lg max-w-4xl w-full p-6 max-h-[90vh] overflow-y-auto">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h3 class="text-xl font-bold text-gray-900">발주/출고 상세보기</h3>
                    <p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
                </div>
                <button onclick="closeDetailModal()" class="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                    <i class="fas fa-times w-5 h-5 text-gray-500"></i>
                </button>
            </div>

            <div class="bg-gray-50 rounded-lg p-4 mb-6">
                <h4 class="font-semibold text-gray-900 mb-3" id="orderInfoTitle"></h4>
                <div class="grid grid-cols-2 gap-4" id="orderInfoContent">
                    <!-- 동적으로 생성됨 -->
                </div>
            </div>

            <div class="mb-6">
                <h4 class="font-semibold text-gray-900 mb-3" id="itemsTitle"></h4>
                <div class="border border-gray-200 rounded-lg overflow-hidden">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                            <tr id="itemsTableHeader">
                                <!-- 동적으로 생성됨 -->
                            </tr>
                        </thead>
                        <tbody id="itemsTableBody">
                            <!-- 동적으로 생성됨 -->
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="flex justify-end">
                <button onclick="closeDetailModal()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                    닫기
                </button>
            </div>
        </div>
    </div>

    <script>
        // 전역 상태
        let releaseOrders = [];
        let releaseHistory = [];
        let currentStatusFilter = '전체';

        // Mock 데이터
        const mockReleaseOrders = [
            { id: "ro1", orderId: "PO-2026-0329-001", branch: "강남점", orderDate: "2026-03-29", status: "출고대기", items: [
                { itemCode: "MEAT-001", itemName: "소고기 패티", category: "육류", requestedQty: 55, confirmedQty: 50, unit: "개", warehouseStock: 250 },
                { itemCode: "VEG-001", itemName: "감자", category: "채소", requestedQty: 85, confirmedQty: 85, unit: "kg", warehouseStock: 180 },
                { itemCode: "DAIRY-001", itemName: "생크림", category: "유제품", requestedQty: 18, confirmedQty: 15, unit: "L", warehouseStock: 65 },
                { itemCode: "VEG-002", itemName: "양상추", category: "채소", requestedQty: 27, confirmedQty: 27, unit: "kg", warehouseStock: 50 }
            ]},
            { id: "ro2", orderId: "PO-2026-0329-002", branch: "홍대점", orderDate: "2026-03-29", status: "준비중", items: [
                { itemCode: "BREAD-001", itemName: "버거빵", category: "빵류", requestedQty: 80, unit: "개", warehouseStock: 650 },
                { itemCode: "DAIRY-002", itemName: "체다치즈", category: "유제품", requestedQty: 25, unit: "장", warehouseStock: 120 },
                { itemCode: "SAUCE-001", itemName: "식용유", category: "조미료", requestedQty: 15, unit: "L", warehouseStock: 45 }
            ]},
            { id: "ro3", orderId: "PO-2026-0329-003", branch: "신촌점", orderDate: "2026-03-29", status: "출고대기", items: [
                { itemCode: "MEAT-001", itemName: "소고기 패티", category: "육류", requestedQty: 45, confirmedQty: 45, unit: "개", warehouseStock: 250 },
                { itemCode: "VEG-003", itemName: "토마토", category: "채소", requestedQty: 20, confirmedQty: 20, unit: "kg", warehouseStock: 80 }
            ]},
            { id: "ro4", orderId: "PO-2026-0329-004", branch: "이대점", orderDate: "2026-03-29", status: "재고부족", items: [
                { itemCode: "VEG-002", itemName: "양상추", category: "채소", requestedQty: 50, unit: "kg", warehouseStock: 30 }
            ]}
        ];

        const mockReleaseHistory = [
            { id: "rh1", releaseDate: "2026-03-28 14:30", orderId: "PO-2026-0328-001", branch: "강남점", handler: "김철수", status: "출고 완료", items: [
                { itemCode: "MEAT-001", itemName: "소고기 패티", category: "육류", requestedQty: 100, confirmedQty: 100, unit: "개" },
                { itemCode: "VEG-002", itemName: "양상추", category: "채소", requestedQty: 35, confirmedQty: 30, unit: "kg" }
            ]},
            { id: "rh2", releaseDate: "2026-03-28 11:20", orderId: "PO-2026-0328-002", branch: "홍대점", handler: "이영희", status: "출고 완료", items: [
                { itemCode: "DAIRY-001", itemName: "생크림", category: "유제품", requestedQty: 25, confirmedQty: 25, unit: "L" },
                { itemCode: "DAIRY-002", itemName: "체다치즈", category: "유제품", requestedQty: 40, confirmedQty: 40, unit: "장" }
            ]},
            { id: "rh3", releaseDate: "2026-03-27 16:00", orderId: "PO-2026-0327-001", branch: "신촌점", handler: "박민수", status: "출고 완료", items: [
                { itemCode: "VEG-001", itemName: "감자", category: "채소", requestedQty: 70, confirmedQty: 70, unit: "kg" },
                { itemCode: "VEG-003", itemName: "토마토", category: "채소", requestedQty: 25, confirmedQty: 25, unit: "kg" },
                { itemCode: "BREAD-001", itemName: "버거빵", category: "빵류", requestedQty: 150, confirmedQty: 150, unit: "개" }
            ]}
        ];

        // 사이드바 토글
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const backdrop = document.getElementById('sidebarBackdrop');
            const menuIcon = document.getElementById('menuIcon');
            
            sidebar.classList.toggle('-translate-x-full');
            backdrop.classList.toggle('hidden');
            
            if (backdrop.classList.contains('hidden')) {
                menuIcon.classList.remove('fa-xmark');
                menuIcon.classList.add('fa-bars');
            } else {
                menuIcon.classList.remove('fa-bars');
                menuIcon.classList.add('fa-xmark');
            }
        }

        // 메뉴 토글
        function toggleMenu(button) {
            const submenu = button.nextElementSibling;
            const icon = button.querySelector('i:last-child');
            
            if (submenu && submenu.classList.contains('submenu')) {
                submenu.classList.toggle('hidden');
                icon.classList.toggle('fa-chevron-down');
                icon.classList.toggle('fa-chevron-right');
            }
        }

        // 사용자 메뉴 토글
        function toggleUserMenu() {
            document.getElementById('userMenu').classList.toggle('hidden');
        }

        // 로그아웃
        function logout() {
            alert('로그아웃되었습니다.');
            window.location.href = '<%= request.getContextPath() %>/common/login.jsp';
        }

        // 백드롭 클릭 시 사이드바 닫기
        document.getElementById('sidebarBackdrop').addEventListener('click', toggleSidebar);

        function getUnifiedReleaseList() {
            return releaseOrders.map(order => ({
                id: order.id,
                orderId: order.orderId,
                branch: order.branch,
                date: order.orderDate,
                status: order.status,
                handler: '-',
                items: order.items,
                type: 'order'
            })).concat(releaseHistory.map(history => ({
                id: history.id,
                orderId: history.orderId,
                branch: history.branch,
                date: history.releaseDate,
                status: history.status,
                handler: history.handler,
                items: history.items,
                type: 'history'
            })));
        }

        function setStatusFilter(status) {
            currentStatusFilter = status;
            updateStatusButtonStyles();
            renderReleaseTable();
        }

        function updateStatusButtonStyles() {
            document.querySelectorAll('.status-filter-btn').forEach(button => {
                const status = button.getAttribute('data-status');
                button.classList.remove('bg-blue-50', 'bg-yellow-50', 'bg-green-50', 'border-blue-200', 'border-yellow-200', 'border-green-200', 'text-blue-700', 'text-yellow-700', 'text-green-700');
                button.classList.remove('border-[#00853D]', 'bg-[#00853D]', 'text-white');
                button.classList.add('border-gray-300', 'text-gray-700');

                if (status === currentStatusFilter) {
                    if (status === '전체') {
                        button.classList.add('bg-gray-900', 'text-white', 'border-gray-900');
                    } else if (status === '출고대기') {
                        button.classList.add('bg-blue-50', 'border-blue-200', 'text-blue-700');
                    } else if (status === '준비중') {
                        button.classList.add('bg-yellow-50', 'border-yellow-200', 'text-yellow-700');
                    } else if (status === '출고 완료') {
                        button.classList.add('bg-green-50', 'border-green-200', 'text-green-700');
                    }
                }
            });
        }

        function getFilteredReleaseList() {
            const branch = document.getElementById('filterBranch').value;
            const startDate = new Date(document.getElementById('filterStartDate').value);
            const endDate = new Date(document.getElementById('filterEndDate').value);
            const unifiedList = getUnifiedReleaseList();
            
            return unifiedList.filter(record => {
                const matchBranch = branch === '전체' || record.branch === branch;
                const matchStatus = currentStatusFilter === '전체' || record.status === currentStatusFilter;
                const recordDate = new Date(record.date.split(' ')[0]);
                const matchDate = recordDate >= startDate && recordDate <= endDate;
                return matchBranch && matchStatus && matchDate;
            });
        }

        function renderReleaseTable() {
            const filtered = getFilteredReleaseList();
            const tbody = document.getElementById('releaseTableBody');
            tbody.innerHTML = '';

            if (filtered.length === 0) {
                document.getElementById('emptyState').classList.remove('hidden');
                return;
            }

            document.getElementById('emptyState').classList.add('hidden');

            filtered.forEach(record => {
                const isCompleted = record.status === '출고 완료';
                const statusBadgeHtml = isCompleted
                    ? '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700"><i class="fas fa-check-circle w-3 h-3"></i>출고완료</span>'
                    : record.status === '준비중'
                        ? '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-700"><i class="fas fa-hourglass-half w-3 h-3"></i>준비중</span>'
                        : '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700"><i class="fas fa-box w-3 h-3"></i>출고대기</span>';

                const tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100 hover:bg-gray-50';
                tr.innerHTML = '<td class="py-4 px-6 font-mono text-sm text-blue-600">' + record.orderId + '</td>' +
                    '<td class="py-4 px-6 font-medium text-gray-900"><div class="flex items-center gap-2"><i class="fas fa-map-pin w-4 h-4 text-gray-400"></i>' + record.branch + '</div></td>' +
                    '<td class="py-4 px-6 text-gray-700 text-sm"><div class="flex items-center gap-2"><i class="fas fa-calendar w-4 h-4 text-gray-400"></i>' + record.date + '</div></td>' +
                    '<td class="py-4 px-6 text-gray-700 text-sm">' + (record.handler || '-') + '</td>' +
                    '<td class="py-4 px-6 text-center">' + statusBadgeHtml + '</td>' +
                    '<td class="py-4 px-6 text-center"><button onclick="showDetailModal(' + '\'' + record.id + '\'' + ')" class="inline-flex items-center gap-2 px-3 py-1.5 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 transition-colors"><i class="fas fa-eye w-4 h-4"></i>상세보기</button></td>';
                tbody.appendChild(tr);
            });
        }

        // 상세보기 모달
        function showDetailModal(id) {
            const order = releaseOrders.find(o => o.id === id);
            const history = releaseHistory.find(h => h.id === id);
            const data = order || history;

            if (!data) return;

            const modal = document.getElementById('detailModal');
            const isOrder = !!order;

            document.getElementById('modalSubtitle').textContent = isOrder ? (order.status === '출고대기' ? '발주 품목 및 출고 수량 정보' : '발주 품목 정보') : '출고 완료 내역';

            const infoTitle = isOrder ? '발주 정보' : '출고 정보';
            document.getElementById('orderInfoTitle').textContent = infoTitle;

            let infoContent = '<div>';
            if (isOrder) {
                infoContent += '<div><p class="text-sm text-gray-500">발주서 번호</p><p class="font-mono text-blue-600 mt-1">' + order.orderId + '</p></div>';
                infoContent += '<div><p class="text-sm text-gray-500">발주요청지점</p><p class="font-semibold text-gray-900 mt-1">' + order.branch + '</p></div>';
                infoContent += '<div><p class="text-sm text-gray-500">발주요청일</p><p class="text-gray-900 mt-1">' + order.orderDate + '</p></div>';
            } else {
                infoContent += '<div><p class="text-sm text-gray-500">발주서 번호</p><p class="font-mono text-blue-600 mt-1">' + history.orderId + '</p></div>';
                infoContent += '<div><p class="text-sm text-gray-500">출고 지점</p><p class="font-semibold text-gray-900 mt-1">' + history.branch + '</p></div>';
                infoContent += '<div><p class="text-sm text-gray-500">출고 일시</p><p class="text-gray-900 mt-1">' + history.releaseDate + '</p></div>';
                infoContent += '<div><p class="text-sm text-gray-500">처리자</p><p class="text-gray-900 mt-1">' + history.handler + '</p></div>';
            }
            infoContent += '</div>';
            document.getElementById('orderInfoContent').innerHTML = infoContent;

            const itemsTitle = isOrder ? (order.status === '출고대기' ? '출고 품목' : '발주 품목') : '출고 품목';
            document.getElementById('itemsTitle').textContent = itemsTitle;

            let headerHtml = '<th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">품목코드</th><th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">품목명</th><th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">카테고리</th><th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">발주 요청 수량</th>';
            if (isOrder && order.status === '출고대기') {
                headerHtml += '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">출고 수량</th>';
            }
            if (isOrder) {
                headerHtml += '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">창고 재고</th>';
            } else {
                headerHtml += '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">출고 수량</th>';
            }
            document.getElementById('itemsTableHeader').innerHTML = headerHtml;

            let itemsHtml = '';
            const items = isOrder ? order.items : history.items;
            items.forEach(item => {
                const isInsufficient = isOrder && item.warehouseStock < item.requestedQty;
                let rowHtml = '<tr class="border-b border-gray-100' + (isInsufficient ? ' bg-red-50' : '') + '">';
                rowHtml += '<td class="py-3 px-4 font-mono text-sm text-gray-600">' + item.itemCode + '</td>';
                rowHtml += '<td class="py-3 px-4 font-medium text-gray-900">' + item.itemName + '</td>';
                rowHtml += '<td class="py-3 px-4 text-sm text-gray-600"><span class="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">' + item.category + '</span></td>';
                rowHtml += '<td class="py-3 px-4 text-right font-semibold text-blue-600">' + item.requestedQty + item.unit + '</td>';
                
                if (isOrder && order.status === '출고대기') {
                    rowHtml += '<td class="py-3 px-4 text-right font-semibold text-green-600">' + (item.confirmedQty || item.requestedQty) + item.unit + '</td>';
                }
                
                if (isOrder) {
                    const stockClass = isInsufficient ? 'text-red-600' : 'text-green-600';
                    rowHtml += '<td class="py-3 px-4 text-right font-semibold ' + stockClass + '">' + item.warehouseStock + item.unit + '</td>';
                } else {
                    rowHtml += '<td class="py-3 px-4 text-right font-semibold text-green-600">' + (item.confirmedQty || item.requestedQty) + item.unit + '</td>';
                }
                
                rowHtml += '</tr>';
                itemsHtml += rowHtml;
            });
            document.getElementById('itemsTableBody').innerHTML = itemsHtml;

            modal.classList.remove('hidden');
        }

        function closeDetailModal() {
            document.getElementById('detailModal').classList.add('hidden');
        }

        function applyFilters() {
            renderReleaseTable();
        }

        function resetFilters() {
            document.getElementById('filterBranch').value = '전체';
            document.getElementById('filterStartDate').value = '2026-03-01';
            document.getElementById('filterEndDate').value = '2026-04-05';
            currentStatusFilter = '전체';
            updateStatusButtonStyles();
            renderReleaseTable();
        }

        function updateStatusCounts() {
            const allRecords = getUnifiedReleaseList();
            const waitingCount = allRecords.filter(record => record.status === '출고대기').length;
            const preparingCount = allRecords.filter(record => record.status === '준비중').length;
            const completedCount = allRecords.filter(record => record.status === '출고 완료').length;

            document.getElementById('countAll').textContent = allRecords.length + '건';
            document.getElementById('countWaiting').textContent = waitingCount + '건';
            document.getElementById('countPreparing').textContent = preparingCount + '건';
            document.getElementById('countCompleted').textContent = completedCount + '건';
        }

        // 모달 외부 클릭 시 닫기
        document.getElementById('detailModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeDetailModal();
            }
        });

        // 사용자 메뉴 외부 클릭 시 닫기
        document.addEventListener('click', function(e) {
            const userMenu = document.getElementById('userMenu');
            if (!e.target.closest('button[onclick="toggleUserMenu()"]') && 
                !e.target.closest('#userMenu')) {
                userMenu.classList.add('hidden');
            }
        });

        // 초기 로드
        window.addEventListener('DOMContentLoaded', function() {
            releaseOrders = mockReleaseOrders.slice();
            releaseHistory = mockReleaseHistory.slice();
            updateStatusCounts();
            updateStatusButtonStyles();
            renderReleaseTable();
        });
    </script>
</body>
</html>


