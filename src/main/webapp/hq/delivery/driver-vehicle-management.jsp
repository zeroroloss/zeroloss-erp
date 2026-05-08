<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기사/차량 관리 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .modal-backdrop { background-color: rgba(0, 0, 0, 0.5); }
        .modal-center { display: flex; align-items: center; justify-content: center; }
    </style>
    <script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
</head>
<body class="bg-gray-50">
<%@ include file="/hq/common/sidebar.jsp" %>
<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <!-- Header, Search, Tabs -->
            <div>
                <h2 class="text-3xl font-bold text-gray-900">기사/차량 관리</h2>
                <p class="text-gray-500 mt-2">배송 업무를 수행하는 기사와 차량 정보를 관리하세요</p>
            </div>
            <div class="bg-white rounded-lg border border-gray-200 p-6 shadow-sm">
                <input type="text" id="searchInput" placeholder="기사명, 전화번호, 차량번호로 검색..." onkeyup="applySearch()" class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm transition-shadow">
            </div>
            <div class="flex justify-between items-end border-b border-gray-200">
                <div class="flex gap-2">
                    <button onclick="switchTab('drivers')" id="driversTabBtn" class="px-5 py-3.5 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors -mb-px"><i class="fas fa-user w-4 h-4"></i> 기사</button>
                    <button onclick="switchTab('vehicles')" id="vehiclesTabBtn" class="px-5 py-3.5 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors -mb-px"><i class="fas fa-truck w-4 h-4"></i> 차량</button>
                </div>
                <div class="pb-2">
                    <button id="addDriverBtn" onclick="openAddDriverModal()" class="px-5 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] shadow-sm flex items-center gap-2 text-sm font-medium"> <i class="fas fa-plus w-4 h-4"></i> 기사 추가</button>
                    <button id="addVehicleBtn" onclick="openAddVehicleModal()" class="hidden px-5 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] shadow-sm flex items-center gap-2 text-sm font-medium"><i class="fas fa-plus w-4 h-4"></i> 차량 추가</button>
                </div>
            </div>

            <!-- 기사 탭 -->
            <div id="driversTab" class="space-y-4">
                <div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden mt-2">
                    <div class="bg-gray-50 border-b border-gray-200"><div class="grid grid-cols-10 gap-4 px-6 py-4 text-sm font-bold text-gray-700"><div class="col-span-2">이름</div><div class="col-span-3">전화번호</div><div class="col-span-2">담당 권역</div><div class="col-span-1 text-center">상태</div><div class="col-span-2 text-center">액션</div></div></div>
                    <div id="driversListBody" class="divide-y divide-gray-100"></div>
                </div>
                <div id="driversPaginationArea" class="flex items-center justify-center gap-2 mt-6"></div>
            </div>

            <!-- 차량 탭 -->
            <div id="vehiclesTab" class="space-y-4 hidden">
                <div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden mt-2">
                    <div class="bg-gray-50 border-b border-gray-200"><div class="grid grid-cols-10 gap-4 px-6 py-4 text-sm font-bold text-gray-700"><div class="col-span-2">차량번호</div><div class="col-span-2 text-center">크기(kg)</div><div class="col-span-2 text-center">온도</div><div class="col-span-2 text-center">활성화 상태</div><div class="col-span-1 text-center">상태</div><div class="col-span-1 text-center">액션</div></div></div>
                    <div id="vehiclesListBody" class="divide-y divide-gray-100"></div>
                </div>
                <div id="vehiclesPaginationArea" class="flex items-center justify-center gap-2 mt-6"></div>
            </div>
        </div>
    </main>
</div>

<!-- 기사 모달 -->
<div id="driverModal" class="fixed inset-0 z-50 hidden modal-center modal-backdrop">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-lg"><div class="px-6 py-4 border-b"><h3 id="driverModalTitle" class="text-xl font-bold"></h3></div><div class="p-6 space-y-4"><input type="hidden" id="driverId"><div><label for="driverCandidate" class="block text-sm font-medium text-gray-700 mb-1">기사 선택</label><select id="driverCandidate" class="w-full px-3 py-2 border rounded-md"></select><p id="driverNameDisplay" class="hidden mt-2 text-lg font-semibold"></p></div><div><label for="driverRegion" class="block text-sm font-medium text-gray-700 mb-1">담당 권역</label><select id="driverRegion" class="w-full px-3 py-2 border rounded-md"></select></div><div><label class="block text-sm font-medium text-gray-700 mb-2">상태</label><div class="flex gap-4"><label class="inline-flex items-center"><input type="radio" name="driverStatus" value="true" class="form-radio"><span class="ml-2">활동중</span></label><label class="inline-flex items-center"><input type="radio" name="driverStatus" value="false" class="form-radio"><span class="ml-2">비활동</span></label></div></div></div><div class="px-6 py-4 bg-gray-50 flex justify-between"><button id="deleteDriverBtn" onclick="handleDeleteDriver()" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700">삭제</button><div class="flex gap-2"><button onclick="closeDriverModal()" class="px-4 py-2 bg-white border rounded-md">취소</button><button onclick="handleSaveDriver()" class="px-4 py-2 bg-[#00853D] text-white rounded-md">저장</button></div></div></div>
</div>

<!-- 차량 모달 -->
<div id="vehicleModal" class="fixed inset-0 z-50 hidden modal-center modal-backdrop">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-lg"><div class="px-6 py-4 border-b"><h3 id="vehicleModalTitle" class="text-xl font-bold"></h3></div><div class="p-6 space-y-4"><input type="hidden" id="vehicleId"><div><label for="plateNumber" class="block text-sm font-medium text-gray-700 mb-1">차량번호</label><input type="text" id="plateNumber" class="w-full px-3 py-2 border rounded-md"></div><div class="grid grid-cols-2 gap-4"><div><label for="vehicleCapacity" class="block text-sm font-medium text-gray-700 mb-1">용량(kg)</label><input type="number" id="vehicleCapacity" class="w-full px-3 py-2 border rounded-md"></div><div><label for="vehicleTempType" class="block text-sm font-medium text-gray-700 mb-1">온도 유형</label><select id="vehicleTempType" class="w-full px-3 py-2 border rounded-md"><option>일반</option><option>냉장</option><option>냉동</option><option>냉장/냉동</option></select></div></div><div><label for="vehicleRegion" class="block text-sm font-medium text-gray-700 mb-1">소속 권역</label><select id="vehicleRegion" class="w-full px-3 py-2 border rounded-md"></select></div><div class="grid grid-cols-2 gap-4"><div><label class="block text-sm font-medium text-gray-700 mb-2">차량 상태</label><select id="vehicleStatus" class="w-full px-3 py-2 border rounded-md"><option value="AVAILABLE">가용</option><option value="IN_TRANSIT">배송 중</option><option value="MAINTENANCE">점검 중</option></select></div><div><label class="block text-sm font-medium text-gray-700 mb-2">활성화 상태</label><div class="flex gap-4 pt-2"><label class="inline-flex items-center"><input type="radio" name="vehicleActive" value="true" class="form-radio"><span class="ml-2">활성</span></label><label class="inline-flex items-center"><input type="radio" name="vehicleActive" value="false" class="form-radio"><span class="ml-2">비활성</span></label></div></div></div></div><div class="px-6 py-4 bg-gray-50 flex justify-between"><button id="deleteVehicleBtn" onclick="handleDeleteVehicle()" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700">삭제</button><div class="flex gap-2"><button onclick="closeVehicleModal()" class="px-4 py-2 bg-white border rounded-md">취소</button><button onclick="handleSaveVehicle()" class="px-4 py-2 bg-[#00853D] text-white rounded-md">저장</button></div></div></div>
</div>

<script>
// 전역 변수, fetchData, 페이지네이션, 탭 전환, 검색 로직 등
let allDrivers = [], allVehicles = [], currentTab = 'drivers', searchTerm = '', currentDriverPage = 1, currentVehiclePage = 1;
const itemsPerPage = 10;
const PAGE_SIZE = 5;
const contextPath = '<%=request.getContextPath()%>';

async function fetchData() {
    try {
        const [driversRes, vehiclesRes] = await Promise.all([
            fetch(contextPath + '/hq/delivery/driver-vehicle?action=getDrivers'),
            fetch(contextPath + '/hq/delivery/driver-vehicle?action=getVehicles')
        ]);
        allDrivers = await driversRes.json();
        allVehicles = await vehiclesRes.json();
        switchTab(currentTab);
    } catch (error) { console.error('Data loading failed:', error); }
}

function renderDrivers() {
    const filtered = allDrivers.filter(function(d) {
        return String(d.name || '').toLowerCase().includes(searchTerm) ||
               String(d.phone || '').toLowerCase().includes(searchTerm);
    });

    const totalPages = Math.ceil(filtered.length / itemsPerPage);
    const paginated = filtered.slice(
        (currentDriverPage - 1) * itemsPerPage,
        currentDriverPage * itemsPerPage
    );

    let html = '';

    if (paginated.length === 0) {
        html = '<div class="p-12 text-center text-gray-500">결과 없음</div>';
    } else {
        paginated.forEach(function(d) {
            html += '<div class="grid grid-cols-10 gap-4 px-6 py-4 text-sm items-center hover:bg-gray-50">';

            html += '<div class="col-span-2 font-medium">' + (d.name || '-') + '</div>';
            html += '<div class="col-span-3">' + (d.phone || '-') + '</div>';

            html += '<div class="col-span-2">';
            html += '<span class="px-2.5 py-1 text-xs font-medium border rounded-md">';
            html += (d.regionName || '-');
            html += '</span>';
            html += '</div>';

            html += '<div class="col-span-1 text-center">';
            html += '<span class="px-2.5 py-1 text-xs font-bold border rounded-full ';
            html += d.active ? 'bg-green-50 text-green-700' : 'bg-gray-100 text-gray-600';
            html += '">';
            html += d.active ? '활동중' : '비활동';
            html += '</span>';
            html += '</div>';

            html += '<div class="col-span-2 text-center">';
            html += '<button onclick="openEditDriverModal(' + d.driverId + ')" class="text-blue-600 hover:text-blue-700">';
            html += '<i class="fas fa-edit w-4 h-4"></i> 수정';
            html += '</button>';
            html += '</div>';

            html += '</div>';
        });
    }

    document.getElementById('driversListBody').innerHTML = html;
    renderPagination('driversPaginationArea', totalPages, currentDriverPage, 'changeDriverPage');
}

function renderVehicles() {
    const filtered = allVehicles.filter(function(v) {
        return String(v.plateNumber || '').toLowerCase().includes(searchTerm);
    });

    const totalPages = Math.ceil(filtered.length / itemsPerPage);
    const paginated = filtered.slice(
        (currentVehiclePage - 1) * itemsPerPage,
        currentVehiclePage * itemsPerPage
    );

    let html = '';

    if (paginated.length === 0) {
        html = '<div class="p-12 text-center text-gray-500">결과 없음</div>';
    } else {
        paginated.forEach(function(v) {
            const statusClassMap = {
                AVAILABLE: 'bg-green-50 text-green-700',
                IN_TRANSIT: 'bg-blue-50 text-blue-700',
                MAINTENANCE: 'bg-yellow-50 text-yellow-700'
            };

            const statusTextMap = {
                AVAILABLE: '가용',
                IN_TRANSIT: '배송 중',
                MAINTENANCE: '점검 중'
            };

            html += '<div class="grid grid-cols-10 gap-4 px-6 py-4 text-sm items-center hover:bg-gray-50">';

            html += '<div class="col-span-2 font-medium">' + (v.plateNumber || '-') + '</div>';
            html += '<div class="col-span-2 text-center">' + (v.capacity || '-') + '</div>';

            html += '<div class="col-span-2 text-center">';
            html += '<span class="px-2.5 py-1 text-xs border rounded-md">' + (v.tempType || '-') + '</span>';
            html += '</div>';

            html += '<div class="col-span-2 text-center">';
            html += '<span class="px-2.5 py-1 text-xs font-bold border rounded-full whitespace-nowrap ';
            html += v.active ? 'bg-green-50 text-green-700' : 'bg-gray-100 text-gray-600';
            html += '">';
            html += v.active ? '활성' : '비활성';
            html += '</span>';
            html += '</div>';

            html += '<div class="col-span-1 text-center">';
            html += '<span class="px-2.5 py-1 text-xs font-bold border rounded-full ';
            html += statusClassMap[v.status] || 'bg-gray-100 text-gray-600';
            html += '">';
            html += statusTextMap[v.status] || '-';
            html += '</span>';
            html += '</div>';

            html += '<div class="col-span-1 text-center">';
            html += '<button onclick="openEditVehicleModal(' + v.vehicleId + ')" class="text-blue-600 hover:text-blue-700">';
            html += '<i class="fas fa-edit w-4 h-4"></i> 수정';
            html += '</button>';
            html += '</div>';

            html += '</div>';
        });
    }

    document.getElementById('vehiclesListBody').innerHTML = html;
    renderPagination('vehiclesPaginationArea', totalPages, currentVehiclePage, 'changeVehiclePage');
}

// Driver Modal (handleDeleteDriver 수정)
async function openAddDriverModal() {
    document.getElementById('driverModalTitle').textContent = '신규 기사 추가';
    document.getElementById('driverId').value = '';
    document.getElementById('driverCandidate').classList.remove('hidden');
    document.getElementById('driverNameDisplay').classList.add('hidden');
    document.getElementById('deleteDriverBtn').classList.add('hidden');
    const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=getAddDriverFormData');
    const data = await res.json();
    document.getElementById('driverCandidate').innerHTML = '<option value="">선택...</option>' + data.candidates.map(function(c) { return '<option value="' + c.empNo + '">' + c.name + '</option>'; }).join('');
    document.getElementById('driverRegion').innerHTML = data.regions.map(function(r) { return '<option value="' + r.regionCode + '">' + r.name + '</option>'; }).join('');
    document.querySelector('input[name="driverStatus"][value="true"]').checked = true;
    document.getElementById('driverModal').classList.remove('hidden');
}
async function openEditDriverModal(id) {
    document.getElementById('driverModalTitle').textContent = '기사 정보 수정';
    document.getElementById('driverId').value = id;
    document.getElementById('driverCandidate').classList.add('hidden');
    document.getElementById('driverNameDisplay').classList.remove('hidden');
    document.getElementById('deleteDriverBtn').classList.remove('hidden');
    const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=getEditDriverFormData&driverId=' + id);
    const data = await res.json();
    document.getElementById('driverNameDisplay').textContent = data.driver.name;
    document.getElementById('driverRegion').innerHTML = data.regions.map(function(r) { return '<option value="' + r.regionCode + '" ' + (r.regionCode === data.driver.regionCode ? 'selected' : '') + '>' + r.name + '</option>'; }).join('');
    document.querySelector('input[name="driverStatus"][value="' + data.driver.active + '"]').checked = true;
    document.getElementById('driverModal').classList.remove('hidden');
}
function closeDriverModal() { document.getElementById('driverModal').classList.add('hidden'); }
async function handleSaveDriver() {
    const id = document.getElementById('driverId').value;
    const data = {
        driverId: id ? parseInt(id) : 0,
        empNo: id ? 0 : parseInt(document.getElementById('driverCandidate').value),
        regionCode: document.getElementById('driverRegion').value,
        active: document.querySelector('input[name="driverStatus"]:checked').value === 'true'
    };
    if (!id && !data.empNo) { commonShowAlert('알림','기사를 선택하세요.'); return; }
    const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=' + (id ? 'updateDriver' : 'addDriver'), { method: 'POST', body: JSON.stringify(data) });
    const result = await res.json();
    if (result.success) { commonShowAlert('알림','저장되었습니다.'); closeDriverModal(); fetchData(); }
    else { commonShowAlert('알림',result.message || '저장 실패'); }
}
async function handleDeleteDriver() {
    commonShowConfirm('확인', '정말 삭제하시겠습니까?', async function() {
        const id = document.getElementById('driverId').value;
        const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=deleteDriver&driverId=' + id, { method: 'POST' });
        const result = await res.json();
        if (result.success) { commonShowAlert('알림','삭제되었습니다.'); closeDriverModal(); fetchData(); }
        else { commonShowAlert('알림',result.message || '삭제 실패'); }
    });
}

// Vehicle Modal (수정됨)
async function openAddVehicleModal() {
    document.getElementById('vehicleModalTitle').textContent = '신규 차량 추가';
    document.getElementById('vehicleId').value = '';
    document.getElementById('deleteVehicleBtn').classList.add('hidden');
    const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=getAddVehicleFormData');
    const data = await res.json();
    document.getElementById('vehicleRegion').innerHTML = data.regions.map(function(r) { return '<option value="' + r.regionCode + '">' + r.name + '</option>'; }).join('');
    document.getElementById('plateNumber').value = '';
    document.getElementById('vehicleCapacity').value = 1000;
    document.querySelector('input[name="vehicleActive"][value="true"]').checked = true;
    document.getElementById('vehicleModal').classList.remove('hidden');
}
async function openEditVehicleModal(id) {
    document.getElementById('vehicleModalTitle').textContent = '차량 정보 수정';
    document.getElementById('vehicleId').value = id;
    document.getElementById('deleteVehicleBtn').classList.remove('hidden');
    const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=getEditVehicleFormData&vehicleId=' + id);
    const data = await res.json();
    document.getElementById('plateNumber').value = data.vehicle.plateNumber;
    document.getElementById('vehicleCapacity').value = data.vehicle.capacity;
    document.getElementById('vehicleTempType').value = data.vehicle.tempType;
    document.getElementById('vehicleStatus').value = data.vehicle.status;
    document.getElementById('vehicleRegion').innerHTML = data.regions.map(function(r) { return '<option value="' + r.regionCode + '" ' + (r.regionCode === data.vehicle.regionCode ? 'selected' : '') + '>' + r.name + '</option>'; }).join('');
    document.querySelector('input[name="vehicleActive"][value="' + data.vehicle.active + '"]').checked = true;
    document.getElementById('vehicleModal').classList.remove('hidden');
}
function closeVehicleModal() { document.getElementById('vehicleModal').classList.add('hidden'); }
async function handleSaveVehicle() {
    const id = document.getElementById('vehicleId').value;
    const data = {
        vehicleId: id ? parseInt(id) : 0,
        plateNumber: document.getElementById('plateNumber').value,
        capacity: parseInt(document.getElementById('vehicleCapacity').value),
        tempType: document.getElementById('vehicleTempType').value,
        regionCode: document.getElementById('vehicleRegion').value,
        status: document.getElementById('vehicleStatus').value,
        active: document.querySelector('input[name="vehicleActive"]:checked').value === 'true'
    };
    if (!data.plateNumber) { commonShowAlert('알림','차량번호를 입력하세요.'); return; }
    const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=' + (id ? 'updateVehicle' : 'addVehicle'), { method: 'POST', body: JSON.stringify(data) });
    const result = await res.json();
    if (result.success) { commonShowAlert('알림','저장되었습니다.'); closeVehicleModal(); fetchData(); }
    else { commonShowAlert('알림',result.message || '저장 실패'); }
}
async function handleDeleteVehicle() {
    commonShowConfirm('확인', '정말 삭제하시겠습니까?', async function() {
        const id = document.getElementById('vehicleId').value;
        const res = await fetch(contextPath + '/hq/delivery/driver-vehicle?action=deleteVehicle&vehicleId=' + id, { method: 'POST' });
        const result = await res.json();
        if (result.success) { commonShowAlert('알림','삭제되었습니다.'); closeVehicleModal(); fetchData(); }
        else { commonShowAlert('알림',result.message || '삭제 실패'); }
    });
}

// Common utility functions
function switchTab(tab) {
    currentTab = tab;
    document.getElementById('driversTab').classList.toggle('hidden', tab !== 'drivers');
    document.getElementById('vehiclesTab').classList.toggle('hidden', tab !== 'vehicles');
    document.getElementById('addDriverBtn').classList.toggle('hidden', tab !== 'drivers');
    document.getElementById('addVehicleBtn').classList.toggle('hidden', tab !== 'vehicles');
    document.getElementById('driversTabBtn').classList.toggle('text-[#00853D]', tab === 'drivers');
    document.getElementById('vehiclesTabBtn').classList.toggle('text-[#00853D]', tab === 'vehicles');
    applySearch();
}
function applySearch() {
    searchTerm = document.getElementById('searchInput').value.trim().toLowerCase();

    currentDriverPage = 1;
    currentVehiclePage = 1;

    if (currentTab === 'drivers') {
        renderDrivers();
    } else {
        renderVehicles();
    }
}
function renderPagination(areaId, totalPages, currentPage, fnName) {
    const paginationArea = document.getElementById(areaId);

    if (!paginationArea) {
        console.error('페이지네이션 영역을 찾을 수 없습니다:', areaId);
        return;
    }

    if (totalPages <= 1) {
        paginationArea.innerHTML = '';
        return;
    }

    const base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
    const active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
    const arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';

    const blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
    const blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

    let html = '';

    html += '<div class="flex flex-col items-center justify-center gap-3">';

    html += '<div class="flex items-center justify-center gap-1">';

    html += '<button type="button" class="' + arrow + '" onclick="' + fnName + '(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
    html += '<i class="fas fa-angles-left text-xs"></i>';
    html += '</button>';

    const prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
    html += '<button type="button" class="' + arrow + '" onclick="' + fnName + '(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
    html += '<i class="fas fa-chevron-left text-xs"></i>';
    html += '</button>';

    for (let i = blockStart; i <= blockEnd; i++) {
        html += '<button type="button" class="' + (i === currentPage ? active : base) + '" onclick="' + fnName + '(' + i + ')">';
        html += i;
        html += '</button>';
    }

    const nextBlockPage = Math.min(totalPages, blockEnd + 1);
    html += '<button type="button" class="' + arrow + '" onclick="' + fnName + '(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
    html += '<i class="fas fa-chevron-right text-xs"></i>';
    html += '</button>';

    html += '<button type="button" class="' + arrow + '" onclick="' + fnName + '(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
    html += '<i class="fas fa-angles-right text-xs"></i>';
    html += '</button>';

    html += '</div>';
    html += '</div>';

    paginationArea.innerHTML = html;
}
function changeDriverPage(page) {
    const filtered = allDrivers.filter(d =>
        String(d.name || '').includes(searchTerm) ||
        String(d.phone || '').includes(searchTerm)
    );

    const totalPages = Math.ceil(filtered.length / itemsPerPage);

    if (page < 1 || page > totalPages) {
        return;
    }

    currentDriverPage = page;
    renderDrivers();

    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

function changeVehiclePage(page) {
    const filtered = allVehicles.filter(v =>
        String(v.plateNumber || '').includes(searchTerm)
    );

    const totalPages = Math.ceil(filtered.length / itemsPerPage);

    if (page < 1 || page > totalPages) {
        return;
    }

    currentVehiclePage = page;
    renderVehicles();

    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

document.addEventListener('DOMContentLoaded', fetchData);
</script>
</body>
</html>
