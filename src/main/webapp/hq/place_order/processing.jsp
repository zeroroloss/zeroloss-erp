<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>발주 요청 승인/반려 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
	    <%@ include file="/hq/common/sidebar.jsp" %>
        <!-- 메인 콘텐츠 -->
        <div class="lg:pl-72">

            <!-- 페이지 콘텐츠 -->
            <main class="p-6">
                <!-- 헤더 -->
                <div class="mb-6">
                    <h2 class="text-3xl font-bold text-gray-900">발주 요청 승인/반려</h2>
                    <p class="text-gray-500 mt-1">발주 요청을 검토하고 승인 또는 반려 처리하세요</p>
                </div>

                <!-- 알림 배너 -->
                <div id="alertBanner" class="bg-yellow-50 border-l-4 border-yellow-500 p-4 rounded-lg mb-6">
                    <div class="flex items-center gap-3">
                        <i class="fas fa-triangle-exclamation w-6 h-6 text-yellow-600 flex-shrink-0"></i>
                        <div>
                            <h3 class="font-semibold text-yellow-900">처리 대기 중인 발주 요청</h3>
                            <p class="text-sm text-yellow-700"><span class="font-bold" id="pendingCount">0</span>건의 발주 요청이 승인 대기 중입니다.</p>
                        </div>
                    </div>
                </div>

                <!-- 두 컬럼 레이아웃 -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <!-- 왼쪽: 발주 요청 목록 -->
                    <div class="lg:col-span-1">
                        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                            <div class="px-4 py-3 border-b border-gray-200 bg-gray-50">
                                <h3 class="font-semibold text-gray-900">발주 요청 목록</h3>
                                <p class="text-xs text-gray-500 mt-1"><span id="totalOrderCount">0</span>건의 발주 요청</p>
                            </div>
                            <div class="divide-y divide-gray-200 max-h-[600px] overflow-y-auto" id="orderListContainer">
                                <!-- 동적 생성 -->
                            </div>
                        </div>
                    </div>

                    <!-- 오른쪽: 발주 상세 -->
                    <div class="lg:col-span-2">
                        <div id="detailView" class="hidden bg-white rounded-lg border border-gray-200 overflow-hidden">
                            <div id="headerSection" class="px-6 py-4 border-b">
                                <div class="flex items-center justify-between mb-4">
                                    <div>
                                        <h3 class="text-lg font-bold text-gray-900" id="detailOrderNumber"></h3>
                                        <div class="flex items-center gap-4 mt-1">
                                            <div class="flex items-center gap-2 text-sm text-gray-600">
                                                <i class="fas fa-map-pin w-4 h-4"></i>
                                                <span id="detailBranch"></span>
                                            </div>
                                            <div class="flex items-center gap-2 text-sm text-gray-600">
                                                <i class="fas fa-calendar w-4 h-4"></i>
                                                <span id="detailDate"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="detailStatus"></div>
                                </div>

                                <div id="actionButtons" class="flex gap-2">
                                    <button onclick="showRejectModal()" class="flex items-center gap-2 px-4 py-2 border border-red-300 text-red-700 rounded-lg hover:bg-red-50 transition-colors text-sm">
                                        <i class="fas fa-circle-xmark w-4 h-4"></i>
                                        반려
                                    </button>
                                    <button onclick="showApproveModal()" class="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors text-sm">
                                        <i class="fas fa-check-circle w-4 h-4"></i>
                                        승인
                                    </button>
                                </div>
                            </div>

                            <!-- 항목 테이블 -->
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50 border-b border-gray-200">
                                        <tr>
                                            <th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">품목코드</th>
                                            <th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">품목명</th>
                                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">요청 수량</th>
                                            <th class="text-center py-3 px-4 text-sm font-semibold text-gray-900">최종 확정 수량</th>
                                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">지점 현재 재고</th>
                                            <th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">본사 재고</th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailItemsTable">
                                        <!-- 동적 생성 -->
                                    </tbody>
                                </table>
                            </div>

                            <!-- 요약 -->
                            <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
                                <div class="flex items-center justify-between">
                                    <span class="text-sm text-gray-600">총 품목 수</span>
                                    <span class="font-semibold text-gray-900" id="summaryItemCount"></span>
                                </div>
                                <div class="flex items-center justify-between mt-2">
                                    <span class="text-sm text-gray-600">총 요청 수량</span>
                                    <span class="font-semibold text-blue-600" id="summaryRequestedQty"></span>
                                </div>
                                <div class="flex items-center justify-between mt-2">
                                    <span class="text-sm text-gray-600">총 확정 수량</span>
                                    <span class="font-semibold text-green-600" id="summaryAdjustedQty"></span>
                                </div>
                            </div>
                        </div>

                        <div id="emptyView" class="bg-white rounded-lg border border-gray-200 p-12 text-center">
                            <i class="fas fa-eye w-16 h-16 text-gray-300 mx-auto mb-4" style="display: block;"></i>
                            <p class="text-gray-500 text-lg">발주 요청을 선택하세요</p>
                            <p class="text-gray-400 text-sm mt-2">왼쪽 목록에서 발주 요청을 클릭하면 상세 내용을 확인할 수 있습니다</p>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- 승인 모달 -->
    <div id="approveModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-lg max-w-md w-full p-6">
            <div class="flex items-center gap-3 mb-4">
                <div class="w-12 h-12 rounded-full bg-green-100 text-green-600 flex items-center justify-center">
                    <i class="fas fa-check-circle w-6 h-6"></i>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-gray-900">발주 승인 확인</h3>
                    <p class="text-sm text-gray-500" id="approveOrderNumber"></p>
                </div>
            </div>

            <div class="bg-green-50 rounded-lg p-4 mb-4 border border-green-200">
                <div class="space-y-2 text-sm">
                    <div class="flex justify-between">
                        <span class="text-green-700">요청 지점</span>
                        <span class="font-semibold text-green-900" id="approveBranch"></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-green-700">품목 수</span>
                        <span class="font-semibold text-green-900" id="approveItemCount"></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-green-700">총 수량</span>
                        <span class="font-semibold text-green-900" id="approveTotalQty"></span>
                    </div>
                </div>
            </div>

            <div class="bg-blue-50 border border-blue-200 rounded-lg p-3 mb-4">
                <p class="text-xs text-blue-800"><strong>안내:</strong> 승인 후 출고 대기 목록으로 이동하며, 출고 처리를 진행할 수 있습니다.</p>
            </div>

            <div class="flex gap-3">
                <button onclick="closeApproveModal()" class="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                    취소
                </button>
                <button onclick="handleApprove()" class="flex-1 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                    승인
                </button>
            </div>
        </div>
    </div>

    <!-- 반려 모달 -->
    <div id="rejectModal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-lg max-w-md w-full p-6">
            <div class="flex items-center gap-3 mb-4">
                <div class="w-12 h-12 rounded-full bg-red-100 text-red-600 flex items-center justify-center">
                    <i class="fas fa-circle-xmark w-6 h-6"></i>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-gray-900">발주 반려 처리</h3>
                    <p class="text-sm text-gray-500" id="rejectOrderNumber"></p>
                </div>
            </div>

            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">반려 사유 선택 <span class="text-red-500">*</span></label>
                <select id="rejectionReasonSelect" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent" onchange="updateRejectReason();">
                    <option value="요청 수량이 안전 재고의 3배를 초과합니다">요청 수량이 안전 재고의 3배를 초과합니다</option>
                    <option value="본사 재고가 부족하여 승인이 불가능합니다">본사 재고가 부족하여 승인이 불가능합니다</option>
                    <option value="최근 발주 이력과 중복되어 재검토가 필요합니다">최근 발주 이력과 중복되어 재검토가 필요합니다</option>
                    <option value="품목 승인 기준을 충족하지 못했습니다">품목 승인 기준을 충족하지 못했습니다</option>
                    <option value="기타 (직접 입력)">기타 (직접 입력)</option>
                </select>
            </div>

            <div id="customReasonDiv" class="hidden mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-2">반려 사유 입력 <span class="text-red-500">*</span></label>
                <textarea id="customReasonText" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent" rows="3" placeholder="반려 사유를 입력해주세요..."></textarea>
            </div>

            <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4">
                <p class="text-xs text-yellow-800"><strong>안내:</strong> 반려 시 지점에 사유가 전달됩니다.</p>
            </div>

            <div class="flex gap-3">
                <button onclick="closeRejectModal()" class="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                    취소
                </button>
                <button onclick="handleReject()" class="flex-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                    반려
                </button>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '<%= request.getContextPath() %>';
        const endpoint = contextPath + '/hq/place_order/processing';

        // 전역 상태
        let orders = [];
        let selectedOrder = null;
        let rejectionReason = '요청 수량이 안전 재고의 3배를 초과합니다';

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

        function normalizeStatus(status) {
            if (!status) return 'PENDING';
            return String(status).toUpperCase();
        }

        // 상태 배지 생성
        function getStatusBadge(status) {
            const normalized = normalizeStatus(status);

            if (normalized === 'PENDING') {
                return '<span class="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-700"><i class="fas fa-hourglass-half w-3 h-3"></i>대기중</span>';
            } else if (normalized === 'APPROVED') {
                return '<span class="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700"><i class="fas fa-check-circle w-3 h-3"></i>승인완료</span>';
            } else if (normalized === 'REJECTED') {
                return '<span class="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-700"><i class="fas fa-circle-xmark w-3 h-3"></i>반려</span>';
            }
            return '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-600">-</span>';
        }

        function toOrderView(row) {
            return {
                poId: row.poId,
                orderNumber: row.poNo,
                branch: row.branchName,
                date: row.requestDate,
                status: normalizeStatus(row.status),
                totalMaterialCnt: row.totalMaterialCnt || 0,
                totalRequestedQty: row.totalRequestedQty || 0,
                details: []
            };
        }

        async function fetchPendingOrders() {
            const res = await fetch(endpoint + '?action=list');
            const json = await res.json();
            if (!res.ok || json.status !== 'success') {
                throw new Error((json && json.message) || '목록 조회 실패');
            }
            const rows = Array.isArray(json.data) ? json.data : [];
            return rows.map(toOrderView);
        }

        async function fetchOrderDetail(poNo) {
            const res = await fetch(endpoint + '?action=detail&poNo=' + encodeURIComponent(poNo));
            const json = await res.json();
            if (!res.ok || json.status !== 'success') {
                throw new Error((json && json.message) || '상세 조회 실패');
            }

            const data = json.data || {};
            const details = Array.isArray(data.details) ? data.details : [];
            return {
                poId: data.poId,
                orderNumber: data.poNo,
                branch: data.branchName,
                date: data.requestDate,
                status: normalizeStatus(data.status),
                rejectReason: data.rejectReason,
                details: details.map(function(item) {
                    return {
                        poDetailId: item.poDetailId,
                        itemCode: item.materialCode,
                        itemName: item.materialName,
                        requestedQty: Number(item.requestedQty || 0),
                        adjustedQty: Number(item.approvedQty || 0),
                        unit: item.unit || '',
                        currentStock: Number(item.currentBranchStock || 0),
                        safetyStock: Number(item.safeStockQty || 0),
                        warehouseStock: Number(item.warehouseStockQty || 0)
                    };
                })
            };
        }

        async function submitApprove(order) {
            const payload = {
                action: 'approve',
                poNo: order.orderNumber,
                details: (order.details || []).map(function(item) {
                    return {
                        poDetailId: item.poDetailId,
                        approvedQty: Number(item.adjustedQty || 0)
                    };
                })
            };

            const res = await fetch(endpoint, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            const json = await res.json();
            if (!res.ok || json.status !== 'success') {
                throw new Error((json && json.message) || '승인 실패');
            }
        }

        async function submitReject(order, reason) {
            const payload = {
                action: 'reject',
                poNo: order.orderNumber,
                rejectReason: reason
            };

            const res = await fetch(endpoint, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            const json = await res.json();
            if (!res.ok || json.status !== 'success') {
                throw new Error((json && json.message) || '반려 실패');
            }
        }

        // 발주 목록 렌더링
        function renderOrderList() {
            const container = document.getElementById('orderListContainer');
            container.innerHTML = '';

            // 대기중(PENDING) 상태의 주문만 필터링
            const pendingOrders = orders.filter(function(order) { return normalizeStatus(order.status) === 'PENDING'; });

            pendingOrders.forEach(function(order) {
                const totalQty = order.totalRequestedQty || 0;
                const isSelected = selectedOrder && selectedOrder.poId === order.poId;
                const bgClass = isSelected ? 'bg-blue-50 border-l-4 border-blue-500' : 'hover:bg-gray-50';

                const div = document.createElement('div');
                div.className = 'p-4 cursor-pointer transition-colors ' + bgClass;
                div.onclick = function() { selectOrder(order); };
                
                const statusBadge = getStatusBadge(order.status);
                const content = '<div class="space-y-2"><div class="flex items-start justify-between gap-2"><div class="flex-1 min-w-0"><h4 class="font-semibold text-sm text-gray-900 truncate">' + order.orderNumber + '</h4><div class="flex items-center gap-1 mt-1"><i class="fas fa-map-pin w-3 h-3 text-gray-400 flex-shrink-0"></i><span class="text-xs text-gray-600">' + order.branch + '</span></div></div>' + statusBadge + '</div><div class="flex items-center gap-1"><i class="fas fa-calendar w-3 h-3 text-gray-400"></i><span class="text-xs text-gray-500">' + order.date + '</span></div><div class="text-xs text-gray-600">품목 ' + order.totalMaterialCnt + '개 · 수량 합계 ' + totalQty + '</div></div>';
                div.innerHTML = content;
                container.appendChild(div);
            });

            document.getElementById('totalOrderCount').textContent = pendingOrders.length;
            const pendingCount = pendingOrders.length;
            document.getElementById('pendingCount').textContent = pendingCount;
        }

        // 발주 선택
        async function selectOrder(order) {
            try {
                selectedOrder = await fetchOrderDetail(order.orderNumber);
                renderOrderList();
                renderOrderDetail();
            } catch (err) {
                alert(err.message);
            }
        }

        // 발주 상세 렌더링
        function renderOrderDetail() {
            if (!selectedOrder) {
                document.getElementById('detailView').classList.add('hidden');
                document.getElementById('emptyView').classList.remove('hidden');
                return;
            }

            document.getElementById('detailView').classList.remove('hidden');
            document.getElementById('emptyView').classList.add('hidden');

            document.getElementById('detailOrderNumber').textContent = selectedOrder.orderNumber;
            document.getElementById('detailBranch').textContent = selectedOrder.branch;
            document.getElementById('detailDate').textContent = selectedOrder.date;
            document.getElementById('detailStatus').innerHTML = getStatusBadge(selectedOrder.status);

            // 헤더 배경색 변경
            const headerSection = document.getElementById('headerSection');
            headerSection.className = 'px-6 py-4 border-b';
            if (selectedOrder.status === 'PENDING') {
                headerSection.classList.add('bg-yellow-50', 'border-yellow-200');
            } else if (selectedOrder.status === 'APPROVED') {
                headerSection.classList.add('bg-green-50', 'border-green-200');
            } else if (selectedOrder.status === 'REJECTED') {
                headerSection.classList.add('bg-red-50', 'border-red-200');
            }

            // 액션 버튼 표시/숨김
            const actionButtons = document.getElementById('actionButtons');
            if (selectedOrder.status === 'PENDING') {
                actionButtons.style.display = 'flex';
            } else {
                actionButtons.style.display = 'none';
            }

            // 항목 테이블 렌더링
            const tbody = document.getElementById('detailItemsTable');
            tbody.innerHTML = '';

            selectedOrder.details.forEach(function(item) {
                const tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100';

                const currentStockColor = item.currentStock < item.safetyStock ? 'text-red-600' : 'text-gray-900';

                let adjustedQtyHTML;
                if (selectedOrder.status === 'PENDING') {
                    adjustedQtyHTML = '<div class="flex items-center justify-center gap-2"><input type="number" value="' + item.adjustedQty + '" onchange="updateAdjustedQty(' + item.poDetailId + ', this.value)" min="0" class="w-24 px-3 py-2 border border-gray-300 rounded-lg text-center font-semibold text-green-600 focus:ring-2 focus:ring-green-500 focus:border-transparent"><span class="text-gray-600">' + item.unit + '</span><i class="fas fa-edit w-4 h-4 text-gray-400"></i></div>';
                } else {
                    adjustedQtyHTML = '<div class="text-center font-semibold text-green-600">' + item.adjustedQty + item.unit + '</div>';
                }

                tr.innerHTML = '<td class="py-4 px-4 font-mono text-sm text-gray-600">' + item.itemCode + '</td><td class="py-4 px-4 font-medium text-gray-900">' + item.itemName + '</td><td class="py-4 px-4 text-right font-semibold text-blue-600">' + item.requestedQty + item.unit + '</td><td class="py-4 px-4">' + adjustedQtyHTML + '</td><td class="py-4 px-4 text-right font-semibold ' + currentStockColor + '">' + item.currentStock + item.unit + '</td><td class="py-4 px-4 text-right font-semibold text-gray-900">' + item.warehouseStock + item.unit + '</td>';

                tbody.appendChild(tr);
            });

            // 요약 업데이트
            const totalRequested = selectedOrder.details.reduce(function(sum, item) { return sum + item.requestedQty; }, 0);
            const totalAdjusted = selectedOrder.details.reduce(function(sum, item) { return sum + item.adjustedQty; }, 0);

            document.getElementById('summaryItemCount').textContent = selectedOrder.details.length + '개';
            document.getElementById('summaryRequestedQty').textContent = totalRequested;
            document.getElementById('summaryAdjustedQty').textContent = totalAdjusted;
        }

        // 최종 확정 수량 업데이트
        function updateAdjustedQty(poDetailId, newQty) {
            if (!selectedOrder) return;

            selectedOrder.details.forEach(function(item) {
                if (item.poDetailId === poDetailId) {
                    item.adjustedQty = Math.max(0, Number(newQty));
                }
            });
            renderOrderDetail();
        }

        function removeSelectedOrderFromList() {
            if (!selectedOrder) return;

            const poId = selectedOrder.poId;
            orders = orders.filter(function(order) { return order.poId !== poId; });
            selectedOrder = null;
            renderOrderList();
            renderOrderDetail();
        }

        async function reloadPendingOrders() {
            orders = await fetchPendingOrders();
            if (selectedOrder) {
                const exists = orders.some(function(order) { return order.poId === selectedOrder.poId; });
                if (!exists) {
                    selectedOrder = null;
                }
            }
            renderOrderList();
            renderOrderDetail();
        }

        // 승인 모달 표시
        function showApproveModal() {
            if (!selectedOrder) return;

            document.getElementById('approveOrderNumber').textContent = selectedOrder.orderNumber;
            document.getElementById('approveBranch').textContent = selectedOrder.branch;
            document.getElementById('approveItemCount').textContent = selectedOrder.details.length + '개';
            const totalQty = selectedOrder.details.reduce(function(sum, item) { return sum + item.adjustedQty; }, 0);
            document.getElementById('approveTotalQty').textContent = totalQty;
            
            document.getElementById('approveModal').classList.remove('hidden');
        }

        // 승인 모달 닫기
        function closeApproveModal() {
            document.getElementById('approveModal').classList.add('hidden');
        }

        // 승인 처리
        async function handleApprove() {
            if (!selectedOrder) return;

            try {
                await submitApprove(selectedOrder);
                alert(selectedOrder.branch + '의 발주서가 승인되었습니다.');
                closeApproveModal();
                removeSelectedOrderFromList();
                await reloadPendingOrders();
            } catch (err) {
                alert(err.message);
            }
        }

        // 반려 모달 표시
        function showRejectModal() {
            if (!selectedOrder) return;

            document.getElementById('rejectOrderNumber').textContent = selectedOrder.orderNumber;
            document.getElementById('rejectionReasonSelect').value = '요청 수량이 안전 재고의 3배를 초과합니다';
            document.getElementById('customReasonText').value = '';
            document.getElementById('customReasonDiv').classList.add('hidden');
            rejectionReason = '요청 수량이 안전 재고의 3배를 초과합니다';
            
            document.getElementById('rejectModal').classList.remove('hidden');
        }

        // 반려 모달 닫기
        function closeRejectModal() {
            document.getElementById('rejectModal').classList.add('hidden');
        }

        // 반려 사유 업데이트
        function updateRejectReason() {
            const value = document.getElementById('rejectionReasonSelect').value;
            rejectionReason = value;

            if (value === '기타 (직접 입력)') {
                document.getElementById('customReasonDiv').classList.remove('hidden');
            } else {
                document.getElementById('customReasonDiv').classList.add('hidden');
            }
        }

        // 반려 처리
        async function handleReject() {
            if (!selectedOrder) return;

            let finalReason = rejectionReason;
            if (rejectionReason === '기타 (직접 입력)') {
                finalReason = document.getElementById('customReasonText').value.trim();
            }

            if (!finalReason) {
                alert('반려 사유를 입력해주세요.');
                return;
            }

            try {
                await submitReject(selectedOrder, finalReason);
                alert(selectedOrder.branch + '의 발주서가 반려되었습니다.');
                closeRejectModal();
                removeSelectedOrderFromList();
                await reloadPendingOrders();
            } catch (err) {
                alert(err.message);
            }
        }

        // 모달 외부 클릭 시 닫기
        document.getElementById('approveModal').addEventListener('click', function(e) {
            if (e.target === this) closeApproveModal();
        });

        document.getElementById('rejectModal').addEventListener('click', function(e) {
            if (e.target === this) closeRejectModal();
        });

        // 사용자 메뉴 외부 클릭 시 닫기
        document.addEventListener('click', function(e) {
            const userMenu = document.getElementById('userMenu');
            if (!e.target.closest('button[onclick="toggleUserMenu()"]') && 
                !e.target.closest('#userMenu')) {
                userMenu.classList.add('hidden');
            }
        });

        // 초기화
        window.addEventListener('DOMContentLoaded', async function() {
            try {
                await reloadPendingOrders();
            } catch (err) {
                alert(err.message);
            }
        });
    </script>
</body>
</html>


