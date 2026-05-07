<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배송 조회 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .modal-backdrop { background-color: rgba(0, 0, 0, 0.5); }
        .modal-center { display: flex; align-items: center; justify-content: center; }
    </style>
</head>
<body class="bg-gray-50">
    <%@ include file="/hq/common/sidebar.jsp" %>

    <!-- 메인 콘텐츠 -->
    <div class="lg:pl-72">
        <main class="p-6">
            <div class="space-y-6">

                <!-- 페이지 헤더 -->
                <div>
                    <h2 class="text-3xl font-bold text-gray-900">배송 조회</h2>
                    <p class="text-gray-500 mt-2">배차된 발주 건의 배송 상태를 추적하고 관리합니다.</p>
                </div>

                <!-- 필터 영역 -->
                <div class="bg-white rounded-lg border border-gray-200 p-6 shadow-sm">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <input type="text" id="searchInput" placeholder="발주번호, 지점명, 기사명으로 검색..." onkeyup="applyFilters()" class="col-span-1 md:col-span-2 px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm transition-shadow">
                        <select id="statusFilter" onchange="applyFilters()" class="col-span-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                            <option value="">전체(배송중/배송완료)</option>
                            <option value="IN_TRANSIT">배송 중</option>
                            <option value="DELIVERED">배송 완료</option>
                        </select>
                    </div>
                </div>

                <!-- 배송 정보 테이블 -->
                <div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">배송 번호</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">발주 번호</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">지점명</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">기사명</th>
                                <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">차량 번호</th>
                                <th class="px-6 py-3 text-center text-xs font-bold text-gray-600 uppercase tracking-wider">배송 상태</th>
                                <th class="px-6 py-3 text-center text-xs font-bold text-gray-600 uppercase tracking-wider">상세</th>
                            </tr>
                        </thead>
                        <tbody id="deliveryTableBody" class="bg-white divide-y divide-gray-100">
                            <!-- 동적 데이터가 여기에 삽입됩니다. -->
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
        </main>
    </div>

    <!-- 배송 상세 모달 -->
    <div id="detailModal" class="fixed inset-0 z-50 hidden modal-center modal-backdrop">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl">
            <div class="px-6 py-4 border-b flex justify-between items-center">
                <h3 id="modalTitle" class="text-xl font-bold text-gray-900">배송 상세 정보</h3>
                <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600"><i class="fas fa-times fa-lg"></i></button>
            </div>
            <div id="modalBody" class="p-6 max-h-[70vh] overflow-y-auto">
                <!-- 모달 내용이 여기에 동적으로 채워집니다. -->
            </div>
            <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end">
                <button onclick="closeDetailModal()" class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50 text-sm font-medium">닫기</button>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '<%=request.getContextPath()%>';
        let allDeliveries = [];
        let currentPage = 1;
        const itemsPerPage = 10;
        const PAGE_SIZE = 5;

        function getStatusBadge(dispatchStatus, placeOrderStatus) {
            // 배송 완료는 입고 확정(=COMPLETED) 또는 별도 배송완료 상태일 때만 표시
            if (placeOrderStatus === 'COMPLETED' || dispatchStatus === 'DELIVERED') {
                return '<span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">배송 완료</span>';
            }
            if (dispatchStatus === 'DELIVERED') {
                return '<span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">배송 완료</span>';
            }
            if (dispatchStatus === 'IN_TRANSIT') {
                return '<span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">배송 중</span>';
            }
            // If neither IN_TRANSIT nor DELIVERED, do not show badge (will be filtered out normally)
            return '<span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">알 수 없음</span>';
        }

        async function loadDeliveries() {
            try {
                const res = await fetch(contextPath + '/hq/delivery/dispatch?action=getDeliveries&_=' + new Date().getTime());
                if (!res.ok) throw new Error('API 응답 실패: ' + res.status);
                const data = await res.json();
                allDeliveries = data || [];
                currentPage = 1;
                renderTable();
            } catch (err) {
                console.error('배차 목록 로딩 실패', err);
                allDeliveries = [];
                renderTable();
            }
        }

        function applyFilters() {
            currentPage = 1;
            renderTable();
        }

        function getEffectiveStatus(d) {
            // Effective status for display: 배송완료는 COMPLETED/dispatch DELIVERED만, 배송중은 IN_TRANSIT만
            if (!d) return null;
            const po = d.placeOrderStatus;
            if (po === 'COMPLETED') return 'DELIVERED';
            if (d.dispatchStatus === 'DELIVERED') return 'DELIVERED';
            if (d.dispatchStatus === 'IN_TRANSIT') return 'IN_TRANSIT';
            return null;
        }

        function getFilteredDeliveries() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            return allDeliveries.filter(function(d) {
                const effective = getEffectiveStatus(d);
                if (!effective) return false; // exclude non-delivery related states
                const matchesSearch = (!searchTerm) || (d.poNo && d.poNo.toLowerCase().includes(searchTerm)) || (d.branchName && d.branchName.toLowerCase().includes(searchTerm)) || (d.driverName && d.driverName.toLowerCase().includes(searchTerm));
                const matchesStatus = (!statusFilter) || (effective === statusFilter);
                return matchesSearch && matchesStatus;
            });
        }

        function renderTable() {
            const filtered = getFilteredDeliveries();
            const totalPages = Math.ceil(filtered.length / itemsPerPage);
            const start = (currentPage - 1) * itemsPerPage;
            const paginated = filtered.slice(start, start + itemsPerPage);
            const tableBody = document.getElementById('deliveryTableBody');
            let html = '';
            if (paginated.length === 0) {
                html = '<tr><td colspan="7" class="text-center py-12 text-gray-500">검색 결과가 없습니다.</td></tr>';
            } else {
                for (let i = 0; i < paginated.length; i++) {
                    const d = paginated[i];
                    const idStr = 'DLV-' + String(d.deliveryId).padStart(6, '0');
                    html += '<tr class="hover:bg-gray-50 transition-colors">';
                    html += '<td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">' + idStr + '</td>';
                    html += '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">' + (d.poNo || '-') + '</td>';
                    html += '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800 font-medium">' + (d.branchName || '-') + '</td>';
                    html += '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">' + (d.driverName || '-') + '</td>';
                    html += '<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">' + (d.vehiclePlate || '-') + '</td>';
                    html += '<td class="px-6 py-4 whitespace-nowrap text-center text-sm">' + getStatusBadge(d.dispatchStatus, d.placeOrderStatus) + '</td>';
                    html += '<td class="px-6 py-4 whitespace-nowrap text-center text-sm">' +
                        '<button onclick="openDetailModal(' + d.deliveryId + ')" class="text-blue-600 hover:text-blue-700 text-sm font-medium">상세보기</button>' +
                    '</td>';
                    html += '</tr>';
                }
            }
            tableBody.innerHTML = html;
            renderPagination(totalPages, filtered.length);
        }

        async function openDetailModal(deliveryId) {
            const delivery = allDeliveries.find(function(x) { return x.deliveryId === deliveryId; });
            if (!delivery) return;
            const modal = document.getElementById('detailModal');
            const modalTitle = document.getElementById('modalTitle');
            const modalBody = document.getElementById('modalBody');
            modalTitle.textContent = '배송 상세 정보 (발주: ' + (delivery.poNo || '-') + ')';

            // fetch order details by poNo
            let items = [];
            try {
                const res = await fetch(contextPath + '/hq/delivery/dispatch?action=getOrderDetails&poNo=' + encodeURIComponent(delivery.poNo) + '&_=' + new Date().getTime());
                if (res.ok) {
                    items = await res.json();
                } else {
                    console.warn('getOrderDetails 실패', res.status);
                }
            } catch (err) {
                console.error('상세 품목 로딩 실패', err);
            }

            let itemsHtml = '';
            if (!items || items.length === 0) {
                itemsHtml = '<tr><td colspan="4" class="px-4 py-3 text-center text-gray-500">품목 정보가 없습니다</td></tr>';
            } else {
                for (let i = 0; i < items.length; i++) {
                    const item = items[i];
                    // expected: materialName, requestedQty, approvedQty, unit
                    itemsHtml += '<tr>' +
                        '<td class="px-4 py-3 text-sm text-gray-800">' + (item.materialName || '-') + '</td>' +
                        '<td class="px-4 py-3 text-sm text-right text-gray-600">' + (item.requestedQty || item.requestedQty === 0 ? item.requestedQty : '-') + '</td>' +
                        '<td class="px-4 py-3 text-sm text-right text-gray-600">' + (item.approvedQty || item.approvedQty === 0 ? item.approvedQty : '-') + '</td>' +
                        '<td class="px-4 py-3 text-sm text-right text-gray-600">' + (item.unit || '-') + '</td>' +
                    '</tr>';
                }
            }

            modalBody.innerHTML = '' +
                '<div class="space-y-4">' +
                    '<div class="grid grid-cols-2 gap-4 text-sm">' +
                        '<div><span class="font-semibold text-gray-600">지점명:</span> ' + (delivery.branchName || '-') + '</div>' +
                        '<div><span class="font-semibold text-gray-600">기사명:</span> ' + (delivery.driverName || '-') + '</div>' +
                        '<div><span class="font-semibold text-gray-600">배송상태:</span> ' + getStatusBadge(delivery.dispatchStatus, delivery.placeOrderStatus) + '</div>' +
                        '<div><span class="font-semibold text-gray-600">차량번호:</span> ' + (delivery.vehiclePlate || '-') + '</div>' +
                    '</div>' +
                    '<div class="border rounded-lg overflow-hidden mt-4">' +
                        '<table class="min-w-full divide-y divide-gray-200">' +
                            '<thead class="bg-gray-50">' +
                                '<tr>' +
                                    '<th class="px-4 py-2 text-left text-xs font-bold text-gray-500 uppercase tracking-wider">품목명</th>' +
                                    '<th class="px-4 py-2 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">요청 수량</th>' +
                                    '<th class="px-4 py-2 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">승인 수량</th>' +
                                    '<th class="px-4 py-2 text-right text-xs font-bold text-gray-500 uppercase tracking-wider">단위</th>' +
                                '</tr>' +
                            '</thead>' +
                            '<tbody class="bg-white divide-y divide-gray-200">' + itemsHtml + '</tbody>' +
                        '</table>' +
                    '</div>' +
                '</div>';

            modal.classList.remove('hidden');
        }

        function closeDetailModal() { document.getElementById('detailModal').classList.add('hidden'); }
        function renderPagination(totalPages, totalItems) {
            const paginationContainer = document.getElementById('paginationContainer');
            const paginationInfo = document.getElementById('paginationInfo');
            const pageButtons = document.getElementById('pageButtons');

            if (totalPages <= 1) {
                paginationContainer.classList.add('hidden');
                paginationInfo.textContent = '';
                pageButtons.innerHTML = '';
                return;
            }

            paginationContainer.classList.remove('hidden');

            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = Math.min(startIndex + itemsPerPage, totalItems);

            paginationInfo.textContent =
                (startIndex + 1) + '-' + endIndex + ' / ' + totalItems + '개';

            const base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
            const active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
            const arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';

            const blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
            const blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

            let html = '';

            html += '<button class="' + arrow + '" onclick="changePage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
            html += '<i class="fas fa-angles-left text-xs"></i>';
            html += '</button>';

            const prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
            html += '<button class="' + arrow + '" onclick="changePage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
            html += '<i class="fas fa-chevron-left text-xs"></i>';
            html += '</button>';

            for (let i = blockStart; i <= blockEnd; i++) {
                html += '<button class="' + (i === currentPage ? active : base) + '" onclick="changePage(' + i + ')">';
                html += i;
                html += '</button>';
            }

            const nextBlockPage = Math.min(totalPages, blockEnd + 1);
            html += '<button class="' + arrow + '" onclick="changePage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
            html += '<i class="fas fa-chevron-right text-xs"></i>';
            html += '</button>';

            html += '<button class="' + arrow + '" onclick="changePage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
            html += '<i class="fas fa-angles-right text-xs"></i>';
            html += '</button>';

            pageButtons.innerHTML = html;
        }

        function changePage(page) {
            const totalPages = Math.ceil(getFilteredDeliveries().length / itemsPerPage);

            if (page < 1 || page > totalPages) {
                return;
            }

            currentPage = page;
            renderTable();

            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        document.addEventListener('DOMContentLoaded', function() { loadDeliveries(); });
    </script>
</body>
</html>
