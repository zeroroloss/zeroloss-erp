<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
        .modal-hidden { display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; }
        .notice-item { transition: all 0.3s ease; }
        .notice-item:hover { box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/hq/common/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <div class="flex items-center justify-between">
                <div>
                    <h2 class="text-3xl font-bold text-gray-900">공지사항</h2>
                    <p class="text-gray-500 mt-1">전체 지점에 공지사항을 작성하고 관리할 수 있습니다.</p>
                </div>
                <button onclick="openCreateModal()"
				        class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2.5 rounded-lg hover:bg-[#006B2F] transition-colors">
				    <i class="fas fa-pen-to-square w-5 h-5"></i>
				    <span>공지사항 작성</span>
				</button>
            </div>

            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="flex flex-col lg:flex-row gap-4">
                    <div class="flex-1 relative">
                        <input type="text" id="searchInput" placeholder="제목 또는 내용으로 검색..." class="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]" onkeyup="filterNotices()">
                        <button onclick="filterNotices()" class="absolute right-2 top-1/2 transform -translate-y-1/2 p-2 text-gray-400 hover:text-[#00853D]">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <div class="flex gap-2 flex-wrap lg:flex-nowrap">
                        <button onclick="setTypeFilter('all')" class="px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium type-filter-btn active" data-type="all">전체</button>
                        <button onclick="setTypeFilter('긴급 공지')" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn" data-type="긴급 공지">긴급 공지</button>
                        <button onclick="setTypeFilter('일반 공지')" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn" data-type="일반 공지">일반 공지</button>
                        <button onclick="setTypeFilter('위생 가이드')" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn" data-type="위생 가이드">위생 가이드</button>
                        <button onclick="setTypeFilter('운영 지침')" class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn" data-type="운영 지침">운영 지침</button>
                    </div>
                </div>
            </div>

            <div id="noticesList" class="space-y-4"></div>

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

<div id="viewModal" class="fixed inset-0 bg-black bg-opacity-50 z-40 modal-hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div class="border-b border-gray-200 px-6 py-4 sticky top-0 bg-white">
		    <div class="flex items-start justify-between gap-4">
		        <div class="flex-1 min-w-0">
		            <div class="flex items-center gap-2 mb-3">
		                <span id="viewNoticePin" class="hidden text-purple-600">
		                    <i class="fas fa-thumbtack"></i>
		                </span>
		                <span id="viewNoticeType" class="inline-block px-3 py-1 rounded text-sm font-medium"></span>
		            </div>
		
		            <h2 id="viewNoticeTitle" class="text-2xl font-bold text-gray-900 leading-snug"></h2>
		
		            <div class="flex items-center gap-4 text-sm text-gray-500 mt-4 flex-wrap">
		                <span>
		                    <i class="fas fa-user w-4 h-4 inline mr-1"></i>
		                    <span id="viewNoticeAuthor"></span>
		                </span>
		                <span>
		                    <i class="fas fa-calendar w-4 h-4 inline mr-1"></i>
		                    <span id="viewNoticeDate"></span>
		                </span>
		                <span>
		                    <i class="fas fa-eye w-4 h-4 inline mr-1"></i>
		                    조회 <span id="viewNoticeViews"></span>회
		                </span>
		            </div>
		        </div>
		
		        <button type="button" onclick="closeViewModal()" class="shrink-0 text-gray-400 hover:text-gray-600">
		            <i class="fas fa-times w-5 h-5"></i>
		        </button>
		    </div>
		</div>
        <div class="p-6 py-10">
            <p id="viewNoticeContent" class="whitespace-pre-wrap text-gray-700"></p>
        </div>
        <div id="viewModalFooter" class="border-t border-gray-200 px-6 py-3 flex justify-between items-center sticky bottom-0 bg-white"></div>
    </div>
</div>

<div id="createModal" class="fixed inset-0 bg-black bg-opacity-50 z-40 modal-hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white">
		    <h2 id="modalTitle" class="text-lg font-bold text-gray-900">공지사항 작성</h2>
		    <button type="button" onclick="closeCreateModal()" class="text-gray-400 hover:text-gray-600">
		        <i class="fas fa-times w-5 h-5"></i>
		    </button>
		</div>
        <div class="p-6 space-y-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">제목</label>
                <input type="text" id="noticeTitle" placeholder="공지사항 제목을 입력하세요" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">유형</label>
                <select id="noticeType" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                    <option value="일반 공지">일반 공지</option>
                    <option value="긴급 공지">긴급 공지</option>
                    <option value="위생 가이드">위생 가이드</option>
                    <option value="운영 지침">운영 지침</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">내용</label>
                <textarea id="noticeContent" placeholder="공지사항 내용을 입력하세요" rows="10" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D] font-sans"></textarea>
            </div>
            <div class="flex items-center gap-2">
                <input type="checkbox" id="isPinned" class="w-4 h-4 border-gray-300 rounded">
                <label for="isPinned" class="text-sm font-medium text-gray-700">상단 고정</label>
            </div>
        </div>
        <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
		    <button type="button"
		            onclick="closeCreateModal()"
		            class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
		        취소
		    </button>
		
		    <button type="button"
		            onclick="saveNotice()"
		            class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
		        저장
		    </button>
		</div>
    </div>
</div>

<script>
    const ctx = "<%= request.getContextPath() %>";
    const CURRENT_USER_ID = 1; // 가상의 로그인 유저 (권한 체크용)
    let editingNoticeId = null;

    let allNotices = [];
    let currentPage = 1;
    const itemsPerPage = 5;
    const PAGE_SIZE = 5;
    let currentTypeFilter = 'all';

    document.addEventListener('DOMContentLoaded', function() { initializeNotices(); });

    async function initializeNotices() {
        try {
            const response = await fetch(ctx + '/hq/support/headquarters-notices-data');
            allNotices = await response.json();
            renderNotices();
        } catch (error) {
            console.error('Error fetching notices:', error);
        }
    }

    function getTypeColor(type) {
        if (type === '긴급 공지') return 'bg-red-100 text-red-800';
        if (type === '위생 가이드') return 'bg-blue-100 text-blue-800';
        if (type === '운영 지침') return 'bg-purple-100 text-purple-800';
        return 'bg-gray-100 text-gray-800';
    }

    function filterAndSortNotices() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const filtered = allNotices.filter(notice => {
            const matchesSearch = notice.title.toLowerCase().includes(searchTerm) || notice.content.toLowerCase().includes(searchTerm);
            const matchesType = currentTypeFilter === 'all' || notice.type === currentTypeFilter;
            return matchesSearch && matchesType;
        });

        filtered.sort((a, b) => {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return new Date(b.createdAt) - new Date(a.createdAt);
        });
        return filtered;
    }

    function renderNotices() {
        const filtered = filterAndSortNotices();
        const totalPages = Math.ceil(filtered.length / itemsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;

        const start = (currentPage - 1) * itemsPerPage;
        const currentNotices = filtered.slice(start, start + itemsPerPage);
        const noticesList = document.getElementById('noticesList');

        if (currentNotices.length === 0) {
            noticesList.innerHTML = '<div class="bg-white rounded-lg border border-gray-200 p-12 text-center"><p class="text-gray-500">검색 결과가 없습니다.</p></div>';
            renderPagination(0, 0);
            return;
        } else {
            noticesList.innerHTML = currentNotices.map(notice => {
                const pinHtml = notice.isPinned ? '<i class="fas fa-thumbtack text-purple-600 mr-2"></i>' : '';
                const typeClass = getTypeColor(notice.type);

                // 🟢 수정된 날짜(lastDate)가 있으면 그걸 쓰고, 없으면 생성일(createdAt)을 사용!
                const displayDate = notice.lastDate ? notice.lastDate : notice.createdAt;

                return `<div class="bg-white rounded-lg border border-gray-200 p-6 notice-item cursor-pointer hover:shadow-lg transition-shadow" onclick="viewNotice(\${notice.noticeId})">
                                <div class="flex items-start justify-between gap-4">
                                    <div class="flex-1 space-y-2">
                                        <div class="flex items-center gap-2 flex-wrap">
                                            \${pinHtml}
                                            <span class="inline-block px-3 py-1 rounded text-sm font-medium \${typeClass}">\${notice.type}</span>
                                            <h3 class="font-bold text-lg text-gray-900">\${notice.title}</h3>
                                        </div>
                                        <p class="text-gray-600 line-clamp-2">\${notice.content}</p>
                                        <div class="flex items-center gap-4 text-sm text-gray-500">
                                            <span><i class="fas fa-user w-4 h-4 inline mr-1"></i>\${notice.authorName}</span>
                                            <span><i class="fas fa-calendar w-4 h-4 inline mr-1"></i>\${new Date(displayDate).toLocaleString()}</span>
                                            <span><i class="fas fa-eye w-4 h-4 inline mr-1"></i>조회 \${notice.viewCount}회</span>
                                        </div>
                                    </div>
                                </div>
                            </div>`;
            }).join('');
        }

        renderPagination(totalPages, filtered.length);
    }
    
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
        const totalPages = Math.ceil(filterAndSortNotices().length / itemsPerPage);

        if (page < 1 || page > totalPages) {
            return;
        }

        currentPage = page;
        renderNotices();

        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }

    function filterNotices() { currentPage = 1; renderNotices(); }
    function setTypeFilter(type) {
        currentTypeFilter = type; currentPage = 1;
        document.querySelectorAll('.type-filter-btn').forEach(btn => {
            btn.classList.toggle('bg-[#00853D]', btn.dataset.type === type);
            btn.classList.toggle('text-white', btn.dataset.type === type);
            btn.classList.toggle('border-gray-300', btn.dataset.type !== type);
            btn.classList.toggle('text-gray-700', btn.dataset.type !== type);
        });
        renderNotices();
    }

    async function viewNotice(noticeId) {
        const notice = allNotices.find(n => n.noticeId === noticeId);
        if (!notice) return;

        const displayDate = notice.lastDate ? notice.lastDate : notice.createdAt;

        document.getElementById('viewNoticeTitle').innerText = notice.title;
        document.getElementById('viewNoticeContent').innerText = notice.content;
        document.getElementById('viewNoticeAuthor').innerText = notice.authorName;
        document.getElementById('viewNoticeDate').innerText = new Date(displayDate).toLocaleString();

        const typeSpan = document.getElementById('viewNoticeType');
        typeSpan.className = "inline-block px-3 py-1 rounded text-sm font-medium " + getTypeColor(notice.type);
        typeSpan.innerText = notice.type;
        document.getElementById('viewNoticePin').classList.toggle('hidden', !notice.isPinned);

        // 조회수 서버 통신 증가
        await fetch(ctx + '/hq/support/headquarters-notices-data?action=view&id=' + noticeId, { method: 'POST' });
        notice.viewCount++; // 로컬 변수 즉시 증가
        document.getElementById('viewNoticeViews').innerText = notice.viewCount;
        renderNotices(); // 배경 리스트도 업데이트

        // 본인(author_id) 여부에 따른 동적 버튼 생성
        const footer = document.getElementById('viewModalFooter');
        if (notice.authorId === CURRENT_USER_ID) {
        	footer.innerHTML = `
        	    <button type="button"
        	            onclick="deleteNotice(\${noticeId})"
        	            class="inline-flex items-center gap-1 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 text-sm">
        	        <i class="fas fa-trash-alt text-xs"></i>
        	        삭제
        	    </button>

        	    <div class="flex items-center gap-3">
        	        <button type="button"
        	                onclick="closeViewModal()"
        	                class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
        	            닫기
        	        </button>

        	        <button type="button"
        	                onclick="openEditModal(\${noticeId})"
        	                class="inline-flex items-center gap-1 px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
        	            수정
        	        </button>
        	    </div>
        	`;
        } else {
        	footer.innerHTML = `<div></div><button type="button" onclick="closeViewModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">닫기</button>`;
        }

        document.getElementById('viewModal').classList.remove('modal-hidden');
    }

    function closeViewModal() { document.getElementById('viewModal').classList.add('modal-hidden'); }

    function openCreateModal() {
        editingNoticeId = null;
        document.getElementById('modalTitle').innerText = '공지사항 작성';
        document.getElementById('noticeTitle').value = '';
        document.getElementById('noticeType').value = '일반 공지';
        document.getElementById('noticeContent').value = '';
        document.getElementById('isPinned').checked = false;
        document.getElementById('createModal').classList.remove('modal-hidden');
    }

    function openEditModal(noticeId) {
        const notice = allNotices.find(n => n.noticeId === noticeId);
        if (!notice) return;

        editingNoticeId = noticeId;
        document.getElementById('modalTitle').innerText = '공지사항 수정';
        document.getElementById('noticeTitle').value = notice.title;
        document.getElementById('noticeType').value = notice.type;
        document.getElementById('noticeContent').value = notice.content;
        document.getElementById('isPinned').checked = notice.isPinned;

        closeViewModal();
        document.getElementById('createModal').classList.remove('modal-hidden');
    }

    function closeCreateModal() { document.getElementById('createModal').classList.add('modal-hidden'); }

    async function saveNotice() {
        const noticeData = {
            noticeId: editingNoticeId,
            title: document.getElementById('noticeTitle').value.trim(),
            type: document.getElementById('noticeType').value,
            content: document.getElementById('noticeContent').value.trim(),
            isPinned: document.getElementById('isPinned').checked
        };

        if (!noticeData.title || !noticeData.content) return commonShowAlert('알림', '제목과 내용을 입력해주세요.');

        const action = editingNoticeId ? 'update' : 'create';

        try {
            const response = await fetch(ctx + '/hq/support/headquarters-notices-data?action=' + action, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(noticeData)
            });
            if (response.ok) {
                commonShowAlert('알림', editingNoticeId ? '공지사항이 수정되었습니다.' : '공지사항이 저장되었습니다.');
                closeCreateModal();
                initializeNotices();
            } else {
                commonShowAlert('알림', '저장에 실패했습니다.');
            }
        } catch (error) { commonShowAlert('알림', '오류가 발생했습니다.'); }
    }

    async function deleteNotice(noticeId) {
        commonShowConfirm('확인', '정말 이 공지사항을 삭제하시겠습니까?', async function() {
            try {
                const response = await fetch(ctx + '/hq/support/headquarters-notices-data?action=delete&id=' + noticeId, { method: 'POST' });
                if(response.ok) {
                    commonShowAlert('알림', '삭제되었습니다.');
                    closeViewModal();
                    initializeNotices();
                } else {
                    commonShowAlert('알림', '삭제에 실패했습니다.');
                }
            } catch (error) { commonShowAlert('알림', '오류가 발생했습니다.'); }
        })
    }

    function toggleMenu(button) {
        const submenu = button.nextElementSibling;
        submenu.classList.toggle('hidden');
        const icon = button.querySelector('i.fa-chevron-right, i.fa-chevron-down');
        if (icon) { icon.classList.toggle('fa-chevron-right'); icon.classList.toggle('fa-chevron-down'); }
    }

    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const backdrop = document.getElementById('sidebarBackdrop');
        sidebar.classList.toggle('-translate-x-full');
        backdrop.classList.toggle('hidden');
        backdrop.addEventListener('click', () => {
            sidebar.classList.add('-translate-x-full');
            backdrop.classList.add('hidden');
        });
    }
</script>
</body>
</html>