<%@ page import="java.util.List" %>
<%@ page import="dto.BranchDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<BranchDTO> branches = (List<BranchDTO>) request.getAttribute("branches");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의사항 관리 - ZERO LOSS 본사 관리 시스템</title>
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
<%@ include file="/hq/common/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">문의사항 관리</h1>
                    <p class="text-gray-500 mt-2">전체 직영점에서 접수된 문의사항을 확인하고 답변할 수 있습니다.</p>
                </div>
            </div>

            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="flex flex-col lg:flex-row gap-4">
                    <div class="flex-1 relative">
                        <input type="text" id="searchInput" placeholder="제목, 내용으로 검색..." class="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
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
                <h3 class="font-bold text-gray-800 mb-2">답변 작성</h3>
                <textarea id="replyContent" placeholder="답변 내용을 입력하세요..." rows="4" class="w-full px-4 py-2 border border-gray-300 rounded-lg outline-none"></textarea>
                <div class="flex justify-between items-center mt-3">
                    <div class="flex items-center">
                        <label for="statusChange" class="mr-2 text-sm font-medium text-gray-700">답변 후 상태 변경:</label>
                        <select id="statusChange" class="px-3 py-1.5 border border-gray-300 rounded-lg text-sm">
                            <option value="처리 중">처리 중</option>
                            <option value="답변 완료">답변 완료</option>
                        </select>
                    </div>
                    <button onclick="submitReply()" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                        <i class="fas fa-paper-plane mr-2"></i>답변 등록
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const API_URL = '<%= request.getContextPath() %>/hq/support/headquarters-inquiries-data';
    const CURRENT_USER_ID = <%= (loginUser != null) ? loginUser.getAccountId() : 0 %>;

    let allInquiries = [];
    let viewingInquiryId = null;
    let currentPage = 1;
    const itemsPerPage = 5;
    const PAGE_SIZE = 5;

    document.addEventListener('DOMContentLoaded', () => {
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
            listEl.innerHTML = '<div class="text-center py-10 text-gray-500">표시할 문의사항이 없습니다.</div>';
            document.getElementById('paginationContainer').classList.add('hidden');
            document.getElementById('paginationInfo').textContent = '';
            document.getElementById('pageButtons').innerHTML = '';
            return;
        }

        const totalPages = Math.ceil(allInquiries.length / itemsPerPage);
        const paginated = allInquiries.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

        paginated.forEach(inquiry => {
            const validReplies = (inquiry.replies || []).filter(r => r.replyId > 0);
            const chips = `
                \${inquiry.urgency === '긴급' ? `<span class="chip c-red mr-2">긴급</span>` : ''}
                <span class="chip \${getChipClass(inquiry.category)} mr-2">\${inquiry.category}</span>
                <span class="chip \${getChipClass(inquiry.status)}">\${inquiry.status}</span>
            `;
            const item = `
                <div class="bg-white rounded-lg border border-gray-200 p-6 item cursor-pointer" onclick="openViewModal(\${inquiry.inquiryId})">
                    <div class="flex justify-between">
                        <div class="flex-1">
                            <div class="mb-2">\${chips}</div>
                            <h3 class="font-bold text-lg text-gray-900 mb-1">\${inquiry.title}</h3>
                            <p class="text-gray-600 line-clamp-1">\${inquiry.content}</p>
                            <div class="flex gap-4 text-xs text-gray-400 mt-3">
                                <span><i class="fas fa-calendar mr-1"></i>\${inquiry.createdAt}</span>
                                <span><i class="fas fa-building mr-1"></i>\${inquiry.branchName}</span>
                                <span><i class="fas fa-comment mr-1"></i>답변 \${validReplies.length}개</span>
                            </div>
                        </div>
                    </div>
                </div>`;
            listEl.innerHTML += item;
        });
        renderPagination(totalPages);
    }

    function renderPagination(totalPages) {
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

        const totalItems = allInquiries.length;
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
        const totalPages = Math.ceil(allInquiries.length / itemsPerPage);

        if (page < 1 || page > totalPages) {
            return;
        }

        currentPage = page;
        renderInquiries();

        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }

    function closeViewModal() { document.getElementById('viewModal').classList.add('modal-hidden'); }

    async function openViewModal(id) {
        const res = await fetch(`\${API_URL}?id=\${id}`);
        const inquiry = await res.json();
        viewingInquiryId = id;

        const chips = `
            \${inquiry.urgency === '긴급' ? `<span class="chip c-red">긴급</span>` : ''}
            <span class="chip \${getChipClass(inquiry.category)}">\${inquiry.category}</span>
            <span class="chip \${getChipClass(inquiry.status)}">\${inquiry.status}</span>
        `;
        document.getElementById('viewChips').innerHTML = chips;
        document.getElementById('viewTitle').innerText = inquiry.title;
        document.getElementById('viewDate').innerText = `🗓 작성일시: \${inquiry.createdAt} | 🏢 지점: \${inquiry.branchName}`;
        document.getElementById('viewContent').innerText = inquiry.content;

        const repliesContainer = document.getElementById('repliesContainer');
        const validReplies = (inquiry.replies || []).filter(r => r.replyId > 0);
        repliesContainer.innerHTML = `<h3 class="font-bold text-gray-800 border-b pb-2">답변 (\${validReplies.length})</h3>`;

        validReplies.forEach(reply => {
            const isHq = reply.authorAffiliation === '본사' || reply.authorAffiliation === '전체';
            const bgColor = isHq ? 'bg-blue-50 border-l-4 border-blue-500' : 'bg-gray-100';
            repliesContainer.innerHTML += `
                <div class="\${bgColor} p-4 rounded-lg shadow-sm mb-3">
                    <div class="flex justify-between text-xs mb-2">
                        <span class="font-bold">\${reply.authorName} (\${reply.authorAffiliation || '소속 정보 없음'})</span>
                        <span class="text-gray-400">\${reply.createdAt}</span>
                    </div>
                    <p class="text-gray-800 text-sm whitespace-pre-wrap">\${reply.content}</p>
                </div>`;
        });

        document.getElementById('replyContent').value = '';
        document.getElementById('statusChange').value = inquiry.status === '답변 완료' ? '답변 완료' : '처리 중';
        document.getElementById('viewModal').classList.remove('modal-hidden');
    }

    async function submitReply() {
        const content = document.getElementById('replyContent').value.trim();
        if (!content) { alert("답변 내용을 입력해주세요."); return; }

        const newStatus = document.getElementById('statusChange').value;
        const res = await fetch(`\${API_URL}?action=createReply`, {
            method: 'POST', headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                inquiryId: viewingInquiryId,
                content: content,
                newStatus: newStatus
            })
        });
        if (res.ok) {
            await openViewModal(viewingInquiryId);
            await loadInquiries();
        } else {
            alert("답변 등록에 실패했습니다.");
        }
    }
</script>
</body>
</html>