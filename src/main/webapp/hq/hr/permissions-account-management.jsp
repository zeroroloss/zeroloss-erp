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
					            	<!-- 소속명 선택 -->
					                <select id="branchNameSelect"
					                        class="w-44 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
					                    <option value="">전체 소속</option>
										<c:forEach var="branch" items="${branchNameList}">
										    <option value="${branch.branchName}">
										        ${branch.branchName}
										    </option>
										</c:forEach>
					                </select>
					                
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
                    <input type="text" id="empNo" name="empNo" placeholder="1" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">아이디</label>
                    <input type="text" id="loginId" name="loginId" placeholder="user_id" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">소속 매장</label>
                    <select name="branchCode" id ="branchCode" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
                        <option value="">선택하세요</option>
                        
                        <c:forEach var="branch" items="${branchNameList }">
                        	<option value="${branch.branchCode }" class="text-gray-900 bg-white">${branch.branchName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div>
				    <label class="block text-sm font-medium text-gray-700 mb-1">역할</label>
				    <select id="roleId" name="roleId"
				            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
				        <option value="">선택하세요</option>
				        <option value="1">본사 관리자</option>
				        <option value="2">지점장</option>
				        <option value="3">매니저</option>
				    </select>
				</div>

                <div class="flex items-center gap-2">
                    <input type="checkbox" name="status" id="isActiveAdd" checked class="w-4 h-4 text-[#00853D] border-gray-300 rounded focus:ring-[#00853D]">
                    <label for="isActiveAdd" class="text-sm text-gray-700">계정 활성화</label>
                </div>
            </div>

            <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
                <button onclick="closeAddModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                    취소
                </button>
                <button type="button" onclick="saveAccount()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
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
                <button type="button" onclick="closeEditModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times w-5 h-5"></i>
                </button>
            </div>

            <div class="p-6 space-y-4">
                <div id="editAccountInfo" class="bg-gray-50 rounded-lg p-3">
                    <!-- 동적으로 생성됨 -->
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">역할 변경</label>
                    <select id="editRoleId" name="editRoleId"
				            class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900 focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
				        <option value="">선택하세요</option>
				        <option value="1">본사 관리자</option>
				        <option value="2">지점장</option>
				        <option value="3">매니저</option>
				    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">소속 매장</label>
                    <select name="editBranchCode" id ="editBranchCode" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
                        <option value="">선택하세요</option>
                        
                        <c:forEach var="branch" items="${branchNameList }">
                        	<option value="${branch.branchCode }" class="text-gray-900 bg-white">${branch.branchName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
                    <select id="editStatus" name="editStatus" class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900 focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                        <option value="">선택하세요</option>
                        <option value="ACTIVE">활성화</option>
                        <option value="INACTIVE">비활성화</option>
                        <option value="LOCKED">잠금</option>
                    </select>
                </div>

                <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 flex items-start gap-2">
                    <i class="fas fa-triangle-exclamation w-4 h-4 text-yellow-600 flex-shrink-0 mt-0.5"></i>
                    <p class="text-xs text-yellow-800">역할 변경 시 해당 계정의 접근 권한이 즉시 변경됩니다.</p>
                </div>
            </div>

            <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
                <button type="button" onclick="closeEditModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                    취소
                </button>
                <button type="button" onclick="updateAccount()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
                    저장
                </button>
            </div>
        </div>
    </div>

    <script>
        var selectedAccount = null;
        var currentPage = 1;
        var pageSize = 10;
        var PAGE_SIZE = 5;
        
        var accounts = [
            <c:forEach var="account" items="${accountList}" varStatus="status">
            {
            	id: "${account.accountId}",
                name: "${account.userName}",
                username: "${account.loginId}",
                branchCode: "${account.branchCode}",
                branch: "${account.branchName}",
                roleId: "${account.roleId}",
                role: "${account.roleName}",
                status: "${account.status}",
                isActive: "${account.status}" === "ACTIVE",
                createdDate: "${account.createdAt}",
                lastLogin: "${account.lastLoginAt}"
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        var searchTerm = document.getElementById("searchInput").value.toLowerCase();
        
        var filtered = accounts.filter(function(account) {
            var matchesSearch =
                account.name.toLowerCase().includes(searchTerm) ||
                account.username.toLowerCase().includes(searchTerm) ||
                account.branch.toLowerCase().includes(searchTerm);

            return matchesSearch;
        });

        // 초기화
        window.addEventListener('DOMContentLoaded', function() {
            clearAccountTable();
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
            document.getElementById("searchInput").value = "";
            document.getElementById('branchNameSelect').value = '';
            currentPage = 1;
            clearAccountTable();

            document.getElementById('paginationContainer').classList.add('hidden');
            document.getElementById('paginationInfo').textContent = '';
            document.getElementById('pageButtons').innerHTML = '';
        }

        function renderAccounts() {
            var searchTerm = document.getElementById('searchInput').value.trim().toLowerCase();
            var selectedBranchName = document.getElementById("branchNameSelect").value.trim();

            var filtered = accounts.filter(function(account) {
                var name = String(account.name || "").toLowerCase();
                var username = String(account.username || "").toLowerCase();
                var branch = String(account.branch || "").toLowerCase();
                var role = String(account.role || "").toLowerCase();

                // 검색어가 없으면 검색 조건은 전체 통과
                var matchesSearch = searchTerm === "" ||
                    name.includes(searchTerm) ||
                    username.includes(searchTerm) ||
                    branch.includes(searchTerm) ||
                    role.includes(searchTerm);

                // 소속 선택 안 했으면 소속 조건은 전체 통과
                var matchesBranch = selectedBranchName === "" ||
                    account.branch === selectedBranchName;

                return matchesSearch && matchesBranch;
            });

            var tbody = document.getElementById('accountTableBody');

            if (filtered.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">검색 결과가 없습니다.</td></tr>';
                renderPagination(0, 0);
                return;
            }

            var totalPages = Math.ceil(filtered.length / pageSize);

            if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            var start = (currentPage - 1) * pageSize;
            var end = start + pageSize;
            var pageList = filtered.slice(start, end);

            tbody.innerHTML = pageList.map(function(account) {
                var isActive = account.status === "ACTIVE";
                var roleColor = account.role === '본사 관리자' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700';
                var statusColor = isActive ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700';
                var statusText = isActive ? '활성' : '비활성';

                return '<tr class="hover:bg-gray-50">' +
                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<div class="flex items-center gap-3">' +
                            '<div class="w-8 h-8 rounded-full bg-[#00853D] flex items-center justify-center text-white font-semibold text-xs">' +
                                (account.name ? account.name.charAt(0) : '-') +
                            '</div>' +
                            '<div>' +
                                '<div class="font-medium text-gray-900 text-sm">' + (account.name || '-') + '</div>' +
                                '<div class="text-xs text-gray-500">가입: ' + (account.createdDate || '-') + '</div>' +
                            '</div>' +
                        '</div>' +
                    '</td>' +

                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<div class="text-sm text-gray-900">' + (account.username || '-') + '</div>' +
                        (account.lastLogin ? '<div class="text-xs text-gray-500">' + account.lastLogin + '</div>' : '') +
                    '</td>' +

                    '<td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">' + (account.branch || '-') + '</td>' +

                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<span class="inline-flex px-2 py-0.5 text-xs font-medium rounded-full ' + roleColor + '">' +
                            (account.role || '-') +
                        '</span>' +
                    '</td>' +

                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<button onclick="toggleActive(\'' + account.id + '\')" class="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded-lg transition-colors ' + statusColor + '">' +
                            '<i class="fas fa-circle ' + (isActive ? 'text-green-600' : 'text-red-600') + '"></i>' +
                            statusText +
                        '</button>' +
                    '</td>' +

                    '<td class="px-4 py-3 whitespace-nowrap">' +
                        '<div class="flex items-center gap-2">' +
                            '<button onclick="editAccountModal(\'' + account.id + '\')" class="text-blue-600 hover:text-blue-700" title="권한 변경">' +
                                '<i class="fas fa-edit w-4 h-4"></i> 수정' +
                            '</button>' +
                        '</div>' +
                    '</td>' +
                '</tr>';
            }).join('');

            renderPagination(totalPages, filtered.length);
        }
        
        function clearAccountTable() {
            var tbody = document.getElementById('accountTableBody');
            tbody.innerHTML = '<tr><td colspan="6" class="px-6 py-8 text-center text-gray-500">조회 버튼을 눌러 계정을 검색하세요.</td></tr>';
        }

        function toggleActive(accountId) {
            if (!confirm("계정 상태를 변경하시겠습니까?")) {
                return;
            }

            const params = new URLSearchParams();
            params.append("action", "statusToggle");
            params.append("accountId", accountId);

            fetch("<%= request.getContextPath() %>/hq/hr/main", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                },
                body: params.toString()
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error();
                }

                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    const account = accounts.find(function(a) {
                        return String(a.id) === String(accountId);
                    });

                    if (account) {
                        account.status = account.status === "ACTIVE" ? "INACTIVE" : "ACTIVE";
                        account.isActive = account.status === "ACTIVE";
                    }

                    renderAccounts();

                    if (typeof updateStats === "function") {
                        updateStats();
                    }

                    alert("계정 상태가 변경되었습니다.");
                } else {
                    alert(data.message || "계정 상태를 변경하지 못했습니다.");
                }
            })
            .catch(function() {
                alert("계정 상태 변경 중 문제가 발생했습니다. 잠시 후 다시 시도해 주세요.");
            });
        }
        
        function updateStats() {
            var total = accounts.length;
            var active = accounts.filter(function(account) {
                return account.status === "ACTIVE";
            }).length;
            var inactive = total - active;

            document.getElementById("totalCount").textContent = total;
            document.getElementById("activeCount").textContent = active;
            document.getElementById("inactiveCount").textContent = inactive;
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
            const empNo = document.getElementById("empNo");
            const branchCode = document.getElementById("branchCode");
            const roleId = document.getElementById("roleId");
            const loginId = document.getElementById("loginId");
            const password = document.getElementById("password");
            const status = document.getElementById("isActiveAdd");

            const params = new URLSearchParams();
            params.append("action", "add");
            params.append("empNo", empNo.value);
            params.append("branchCode", branchCode.value);
            params.append("roleId", roleId.value);
            params.append("loginId", loginId.value);
            params.append("password", password.value);
            params.append("status", status.checked ? "ACTIVE" : "INACTIVE");

            console.log(params.toString());

            fetch("<%= request.getContextPath() %>/hq/hr/main", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                },
                body: params.toString()
            })
            .then(response => response.text())
            .then(text => {
                console.log("서버 응답:", text);

                const data = JSON.parse(text);

                if (data.success) {
                    alert("계정이 추가되었습니다.");
                    closeAddModal();
                    applyFilters();
                } else {
                    alert(data.message);
                }
            })
            .catch(error => {
                console.error(error);
                location.href = "<%= request.getContextPath() %>/common/500.jsp";
            });
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
                document.getElementById('editRoleId').value = selectedAccount.roleId;
                document.getElementById('editStatus').value = selectedAccount.status;
                document.getElementById('editBranchCode').value = selectedAccount.branchCode;
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
            	const roleId = document.getElementById("editRoleId").value;
                const branchCode = document.getElementById("editBranchCode").value;
                const status = document.getElementById("editStatus").value;

                if (!roleId) {
                    alert("역할을 선택해주세요.");
                    return;
                }

                if (!branchCode) {
                    alert("소속 매장을 선택해주세요.");
                    return;
                }
                
                if (!status) {
                    alert("상태를 선택해주세요.");
                    return;
                }

                const params = new URLSearchParams();
                params.append("action", "update");
                params.append("accountId", selectedAccount.id);
                params.append("roleId", roleId);
                params.append("branchCode", branchCode);
                params.append("status", status);

                fetch("<%= request.getContextPath() %>/hq/hr/main", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                    },
                    body: params.toString()
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        selectedAccount.roleId = roleId;
                        selectedAccount.branchCode = branchCode;
                        selectedAccount.status = status;
                        selectedAccount.isActive = status === "ACTIVE";
                        selectedAccount.role = document.getElementById("editRoleId").selectedOptions[0].text;
                        selectedAccount.branch = document.getElementById("editBranchCode").selectedOptions[0].text;

                        closeEditModal();
                        renderAccounts();
                        updateStats();
                        
                        alert("계정 정보가 수정되었습니다.");
                    } else {
                        alert(data.message || "계정 수정에 실패했습니다.");
                    }
                })
                .catch(error => {
                    console.error(error);
                    location.href = "<%= request.getContextPath() %>/common/500.jsp";
                });
            }
        }
        
        // 페이징 처리
		function renderPagination(totalPages, totalItems) {
		    var paginationContainer = document.getElementById('paginationContainer');
		    var paginationInfo = document.getElementById('paginationInfo');
		    var pageButtons = document.getElementById('pageButtons');
		
		    if (!paginationContainer || !paginationInfo || !pageButtons) {
		        console.error('페이지네이션 HTML 요소를 찾을 수 없습니다.');
		        return;
		    }
		
		    if (totalPages <= 1 || totalItems <= pageSize) {
		        paginationContainer.classList.add('hidden');
		        paginationInfo.textContent = '';
		        pageButtons.innerHTML = '';
		        return;
		    }
		
		    paginationContainer.classList.remove('hidden');
		
		    var startIndex = (currentPage - 1) * pageSize;
		    var endIndex = Math.min(startIndex + pageSize, totalItems);
		
		    paginationInfo.textContent =
		        (startIndex + 1) + '-' + endIndex + ' / ' + totalItems + '개';
		
		    var base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
		    var active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
		    var arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';
		
		    var blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
		    var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);
		
		    var html = '';
		
		    html += '<button type="button" class="' + arrow + '" onclick="changePage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-angles-left text-xs"></i>';
		    html += '</button>';
		
		    var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
		    html += '<button type="button" class="' + arrow + '" onclick="changePage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-chevron-left text-xs"></i>';
		    html += '</button>';
		
		    for (var i = blockStart; i <= blockEnd; i++) {
		        html += '<button type="button" class="' + (i === currentPage ? active : base) + '" onclick="changePage(' + i + ')">';
		        html += i;
		        html += '</button>';
		    }
		
		    var nextBlockPage = Math.min(totalPages, blockEnd + 1);
		    html += '<button type="button" class="' + arrow + '" onclick="changePage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-chevron-right text-xs"></i>';
		    html += '</button>';
		
		    html += '<button type="button" class="' + arrow + '" onclick="changePage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
		    html += '<i class="fas fa-angles-right text-xs"></i>';
		    html += '</button>';
		
		    pageButtons.innerHTML = html;
		}
        
		function changePage(page) {
		    var searchTerm = document.getElementById('searchInput').value.trim().toLowerCase();
		    var selectedBranchName = document.getElementById("branchNameSelect").value.trim();

		    var filtered = accounts.filter(function(account) {
		        var name = String(account.name || "").toLowerCase();
		        var username = String(account.username || "").toLowerCase();
		        var branch = String(account.branch || "").toLowerCase();
		        var role = String(account.role || "").toLowerCase();

		        var matchesSearch = searchTerm === "" ||
		            name.includes(searchTerm) ||
		            username.includes(searchTerm) ||
		            branch.includes(searchTerm) ||
		            role.includes(searchTerm);

		        var matchesBranch = selectedBranchName === "" ||
		            account.branch === selectedBranchName;

		        return matchesSearch && matchesBranch;
		    });

		    var totalPages = Math.ceil(filtered.length / pageSize);

		    if (page < 1 || page > totalPages) {
		        return;
		    }

		    currentPage = page;
		    renderAccounts();

		    window.scrollTo({
		        top: 0,
		        behavior: 'smooth'
		    });
		}

        function applyFilters() {
            currentPage = 1;
            renderAccounts();
        }
    </script>
</body>
</html>

