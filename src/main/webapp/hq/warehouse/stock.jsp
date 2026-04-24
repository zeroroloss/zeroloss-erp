<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
Map<String, List<String>> categoryMaterialMap = (Map<String, List<String>>) request.getAttribute("categoryMaterialMap");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>본사 물류창고 재고 조회 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.sidebar-open .sidebar {
	transform: translateX(0);
}
</style>

<script>
        const categoryMaterialMap = <%=request.getAttribute("categoryMaterialJson") == null ? "{}" : request.getAttribute("categoryMaterialJson")%>;
    </script>
</head>
<body class="bg-gray-50">
	<%@ include file="/hq/common/sidebar.jsp"%>
	<div class="lg:pl-72">

		<main class="p-6">
			<div class="mb-6">
				<h2 class="text-3xl font-bold text-gray-900">본사 물류창고 재고 조회</h2>
				<p class="text-gray-500 mt-1">현재고와 변동이력을 함께 확인하세요</p>
			</div>

			<div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
				<div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">카테고리</label>
						<select id="filterCategory" onchange="updateStockItemNames()"
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
						<label class="block text-sm font-medium text-gray-700 mb-2">검색</label>
						<input type="text" id="filterSearch"
							placeholder="재고코드, 카테고리, 품목 검색"
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
					</div>
				</div>

				<div class="flex items-center gap-2">
					<button onclick="applyFilters()"
						class="px-6 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] font-medium transition-colors">
						조회하기</button>
					<button onclick="resetFilters()"
						class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium transition-colors">
						초기화</button>
				</div>
			</div>

			<!-- 상태 버튼 -->
			<div class="bg-white rounded-lg border border-gray-200 p-4 mb-6">
				<div class="flex flex-wrap gap-3" id="statusFilterButtons">
					<button type="button" data-status="전체"
						onclick="setStatusFilter('전체')"
						class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-gray-300 text-sm font-medium text-gray-700 hover:bg-gray-50">
						전체 <span id="countAll" class="text-xs text-gray-500">0건</span>
					</button>
					<button type="button" data-status="AVAILABLE"
						onclick="setStatusFilter('AVAILABLE')"
						class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-green-200 text-sm font-medium text-green-700 hover:bg-green-50">
						사용 가능 <span id="countAvailable" class="text-xs text-green-600">0건</span>
					</button>
					<button type="button" data-status="OUT_OF_STOCK"
						onclick="setStatusFilter('OUT_OF_STOCK')"
						class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-yellow-200 text-sm font-medium text-yellow-700 hover:bg-yellow-50">
						재고 없음 <span id="outOfStockCount" class="text-xs text-yellow-600">0건</span>
					</button>
					<button type="button" data-status="DISPOSED"
						onclick="setStatusFilter('DISPOSED')"
						class="status-filter-btn inline-flex items-center gap-2 px-4 py-2 rounded-lg border border-red-200 text-sm font-medium text-red-700 hover:bg-red-50">
						폐기됨 <span id="countDisposed" class="text-xs text-red-600">0건</span>
					</button>
				</div>
			</div>

			<div
				class="bg-white rounded-lg border border-gray-200 overflow-hidden">
				<div
					class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
					<div>
						<h3 class="text-base font-semibold text-gray-900">본사 물류창고 재고
							리스트</h3>
					</div>
					<p class="text-base text-gray-500">
						조회 건수 <span id="recordCount" class="font-semibold text-gray-700">0건</span>
					</p>
				</div>

				<div class="overflow-x-auto">
					<table class="w-full">
						<thead class="bg-gray-50 border-b border-gray-200">
							<tr>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">재고코드</th>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">카테고리</th>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">품목명</th>
								<th
                                    class="text-right py-4 px-6 text-sm font-semibold text-gray-900">현재 재고</th>
								<th
									class="text-left py-4 px-6 text-sm font-semibold text-gray-900">입고 시점</th>
								<th
									class="text-center py-4 px-6 text-sm font-semibold text-gray-900">상태</th>
								<th
									class="text-center py-4 px-6 text-sm font-semibold text-gray-900">상세정보</th>
							</tr>
						</thead>
						<tbody id="stockTableBody"></tbody>
					</table>
				</div>

				<div id="emptyState" class="hidden py-12 text-center">
					<i
						class="fas fa-boxes-stacked w-16 h-16 text-gray-300 mx-auto mb-4"></i>
					<p class="text-gray-500 text-lg mb-2">조회 결과가 없습니다</p>
					<p class="text-gray-400 text-sm">다른 조건으로 검색해보세요</p>
				</div>
			</div>
		</main>
	</div>
	</div>

	<div id="detailModal"
		class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
		<div
			class="bg-white rounded-lg max-w-4xl w-full p-6 max-h-[90vh] overflow-y-auto">
			<div class="flex items-center justify-between mb-6">
				<div>
					<h3 class="text-xl font-bold text-gray-900">재고 상세 정보</h3>
					<p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
				</div>
				<button onclick="closeDetailModal()"
					class="text-gray-400 hover:text-gray-600">
					<i class="fas fa-times w-6 h-6"></i>
				</button>
			</div>

			<div
				class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6 bg-gray-50 rounded-lg p-4">
				<div>
					<p class="text-sm text-gray-500">재고코드</p>
					<p class="font-semibold text-gray-900" id="detailStockCode"></p>
				</div>
				<div>
					<p class="text-sm text-gray-500">재료코드</p>
					<p class="font-semibold text-gray-900" id="detailMaterialCode"></p>
				</div>
				<div>
					<p class="text-sm text-gray-500">재료명</p>
					<p class="font-semibold text-gray-900" id="detailMaterialName"></p>
				</div>
				<div>
                    <p class="text-sm text-gray-500">현재 재고</p>
					<p class="font-semibold text-gray-900" id="detailQty"></p>
				</div>
				<div>
					<p class="text-sm text-gray-500">입고시점</p>
					<p class="font-semibold text-gray-900" id="detailReceivedAt"></p>
				</div>
				<div>
					<p class="text-sm text-gray-500">유통기한</p>
					<p class="font-semibold text-gray-900" id="detailExpiryDate"></p>
				</div>
			</div>

			<div>
				<h4 class="font-semibold text-gray-900 mb-3">변동 이력</h4>
				<div class="overflow-x-auto border border-gray-200 rounded-lg">
					<table class="w-full">
						<thead class="bg-gray-50 border-b border-gray-200">
							<tr>
								<th
									class="text-left py-3 px-4 text-sm font-semibold text-gray-900">시점</th>
								<th
									class="text-left py-3 px-4 text-sm font-semibold text-gray-900">유형</th>
								<th
                                    class="text-right py-3 px-4 text-sm font-semibold text-gray-900">변동량</th>
								<th
                                    class="text-right py-3 px-4 text-sm font-semibold text-gray-900">변동 후 재고</th>
							</tr>
						</thead>
						<tbody id="movementTableBody"></tbody>
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
        let allStocks = [];
        let filteredStocks = [];
        let currentStatusFilter = '전체';

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

        function setStatusFilter(status) {
            currentStatusFilter = status;
            updateStatusButtonStyles();
            applyFilters();
            updateStatusCounts();
        }

        function getStatusMeta(status) {
            if (status === 'AVAILABLE') {
                return { label: '사용 가능', badgeClass: 'bg-green-100 text-green-700', btnClass: ['bg-green-50', 'border-green-200', 'text-green-700'] };
            }
            if (status === 'OUT_OF_STOCK') {
                return { label: '재고 없음', badgeClass: 'bg-yellow-100 text-yellow-700', btnClass: ['bg-yellow-50', 'border-yellow-200', 'text-yellow-700'] };
            }
            if (status === 'DISPOSED') {
                return { label: '폐기됨', badgeClass: 'bg-red-100 text-red-700', btnClass: ['bg-red-50', 'border-red-200', 'text-red-700'] };
            }
            return { label: status || '-', badgeClass: 'bg-gray-100 text-gray-700', btnClass: ['bg-gray-50', 'border-gray-300', 'text-gray-700'] };
        }

        function updateStockItemNames() {
        	const categorySelect = document.getElementById("filterCategory");
            const itemNameSelect = document.getElementById('filterItemName');
            
            const selectedCategory = categorySelect.value;
            
            // 품목 초기화
            itemNameSelect.innerHTML = '<option value="전체">전체</option>';
            if (selectedCategory === "전체")
            	return;
            
            const items = categoryMaterialMap[selectedCategory];
            
            if (items && items.length > 0) {
            	items.forEach(item => {
            		const option = document.createElement("option");
            		option.value = item;
            		option.textContent = item;
            		itemNameSelect.appendChild(option);
            	});
            }
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
                    } else {
                        const meta = getStatusMeta(status);
                        button.classList.add(...meta.btnClass);
                    }
                }
            });
        }

        // 조회하기 버튼 시, AJAX로 리스트 다시 받아오기
        async function applyFilters() {
            const categoryName = document.getElementById('filterCategory').value;
            const itemName = document.getElementById('filterItemName').value;
            const search = document.getElementById('filterSearch').value.trim();
            
            const params = new URLSearchParams({
                categoryName: categoryName,
                itemName: itemName,
                keyword: search
            });

            const url = "<%=request.getContextPath()%>/api/hq/warehouse/stock?" + params.toString();

            try {
                const res = await fetch(url);

                console.log('Response 상태:', res.status);

                // HTTP 에러 처리
                if (!res.ok) {
                    const errData = await res.json();
                    throw new Error(errData.message || 'HTTP ' + res.status);
                }

                const result = await res.json();

                if (!result || result.status !== 'success') {
                    throw new Error(result?.message || '데이터 오류');
                }

                allStocks = result.data || [];
                
                filteredStocks = allStocks.filter(stock => {
                    return currentStatusFilter === '전체' ||
                        stock.status === currentStatusFilter;
                });

                renderTable();
                updateStatusCounts();
                updateStatusButtonStyles();

                document.getElementById('recordCount').textContent =
                    filteredStocks.length + '건';

            } catch (err) {
                console.error('❌ 조회 실패:', err);

                allStocks = [];
                filteredStocks = [];

                renderTable();
            }
        }

        function resetFilters() {
            document.getElementById('filterSearch').value = '';
            document.getElementById('filterCategory').value = '전체';
            updateStockItemNames();
            document.getElementById('filterItemName').value = '전체';
            currentStatusFilter = '전체';
            
            applyFilters(); // 다시 서버 조회
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

            filteredStocks.forEach(stock => {
                const meta = getStatusMeta(stock.status);

                const tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100 hover:bg-gray-50';
                tr.innerHTML =
                    '<td class="py-4 px-6 text-sm text-gray-900 font-mono">' + stock.stockNo + '</td>' +
                    '<td class="py-4 px-6 text-sm text-gray-600"><span class="px-2 py-0.5 rounded bg-gray-100">' + stock.category + '</span></td>' +
                    '<td class="py-4 px-6 text-sm font-medium text-gray-900">' + stock.materialName + '</td>' +
                    '<td class="py-4 px-6 text-right text-sm font-semibold text-gray-900">' + (stock.currentQty ?? 0) + ' ' + (stock.unit ?? '') + '</td>' +
                    '<td class="py-4 px-6 text-sm text-gray-600">' + stock.receivedAt + '</td>' +
                    '<td class="py-4 px-6 text-center"><span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ' + meta.badgeClass + '">' + meta.label + '</span></td>' +
                    '<td class="py-4 px-6 text-center"><button onclick="openDetail(\'' + stock.stockNo + '\')" class="px-3 py-1.5 text-sm text-[#00853D] hover:bg-green-50 rounded-lg transition-colors">상세정보</button></td>';
                tbody.appendChild(tr);
            });
        }

        function updateStatusCounts() {
            const availableCount = allStocks.filter(stock => stock.status === 'AVAILABLE').length;
            const outOfStockCount = allStocks.filter(stock => stock.status === 'OUT_OF_STOCK').length;
            const disposedCount = allStocks.filter(stock => stock.status === 'DISPOSED').length;

            document.getElementById('countAll').textContent = allStocks.length + '건';
            document.getElementById('countAvailable').textContent = availableCount + '건';
            document.getElementById('outOfStockCount').textContent = outOfStockCount + '건';
            document.getElementById('countDisposed').textContent = disposedCount + '건';
        }

        // 상제 정보 버튼 클릭시, 재고 번호에 해당하는 재고 변동 이력을 ajax로 가져온다.
        async function openDetail(stockNo) {
            console.log('=== openDetail 함수 호출 ===');
            console.log('stockNo:', stockNo);

            const tbody = document.getElementById('movementTableBody');

            // 1. 로딩 UI
            tbody.innerHTML = `
            <tr>
                <td colspan="4" class="py-8 text-center text-gray-500">
                    로딩 중...
                </td>
            </tr>`;

            try {
                if (!stockNo) throw new Error('재고코드가 없습니다.');
                
                // API 호출
                const detailUrl =
                    "<%=request.getContextPath()%>/api/hq/warehouse/stock/" + encodeURIComponent(stockNo);
                
                console.log('API 호출 시작:', detailUrl);
                
                const res = await fetch(detailUrl);
                console.log('API 응답 상태:', res.status, res.ok);
                
                if (!res.ok) throw new Error('API 실패: ' + res.status);

                
                const detail = await res.json();
                
                console.log('전체 API 응답:', detail);
                console.log('detail.status:', detail.status);
                console.log('detail.data:', detail.data);
                console.log('detail.data.movements:', detail.data?.movements);
                
                /* detail.data
                = { 
                    "stockNo": "...",
                    "materialCode": "...",
                    "movements": [...]
                } */
                const data = detail.data;
                
                console.log('재고 변동:', data.movements);

                // 서버 데이터 기준으로 UI 세팅
                
                document.getElementById('detailStockCode').textContent = data.stockNo;
                document.getElementById('detailMaterialCode').textContent = data.materialCode;
                document.getElementById('detailMaterialName').textContent = data.materialName;
                document.getElementById('detailQty').textContent = data.currentQty + ' ' + data.unit;
                document.getElementById('detailReceivedAt').textContent = data.receivedAt;
                document.getElementById('detailExpiryDate').textContent = data.expiryDate;
                
                const subtitleElem = document.getElementById('modalSubtitle');
                if (subtitleElem) {
                    subtitleElem.textContent = data.category + ' · ' + data.materialName;
                } else {
                    console.warn('modalSubtitle 요소를 찾을 수 없음');
                }
                
                const changes = data.movements;
                const unit = data.unit ? ' ' + data.unit : '';

                // 3. 이력 렌더링
                console.log('changes 확인:', changes);
                
                if (!changes || changes.length === 0) {
                    console.log('변동이 없음 - 이력 없음 메시지 표시');
                    tbody.innerHTML = `
                    <tr>
                        <td colspan="4" class="py-8 text-center text-gray-500">
                            이력이 없습니다.
                        </td>
                    </tr>`;
                } else {
                    console.log('변동이 있음:', changes.length, '건');
                    tbody.innerHTML = '';

                    changes.forEach((c, index) => {
                        const typeLabel =
                            c.changeType === 'INBOUND' ? '입고' :
                            c.changeType === 'OUTBOUND' ? '출고' :
                            c.changeType === 'ADJUST' ? '조정' :
                            c.changeType === 'DISPOSAL' ? '폐기' :
                            c.changeType;

                        const changedAt = c.changedAt == null ? '-' : c.changedAt;
                        const amountNumber = c.changeAmount == null ? 0 : Number(c.changeAmount);
                        const afterQty = c.afterQty == null ? 0 : c.afterQty;

                        const isInbound = c.changeType === 'INBOUND';
                        const isOutboundLike = c.changeType === 'OUTBOUND' || c.changeType === 'DISPOSAL';
                        const signedAmount = isInbound
                            ? '+' + Math.abs(amountNumber)
                            : isOutboundLike
                                ? '-' + Math.abs(amountNumber)
                                : (amountNumber > 0 ? '+' + amountNumber : String(amountNumber));

                        const typeClass = isInbound
                            ? 'text-green-700 bg-green-50'
                            : isOutboundLike
                                ? 'text-red-700 bg-red-50'
                                : 'text-amber-700 bg-amber-50';

                        const amountClass = isInbound
                            ? 'text-green-700'
                            : isOutboundLike
                                ? 'text-red-700'
                                : 'text-amber-700';

                        const row = document.createElement('tr');
                        row.className = 'border-b border-gray-100';

                        const td1 = document.createElement('td');
                        td1.className = 'py-3 px-4 text-base text-gray-800';
                        td1.textContent = changedAt;
                        
                        const td2 = document.createElement('td');
                        td2.className = 'py-3 px-4 text-base';
                        td2.innerHTML = '<span class="inline-flex items-center px-2 py-0.5 rounded font-semibold ' + typeClass + '">' + typeLabel + '</span>';
                        
                        const td3 = document.createElement('td');
                        td3.className = 'py-3 px-4 text-base text-right font-semibold ' + amountClass;
                        td3.textContent = signedAmount + unit;
                        
                        const td4 = document.createElement('td');
                        td4.className = 'py-3 px-4 text-base text-right text-gray-800 font-medium';
                        td4.textContent = afterQty + unit;
                        
                        row.appendChild(td1);
                        row.appendChild(td2);
                        row.appendChild(td3);
                        row.appendChild(td4);

                        tbody.appendChild(row);
                        
                    });
                    
                }

                console.log('모달 오픈');
                document.getElementById('detailModal').classList.remove('hidden');

            } catch (err) {
                console.error('에러 발생:', err);
                console.error('에러 메시지:', err.message);
                console.error('에러 스택:', err.stack);
                tbody.innerHTML = `
                <tr>
                    <td colspan="4" class="py-8 text-center text-red-500">
                        데이터를 불러오지 못했습니다: ${err.message}
                    </td>
                </tr>`;
            }
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
            document.getElementById('filterCategory').value = '전체';
            updateStockItemNames(); // 품목 select를 "전체"로 재구성
            document.getElementById('filterItemName').value = '전체';
            document.getElementById('filterSearch').value = '';
            currentStatusFilter = '전체';
            applyFilters(); // category=전체, item=전체, keyword=''
        });
    </script>
</body>
</html>