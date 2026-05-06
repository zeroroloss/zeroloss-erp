<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dto.AccountDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>지점장 홈</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<%@ include file="/branch/common/layout/layout_head.jsp" %>
</head>
<body class="bg-gray-50">
	<div class="zl-app">
	<%@ include file="/branch/common/layout/sidebar.jsp" %>

		<div class="zl-content">
		<%@ include file="/branch/common/layout/topbar.jsp" %>

			<div class="p-6 space-y-5">

			    <!-- 페이지 헤더 -->
			    <div class="bg-gradient-to-r from-[#00853D] to-[#00A94F] rounded-xl p-4 text-white shadow-lg">
			        <div class="flex items-center gap-3">
			            <div>
			                <h2 class="text-2xl font-bold">
			                    <%="ZERO LOSS " + loginUser.getBranchName() + " 지점 관리 시스템"%>
			                </h2>
			                <p class="text-white/90 mt-1 text-sm">
			                    <%="2026년 4월 20일 | " + loginUser.getUserName() + " " + loginUser.getRoleName() + "님 환영합니다."%>
			                </p>
			            </div>
			        </div>
			    </div>
			
																<!-- 빠른 통계 -->
																<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">

				    <!-- 통계 카드 1: 주문 건수 -->
				    <div class="bg-white rounded-xl border border-gray-200 p-4 shadow-sm hover:shadow-md hover:border-[#00853D]/40 transition-all">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#00853D] text-white flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-shopping-cart text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				                <p class="text-xl font-bold text-gray-900 leading-tight" id="summary-orders">0건</p>
				                <p class="text-sm text-gray-600 mt-0.5">주문 건수</p>
				            </div>
				        </div>
				    </div>
				
				    <!-- 통계 카드 2: 오늘 매출주문 건수 -->
				    <div class="bg-white rounded-xl border border-gray-200 p-4 shadow-sm hover:shadow-md hover:border-[#00853D]/40 transition-all">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#FFD100] text-[#00853D] flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-arrow-trend-up text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				                <p class="text-xl font-bold text-gray-900 leading-tight" id="summary-sales">₩0</p>
				                <p class="text-sm text-gray-600 mt-0.5">오늘 매출</p>
				            </div>
				        </div>
				    </div>
				
				    <!-- 통계 카드 3: 재고 현황 -->
				    <div class="bg-white rounded-xl border border-gray-200 p-4 shadow-sm hover:shadow-md hover:border-[#00853D]/40 transition-all">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#006B2F] text-white flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-chart-line text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				                <p class="text-xl font-bold text-gray-900 leading-tight" id="summary-monthly-sales">₩0</p>
				                <p class="text-sm text-gray-600 mt-0.5">이번 달 매출</p>
				            </div>
				        </div>
				    </div>
				
				    <!-- 통계 카드 4: 알림 -->
				    <div class="bg-white rounded-xl border border-gray-200 p-4 shadow-sm hover:shadow-md hover:border-[#00853D]/40 transition-all">
				        <div class="flex items-center gap-4">
				            <div class="w-10 h-10 rounded-lg bg-[#00A94F] text-white flex items-center justify-center shadow-sm shrink-0">
				                <i class="fas fa-users text-base"></i>
				            </div>
				
				            <div class="min-w-0">
				                <p class="text-xl font-bold text-gray-900 leading-tight" id="todayEmp">${todayEmp}명</p>
				                <p class="text-sm text-gray-600 mt-0.5">오늘 근무 인원</p>
				            </div>
				        </div>
				    </div>
				</div>

			    <!-- 빠른 작업 -->
				<div>
				    <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
				        <div class="w-1 h-6 bg-[#00853D] rounded-full"></div>
				        빠른 작업
				    </h3>
				
				    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
				
				        <!-- 작업 1: 재고 현황 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-warehouse text-base"></i>
				                </div>
				
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">재고 현황</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">실시간 재고 확인</p>
				                    <a href="<%= request.getContextPath()%>/branch/stock"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 작업 2: 발주서 작성 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-file-invoice text-base"></i>
				                </div>
				
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">발주서 작성</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">새로운 발주 요청 생성</p>
				                    <a href="<%= request.getContextPath()%>/branch/place_order/draft"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 작업 3: 매출 조회 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-arrow-trend-up text-base"></i>
				                </div>
				
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">매출 조회</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">오늘 매출 상세 분석</p>
				                    <a href="<%= request.getContextPath()%>/branch/sales/detail"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				
				        <!-- 작업 4: 재고 교환 요청 -->
				        <div class="border-2 rounded-xl p-5 bg-[#00853D]/5 border-[#00853D]/15 hover:border-[#00853D]/35 hover:bg-[#00853D]/10 transition-all shadow-sm hover:shadow-md">
				            <div class="flex items-start gap-4">
				                <div class="w-11 h-11 bg-[#00853D] rounded-lg flex items-center justify-center text-white shadow-sm shrink-0">
				                    <i class="fas fa-right-left text-base"></i>
				                </div>
				
				                <div>
				                    <h4 class="text-base font-bold text-gray-900 mb-1">재고 교환</h4>
				                    <p class="text-sm text-gray-600 mb-3 leading-relaxed">주변 지점에 재고 지원 요청</p>
				                    <a href="<%= request.getContextPath()%>/branch/swap/main?tab=check_stock"
				                       class="inline-flex items-center gap-1.5 text-sm font-medium text-[#00853D] hover:text-[#006B2F] hover:gap-2.5 transition-all">
				                        바로가기
				                        <i class="fas fa-arrow-right text-xs"></i>
				                    </a>
				                </div>
				            </div>
				        </div>
				    </div>
				</div>
			
			    <!-- 상위 공지 -->
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
				
				    <!-- 상위 공지 목록 출력 영역 -->
				    <div id="topNoticeList" class="space-y-3">
				        <div class="p-4 text-sm text-gray-500 bg-gray-50 rounded-lg">
				            공지사항을 불러오는 중입니다.
				        </div>
				    </div>
				</div>
			</div>
		</div>
	</div>
<script>
    // 상위 공지
    const ctx = "<%= request.getContextPath() %>";

    document.addEventListener('DOMContentLoaded', function () {
		loadSalesSummary();
        loadTopNotices();
    });

	async function loadSalesSummary() {
		try {
			const response = await fetch(ctx + '/branch/sales/summary');

			if (response.status === 401) {
				window.location.href = ctx + '/login';
				return;
			}

			if (!response.ok) {
				document.getElementById('summary-orders').textContent = '데이터 로딩 실패';
				document.getElementById('summary-sales').textContent = '데이터 로딩 실패';
				document.getElementById('summary-monthly-sales').textContent = '데이터 로딩 실패';
				return;
			}

			const summary = await response.json();
			const formatCurrency = function (amount) {
				return new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(amount || 0);
			};

			document.getElementById('summary-orders').textContent = (summary.todayOrders || 0) + '건';
			document.getElementById('summary-sales').textContent = formatCurrency(summary.todaySales);
			document.getElementById('summary-monthly-sales').textContent = formatCurrency(summary.monthlySales);
		} catch (error) {
			console.error(error);

			document.getElementById('summary-orders').textContent = '데이터 로딩 실패';
			document.getElementById('summary-sales').textContent = '데이터 로딩 실패';
			document.getElementById('summary-monthly-sales').textContent = '데이터 로딩 실패';
		}
	}

    async function loadTopNotices() {
        const topNoticeList = document.getElementById('topNoticeList');

        try {
            const response = await fetch(ctx + '/hq/support/headquarters-notices-data');

            if (!response.ok) {
                throw new Error('공지사항 조회 실패');
            }

            const notices = await response.json();

            const topNotices = notices
                .sort(function (a, b) {
                    if (a.isPinned && !b.isPinned) return -1;
                    if (!a.isPinned && b.isPinned) return 1;

                    const dateA = new Date(a.lastDate ? a.lastDate : a.createdAt);
                    const dateB = new Date(b.lastDate ? b.lastDate : b.createdAt);

                    return dateB - dateA;
                })
                .slice(0, 4);

            if (topNotices.length === 0) {
                topNoticeList.innerHTML =
                    '<div class="p-4 text-sm text-gray-500 bg-gray-50 rounded-lg">' +
                        '등록된 공지사항이 없습니다.' +
                    '</div>';
                return;
            }

            topNoticeList.innerHTML = topNotices.map(function (notice) {
                const displayDate = notice.lastDate ? notice.lastDate : notice.createdAt;
                const dateText = formatNoticeDate(displayDate);

                const typeStyle = getNoticeTypeStyle(notice.type);

                return '' +
                    '<div class="flex items-start gap-3 p-3 rounded-lg bg-gray-50 border border-gray-100 hover:bg-green-50/50 hover:border-[#00853D]/20 transition-colors cursor-pointer" ' +
                         'onclick="location.href=\'' + ctx + '/hq/support/headquarters-notices.jsp\'">' +

                        '<div class="w-8 h-8 rounded-lg ' + typeStyle.iconBg + ' ' + typeStyle.iconText + ' flex items-center justify-center flex-shrink-0">' +
                            '<i class="' + typeStyle.icon + ' text-sm"></i>' +
                        '</div>' +

                        '<div class="flex-1 min-w-0">' +
                            '<div class="flex items-center gap-2 mb-1">' +
                                '<span class="px-2 py-0.5 rounded-full ' + typeStyle.badge + ' text-[11px] font-semibold">' +
                                    escapeHtml(notice.type) +
                                '</span>' +
                                (notice.isPinned ? '<i class="fas fa-thumbtack text-xs text-[#00853D]"></i>' : '') +
                            '</div>' +

                            '<p class="text-sm font-medium text-gray-900 truncate">' +
                                escapeHtml(notice.title) +
                            '</p>' +

                            '<p class="text-xs text-gray-500 mt-1">' +
                                dateText +
                            '</p>' +
                        '</div>' +
                    '</div>';
            }).join('');

        } catch (error) {
            console.error(error);

            topNoticeList.innerHTML =
                '<div class="p-4 text-sm text-red-600 bg-red-50 border border-red-100 rounded-lg">' +
                    '공지사항을 불러오지 못했습니다.' +
                '</div>';
        }
    }

    function getNoticeTypeStyle(type) {
        if (type === '긴급 공지') {
            return {
                badge: 'bg-red-100 text-red-700',
                iconBg: 'bg-red-100',
                iconText: 'text-red-600',
                icon: 'fas fa-triangle-exclamation'
            };
        }

        if (type === '위생 가이드') {
            return {
                badge: 'bg-blue-100 text-blue-700',
                iconBg: 'bg-blue-100',
                iconText: 'text-blue-600',
                icon: 'fas fa-shield-halved'
            };
        }

        if (type === '운영 지침') {
            return {
                badge: 'bg-purple-100 text-purple-700',
                iconBg: 'bg-purple-100',
                iconText: 'text-purple-600',
                icon: 'fas fa-clipboard-list'
            };
        }

        return {
            badge: 'bg-gray-100 text-gray-700',
            iconBg: 'bg-gray-100',
            iconText: 'text-gray-600',
            icon: 'fas fa-bullhorn'
        };
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
</script>
</body>
</html>
