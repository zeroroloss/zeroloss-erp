<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.google.gson.Gson"%>
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
    <%
        Map<String, List<String>> categoryMaterialMap = (Map<String, List<String>>) request.getAttribute("categoryMaterialMap");
        Gson gson = new Gson();
        String categoryJson = gson.toJson(categoryMaterialMap != null ? categoryMaterialMap : new HashMap<>());
    %>
    <script>
        const categoryMaterialMap = <%=categoryJson%>;
    </script>
</head>
<body class="bg-gray-50">
	    <%@ include file="/hq/common/sidebar.jsp" %>
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
                                <%
                                if (categoryMaterialMap != null) {
                                    for (String category : categoryMaterialMap.keySet()) {
                                %>
                                <option value="<%=category%>"><%=category%></option>
                                <%
                                    }
                                }
                                %>
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
                            <h3 class="font-semibold text-lg text-gray-900">유통기한 임박 재고 리스트 (7일 이하)</h3>
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

                    <div class="overflow-auto max-h-[540px]">
                        <table class="w-full">
                            <thead class="bg-gray-50 border-b border-gray-200 sticky top-0 z-10">
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
        // ============================================================
        // 전역 상태
        // ============================================================
        let expiryItems = [];
        let selectedItems = [];

        // ============================================================
        // 사이드바 / 메뉴 토글
        // ============================================================
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
            window.location.href = '<%=request.getContextPath()%>/common/login.jsp';
        }

        document.getElementById('sidebarBackdrop').addEventListener('click', toggleSidebar);

        document.addEventListener('click', function(e) {
            const userMenu = document.getElementById('userMenu');
            if (!e.target.closest('button[onclick="toggleUserMenu()"]') && 
                !e.target.closest('#userMenu')) {
                userMenu.classList.add('hidden');
            }
        });

        // ============================================================
        // 품목명 필터 옵션 업데이트 (카테고리별)
        // ============================================================
        function updateExpiryItemNames() {
            const selectedCategory = document.getElementById('filterCategory').value;
            const itemNameSelect = document.getElementById('filterItemName');
            
            // 서버 데이터에서 카테고리별 품목 가져오기
            if (selectedCategory === '전체') {
                itemNameSelect.innerHTML = '<option value="전체">전체</option>';
                return;
            }

            itemNameSelect.innerHTML = '<option value="전체">전체</option>';
            
            if (categoryMaterialMap && categoryMaterialMap[selectedCategory]) {
                categoryMaterialMap[selectedCategory].forEach(itemName => {
                    const option = document.createElement('option');
                    option.value = itemName;
                    option.textContent = itemName;
                    itemNameSelect.appendChild(option);
                });
            }
        }

        // ============================================================
        // 필터된 항목 가져오기 (로컬 필터링)
        // ============================================================
        function getFilteredItems() {
            const categoryFilter = document.getElementById('filterCategory').value;
            const itemNameFilter = document.getElementById('filterItemName').value;
            const searchQuery = document.getElementById('searchQuery').value.trim().toLowerCase();
            
            return expiryItems.filter(item => {
                const matchesCategory = categoryFilter === '전체' || item.category === categoryFilter;
                const matchesItemName = itemNameFilter === '전체' || item.itemName === itemNameFilter;
                const matchesSearch = !searchQuery || 
                    (item.stockNo && item.stockNo.toLowerCase().includes(searchQuery)) || 
                    (item.category && item.category.toLowerCase().includes(searchQuery)) || 
                    (item.itemName && item.itemName.toLowerCase().includes(searchQuery));
                return matchesCategory && matchesItemName && matchesSearch;
            });
        }

        // ============================================================
        // 필터 적용 / 초기화
        // ============================================================
        function applyFilters() {
            selectedItems = [];
            document.getElementById('selectAllCheckbox').checked = false;
            updateActionBar();
            loadExpiryData();
        }

        function resetFilters() {
            document.getElementById('filterCategory').value = '전체';
            updateExpiryItemNames();
            document.getElementById('filterItemName').value = '전체';
            document.getElementById('searchQuery').value = '';
            applyFilters();
        }

        // ============================================================
        // 테이블 렌더링
        // ============================================================
        function renderTable() {
            // 로컬 필터링 (프론트엔드 검색)
            const filtered = getFilteredItems();
            const tbody = document.getElementById('expiryTableBody');
            tbody.innerHTML = '';

            if (filtered.length === 0) {
                tbody.innerHTML = '<tr><td colspan="10" class="py-12 text-center text-gray-500">' +
                    '<i class="fas fa-box w-12 h-12 mx-auto mb-3 text-gray-400"></i>' +
                    '<p>조회 결과가 없습니다</p></td></tr>';
                updateStats();
                return;
            }

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
                tr.innerHTML = '<td class="py-4 px-6"><input type="checkbox" class="item-checkbox w-4 h-4 rounded border-gray-300" data-item-id="' + item.id + '" data-stock-no="' + item.stockNo + '" onchange="updateSelection()"></td>' +
                    '<td class="py-4 px-6 font-mono text-sm text-gray-600">' + (item.stockNo || item.itemCode || '-') + '</td>' +
                    '<td class="py-4 px-6"><span class="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-full">' + item.category + '</span></td>' +
                    '<td class="py-4 px-6 font-medium text-gray-900">' + item.itemName + '</td>' +
                    '<td class="py-4 px-6 text-right font-semibold text-gray-900">' + item.quantity + (item.unit || '') + '</td>' +
                    '<td class="py-4 px-6 text-gray-700 text-sm"><div class="flex items-center gap-2"><i class="fas fa-calendar w-4 h-4 text-gray-400"></i>' + item.receivedDate + '</div></td>' +
                    '<td class="py-4 px-6 font-medium text-gray-900"><div class="flex items-center gap-2"><i class="fas fa-calendar w-4 h-4"></i>' + item.expiryDate + '</div></td>' +
                    '<td class="py-4 px-6 text-center"><span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-sm font-bold ' + dBadgeClass + '"><i class="fas fa-clock w-4 h-4"></i>D-' + item.daysLeft + '</span></td>' +
                    '<td class="py-4 px-6 text-right font-semibold text-gray-900">₩' + (item.totalValue ? item.totalValue.toLocaleString() : '0') + '</td>' +
                    '<td class="py-4 px-6 text-center"><span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium ' + statusBadgeClass + '">' + statusIcon + statusText + '</span></td>';
                tbody.appendChild(tr);
            });

            updateStats();
        }

        // ============================================================
        // 선택 항목 관리
        // ============================================================
        function updateSelection() {
            selectedItems = [];
            document.querySelectorAll('.item-checkbox:checked').forEach(checkbox => {
                selectedItems.push({
                    id: checkbox.dataset.itemId,
                    stockNo: checkbox.dataset.stockNo
                });
            });
            updateActionBar();
        }

        function toggleSelectAll() {
            const isChecked = document.getElementById('selectAllCheckbox').checked;
            document.querySelectorAll('.item-checkbox').forEach(checkbox => {
                checkbox.checked = isChecked;
            });
            updateSelection();
        }

        function updateActionBar() {
            const actionBar = document.getElementById('actionBar');
            if (selectedItems.length > 0) {
                actionBar.classList.remove('hidden');
                document.getElementById('selectedCountText').textContent = selectedItems.length + '개 품목 선택됨';
            } else {
                actionBar.classList.add('hidden');
            }
        }

        // ============================================================
        // 통계 업데이트
        // ============================================================
        function updateStats() {
            const filtered = getFilteredItems();
            const urgentCount = filtered.filter(i => i.status === 'urgent').length;
            const warningCount = filtered.filter(i => i.status === 'warning').length;

            document.getElementById('urgentCount').textContent = urgentCount + '개';
            document.getElementById('warningCount').textContent = warningCount + '개';
        }

        // ============================================================
        // 폐기 처리 모달
        // ============================================================
        function showDisposalModal() {
            if (selectedItems.length === 0) {
                alert('폐기할 품목을 선택해주세요.');
                return;
            }
            document.getElementById('disposalCountText').textContent = selectedItems.length + '개 품목';
            document.getElementById('disposalModal').classList.remove('hidden');
        }

        function cancelDisposal() {
            document.getElementById('disposalModal').classList.add('hidden');
        }

        async function confirmDisposal() {
            try {
                // stock_no 배열로 변환
                const stockNos = selectedItems.map(item => item.stockNo);
                
                const response = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/expiry_date/dispose', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ stockNos: stockNos })
                });

                const result = await response.json();
                if (!response.ok || result.status !== 'success') {
                    throw new Error(result.message || '폐기 처리 실패');
                }

                selectedItems = [];
                document.getElementById('disposalModal').classList.add('hidden');
                document.getElementById('selectAllCheckbox').checked = false;
                alert('폐기 처리가 완료되었습니다.');
                applyFilters();

            } catch (err) {
                alert('폐기 처리 중 오류가 발생했습니다: ' + err.message);
            }
        }

        document.getElementById('disposalModal').addEventListener('click', function(e) {
            if (e.target === this) {
                cancelDisposal();
            }
        });

        // ============================================================
        // 데이터 로드 (GET API)
        // ============================================================
        async function loadExpiryData() {
            try {
                const category = document.getElementById('filterCategory').value;
                const itemName = document.getElementById('filterItemName').value;
                const search = document.getElementById('searchQuery').value;

                const params = new URLSearchParams();
                if (category !== '전체') params.append('category', category);
                if (itemName !== '전체') params.append('itemName', itemName);
                if (search.trim()) params.append('search', search);

                const response = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/expiry_date?' + params.toString());
                
                if (!response.ok) {
                    const errData = await response.json();
                    throw new Error(errData.message || 'HTTP ' + response.status);
                }

                const result = await response.json();
                if (!result || result.status !== 'success') {
                    throw new Error((result && result.message) || '데이터 오류');
                }

                // API 응답 데이터 정규화
                expiryItems = (result.data || []).map(item => ({
                    id: item.id || item.warehouseStockId,
                    stockNo: item.stockNo,
                    itemCode: item.itemCode || item.stockNo,
                    category: item.category || item.categoryName,
                    itemName: item.itemName || item.materialName,
                    quantity: item.quantity || item.qty,
                    unit: item.unit,
                    receivedDate: item.receivedDate || item.receivedAt,
                    expiryDate: item.expiryDate,
                    daysLeft: item.daysLeft,
                    totalValue: item.totalValue || (item.quantity * (item.unitPrice || 0)),
                    status: item.status
                }));

                updateExpiryItemNames();
                renderTable();

            } catch (err) {
                console.error('데이터 로드 실패:', err);
                expiryItems = [];
                updateExpiryItemNames();
                renderTable();
                alert('데이터를 불러오는 중 오류가 발생했습니다: ' + err.message);
            }
        }

        // ============================================================
        // 초기 로드
        // ============================================================
        window.addEventListener('DOMContentLoaded', function() {
            // 카테고리 필터 옵션 초기화 (서버 데이터 기반)
            const categorySelect = document.getElementById('filterCategory');
            if (categoryMaterialMap && Object.keys(categoryMaterialMap).length > 0) {
                Object.keys(categoryMaterialMap).forEach(category => {
                    if (!Array.from(categorySelect.options).some(opt => opt.value === category)) {
                        const option = document.createElement('option');
                        option.value = category;
                        option.textContent = category;
                        categorySelect.appendChild(option);
                    }
                });
            }
            
            // 초기 데이터 로드
            loadExpiryData();
        });
    </script>
</body>
</html>


