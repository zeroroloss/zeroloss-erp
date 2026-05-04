<%@ page pageEncoding="UTF-8" %>
<%@ page import="dto.AccountDTO" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/common/login.jsp");
        return;
    }
%>
<%
    String cp = request.getContextPath();
    String uri = request.getRequestURI();

    boolean homeActive = uri.endsWith("/hq/main/home.jsp");

    boolean branchStockGroup = uri.contains("/hq/branch_stock/");
    boolean brancStockActive = uri.endsWith("/hq/branch_stock/stock.jsp");
    boolean branchStockLossActive = uri.endsWith("/hq/branch_stock/loss.jsp");

    boolean warehouseGroup = uri.contains("/hq/warehouse/");
    boolean warehouseReceiveActive = uri.endsWith("/hq/warehouse/inbound.jsp");
    boolean warehouseReleaseActive = uri.endsWith("/hq/warehouse/outbound.jsp");
    boolean warehouseStockActive = uri.endsWith("/hq/warehouse/stock.jsp");
    boolean warehouseExpiryActive = uri.endsWith("/hq/warehouse/expiry_date.jsp");

    boolean placeOrderGroup = uri.contains("/hq/place_order/");
    boolean placeOrderOverViewActive = uri.endsWith("/hq/place_order/overview.jsp");
    boolean placeOrderProcessingActive = uri.endsWith("/hq/place_order/processing.jsp");
    boolean placeOrderItemLimitActive = uri.endsWith("/hq/place_order/order_quantity_limit.jsp");

    boolean salesGroup = uri.contains("/hq/sales/");
    boolean salesDetailActive = uri.endsWith("/hq/sales/detail") || uri.endsWith("/hq/sales/sales-detail.jsp");
    boolean salesRankingActive = uri.endsWith("/hq/sales/ranking") || uri.endsWith("/hq/sales/sales-ranking.jsp");
    boolean salesHeadquartersActive = uri.endsWith("/hq/sales/headquarters") || uri.endsWith("/hq/sales/sales-headquarters.jsp");

    boolean deliveryGroup = uri.contains("/hq/delivery/");
    boolean deliveryInquiryActive = uri.endsWith("/hq/delivery/inquiry") || uri.endsWith("/hq/delivery/delivery-inquiry.jsp");
    boolean dispatchManagementActive = uri.endsWith("/hq/delivery/dispatch") || uri.endsWith("/hq/delivery/dispatch-management.jsp");
    boolean driverVehicleActive = uri.endsWith("/hq/delivery/driver-vehicle") || uri.endsWith("/hq/delivery/driver-vehicle-management.jsp");

    boolean recipeActive = uri.endsWith("/hq/recipe/management") || uri.endsWith("/hq/recipe/recipe-management.jsp");

    boolean supportGroup = uri.contains("/hq/support/");
    boolean branchSearchActive = uri.endsWith("/hq/support/branch-search.jsp");
    boolean hqNoticesActive = uri.endsWith("/hq/support/headquarters-notices.jsp");
    boolean hqInquiriesActive = uri.endsWith("/hq/support/headquarters-inquiries.jsp") || uri.endsWith("/hq/support/inquiries");

    boolean hrGroup = uri.contains("/hq/hr/");
    boolean hrInquiryActive = uri.endsWith("/hq/hr/hr-employee-inquiry.jsp");
    boolean permissionsActive = uri.endsWith("/hq/hr/permissions-account-management.jsp");
    boolean employeeScheduleActive = uri.endsWith("/hq/hr/employee-schedule-management.jsp");
%>

<div id="sidebarBackdrop" class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden lg:hidden"></div>

<aside id="sidebar" class="fixed top-0 left-0 h-screen w-72 bg-white border-r border-gray-200 z-30 transform -translate-x-full transition-transform duration-200 lg:translate-x-0 flex flex-col">
    <%
        Integer unreadCount = (Integer) request.getAttribute("unreadCount");
        if (unreadCount == null) unreadCount = 0;

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

    <div class="p-6 border-b border-gray-200">
        <div class="flex items-center gap-3">
            <div class="w-12 h-12 rounded-full flex items-center justify-center overflow-hidden border-2 border-[#00853D]">
                <img src="<%= request.getContextPath() %>/upload/images/logo.png" alt="로고" class="w-full h-full object-cover">
            </div>

            <div class="min-w-0 max-w-[140px]">
                <h1 class="text-sm font-bold text-gray-900 truncate" title="<%= titleText %>">
                    <%= titleText %>
                </h1>
                <p class="text-xs text-gray-500 truncate" title="<%= subText %>">
                    <%= subText %>
                </p>
            </div>
			<div class="ml-auto relative">
	            <button onclick="openNotificationModal()" type="button" class="ml-auto p-2 rounded-lg hover:bg-gray-100 relative flex-shrink-0">
	                <i class="fas fa-bell text-gray-700 w-5 h-5"></i>
	                <% if (unreadCount > 0) { %>
	                <span class="absolute -top-1 -right-1 min-w-[18px] h-[18px] px-1 bg-red-500 text-white text-[10px] rounded-full flex items-center justify-center">
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
			                    <span class="font-semibold text-[#00853D]"><%= unreadCount %></span>개
			                </p>
			            </div>
			
			            <button type="button"
			                    onclick="closeNotificationModal()"
			                    class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-gray-100 text-gray-500">
			                <i class="fas fa-times"></i>
			            </button>
			        </div>
			
			        <!-- Body -->
			        <div class="max-h-[420px] overflow-y-auto">
			            <% if (unreadCount == 0) { %>
			                <div class="px-5 py-10 text-center text-gray-500">
			                    <div class="w-12 h-12 mx-auto mb-3 rounded-full bg-gray-100 flex items-center justify-center">
			                        <i class="fas fa-bell-slash text-gray-400"></i>
			                    </div>
			                    <p class="text-sm">새로운 알림이 없습니다.</p>
			                </div>
			            <% } else { %>
			                <div class="divide-y divide-gray-100">
			                    <div class="px-5 py-4 hover:bg-gray-50 cursor-pointer">
			                        <div class="flex gap-3">
			                            <div class="w-9 h-9 rounded-full bg-[#00853D]/10 flex items-center justify-center flex-shrink-0">
			                                <i class="fas fa-bell text-[#00853D] text-sm"></i>
			                            </div>
			
			                            <div class="flex-1 min-w-0">
			                                <div class="flex items-center justify-between gap-2">
			                                    <p class="text-sm font-semibold text-gray-900 truncate">새 알림이 도착했습니다</p>
			                                    <span class="w-2 h-2 bg-red-500 rounded-full flex-shrink-0"></span>
			                                </div>
			                                <p class="text-sm text-gray-600 mt-1 line-clamp-2">
			                                    확인이 필요한 알림 내용입니다.
			                                </p>
			                                <p class="text-xs text-gray-400 mt-2">방금 전</p>
			                            </div>
			                        </div>
			                    </div>
			                </div>
			            <% } %>
			        </div>
			
			        <!-- Footer -->
			        <div class="px-5 py-3 border-t border-gray-200 bg-gray-50">
			            <a href="<%= request.getContextPath() %>/hq/common/notification.jsp"
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
        <a href="<%= cp %>/hq/main/home" class="flex items-center gap-3 px-3 py-2.5 rounded-lg <%= homeActive ? "bg-[#00853D] text-white font-medium" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <i class="fas fa-home w-5 h-5"></i>
            <span class="text-sm">홈</span>
        </a>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= branchStockGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-warehouse w-5 h-5"></i>
                <span class="text-sm">지점 재고 현황</span>
            </div>
            <i class="fas <%= branchStockGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= branchStockGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= cp %>/hq/branch_stock/stock" class="block px-4 py-2 rounded-lg text-sm <%= brancStockActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">지점 재고 현황</a>
            <a href="<%= cp %>/hq/branch_stock/loss" class="block px-4 py-2 rounded-lg text-sm <%= branchStockLossActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">지점 재고 리스크 현황</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= warehouseGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-box-open w-5 h-5"></i>
                <span class="text-sm">물류창고 관리</span>
            </div>
            <i class="fas <%= warehouseGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= warehouseGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= cp %>/hq/warehouse/inbound" class="block px-4 py-2 rounded-lg text-sm <%= warehouseReceiveActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">본사 물류창고 입고</a>
            <a href="<%= cp %>/hq/warehouse/outbound" class="block px-4 py-2 rounded-lg text-sm <%= warehouseReleaseActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">본사 물류창고 출고 내역</a>
            <a href="<%= cp %>/hq/warehouse/stock" class="block px-4 py-2 rounded-lg text-sm <%= warehouseStockActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">본사 물류창고 재고 조회</a>
            <a href="<%= cp %>/hq/warehouse/expiry_date" class="block px-4 py-2 rounded-lg text-sm <%= warehouseExpiryActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">유통기한 조회 및 폐기</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= placeOrderGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-file-invoice w-5 h-5"></i>
                <span class="text-sm">지점 발주 관리</span>
            </div>
            <i class="fas <%= placeOrderGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= placeOrderGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= cp %>/hq/place_order/overview" class="block px-4 py-2 rounded-lg text-sm <%= placeOrderOverViewActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">지점 발주 요청 조회</a>
            <a href="<%= cp %>/hq/place_order/processing" class="block px-4 py-2 rounded-lg text-sm <%= placeOrderProcessingActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">지점 발주 요청 처리</a>
            <a href="<%= cp %>/hq/place_order/order_quantity_limit" class="block px-4 py-2 rounded-lg text-sm <%= placeOrderItemLimitActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">품목별 최소/최대 발주 수량</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= salesGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-arrow-trend-up w-5 h-5"></i>
                <span class="text-sm">매출 관리</span>
            </div>
            <i class="fas <%= salesGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= salesGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= cp %>/hq/sales/headquarters" class="block px-4 py-2 rounded-lg text-sm <%= salesHeadquartersActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">본사 매출 조회</a>
            <a href="<%= cp %>/hq/sales/detail" class="block px-4 py-2 rounded-lg text-sm <%= salesDetailActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">직영점 매출 조회</a>
            <a href="<%= cp %>/hq/sales/ranking" class="block px-4 py-2 rounded-lg text-sm <%= salesRankingActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">전사 매출 랭킹</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= deliveryGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-truck w-5 h-5"></i>
                <span class="text-sm">배송 관리</span>
            </div>
            <i class="fas <%= deliveryGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= deliveryGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= cp %>/hq/delivery/inquiry" class="block px-4 py-2 rounded-lg text-sm <%= deliveryInquiryActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">배송 조회</a>
            <a href="<%= cp %>/hq/delivery/dispatch" class="block px-4 py-2 rounded-lg text-sm <%= dispatchManagementActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">배차 관리</a>
            <a href="<%= cp %>/hq/delivery/driver-vehicle" class="block px-4 py-2 rounded-lg text-sm <%= driverVehicleActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">기사/차량 관리</a>
        </div>

        <a href="<%= cp %>/hq/recipe/management" class="flex items-center gap-3 px-3 py-2.5 rounded-lg <%= recipeActive ? "bg-[#00853D] text-white font-medium" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <i class="fas fa-book w-5 h-5"></i>
            <span class="text-sm">레시피 관리</span>
        </a>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= supportGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-store w-5 h-5"></i>
                <span class="text-sm">운영지원</span>
            </div>
            <i class="fas <%= supportGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= supportGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= cp %>/hq/support/branch-search.jsp" class="block px-4 py-2 rounded-lg text-sm <%= branchSearchActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">직영점 관리</a>
            <a href="<%= cp %>/hq/support/headquarters-notices.jsp" class="block px-4 py-2 rounded-lg text-sm <%= hqNoticesActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">공지사항</a>
            <a href="<%= cp %>/hq/support/inquiries" class="block px-4 py-2 rounded-lg text-sm <%= hqInquiriesActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">문의사항</a>
        </div>

        <button onclick="toggleMenu(this)" class="w-full flex items-center justify-between px-3 py-2.5 rounded-lg <%= hrGroup ? "bg-gray-100 text-gray-700" : "text-gray-700 hover:bg-gray-100" %> transition-colors">
            <div class="flex items-center gap-3">
                <i class="fas fa-users w-5 h-5"></i>
                <span class="text-sm">인사 및 권한 관리</span>
            </div>
            <i class="fas <%= hrGroup ? "fa-chevron-down" : "fa-chevron-right" %> w-4 h-4"></i>
        </button>
        <div class="submenu <%= hrGroup ? "" : "hidden" %> ml-4 mt-1 space-y-1">
            <a href="<%= cp %>/hq/hr/employee" class="block px-4 py-2 rounded-lg text-sm <%= hrInquiryActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">본사/지점 직원 통합 조회</a>
            <a href="<%= cp %>/hq/hr/main" class="block px-4 py-2 rounded-lg text-sm <%= permissionsActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">계정/권한 관리</a>
            <a href="<%= cp %>/hq/hr/hqschedule" class="block px-4 py-2 rounded-lg text-sm <%= employeeScheduleActive ? "bg-[#00853D] text-white font-medium" : "text-gray-600 hover:bg-gray-100" %>">직원 일정 관리</a>
        </div>
    </nav>
    <div class="mt-auto p-4 border-t border-gray-200 bg-white">
        <form action="${pageContext.request.contextPath}/logout" method="post">
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
        const icon = button.querySelector('.fas.fa-chevron-right, .fas.fa-chevron-down');

        if (submenu.classList.contains('hidden')) {
            submenu.classList.remove('hidden');
            icon.classList.remove('fa-chevron-right');
            icon.classList.add('fa-chevron-down');
        } else {
            submenu.classList.add('hidden');
            icon.classList.remove('fa-chevron-down');
            icon.classList.add('fa-chevron-right');
        }
    }

    document.addEventListener('DOMContentLoaded', function () {
        const sidebar = document.getElementById('sidebar');
        const backdrop = document.getElementById('sidebarBackdrop');
        const menuToggleButton = document.getElementById('menu-toggle-button'); // Topbar에 있을 것으로 예상되는 버튼 ID

        if (menuToggleButton) {
            menuToggleButton.addEventListener('click', function () {
                sidebar.classList.toggle('-translate-x-full');
                backdrop.classList.toggle('hidden');
            });
        }

        if (backdrop) {
            backdrop.addEventListener('click', function () {
                sidebar.classList.add('-translate-x-full');
                backdrop.classList.add('hidden');
            });
        }
    });
    
    // 알림 모달
    function openNotificationModal() {
	    document.getElementById('notificationModal').classList.remove('hidden');
	}
	
	function closeNotificationModal() {
	    document.getElementById('notificationModal').classList.add('hidden');
	}
	
	document.addEventListener('click', function(e) {
	    var modal = document.getElementById('notificationModal');
	    var buttonArea = modal.closest('.relative');
	
	    if (!buttonArea.contains(e.target)) {
	        modal.classList.add('hidden');
	    }
	});
	
	document.addEventListener('keydown', function(e) {
	    if (e.key === 'Escape') {
	        closeNotificationModal();
	    }
	});
</script>