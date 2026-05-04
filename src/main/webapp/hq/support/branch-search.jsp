<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직영점 관리 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
        .modal-hidden { display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/hq/common/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <div class="flex justify-between items-center">
                <div>
                    <h2 class="text-3xl font-bold text-gray-900">직영점 관리</h2>
                    <p class="text-gray-500 mt-2">전국 직영점을 지역별로 검색하고 상세 정보를 확인할 수 있습니다.</p>
                </div>
                <button onclick="openCreateModal()" class="px-6 py-3 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors flex items-center gap-2 font-medium whitespace-nowrap">
                    <i class="fas fa-plus w-4 h-4"></i> 직영점 등록
                </button>
            </div>

            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="space-y-4">
                    <div class="mb-4">
                        <label class="text-sm font-medium text-gray-700 mb-2 block">지역</label>
                        <div id="regionFilters" class="flex flex-wrap gap-2"></div>
                    </div>
                    <div class="flex-1 relative">
                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400"></i>
                        <input type="text" id="searchInput" placeholder="지점명, 주소, 지점장명으로 검색..." onkeyup="handleSearchKeyup(event)" class="w-full pl-10 pr-12 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                        <button onclick="applyFilters()" class="absolute right-2 top-1/2 transform -translate-y-1/2 p-2 text-gray-400 hover:text-[#00853D] transition-colors">
                            <i class="fas fa-search w-4 h-4"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div id="branchGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4"></div>
            <div id="emptyState" class="bg-white rounded-lg border border-gray-200 p-12 text-center hidden">
                <i class="fas fa-search w-16 h-16 text-gray-300 mx-auto mb-4"></i>
                <p class="text-gray-500 text-lg mb-2">검색 결과가 없습니다</p>
            </div>
            <div id="paginationArea"></div>
        </div>
    </main>
</div>

<div id="detailModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4 modal-hidden">
    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <h3 id="detailModalTitle" class="text-xl font-bold text-gray-900">직영점 상세 정보</h3>
            <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600 text-2xl"><i class="fas fa-times"></i></button>
        </div>
        <div id="detailModalContent" class="p-6 space-y-6"></div>
        <div class="sticky bottom-0 bg-white border-t border-gray-200 px-6 py-4 flex gap-3 justify-end" id="detailModalFooter">
        </div>
    </div>
</div>

<div id="formModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4 modal-hidden">
    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <h3 id="formModalTitle" class="text-xl font-bold text-gray-900">직영점 등록</h3>
            <button onclick="closeFormModal()" class="text-gray-400 hover:text-gray-600 text-2xl"><i class="fas fa-times"></i></button>
        </div>
        <div class="p-6 space-y-4">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">지점명</label>
                    <input type="text" id="formBranchName" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">지역</label>
                    <select id="formBranchRegion" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none"></select>
                </div>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">주소</label>
                <input type="text" id="formBranchAddress" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none">
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">지점 연락처</label>
                    <input type="text" id="formBranchPhone" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
                    <select id="formBranchStatus" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="INACTIVE">INACTIVE</option>
                        <option value="CLOSED">CLOSED</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="sticky bottom-0 bg-white border-t border-gray-200 px-6 py-4 flex justify-end gap-3">
            <button onclick="closeFormModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">취소</button>
            <button onclick="saveBranch()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F]">저장</button>
        </div>
    </div>
</div>

<script>
    const regions = ['전체', '서울권', '경기남부권', '인천권', '강원권', '충남권', '대전권', '충북권', '세종권', '부산권', '울산권', '대구권', '경북권', '경남권', '전남권', '광주권', '전북권', '제주권'];
    const regionCodes = {'서울권': '02', '경기남부권': '031', '인천권': '032', '강원권': '033', '충남권': '041', '대전권': '042', '충북권': '043', '세종권': '044', '부산권': '051', '울산권': '052', '대구권': '053', '경북권': '054', '경남권': '055', '전남권': '061', '광주권': '062', '전북권': '063', '제주권': '064'};
    let allBranches = [];
    let currentBranches = [];
    let selectedRegion = '전체';
    let currentPage = 1;
    const itemsPerPage = 9;

    let selectedBranchForDetail = null;
    let editingBranchId = null; // 폼 모달이 등록 모드인지 수정 모드인지 판단

    const ctx = "<%= request.getContextPath() %>";

    async function init() {
        renderRegionFilters();
        populateRegionSelect();
        await applyFilters();
    }

    function renderRegionFilters() {
        const html = regions.map(region => {
            const isActive = selectedRegion === region;
            const btnClass = isActive ? 'bg-[#00853D] text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200';
            return `<button onclick="setRegion('\${region}')" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors \${btnClass}">\${region}</button>`;
        }).join('');
        document.getElementById('regionFilters').innerHTML = html;
    }

    async function applyFilters() {
        const searchTerm = document.getElementById('searchInput').value;
        const url = ctx + '/hq/support/branch-search-data?region=' + encodeURIComponent(selectedRegion) + '&keyword=' + encodeURIComponent(searchTerm);
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error("서버 에러 발생!");
            allBranches = await response.json();
            currentBranches = allBranches;
            currentPage = 1;
            renderBranches();
            renderPagination();
        } catch (error) {
            console.error('에러:', error);
        }
    }

    function handleSearchKeyup(event) { if (event.key === 'Enter') applyFilters(); }

    function renderBranches() {
        const branchGrid = document.getElementById('branchGrid');
        const emptyState = document.getElementById('emptyState');

        if (currentBranches.length === 0) {
            branchGrid.innerHTML = '';
            emptyState.classList.remove('hidden');
            return;
        }
        emptyState.classList.add('hidden');

        const paginated = currentBranches.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

        branchGrid.innerHTML = paginated.map(branch => {
            const statusClass = branch.status === 'ACTIVE' ? 'bg-green-100 text-green-700' : (branch.status === 'INACTIVE' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700');
            return `<div class="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-shadow cursor-pointer" onclick="viewBranchDetail('\${branch.id}')">
                          <div class="flex items-start justify-between mb-4">
                            <div>
                              <h3 class="font-bold text-lg text-gray-900">\${branch.name}</h3>
                              <p class="text-sm text-gray-500">\${branch.id}</p>
                            </div>
                            <span class="px-3 py-1 rounded-full text-xs font-medium \${statusClass}">\${branch.status}</span>
                          </div>
                          <div class="space-y-2 mb-4">
                            <div class="flex items-start gap-2 text-sm"><i class="fas fa-map-marker-alt w-4 h-4 text-gray-400 mt-0.5"></i><span class="text-gray-600">\${branch.address || '-'}</span></div>
                            <div class="flex items-center gap-2 text-sm"><i class="fas fa-phone w-4 h-4 text-gray-400"></i><span class="text-gray-600">\${branch.phone || '-'}</span></div>
                            <div class="flex items-center gap-2 text-sm"><i class="fas fa-user-tie w-4 h-4 text-gray-400"></i><span class="text-gray-600">지점장: \${branch.managerName || '미지정'}</span></div>
                          </div>
                        </div>`;
        }).join('');
    }

    function renderPagination() {
        const paginationArea = document.getElementById('paginationArea');
        const totalPages = Math.ceil(currentBranches.length / itemsPerPage);
        if (totalPages <= 1) { paginationArea.innerHTML = ''; return; }

        let html = '<div class="flex justify-center gap-2">';
        html += `<button onclick="setPage(Math.max(1, \${currentPage} - 1))" class="p-2 border rounded-lg hover:bg-gray-100"><i class="fas fa-chevron-left text-xs"></i></button>`;
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                html += `<button onclick="setPage(\${i})" class="px-3 py-1 border rounded-lg \${currentPage === i ? 'bg-[#00853D] text-white' : 'hover:bg-gray-100'}">\${i}</button>`;
            } else if ((i === 2 && currentPage > 4) || (i === totalPages - 1 && currentPage < totalPages - 3)) {
                html += `<span class="px-2">...</span>`;
            }
        }
        html += `<button onclick="setPage(Math.min(\${totalPages}, \${currentPage} + 1))" class="p-2 border rounded-lg hover:bg-gray-100"><i class="fas fa-chevron-right text-xs"></i></button></div>`;
        paginationArea.innerHTML = html;
    }

    function setRegion(region) { selectedRegion = region; applyFilters(); renderRegionFilters(); }
    function setPage(page) { currentPage = page; renderBranches(); renderPagination(); }

    // 상세 모달 열기 (수정/삭제 버튼 추가)
    function viewBranchDetail(branchId) {
        selectedBranchForDetail = allBranches.find(b => String(b.id) === String(branchId));
        if (!selectedBranchForDetail) return alert('지점 정보를 찾을 수 없습니다.');

        const b = selectedBranchForDetail;
        const statusClass = b.status === 'ACTIVE' ? 'bg-green-100 text-green-700' : (b.status === 'INACTIVE' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700');

        document.getElementById('detailModalContent').innerHTML =
            `<div class="space-y-4">
                   <div class="grid grid-cols-2 gap-4">
                       <div><p class="text-sm text-gray-500 mb-1">지점 코드</p><p class="font-medium">\${b.id}</p></div>
                       <div><p class="text-sm text-gray-500 mb-1">지역</p><p class="font-medium">\${b.region || '-'}</p></div>
                   </div>
                   <div><p class="text-sm text-gray-500 mb-1">주소</p><p class="font-medium">\${b.address || '-'}</p></div>
                   <div class="grid grid-cols-2 gap-4">
                       <div><p class="text-sm text-gray-500 mb-1">전화번호</p><p class="font-medium">\${b.phone || '-'}</p></div>
                       <div><p class="text-sm text-gray-500 mb-1">상태</p><span class="px-3 py-1 rounded-full text-xs font-medium \${statusClass}">\${b.status}</span></div>
                   </div>
                   <div class="border-t pt-4 grid grid-cols-2 gap-4">
                       <div><p class="text-sm text-gray-500 mb-1">지점장</p><p class="font-medium">\${b.managerName || '미지정'}</p></div>
                       <div><p class="text-sm text-gray-500 mb-1">직원 수</p><p class="font-medium">\${b.employeeCount || 0}명</p></div>
                   </div>
               </div>`;
        document.getElementById('detailModalTitle').innerText = b.name + ' 상세 정보';

        // 동적 푸터 구성 (닫기, 수정, 삭제)
        document.getElementById('detailModalFooter').innerHTML = `
                <button onclick="closeDetailModal()" class="px-4 py-2 border rounded-lg text-gray-700 hover:bg-gray-50">닫기</button>
                <button onclick="openEditModal()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"><i class="fas fa-edit mr-1"></i>수정</button>
                <button onclick="deleteBranch('\${b.id}')" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"><i class="fas fa-trash mr-1"></i>삭제</button>
            `;

        document.getElementById('detailModal').classList.remove('modal-hidden');
    }

    // 공통 폼 초기화
    function clearForm() {
        document.getElementById('formBranchName').value = '';
        document.getElementById('formBranchRegion').value = '서울권';
        document.getElementById('formBranchAddress').value = '';
        document.getElementById('formBranchPhone').value = '';
        document.getElementById('formBranchStatus').value = 'ACTIVE';
    }

    // 신규 등록 모달 열기
    function openCreateModal() {
        editingBranchId = null;
        clearForm();
        document.getElementById('formBranchRegion').disabled = false; // 신규는 지역 선택 가능
        document.getElementById('formModalTitle').innerText = '신규 직영점 등록';
        document.getElementById('formModal').classList.remove('modal-hidden');
    }

    // 수정 모달 열기
    function openEditModal() {
        if(!selectedBranchForDetail) return;
        editingBranchId = selectedBranchForDetail.id;

        document.getElementById('formBranchName').value = selectedBranchForDetail.name || '';
        document.getElementById('formBranchRegion').value = selectedBranchForDetail.region || '서울권';
        document.getElementById('formBranchRegion').disabled = true; // 코드가 꼬이므로 지역 변경 금지
        document.getElementById('formBranchAddress').value = selectedBranchForDetail.address || '';
        document.getElementById('formBranchPhone').value = selectedBranchForDetail.phone || '';
        document.getElementById('formBranchStatus').value = selectedBranchForDetail.status || 'ACTIVE';

        document.getElementById('formModalTitle').innerText = '직영점 정보 수정';
        closeDetailModal();
        document.getElementById('formModal').classList.remove('modal-hidden');
    }

    // 모달 닫기
    function closeFormModal() { document.getElementById('formModal').classList.add('modal-hidden'); }
    function closeDetailModal() { document.getElementById('detailModal').classList.add('modal-hidden'); }

    // 저장 (신규 등록 or 수정 분기)
    async function saveBranch() {
        const branchData = {
            id: editingBranchId, // 수정일 경우 존재, 신규면 null
            name: document.getElementById('formBranchName').value,
            regionCode: regionCodes[document.getElementById('formBranchRegion').value],
            address: document.getElementById('formBranchAddress').value,
            phone: document.getElementById('formBranchPhone').value,
            status: document.getElementById('formBranchStatus').value
        };

        const action = editingBranchId ? 'update' : 'create';

        try {
            const response = await fetch(ctx + `/hq/support/branch-search-data?action=\${action}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(branchData)
            });

            if (response.ok) {
                alert(editingBranchId ? '수정되었습니다.' : '등록되었습니다.');
                closeFormModal();
                applyFilters();
            } else {
                alert('저장에 실패했습니다.');
            }
        } catch (error) {
            alert('통신 중 오류가 발생했습니다.');
        }
    }

    // 삭제
    async function deleteBranch(branchId) {
        if(!confirm('정말로 이 지점을 삭제하시겠습니까? 삭제 시 관련된 데이터가 손실될 수 있습니다.')) return;

        try {
            const response = await fetch(ctx + `/hq/support/branch-search-data?action=delete&id=\${branchId}`, { method: 'POST' });
            if(response.ok) {
                alert('지점이 삭제되었습니다.');
                closeDetailModal();
                applyFilters();
            } else {
                alert('삭제에 실패했습니다.');
            }
        } catch (error) {
            alert('통신 중 오류가 발생했습니다.');
        }
    }

    // 셀렉트 박스 채우기
    function populateRegionSelect() {
        const select = document.getElementById('formBranchRegion');
        regions.forEach(region => {
            if (region !== '전체') {
                const option = document.createElement('option');
                option.value = region;
                option.textContent = region;
                select.appendChild(option);
            }
        });
    }

    // 기타 이벤트
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('detailModal').addEventListener('click', e => { if (e.target.id === 'detailModal') closeDetailModal(); });
        document.getElementById('formModal').addEventListener('click', e => { if (e.target.id === 'formModal') closeFormModal(); });
        document.getElementById('sidebarBackdrop').addEventListener('click', toggleSidebar);
    });

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') { closeDetailModal(); closeFormModal(); }
    });

    function toggleSidebar() { document.getElementById('sidebar').classList.toggle('-translate-x-full'); document.getElementById('sidebarBackdrop').classList.toggle('hidden'); }

    init();
</script>
</body>
</html>