<%@ page import="java.util.List" %>
<%@ page import="dto.BranchDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	@SuppressWarnings("unchecked")
    List<BranchDTO> branches = (List<BranchDTO>) request.getAttribute("branches");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의사항 - ZERO LOSS 지점 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
        .modal-hidden { display: none !important; }
        .item { transition: all 0.3s ease; }
        .item:hover { box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); }
        .chip { height: 24px; padding: 0 10px; border-radius: 999px; font-size: 12px; font-weight: 700; display: inline-flex; align-items: center; }
        .c-red { background: #fee2e2; color: #dc2626; }
        .c-purple { background: #f3e8ff; color: #7c3aed; }
        .c-blue { background: #dbeafe; color: #2563eb; }
        .c-orange { background: #ffedd5; color: #c2410c; }
        .c-green { background: #dcfce7; color: #15803d; }
        .c-yellow { background:#fef3c7; color:#b45309; }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/branch/common/layout/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">문의사항</h1>
                    <p class="text-gray-500 mt-2">본사에 문의사항이나 건의사항을 전달할 수 있습니다.</p>
                </div>
                <button onclick="openCreateModal()" class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2 rounded-lg hover:bg-[#006B2F] transition-colors">
                    <i class="fas fa-plus w-4 h-4"></i>
                    <span>문의하기</span>
                </button>
            </div>

            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="flex flex-col lg:flex-row gap-4">
                    <div class="flex-1 relative">
                        <input type="text" id="searchInput" placeholder="제목 또는 내용으로 검색..." class="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                    </div>
                    <div class="flex gap-2">
                        <select id="branchFilter" class="w-full lg:w-40 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                            <option value="all">전체 지점</option>
                            <% if (branches != null) {
                                for (BranchDTO branch : branches) { %>
                                    <option value="<%= branch.getBranchCode() %>"><%= branch.getName() %></option>
                            <%  }
                               } %>
                        </select>
                        <select id="categoryFilter" class="w-full lg:w-40 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                            <option value="all">전체 유형</option>
                            <option value="설비 문의">설비 문의</option>
                            <option value="재고 문의">재고 문의</option>
                            <option value="운영 건의">운영 건의</option>
                            <option value="인사 문의">인사 문의</option>
                            <option value="기타">기타</option>
                        </select>
                        <select id="statusFilter" class="w-full lg:w-40 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                            <option value="all">전체 상태</option>
                            <option value="대기 중">대기 중</option>
                            <option value="처리 중">처리 중</option>
                            <option value="답변 완료">답변 완료</option>
                        </select>
                    </div>
                </div>
            </div>

            <div id="inquiryList" class="space-y-4"></div>
            <div id="pagination" class="flex justify-center items-center gap-1 p-4"></div>
        </div>
    </main>
</div>

<div id="createEditModal" class="fixed inset-0 bg-black bg-opacity-50 z-40 modal-hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
            <h2 id="modalTitle" class="text-xl font-bold text-gray-900"></h2>
            <button onclick="closeCreateEditModal()" class="text-gray-400 hover:text-gray-600"><i class="fas fa-times w-6 h-6"></i></button>
        </div>
        <div class="p-6 space-y-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">제목</label>
                <input type="text" id="inquiryTitle" class="w-full px-4 py-2 border border-gray-300 rounded-lg outline-none">
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">유형</label>
                    <select id="inquiryCategory" class="w-full px-4 py-2 border border-gray-300 rounded-lg outline-none">
                        <option>설비 문의</option><option>재고 문의</option><option>운영 건의</option><option>인사 문의</option><option>기타</option>
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">긴급도</label>
                    <select id="inquiryUrgency" class="w-full px-4 py-2 border border-gray-300 rounded-lg outline-none">
                        <option>일반</option><option>긴급</option>
                    </select>
                </div>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">내용</label>
                <textarea id="inquiryContent" rows="8" class="w-full px-4 py-2 border border-gray-300 rounded-lg outline-none"></textarea>
            </div>
        </div>
        <div class="border-t border-gray-200 p-6 flex justify-end gap-3">
            <button onclick="closeCreateEditModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">취소</button>
            <button onclick="saveInquiry()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F]">저장</button>
        </div>
    </div>
</div>

<div id="viewModal" class="fixed inset-0 bg-black bg-opacity-50 z-40 modal-hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6">
            <div class="flex items-start justify-between">
                <div class="flex-1">
                    <div id="viewChips" class="flex items-center gap-2 mb-3"></div>
                    <h2 id="viewTitle" class="text-2xl font-bold text-gray-900"></h2>
                    <p id="viewDate" class="text-sm text-gray-500 mt-2"></p>
                </div>
                <button onclick="closeViewModal()" class="text-gray-400 hover:text-gray-600"><i class="fas fa-times w-6 h-6"></i></button>
            </div>
        </div>
        <div class="p-6 space-y-6">
            <div>
                <h3 class="font-bold text-gray-800 mb-2">문의 내용</h3>
                <p id="viewContent" class="whitespace-pre-wrap text-gray-700 bg-gray-50 p-4 rounded-lg border border-gray-200"></p>
            </div>
            <div id="repliesContainer" class="space-y-4"></div>
            <div class="pt-4 border-t border-gray-200">
                <h3 class="font-bold text-gray-800 mb-2">답변/추가 문의 작성</h3>
                <textarea id="replyContent" placeholder="내용을 입력하세요..." rows="4" class="w-full px-4 py-2 border border-gray-300 rounded-lg outline-none"></textarea>
                <div id="replyActionContainer" class="flex justify-end mt-3">
                    <button onclick="submitReply()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">등록</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const API_URL = '<%= request.getContextPath() %>/branch/support/branch-inquiries-data';
    const CURRENT_USER_ID = <%= (loginUser != null) ? loginUser.getAccountId() : 0 %>;
    const CURRENT_BRANCH_CODE = <%= (loginUser != null) ? loginUser.getBranchCode() : 0 %>;

    let allInquiries = [];
    let editingInquiryId = null;
    let viewingInquiryId = null;
    let currentPage = 1;
    const itemsPerPage = 5;

    document.addEventListener('DOMContentLoaded', () => {
        // 페이지 로딩 시, 현재 로그인된 지점으로 필터 기본값 설정
        document.getElementById('branchFilter').value = CURRENT_BRANCH_CODE;

        loadInquiries();
        document.getElementById('searchInput').addEventListener('keyup', () => { currentPage = 1; loadInquiries(); });
        document.getElementById('branchFilter').addEventListener('change', () => { currentPage = 1; loadInquiries(); });
        document.getElementById('categoryFilter').addEventListener('change', () => { currentPage = 1; loadInquiries(); });
        document.getElementById('statusFilter').addEventListener('change', () => { currentPage = 1; loadInquiries(); });
    });

    async function loadInquiries() {
        const searchTerm = document.getElementById('searchInput').value;
        const branchCode = document.getElementById('branchFilter').value;
        const category = document.getElementById('categoryFilter').value;
        const status = document.getElementById('statusFilter').value;
        try {
            const url = `\${API_URL}?searchTerm=\${encodeURIComponent(searchTerm)}&branchCode=\${branchCode}&category=\${encodeURIComponent(category)}&status=\${encodeURIComponent(status)}`;
            const response = await fetch(url);
            allInquiries = await response.json();
            renderInquiries();
        } catch (error) { console.error(error); }
    }

    function getChipClass(type) {
        switch (type) {
            case '긴급': return 'c-red';
            case '설비 문의': return 'c-purple';
            case '재고 문의': return 'c-orange';
            case '대기 중': return 'c-yellow';
            case '처리 중': return 'c-blue';
            case '답변 완료': return 'c-green';
            default: return 'bg-gray-200 text-gray-800';
        }
    }

    function renderInquiries() {
        const listEl = document.getElementById('inquiryList');
        listEl.innerHTML = '';
        if (allInquiries.length === 0) {
            listEl.innerHTML = '<div class="text-center py-10 text-gray-500">문의사항이 없습니다.</div>';
            document.getElementById('pagination').innerHTML = '';
            return;
        }

        const totalPages = Math.ceil(allInquiries.length / itemsPerPage);
        const paginated = allInquiries.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

        paginated.forEach(inquiry => {
            const validReplies = (inquiry.replies || []).filter(r => r.replyId > 0);
            const chips = `
                \${inquiry.urgency === '긴급' ? '<span class=\"chip c-red mr-2\">긴급</span>' : ''}
                <span class=\"chip \${getChipClass(inquiry.category)} mr-2\">\${inquiry.category}</span>
                <span class=\"chip \${getChipClass(inquiry.status)}\">\${inquiry.status}</span>
            `;
            const item = `
                <div class=\"bg-white rounded-lg border border-gray-200 p-6 item cursor-pointer\" onclick=\"openViewModal(\${inquiry.inquiryId})\">
                    <div class=\"flex justify-between\">
                        <div class=\"flex-1\">
                            <div class=\"mb-2\">\${chips}</div>
                            <h3 class=\"font-bold text-lg text-gray-900 mb-1\">\${inquiry.title}</h3>
                            <p class=\"text-gray-600 line-clamp-1\">\${inquiry.content}</p>
                            <div class=\"flex gap-4 text-xs text-gray-400 mt-3\">
                                <span><i class=\"fas fa-calendar mr-1\"></i>\${inquiry.createdAt}</span>
                                <span><i class=\"fas fa-building mr-1\"></i>\${inquiry.branchName}</span>
                                <span><i class=\"fas fa-comment mr-1\"></i>답변 \${validReplies.length}개</span>
                            </div>
                        </div>
                        <div class=\"flex gap-2\">
                             <button onclick=\"event.stopPropagation(); openEditModal(\${inquiry.inquiryId});\" class=\"p-2 text-gray-400 hover:text-blue-600\"><i class=\"fas fa-edit\"></i></button>
                             <button onclick=\"event.stopPropagation(); deleteInquiry(\${inquiry.inquiryId});\" class=\"p-2 text-gray-400 hover:text-red-600\"><i class=\"fas fa-trash\"></i></button>
                        </div>
                    </div>
                </div>`;
            listEl.innerHTML += item;
        });
        renderPagination(totalPages);
    }

    function renderPagination(totalPages) {
        const el = document.getElementById('pagination');

        totalPages = parseInt(totalPages || 1);

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

    function changePage(page) {
        const totalPages = Math.max(1, Math.ceil(allInquiries.length / itemsPerPage));

        page = parseInt(page || 1);

        if (page < 1) {
            page = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        currentPage = page;
        renderInquiries();
    }

    function openCreateModal() {
        editingInquiryId = null;
        document.getElementById('modalTitle').innerText = '문의하기';
        document.getElementById('inquiryTitle').value = '';
        document.getElementById('inquiryCategory').value = '설비 문의';
        document.getElementById('inquiryUrgency').value = '일반';
        document.getElementById('inquiryContent').value = '';
        document.getElementById('createEditModal').classList.remove('modal-hidden');
    }

    function openEditModal(id) {
        const i = allInquiries.find(inq => inq.inquiryId === id);
        if (!i) return;
        editingInquiryId = id;
        document.getElementById('modalTitle').innerText = '문의 수정';
        document.getElementById('inquiryTitle').value = i.title;
        document.getElementById('inquiryCategory').value = i.category;
        document.getElementById('inquiryUrgency').value = i.urgency;
        document.getElementById('inquiryContent').value = i.content;
        document.getElementById('createEditModal').classList.remove('modal-hidden');
    }

    function closeCreateEditModal() { document.getElementById('createEditModal').classList.add('modal-hidden'); }
    function closeViewModal() { document.getElementById('viewModal').classList.add('modal-hidden'); }

    async function saveInquiry() {
        const data = {
            inquiryId: editingInquiryId,
            title: document.getElementById('inquiryTitle').value.trim(),
            category: document.getElementById('inquiryCategory').value,
            urgency: document.getElementById('inquiryUrgency').value,
            content: document.getElementById('inquiryContent').value.trim()
        };
        const action = editingInquiryId ? 'update' : 'create';
        const res = await fetch(API_URL + '?action=' + action, {
            method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data)
        });
        if (res.ok) { loadInquiries(); closeCreateEditModal(); }
    }

    async function deleteInquiry(id) {
        if (!confirm('삭제하시겠습니까?')) return;
        const res = await fetch(API_URL + '?action=delete&id=' + id, { method: 'POST' });
        if (res.ok) loadInquiries();
    }

    async function openViewModal(id) {
        const res = await fetch(API_URL + '?id=' + id);
        const inquiry = await res.json();
        viewingInquiryId = id;

        document.getElementById('viewTitle').innerText = inquiry.title;
        document.getElementById('viewDate').innerText = `🗓 작성일시: \${inquiry.createdAt} | 🏢 지점: \${inquiry.branchName}`;
        document.getElementById('viewContent').innerText = inquiry.content;

        const repliesContainer = document.getElementById('repliesContainer');
        const validReplies = (inquiry.replies || []).filter(r => r.replyId > 0);
        repliesContainer.innerHTML = `<h3 class=\"font-bold text-gray-800 border-b pb-2\">답변 (\${validReplies.length})</h3>`;

        validReplies.forEach(reply => {
            const isHq = reply.authorAffiliation === '본사' || reply.authorAffiliation === '전체';
            const bgColor = isHq ? 'bg-blue-50 border-l-4 border-blue-500' : 'bg-gray-100';

            repliesContainer.innerHTML += `
                <div class="\${bgColor} p-4 rounded-lg shadow-sm mb-3">
                    <div class=\"flex justify-between text-xs mb-2\">
                        <span class=\"font-bold\">\${reply.authorName} (\${reply.authorAffiliation || '소속 정보 없음'})</span>
                        <span class=\"text-gray-400\">\${reply.createdAt}</span>
                    </div>
                    <p class=\"text-gray-800 text-sm whitespace-pre-wrap\">\${reply.content}</p>
                </div>`;
        });

        const canReply = (CURRENT_BRANCH_CODE === 1 || CURRENT_BRANCH_CODE === inquiry.branchCode);
        const replyTextarea = document.getElementById('replyContent');
        const replyActionContainer = document.getElementById('replyActionContainer');

        if (canReply) {
            replyTextarea.disabled = false;
            replyTextarea.placeholder = "내용을 입력하세요...";
            replyTextarea.classList.remove('bg-gray-100', 'cursor-not-allowed');
            replyActionContainer.innerHTML = `<button onclick="submitReply()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">등록</button>`;
        } else {
            replyTextarea.disabled = true;
            replyTextarea.placeholder = "타 지점의 문의사항에는 답변을 작성할 수 없습니다.";
            replyTextarea.classList.add('bg-gray-100', 'cursor-not-allowed');
            replyActionContainer.innerHTML = '';
        }

        document.getElementById('replyContent').value = '';
        document.getElementById('viewModal').classList.remove('modal-hidden');
    }

    async function submitReply() {
        const content = document.getElementById('replyContent').value.trim();
        if (!content) return;
        const res = await fetch(API_URL + '?action=createReply', {
            method: 'POST', headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ inquiryId: viewingInquiryId, content: content })
        });
        if (res.ok) { openViewModal(viewingInquiryId); loadInquiries(); }
        else if (res.status === 403) { alert('본인의 문의사항에만 답변할 수 있습니다.'); }
    }
</script>
</body>
</html>