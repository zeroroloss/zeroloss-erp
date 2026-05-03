<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>배차 관리 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .modal-backdrop { background-color: rgba(0, 0, 0, 0.5); }
        .modal-center { display: flex; align-items: center; justify-content: center; }
    </style>
</head>
<body class="bg-gray-50">
    <%@ include file="/hq/common/sidebar.jsp" %>
    <div class="lg:pl-72">
        <main class="p-6">
            <div class="space-y-6">

                <div>
                    <h2 class="text-3xl font-bold text-gray-900">배차 관리</h2>
                    <p class="text-gray-500 mt-2">발주 승인 건을 권역별로 그룹화하고 기사와 차량을 배정하세요</p>
                </div>

                <div>
                    <div class="flex justify-between items-center mb-4">
                        <div class="flex items-center gap-4">
                            <h3 class="text-xl font-bold text-gray-900">배차 대기 발주 건</h3>
                            <select id="regionFilter" onchange="selectRegion(this.value)" class="px-3 py-2 border border-gray-300 rounded-lg text-sm font-medium focus:ring-2 focus:ring-[#00853D] focus:border-transparent transition-shadow"></select>
                        </div>
                        <button onclick="openDispatchModal()" id="createDispatchBtn" class="px-4 py-2 bg-[#00853D] text-white rounded-lg flex items-center gap-2 text-sm whitespace-nowrap">
                            <i class="fas fa-plus w-4 h-4"></i> 배차 생성
                        </button>
                    </div>
                    <div class="bg-white rounded-lg border border-gray-200 overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">발주 번호</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">지점명</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">권역</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">요청일</th>
                                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">품목 수</th>
                                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">총 금액</th>
                                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">상세</th>
                                </tr>
                            </thead>
                            <tbody id="orderListBody" class="bg-white divide-y divide-gray-200"></tbody>
                        </table>
                    </div>
                    <div id="paginationArea" class="flex items-center justify-center gap-2 mt-6"></div>
                </div>
            </div>
        </main>
    </div>

    <!-- 배차 생성 모달 -->
    <div id="dispatchModal" class="fixed inset-0 z-40 hidden modal-center modal-backdrop">
        <div class="bg-white rounded-lg shadow-lg max-w-3xl w-full mx-4">
            <div class="border-b p-6"><h3 class="text-xl font-bold">배차 생성</h3><p class="text-sm text-gray-500 mt-1">배차할 발주 건을 선택하고, 기사와 차량을 배정하세요.</p></div>
            <div class="p-6 grid grid-cols-2 gap-6 max-h-[70vh]">
                <div class="space-y-4">
                    <h4 class="font-bold text-gray-800">1. 발주 건 선택</h4>
                    <div id="modalOrderList" class="border rounded-lg h-64 overflow-y-auto p-2 space-y-1 bg-gray-50">
                        <!-- 모달 내 발주 목록 -->
                    </div>
                </div>
                <div class="space-y-4">
                    <h4 class="font-bold text-gray-800">2. 기사 및 차량 배정</h4>
                    <div>
                        <label class="block text-sm font-medium mb-1">선택 권역</label>
                        <p id="selectedRegionText" class="px-3 py-2 border rounded-lg bg-gray-100 text-gray-600 text-sm">발주 건을 먼저 선택하세요.</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">기사 선택</label>
                        <select id="driverSelect" class="w-full px-3 py-2 border rounded-lg text-sm" disabled></select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1">차량 선택</label>
                        <select id="vehicleSelect" class="w-full px-3 py-2 border rounded-lg text-sm" disabled></select>
                    </div>
                </div>
            </div>
            <div class="border-t p-6 flex gap-2 justify-end bg-gray-50">
                <button onclick="closeDispatchModal()" class="px-4 py-2 border rounded-lg text-sm">취소</button>
                <button onclick="createDispatch()" id="modalCreateDispatchBtn" class="px-4 py-2 bg-gray-300 text-white rounded-lg text-sm" disabled>배차 생성</button>
            </div>
        </div>
    </div>

    <!-- 발주 상세 모달 -->
    <div id="orderDetailModal" class="fixed inset-0 z-50 hidden modal-center modal-backdrop">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl">
            <div class="px-6 py-4 border-b flex justify-between items-center"><h3 id="orderDetailModalTitle" class="text-xl font-bold text-gray-900"></h3><button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600"><i class="fas fa-times fa-lg"></i></button></div>
            <div id="orderDetailModalBody" class="p-6 max-h-[70vh] overflow-y-auto"></div>
            <div class="px-6 py-4 bg-gray-50 rounded-b-lg flex justify-end"><button onclick="closeDetailModal()" class="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50 text-sm font-medium">닫기</button></div>
        </div>
    </div>

<script>
let allPendingOrders = [], allRegions = [], selectedRegion = "전체", currentPage = 1, itemsPerPage = 8;
let modalSelectedOrders = new Set();

async function fetchData() {
    try {
        const res = await fetch(`/hq/delivery/dispatch?action=getPageData&_=\${new Date().getTime()}`);
        const data = await res.json();
        allPendingOrders = data.pendingOrders || [];
        if (allRegions.length === 0) {
            allRegions = [{regionCode: 'ALL', name: '전체'}, ...data.regions];
            renderRegionFilter();
        }
        renderOrders();
    } catch (error) { console.error("데이터 로딩 실패:", error); }
}

function renderRegionFilter() {
    document.getElementById("regionFilter").innerHTML = allRegions.map(r => `<option value="\${r.name}" \${selectedRegion === r.name ? 'selected' : ''}>\${r.name}</option>`).join('');
}

function renderOrders() {
    const filtered = allPendingOrders.filter(o => selectedRegion === "전체" || o.regionName === selectedRegion);
    const totalPages = Math.ceil(filtered.length / itemsPerPage);
    const paginated = filtered.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);
    document.getElementById("orderListBody").innerHTML = paginated.map(order => `
        <tr class="hover:bg-gray-50">
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">\${order.poNo}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">\${order.branchName}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm"><span class="px-2 py-1 text-xs border rounded-lg">\${order.regionName}</span></td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">\${new Date(order.requestDate).toLocaleDateString()}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-900">\${order.totalMaterialCnt}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-right font-semibold text-gray-900">\${order.totalAmount.toLocaleString()}원</td>
            <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                <button onclick="openDetailModal('\${order.poNo}')" class="px-3 py-1 text-xs font-medium border border-gray-300 text-gray-700 rounded hover:bg-gray-100 transition-colors">상세보기</button>
            </td>
        </tr>
    `).join('') || '<tr><td colspan="7" class="p-12 text-center text-gray-500">배차 대기 중인 발주가 없습니다.</td></tr>';
    renderPagination(totalPages);
}

function openDispatchModal() {
    const modal = document.getElementById('dispatchModal');
    const orderListContainer = document.getElementById('modalOrderList');

    orderListContainer.innerHTML = allPendingOrders.map(order => `
        <label class="flex items-center p-2 rounded-md hover:bg-gray-200 cursor-pointer">
            <input type="checkbox" class="modal-order-checkbox mr-3" value="\${order.poNo}" data-region-code="\${order.regionCode}" data-region-name="\${order.regionName}" onchange="handleModalOrderSelectionChange()">
            <span class="text-sm font-medium">\${order.poNo} - \${order.branchName} (\${order.regionName})</span>
        </label>
    `).join('') || '<div class="p-4 text-center text-sm text-gray-500">배차 대기 건이 없습니다.</div>';

    resetAndDisableSelectors();
    modal.classList.remove('hidden');
}

function handleModalOrderSelectionChange() {
    const checkboxes = document.querySelectorAll('.modal-order-checkbox:checked');
    modalSelectedOrders.clear();

    if (checkboxes.length > 0) {
        const firstRegionName = checkboxes[0].dataset.regionName;
        const firstRegionCode = checkboxes[0].dataset.regionCode;

        checkboxes.forEach(cb => {
            if (cb.dataset.regionName === firstRegionName) {
                modalSelectedOrders.add(cb.value);
            } else {
                cb.checked = false;
                alert("동일한 권역의 발주 건만 함께 배차할 수 있습니다.");
            }
        });

        if (modalSelectedOrders.size > 0) {
            document.getElementById('selectedRegionText').textContent = firstRegionName;
            loadDriverAndVehicleOptions(firstRegionCode);
        }
    } else {
        resetAndDisableSelectors();
    }
    updateModalCreateButton();
}

function resetAndDisableSelectors() {
    const driverSelect = document.getElementById('driverSelect');
    const vehicleSelect = document.getElementById('vehicleSelect');
    driverSelect.innerHTML = '';
    vehicleSelect.innerHTML = '';
    driverSelect.disabled = true;
    vehicleSelect.disabled = true;
    document.getElementById('selectedRegionText').textContent = '발주 건을 먼저 선택하세요.';
    updateModalCreateButton();
}

async function loadDriverAndVehicleOptions(regionCode) {
    const driverSelect = document.getElementById('driverSelect');
    const vehicleSelect = document.getElementById('vehicleSelect');
    driverSelect.innerHTML = '<option>로딩 중...</option>';
    vehicleSelect.innerHTML = '<option>로딩 중...</option>';

    try {
        const res = await fetch(`/hq/delivery/dispatch?action=getModalData&regionCode=\${regionCode}`);
        const data = await res.json();

        driverSelect.innerHTML = '<option value="">기사 선택</option>' + data.drivers.map(d => `<option value="\${d.driverId}">\${d.name} (\${d.phone})</option>`).join('');
        vehicleSelect.innerHTML = '<option value="">차량 선택</option>' + data.vehicles.map(v => `<option value="\${v.vehicleId}">\${v.plateNumber} (\${v.capacity}kg, \${v.tempType})</option>`).join('');
        driverSelect.disabled = false;
        vehicleSelect.disabled = false;
    } catch (e) {
        driverSelect.innerHTML = '<option>오류</option>';
        vehicleSelect.innerHTML = '<option>오류</option>';
    }
}

function updateModalCreateButton() {
    const btn = document.getElementById('modalCreateDispatchBtn');
    if (modalSelectedOrders.size > 0) {
        btn.disabled = false;
        btn.classList.replace('bg-gray-300', 'bg-[#00853D]');
    } else {
        btn.disabled = true;
        btn.classList.replace('bg-[#00853D]', 'bg-gray-300');
    }
}

async function createDispatch() {
    const driverId = document.getElementById('driverSelect').value;
    const vehicleId = document.getElementById('vehicleSelect').value;

    if (!driverId || !vehicleId) { alert("기사와 차량을 모두 선택해주세요."); return; }

    try {
        for (const poNo of modalSelectedOrders) {
            const res = await fetch("/hq/delivery/dispatch?action=createDispatch", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ poNo, driverId: parseInt(driverId), vehicleId: parseInt(vehicleId) })
            });
            const result = await res.json();
            if (!result.success) throw new Error(result.message || `\${poNo} 배차 생성 실패`);
        }
        alert("배차가 생성되었습니다.");
        closeDispatchModal();
        fetchData();
    } catch (error) {
        alert(error.message || "배차 생성 중 오류가 발생했습니다.");
    }
}

function closeDispatchModal() { document.getElementById('dispatchModal').classList.add('hidden'); }
async function openDetailModal(poNo) { /* 상세 모달 (이전과 동일) */ }
function closeDetailModal() { document.getElementById('orderDetailModal').classList.add('hidden'); }
function renderPagination(totalPages) { /* 페이지네이션 (이전과 동일) */ }
function selectRegion(region) { currentPage = 1; selectedRegion = region; renderOrders(); }

window.addEventListener('pageshow', (event) => fetchData());
</script>
</body>
</html>
