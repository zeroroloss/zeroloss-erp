<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dto.AccountDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.NotificationDTO" %>
<%@ page import="service.NotificationService" %>
<%@ page import="service.NotificationServiceImpl" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
if (loginUser == null) {
    response.sendRedirect(request.getContextPath() + "/common/login");
    return;
}
%>
<%
    Integer sidebarAccountId = null;

    if (session != null && session.getAttribute("accountId") != null) {
        sidebarAccountId = (Integer) session.getAttribute("accountId");
    }

    NotificationService sidebarNotifService = new NotificationServiceImpl();

    List<NotificationDTO> headerNotificationList = null;
    int unreadCount = 0;

    if (sidebarAccountId != null) {
        headerNotificationList = sidebarNotifService.searchNotificationList(sidebarAccountId);

        if (headerNotificationList != null) {
            for (NotificationDTO notif : headerNotificationList) {
                if (notif.getIsRead() == null || notif.getIsRead() == 0) {
                    unreadCount++;
                }
            }
        }
    }
%>
<%
String uri = request.getRequestURI();

boolean homeActive = uri.endsWith("/branch/main/home.jsp");

boolean stockGroup = uri.contains("/branch/stock/");
boolean stockStatusActive = uri.endsWith("/branch/stock/stock.jsp");
boolean stockChangeActive = uri.contains("/branch/stock/stock_change.jsp");
boolean safetyStockActive = uri.contains("/branch/stock/safety_stock.jsp");

boolean inboundGroup = uri.contains("/branch/inbound/");
boolean inboundHistoryActive = uri.contains("/branch/inbound/history.jsp");
boolean inboundProcessingActive = uri.contains("/branch/inbound/processing.jsp");

boolean orderGroup = uri.contains("/branch/place_order/");
boolean orderHistoryActive = uri.contains("/branch/place_order/history");
boolean orderDraftCreateActive = uri.contains("/branch/place_order/draft");

boolean salesGroup = uri.contains("/branch/sales/");
boolean salesDetailActive = uri.contains("/branch/sales/detail") || uri.contains("/branch/sales/branch_sales/sales-detail.jsp");
boolean salesRankActive = uri.contains("/branch/sales/ranking") || uri.contains("/branch/sales/sales_rank/menu_rank.jsp");

boolean swapActive = uri.contains("/branch/swap/");
boolean recipeActive = uri.endsWith("/branch/recipe/management") || uri.endsWith("/branch/recipe/recipe-management.jsp");

boolean hrGroup = uri.contains("/branch/hr/");
boolean hrEmployeeActive = uri.contains("/branch/hr/employee/");
boolean hrScheduleActive = uri.contains("/branch/hr/schedule/");

boolean supportGroup = uri.contains("/branch/support/");
boolean noticeActive = uri.contains("/branch/support/notices") || uri.contains("/branch/support/branch-notices.jsp");
boolean inquiryActive = uri.contains("/branch/support/inquiries") || uri.contains("/branch/support/branch-inquiries.jsp");
%>
<div id="sidebarBackdrop" class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden lg:hidden"></div>

<aside id="sidebar" class="fixed top-0 left-0 h-screen w-72 bg-white border-r border-gray-200 z-30 transform -translate-x-full transition-transform duration-200 lg:translate-x-0 flex flex-col">
    <div class="p-6 border-b border-gray-200">
        <div class="flex items-center gap-3">
            <div class="w-12 h-12 rounded-full flex items-center justify-center overflow-hidden border-2 border-[#00853D]">
			    <img src="<%= request.getContextPath() %>/upload/images/logo.png" alt="로고" class="w-full h-full object-cover">
			</div>
            <%
			    String titleText = "Zero Loss";
			    String subText = "ERP";
			
			    if (loginUser != null) {
			        String userName = loginUser.getUserName() != null ? loginUser.getUserName() : "";
			        String roleName = loginUser.getRoleName() != null ? loginUser.getRoleName() : "";
			        String branchName = loginUser.getBranchName() != null ? loginUser.getBranchName() : "";
			
			        titleText = userName + " " + roleName;
			        subText = loginUser.getHqId() != null ? "본사" : branchName;
			    }
			%>
			<div>
			    <h1 class="text-sm font-bold text-gray-900"><%= titleText %></h1>
			    <p class="text-xs text-gray-500"><%= subText %></p>
			</div>
	        <div class="ml-auto relative">
			    <button onclick="openNotificationModal()" class="p-2 rounded-lg hover:bg-gray-100 relative">
			        <i class="fas fa-bell w-5 h-5"></i>
			
			        <% if (unreadCount > 0) { %>
			            <span id="sidebarNotifBadge" class="absolute -top-1 -right-1 min-w-[18px] h-[18px] px-1 bg-red-500 text-white text-[10px] rounded-full flex items-center justify-center">
			                <%= unreadCount > 99 ? "99+" : unreadCount %>
			            </span>
			        <% } %>
			    </button>
			
			    <!-- Notification Dropdown -->
			    <div id="notificationModal"
			         class="hidden absolute top-12 left-0 w-96 bg-white rounded-xl shadow-xl border border-gray-200 z-50 overflow-hidden">
			
			        <!-- Header -->
			        <div class="px-5 py-4 border-b border-gray-200 flex items-center justify-between">
			            <div>
			                <h3 class="text-lg font-bold text-gray-900">알림</h3>
			                <p class="text-sm text-gray-500">
			                    읽지 않은 알림
			                    <span id="sidebarUnreadCount" class="font-semibold text-[#00853D]"><%= unreadCount %></span>개
			                </p>
			            </div>
			
			            <button type="button"
			                    onclick="closeNotificationModal()"
			                    class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-gray-100 text-gray-500">
			                <i class="fas fa-times"></i>
			            </button>
			        </div>
			
			        <!-- Body -->
			        <div id="notificationScrollBody" class="max-h-[420px] overflow-y-auto cursor-grab active:cursor-grabbing select-none">
			            <% if (unreadCount == 0) { %>
			                <div class="px-5 py-10 text-center text-gray-500">
			                    <div class="w-12 h-12 mx-auto mb-3 rounded-full bg-gray-100 flex items-center justify-center">
			                        <i class="fas fa-bell-slash text-gray-400"></i>
			                    </div>
			                    <p class="text-sm">새로운 알림이 없습니다.</p>
			                </div>
			            <% } else { %>
			                <div class="divide-y divide-gray-100">
			                	<%
					                for (NotificationDTO notif : headerNotificationList) {
					                    if (notif.getIsRead() != null && notif.getIsRead() == 1) {
					                        continue;
					                    }
					
					                    String iconClass = "fa-bell";
					                    String iconBg = "bg-[#00853D]/10";
					                    String iconColor = "text-[#00853D]";
					
					                    if ("INVENTORY".equals(notif.getCategory())) {
					                        iconClass = "fa-boxes-stacked";
					                        iconBg = "bg-orange-100";
					                        iconColor = "text-orange-600";
					                    } else if ("ORDER".equals(notif.getCategory())) {
					                        iconClass = "fa-truck";
					                        iconBg = "bg-blue-100";
					                        iconColor = "text-blue-600";
					                    } else if ("SWAP".equals(notif.getCategory())) {
					                        iconClass = "fa-right-left";
					                        iconBg = "bg-green-100";
					                        iconColor = "text-green-600";
					                    } else if ("BOARD".equals(notif.getCategory())) {
					                        iconClass = "fa-comments";
					                        iconBg = "bg-purple-100";
					                        iconColor = "text-purple-600";
					                    } else if ("SYSTEM".equals(notif.getCategory())) {
					                        iconClass = "fa-gear";
					                        iconBg = "bg-gray-100";
					                        iconColor = "text-gray-600";
					                    }
					            %>
			                
					            <div class="px-5 py-4 hover:bg-gray-50 cursor-pointer sidebar-notification-item"
					                 data-notification-id="<%= notif.getNotificationId() %>"
					                 onclick="goNotificationTargetAndRead('<%= notif.getTargetType() %>', <%= notif.getTargetId() == null ? 0 : notif.getTargetId() %>, <%= notif.getNotificationId() %>)">
					
					                <div class="flex gap-3">
					                    <div class="w-9 h-9 rounded-full <%= iconBg %> flex items-center justify-center flex-shrink-0">
					                        <i class="fas <%= iconClass %> <%= iconColor %> text-sm"></i>
					                    </div>
					
					                    <div class="flex-1 min-w-0">
					                        <div class="flex items-center justify-between gap-2">
					                            <p class="text-sm font-semibold text-gray-900 truncate">
					                                <%= notif.getTitle() %>
					                            </p>
					                            <span class="w-2 h-2 bg-red-500 rounded-full flex-shrink-0"></span>
					                        </div>
					
					                        <p class="text-sm text-gray-600 mt-1 line-clamp-2">
					                            <%= notif.getMessage() %>
					                        </p>
					
					                        <p class="text-xs text-gray-400 mt-2">
					                            <%= notif.getCreatedAt() %>
					                        </p>
					                    </div>
					                </div>
					            </div>
					
					            <%
					                }
					            %>
					        </div>
					    <% } %>
					</div>
			
			        <!-- Footer -->
			        <div class="px-5 py-3 border-t border-gray-200 bg-gray-50">
			            <a href="<%= request.getContextPath() %>/branch/common/notification"
			               class="w-full inline-flex items-center justify-center gap-2 text-sm font-semibold text-[#00853D] hover:text-[#006B2F]">
			                전체 알림 보기
			                <i class="fas fa-arrow-right text-xs"></i>
			            </a>
			        </div>
			    </div>
			</div>
   		</div>
    </div>

    <nav class="flex-1 p-4 space-y-1 overflow-y-auto">
        <a href="<%= request.getContextPath() %>/branch/main/home" class="flex items-center gap-3 px-3 py-2.5 rounded-lg <%= homeActive ? "bg-[#00853D] text-white font-medium" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <i class="fas fa-home w-5 h-5"></i>
            <span class="text-sm">홈</span>
        </a>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= stockGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-warehouse w-5 h-5"></i>
                <span class="text-sm">재고관리</span>
            </div>
            <i class="fas <%= stockGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= stockGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= request.getContextPath() %>/branch/stock" class="block px-4 py-2 rounded-lg text-sm <%= stockStatusActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">재고 현황</a>
            <a href="<%= request.getContextPath() %>/branch/stock_change" class="block px-4 py-2 rounded-lg text-sm <%= stockChangeActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">재고 변동</a>
        	<a href="<%= request.getContextPath() %>/branch/stock/safety_stock" class="block px-4 py-2 rounded-lg text-sm <%= safetyStockActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">품목별 안전재고 설정</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= inboundGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-box-open w-5 h-5"></i>
                <span class="text-sm">입고 관리</span>
            </div>
            <i class="fas <%= inboundGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= inboundGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= request.getContextPath() %>/branch/inbound/history" class="block px-4 py-2 rounded-lg text-sm <%= inboundHistoryActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">입고 내역</a>
            <a href="<%= request.getContextPath() %>/branch/inbound/processing" class="block px-4 py-2 rounded-lg text-sm <%= inboundProcessingActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">입고 처리</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= orderGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-file-invoice w-5 h-5"></i>
                <span class="text-sm">발주 관리</span>
            </div>
            <i class="fas <%= orderGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= orderGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= request.getContextPath() %>/branch/place_order/history" class="block px-4 py-2 rounded-lg text-sm <%= orderHistoryActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">발주 내역</a>
            <a href="<%= request.getContextPath() %>/branch/place_order/draft" class="block px-4 py-2 rounded-lg text-sm <%= orderDraftCreateActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">발주서 작성</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= salesGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-arrow-trend-up w-5 h-5"></i>
                <span class="text-sm">매출 관리</span>
            </div>
            <i class="fas <%= salesGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= salesGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= request.getContextPath() %>/branch/sales/detail" class="block px-4 py-2 rounded-lg text-sm <%= salesDetailActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">매출 조회</a>
            <a href="<%= request.getContextPath() %>/branch/sales/ranking" class="block px-4 py-2 rounded-lg text-sm <%= salesRankActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">매출 순위</a>
        </div>
        
        <a href="<%= request.getContextPath() %>/branch/swap/main" class="flex items-center gap-3 px-3 py-2.5 rounded-lg <%= swapActive ? "bg-[#00853D] text-white font-medium" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <i class="fas fa-right-left w-5 h-5"></i>
            <span class="text-sm">재고 교환/요청</span>
        </a>

        <a href="<%= request.getContextPath() %>/branch/recipe/management" class="flex items-center gap-3 px-3 py-2.5 rounded-lg <%= recipeActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %> transition-colors">
            <i class="fas fa-book w-5 h-5"></i>
            <span class="text-sm">레시피 관리</span>
        </a>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= hrGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-users w-5 h-5"></i>
                <span class="text-sm">직원관리</span>
            </div>
            <i class="fas <%= hrGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= hrGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= request.getContextPath() %>/branch/hr/main" class="block px-4 py-2 rounded-lg text-sm <%= hrEmployeeActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">직원 정보 조회</a>
            <a href="<%= request.getContextPath() %>/branch/hr/branchschedule" class="block px-4 py-2 rounded-lg text-sm <%= hrScheduleActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">일정관리</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= supportGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-store w-5 h-5"></i>
                <span class="text-sm">운영지원</span>
            </div>
            <i class="fas <%= supportGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= supportGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= request.getContextPath() %>/branch/support/notices" class="block px-4 py-2 rounded-lg text-sm <%= noticeActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">공지사항</a>
            <a href="<%= request.getContextPath() %>/branch/support/inquiries" class="block px-4 py-2 rounded-lg text-sm <%= inquiryActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">문의사항</a>
        </div>
    </nav>
    <!-- 로그아웃 -->
    <div class="mt-auto p-4 border-t border-gray-200 bg-white">
        <form action="<%= request.getContextPath() %>/logout" method="post">
            <button
                type="submit"
                class="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 transition-all">
                <i class="fas fa-sign-out-alt"></i>
                <span>로그아웃</span>
            </button>
        </form>
    </div>
</aside>

<script>
function toggleMenu(button) {
    const submenu = button.nextElementSibling;
    if (!submenu) {
        return;
    }

    submenu.classList.toggle("hidden");

    const icon = button.querySelector(".fa-chevron-right, .fa-chevron-down");
    if (icon) {
        if (submenu.classList.contains("hidden")) {
            icon.classList.remove("fa-chevron-down");
            icon.classList.add("fa-chevron-right");
        } else {
            icon.classList.remove("fa-chevron-right");
            icon.classList.add("fa-chevron-down");
        }
    }
}

function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    const backdrop = document.getElementById("sidebarBackdrop");

    if (!sidebar || !backdrop) {
        return;
    }

    sidebar.classList.toggle("-translate-x-full");
    backdrop.classList.toggle("hidden");
}

document.addEventListener("DOMContentLoaded", function() {
    const backdrop = document.getElementById("sidebarBackdrop");
    if (!backdrop) {
        return;
    }

    backdrop.addEventListener("click", function() {
        const sidebar = document.getElementById("sidebar");
        if (!sidebar) {
            return;
        }

        sidebar.classList.add("-translate-x-full");
        backdrop.classList.add("hidden");
    });
});

//알림 모달
function openNotificationModal() {
    document.getElementById('notificationModal').classList.remove('hidden');
}

function closeNotificationModal() {
    document.getElementById('notificationModal').classList.add('hidden');
}

document.addEventListener('click', function(e) {
    var modal = document.getElementById('notificationModal');

    if (!modal || modal.classList.contains('hidden')) {
        return;
    }

    var buttonArea = modal.closest('.relative');

    if (!buttonArea) {
        return;
    }

    if (!buttonArea.contains(e.target)) {
        modal.classList.add('hidden');
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeNotificationModal();
    }
});

// 이동 주소 매핑
function getNotificationTargetUrl(targetType, targetId) {
    var ctx = '<%= request.getContextPath() %>';

    if (targetType === 'BRANCH_EXPIRY') {
    	return ctx + '/branch/stock';
    } else if (targetType === 'BRANCH_INVENTORY') {
    	return ctx + '/branch/stock';
    } else if (targetType === 'BRANCH_SAFETY') {
    	return ctx + '/branch/stock';
    } else if (targetType === 'ORDER') {
    	return ctx + '/branch/place_order/history';
    } else if (targetType === 'INBOUND') {
    	return ctx + '/branch/inbound/processing';
    } else if (targetType === 'SWAP') {
        return ctx + '/branch/swap/main?tab=check_stock';
    } else if (targetType === 'INQUIRY') {
    	return ctx + '/branch/support/inquiries';
    } else if (targetType === 'NOTICE') {
    	return ctx + '/branch/support/notices';
    } else if (targetType === 'RECIPE') {
    	return ctx + '/branch/recipe/management';
    } 
    return ctx + '/branch/common/notification';
}

// 읽음 처리
function getNotificationPostUrl() {
    var ctx = '<%= request.getContextPath() %>';
    var uri = '<%= request.getRequestURI() %>';

    if (uri.indexOf('/hq/') !== -1) {
        return ctx + '/hq/common/notification';
    }

    return ctx + '/branch/common/notification';
}

async function goNotificationTargetAndRead(targetType, targetId, notificationId) {
    var url = getNotificationTargetUrl(targetType, targetId);

    try {
        var response = await fetch(getNotificationPostUrl() + '?action=read&id=' + notificationId, {
            method: 'POST'
        });

        if (!response.ok) {
            throw new Error('읽음 처리 실패');
        }

        if (typeof updateSidebarNotificationAfterRead === 'function') {
            updateSidebarNotificationAfterRead(notificationId);
        }

    } catch (error) {
        console.error('알림 읽음 처리 실패:', error);
    }

    location.href = url;
}

// 사이드바 목록 갱신
function updateSidebarNotificationAfterRead(notificationId) {
    var item = document.querySelector('.sidebar-notification-item[data-notification-id="' + notificationId + '"]');

    if (item) {
        item.remove();
    }

    var countSpan = document.getElementById('sidebarUnreadCount');
    var badge = document.getElementById('sidebarNotifBadge');

    var currentCount = 0;

    if (countSpan) {
        currentCount = parseInt(countSpan.innerText, 10);

        if (isNaN(currentCount)) {
            currentCount = 0;
        }

        currentCount = Math.max(currentCount - 1, 0);
        countSpan.innerText = currentCount;
    }

    if (badge) {
        if (currentCount <= 0) {
            badge.remove();
        } else {
            badge.innerText = currentCount > 99 ? '99+' : currentCount;
        }
    }

    var list = document.querySelector('#notificationScrollBody .divide-y');

    if (list && list.children.length === 0) {
        document.getElementById('notificationScrollBody').innerHTML =
            '<div class="px-5 py-10 text-center text-gray-500">' +
                '<div class="w-12 h-12 mx-auto mb-3 rounded-full bg-gray-100 flex items-center justify-center">' +
                    '<i class="fas fa-bell-slash text-gray-400"></i>' +
                '</div>' +
                '<p class="text-sm">새로운 알림이 없습니다.</p>' +
            '</div>';
    }
}

// 전체 읽음 처리
function clearSidebarNotifications() {
    var countSpan = document.getElementById('sidebarUnreadCount');
    var badge = document.getElementById('sidebarNotifBadge');
    var scrollBody = document.getElementById('notificationScrollBody');

    if (countSpan) {
        countSpan.innerText = '0';
    }

    if (badge) {
        badge.remove();
    }

    if (scrollBody) {
        scrollBody.innerHTML =
            '<div class="px-5 py-10 text-center text-gray-500">' +
                '<div class="w-12 h-12 mx-auto mb-3 rounded-full bg-gray-100 flex items-center justify-center">' +
                    '<i class="fas fa-bell-slash text-gray-400"></i>' +
                '</div>' +
                '<p class="text-sm">새로운 알림이 없습니다.</p>' +
            '</div>';
    }
}
</script>
