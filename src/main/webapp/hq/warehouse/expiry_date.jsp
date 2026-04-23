<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dto.AccountDTO" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
if (loginUser == null) {
    response.sendRedirect(request.getContextPath() + "/common/login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>유통기한 조회 - ZERO LOSS 본사 관리 시스템</title>
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
		<aside id="sidebar" class="fixed top-0 left-0 h-screen w-72 bg-white border-r border-gray-200 z-30 transform -translate-x-full transition-transform duration-200 lg:translate-x-0 flex flex-col">
		    <%
		        Integer unreadCount = (Integer) request.getAttribute("unreadCount");
		        if (unreadCount == null) unreadCount = 0;
		
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
		    <div class="mt-auto p-4 border-t border-gray-200 bg-white">
			    <form action="${pageContext.request.contextPath}/logout" method="post">
			        <button
			            type="submit"
			            class="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 transition-all"
			        >
			            <i class="fas fa-sign-out-alt"></i>
			            <span>로그아웃</span>
			        </button>
			    </form>
			</div>
		</aside>

        <!-- 메인 콘텐츠 -->
        <div class="lg:pl-72">

            <!-- 페이지 콘텐츠 -->
            <main class="p-6">
                <!-- 헤더 -->
                <div class="mb-6">
                    <h2 class="text-3xl font-bold text-gray-900">유통기한 조회</h2>
                    <p class="text-gray-500 mt-1">창고 내 유통기한 임박 품목을 관리하고 조치하세요</p>
                </div>

                <!-- 필터 -->
                <div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                        <!-- 카테고리 필터 -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">카테고리</label>
                            <select id="filterCategory" onchange="updateExpiryItemNames()" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                                <option value="전체">전체</option>
                                <option value="육류">육류</option>
                                <option value="채소">채소</option>
                                <option value="유제품">유제품</option>
                                <option value="빵류">빵류</option>
                                <option value="음료">음료</option>
                                <option value="조미료">조미료</option>
                            </select>
                        </div>

                        <!-- 품목명 필터 -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">품목명</label>
                            <select id="filterItemName" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                                <option value="전체">전체</option>
                            </select>
                        </div>

                        <!-- 검색 -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">검색</label>
                            <input type="text" id="searchQuery" placeholder="재고 코드, 카테고리, 품목 검색" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
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

                <!-- 선택 액션 바 -->
                <div id="actionBar" class="hidden bg-blue-50 rounded-lg p-4 border border-blue-200 mb-6">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <i class="fas fa-box w-5 h-5 text-blue-600"></i>
                            <div>
                                <p class="font-semibold text-blue-900" id="selectedCountText"></p>
                                <p class="text-sm text-blue-600">선택한 품목에 대한 조치를 진행하세요</p>
                            </div>
                        </div>
                        <button onclick="showDisposalModal()" class="flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                            <i class="fas fa-trash w-4 h-4"></i>
                            폐기 처리
                        </button>
                    </div>
                </div>

                <!-- 유통기한 임박 품목 테이블 -->
                <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                        <div>
                            <h3 class="font-semibold text-lg text-gray-900">유통기한 임박 재고 리스트</h3>
                            <p class="text-sm text-gray-500 mt-1">체크박스를 선택하여 일괄 처리하세요</p>
                        </div>
                        <div class="flex items-center gap-4">
                            <div class="text-right">
                                <p class="text-sm text-red-600 font-semibold">긴급 <span id="urgentCount" class="text-lg font-bold">0개</span></p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm text-orange-600 font-semibold">경고 <span id="warningCount" class="text-lg font-bold">0개</span></p>
                            </div>
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50 border-b border-gray-200">
                                <tr>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900 w-12">
                                        <input type="checkbox" id="selectAllCheckbox" onclick="toggleSelectAll()" class="w-4 h-4 rounded border-gray-300">
                                    </th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">재고 코드</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">카테고리</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">품목명</th>
                                    <th class="text-right py-4 px-6 text-sm font-semibold text-gray-900">수량</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">입고일</th>
                                    <th class="text-left py-4 px-6 text-sm font-semibold text-gray-900">유통기한</th>
                                    <th class="text-center py-4 px-6 text-sm font-semibold text-gray-900">D-Day</th>
                                    <th class="text-right py-4 px-6 text-sm font-semibold text-gray-900">자산 가치</th>
                                    <th class="text-center py-4 px-6 text-sm font-semibold text-gray-900">상태</th>
                                </tr>
                            </thead>
                            <tbody id="expiryTableBody">
                                <!-- 동적으로 생성됨 -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- 폐기 처리 모달 -->
    <div id="disposalModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-lg max-w-md w-full p-6">
            <div class="flex items-center gap-3 mb-4">
                <div class="w-12 h-12 rounded-full bg-red-100 text-red-600 flex items-center justify-center">
                    <i class="fas fa-trash w-6 h-6"></i>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-gray-900">폐기 처리</h3>
                    <p class="text-sm text-gray-500">확인 후 처리하세요</p>
                </div>
            </div>

            <div class="bg-red-50 rounded-lg p-4 mb-4 border border-red-200">
                <p class="text-sm text-red-800 mb-2">
                    <strong id="disposalCountText"></strong>을(를) 폐기 처리합니다.
                </p>
                <p class="text-xs text-red-600">
                    * 폐기 후 복구할 수 없으며, 폐기율 통계에 반영됩니다.
                </p>
            </div>

            <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4">
                <p class="text-xs text-yellow-800">
                    폐기 처리된 품목은 복구할 수 없습니다. 계속하시겠습니까?
                </p>
            </div>

            <div class="flex gap-3">
                <button onclick="cancelDisposal()" class="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                    취소
                </button>
                <button onclick="confirmDisposal()" class="flex-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                    확인
                </button>
            </div>
        </div>
    </div>

    <script>
        // 전역 상태
        let expiryItems = [];
        let selectedItems = [];

        // Mock 데이터
        const mockExpiryItems = [
            { id: "we1", itemCode: "MEAT-001", itemName: "소고기 패티", category: "육류", quantity: 50, unit: "개", receivedDate: "2026-03-15", expiryDate: "2026-03-31", daysLeft: 2, unitPrice: 25000, totalValue: 1250000, status: "urgent" },
            { id: "we1-2", itemCode: "MEAT-001", itemName: "소고기 패티", category: "육류", quantity: 35, unit: "개", receivedDate: "2026-03-14", expiryDate: "2026-03-30", daysLeft: 1, unitPrice: 25000, totalValue: 875000, status: "urgent" },
            { id: "we2", itemCode: "DAIRY-002", itemName: "체다치즈", category: "유제품", quantity: 80, unit: "장", receivedDate: "2026-03-20", expiryDate: "2026-04-01", daysLeft: 3, unitPrice: 18000, totalValue: 1440000, status: "urgent" },
            { id: "we2-2", itemCode: "DAIRY-002", itemName: "체다치즈", category: "유제품", quantity: 60, unit: "장", receivedDate: "2026-03-19", expiryDate: "2026-03-31", daysLeft: 2, unitPrice: 18000, totalValue: 1080000, status: "urgent" },
            { id: "we3", itemCode: "DAIRY-001", itemName: "생크림", category: "유제품", quantity: 25, unit: "L", receivedDate: "2026-03-22", expiryDate: "2026-04-03", daysLeft: 5, unitPrice: 30000, totalValue: 750000, status: "warning" },
            { id: "we3-2", itemCode: "DAIRY-001", itemName: "생크림", category: "유제품", quantity: 18, unit: "L", receivedDate: "2026-03-21", expiryDate: "2026-04-02", daysLeft: 4, unitPrice: 30000, totalValue: 540000, status: "warning" },
            { id: "we4", itemCode: "VEG-002", itemName: "양상추", category: "채소", quantity: 30, unit: "kg", receivedDate: "2026-03-24", expiryDate: "2026-04-04", daysLeft: 6, unitPrice: 5000, totalValue: 150000, status: "warning" },
            { id: "we4-2", itemCode: "VEG-002", itemName: "양상추", category: "채소", quantity: 22, unit: "kg", receivedDate: "2026-03-25", expiryDate: "2026-04-05", daysLeft: 7, unitPrice: 5000, totalValue: 110000, status: "warning" },
            { id: "we5", itemCode: "VEG-003", itemName: "토마토", category: "채소", quantity: 45, unit: "kg", receivedDate: "2026-03-23", expiryDate: "2026-04-05", daysLeft: 7, unitPrice: 8000, totalValue: 360000, status: "warning" },
            { id: "we5-2", itemCode: "VEG-003", itemName: "토마토", category: "채소", quantity: 38, unit: "kg", receivedDate: "2026-03-24", expiryDate: "2026-04-06", daysLeft: 8, unitPrice: 8000, totalValue: 304000, status: "normal" },
            { id: "we6", itemCode: "BREAD-001", itemName: "버거빵", category: "빵류", quantity: 200, unit: "개", receivedDate: "2026-03-25", expiryDate: "2026-04-08", daysLeft: 10, unitPrice: 500, totalValue: 100000, status: "normal" },
            { id: "we6-2", itemCode: "BREAD-001", itemName: "버거빵", category: "빵류", quantity: 150, unit: "개", receivedDate: "2026-03-26", expiryDate: "2026-04-09", daysLeft: 11, unitPrice: 500, totalValue: 75000, status: "normal" }
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

        // 품목명 필터 옵션 업데이트
        function updateExpiryItemNames() {
            const selectedCategory = document.getElementById('filterCategory').value;
            const itemNameSelect = document.getElementById('filterItemName');
            const uniqueNames = ['전체'];

            expiryItems.forEach(item => {
                if (selectedCategory === '전체' || item.category === selectedCategory) {
                    if (!uniqueNames.includes(item.itemName)) {
                        uniqueNames.push(item.itemName);
                    }
                }
            });

            const previousValue = itemNameSelect.value;
            itemNameSelect.innerHTML = '';
            uniqueNames.forEach(name => {
                const option = document.createElement('option');
                option.value = name;
                option.textContent = name;
                itemNameSelect.appendChild(option);
            });

            if (uniqueNames.includes(previousValue)) {
                itemNameSelect.value = previousValue;
            }
        }

        // 필터된 항목 가져오기
        function getFilteredItems() {
            const categoryFilter = document.getElementById('filterCategory').value;
            const itemNameFilter = document.getElementById('filterItemName').value;
            const searchQuery = document.getElementById('searchQuery').value.trim().toLowerCase();
            
            return expiryItems.filter(item => {
                const matchesCategory = categoryFilter === '전체' || item.category === categoryFilter;
                const matchesItemName = itemNameFilter === '전체' || item.itemName === itemNameFilter;
                const matchesSearch = !searchQuery || item.itemCode.toLowerCase().includes(searchQuery) || item.category.toLowerCase().includes(searchQuery) || item.itemName.toLowerCase().includes(searchQuery);
                return matchesCategory && matchesItemName && matchesSearch;
            });
        }

        function applyFilters() {
            selectedItems = [];
            document.getElementById('selectAllCheckbox').checked = false;
            updateActionBar();
            renderTable();
        }

        function resetFilters() {
            document.getElementById('filterCategory').value = '전체';
            updateExpiryItemNames();
            document.getElementById('filterItemName').value = '전체';
            document.getElementById('searchQuery').value = '';
            applyFilters();
        }

        // 테이블 렌더링
        function renderTable() {
            const filtered = getFilteredItems();
            const tbody = document.getElementById('expiryTableBody');
            tbody.innerHTML = '';

            filtered.forEach(item => {
                let rowClass = '';
                if (item.daysLeft <= 1) {
                    rowClass = 'bg-red-50';
                } else if (item.daysLeft <= 3) {
                    rowClass = 'bg-orange-50';
                }

                let statusBadgeClass = '';
                let statusIcon = '';
                let statusText = '';
                if (item.status === 'urgent') {
                    statusBadgeClass = 'bg-red-100 text-red-700';
                    statusIcon = '<i class="fas fa-triangle-exclamation w-3 h-3"></i>';
                    statusText = '긴급';
                } else if (item.status === 'warning') {
                    statusBadgeClass = 'bg-orange-100 text-orange-700';
                    statusIcon = '<i class="fas fa-clock w-3 h-3"></i>';
                    statusText = '경고';
                } else {
                    statusBadgeClass = 'bg-gray-100 text-gray-700';
                    statusText = '정상';
                }

                let dBadgeClass = '';
                if (item.daysLeft <= 1) {
                    dBadgeClass = 'bg-red-100 text-red-700';
                } else if (item.daysLeft <= 3) {
                    dBadgeClass = 'bg-orange-100 text-orange-700';
                } else {
                    dBadgeClass = 'bg-yellow-100 text-yellow-700';
                }

                const tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100 hover:bg-gray-50 ' + rowClass;
                tr.innerHTML = '<td class="py-4 px-6"><input type="checkbox" class="item-checkbox w-4 h-4 rounded border-gray-300" data-item-id="' + item.id + '" onchange="updateSelection()"></td><td class="py-4 px-6 font-mono text-sm text-gray-600">' + item.itemCode + '</td><td class="py-4 px-6"><span class="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-full">' + item.category + '</span></td><td class="py-4 px-6 font-medium text-gray-900">' + item.itemName + '</td><td class="py-4 px-6 text-right font-semibold text-gray-900">' + item.quantity + item.unit + '</td><td class="py-4 px-6 text-gray-700 text-sm"><div class="flex items-center gap-2"><i class="fas fa-calendar w-4 h-4 text-gray-400"></i>' + item.receivedDate + '</div></td><td class="py-4 px-6 font-medium text-gray-900"><div class="flex items-center gap-2"><i class="fas fa-calendar w-4 h-4"></i>' + item.expiryDate + '</div></td><td class="py-4 px-6 text-center"><span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-sm font-bold ' + dBadgeClass + '"><i class="fas fa-clock w-4 h-4"></i>D-' + item.daysLeft + '</span></td><td class="py-4 px-6 text-right font-semibold text-gray-900">₩' + item.totalValue.toLocaleString() + '</td><td class="py-4 px-6 text-center"><span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium ' + statusBadgeClass + '">' + statusIcon + statusText + '</span></td>';
                tbody.appendChild(tr);
            });

            updateStats();
        }

        // 선택 항목 체크박스
        function updateSelection() {
            selectedItems = [];
            document.querySelectorAll('.item-checkbox:checked').forEach(checkbox => {
                selectedItems.push(checkbox.dataset.itemId);
            });
            updateActionBar();
        }

        // 전체 선택
        function toggleSelectAll() {
            const isChecked = document.getElementById('selectAllCheckbox').checked;
            document.querySelectorAll('.item-checkbox').forEach(checkbox => {
                checkbox.checked = isChecked;
            });
            updateSelection();
        }

        // 액션 바 업데이트
        function updateActionBar() {
            const actionBar = document.getElementById('actionBar');
            if (selectedItems.length > 0) {
                actionBar.classList.remove('hidden');
                document.getElementById('selectedCountText').textContent = selectedItems.length + '개 품목 선택됨';
            } else {
                actionBar.classList.add('hidden');
            }
        }

        // 통계 업데이트
        function updateStats() {
            const filtered = getFilteredItems();
            const urgentCount = filtered.filter(i => i.status === 'urgent').length;
            const warningCount = filtered.filter(i => i.status === 'warning').length;

            document.getElementById('urgentCount').textContent = urgentCount + '개';
            document.getElementById('warningCount').textContent = warningCount + '개';
        }

        // 폐기 처리 모달
        function showDisposalModal() {
            document.getElementById('disposalCountText').textContent = selectedItems.length + '개 품목';
            document.getElementById('disposalModal').classList.remove('hidden');
        }

        function cancelDisposal() {
            document.getElementById('disposalModal').classList.add('hidden');
        }

        function confirmDisposal() {
            expiryItems = expiryItems.filter(item => !selectedItems.includes(item.id));
            selectedItems = [];
            document.getElementById('disposalModal').classList.add('hidden');
            document.getElementById('selectAllCheckbox').checked = false;
            alert('폐기 처리가 완료되었습니다.');
            renderTable();
        }

        // 모달 외부 클릭 시 닫기
        document.getElementById('disposalModal').addEventListener('click', function(e) {
            if (e.target === this) {
                cancelDisposal();
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
            expiryItems = mockExpiryItems.slice();
            updateExpiryItemNames();
            renderTable();
        });
    </script>
</body>
</html>


