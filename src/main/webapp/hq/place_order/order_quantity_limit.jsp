<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>품목별 발주 수량 설정 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
    </style>
</head>
<body class="bg-gray-50">
	<%@ include file="/hq/common/sidebar.jsp" %>
	<div class="lg:pl-72">
		<main class="p-6">
			<div class="space-y-6">
				<div>
					<h2 class="text-3xl font-bold text-gray-900">품목별 발주 수량 설정</h2>
					<p class="text-gray-500 mt-1">품목별 발주 제한을 설정하여 과다 발주를 방지하세요</p>
				</div>

				<div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
					<div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
						<h3 class="font-semibold text-lg text-gray-900">발주 제한 설정 리스트</h3>
						<p class="text-sm text-gray-500 mt-1">카테고리와 품목명으로 필터링한 뒤 수량을 수정하세요</p>
					</div>

					<div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
						<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
							<div>
								<label class="block text-sm font-medium text-gray-700 mb-2">카테고리 선택</label>
								<select id="categoryFilter" onchange="handleCategoryChange()" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
									<option value="전체">전체</option>
								</select>
							</div>

							<div>
								<label class="block text-sm font-medium text-gray-700 mb-2">품목명 선택</label>
								<select id="itemFilter" onchange="handleItemChange()" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent">
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
									<th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">최소 수량</th>
									<th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">최대 수량</th>
									<th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상태</th>
									<th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">작업</th>
								</tr>
							</thead>
							<tbody id="itemTableBody"></tbody>
						</table>
					</div>

					<div id="emptyState" class="py-12 text-center hidden">
						<i class="fas fa-folder-open w-16 h-16 text-gray-300 mx-auto mb-4" style="display:block;"></i>
						<p class="text-gray-500 text-lg mb-2">조회 결과가 없습니다</p>
						<p class="text-gray-400 text-sm">선택한 필터 조건에 해당하는 품목이 없습니다</p>
					</div>

					<div id="paginationContainer" class="flex justify-between items-center px-6 py-4 border-t border-gray-200 hidden">
						<button onclick="previousPage()" id="prevBtn" class="flex items-center gap-1 px-3 py-2 rounded-lg text-sm font-medium bg-gray-100 text-gray-500 hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed">
							<i class="fas fa-chevron-left w-4 h-4"></i>
							이전
						</button>
						<div class="text-sm text-gray-500"><span id="pageInfo">1 / 1</span></div>
						<button onclick="nextPage()" id="nextBtn" class="flex items-center gap-1 px-3 py-2 rounded-lg text-sm font-medium bg-gray-100 text-gray-500 hover:bg-gray-200 disabled:opacity-50 disabled:cursor-not-allowed">
							다음
							<i class="fas fa-chevron-right w-4 h-4"></i>
						</button>
					</div>
				</div>

				<div class="bg-blue-50 rounded-lg p-4 border border-blue-200">
					<div class="flex items-center gap-2">
						<i class="fas fa-box w-5 h-5 text-blue-600"></i>
						<p class="text-sm text-blue-900">총 <span class="font-semibold" id="totalItemsCount">0개 품목</span>의 발주 제한이 설정되어 있습니다.</p>
					</div>
				</div>
			</div>
		</main>
	</div>

	<script>
		var apiUrl = '<%= request.getContextPath() %>/api/hq/place_order/order_quantity_limit';
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

		function loadItems() {
			fetch(apiUrl, { headers: { 'Accept': 'application/json' } })
				.then(function (response) { return response.json(); })
				.then(function (payload) {
					items = normalizeResponse(payload);
					selectedCategory = '전체';
					selectedItemName = '전체';
					currentPage = 1;
					editingCode = null;
					updateCategoryFilter();
					updateItemFilter();
					renderTable();
				})
				.catch(function (error) {
					console.error(error);
					items = [];
					renderTable();
				});
		}

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
			categoryFilter.innerHTML = values.map(function (value) {
				return '<option value="' + escapeHtml(value) + '">' + escapeHtml(value) + '</option>';
			}).join('');
			categoryFilter.value = selectedCategory;
		}

		function updateItemFilter() {
			var itemFilter = document.getElementById('itemFilter');
			
			// 카테고리가 전체면 품목도 전체만
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
				
				// 선택된 카테고리가 아니면 옵션에 추가 X
				if (categoryName !== selectedCategory) { return; }
				
				if (hasText(itemName) && !seen[itemName]) {
					seen[itemName] = true;
					values.push(itemName);
				}
			});
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
					var minQty = item.minQty != null ? item.minQty : '';
					var maxQty = item.maxQty != null ? item.maxQty : '';
					var isEditing = editingCode === materialCode;
					var rowHtml = '';
					rowHtml += '<tr class="border-b border-gray-100 hover:bg-gray-50">';
					rowHtml += '<td class="py-4 px-6 font-mono text-sm text-gray-600">' + escapeHtml(materialCode) + '</td>';
					rowHtml += '<td class="py-4 px-6"><span class="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-full">' + escapeHtml(categoryName) + '</span></td>';
					rowHtml += '<td class="py-4 px-6 font-medium text-gray-900">' + escapeHtml(materialName) + '</td>';
					if (isEditing) {
						rowHtml += '<td class="py-4 px-6"><div class="flex items-center justify-center gap-2"><input type="number" id="minQty_' + escapeHtml(materialCode) + '" value="' + escapeHtml(minQty) + '" min="0" class="w-20 px-3 py-2 border border-gray-300 rounded-lg text-center font-semibold focus:ring-2 focus:ring-blue-500 focus:border-transparent"><span class="text-gray-600">' + escapeHtml(unit) + '</span></div></td>';
						rowHtml += '<td class="py-4 px-6"><div class="flex items-center justify-center gap-2"><input type="number" id="maxQty_' + escapeHtml(materialCode) + '" value="' + escapeHtml(maxQty) + '" min="0" class="w-20 px-3 py-2 border border-gray-300 rounded-lg text-center font-semibold focus:ring-2 focus:ring-blue-500 focus:border-transparent"><span class="text-gray-600">' + escapeHtml(unit) + '</span></div></td>';
					} else {
						rowHtml += '<td class="py-4 px-6"><div class="text-center font-semibold text-gray-900">' + escapeHtml(minQty) + escapeHtml(unit) + '</div></td>';
						rowHtml += '<td class="py-4 px-6"><div class="text-center font-semibold text-gray-900">' + escapeHtml(maxQty) + escapeHtml(unit) + '</div></td>';
					}
					rowHtml += '<td class="py-4 px-6 text-center"><span class="inline-flex items-center gap-1 px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700"><i class="fas fa-check-circle w-3 h-3"></i>정상</span></td>';
					if (isEditing) {
						rowHtml += '<td class="py-4 px-6 text-center"><button onclick="handleSave(\'' + escapeHtml(materialCode) + '\')" class="inline-flex items-center gap-1 px-3 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"><i class="fas fa-save w-4 h-4"></i>저장</button></td>';
					} else {
						rowHtml += '<td class="py-4 px-6 text-center"><button onclick="handleEdit(\'' + escapeHtml(materialCode) + '\')" class="inline-flex items-center gap-1 px-3 py-1 text-blue-600 hover:text-blue-700 hover:bg-blue-50 rounded-lg transition-colors"><i class="fas fa-edit w-4 h-4"></i>수정</button></td>';
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
			if (itemCount > itemsPerPage) {
				paginationContainer.classList.remove('hidden');
			} else {
				paginationContainer.classList.add('hidden');
			}
			document.getElementById('pageInfo').textContent = currentPage + ' / ' + totalPages;
			document.getElementById('prevBtn').disabled = currentPage === 1;
			document.getElementById('nextBtn').disabled = currentPage === totalPages;
		}

		function previousPage() {
			if (currentPage > 1) {
				currentPage -= 1;
				renderTable();
			}
		}

		function nextPage() {
			var totalPages = Math.max(1, Math.ceil(getFilteredItems().length / itemsPerPage));
			if (currentPage < totalPages) {
				currentPage += 1;
				renderTable();
			}
		}

		function handleEdit(code) {
			editingCode = code;
			renderTable();
		}

		function handleSave(code) {
			var minQty = toNumber(document.getElementById('minQty_' + code).value);
			var maxQty = toNumber(document.getElementById('maxQty_' + code).value);
			if (minQty < 0 || maxQty < 0 || minQty >= maxQty) {
				alert('최소 수량은 최대 수량보다 작아야 합니다.');
				return;
			}

			fetch(apiUrl, {
				method: 'POST',
				headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
				body: JSON.stringify({ materialCode: code, minQty: minQty, maxQty: maxQty })
			})
				.then(function (response) { return response.json().then(function (payload) { return { ok: response.ok, payload: payload }; }); })
				.then(function (result) {
					if (!result.ok || !result.payload || result.payload.status !== 'success') {
						alert((result.payload && result.payload.message) || '저장에 실패했습니다.');
						return;
					}
					editingCode = null;
					loadItems();
					alert('발주 제한 설정이 저장되었습니다.');
				})
				.catch(function (error) {
					console.error(error);
					alert('저장 중 오류가 발생했습니다.');
				});
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
			alert('로그아웃 되었습니다.');
			window.location.href = '<%= request.getContextPath() %>/common/login.jsp';
		}

		loadItems();
	</script>
</body>
</html>
