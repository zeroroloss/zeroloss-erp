<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의 게시판 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
        .modal-hidden { display: none !important; }
        .inquiry-item { transition: all 0.3s ease; }
        .inquiry-item:hover { box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); }
        .urgent-inquiry { border-left: 4px solid #dc2626; }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/hq/common/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">문의 게시판 관리</h1>
                <p class="text-gray-500 mt-2">직영점의 문의사항 및 건의사항을 확인하고 답변할 수 있습니다.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div class="bg-white rounded-lg border border-gray-200 p-6">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 bg-gray-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-list w-6 h-6 text-gray-600"></i>
                        </div>
                        <div>
                            <p id="statTotal" class="text-2xl font-bold text-gray-900">0건</p>
                            <p class="text-sm text-gray-500">전체 문의</p>
                        </div>
                    </div>
                </div>
                <div class="bg-white rounded-lg border border-gray-200 p-6">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-clock w-6 h-6 text-yellow-600"></i>
                        </div>
                        <div>
                            <p id="statWaiting" class="text-2xl font-bold text-yellow-600">0건</p>
                            <p class="text-sm text-gray-500">대기 중</p>
                        </div>
                    </div>
                </div>
                <div class="bg-white rounded-lg border border-gray-200 p-6">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-hourglass-half w-6 h-6 text-blue-600"></i>
                        </div>
                        <div>
                            <p id="statProcessing" class="text-2xl font-bold text-blue-600">0건</p>
                            <p class="text-sm text-gray-500">처리 중</p>
                        </div>
                    </div>
                </div>
                <div class="bg-white rounded-lg border border-gray-200 p-6">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-check-circle w-6 h-6 text-green-600"></i>
                        </div>
                        <div>
                            <p id="statCompleted" class="text-2xl font-bold text-green-600">0건</p>
                            <p class="text-sm text-gray-500">답변 완료</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="space-y-4">
                    <div class="flex flex-col lg:flex-row gap-4">
                        <div class="flex-1 relative">
                            <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                            <input type="text" id="searchInput" placeholder="제목 또는 내용으로 검색..." class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                        </div>
                        <select id="categoryFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                            <option value="all">전체 카테고리</option>
                            <option value="설비 문의">설비 문의</option>
                            <option value="재고 문의">재고 문의</option>
                            <option value="운영 건의">운영 건의</option>
                            <option value="인사 문의">인사 문의</option>
                            <option value="기타">기타</option>
                        </select>
                        <select id="statusFilter" class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]">
                            <option value="all">전체 상태</option>
                            <option value="대기 중">대기 중</option>
                            <option value="처리 중">처리 중</option>
                            <option value="답변 완료">답변 완료</option>
                        </select>
                    </div>
                </div>
            </div>

            <div id="inquiriesList" class="space-y-4"></div>

            <div id="pagination" class="flex items-center justify-between"></div>
        </div>
    </main>
</div>

<div id="detailModal" class="fixed inset-0 bg-black bg-opacity-50 z-40 modal-hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
            <div class="flex-1">
                <div id="detailChips" class="flex items-center gap-2 mb-3 flex-wrap"></div>
                <h2 id="detailTitle" class="text-2xl font-bold text-gray-900"></h2>
                <div class="flex items-center gap-4 text-sm text-gray-500 mt-3 flex-wrap">
                    <span><i class="fas fa-building w-4 h-4 inline mr-1"></i><span id="detailBranch"></span></span>
                    <span><i class="fas fa-calendar w-4 h-4 inline mr-1"></i><span id="detailDate"></span></span>
                </div>
            </div>
            <button onclick="closeDetailModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-6 h-6"></i>
            </button>
        </div>

        <div class="p-6 space-y-6">
            <div class="bg-gray-50 rounded-lg p-6 border border-gray-200">
                <h3 class="font-bold text-gray-800 mb-2">문의 내용</h3>
                <p id="detailContent" class="whitespace-pre-wrap text-gray-700"></p>
            </div>

            <div id="repliesContainer" class="space-y-4"></div>

            <div class="space-y-3 pt-4 border-t">
                <h3 class="font-bold text-lg">답변 작성</h3>
                <textarea id="replyInput" placeholder="답변을 입력하세요..." rows="5" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D] font-sans"></textarea>
                <div class="flex justify-end gap-3">
                    <button onclick="closeDetailModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">닫기</button>
                    <button onclick="sendReply()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F]">
                        <i class="fas fa-paper-plane w-4 h-4 inline mr-2"></i>답변 전송
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- JSP와 JS 변수 충돌을 막기 위해 변수명을 currentUser로 설정 --%>
<%
    dto.AccountDTO currentUser = (dto.AccountDTO) session.getAttribute("loginUser");
    int currentUserId = (currentUser != null) ? currentUser.getAccountId() : 1;
    int currentBranchCode = (currentUser != null) ? currentUser.getBranchCode() : 1;
%>
<script>
    // 본사(HQ)도 직영점 문의 데이터를 읽고 쓸 수 있도록 동일한 API 사용
    const API_URL = '<%= request.getContextPath() %>/branch/support/branch-inquiries-data';
    const CURRENT_USER_ID = <%= currentUserId %>;
    const CURRENT_BRANCH_CODE = <%= currentBranchCode %>; // 본사는 1

    let allInquiries = [];
    let selectedInquiryId = null;
    let currentPage = 1;
    const itemsPerPage = 8;

    document.addEventListener('DOMContentLoaded', () => {
        loadInquiries();
        document.getElementById('searchInput').addEventListener('keyup', () => { currentPage = 1; loadInquiries(); });
        document.getElementById('categoryFilter').addEventListener('change', () => { currentPage = 1; loadInquiries(); });
        document.getElementById('statusFilter').addEventListener('change', () => { currentPage = 1; loadInquiries(); });
    });

    async function loadInquiries() {
        const searchTerm = document.getElementById('searchInput').value;
        const category = document.getElementById('categoryFilter').value;
        const status = document.getElementById('statusFilter').value;

        try {
            const url = API_URL + '?searchTerm=' + encodeURIComponent(searchTerm) + '&category=' + encodeURIComponent(category) + '&status=' + encodeURIComponent(status);
            const response = await fetch(url);
            if (!response.ok) throw new Error('데이터 로드 실패');

            allInquiries = await response.json();
            updateStatistics();
            renderInquiries();
        } catch (error) {
            console.error(error);
        }
    }

    function updateStatistics() {
        const total = allInquiries.length;
        const waiting = allInquiries.filter(i => i.status === '대기 중').length;
        const processing = allInquiries.filter(i => i.status === '처리 중').length;
        const completed = allInquiries.filter(i => i.status === '답변 완료').length;

        document.getElementById('statTotal').innerText = total + '건';
        document.getElementById('statWaiting').innerText = waiting + '건';
        document.getElementById('statProcessing').innerText = processing + '건';
        document.getElementById('statCompleted').innerText = completed + '건';
    }

    function getCategoryColor(category) {
        const colors = {
            '설비 문의': 'bg-purple-100 text-purple-800',
            '재고 문의': 'bg-orange-100 text-orange-800',
            '운영 건의': 'bg-blue-100 text-blue-800',
            '인사 문의': 'bg-green-100 text-green-800',
            '기타': 'bg-gray-100 text-gray-800'
        };
        return colors[category] || 'bg-gray-100 text-gray-800';
    }

    function getStatusColor(status) {
        const colors = {
            '대기 중': 'bg-yellow-100 text-yellow-800',
            '처리 중': 'bg-blue-100 text-blue-800',
            '답변 완료': 'bg-green-100 text-green-800'
        };
        return colors[status] || 'bg-gray-100 text-gray-800';
    }

    function renderInquiries() {
        const listEl = document.getElementById('inquiriesList');
        listEl.innerHTML = '';

        if (allInquiries.length === 0) {
            listEl.innerHTML = '<div class="bg-white rounded-lg border border-gray-200 p-12 text-center"><i class="fas fa-search w-12 h-12 text-gray-400 mx-auto mb-4 block"></i><p class="text-gray-500">조회된 문의사항이 없습니다.</p></div>';
            document.getElementById('pagination').innerHTML = '';
            return;
        }

        const totalPages = Math.ceil(allInquiries.length / itemsPerPage);
        if (currentPage > totalPages) currentPage = totalPages || 1;
        const paginated = allInquiries.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage);

        paginated.forEach(inquiry => {
            const urgentClass = inquiry.urgency === '긴급' ? 'urgent-inquiry' : '';
            const validReplies = (inquiry.replies || []).filter(r => r.replyId > 0);
            const timeDisplay = inquiry.updatedAt ? `<span class="text-blue-500">${inquiry.updatedAt} (수정됨)</span>` : inquiry.createdAt;

            const chips = `
                \${inquiry.urgency === '긴급' ? '<span class=\"inline-block px-3 py-1 bg-red-100 text-red-800 text-sm font-medium rounded mr-2\">긴급</span>' : ''}
                <span class=\"inline-block px-3 py-1 text-sm font-medium rounded mr-2 \${getCategoryColor(inquiry.category)}\">\${inquiry.category}</span>
                <span class=\"inline-block px-3 py-1 text-sm font-medium rounded \${getStatusColor(inquiry.status)}\">\${inquiry.status}</span>
            `;

            const item = `
                <div class=\"bg-white rounded-lg border border-gray-200 p-6 inquiry-item cursor-pointer \${urgentClass}\" onclick=\"viewInquiry(\${inquiry.inquiryId})\">
                    <div class=\"flex items-start justify-between gap-4\">
                        <div class=\"flex-1 space-y-2\">
                            <div class=\"flex items-center gap-2 flex-wrap\">\${chips}</div>
                            <h3 class=\"font-bold text-lg text-gray-900\">\${inquiry.title}</h3>
                            <p class=\"text-gray-600 line-clamp-2\">\${inquiry.content}</p>
                            <div class=\"flex items-center justify-between flex-wrap mt-2\">
                                <div class=\"flex items-center gap-4 text-sm text-gray-500\">
                                    <span><i class=\"fas fa-building w-4 h-4 inline mr-1\"></i>\${inquiry.branchName}</span>
                                    <span><i class=\"fas fa-calendar w-4 h-4 inline mr-1\"></i>\${timeDisplay}</span>
                                </div>
                                <div class=\"flex items-center gap-2 text-sm text-gray-500\">
                                    <i class=\"fas fa-comments w-4 h-4\"></i>
                                    <span>답변 \${validReplies.length}개</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>`;
            listEl.innerHTML += item;
        });

        renderPagination(totalPages);
    }

    function renderPagination(totalPages) {
        const el = document.getElementById('pagination');
        if (totalPages <= 1) { el.innerHTML = ''; return; }

        const prevDisabled = currentPage === 1 ? 'disabled opacity-50 cursor-not-allowed' : '';
        const nextDisabled = currentPage === totalPages ? 'disabled opacity-50 cursor-not-allowed' : '';

        el.innerHTML = `
            <button onclick=\"changePage(\${currentPage - 1})\" class=\"flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 \${prevDisabled}\">
                <i class=\"fas fa-chevron-left w-4 h-4\"></i><span>이전</span>
            </button>
            <div class=\"text-gray-600\"><span>\${currentPage} / \${totalPages}</span></div>
            <button onclick=\"changePage(\${currentPage + 1})\" class=\"flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 \${nextDisabled}\">
                <span>다음</span><i class=\"fas fa-chevron-right w-4 h-4\"></i>
            </button>`;
    }

    function changePage(p) {
        if (p > 0) { currentPage = p; renderInquiries(); window.scrollTo(0,0); }
    }

    async function viewInquiry(id) {
        try {
            const res = await fetch(API_URL + '?id=' + id);
            const inquiry = await res.json();
            selectedInquiryId = id;

            // 상단 칩 세팅
            const chips = `
                \${inquiry.urgency === '긴급' ? '<span class=\"inline-block px-3 py-1 bg-red-100 text-red-800 text-sm font-medium rounded\">긴급</span>' : ''}
                <span class=\"inline-block px-3 py-1 text-sm font-medium rounded \${getCategoryColor(inquiry.category)}\">\${inquiry.category}</span>
                <span class=\"inline-block px-3 py-1 text-sm font-medium rounded \${getStatusColor(inquiry.status)}\">\${inquiry.status}</span>
            `;
            document.getElementById('detailChips').innerHTML = chips;

            // 본문 및 메타정보 세팅
            const timeDisplay = inquiry.updatedAt ? `\${inquiry.updatedAt} (수정됨)` : inquiry.createdAt;
            document.getElementById('detailTitle').innerText = inquiry.title;
            document.getElementById('detailBranch').innerText = inquiry.branchName;
            document.getElementById('detailDate').innerText = timeDisplay;
            document.getElementById('detailContent').innerText = inquiry.content;

            // 답변 목록 세팅
            const repliesContainer = document.getElementById('repliesContainer');
            const validReplies = (inquiry.replies || []).filter(r => r.replyId > 0);

            repliesContainer.innerHTML = `<h3 class=\"font-bold text-lg border-b pb-2\">답변 (\${validReplies.length})</h3>`;

            validReplies.forEach(reply => {
                // 본사 관리자 답변(파란색), 지점 답변(회색)
                const isHq = reply.authorAffiliation === '본사' || reply.authorAffiliation === '전체';
                const bgClass = isHq ? 'bg-blue-50 border-l-4 border-blue-500' : 'bg-gray-100';

                repliesContainer.innerHTML += `
                    <div class=\"rounded-lg p-4 \${bgClass} mb-3 shadow-sm\">
                        <div class=\"flex items-center justify-between mb-2\">
                            <span class=\"font-bold text-sm\">\${reply.authorName} (\${reply.authorAffiliation})</span>
                            <span class=\"text-xs text-gray-500\">\${reply.createdAt}</span>
                        </div>
                        <p class=\"text-gray-800 whitespace-pre-wrap\">\${reply.content}</p>
                    </div>`;
            });

            document.getElementById('replyInput').value = '';
            document.getElementById('detailModal').classList.remove('modal-hidden');
        } catch(e) {
            console.error(e);
            alert("상세 정보를 불러오지 못했습니다.");
        }
    }

    function closeDetailModal() {
        document.getElementById('detailModal').classList.add('modal-hidden');
        selectedInquiryId = null;
    }

    async function sendReply() {
        const replyContent = document.getElementById('replyInput').value.trim();
        if (!replyContent) return alert('답변을 입력해주세요.');

        try {
            const res = await fetch(API_URL + '?action=createReply', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ inquiryId: selectedInquiryId, content: replyContent })
            });

            if (res.ok) {
                alert('답변이 전송되었습니다.');
                await loadInquiries();       // 리스트 업데이트 및 통계 갱신
                viewInquiry(selectedInquiryId); // 모달창 내용 새로고침
            } else if (res.status === 403) {
                alert('권한이 없습니다.');
            } else {
                alert('오류가 발생했습니다.');
            }
        } catch(e) {
            console.error(e);
        }
    }
</script>
</body>
</html>