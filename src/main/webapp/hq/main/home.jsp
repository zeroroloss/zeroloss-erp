<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.text.NumberFormat, java.util.Locale" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar {
            transform: translateX(0);
        }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/hq/common/sidebar.jsp" %>

	<!-- 메인 콘텐츠 -->
    <div class="lg:pl-72">
            
        <!-- 페이지 콘텐츠 -->
        <main class="p-6">
            <!-- 메인 컨테이너 -->
            <div class="space-y-6">
        
		        <!-- 페이지 헤더 -->
		        <div class="bg-gradient-to-r from-[#00853D] to-[#00A94F] rounded-xl p-4 text-white shadow-lg">
		            <div class="flex items-center gap-3">
		                <div>
		                    <h2 class="text-3xl font-bold">ZERO LOSS 본사 관리 시스템</h2>
		                    <p class="text-white/90 mt-1">전국 직영점을 통합 관리하는 본사 관리자 포털에 오신 것을 환영합니다</p>
		                </div>
		            </div>
		        </div>
		
		        <!-- 빠른 통계 -->
				<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
				    <!-- 통계 카드 1: 전체 직영점 -->
				    <div class="bg-white rounded-xl border border-[#00853D]/10 p-4 hover:border-[#00853D]/30 transition-all shadow-sm hover:shadow-md">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#00853D] text-white flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-store text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				                <p class="text-xl font-bold text-gray-900 leading-tight" id="totalBranch">${totalBranch - 1}개</p>
				                <p class="text-sm text-gray-600 mt-0.5 ">전체 직영점</p>
				            </div>
				        </div>
				    </div>
				
				    <!-- 통계 카드 2: 전사 매출 -->
				    <div class="bg-white rounded-xl border border-[#00853D]/10 p-4 hover:border-[#00853D]/30 transition-all shadow-sm hover:shadow-md">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#FFD100] text-[#00853D] flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-arrow-trend-up text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				            	<%
								    Object monthlySalesObj = request.getAttribute("monthlySales");
								    long monthlySales = 0;
								    if (monthlySalesObj instanceof Number) {
								        monthlySales = ((Number) monthlySalesObj).longValue();
								    }
								    NumberFormat nf = NumberFormat.getInstance(Locale.KOREA);
								%>
				                <p class="text-lg font-bold text-gray-900 leading-tight">₩<%= nf.format(monthlySales) %></p>
				                <p class="text-sm text-gray-600 mt-0.5">전사 매출 (월)</p>
				            </div>
				        </div>
				    </div>
				
				    <!-- 통계 카드 3: 총 재고 가치 -->
				    <div class="bg-white rounded-xl border border-[#00853D]/10 p-4 hover:border-[#00853D]/30 transition-all shadow-sm hover:shadow-md">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#006B2F] text-white flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-file-invoice text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				                <p class="text-lg font-bold text-gray-900 leading-tight">${totalPending }개</p>
				                <p class="text-sm text-gray-600 mt-0.5">발주 요청 수</p>
				            </div>
				        </div>
				    </div>
				
				    <!-- 통계 카드 4: 총 직원 수 -->
				    <div class="bg-white rounded-xl border border-[#00853D]/10 p-4 hover:border-[#00853D]/30 transition-all shadow-sm hover:shadow-md">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#00A94F] text-white flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-users text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				                <p class="text-xl font-bold text-gray-900 leading-tight" id="totalEmp">${totalEmp}명</p>
				                <p class="text-sm text-gray-600 mt-0.5">총 직원 수</p>
				            </div>
				        </div>
				    </div>
				</div>
				
		        <!-- 관리 모듈 -->
				<div>
				    <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
				        <div class="w-1 h-6 bg-[#00853D] rounded-full"></div>
				        관리 모듈
				    </h3>
				
				    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
				
				        <!-- 모듈 1: 재고 관리 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-warehouse text-base"></i>
				                </div>
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">재고 관리</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">전지점 품목 통합 조회 및 본사 물류창고 관리</p>
				                    <a href="<%= request.getContextPath() %>/hq/branch_stock/stock"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 모듈 2: 발주 관리 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-box text-base"></i>
				                </div>
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">발주 관리</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">지점 발주 요청 취합, 승인/반려 및 품목별 수량 설정</p>
				                    <a href="<%= request.getContextPath() %>/hq/place_order/overview"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 모듈 3: 매출 관리 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-arrow-trend-up text-base"></i>
				                </div>
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">매출 관리</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">전체 지점의 실시간 매출 조회 및 기간별 매출 분석</p>
				                    <a href="<%= request.getContextPath() %>/hq/sales/headquarters"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 모듈 4: 배송 관리 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-truck text-base"></i>
				                </div>
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">배송 관리</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">배송 상태 통합 트래킹 및 반품 처리</p>
				                    <a href="<%= request.getContextPath() %>/hq/delivery/inquiry"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 모듈 5: 직영점 통합 관리 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-store text-base"></i>
				                </div>
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">직영점 통합 관리</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">전국 직영점의 영업 현황과 실시간 매출 통합 관리</p>
				                    <a href="<%= request.getContextPath() %>/hq/support/branch-search"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 모듈 6: 인사 및 권한 관리 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-users text-base"></i>
				                </div>
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">인사 및 권한 관리</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">본사 및 지점별 직원 정보, 계정 발급 및 권한 관리</p>
				                    <a href="<%= request.getContextPath() %>/hq/hr/employee"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
				<!-- 긴급 공지 -->
				<div class="bg-white rounded-xl border-2 border-[#00853D]/10 p-6 shadow-sm">
				    <div class="flex items-center justify-between mb-4">
				        <h3 class="text-lg font-bold text-gray-900 flex items-center gap-2">
				           <div class="w-1 h-5 bg-[#00853D] rounded-full"></div>
				            공지사항
				        </h3>
				
				        <a href="<%= request.getContextPath() %>/hq/support/headquarters-notices.jsp"
				           class="inline-flex items-center gap-1 text-sm font-medium text-[#00853D] hover:text-[#006B2F] transition-all whitespace-nowrap">
				            바로가기
				        	<i class="fas fa-arrow-right text-xs"></i>
				        </a>
			      	</div>
					<!-- 긴급 공지 목록 출력 영역 -->
				    <div id="urgentNoticeList" class="space-y-3">
				        <div class="p-4 text-sm text-gray-500 bg-gray-50 rounded-lg">
				            긴급 공지를 불러오는 중입니다.
				        </div>
				    </div>	
			    </div>
			</div>
		</main>
	</div>
							
    <script>
    // 긴급 공지
    const ctx = "<%= request.getContextPath() %>";

    document.addEventListener('DOMContentLoaded', function () {
        loadUrgentNotices();
    });

    async function loadUrgentNotices() {
        const urgentNoticeList = document.getElementById('urgentNoticeList');

        try {
            const response = await fetch(ctx + '/hq/support/headquarters-notices-data');

            if (!response.ok) {
                throw new Error('공지사항 조회 실패');
            }

            const notices = await response.json();

            const urgentNotices = notices
                .filter(function (notice) {
                    return notice.type === '긴급 공지';
                })
                .sort(function (a, b) {
                    if (a.isPinned && !b.isPinned) return -1;
                    if (!a.isPinned && b.isPinned) return 1;

                    const dateA = new Date(a.lastDate ? a.lastDate : a.createdAt);
                    const dateB = new Date(b.lastDate ? b.lastDate : b.createdAt);

                    return dateB - dateA;
                })
                .slice(0, 3);

            if (urgentNotices.length === 0) {
                urgentNoticeList.innerHTML =
                    '<div class="p-4 text-sm text-gray-500 bg-gray-50 rounded-lg">' +
                        '등록된 긴급 공지가 없습니다.' +
                    '</div>';
                return;
            }

            urgentNoticeList.innerHTML = urgentNotices.map(function (notice) {
                const displayDate = notice.lastDate ? notice.lastDate : notice.createdAt;
                const dateText = formatNoticeDate(displayDate);

                return '' +
                    '<div class="flex items-start gap-3 p-3 rounded-lg bg-red-50/60 border border-red-100 hover:bg-red-50 transition-colors cursor-pointer" ' +
                         'onclick="location.href=\'' + ctx + '/hq/support/headquarters-notices.jsp\'">' +
                        '<div class="w-8 h-8 rounded-lg bg-red-100 text-red-600 flex items-center justify-center flex-shrink-0">' +
                            '<i class="fas fa-triangle-exclamation text-sm"></i>' +
                        '</div>' +

                        '<div class="flex-1 min-w-0">' +
                            '<div class="flex items-center gap-2 mb-1">' +
                                '<span class="px-2 py-0.5 rounded-full bg-red-100 text-red-700 text-[11px] font-semibold">긴급</span>' +
                                (notice.isPinned ? '<i class="fas fa-thumbtack text-xs text-red-500"></i>' : '') +
                            '</div>' +
                            '<p class="text-sm font-medium text-gray-900 truncate">' + escapeHtml(notice.title) + '</p>' +
                            '<p class="text-xs text-gray-500 mt-1">' + dateText + '</p>' +
                        '</div>' +
                    '</div>';
            }).join('');

        } catch (error) {
            console.error(error);

            urgentNoticeList.innerHTML =
                '<div class="p-4 text-sm text-red-600 bg-red-50 border border-red-100 rounded-lg">' +
                    '긴급 공지를 불러오지 못했습니다.' +
                '</div>';
        }
    }

    function formatNoticeDate(dateValue) {
        if (!dateValue) return '';

        const date = new Date(dateValue);

        if (isNaN(date.getTime())) {
            return dateValue;
        }

        return date.toLocaleString('ko-KR', {
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    function escapeHtml(value) {
        if (value == null) return '';

        return String(value)
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }
    
        // 사이드바 토글
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const backdrop = document.getElementById('sidebarBackdrop');
            
            if (sidebar.classList.contains('-translate-x-full')) {
                sidebar.classList.remove('-translate-x-full');
                backdrop.classList.remove('hidden');
            } else {
                sidebar.classList.add('-translate-x-full');
                backdrop.classList.add('hidden');
            }
        }

        // 메뉴 토글
        function toggleMenu(button) {
            const submenu = button.nextElementSibling;
            const chevron = button.querySelector('i.fa-chevron-right');
            
            submenu.classList.toggle('hidden');
            if (chevron) {
                if (submenu.classList.contains('hidden')) {
                    chevron.classList.remove('fa-chevron-down');
                    chevron.classList.add('fa-chevron-right');
                } else {
                    chevron.classList.add('fa-chevron-down');
                    chevron.classList.remove('fa-chevron-right');
                }
            }
        }

        // 사용자 메뉴 토글
        function toggleUserMenu() {
            const userMenu = document.getElementById('userMenu');
            userMenu.classList.toggle('hidden');
        }

        // 사용자 메뉴 외부 클릭시 닫기
        document.addEventListener('click', (e) => {
            const userMenuBtn = document.getElementById('userMenuBtn');
            const userMenu = document.getElementById('userMenu');
            
            if (!userMenuBtn.contains(e.target) && !userMenu.contains(e.target)) {
                userMenu.classList.add('hidden');
            }
        });

        // 사이드바 배경 클릭시 닫기
        document.getElementById('sidebarBackdrop').addEventListener('click', toggleSidebar);

        // 로그아웃 함수
        function logout() {
            alert('로그아웃 되었습니다');
            window.location.href = '<%= request.getContextPath() %>/common/login.jsp';
        }
    </script>
</body>
</html>
