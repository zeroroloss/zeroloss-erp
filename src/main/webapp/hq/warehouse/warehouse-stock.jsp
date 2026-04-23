<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dto.AccountDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>본사 물류창고 재고 조회 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar {
            transform: translateX(0);
        }
    </style>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen">
        <!-- 모바일 사이드바 배경 -->
        <div id="sidebarBackdrop" class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden lg:hidden"></div>

        <!-- 사이드바 -->
		<aside id="sidebar" class="fixed top-0 left-0 h-full w-72 bg-white border-r border-gray-200 z-30 transform -translate-x-full transition-transform duration-200 lg:translate-x-0 overflow-y-auto">
		    <%
		        Integer unreadCount = (Integer) request.getAttribute("unreadCount");
		        if (unreadCount == null) unreadCount = 0;
		
		        AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
		
		        String titleText = "Zero Loss";
		        String subText = "ERP";
		
		        if (loginUser != null) {
		            String userName = loginUser.getUserName() != null ? loginUser.getUserName() : "";
		            String roleName = loginUser.getRoleName() != null ? loginUser.getRoleName() : "";
		            String branchName = loginUser.getBranchName() != null ? loginUser.getBranchName() : "";
		
		            titleText = userName + " " + roleName;
		            subText = loginUser.getHqId() != null ? "본사" : branchName;
		        }
		    %>
		
		    <div class="p-6 border-b border-gray-200">
		        <div class="flex items-center gap-3">
		            <div class="w-10 h-10 bg-[#00853D] rounded-full flex items-center justify-center flex-shrink-0">
		                <span class="text-white font-bold text-xl">분</span>
		            </div>
		
		            <div class="min-w-0 max-w-[140px]">
		                <h1 class="text-sm font-bold text-gray-900 truncate" title="<%= titleText %>">
		                    <%= titleText %>
		                </h1>
		                <p class="text-xs text-gray-500 truncate" title="<%= subText %>">
		                    <%= subText %>
		                </p>
		            </div>
		
		            <button type="button" class="ml-auto p-2 rounded-lg hover:bg-gray-100 relative flex-shrink-0">
		                <i class="fas fa-bell text-gray-700 w-5 h-5"></i>
		
		                <% if (unreadCount > 0) { %>
		                    <span class="absolute -top-1 -right-1 min-w-[18px] h-[18px] px-1 bg-red-500 text-white text-[10px] rounded-full flex items-center justify-center">
		                        <%= unreadCount > 99 ? "99+" : unreadCount %>
		                    </span>
		                <% } %>
		            </button>
		        </div>
		    </div>
		
		    <%@ include file="/hq/common/sidebar.jsp" %>
		</aside>

        <div class="lg:pl-72">

            <main class="p-6">
                <div class="mb-6">
                    <h2 class="text-3xl font-bold text-gray-900">본사 물류창고 재고 조회</h2>
                    <p class="text-gray-500 mt-1">현재고와 변동이력을 함께 확인하세요</p>
                </div>

                <div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">재료 검색</label>
                            <input type="text" id="filterSearch" placeholder="재료명 또는 코드 입력" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">카테고리</label>
                            <select id="filterCategory" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                                <option value="전체">전체</option>
                                <option value="단백질">단백질</option>
                                <option value="야채">야채</option>
                                <option value="치즈">치즈</option>
                                <option value="빵류">빵류</option>
                                <option value="소스">소스</option>
                                <option value="음료">음료</option>
                                <option value="쿠키">쿠키</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">상태</label>
                            <select id="filterStatusDropdown" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                                <option value="전체">전체</option>
                                <option value="AVAILABLE">사용 가능</option>
                                <option value="HOLD">재고 없음</option>
                                <option value="EXPIRED">폐기됨</option>
                            </select>
                        </div>
                    </div>

                    <div class="flex items-center gap-2">
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
                        <button type="button" data-status="AVAILABLE" onclick="setStatusFilter('AVAILABLE')" class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-green-200 text-sm font-medium text-green-700 hover:bg-green-50">
                            사용 가능 <span id="countAvailable" class="text-xs text-green-600">0건</span>
                        </button>
                        <button type="button" data-status="HOLD" onclick="setStatusFilter('HOLD')" class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-yellow-200 text-sm font-medium text-yellow-700 hover:bg-yellow-50">
                            재고 없음 <span id="countHold" class="text-xs text-yellow-600">0건</span>
                        </button>
                        <button type="button" data-status="EXPIRED" onclick="setStatusFilter('EXPIRED')" class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-red-200 text-sm font-medium text-red-700 hover:bg-red-50">
                            폐기됨 <span id="countExpired" class="text-xs text-red-600">0건</span>
                        </button>
                    </div>
                </div>

                <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                    <div class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                        <div>
                            <h3 class="text-base font-semibold text-gray-900">본사 물류창고 재고 리스트</h3>
                            <p class="text-xs text-gray-500 mt-1">warehouse_stock 기준 현재고 조회</p>
                        </div>
                        <p class="text-xs text-gray-500">조회 건수 <span id="recordCount" class="font-semibold text-gray-700">0건</span></p>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50 border-b border-gray-200">
                                <tr>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">재고코드</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">재료명</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">카테고리</th>
                                    <th class="text-right py-4 px-6 text-sm font-semibold text-gray-900">현재고</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">입고 시점</th>
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
    </div>

    <div id="detailModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-lg max-w-4xl w-full p-6 max-h-[90vh] overflow-y-auto">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h3 class="text-xl font-bold text-gray-900">재고 상세 정보</h3>
                    <p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
                </div>
                <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600"><i class="fas fa-times w-6 h-6"></i></button>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6 bg-gray-50 rounded-lg p-4">
                <div><p class="text-sm text-gray-500">재고코드</p><p class="font-semibold text-gray-900" id="detailStockCode"></p></div>
                <div><p class="text-sm text-gray-500">재료코드</p><p class="font-semibold text-gray-900" id="detailMaterialCode"></p></div>
                <div><p class="text-sm text-gray-500">재료명</p><p class="font-semibold text-gray-900" id="detailMaterialName"></p></div>
                <div><p class="text-sm text-gray-500">현재고</p><p class="font-semibold text-gray-900" id="detailQty"></p></div>
                <div><p class="text-sm text-gray-500">입고시점</p><p class="font-semibold text-gray-900" id="detailReceivedAt"></p></div>
                <div><p class="text-sm text-gray-500">유통기한</p><p class="font-semibold text-gray-900" id="detailExpiryDate"></p></div>
            </div>

            <div>
                <h4 class="font-semibold text-gray-900 mb-3">변동 이력</h4>
                <div class="overflow-x-auto border border-gray-200 rounded-lg">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                            <tr>
                                <th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">시점</th>
                                <th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">유형</th>
                                <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">변동 수량</th>
                                <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">변동 후 수량</th>
                            </tr>
                        </thead>
                        <tbody id="movementTableBody"></tbody>
                    </table>
                </div>
            </div>

            <div class="flex justify-end mt-6">
                <button onclick="closeDetailModal()" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">닫기</button>
            </div>
        </div>
    </div>

    <script>
        let allStocks = [];
        let filteredStocks = [];
        let selectedStock = null;
        let currentStatusFilter = '전체';

        const mockStocks = [
            { stockNo: 'INV-2024-001', materialCode: 'PROTEIN-001', materialName: '치킨 스트립', category: '단백질', currentQty: 180, unit: 'kg', receivedAt: '2026-04-18 09:10', expiryDate: '2026-04-28', status: 'AVAILABLE', inboundId: 1, receivedQty: 180 },
            { stockNo: 'INV-2024-002', materialCode: 'PROTEIN-002', materialName: '참치', category: '단백질', currentQty: 90, unit: 'kg', receivedAt: '2026-04-16 14:20', expiryDate: '2026-04-26', status: 'AVAILABLE', inboundId: 2, receivedQty: 90 },
            { stockNo: 'INV-2024-003', materialCode: 'VEG-001', materialName: '양상추', category: '야채', currentQty: 65, unit: 'kg', receivedAt: '2026-04-20 11:05', expiryDate: '2026-04-24', status: 'HOLD', inboundId: 3, receivedQty: 65 },
            { stockNo: 'INV-2024-004', materialCode: 'VEG-002', materialName: '토마토', category: '야채', currentQty: 42, unit: 'kg', receivedAt: '2026-04-19 10:30', expiryDate: '2026-04-22', status: 'EXPIRED', inboundId: 4, receivedQty: 42 },
            { stockNo: 'INV-2024-005', materialCode: 'BREAD-001', materialName: '허니오트 빵', category: '빵류', currentQty: 220, unit: '개', receivedAt: '2026-04-21 08:00', expiryDate: '2026-05-02', status: 'AVAILABLE', inboundId: 5, receivedQty: 220 },
            { stockNo: 'INV-2024-006', materialCode: 'CHEESE-001', materialName: '아메리칸 치즈', category: '치즈', currentQty: 55, unit: 'kg', receivedAt: '2026-04-17 13:45', expiryDate: '2026-04-23', status: 'AVAILABLE', inboundId: 6, receivedQty: 55 },
            { stockNo: 'INV-2024-007', materialCode: 'SAUCE-001', materialName: '랜치 소스', category: '소스', currentQty: 35, unit: 'L', receivedAt: '2026-04-14 16:30', expiryDate: '2026-07-14', status: 'AVAILABLE', inboundId: 7, receivedQty: 35 },
            { stockNo: 'INV-2024-008', materialCode: 'COOKIE-001', materialName: '초콜릿칩 쿠키', category: '쿠키', currentQty: 130, unit: '개', receivedAt: '2026-04-12 12:00', expiryDate: '2026-06-10', status: 'AVAILABLE', inboundId: 8, receivedQty: 130 }
        ];

        const stockMovements = {
            'INV-2024-001': [
                { changedAt: '2026-04-18 09:10', changeType: 'RECEIPT', changeAmount: 180, afterQty: 180 },
                { changedAt: '2026-04-20 08:45', changeType: 'OUTBOUND', changeAmount: -20, afterQty: 160 }
            ],
            'INV-2024-002': [
                { changedAt: '2026-04-16 14:20', changeType: 'RECEIPT', changeAmount: 90, afterQty: 90 },
                { changedAt: '2026-04-21 15:00', changeType: 'ADJUST', changeAmount: 0, afterQty: 90 }
            ],
            'INV-2024-003': [
                { changedAt: '2026-04-20 11:05', changeType: 'RECEIPT', changeAmount: 65, afterQty: 65 },
                { changedAt: '2026-04-21 09:40', changeType: 'HOLD', changeAmount: 0, afterQty: 65 }
            ],
            'INV-2024-004': [
                { changedAt: '2026-04-19 10:30', changeType: 'RECEIPT', changeAmount: 42, afterQty: 42 },
                { changedAt: '2026-04-22 08:00', changeType: 'DISPOSAL', changeAmount: -42, afterQty: 0 }
            ]
        };

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

        function toggleMenu(button) {
            const submenu = button.nextElementSibling;
            const icon = button.querySelector('i:last-child');

            if (submenu && submenu.classList.contains('submenu')) {
                submenu.classList.toggle('hidden');
                icon.classList.toggle('fa-chevron-down');
                icon.classList.toggle('fa-chevron-right');
            }
        }

        function toggleUserMenu() {
            document.getElementById('userMenu').classList.toggle('hidden');
        }

        function logout() {
            alert('로그아웃되었습니다.');
            window.location.href = '<%= request.getContextPath() %>/common/login.jsp';
        }

        document.getElementById('sidebarBackdrop').addEventListener('click', toggleSidebar);

        function getExpiryDayCount(expiryDate) {
            const today = new Date('2026-04-22T00:00:00');
            const target = new Date(expiryDate + 'T00:00:00');
            return Math.ceil((target - today) / (1000 * 60 * 60 * 24));
        }

        function setStatusFilter(status) {
            currentStatusFilter = status;
            updateStatusButtonStyles();
            renderTable();
            updateStatusCounts();
        }

        function updateStatusButtonStyles() {
            document.querySelectorAll('.status-filter-btn').forEach(button => {
                const status = button.getAttribute('data-status');
                button.classList.remove('bg-green-50', 'bg-yellow-50', 'bg-red-50', 'border-green-200', 'border-yellow-200', 'border-red-200', 'text-green-700', 'text-yellow-700', 'text-red-700');
                button.classList.remove('bg-gray-900', 'text-white', 'border-gray-900');
                button.classList.add('border-gray-300', 'text-gray-700');

                if (status === currentStatusFilter) {
                    if (status === '전체') {
                        button.classList.add('bg-gray-900', 'text-white', 'border-gray-900');
                    } else if (status === 'AVAILABLE') {
                        button.classList.add('bg-green-50', 'border-green-200', 'text-green-700');
                    } else if (status === 'HOLD') {
                        button.classList.add('bg-yellow-50', 'border-yellow-200', 'text-yellow-700');
                    } else if (status === 'EXPIRED') {
                        button.classList.add('bg-red-50', 'border-red-200', 'text-red-700');
                    }
                }
            });
        }

        function applyFilters() {
            const search = document.getElementById('filterSearch').value.trim().toLowerCase();
            const category = document.getElementById('filterCategory').value;
            const statusDropdown = document.getElementById('filterStatusDropdown').value;

            filteredStocks = allStocks.filter(stock => {
                const matchesSearch = !search || stock.materialName.toLowerCase().includes(search) || stock.materialCode.toLowerCase().includes(search) || stock.stockNo.toLowerCase().includes(search);
                const matchesCategory = category === '전체' || stock.category === category;
                const matchesStatus = currentStatusFilter === '전체' || stock.status === currentStatusFilter;
                return matchesSearch && matchesCategory && matchesStatus;
            });

            renderTable();
            updateStatusCounts();
        }

        function resetFilters() {
            document.getElementById('filterSearch').value = '';
            document.getElementById('filterCategory').value = '전체';
            document.getElementById('filterStatusDropdown').value = '전체';
            currentStatusFilter = '전체';
            updateStatusButtonStyles();
            applyFilters();
        }

        function renderTable() {
            const tbody = document.getElementById('stockTableBody');
            tbody.innerHTML = '';

            if (filteredStocks.length === 0) {
                document.getElementById('emptyState').classList.remove('hidden');
                document.getElementById('recordCount').textContent = '0건';
                return;
            }

            document.getElementById('emptyState').classList.add('hidden');
            document.getElementById('recordCount').textContent = filteredStocks.length + '건';

            filteredStocks.forEach(stock => {
                const statusLabel = stock.status === 'AVAILABLE' ? '사용 가능' : stock.status === 'HOLD' ? '재고 없음' : '폐기됨';
                const statusClass = stock.status === 'AVAILABLE' ? 'bg-green-100 text-green-700' : stock.status === 'HOLD' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700';

                const tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100 hover:bg-gray-50';
                tr.innerHTML = '<td class="py-4 px-6 text-sm text-gray-900 font-mono">' + stock.stockNo + '</td>' +
                    '<td class="py-4 px-6 text-sm font-medium text-gray-900">' + stock.materialName + '</td>' +
                    '<td class="py-4 px-6 text-sm text-gray-600"><span class="px-2 py-0.5 rounded bg-gray-100">' + stock.category + '</span></td>' +
                    '<td class="py-4 px-6 text-right text-sm font-semibold text-gray-900">' + stock.currentQty + stock.unit + '</td>' +
                    '<td class="py-4 px-6 text-sm text-gray-600">' + stock.receivedAt + '</td>' +
                    '<td class="py-4 px-6 text-center"><span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ' + statusClass + '">' + statusLabel + '</span></td>' +
                    '<td class="py-4 px-6 text-center"><button onclick="openDetail(\'' + stock.stockNo + '\')" class="px-3 py-1.5 text-sm text-[#00853D] hover:bg-green-50 rounded-lg transition-colors">상세정보</button></td>';
                tbody.appendChild(tr);
            });
        }

        function updateStatusCounts() {
            const availableCount = allStocks.filter(stock => stock.status === 'AVAILABLE').length;
            const holdCount = allStocks.filter(stock => stock.status === 'HOLD').length;
            const expiredCount = allStocks.filter(stock => stock.status === 'EXPIRED').length;

            document.getElementById('countAll').textContent = allStocks.length + '건';
            document.getElementById('countAvailable').textContent = availableCount + '건';
            document.getElementById('countHold').textContent = holdCount + '건';
            document.getElementById('countExpired').textContent = expiredCount + '건';
        }

        function openDetail(stockNo) {
            selectedStock = allStocks.find(stock => stock.stockNo === stockNo) || null;
            if (!selectedStock) return;

            document.getElementById('detailStockCode').textContent = selectedStock.stockNo;
            document.getElementById('detailMaterialCode').textContent = selectedStock.materialCode;
            document.getElementById('detailMaterialName').textContent = selectedStock.materialName;
            document.getElementById('detailQty').textContent = selectedStock.currentQty + selectedStock.unit + ' / ' + selectedStock.status;
            document.getElementById('detailReceivedAt').textContent = selectedStock.receivedAt;
            document.getElementById('detailExpiryDate').textContent = selectedStock.expiryDate;
            document.getElementById('modalSubtitle').textContent = selectedStock.category + ' · ' + selectedStock.materialName;

            const movements = stockMovements[selectedStock.stockNo] || [];
            const tbody = document.getElementById('movementTableBody');
            tbody.innerHTML = movements.length === 0 ? '<tr><td colspan="4" class="py-8 text-center text-gray-500">이력이 없습니다</td></tr>' : '';
            movements.forEach(movement => {
                const typeLabel = movement.changeType === 'RECEIPT' ? '입고' : movement.changeType === 'OUTBOUND' ? '출고' : movement.changeType === 'ADJUST' ? '조정' : movement.changeType === 'DISPOSAL' ? '폐기' : movement.changeType;
                const row = document.createElement('tr');
                row.className = 'border-b border-gray-100';
                row.innerHTML = '<td class="py-3 px-4 text-sm text-gray-600">' + movement.changedAt + '</td><td class="py-3 px-4 text-sm text-gray-900">' + typeLabel + '</td><td class="py-3 px-4 text-right text-sm text-gray-900">' + movement.changeAmount + '</td><td class="py-3 px-4 text-right text-sm font-semibold text-gray-900">' + movement.afterQty + '</td>';
                tbody.appendChild(row);
            });

            document.getElementById('detailModal').classList.remove('hidden');
        }

        function closeDetailModal() {
            document.getElementById('detailModal').classList.add('hidden');
        }

        document.getElementById('detailModal').addEventListener('click', function(e) {
            if (e.target === this) closeDetailModal();
        });

        document.addEventListener('click', function(e) {
            const userMenu = document.getElementById('userMenu');
            if (!e.target.closest('button[onclick="toggleUserMenu()"]') && !e.target.closest('#userMenu')) {
                userMenu.classList.add('hidden');
            }
        });

        window.addEventListener('DOMContentLoaded', function() {
            allStocks = mockStocks.slice();
            filteredStocks = allStocks.slice();
            updateStatusCounts();
            updateStatusButtonStyles();
            renderTable();
        });
    </script>
</body>
</html>