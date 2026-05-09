<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>발주 요청 취합 및 조회 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
<style>
.sidebar-open .sidebar { transform: translateX(0); }

.tab-link {
    transition: all 0.15s ease;
}

.tab-link.active {
    background: #f3f6ff;
    color: #2563eb !important;
    box-shadow: inset 0 -2px 0 #4f7dff;
}

/* 커스텀 날짜 선택기 */
.custom-date-picker {
    position: fixed;
    width: 300px;
    background: #fff;
    border: 1px solid #d1d5db;
    border-radius: 0.75rem;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    z-index: 9999;
    padding: 14px;
}

.custom-date-picker.hidden {
    display: none;
}

.custom-date-picker-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12px;
}

.custom-date-nav-btn {
    width: 30px;
    height: 30px;
    border-radius: 0.5rem;
    border: 1px solid #e5e7eb;
    color: #4b5563;
    background: #fff;
    cursor: pointer;
}

.custom-date-nav-btn:hover {
    background: #f3f4f6;
}

.custom-date-weekdays,
.custom-date-days {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 4px;
}

.custom-date-weekdays div {
    text-align: center;
    font-size: 11px;
    font-weight: 700;
    color: #6b7280;
    padding: 4px 0;
}

.custom-date-day {
    height: 32px;
    border-radius: 0.5rem;
    border: none;
    background: #fff;
    font-size: 12px;
    cursor: pointer;
    color: #111827;
}

.custom-date-day:hover {
    background: #ecfdf3;
    color: #00853D;
    font-weight: 700;
}

.custom-date-day.other-month {
    color: #c4c4c4;
}

.custom-date-day.today {
    border: 1px solid #00853D;
    color: #00853D;
    font-weight: 700;
}

.custom-date-day.selected {
    background: #00853D;
    color: #fff;
    font-weight: 700;
}
</style>
<!-- 넘어온 데이터를 js로 반들기 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
</head>

<body class="bg-gray-50">

<%@ include file="/hq/common/sidebar.jsp"%>

<div class="lg:pl-72">
    <main class="p-6">

        <!-- ===== 페이지 헤더 ===== -->
        <div class="mb-6">
            <h2 class="text-3xl font-bold text-gray-900">발주 요청 취합 및 조회</h2>
            <p class="text-gray-500 mt-1">전체 지점의 발주 요청을 통합 관리하세요</p>
        </div>

        <!-- ===== 검색 필터 영역 ===== -->
		<div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm mb-6">
		    <div class="flex flex-col gap-4">
		
		        <!-- 검색 / 필터 -->
		        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
		
		            <!-- 왼쪽 설명 -->
		            <div>
		                <h3 class="text-sm font-semibold text-gray-800">발주 요청 조회</h3>
		                <p class="text-xs text-gray-500 mt-1">
		                    지점과 일자 범위를 선택하여 발주 요청 내역을 조회할 수 있습니다.
		                </p>
		            </div>
		
		            <!-- 오른쪽 필터 -->
		            <div class="flex flex-wrap items-center gap-2">
		
		                <!-- 지점 선택 -->
		                <select id="filterBranch"
		                        class="w-44 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
		                    <option value="전체">전체 지점</option>
		
		                    <c:if test="${not empty branchNames}">
		                        <c:forEach var="name" items="${branchNames}">
		                            <option value="${name}"
		                                <c:if test="${param.branchName == name}">selected</c:if>>
		                                ${name}
		                            </option>
		                        </c:forEach>
		                    </c:if>
		                </select>
		
		                <!-- 시작일 -->
						<div class="relative w-52">
						    <input type="text"
						           id="filterStartDate"
						           readonly
						           onclick="openCustomDatePicker('filterStartDate', event)"
						           placeholder="시작일 선택"
						           class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
						
						    <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
						</div>
						
						<span class="text-gray-500 text-sm">~</span>
						
						<!-- 종료일 -->
						<div class="relative w-52">
						    <input type="text"
						           id="filterEndDate"
						           readonly
						           onclick="openCustomDatePicker('filterEndDate', event)"
						           placeholder="종료일 선택"
						           class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
						
						    <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
						</div>
		
		                <!-- 버튼 -->
		                <button type="button"
		                        onclick="applyFilters()"
		                        class="px-5 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">
		                    조회
		                </button>
		
		                <button type="button"
		                        onclick="resetFilters()"
		                        class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">
		                    초기화
		                </button>
		            </div>
		        </div>
		    </div>
		</div>

        <!-- ===== 탭 UI ===== -->
        <div class="bg-white rounded-lg border border-gray-200 mb-6 overflow-hidden">
            <div class="grid grid-cols-4 border-b border-gray-200">
                <a href="#" class="tab-link active text-center py-3 font-semibold text-gray-500" data-status="전체">
                    전체 <span id="countAll">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-yellow-500" data-status="PENDING">
                    승인 대기 <span id="countPending" class="text-yellow-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-green-600" data-status="APPROVED">
                    승인됨 <span id="countApproved" class="text-green-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-red-500" data-status="REJECTED">
                    반려됨 <span id="countRejected" class="text-red-400">0건</span>
                </a>
            </div>
        </div>

        <!-- ===== 발주 요청 테이블 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
            <div class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                <h3 class="text-base font-semibold text-gray-900">발주 요청/이력</h3>
                <p class="text-base text-gray-500">조회 건수 <span id="recordCount" class="font-semibold text-gray-700">0건</span></p>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">발주 번호</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">요청 지점</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">요청 시점</th>
                            <th class="text-right  py-3 px-6 text-sm font-semibold text-gray-900">품목 수</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상태</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상세조회</th>
                        </tr>
                    </thead>
                    <tbody id="orderTableBody"></tbody>
                </table>
            </div>
            <div id="emptyState" class="hidden py-12 text-center">
                <i class="fas fa-folder-open text-4xl text-gray-300 mx-auto mb-4" style="display: block;"></i>
                <p class="text-gray-500 text-lg mb-2">발주 요청이 없습니다</p>
                <p class="text-gray-400 text-sm">선택한 필터 조건에 해당하는 발주가 없습니다</p>
            </div>

            <!-- 페이지네이션 -->
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

<!-- ===== 상세정보 모달 ===== -->
<div id="detailModal"
     class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
     onclick="if(event.target === this) closeDetailModal()">

    <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto"
         onclick="event.stopPropagation()">

        <!-- 모달 헤더 -->
        <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white z-10">
            <div>
                <h3 class="text-lg font-bold text-gray-900">발주서 상세 정보</h3>
                <p class="text-sm text-gray-500 mt-1" id="modalSubtitle"></p>
            </div>

            <button type="button"
                    onclick="closeDetailModal()"
                    class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-5 h-5"></i>
            </button>
        </div>

        <!-- 모달 본문 -->
        <div class="p-6 space-y-5">

            <!-- 기본 정보 -->
            <div>
                <h4 class="text-sm font-semibold text-gray-800 mb-3">기본 정보</h4>

                <div class="grid grid-cols-2 gap-4 bg-gray-50 rounded-lg p-4 border border-gray-200">
                    <div>
                        <p class="text-sm text-gray-500">발주 번호</p>
                        <p class="font-semibold text-gray-900 mt-1" id="detailOrderNumber"></p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">요청 지점</p>
                        <p class="font-semibold text-gray-900 mt-1" id="detailBranch"></p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">요청 시점</p>
                        <p class="font-semibold text-gray-900 mt-1" id="detailDate"></p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">상태</p>
                        <div id="detailStatus" class="mt-1"></div>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">품목 수</p>
                        <p class="font-semibold text-gray-900 mt-1" id="detailItemCount"></p>
                    </div>

                    <div>
                        <p class="text-sm text-gray-500">총 요청 수량</p>
                        <p class="font-semibold text-[#00853D] mt-1" id="detailTotalQty"></p>
                    </div>
                </div>
            </div>

            <!-- 발주 품목 상세 -->
            <div>
                <h4 class="text-sm font-semibold text-gray-800 mb-3">발주 품목 상세</h4>

                <!-- 반려 사유 영역 -->
                <div id="rejectReasonBox"
                     class="hidden mb-3 p-3 bg-red-50 border border-red-100 text-red-700 rounded-lg text-sm">
                </div>

                <!-- 상세 정보 테이블 -->
                <div class="overflow-x-auto border border-gray-200 rounded-lg">
                    <table class="w-full">
                        <thead id="itemsTableHead" class="bg-gray-50 border-b border-gray-200"></thead>
                        <tbody id="itemsTableBody" class="divide-y divide-gray-200"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 모달 하단 버튼 -->
        <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
            <button type="button"
                    onclick="closeDetailModal()"
                    class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                닫기
            </button>
        </div>
    </div>
</div>

<!-- 커스텀 달력 -->
<div id="customDatePicker" class="custom-date-picker hidden" onclick="event.stopPropagation()">
    <div class="custom-date-picker-header">
        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(-1)">
            <i class="fas fa-chevron-left text-xs"></i>
        </button>

        <div class="flex items-center gap-2">
            <select id="customDatePickerYear"
                    onchange="changeCustomPickerYearMonth()"
                    class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
            </select>

            <select id="customDatePickerMonth"
                    onchange="changeCustomPickerYearMonth()"
                    class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
            </select>
        </div>

        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(1)">
            <i class="fas fa-chevron-right text-xs"></i>
        </button>
    </div>

    <div class="custom-date-weekdays">
        <div>일</div>
        <div>월</div>
        <div>화</div>
        <div>수</div>
        <div>목</div>
        <div>금</div>
        <div>토</div>
    </div>

    <div id="customDatePickerDays" class="custom-date-days"></div>
</div>

<script>
    // ============================================================
    // 상수 / 설정
    // ============================================================
    var STATUS_CONFIG = {
        'PENDING':  { label: '승인 대기', badgeClass: 'bg-yellow-100 text-yellow-700', rowClass: 'bg-yellow-50' },
        'APPROVED': { label: '승인됨', badgeClass: 'bg-green-100 text-green-700',  rowClass: 'bg-green-50' },
        'REJECTED': { label: '반려됨', badgeClass: 'bg-red-100 text-red-700',      rowClass: 'bg-red-50' },
        'CANCELED': { label: '취소됨', badgeClass: 'bg-gray-200 text-gray-700', rowClass: 'bg-gray-50' },
        'DELIVERED': { label: '승인됨(지점 배송완료)', badgeClass: 'bg-green-100 text-green-700', rowClass: 'bg-green-50' },
        'COMPLETED': { label: '승인됨(지점 입고완료)', badgeClass: 'bg-green-100 text-green-700', rowClass: 'bg-green-50' },
        
        'default': { label: '미확인', badgeClass: 'bg-gray-100 text-gray-500', rowClass: '' }
    };

    function renderStatusBadge(status) {
        var meta = STATUS_CONFIG[status] || STATUS_CONFIG['default'];
        return '<span class="inline-flex px-3 py-1 rounded-full text-xs font-medium ' + meta.badgeClass + '">' + meta.label + '</span>';
    }

    // ============================================================
    // 전역 상태
    // ============================================================
    var allOrders      = [];
    var filteredOrders = [];
    var currentStatusFilter = '전체';
    var currentPage = 1;
    var itemsPerPage = 10;
    var PAGE_SIZE = 5;

	 // ============================================================
	 // 커스텀 달력
	 // ============================================================
	 var customDateTargetId = null;
	 var customPickerDate = new Date();
	
	 function parseDateLocal(dateStr) {
	     if (!dateStr) return null;
	
	     var parts = String(dateStr).split('-');
	
	     if (parts.length !== 3) {
	         return null;
	     }
	
	     return new Date(
	         Number(parts[0]),
	         Number(parts[1]) - 1,
	         Number(parts[2])
	     );
	 }
	
	 function formatDateLocal(date) {
	     return date.getFullYear() + '-' +
	         String(date.getMonth() + 1).padStart(2, '0') + '-' +
	         String(date.getDate()).padStart(2, '0');
	 }
	
	 function openCustomDatePicker(inputId, event) {
	     if (event) {
	         event.stopPropagation();
	     }
	
	     customDateTargetId = inputId;
	
	     var input = document.getElementById(inputId);
	     var selectedDate = parseDateLocal(input.value);
	
	     customPickerDate = selectedDate || new Date();
	
	     renderCustomDatePicker();
	     positionCustomDatePicker(input);
	
	     document.getElementById('customDatePicker').classList.remove('hidden');
	 }
	
	 function positionCustomDatePicker(input) {
	     var picker = document.getElementById('customDatePicker');
	     var rect = input.getBoundingClientRect();
	
	     var top = rect.bottom + 6;
	     var left = rect.left;
	
	     if (left + 300 > window.innerWidth) {
	         left = window.innerWidth - 312;
	     }
	
	     if (top + 330 > window.innerHeight) {
	         top = rect.top - 330;
	     }
	
	     picker.style.top = top + 'px';
	     picker.style.left = left + 'px';
	 }
	
	 function changeCustomPickerMonth(amount) {
	     customPickerDate.setMonth(customPickerDate.getMonth() + amount);
	     renderCustomDatePicker();
	 }
	
	 function changeCustomPickerYearMonth() {
	     var yearSelect = document.getElementById('customDatePickerYear');
	     var monthSelect = document.getElementById('customDatePickerMonth');
	
	     var selectedYear = Number(yearSelect.value);
	     var selectedMonth = Number(monthSelect.value);
	
	     customPickerDate = new Date(selectedYear, selectedMonth, 1);
	     renderCustomDatePicker();
	 }
	
	 function renderCustomDatePicker() {
	     var year = customPickerDate.getFullYear();
	     var month = customPickerDate.getMonth();
	
	     renderCustomPickerYearMonthSelect(year, month);
	
	     var firstDay = new Date(year, month, 1);
	     var lastDay = new Date(year, month + 1, 0);
	     var prevLastDay = new Date(year, month, 0);
	
	     var startDay = firstDay.getDay();
	
	     var days = [];
	
	     for (var i = startDay - 1; i >= 0; i--) {
	         var prevDate = prevLastDay.getDate() - i;
	
	         days.push({
	             date: new Date(year, month - 1, prevDate),
	             currentMonth: false
	         });
	     }
	
	     for (var d = 1; d <= lastDay.getDate(); d++) {
	         days.push({
	             date: new Date(year, month, d),
	             currentMonth: true
	         });
	     }
	
	     while (days.length < 42) {
	         var nextDate = days.length - (startDay + lastDay.getDate()) + 1;
	
	         days.push({
	             date: new Date(year, month + 1, nextDate),
	             currentMonth: false
	         });
	     }
	
	     var todayValue = formatDateLocal(new Date());
	     var selectedValue = '';
	
	     if (customDateTargetId) {
	         selectedValue = document.getElementById(customDateTargetId).value;
	     }
	
	     var html = '';
	
	     for (var j = 0; j < days.length; j++) {
	         var dateValue = formatDateLocal(days[j].date);
	
	         var className = 'custom-date-day';
	
	         if (!days[j].currentMonth) {
	             className += ' other-month';
	         }
	
	         if (dateValue === todayValue) {
	             className += ' today';
	         }
	
	         if (dateValue === selectedValue) {
	             className += ' selected';
	         }
	
	         html += '<button type="button" class="' + className + '" onclick="selectCustomDate(\'' + dateValue + '\')">';
	         html += days[j].date.getDate();
	         html += '</button>';
	     }
	
	     document.getElementById('customDatePickerDays').innerHTML = html;
	 }
	
	 function renderCustomPickerYearMonthSelect(year, month) {
	     var yearSelect = document.getElementById('customDatePickerYear');
	     var monthSelect = document.getElementById('customDatePickerMonth');
	
	     var yearHtml = '';
	     var startYear = year - 10;
	     var endYear = year + 10;
	
	     for (var y = startYear; y <= endYear; y++) {
	         yearHtml += '<option value="' + y + '"';
	
	         if (y === year) {
	             yearHtml += ' selected';
	         }
	
	         yearHtml += '>' + y + '년</option>';
	     }
	
	     var monthHtml = '';
	
	     for (var m = 0; m < 12; m++) {
	         monthHtml += '<option value="' + m + '"';
	
	         if (m === month) {
	             monthHtml += ' selected';
	         }
	
	         monthHtml += '>' + (m + 1) + '월</option>';
	     }
	
	     yearSelect.innerHTML = yearHtml;
	     monthSelect.innerHTML = monthHtml;
	 }
	
	 function selectCustomDate(dateValue) {
	     if (!customDateTargetId) {
	         return;
	     }
	
	     document.getElementById(customDateTargetId).value = dateValue;
	
	     document.getElementById('customDatePicker').classList.add('hidden');
	
	     customDateTargetId = null;
	 }
	
	 function closeCustomDatePicker() {
	     document.getElementById('customDatePicker').classList.add('hidden');
	     customDateTargetId = null;
	 }
	
	 document.addEventListener('mousedown', function(event) {
	     var picker = document.getElementById('customDatePicker');
	
	     if (!picker || picker.classList.contains('hidden')) {
	         return;
	     }
	
	     var target = event.target;
	
	     if (picker.contains(target)) {
	         return;
	     }
	
	     if (
	         customDateTargetId &&
	         document.getElementById(customDateTargetId) &&
	         document.getElementById(customDateTargetId).contains(target)
	     ) {
	         return;
	     }
	
	     closeCustomDatePicker();
	 });
    
    // ============================================================
    // 사이드바 / 네비게이션
    // ============================================================
    function toggleSidebar() {
        var sidebar  = document.getElementById('sidebar');
        var backdrop = document.getElementById('sidebarBackdrop');
        var menuIcon = document.getElementById('menuIcon');
        if (!sidebar || !backdrop || !menuIcon) return;

        sidebar.classList.toggle('-translate-x-full');
        backdrop.classList.toggle('hidden');
        var isOpen = !backdrop.classList.contains('hidden');
        menuIcon.classList.toggle('fa-bars', !isOpen);
        menuIcon.classList.toggle('fa-xmark', isOpen);
    }

    function toggleMenu(button) {
        var submenu = button.nextElementSibling;
        if (submenu && submenu.classList.contains('submenu')) {
            submenu.classList.toggle('hidden');
            var icon = button.querySelector('i:last-child');
            icon.classList.toggle('fa-chevron-down');
            icon.classList.toggle('fa-chevron-right');
        }
    }

    function toggleUserMenu() { document.getElementById('userMenu').classList.toggle('hidden'); }

    function logout() {
        commonShowAlert('로그아웃', '로그아웃되었습니다.', function() {
            window.location.href = '<%=request.getContextPath()%>/login';
        });
    }

    var backdrop = document.getElementById('sidebarBackdrop');
    if (backdrop) {
        backdrop.addEventListener('click', toggleSidebar);
    }
    document.addEventListener('click', function(e) {
        var userMenu = document.getElementById('userMenu');

        if (!userMenu) return;

        if (!e.target.closest('button[onclick="toggleUserMenu()"]') && !e.target.closest('#userMenu')) {
            userMenu.classList.add('hidden');
        }
    });

    // ============================================================
    // 날짜 기본값 (이번달 1일 ~ 오늘)
    // ============================================================
    function initDateRange() {
		var today = new Date();

		var mm = String(today.getMonth() + 1).padStart(2, '0');
		var dd = String(today.getDate()).padStart(2, '0');
		var yyyy = today.getFullYear();
		var firstDay = yyyy + '-' + mm + '-01';
		var todayStr = yyyy + '-' + mm + '-' + dd;
		document.getElementById('filterStartDate').value = firstDay;
		document.getElementById('filterEndDate').value = todayStr;
    }

    // ============================================================
    // 탭 / 상태 관리
    // ============================================================
    document.querySelectorAll('.tab-link').forEach(function(tab) {
        tab.addEventListener('click', function(e) {
            e.preventDefault();
            currentStatusFilter = this.getAttribute('data-status');
            updateActiveTab();
            applyStatusFilter();
        });
    });

    function updateActiveTab() {
        document.querySelectorAll('.tab-link').forEach(function(tab) {
            if (tab.getAttribute('data-status') === currentStatusFilter) {
                tab.classList.add('active');
            } else {
                tab.classList.remove('active');
            }
        });
    }

    function applyStatusFilter() {
        if (currentStatusFilter === '전체') {
            filteredOrders = allOrders;
        } else if (currentStatusFilter === 'APPROVED') {
            filteredOrders = allOrders.filter(function(o) {
                return o.status === 'APPROVED' || o.status === 'DELIVERED' || o.status === 'COMPLETED';
            });
        } else {
            filteredOrders = allOrders.filter(function(o) { return o.status === currentStatusFilter; });
        }
        currentPage = 1;
        renderTable();
    }

    function updateStatusCounts() {
        var counts = { PENDING: 0, APPROVED: 0, REJECTED: 0 };
        allOrders.forEach(function(o) {
            if (o.status === 'PENDING') counts.PENDING++;
            else if (o.status === 'APPROVED' || o.status === 'DELIVERED' || o.status === 'COMPLETED') counts.APPROVED++;
            else if (o.status === 'REJECTED') counts.REJECTED++;
        });
        document.getElementById('countAll').textContent      = allOrders.length + '건';
        document.getElementById('countPending').textContent  = counts.PENDING   + '건';
        document.getElementById('countApproved').textContent = counts.APPROVED  + '건';
        document.getElementById('countRejected').textContent = counts.REJECTED  + '건';
    }

    // ============================================================
    // 데이터 조회 (API)
    // ============================================================
    async function applyFilters() {
        var params = new URLSearchParams({
            branchName:    document.getElementById('filterBranch').value,
            startDate: document.getElementById('filterStartDate').value,
            endDate:   document.getElementById('filterEndDate').value
        });

        try {
            // 요청
            var res = await fetch('<%=request.getContextPath()%>/api/hq/place_order/overview?' + params);
            // parse JSON once
            var payload = null;
            try {
                payload = await res.json();
            } catch (e) {
                payload = null;
            }

            if (!res.ok) {
                throw new Error((payload && payload.message) || 'HTTP ' + res.status);
            }

            var result = payload;
            console.log('응답 데이터:', result && result.data);
            if (!result || result.status != 'success') throw new Error((result && result.message) || '데이터 오류');

            allOrders = result.data || [];
            filteredOrders = (currentStatusFilter === '전체')
                ? allOrders
                : allOrders.filter(function(o) { return o.status === currentStatusFilter; });

        } catch (err) {
            console.error('발주 요청 조회 실패:', err);
            allOrders      = [];
            filteredOrders = [];
        }

        currentPage = 1;
        renderTable();
        updateStatusCounts();
        updateActiveTab();
    }

    function resetFilters() {
        document.getElementById('filterBranch').value = '전체';
        initDateRange();
        currentStatusFilter = '전체';
        updateActiveTab();
        applyFilters();
    }

    // ============================================================
    // 테이블 렌더링
    // ============================================================
    function renderTable() {
        var tbody      = document.getElementById('orderTableBody');
        var emptyState = document.getElementById('emptyState');

        tbody.innerHTML = '';

        document.getElementById('recordCount').textContent = filteredOrders.length + '건';

        var totalPages = Math.ceil(filteredOrders.length / itemsPerPage);
        var startIndex = (currentPage - 1) * itemsPerPage;
        var endIndex = startIndex + itemsPerPage;
        var pageOrders = filteredOrders.slice(startIndex, endIndex);
        
        if (filteredOrders.length === 0) {
            emptyState.classList.remove('hidden');
            document.getElementById('paginationContainer').classList.add('hidden');
            return;
        }

        emptyState.classList.add('hidden');

        pageOrders.forEach(function(order) {
            var meta = STATUS_CONFIG[order.status] || STATUS_CONFIG['default'];
            var tr   = document.createElement('tr');
            tr.className = 'border-b border-gray-100 hover:bg-gray-50 ' + meta.rowClass;
            tr.innerHTML =
                '<td class="py-4 px-6 font-mono text-sm text-blue-600">' + order.poNo + '</td>' +
                '<td class="py-4 px-6 font-medium text-gray-900"><i class="fas fa-map-pin text-gray-400 mr-2"></i>' + order.branchName + '</td>' +
                '<td class="py-4 px-6 text-gray-700 text-sm"><i class="fas fa-calendar text-gray-400 mr-2"></i>' + order.requestedAt + '</td>' +
                '<td class="py-4 px-6 text-right font-semibold text-gray-900">' + order.totalItemCnt + '개</td>' +
                '<td class="py-4 px-6 text-center"><span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ' + meta.badgeClass + '">' + meta.label + '</span></td>' +
                '<td class="py-4 px-6 text-center"><button onclick="openDetail(\'' + order.poId + '\')" class="text-blue-600 hover:text-blue-700 text-sm font-medium">상세조회</button></td>';
            tbody.appendChild(tr);
        });
        
        updatePagination(totalPages, startIndex, endIndex);
    }
    
 	// ============================================================
    // 페이징 처리
    // ============================================================

    function updatePagination(totalPages, startIndex, endIndex) {
        var container = document.getElementById('paginationContainer');

        if (totalPages <= 1) {
            container.classList.add('hidden');
            return;
        }

        container.classList.remove('hidden');

        document.getElementById('paginationInfo').textContent =
            (startIndex + 1)
            + '-'
            + Math.min(endIndex, filteredOrders.length)
            + ' / '
            + filteredOrders.length
            + '개';

        var pageButtons = document.getElementById('pageButtons');

        var base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
        var active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
        var arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';

        var blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
        var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

        var html = '';

        html += '<button class="' + arrow + '" onclick="goToPage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
        html += '<i class="fas fa-angles-left text-xs"></i>';
        html += '</button>';

        var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
        html += '<button class="' + arrow + '" onclick="goToPage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
        html += '<i class="fas fa-chevron-left text-xs"></i>';
        html += '</button>';

        for (var i = blockStart; i <= blockEnd; i++) {
            html += '<button class="' + (i === currentPage ? active : base) + '" onclick="goToPage(' + i + ')">';
            html += i;
            html += '</button>';
        }

        var nextBlockPage = Math.min(totalPages, blockEnd + 1);
        html += '<button class="' + arrow + '" onclick="goToPage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
        html += '<i class="fas fa-chevron-right text-xs"></i>';
        html += '</button>';

        html += '<button class="' + arrow + '" onclick="goToPage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
        html += '<i class="fas fa-angles-right text-xs"></i>';
        html += '</button>';

        pageButtons.innerHTML = html;
    }

    function goToPage(page) {
        currentPage = page;
        renderTable();

        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }

    // ============================================================
    // 상세정보 모달
    // ============================================================
    function getDetailTableConfig(status) {
        if (status === 'APPROVED') {
            return {
                colspan: 4,
                head: `
                    <tr>
                        <th class="text-left py-3 px-4 text-sm font-semibold">품목명</th>
                        <th class="text-right py-3 px-4 text-sm font-semibold">요청 수량</th>
                        <th class="text-right py-3 px-4 text-sm font-semibold">승인 수량</th>
                        <th class="text-right py-3 px-4 text-sm font-semibold">미승인 수량</th>
                    </tr>`
            };
        }

        if (status === 'REJECTED') {
            return {
                colspan: 2,
                head: `
                    <tr>
                        <th class="text-left py-3 px-4 text-sm font-semibold">품목명</th>
                        <th class="text-right py-3 px-4 text-sm font-semibold">요청 수량</th>
                    </tr>`
            };
        }

        return {
            colspan: 4,
            head: `
                <tr>
                    <th class="text-left py-3 px-4 text-sm font-semibold">품목명</th>
                    <th class="text-right py-3 px-4 text-sm font-semibold">요청 수량</th>
                    <th class="text-right py-3 px-4 text-sm font-semibold">지점 현재 재고</th>
                    <th class="text-right py-3 px-4 text-sm font-semibold">지점 안전 재고</th>
                </tr>`
        };
    }

    function renderDetailRow(item, status, rejectReason) {
        console.log(item);
        console.log(status);

        // 값 안전 처리 (null/undefined 방지)
        var name          = item.materialName || '';
        var requestedQty  = item.requestedQty || 0;
        var approvedQty   = Number(item.approvedQty || 0);
        var currentStock  = item.currentStock || 0;
        var safetyStock   = item.safetyStock || 0;
        var unit          = item.unit || '';

        if (status === 'APPROVED') {
            var rejectedQty = Math.max(0, Number(requestedQty) - approvedQty);

            return ''
                + '<td class="py-3 px-4">' + name + '</td>'
                + '<td class="py-3 px-4 text-right">' + requestedQty + unit + '</td>'
                + '<td class="py-3 px-4 text-right text-green-600 font-semibold">' + approvedQty + unit + '</td>'
                + '<td class="py-3 px-4 text-right text-red-500 font-semibold">' + rejectedQty + unit + '</td>';
        }

        if (status === 'REJECTED') {
            return ''
                + '<td class="py-3 px-4">' + name + '</td>'
                + '<td class="py-3 px-4 text-right">' + requestedQty + unit + '</td>';
        }

        // PENDING (기본)
        var stockColor = (Number(currentStock) < Number(safetyStock))
            ? 'text-red-600'
            : 'text-green-600';

        return ''
            + '<td class="py-3 px-4">' + name + '</td>'
            + '<td class="py-3 px-4 text-right font-semibold text-blue-600">' + requestedQty + unit + '</td>'
            + '<td class="py-3 px-4 text-right font-semibold ' + stockColor + '">' + currentStock + unit + '</td>'
            + '<td class="py-3 px-4 text-right text-gray-700">' + safetyStock + unit + '</td>';
    }

    async function openDetail(orderId) {
        var thead = document.getElementById('itemsTableHead');
        var tbody = document.getElementById('itemsTableBody');
        document.getElementById('detailModal').classList.remove('hidden');

        // 로딩
        thead.innerHTML = '';
        tbody.innerHTML = '<tr><td class="py-8 text-center text-gray-500">로딩 중...</td></tr>';

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/place_order/overview/' + encodeURIComponent(orderId));
            var json;
            try {
                json = await res.json();
            } catch (e) {
                throw new Error("JSON 파싱 실패");
            }

            if (!res.ok || !json || json.status !== 'success') {
                throw new Error((json && json.message) || ('API 실패: ' + res.status));
            }

            var data   = json.data;
            var meta   = STATUS_CONFIG[data.status] || STATUS_CONFIG['default'];
            var status = data.status; // 발주 상태
            var tableConfig = getDetailTableConfig(status);

            // 기본 정보
            document.getElementById('modalSubtitle').textContent    = data.branchName + ' · ' + data.poNo;
            document.getElementById('detailOrderNumber').textContent = data.poNo;
            document.getElementById('detailBranch').textContent      = data.branchName;
            document.getElementById('detailDate').textContent        = data.requestedAt;
            document.getElementById('detailItemCount').textContent   = data.totalItemCnt + '개';
            document.getElementById('detailTotalQty').textContent    = data.totalAmounts;
            document.getElementById('detailStatus').innerHTML = renderStatusBadge(status);
            /* 반려 사유 */
            var rejectReasonBox = document.getElementById('rejectReasonBox');

            if (status === 'REJECTED') {
                rejectReasonBox.classList.remove('hidden');
                rejectReasonBox.innerText = '반려 사유 : ' + data.rejectReason || '-';
            } else {
                rejectReasonBox.classList.add('hidden');
                rejectReasonBox.innerText = '';
            }

            // 품목 목록
            var items = data.items || [];
            if (items.length === 0) {
                thead.innerHTML = tableConfig.head;
                tbody.innerHTML = `<tr><td colspan="${tableConfig.colspan}" class="py-8 text-center text-gray-500">품목 정보가 없습니다</td></tr>`;
                return;
            }

            thead.innerHTML = tableConfig.head;
            tbody.innerHTML = '';

            // 바디 구성
            var rejectReason = data.rejectReason || '';
            items.forEach(function(item) {
                const html = renderDetailRow(item, status, rejectReason);
                var tr = document.createElement('tr');
                tr.innerHTML = html;
                tbody.appendChild(tr);
            });

        } catch (err) {
            console.error('상세 조회 실패:', err);

            tbody.innerHTML = `
                <tr>
                    <td colspan="1" class="py-8 text-center text-red-500">
                        데이터를 불러오지 못했습니다: ${err.message}
                    </td>
                </tr>`;
        }
    }

    function closeDetailModal() {
        document.getElementById('detailModal').classList.add('hidden');
    }

    document.getElementById('detailModal').addEventListener('click', function(e) {
        if (e.target == this) closeDetailModal();
    });

    // ============================================================
    // 초기화
    // ============================================================
    window.addEventListener('DOMContentLoaded', function() {
        initDateRange();
        updateActiveTab();
        applyFilters();
    });
</script>
</body>
</html>
