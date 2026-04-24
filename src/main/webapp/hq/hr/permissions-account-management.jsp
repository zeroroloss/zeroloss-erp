<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직영점 계정 발급/삭제 및 권한 부여 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar {
            transform: translateX(0);
        }
        .modal-hidden {
            display: none !important;
            visibility: hidden !important;
            opacity: 0 !important;
            pointer-events: none !important;
        }
    </style>
</head>
<body class="bg-gray-50">
	    <%@ include file="/hq/common/sidebar.jsp" %>
        <!-- 메인 콘텐츠 -->
        <div class="lg:pl-72">

            <!-- 페이지 콘텐츠 -->
            <main class="p-6">
                <div class="space-y-6">
                    <!-- 페이지 헤더 -->
                    <div class="flex items-center justify-between">
                        <div>
                            <h3 class="text-3xl font-bold text-gray-900">직영점 계정 발급/삭제 및 권한 부여</h3>
                            <p class="text-gray-500 mt-1">직영점 계정을 통합 관리하고 권한을 설정하세요</p>
                        </div>
                        <button onclick="showAddModal()" class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2.5 rounded-lg hover:bg-[#006B2F] transition-colors">
                            <i class="fas fa-user-plus w-5 h-5"></i>
                            <span>계정 추가</span>
                        </button>
                    </div>
                    <!-- 통계 카드 -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="bg-white rounded-lg border border-gray-200 p-4">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                    <i class="fas fa-shield w-6 h-6 text-blue-600"></i>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500">전체 계정</p>
                                    <p class="text-2xl font-bold text-gray-900 mt-1" id="totalCount">${totalCnt}</p>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg border border-gray-200 p-4">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                                    <i class="fas fa-circle-check w-6 h-6 text-green-600"></i>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500">활성 계정</p>
                                    <p class="text-2xl font-bold text-gray-900 mt-1" id="activeCount">${activeCnt}</p>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white rounded-lg border border-gray-200 p-4">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                                    <i class="fas fa-circle-xmark w-6 h-6 text-red-600"></i>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-500">비활성 계정</p>
                                    <p class="text-2xl font-bold text-gray-900 mt-1" id="inactiveCount">${inactiveCnt}</p>
                                </div>
                            </div>
                        </div>
                    </div>

					<!-- 검색 및 필터 -->
					<div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
					    <div class="flex flex-col gap-4">
					        
					        <!-- 검색 영역 -->
					        <div class="flex items-center justify-between gap-4">
					            <div>
					                <h3 class="text-sm font-semibold text-gray-800">계정 검색</h3>
					                <p class="text-xs text-gray-500 mt-1">이름, 아이디, 소속 매장 기준으로 검색할 수 있습니다.</p>
					            </div>
					
					            <div class="flex items-center gap-2">
					                <div class="relative w-80">
					                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-sm"></i>
					                    <input type="text" id="searchInput" onkeydown="if(event.key === 'Enter') applyFilters();" placeholder="검색어를 입력하세요"class="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
					                </div>
					                <button type="button" onclick="applyFilters()" class="px-5 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">조회</button>
					                <button type="button" onclick="resetFilters()" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">초기화</button>
					            </div>
					        </div>
					    </div>
					</div>

                    <!-- 계정 테이블 -->
                    <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="bg-gray-50 border-b border-gray-200">
                                    <tr>
                                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">이름</th>
                                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">아이디</th>
                                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">소속 매장</th>
                                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">역할</th>
                                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
                                    </tr>
                                </thead>
                                <tbody id="accountTableBody" class="bg-white divide-y divide-gray-200">
                                    <!-- 동적으로 생성됨 -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add Account Modal -->
    <div id="addModal" class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onclick="if(event.target === this) closeAddModal()">
        <div class="bg-white rounded-lg max-w-sm w-full max-h-[90vh] overflow-y-auto" onclick="event.stopPropagation()">
            <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white">
                <h3 class="text-lg font-bold text-gray-900">계정 추가</h3>
                <button onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times w-5 h-5"></i>
                </button>
            </div>

            <div class="p-6 space-y-4">
            	<div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">사번</label>
                    <input type="text" name="empNo" placeholder="1" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">아이디</label>
                    <input type="text" name="loginId" placeholder="user_id" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
                    <input type="password" name="password" placeholder="••••••••" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">소속 매장</label>
                    <select name="branchCode" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
                        <option value="">선택하세요</option>
                        
                        <c:forEach var="branch" items="${branchNameList }">
                        	<option value="${branch.branchCode }" class="text-gray-900 bg-white">${branch.branchName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="flex items-center gap-2">
                    <input type="checkbox" id="isActiveAdd" checked class="w-4 h-4 text-[#00853D] border-gray-300 rounded focus:ring-[#00853D]">
                    <label for="isActiveAdd" class="text-sm text-gray-700">계정 활성화</label>
                </div>
            </div>

            <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
                <button onclick="closeAddModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                    취소
                </button>
                <button onclick="saveAccount()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
                    추가
                </button>
            </div>
        </div>
    </div>

    <!-- Edit Account Modal -->
    <div id="editModal" class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onclick="if(event.target === this) closeEditModal()">
        <div class="bg-white rounded-lg max-w-sm w-full max-h-[90vh] overflow-y-auto" onclick="event.stopPropagation()">
            <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white">
                <h3 class="text-lg font-bold text-gray-900">권한 변경</h3>
                <button onclick="editAccountModal(accountId)" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times w-5 h-5"></i>
                </button>
            </div>

            <div class="p-6 space-y-4">
                <div id="editAccountInfo" class="bg-gray-50 rounded-lg p-3">
                    <!-- 동적으로 생성됨 -->
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">역할 변경</label>
                    <select id="editRoleSelect" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                        <option>본사관리자</option>
                        <option>지점장</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">소속 매장</label>
                    <select id="editBranchSelect" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                        <option value="">선택하세요</option>
                        
                        <c:forEach var="branchName" items="${branchNameList }">
                        	<option value="${branch.branchCode }">${branch.branchName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 flex items-start gap-2">
                    <i class="fas fa-triangle-exclamation w-4 h-4 text-yellow-600 flex-shrink-0 mt-0.5"></i>
                    <p class="text-xs text-yellow-800">역할 변경 시 해당 계정의 접근 권한이 즉시 변경됩니다.</p>
                </div>
            </div>

            <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
                <button onclick="closeEditModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                    취소
                </button>
                <button onclick="updateAccount()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
                    저장
                </button>
            </div>
        </div>
    </div>

    <script>
        var selectedAccount = null;
        
        var accounts = [
            <c:forEach var="account" items="${accountList}" varStatus="status">
            {
                name: "${account.userName}",
                username: "${account.loginId}",
                branch: "${account.branchName}",
                role: "${account.roleName}",
                status: "${account.status}"
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        var filtered = accounts.filter(function(account) {
            var matchesSearch =
                account.name.toLowerCase().includes(searchTerm) ||
                account.username.toLowerCase().includes(searchTerm) ||
                account.branch.toLowerCase().includes(searchTerm);

            return matchesSearch;
        });

        // 초기화
        window.addEventListener('DOMContentLoaded', function() {
            renderBranchFilters();
            renderRoleFilters();
            renderAccounts();
            updateStats();
            setupSidebarToggle();
        });

        function setupSidebarToggle() {
            var sidebarToggle = document.getElementById('mobileMenuBtn');
            var sidebar = document.getElementById('sidebar');
            var backdrop = document.getElementById('sidebarBackdrop');

            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    toggleSidebar();
                });
            }

            if (backdrop) {
                backdrop.addEventListener('click', function() {
                    sidebar.classList.add('-translate-x-full');
                    backdrop.classList.add('hidden');
                });
            }
        }

        function toggleSidebar() {
            var sidebar = document.getElementById('sidebar');
            var backdrop = document.getElementById('sidebarBackdrop');
            sidebar.classList.toggle('-translate-x-full');
            backdrop.classList.toggle('hidden');
        }

        function toggleUserMenu() {
            var userMenu = document.getElementById('userMenu');
            userMenu.classList.toggle('hidden');
        }

        function logout() {
            alert('로그아웃되었습니다.');
        }

        function toggleMenu(button) {
            var submenu = button.nextElementSibling;
            if (submenu && submenu.classList.contains('submenu')) {
                submenu.classList.toggle('hidden');
                var arrow = button.querySelector('i:last-child');
                arrow.classList.toggle('fa-chevron-right');
                arrow.classList.toggle('fa-chevron-down');
            }
        }

        function applyFilters() {
            renderAccounts();
        }
        
        function resetFilters() {
        	document.getElementById("searchInput").value="";
        	applyFilters();
        }

        function renderAccounts() {
            var searchTerm = document.getElementById('searchInput').value.toLowerCase();
            var filtered = accounts.filter(function(account) {
                var matchesSearch = account.name.toLowerCase().includes(searchTerm) || 
                                   account.username.toLowerCase().includes(searchTerm) || 
                                   account.branch.toLowerCase().includes(searchTerm);
                return matchesSearch;
            });
            
            //log 확인
            console.log(filtered);

            var tbody = document.getElementById('accountTableBody');
            if (filtered.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">검색 결과가 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = filtered.map(function(account) {
                var roleColor = account.role === '본사 관리자' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700';
                var statusColor = account.isActive ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700';
                var statusText = account.isActive ? '활성' : '비활성';
                return '<tr class="hover:bg-gray-50">' +
                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<div class="flex items-center gap-3">' +
                            '<div class="w-8 h-8 rounded-full bg-[#00853D] flex items-center justify-center text-white font-semibold text-xs">' + account.name.charAt(0) + '</div>' +
                            '<div>' +
                                '<div class="font-medium text-gray-900 text-sm">' + account.name + '</div>' +
                                '<div class="text-xs text-gray-500">가입: ' + account.createdDate + '</div>' +
                            '</div>' +
                        '</div>' +
                    '</td>' +
                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<div class="text-sm text-gray-900">' + account.username + '</div>' +
                        (account.lastLogin ? '<div class="text-xs text-gray-500">' + account.lastLogin + '</div>' : '') +
                    '</td>' +
                    '<td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">' + account.branch + '</td>' +
                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<span class="inline-flex px-2 py-0.5 text-xs font-medium rounded-full ' + roleColor + '">' + account.role + '</span>' +
                    '</td>' +
                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<button onclick="toggleActive(\'' + account.id + '\')" class="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-lg transition-colors ' + statusColor + '">' +
                            '<i class="fas fa-circle ' + (account.isActive ? 'text-green-600' : 'text-red-600') + '"></i>' + statusText +
                        '</button>' +
                    '</td>' +
                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<div class="flex items-center gap-2">' +
                            '<button onclick="editAccountModal(\'' + account.id + '\')" class="text-blue-600 hover:text-blue-700" title="권한 변경">' +
                                '<i class="fas fa-edit w-4 h-4"></i>' +
                            '</button>' +
                        '</div>' +
                    '</td>' +
                '</tr>';
            }).join('');
        }

        function updateStats() {
            var total = accounts.length;
            var active = accounts.filter(function(a) { return a.isActive; }).length;
            var inactive = total - active;

            document.getElementById('totalCount').textContent = total;
            document.getElementById('activeCount').textContent = active;
            document.getElementById('inactiveCount').textContent = inactive;
        }

        function toggleActive(accountId) {
            if (!confirm("계정 상태를 변경하시겠습니까?")) {
                return;
            }
            location.href = "${pageContext.request.contextPath}/hq/account/status-toggle?accountId=" + accountId;
        }

        function showAddModal() {
            var modal = document.getElementById('addModal');
            modal.classList.remove('modal-hidden');
        }

        function closeAddModal() {
            var modal = document.getElementById('addModal');
            modal.classList.add('modal-hidden');
        }

        function saveAccount() {
            alert('계정이 추가되었습니다.');
            closeAddModal();
        }

        function editAccountModal(accountId) {
            selectedAccount = accounts.find(function(a) { return a.id === accountId; });
            if (selectedAccount) {
                var info = '<div class="flex items-center gap-2 mb-2">' +
                    '<div class="w-8 h-8 rounded-full bg-[#00853D] flex items-center justify-center text-white font-semibold text-xs">' + selectedAccount.name.charAt(0) + '</div>' +
                    '<div>' +
                        '<div class="font-medium text-gray-900 text-sm">' + selectedAccount.name + '</div>' +
                        '<div class="text-xs text-gray-500">' + selectedAccount.username + '</div>' +
                    '</div>' +
                    '</div>' +
                    '<div class="text-xs text-gray-600">' +
                        '<p>소속: ' + selectedAccount.branch + '</p>' +
                    '</div>';
                document.getElementById('editAccountInfo').innerHTML = info;
                document.getElementById('editRoleSelect').value = selectedAccount.role;
                document.getElementById('editBranchSelect').value = selectedAccount.branch;
                var modal = document.getElementById('editModal');
                modal.classList.remove('modal-hidden');
            }
        }

        function closeEditModal() {
            var modal = document.getElementById('editModal');
            modal.classList.add('modal-hidden');
        }

        function updateAccount() {
            if (selectedAccount) {
                selectedAccount.role = document.getElementById('editRoleSelect').value;
                selectedAccount.branch = document.getElementById('editBranchSelect').value;
                alert('권한이 변경되었습니다.');
                closeEditModal();
                renderAccounts();
                updateStats();
            }
        }
    </script>
</body>
</html>

