<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<title>지점 재고 현황 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
<style>
.sidebar-open .sidebar {
	transform: translateX(0);
}

.sidebar-open #sidebarBackdrop {
	display: block;
}
</style>
</head>
<body class="bg-gray-50">
	<%@ include file="/hq/common/sidebar.jsp"%>

	<!-- 메인 콘텐츠 -->
	<div class="lg:pl-72">

		<!-- 페이지 콘텐츠 -->
		<main class="p-6">
			<!-- ===== 페이지 헤더 ===== -->
			<div class="mb-6">
			    <h2 class="text-3xl font-bold text-gray-900">지점 재고 현황</h2>
			    <p class="text-gray-500 mt-1">모든 지점의 재고 현황을 조회하세요</p>
			</div>
			
			<!-- ===== 검색 필터 영역 ===== -->
			<div class="bg-white rounded-xl border border-gray-200 p-6 shadow-sm mb-6">
			    <div class="flex flex-col gap-4">
			
			        <!-- 상단: 설명 -->
			        <div>
			            <h3 class="text-sm font-semibold text-gray-800">지점 재고 검색</h3>
			            <p class="text-xs text-gray-500 mt-1">
			                지점, 카테고리, 품목명, 검색어 기준으로 지점 재고 현황을 조회할 수 있습니다.
			            </p>
			        </div>
			
			        <!-- 하단: 필터 + 버튼 -->
			        <div class="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-4 pt-4 border-t border-gray-100">
			
			            <!-- 필터 영역 -->
			            <div class="flex flex-wrap items-center gap-3 flex-1">
			
			                <!-- 지점 선택 -->
			                <select id="branchSelect"
			                        class="w-52 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white">
			                    <option value="">전체 지점</option>
			
			                    <c:forEach var="branch" items="${branchList}">
			                        <c:if test="${branch.branchCode != 1}">
			                            <option value="${branch.branchCode}">
			                                ${branch.branchName}
			                            </option>
			                        </c:if>
			                    </c:forEach>
			                </select>
			
			                <!-- 카테고리 선택 -->
			                <select id="categorySelect"
			                        class="w-48 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white">
			                    <option value="">전체 카테고리</option>
			
			                    <c:forEach var="group" items="${materialGroupList}">
			                        <option value="${group.materialGroupId}">
			                            ${group.groupName}
			                        </option>
			                    </c:forEach>
			                </select>
			
			                <!-- 품목명 선택 -->
			                <select id="itemNameSelect"
			                        class="w-52 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white">
			                    <option value="">전체 품목</option>
			                </select>
			
			                <!-- 검색어 -->
							<div class="relative w-96">
							    <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-sm"></i>
							    <input type="text"
							           id="searchInput"
							           placeholder="품목명, 코드, 지점명 검색"
							           class="w-full pl-9 pr-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
							</div>
			            </div>
			
			            <!-- 버튼 영역 -->
			            <div class="flex items-center gap-2 xl:ml-4 xl:shrink-0">
			                <button type="button"
			                        onclick="handleSearch()"
			                        class="px-5 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">
			                    조회
			                </button>
			
			                <button type="button"
			                        onclick="handleReset()"
			                        class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">
			                    초기화
			                </button>
			            </div>
			        </div>
			    </div>
			</div>

			<!-- 탭 -->
			<div id="tabsContainer"
				class="bg-white rounded-lg border border-gray-200 hidden mb-6">
				<div class="flex border-b border-gray-200">
					<button onclick="setActiveTab('all')"
						class="flex-1 px-6 py-4 font-semibold transition-colors tab-btn active"
						data-tab="all">
						전체 재고 (<span id="totalCount">0</span>)
					</button>
					<button onclick="setActiveTab('expiring')"
						class="flex-1 px-6 py-4 font-semibold transition-colors tab-btn"
						data-tab="expiring">
						유통기한 임박 (<span id="expiringCount">0</span>)
					</button>
					<button onclick="setActiveTab('low')"
						class="flex-1 px-6 py-4 font-semibold transition-colors tab-btn"
						data-tab="low">
						안전재고 미달 (<span id="lowCount">0</span>)
					</button>
				</div>
			</div>

			<!-- 재고 리스트 -->
			<div id="inventoryTableContainer"
				class="bg-white rounded-lg border border-gray-200 overflow-hidden hidden">
				<div class="overflow-x-auto">
					<table class="w-full">
						<thead class="bg-gray-50 border-b border-gray-200">
							<tr>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">지점</th>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">품목코드</th>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">품목명</th>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">카테고리</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">현재
									재고</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">안전
									재고</th>
								<th
									class="text-center py-4 px-6 text-sm font-semibold text-gray-900">상태</th>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">최종
									업데이트</th>
							</tr>
						</thead>
						<tbody id="inventoryTableBody">
							<!-- 동적으로 생성됨 -->
						</tbody>
					</table>
				</div>

				<!-- 페이지네이션 -->
				<div id="paginationContainer"
					class="px-6 py-4 border-t border-gray-200 flex flex-col items-center justify-center gap-3 hidden">
					<div id="paginationInfo" class="text-sm text-gray-600">
						<!-- 동적으로 생성됨 -->
					</div>

					<div class="flex items-center justify-center gap-2">
						<div id="pageButtons" class="flex items-center gap-1">
							<!-- 동적으로 생성됨 -->
						</div>
					</div>
				</div>
			</div>

			<!-- 초기 상태 메시지 -->
			<div id="initialStateContainer"
				class="bg-white rounded-lg border border-gray-200 p-12 text-center">
				<i class="fas fa-box w-16 h-16 mx-auto mb-4 text-gray-300"></i>
				<h3 class="text-lg font-semibold text-gray-900 mb-2">조회 조건을
					선택하세요</h3>
				<p class="text-gray-500">지점, 카테고리, 품목명을 선택하거나 검색어를 입력한 후 '조회하기'
					버튼을 클릭하세요</p>
			</div>
		</main>
	</div>

	<script>
        // 전역 상태
        let allData = [];
        let filteredData = [];
        let currentPage = 1;
        const ITEMS_PER_PAGE = 10;
        let activeTab = 'all';
        let hasSearched = false;

        // 사이드바 토글
        function toggleSidebar() {
            const body = document.body;
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

        // 사이드바 메뉴 닫기
        function closeSidebar() {
            document.getElementById('sidebar').classList.add('-translate-x-full');
            document.getElementById('sidebarBackdrop').classList.add('hidden');
            document.getElementById('menuIcon').classList.remove('fa-xmark');
            document.getElementById('menuIcon').classList.add('fa-bars');
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
            commonShowAlert('알림','로그아웃되었습니다.');
            window.location.href = '<%=request.getContextPath()%>/common/login.jsp';
        }

        // 백드롭 클릭 시 사이드바 닫기
        document.getElementById('sidebarBackdrop').addEventListener('click', closeSidebar);

        // 필터링 아래로
        function applyFilters() {
            const searchQuery = document.getElementById('searchInput').value.toLowerCase();
            const selectedBranch = document.getElementById('branchSelect').value;
            const selectedCategory = document.getElementById('categorySelect').value;
            const selectedItemName = document.getElementById('itemNameSelect').value;

            filteredData = allData.filter(item => {
                const matchesSearch = !searchQuery || 
                item.materialName.toLowerCase().includes(searchQuery) ||
                String(item.materialCode).toLowerCase().includes(searchQuery) ||
                    item.branchName.includes(searchQuery);
                
                const matchesBranch = !selectedBranch || item.branchName === selectedBranch;
                const matchesCategory = !selectedCategory || item.categoryName === selectedCategory;
                const matchesItemName = !selectedItemName || item.materialName === selectedItemName;

                let matchesTab = true;
                if (activeTab === 'low') {
                    matchesTab = item.status === 'low' || item.status === 'out';
                } else if (activeTab === 'expiring') {
                	 matchesTab = item.expireStatus === 'urgent' || item.expireStatus === 'warning';
                }

                return matchesSearch && matchesBranch && matchesCategory && matchesItemName && matchesTab;
            });
        }

        // 조회하기
        window.handleSearch = function() {

	let branchCode = document.getElementById('branchSelect').value;
	let materialGroupId = document.getElementById('categorySelect').value;
	let materialCode = document.getElementById('itemNameSelect').value;
	const keyword = document.getElementById('searchInput').value;

	let url = '<%=request.getContextPath()%>/hq/branch_stock/stock?ajax=true'
		+ '&branchCode=' + branchCode
		+ '&materialGroupId=' + materialGroupId
		+ '&materialCode=' + materialCode
		+ '&keyword=' + keyword;

	if (activeTab === 'expiring') {
		url += '&expireWithinDays=7';
	}
	
	if (activeTab === 'low') {
	    url += '&stockStatus=low';
	}
	console.log(url);
	fetch(url)
		.then(res => res.json())
		.then(data => {
    		console.log("서버 데이터:", data);

   		 allData = data;
   		 filteredData = data;

    		hasSearched = true;
    		currentPage = 1;

    		updateUI();
		})
		.catch(err => {
			console.error(err);
			commonShowAlert('알림',"조회 실패");
		});
	};

        // 초기화
        function handleReset() {
            document.getElementById('searchInput').value = '';
            document.getElementById('branchSelect').selectedIndex = 0;
            document.getElementById('categorySelect').selectedIndex = 0;
            document.getElementById('itemNameSelect').selectedIndex = 0;
            
            hasSearched = false;
            currentPage = 1;
            filteredData = [];
            allData = [];
            
            updateUI();
        }

        // 탭 변경
        function setActiveTab(tab) {
    		activeTab = tab;
    		currentPage = 1;
    		updateTabButtons();

    		if (hasSearched) {
        		handleSearch();
    		}
		}

        // UI 업데이트
        function updateUI() {
            const initialState = document.getElementById('initialStateContainer');
            const tabsContainer = document.getElementById('tabsContainer');
            const tableContainer = document.getElementById('inventoryTableContainer');

            if (hasSearched) {
                initialState.classList.add('hidden');
                tabsContainer.classList.remove('hidden');
                tableContainer.classList.remove('hidden');
                
                updateStats();
                renderTable();
                updateTabButtons();
            } else {
                initialState.classList.remove('hidden');
                tabsContainer.classList.add('hidden');
                tableContainer.classList.add('hidden');
            }
        }

        // 통계 업데이트
        function updateStats() {
        	const total = allData.length;

            const expiring = allData.filter(i =>
                i.expireStatus === 'urgent' || i.expireStatus === 'warning'
            ).length;

            const low = allData.filter(i =>
                i.status === 'low' || i.status === 'out'
            ).length;

            document.getElementById('totalCount').textContent = total;
            document.getElementById('expiringCount').textContent = expiring;
            document.getElementById('lowCount').textContent = low;
}

        // 테이블 렌더링
        function renderTable() {
            const totalPages = Math.ceil(filteredData.length / ITEMS_PER_PAGE);
            const startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
            const endIndex = startIndex + ITEMS_PER_PAGE;
            const currentItems = filteredData.slice(startIndex, endIndex);

            const tbody = document.getElementById('inventoryTableBody');
            tbody.innerHTML = '';

            if (currentItems.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="8" class="py-12 text-center text-gray-500">
                            <i class="fas fa-box w-12 h-12 mx-auto mb-3 text-gray-400"></i>
                            <p>검색 결과가 없습니다</p>
                        </td>
                    </tr>
                `;
                document.getElementById('paginationContainer').classList.add('hidden');
                return;
            }

            currentItems.forEach(item => {
                const statusBadge = getExpireStatusBadge(item.expireStatus);
                const statusColorClass = item.status === 'normal' ? 'text-green-600' :
                                        item.status === 'low' ? 'text-yellow-600' :
                                        'text-red-600';
                
                const tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100 hover:bg-gray-50';
                tr.innerHTML = `
                    <td class="py-4 px-6">
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-700">
                            ` + item.branchName + `
                        </span>
                    </td>
                    <td class="py-4 px-6 font-mono text-sm text-gray-600">` + item.materialCode + `</td>
                    <td class="py-4 px-6 font-medium text-gray-900">` + item.materialName + `</td>
                    <td class="py-4 px-6">
                        <span class="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-full">
                            ` + item.categoryName + `
                        </span>
                    </td>
                    <td class="py-4 px-6 text-right">
                        <span class="font-semibold ` + statusColorClass + `">
                            ` + item.currentQty + item.unit + `
                        </span>
                    </td>
                    <td class="py-4 px-6 text-right text-gray-600">
                        ` + item.safeStockQty + item.unit + `
                    </td>
                    <td class="py-4 px-6 text-center">` + statusBadge + `</td>
                    <td class="py-4 px-6 text-sm text-gray-500">` + item.lastUpdated + `</td>
                `;
                tbody.appendChild(tr);
            });

            // 페이지네이션 업데이트
            updatePagination(totalPages, startIndex, endIndex);
        }

        // 페이지네이션 업데이트
       function updatePagination(totalPages, startIndex, endIndex) {
    		const paginationContainer = document.getElementById('paginationContainer');
    		const paginationInfo = document.getElementById('paginationInfo');
    		const pageButtons = document.getElementById('pageButtons');

    		if (totalPages <= 1) {
        		paginationContainer.classList.add('hidden');
        		return;
    		}

    		paginationContainer.classList.remove('hidden');

    		const endValue = Math.min(endIndex, filteredData.length);
    		const totalItems = filteredData.length;
    		paginationInfo.textContent = (startIndex + 1) + '-' + endValue + ' / ' + totalItems + '개';

    		const PAGE_SIZE = 5;
    		const blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
    		const blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

    		var base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
		    var active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
		    var arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';

    		let html = '';

    		html += '<button class="' + arrow + '" onclick="goToPage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
    		html += '<i class="fas fa-angles-left text-xs"></i>';
    		html += '</button>';

    		const prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
    		html += '<button class="' + arrow + '" onclick="goToPage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
    		html += '<i class="fas fa-chevron-left text-xs"></i>';
    		html += '</button>';

    		for (let i = blockStart; i <= blockEnd; i++) {
       			 html += '<button class="' + (i === currentPage ? active : base) + '" onclick="goToPage(' + i + ')">';
        		html += i;
        		html += '</button>';
    		}

    		const nextBlockPage = Math.min(totalPages, blockEnd + 1);
    		html += '<button class="' + arrow + '" onclick="goToPage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
    		html += '<i class="fas fa-chevron-right text-xs"></i>';
    		html += '</button>';

    		html += '<button class="' + arrow + '" onclick="goToPage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
    		html += '<i class="fas fa-angles-right text-xs"></i>';
    		html += '</button>';

    		pageButtons.innerHTML = html;
		}
        // 페이지 이동
        function goToPage(page) {
            currentPage = page;
            renderTable();
        }

        // 탭 버튼 업데이트
        function updateTabButtons() {

    		document.querySelectorAll('.tab-btn').forEach(btn => {
        		btn.style.backgroundColor = '#ffffff';
        		btn.style.color = '#6b7280';
    		});
    		const activeBtn = document.querySelector('[data-tab="' + activeTab + '"]');

    		if (activeBtn) {
        		activeBtn.style.backgroundColor = '#00853D';
        		activeBtn.style.color = '#ffffff';
    		}
		}

        // 상태 배지
        function getStatusBadge(status) {
            switch (status) {
            case 'urgent':
                return '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-700">긴급</span>';
            case 'warning':
                return '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-700">주의</span>';
            case 'normal':
                return '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700">정상</span>';
            default:
                return '<span class="text-gray-400">-</span>';
            }
        }

        // 사용자 메뉴 외부 클릭 시 닫기
        document.addEventListener('click', function(e) {
    		const userMenu = document.getElementById('userMenu');

			if (!userMenu) return;

			if (!e.target.closest('button[onclick="toggleUserMenu()"]') && 
				!e.target.closest('#userMenu')) {
					userMenu.classList.add('hidden');
   		 		}
			});
        
		document.getElementById("categorySelect").addEventListener("change", function () {

   			const materialGroupId = this.value;
    		const itemSelect = document.getElementById("itemNameSelect");

   			itemSelect.innerHTML = '<option value="">전체</option>';

    		if (!materialGroupId) return;

    		fetch('<%=request.getContextPath()%>/hq/branch_stock/stock?ajax=true&type=material&materialGroupId=' + materialGroupId)
        		.then(res => res.json())
       			.then(data => {
            		console.log("품목명 응답:", data);

            		data.forEach(m => {
                		const option = document.createElement("option");
                		option.value = m.materialCode;
                		option.textContent = m.materialName;
                		itemSelect.appendChild(option);
            		});
        		})
        	.catch(err => console.error("품목명 조회 실패:", err));
		});
		
		function getExpireStatusBadge(expireStatus) {
		    switch (expireStatus) {
		        case 'urgent':
		            return '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-700">긴급</span>';
		        case 'warning':
		            return '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-700">주의</span>';
		        case 'normal':
		            return '<span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700">정상</span>';
		        default:
		            return '';
		    }
		}
</script>
</body>
</html>
