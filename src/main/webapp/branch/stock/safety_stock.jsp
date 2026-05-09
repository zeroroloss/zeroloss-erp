<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>품목별 안전재고 설정 - ZERO LOSS 지점 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
    </style>
</head>

<body class="bg-gray-50">
	<%@ include file="/branch/common/layout/layout_head.jsp" %>
	<div class="zl-app">
		<%@ include file="/branch/common/layout/sidebar.jsp" %>
		<div class="zl-content">
			<div class="p-6">
				<div class="space-y-6">
					<div>
						<h2 class="text-3xl font-bold text-gray-900">품목별 안전재고 설정</h2>
						<p class="text-gray-500 mt-1">지점별 품목 안전재고 수량을 확인하고 수정합니다.</p>
					</div>
					
					<div class="bg-emerald-50 rounded-lg p-4 border border-emerald-200">
						<div class="flex items-center gap-2">
							<i class="fas fa-clipboard-check w-5 h-5 text-emerald-600"></i>
							<p class="text-sm text-emerald-900">총 <span class="font-semibold" id="totalItemsCount">0개 품목</span>의 안전재고를 관리합니다.</p>
						</div>
					</div>

					<div class="bg-white rounded-lg border border-gray-200 overflow-hidden shadow-sm">
						<div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
							<h3 class="font-semibold text-lg text-gray-900">안전재고 설정 리스트</h3>
							<p class="text-sm text-gray-500 mt-1">카테고리와 품목명을 선택해 목록을 좁힐 수 있습니다</p>
						</div>

						<div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
							<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-2">카테고리 선택</label>
									<select id="categoryFilter" onchange="handleCategoryChange()" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent">
										<option value="전체">전체</option>
									</select>
								</div>
								<div>
									<label class="block text-sm font-medium text-gray-700 mb-2">품목명 선택</label>
									<select id="itemFilter" onchange="handleItemChange()" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent">
										<option value="전체">전체</option>
									</select>
								</div>
							</div>
						</div>

						<div class="overflow-x-auto">
							<table class="w-full">
								<thead class="bg-gray-50 border-b border-gray-200">
									<tr>
										<th class="text-left py-3 px-6 text-sm font-semibold text-gray-900">품목코드</th>
										<th class="text-left py-3 px-6 text-sm font-semibold text-gray-900">카테고리</th>
										<th class="text-left py-3 px-6 text-sm font-semibold text-gray-900">품목명</th>
										<th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">안전재고(단위)</th>
										<th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">작업</th>
									</tr>
								</thead>
								<tbody id="itemTableBody"></tbody>
							</table>
						</div>

						<div id="emptyState" class="py-12 text-center hidden">
							<i class="fas fa-box-open w-16 h-16 text-gray-300 mx-auto mb-4" style="display:block;"></i>
							<p class="text-gray-500 text-lg mb-2">조회 결과가 없습니다</p>
							<p class="text-gray-400 text-sm">선택한 필터 조건에 해당하는 품목이 없습니다</p>
						</div>

						<div id="paginationContainer" class="px-6 py-4 border-t border-gray-200 flex flex-col items-center justify-center gap-3 hidden">
						    <div id="paginationInfo" class="text-sm text-gray-600"></div>
						    <div class="flex items-center justify-center gap-2">
						        <div id="pageButtons" class="flex items-center gap-1"></div>
						    </div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		var apiUrl = '<%= request.getContextPath() %>/api/branch/stock/safety_stock';
		var items = [];
		var selectedCategory = '전체';
		var selectedItemName = '전체';
		var editingCode = null;
		var currentPage = 1;
		var itemsPerPage = 10;

		function hasText(value) {
			return value !== null && value !== undefined && String(value).trim() !== '';
		}

		function toNumber(value) {
			var parsed = parseFloat(value);
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
			if (Array.isArray(payload)) { return payload; }
			if (payload.status === 'success' && Array.isArray(payload.data)) { return payload.data; }
			if (Array.isArray(payload.data)) { return payload.data; }
			return [];
		}
		
		async function loadItems() {
			try {
				// GET) /api/branch/stock/safety_stock
				// 요청 헤더의 'Accept'는 어떤 형식의 응답을 받고 싶은지를 알려주는 역할
				const response = await fetch(apiUrl, {headers : {'Accept': 'application/json'} });
				const payload = await response.json();
				
				// response 정규화
				items = normalizeResponse(payload);
				selectedCategory = '전체';
				selectedItemName = '전체';
				currentPage = 1;
				editingCode = null;
				
				updateCategoryFilter();
				updateItemFilter();
				
				renderTable();
			} catch (error) {
				console.error(error);
				items = [];
				renderTable();
			}
		}
		
		// 
		function updateCategoryFilter() {
			var categoryFilter = document.getElementById('categoryFilter');
			var values = ['전체'];
			var seen = {};
			
			items.forEach(function (item) {
				var categoryName = item.categoryName || item.category || item.groupName || '';
				if (hasText(categoryName) && !seen[categoryName]) {
					seen[categoryName] = true;
					values.push(categoryName);
				}
			});
			
			// 옵션 세팅
			categoryFilter.innerHTML = values.map(function (value) {
				return '<option value="' + escapeHtml(value) + '">' + escapeHtml(value) + '</option>';
			}).join('');
			
			categoryFilter.value = selectedCategory;
		}

		function updateItemFilter() {
			var itemFilter = document.getElementById('itemFilter');
			
			// 카테고리가 전체이면 품목도 전체만 나온다
			if (selectedCategory === '전체') {
				itemFilter.innerHTML = '<option value="전체">전체</option>';
				itemFilter.value = '전체';
				return;
			}
			
			var values = ['전체'];
			var seen = {};
			items.forEach(function (item) {
				var categoryName = item.categoryName || item.category || item.groupName || '';
				var itemName = item.materialName || item.itemName || item.name || '';
				
				// 선택된 카테고리만 필터링
				if (categoryName !== selectedCategory) { return; }
				
				if (hasText(itemName) && !seen[itemName]) {
					seen[itemName] = true;
					values.push(itemName);
				}
			});
			
			// 품목명 - 셀렉트 옵션
			itemFilter.innerHTML = values.map(function (value) {
				return '<option value="' + escapeHtml(value) + '">' + escapeHtml(value) + '</option>';
			}).join('');
			itemFilter.value = selectedItemName;
		}

		function handleCategoryChange() {
			selectedCategory = document.getElementById('categoryFilter').value;
			selectedItemName = '전체';
			currentPage = 1;
			updateItemFilter();
			renderTable();
		}

		function handleItemChange() {
			selectedItemName = document.getElementById('itemFilter').value;
			currentPage = 1;
			renderTable();
		}

		function getFilteredItems() {
			return items.filter(function (item) {
				var categoryName = item.categoryName || item.category || item.groupName || '';
				var itemName = item.materialName || item.itemName || item.name || '';
				return (selectedCategory === '전체' || categoryName === selectedCategory) &&
					(selectedItemName === '전체' || itemName === selectedItemName);
			});
		}

		function renderTable() {
			var filteredItems = getFilteredItems();
			var totalPages = Math.max(1, Math.ceil(filteredItems.length / itemsPerPage));
			if (currentPage > totalPages) { currentPage = totalPages; }
			var startIndex = (currentPage - 1) * itemsPerPage;
			var currentItems = filteredItems.slice(startIndex, startIndex + itemsPerPage);
			var tableBody = document.getElementById('itemTableBody');
			var emptyState = document.getElementById('emptyState');
			tableBody.innerHTML = '';

			if (currentItems.length === 0) {
				emptyState.classList.remove('hidden');
			} else {
				emptyState.classList.add('hidden');
				currentItems.forEach(function (item) {
					var materialCode = item.materialCode || item.itemCode || '';
					var materialName = item.materialName || item.itemName || '';
					var categoryName = item.categoryName || item.category || item.groupName || '';
					var unit = item.unit || '';
					var safeStockQty = item.safeStockQty != null ? item.safeStockQty : '';
					var isEditing = editingCode === materialCode;
					var rowHtml = '';
					rowHtml += '<tr class="border-b border-gray-100 hover:bg-gray-50">';
					rowHtml += '<td class="py-4 px-6 font-mono text-sm text-gray-600">' + escapeHtml(materialCode) + '</td>';
					rowHtml += '<td class="py-4 px-6"><span class="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-full">' + escapeHtml(categoryName) + '</span></td>';
					rowHtml += '<td class="py-4 px-6 font-medium text-gray-900">' + escapeHtml(materialName) + '</td>';
					rowHtml += '<td class="py-4 px-6 text-center">';
					if (isEditing) {
						// input으로 만들어서 붙인다.
						rowHtml += '<div class="flex items-center justify-center gap-2"><input type="number" id="safeQty_' + escapeHtml(materialCode) + '" value="' + escapeHtml(safeStockQty) + '" min="0" class="w-24 px-3 py-2 border border-gray-300 rounded-lg text-center font-semibold focus:ring-2 focus:ring-emerald-500 focus:border-transparent"><span class="text-gray-600">' + escapeHtml(unit) + '</span></div>';
					} else {
						// 그냥 붙인다.
						rowHtml += '<div class="font-semibold text-gray-900">' + escapeHtml(safeStockQty) + escapeHtml(unit) + '</div>';
					}
					rowHtml += '</td>';
					if (isEditing) {
						rowHtml += '<td class="py-4 px-6 text-center"><button onclick="handleSave(\'' + escapeHtml(materialCode) + '\')" class="inline-flex items-center gap-1 px-3 py-1 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors"><i class="fas fa-save w-4 h-4"></i>저장</button></td>';
					} else {
						rowHtml += '<td class="py-4 px-6 text-center"><button onclick="handleEdit(\'' + escapeHtml(materialCode) + '\')" class="inline-flex items-center gap-1 px-3 py-1 text-emerald-700 hover:text-emerald-800 hover:bg-emerald-50 rounded-lg transition-colors"><i class="fas fa-edit w-4 h-4"></i>수정</button></td>';
					}
					rowHtml += '</tr>';
					tableBody.insertAdjacentHTML('beforeend', rowHtml);
				});
			}

			updatePagination(totalPages, filteredItems.length);
			document.getElementById('totalItemsCount').textContent = filteredItems.length + '개 품목';
		}

		function updatePagination(totalPages, itemCount) {
		    var paginationContainer = document.getElementById('paginationContainer');
		    var paginationInfo = document.getElementById('paginationInfo');
		    var pageButtons = document.getElementById('pageButtons');

		    totalPages = parseInt(totalPages || 1);
		    itemCount = parseInt(itemCount || 0);

		    if (totalPages <= 1) {
		        paginationContainer.classList.add('hidden');
		        paginationInfo.textContent = '';
		        pageButtons.innerHTML = '';
		        return;
		    }

		    paginationContainer.classList.remove('hidden');

		    var startIndex = (currentPage - 1) * itemsPerPage;
		    var endIndex = Math.min(startIndex + itemsPerPage, itemCount);

		    paginationInfo.textContent = (startIndex + 1) + '-' + endIndex + ' / ' + itemCount + '개';

		    var PAGE_SIZE = 5;
		    var blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
		    var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

		    var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
		    var nextBlockPage = Math.min(totalPages, blockEnd + 1);

		    var base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
		    var active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
		    var arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';

		    var html = '';

		    // 맨 첫 페이지
		    html += '<button type="button" class="' + arrow + '" onclick="goToPage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-angles-left text-xs"></i>';
		    html += '</button>';

		    // 이전 블록
		    html += '<button type="button" class="' + arrow + '" onclick="goToPage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-chevron-left text-xs"></i>';
		    html += '</button>';

		    // 페이지 번호
		    for (var i = blockStart; i <= blockEnd; i++) {
		        html += '<button type="button" class="' + (i === currentPage ? active : base) + '" onclick="goToPage(' + i + ')">';
		        html += i;
		        html += '</button>';
		    }

		    // 다음 블록
		    html += '<button type="button" class="' + arrow + '" onclick="goToPage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-chevron-right text-xs"></i>';
		    html += '</button>';

		    // 맨 마지막 페이지
		    html += '<button type="button" class="' + arrow + '" onclick="goToPage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-angles-right text-xs"></i>';
		    html += '</button>';

		    pageButtons.innerHTML = html;
		}

		function goToPage(page) {
		    var totalPages = Math.max(1, Math.ceil(getFilteredItems().length / itemsPerPage));

		    page = parseInt(page || 1);

		    if (page < 1) {
		        page = 1;
		    }

		    if (page > totalPages) {
		        page = totalPages;
		    }

		    currentPage = page;
		    editingCode = null;
		    renderTable();
		}

		function handleEdit(code) {
			editingCode = code;
			renderTable();
		}

		// 안전재고 수정 후 저장
		async function handleSave(code) {
			var safeQty = toNumber(document.getElementById('safeQty_' + code).value);
			
			if (safeQty < 0) {
				commonShowAlert('알림', '안전재고는 0 이상이어야 합니다.');
				return;
			}
			
			try {
				// POST) /api/branch/stock/safety_stock
				const response = await fetch(apiUrl, {
					method : 'POST',
					headers : {
						'Content-Type' : 'application/json', // json으로 데이터 보낼게
						'Accept' : 'application/json' // json으로 받기를 원해
					},
					body: JSON.stringify({
						materialCode: code,
						safeStockQty: safeQty
					})
				});
				
				const payload = await response.json();
				
				if (!response.ok || !payload || payload.status !== 'success') {
					commonShowAlert('알림', payload?.message || '저장에 실패했습니다.');
					return;
				}
				
				editingCode = null;
				
				// 수정 반영된 것을 다시 로딩
				await loadItems();
				commonShowAlert('알림', '안전재고 설정이 저장되었습니다.');
			} catch (error) {
				console.error(error);
				commonShowAlert('알림', '저장 중 오류가 발생했습니다.');
			}
		}

		function toggleSidebar() {
			var sidebar = document.getElementById('sidebar');
			var backdrop = document.getElementById('sidebarBackdrop');
			var menuIcon = document.getElementById('menuIcon');
			sidebar.classList.toggle('-translate-x-full');
			backdrop.classList.toggle('hidden');
			if (menuIcon) {
				if (backdrop.classList.contains('hidden')) {
					menuIcon.classList.remove('fa-xmark');
					menuIcon.classList.add('fa-bars');
				} else {
					menuIcon.classList.remove('fa-bars');
					menuIcon.classList.add('fa-xmark');
				}
			}
		}

		function toggleMenu(button) {
			var submenu = button.nextElementSibling;
			var icon = button.querySelector('i:last-child');
			if (submenu && submenu.classList.contains('submenu')) {
				submenu.classList.toggle('hidden');
				if (icon) {
					icon.classList.toggle('fa-chevron-down');
					icon.classList.toggle('fa-chevron-right');
				}
			}
		}

		function toggleUserMenu() {
			document.getElementById('userMenu').classList.toggle('hidden');
		}

		document.addEventListener('click', function (e) {
			var userMenuBtn = document.getElementById('userMenuBtn');
			var userMenu = document.getElementById('userMenu');
			if (userMenuBtn && userMenu && !userMenuBtn.contains(e.target) && !userMenu.contains(e.target)) {
				userMenu.classList.add('hidden');
			}
		});

		document.getElementById('sidebarBackdrop').addEventListener('click', toggleSidebar);

		function logout() {
			commonShowAlert('알림', '로그아웃 되었습니다.');
			window.location.href = '<%= request.getContextPath() %>/login';
		}
		
		// 초기 로딩
		document.addEventListener('DOMContentLoaded', async function () {
			await loadItems();
		});

	</script>
</body>
</html>
