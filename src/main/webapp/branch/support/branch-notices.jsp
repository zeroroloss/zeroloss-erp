<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>본사 공지사항 - ZERO LOSS 지점 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
        .modal-hidden { display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; }
        .notice-item { transition: all 0.3s ease; }
        .notice-item:hover { box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/branch/common/layout/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">본사 공지사항</h1>
                    <p class="text-gray-500 mt-2">본사에서 전달하는 공지사항을 확인할 수 있습니다.</p>
                </div>
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

            <div id="pagination" class="flex justify-center items-center gap-1 p-4"></div>
        </div>
    </main>
</div>

<div id="viewModal" class="fixed inset-0 bg-black bg-opacity-50 z-40 modal-hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
            <div class="flex-1">
                <div class="flex items-center gap-2 mb-3">
                    <span id="viewNoticePin" class="hidden text-purple-600"><i class="fas fa-thumbtack"></i></span>
                    <span id="viewNoticeType" class="inline-block px-3 py-1 rounded text-sm font-medium"></span>
                </div>
                <h2 id="viewNoticeTitle" class="text-2xl font-bold text-gray-900"></h2>
                <div class="flex items-center gap-4 text-sm text-gray-500 mt-4">
                    <span><i class="fas fa-user w-4 h-4 inline mr-1"></i><span id="viewNoticeAuthor"></span></span>
                    <span><i class="fas fa-calendar w-4 h-4 inline mr-1"></i><span id="viewNoticeDate"></span></span>
                    <span><i class="fas fa-eye w-4 h-4 inline mr-1"></i>조회 <span id="viewNoticeViews"></span>회</span>
                </div>
            </div>
            <button onclick="closeViewModal()" class="text-gray-400 hover:text-gray-600"><i class="fas fa-times w-6 h-6"></i></button>
        </div>
        <div class="p-6">
            <p id="viewNoticeContent" class="whitespace-pre-wrap text-gray-700"></p>
        </div>
        <div id="viewModalFooter" class="border-t border-gray-200 p-6 flex justify-end gap-3">
             <button onclick="closeViewModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">닫기</button>
        </div>
    </div>
</div>

<script>
    const ctx = "<%= request.getContextPath() %>";
    let allNotices = [];
    let currentPage = 1;
    const itemsPerPage = 8;
    let currentTypeFilter = 'all';

    document.addEventListener('DOMContentLoaded', function() { initializeNotices(); });

    async function initializeNotices() {
        try {
            // 🟢 직영점용 데이터 URL로 변경
            const response = await fetch(ctx + '/branch/support/branch-notices-data');
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
            noticesList.innerHTML = '<div class="bg-white rounded-lg border border-gray-200 p-12 text-center"><p class="text-gray-500">표시할 공지사항이 없습니다.</p></div>';
        } else {
            noticesList.innerHTML = currentNotices.map(notice => {
                const pinHtml = notice.isPinned ? '<i class="fas fa-thumbtack text-purple-600 mr-2"></i>' : '';
                const typeClass = getTypeColor(notice.type);
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

        renderPagination(totalPages);
    }
     
    // 페이징
    function renderPagination(totalPages) {
        const el = document.getElementById('pagination');

        totalPages = parseInt(totalPages || 0);

        if (totalPages <= 1) {
            el.innerHTML = '';
            return;
        }

        const PAGE_SIZE = 5;
        const blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
        const blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

        const prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
        const nextBlockPage = Math.min(totalPages, blockEnd + 1);

        const base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
        const active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
        const arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';

        let html = '';

        // 맨 첫 페이지
        html += '<button type="button" class="' + arrow + '" onclick="changePage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
        html += '<i class="fas fa-angles-left text-xs"></i>';
        html += '</button>';

        // 이전 블록
        html += '<button type="button" class="' + arrow + '" onclick="changePage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
        html += '<i class="fas fa-chevron-left text-xs"></i>';
        html += '</button>';

        // 페이지 번호
        for (let i = blockStart; i <= blockEnd; i++) {
            html += '<button type="button" class="' + (i === currentPage ? active : base) + '" onclick="changePage(' + i + ')">';
            html += i;
            html += '</button>';
        }

        // 다음 블록
        html += '<button type="button" class="' + arrow + '" onclick="changePage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
        html += '<i class="fas fa-chevron-right text-xs"></i>';
        html += '</button>';

        // 맨 마지막 페이지
        html += '<button type="button" class="' + arrow + '" onclick="changePage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
        html += '<i class="fas fa-angles-right text-xs"></i>';
        html += '</button>';

        el.innerHTML = html;
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

    function changePage(page) {
        const totalPages = Math.max(1, Math.ceil(filterAndSortNotices().length / itemsPerPage));

        page = parseInt(page || 1);

        if (page < 1) {
            page = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        currentPage = page;
        renderNotices();
        window.scrollTo(0, 0);
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

        // 🟢 직영점용 데이터 URL로 변경
        await fetch(ctx + '/branch/support/branch-notices-data?action=view&id=' + noticeId, { method: 'POST' });
        notice.viewCount++;
        document.getElementById('viewNoticeViews').innerText = notice.viewCount;
        renderNotices();

        document.getElementById('viewModal').classList.remove('modal-hidden');
    }

    function closeViewModal() { document.getElementById('viewModal').classList.add('modal-hidden'); }

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