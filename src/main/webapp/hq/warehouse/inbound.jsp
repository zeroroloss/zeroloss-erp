<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>본사 물류창고 입고 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<%@ page import="com.google.gson.Gson"%>
<style>
.sidebar-open .sidebar {
	transform: translateX(0);
}
</style>
<%
List<String> supplierNameList = (List<String>) request.getAttribute("supplierNameList");
Map<String, List<String>> categoryMaterialMap = (Map<String, List<String>>) request.getAttribute("categoryMaterialMap");

Gson gson = new Gson();
String supplierJson = gson.toJson(supplierNameList);
String categoryJson = gson.toJson(categoryMaterialMap);

// 품목 - 단가
Map<String, Integer> materialPriceMap = (Map<String, Integer>) request.getAttribute("materialPriceMap");
String priceJson = gson.toJson(materialPriceMap);
%>

<script>
	const supplierNameList = <%=supplierJson%>;
	const categoryMaterialMap = <%=categoryJson%>;
    const materialPriceMap = <%=priceJson%>;
</script>
</head>
<body class="bg-gray-50">

	<%@ include file="/hq/common/sidebar.jsp"%>

	<div class="lg:pl-72">
		<main class="p-6">

			<!-- ===== 페이지 헤더 ===== -->
			<div class="mb-6 flex items-center justify-between">
				<div>
					<h2 class="text-3xl font-bold text-gray-900">본사 물류창고 입고</h2>
					<p class="text-gray-500 mt-1">신규 입고를 등록하고 입고 이력을 관리하세요</p>
				</div>
				<button onclick="openReceiveModal()"
					class="flex items-center gap-2 px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors">
					<i class="fas fa-plus w-5 h-5"></i>신규 입고 등록
				</button>
			</div>

			<!-- ===== 검색 필터 영역 ===== -->
			<div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
				<div
					class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4 mb-4">
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">공급사</label>
						<select id="filterSupplier"
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
							<option value="전체">전체</option>
							<%
							if (supplierNameList != null) {
								for (String supplier : supplierNameList) {
							%>
							<option value="<%=supplier%>"><%=supplier%></option>
							<%
							}
							}
							%>
						</select>
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">카테고리</label>
						<select id="filterCategory" onchange="updateFilterItemNames()"
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
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
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">품목명</label>
						<select id="filterItemName"
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
							<option value="전체">전체</option>
						</select>
					</div>
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">일자
							범위</label>
						<div class="flex flex-col sm:flex-row sm:items-center gap-2">
							<input type="date" id="filterStartDate"
								class="w-full min-w-0 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
							<span class="text-gray-500 hidden sm:inline">~</span> <input
								type="date" id="filterEndDate"
								class="w-full min-w-0 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
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

			<!-- ===== 입고 이력 테이블 ===== -->
			<div
				class="bg-white rounded-lg border border-gray-200 overflow-hidden">
				<div
					class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
					<h3 class="text-base font-semibold text-gray-900">입고 이력 리스트</h3>
					<p class="text-base text-gray-500">
						조회 건수 <span id="totalRecords" class="font-semibold text-gray-700">0건</span>
					</p>
				</div>
				<div class="overflow-x-auto">
					<table class="w-full">
						<thead class="bg-gray-50 border-b border-gray-200">
							<tr>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">날짜/시간</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">공급사</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">카테고리</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">품목명</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">수량</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">단가</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">합계</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">유통기한</th>
							</tr>
						</thead>
						<tbody id="inboundTableBody"></tbody>
					</table>
				</div>

				<!-- 페이지네이션 -->
				<div id="paginationContainer"
					class="hidden px-6 py-4 border-t border-gray-200 flex items-center justify-between">
					<p id="paginationInfo" class="text-sm text-gray-600"></p>
					<div class="flex items-center gap-2">
						<button onclick="previousPage()" id="prevBtn"
							class="p-2 rounded-lg border border-gray-300 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
							<i class="fas fa-chevron-left w-5 h-5"></i>
						</button>
						<div id="pageButtons" class="flex items-center gap-1"></div>
						<button onclick="nextPage()" id="nextBtn"
							class="p-2 rounded-lg border border-gray-300 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">
							<i class="fas fa-chevron-right w-5 h-5"></i>
						</button>
					</div>
				</div>
			</div>

		</main>
	</div>

	<!-- ===== 신규 입고 등록 모달 ===== -->
	<div id="receiveModal"
		class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
		<div
			class="bg-white rounded-lg max-w-2xl w-full p-6 max-h-[90vh] overflow-y-auto">

			<!-- 모달 헤더 -->
			<div class="flex items-center justify-between mb-6">
				<h3 class="text-xl font-bold text-gray-900">신규 입고 등록</h3>
				<button onclick="closeReceiveModal()"
					class="text-gray-400 hover:text-gray-600">
					<i class="fas fa-times w-6 h-6"></i>
				</button>
			</div>

			<!-- 입고 등록 폼 -->
			<div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
				<!-- 공급사 -->
				<div>
					<label class="block text-sm font-medium text-gray-700 mb-2">공급사
						*</label> <select id="formSupplier"
						class="w-full px-4 py-2 border rounded-lg">
						<option value="">선택하세요</option>
						<%
						for (String supplier : supplierNameList) {
						%>
						<option value="<%=supplier%>"><%=supplier%></option>
						<%
						}
						%>
					</select>
				</div>

				<!-- 카테고리 -->
				<div>
					<label class="block text-sm font-medium text-gray-700 mb-2">카테고리
						*</label> <select id="formCategory" onchange="updateFormItemNames()"
						class="w-full px-4 py-2 border rounded-lg">
						<option value="">선택하세요</option>
						<%
						for (String category : categoryMaterialMap.keySet()) {
						%>
						<option value="<%=category%>"><%=category%></option>
						<%
						}
						%>
					</select>
				</div>

				<!-- 품목 -->
				<div>
					<label class="block text-sm font-medium text-gray-700 mb-2">품목명
						*</label> <select id="formItem" onchange="handleItemChange()"
						class="w-full px-4 py-2 border rounded-lg">
						<option value="">카테고리를 먼저 선택하세요</option>
					</select>
				</div>

				<!-- 수량 -->
				<div>
					<label class="block text-sm font-medium text-gray-700 mb-2">수량
						*</label> <input type="number" id="formQuantity" min="1"
						class="w-full px-4 py-2 border rounded-lg">
				</div>

				<!-- 단가 (자동) -->
				<div>
					<label class="block text-sm font-medium text-gray-700 mb-2">단가</label>
					<div class="px-4 py-2 border rounded-lg bg-gray-100">
						<p id="unitPriceDisplay">₩0</p>
					</div>
				</div>

				<!-- 합계 -->
				<div>
					<label class="block text-sm font-medium text-gray-700 mb-2">합계</label>
					<div class="px-4 py-2 border rounded-lg bg-gray-50">
						<p id="totalAmount">₩0</p>
					</div>
				</div>

				<!-- 유통기한 -->
				<div>
					<label class="block text-sm font-medium text-gray-700 mb-2">유통기한
						*</label> <input type="date" id="formExpiryDate"
						class="w-full px-4 py-2 border rounded-lg">
				</div>


				<div class="flex justify-end gap-2">
					<button type="button" onclick="closeReceiveModal()"
						class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium transition-colors">취소</button>
					<button type="button" onclick="handleReceive()"
						class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] font-medium transition-colors">입고
						등록</button>
				</div>
			</div>
		</div>

		<script>
    // ============================================================
    // 상수 / 설정
    // ============================================================
    var ITEMS_PER_PAGE = 10;

    // ============================================================
    // 전역 상태
    // ============================================================
    var allRecords = [];
    var filteredRecords = [];
    var currentPage = 1;
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

    document.addEventListener('click', function(e) {
        if (!e.target.closest('button[onclick="toggleUserMenu()"]') && !e.target.closest('#userMenu')) {
            document.getElementById('userMenu').classList.add('hidden');
        }
    });

    // ============================================================
    // 필터 품목명 연동
    // ============================================================
    function updateFilterItemNames() {
        var select   = document.getElementById('filterItemName');
        var categoryName = document.getElementById('filterCategory').value;
        select.innerHTML = '<option value="전체">전체</option>';
        (categoryMaterialMap[categoryName] || []).forEach(function(item) {
            var opt = document.createElement('option');
            opt.value = item;
            opt.textContent = item;
            select.appendChild(opt);
        });
    }

    // ============================================================
    // 모달 품목명 연동
    // ============================================================
    function updateFormItemNames() {
        var select   = document.getElementById('formItem');
        var categoryName = document.getElementById('formCategory').value;
        
     	// 품목 초기화
        select.innerHTML = '<option value="">선택하세요</option>';
        (categoryMaterialMap[categoryName] || []).forEach(function(item) {
            var opt = document.createElement('option');
            opt.value = item;
            opt.textContent = item;
            select.appendChild(opt);
        });
        
        // 단가 / 합계 초기화
        selectedUnitPrice = 0;
        document.getElementById('unitPriceDisplay').textContent = '₩0';
        document.getElementById('totalAmount').textContent = '₩0';
    }
    
    // ============================================================
    // 품목 선택 시 단가 자동 세팅
    // ============================================================
   	let selectedUnitPrice = 0;
   	function handleItemChange() {
   	    const itemName = document.getElementById('formItem').value;

   	    selectedUnitPrice = materialPriceMap[itemName] || 0;

   	    // 단가 표시
   	    document.getElementById('unitPriceDisplay').textContent =
   	        '₩' + selectedUnitPrice.toLocaleString('ko-KR');

   	    calculateTotal();
   	}
   	
    // ============================================================
    // 모달 열기 / 닫기
    // ============================================================
    function openReceiveModal() {
        document.getElementById('formSupplier').value  = '';
        document.getElementById('formCategory').value  = '';
        document.getElementById('formItem').innerHTML  = '<option value="">카테고리를 먼저 선택하세요</option>';
        document.getElementById('formQuantity').value  = '';
        document.getElementById('formExpiryDate').value = '';

        selectedUnitPrice = 0;

        document.getElementById('unitPriceDisplay').textContent = '₩0';
        document.getElementById('totalAmount').textContent = '₩0';

        document.getElementById('receiveModal').classList.remove('hidden');
    }

    function closeReceiveModal() {
        document.getElementById('receiveModal').classList.add('hidden');
    }

    document.getElementById('receiveModal').addEventListener('click', function(e) {
        if (e.target == this) closeReceiveModal();
    });

    // ============================================================
    // 합계 실시간 계산
    // ============================================================
    function calculateTotal() {
        const quantity = parseInt(document.getElementById('formQuantity').value) || 0;
        
        // 품목 선택 안 했으면 계산 안함
        if (selectedUnitPrice === 0) {
		    document.getElementById('totalAmount').textContent = '₩0';
		    return;
		}

        const total = quantity * selectedUnitPrice;

        document.getElementById('totalAmount').textContent =
            '₩' + total.toLocaleString('ko-KR');
    }

    // ============================================================
    // 입고 등록 (POST API)
    // ============================================================
    async function handleReceive() {
	    const supplier = document.getElementById('formSupplier').value.trim();
	    const category = document.getElementById('formCategory').value.trim();
	    const item     = document.getElementById('formItem').value.trim();
	    const quantity = parseInt(document.getElementById('formQuantity').value);
	    const expiry   = document.getElementById('formExpiryDate').value;
	
	    // 필수값 검사 (한 번에 처리)
	    const validations = [
	        [supplier, '공급사를 선택해주세요.'],
	        [category, '카테고리를 선택해주세요.'],
	        [item, '품목을 선택해주세요.'],
	        [quantity && quantity > 0, '수량을 1 이상 입력해주세요.'],
	        [expiry, '유통기한을 선택해주세요.'],
	        [selectedUnitPrice > 0, '품목을 올바르게 선택해주세요.']
	    ];
	
	    for (const [condition, message] of validations) {
	        if (!condition) {
	            alert(message);
	            return;
	        }
	    }
	
	    const payload = {
	        supplier,
	        categoryName: category,
	        itemName: item,
	        quantity,
	        unitPrice: selectedUnitPrice,
	        expiryDate: expiry
	    };
	
	    try {
	        const res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/inbound', {
	            method: 'POST',
	            headers: { 'Content-Type': 'application/json' },
	            body: JSON.stringify(payload)
	        });
	
	        const result = await res.json();
	        if (!res.ok || result.status !== 'success') {
	            throw new Error(result.message || '등록 실패');
	        }
	
	        closeReceiveModal();
	        alert('입고 처리가 완료되었습니다.');
	        applyFilters();
	
	    } catch (err) {
	        alert('입고 등록 중 오류가 발생했습니다: ' + err.message);
	    }
	}

    // ============================================================
    // 데이터 조회 (GET API)
    // ============================================================
    async function applyFilters() {
        var params = new URLSearchParams({
            supplier:  document.getElementById('filterSupplier').value,
            categoryName:  document.getElementById('filterCategory').value,
            itemName:  document.getElementById('filterItemName').value,
            startDate: document.getElementById('filterStartDate').value,
            endDate:   document.getElementById('filterEndDate').value
        });

        try {
        	var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/inbound?' + params);
					if (!res.ok) {
						var errData = await
						res.json();
						throw new Error(errData.message || 'HTTP ' + res.status);
					}
					var result = await
					res.json();
					if (!result || result.status != 'success')
						throw new Error((result && result.message) || '데이터 오류');

					allRecords = result.data || [];
					filteredRecords = allRecords;

				} catch (err) {
					allRecords = [];
					filteredRecords = [];
				}

				currentPage = 1;
				renderTable();
				document.getElementById('totalRecords').textContent = filteredRecords.length
						+ '건';
			}

			function resetFilters() {
				document.getElementById('filterSupplier').value = '전체';
				document.getElementById('filterCategory').value = '전체';
				updateFilterItemNames();
				document.getElementById('filterItemName').value = '전체';
				var today = new Date();
				var mm = String(today.getMonth() + 1).padStart(2, '0');
				var dd = String(today.getDate()).padStart(2, '0');
				var yyyy = today.getFullYear();
				var firstDay = yyyy + '-' + mm + '-01';
				var todayStr = yyyy + '-' + mm + '-' + dd;
				document.getElementById('filterStartDate').value = firstDay;
				document.getElementById('filterEndDate').value = todayStr;
				applyFilters();
			}

			// ============================================================
			// 테이블 렌더링
			// ============================================================
			function renderTable() {
				var tbody = document.getElementById('inboundTableBody');
				var totalPages = Math.ceil(filteredRecords.length
						/ ITEMS_PER_PAGE);
				var startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
				var endIndex = startIndex + ITEMS_PER_PAGE;
				var pageItems = filteredRecords.slice(startIndex, endIndex);

				tbody.innerHTML = '';

				if (pageItems.length == 0) {
					tbody.innerHTML = '<tr><td colspan="9" class="py-12 text-center text-gray-500">'
							+ '<i class="fas fa-box w-12 h-12 mx-auto mb-3 text-gray-400"></i>'
							+ '<p>조회 결과가 없습니다</p></td></tr>';
					document.getElementById('paginationContainer').classList
							.add('hidden');
					return;
				}

				pageItems
						.forEach(function(record) {
							var unitPriceFmt = record.unitPrice
									.toLocaleString('ko-KR');
							var totalFmt = record.totalPrice
									.toLocaleString('ko-KR');
							var tr = document.createElement('tr');
							tr.className = 'border-b border-gray-100 hover:bg-gray-50';
							tr.innerHTML = '<td class="py-4 px-6 text-sm text-gray-900">'
									+ record.receivedAt
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm text-gray-900">'
									+ record.supplierName
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm text-gray-600">'
									+ record.categoryName
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm font-medium text-gray-900">'
									+ record.itemName
									+ '</td>'
									+ '<td class="py-4 px-6 text-right text-sm text-gray-600">'
									+ record.quantity
									+ ' '
									+ (record.unit || '')
									+ '</td>'
									+ '<td class="py-4 px-6 text-right text-sm text-gray-600">&#8361;'
									+ unitPriceFmt
									+ '</td>'
									+ '<td class="py-4 px-6 text-right text-sm font-semibold text-[#00853D]">&#8361;'
									+ totalFmt
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm text-gray-600">'
									+ record.expiryDate + '</td>';
							tbody.appendChild(tr);
						});

				updatePagination(totalPages, startIndex, endIndex);
			}

			// ============================================================
			// 페이지네이션
			// ============================================================
			function updatePagination(totalPages, startIndex, endIndex) {
				var container = document.getElementById('paginationContainer');
				if (totalPages <= 1) {
					container.classList.add('hidden');
					return;
				}

				container.classList.remove('hidden');
				document.getElementById('paginationInfo').textContent = (startIndex + 1)
						+ '-'
						+ Math.min(endIndex, filteredRecords.length)
						+ ' / ' + filteredRecords.length + '개';

				var pageButtons = document.getElementById('pageButtons');
				pageButtons.innerHTML = '';

				for (var page = 1; page <= totalPages; page++) {
					var showPage = (page == 1 || page == totalPages || (page >= currentPage - 1 && page <= currentPage + 1));
					var showEllipsis = (page == currentPage - 2 || page == currentPage + 2);

					if (showPage) {
						var btn = document.createElement('button');
						btn.className = (page == currentPage) ? 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white'
								: 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
						btn.textContent = page;
						(function(p) {
							btn.onclick = function() {
								goToPage(p);
							};
						})(page);
						pageButtons.appendChild(btn);
					} else if (showEllipsis) {
						var span = document.createElement('span');
						span.className = 'px-2 text-gray-400';
						span.textContent = '...';
						pageButtons.appendChild(span);
					}
				}

				document.getElementById('prevBtn').disabled = (currentPage == 1);
				document.getElementById('nextBtn').disabled = (currentPage == totalPages);
			}

			function goToPage(page) {
				currentPage = page;
				renderTable();
				window.scrollTo({
					top : 0,
					behavior : 'smooth'
				});
			}

			function previousPage() {
				if (currentPage > 1)
					goToPage(currentPage - 1);
			}

			function nextPage() {
				var totalPages = Math.ceil(filteredRecords.length
						/ ITEMS_PER_PAGE);
				if (currentPage < totalPages)
					goToPage(currentPage + 1);
			}

			// ============================================================
			// 초기화
			// ============================================================
			window.addEventListener('DOMContentLoaded', function() {
				
			    document.getElementById('formQuantity').addEventListener('input', calculateTotal);

				var today = new Date();
				var mm = String(today.getMonth() + 1).padStart(2, '0');
				var dd = String(today.getDate()).padStart(2, '0');
				var yyyy = today.getFullYear();
				var firstDay = yyyy + '-' + mm + '-01';
				var todayStr = yyyy + '-' + mm + '-' + dd;
				document.getElementById('filterStartDate').value = firstDay;
				document.getElementById('filterEndDate').value = todayStr;

				updateFilterItemNames();
				applyFilters();
			});
		</script>
</body>
</html>


