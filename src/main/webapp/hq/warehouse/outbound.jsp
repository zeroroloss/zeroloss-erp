<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>본사 물류창고 출고 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
.sidebar-open .sidebar { 
    transform: translateX(0); 
}

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
    z-index: 99999;
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

.status { display: inline-flex; align-items: center; gap: 6px; padding: 5px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; }
.status-pending { background: #fff7e6; color: #d97706; }
.status-approved { background: #e8f5e9; color: #16a34a; }
.status-rejected { background: #ffe4e6; color: #dc2626; }
.status-canceled { background: #f3f4f6; color: #6b7280; }
.status-delivered { background: #e0f2fe; color: #0284c7; }
.status-completed { background: #ede9fe; color: #7c3aed; }
</style>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
</head>
<body class="bg-gray-50">

<%@ include file="/hq/common/sidebar.jsp"%>

<div class="lg:pl-72">
    <main class="p-6">

        <!-- ===== 페이지 헤더 ===== -->
        <div class="mb-6">
            <h2 class="text-3xl font-bold text-gray-900">본사 물류창고 출고</h2>
            <p class="text-gray-500 mt-1">지점 발주 요청에 대한 출고 내역을 확인하세요</p>
        </div>

        <!-- ===== 검색 필터 영역 ===== -->
		<div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm mb-6">
		    <div class="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-4">
		
		        <!-- 왼쪽 설명 -->
		        <div class="shrink-0">
		            <div class="flex items-center gap-2">
		                <h3 class="text-sm font-semibold text-gray-800">출고 이력 검색</h3>
		            </div>
		            <p class="text-xs text-gray-500 mt-1">
		                지점과 일자 범위를 선택하여 출고 이력을 조회할 수 있습니다.
		            </p>
		        </div>
		
		        <!-- 오른쪽 필터 -->
		        <div class="flex flex-wrap items-center justify-end gap-2">
		
		            <!-- 지점 선택 -->
		            <select id="filterBranch"
		                    class="w-44 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white">
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
		            <div class="relative w-44">
		                <input type="text"
		                       id="filterStartDate"
		                       readonly
		                       onclick="openCustomDatePicker('filterStartDate', event)"
		                       placeholder="시작일"
		                       class="w-full pl-3 pr-9 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
		
		                <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
		            </div>
		
		            <span class="text-gray-400 text-sm px-1">~</span>
		
		            <!-- 종료일 -->
		            <div class="relative w-44">
		                <input type="text"
		                       id="filterEndDate"
		                       readonly
		                       onclick="openCustomDatePicker('filterEndDate', event)"
		                       placeholder="종료일"
		                       class="w-full pl-3 pr-9 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
		
		                <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
		            </div>
		
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

        <!-- ===== 탭 UI ===== -->
        <div class="bg-white rounded-lg border border-gray-200 mb-6 overflow-hidden">
            <div class="grid grid-cols-4 border-b border-gray-200">
                <a href="#" class="tab-link active text-center py-3 font-semibold text-gray-500" data-status="전체">
                    전체 <span id="countAll">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-amber-500" data-status="PENDING">
                    승인 대기 <span id="countWaiting" class="text-xs text-amber-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-green-600" data-status="APPROVED">
                    승인됨 <span id="countPreparing" class="text-xs text-green-400">0건</span>
                </a>
                <a href="#" class="tab-link text-center py-3 font-semibold text-blue-600" data-status="DELIVERED">
                    지점 배송 완료 <span id="countCompleted" class="text-xs text-blue-400">0건</span>
                </a>
            </div>
        </div>

        <!-- ===== 출고 목록 테이블 ===== -->
        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
            <div class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                <h3 class="text-base font-semibold text-gray-900">출고 이력 리스트</h3>
                <p class="text-base text-gray-500">조회 건수 <span id="recordCount" class="font-semibold text-gray-700">0건</span></p>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-gray-50 border-b border-gray-200">
                        <tr>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">발주서 번호</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">지점명</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">출고 시점</th>
                            <th class="text-left   py-3 px-6 text-sm font-semibold text-gray-900">처리자</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">출고 상태</th>
                            <th class="text-center py-3 px-6 text-sm font-semibold text-gray-900">상세조회</th>
                        </tr>
                    </thead>
                    <tbody id="outboundTableBody"></tbody>
                </table>
            </div>
            <div id="emptyState" class="hidden py-12 text-center">
                <i class="fas fa-box text-4xl text-gray-300 mx-auto mb-4" style="display: block;"></i>
                <p class="text-gray-500 text-lg mb-2">조회 결과가 없습니다</p>
                <p class="text-gray-400 text-sm">선택한 필터 조건에 해당하는 출고 내역이 없습니다</p>
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

<!-- ===== 상세보기 모달 ===== -->
<div id="detailModal"
     class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
     onclick="if(event.target === this) closeDetailModal()">

    <div class="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto"
         onclick="event.stopPropagation()">

        <!-- 모달 헤더 -->
        <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white z-10">
            <div>
                <h3 class="text-lg font-bold text-gray-900">발주/출고 상세보기</h3>
                <p class="text-xs text-gray-500 mt-1" id="modalSubtitle"></p>
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
                <div class="flex items-center gap-2 mb-3">
                    <div class="w-1 h-5 bg-[#00853D] rounded-full"></div>
                    <h4 class="text-sm font-semibold text-gray-800">기본 정보</h4>
                </div>

                <div class="grid grid-cols-2 gap-4 bg-gray-50 rounded-lg border border-gray-200 p-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">발주서 번호</label>
                        <div id="detailOrderId"
                             class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white font-mono text-blue-600">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">지점명</label>
                        <div id="detailBranch"
                             class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900 font-medium">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">출고 시점</label>
                        <div id="detailDate"
                             class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">처리자</label>
                        <div id="detailHandler"
                             class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">출고 상태</label>
                        <div class="w-full min-h-[38px] px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white flex items-center">
                            <div id="detailStatus"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 품목 상세 -->
            <div>
                <div class="flex items-center gap-2 mb-3">
                    <div class="w-1 h-5 bg-[#00853D] rounded-full"></div>
                    <h4 class="text-sm font-semibold text-gray-800" id="itemsTitle">품목 상세</h4>
                </div>

                <div class="overflow-x-auto border border-gray-200 rounded-lg">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b border-gray-200">
                            <tr id="itemsTableHeader"></tr>
                        </thead>
                        <tbody id="itemsTableBody" class="bg-white divide-y divide-gray-100"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 모달 하단 -->
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
        'PENDING':   { label: '승인 대기', badgeClass: 'status-pending' },
        'APPROVED':  { label: '승인됨', badgeClass: 'status-approved' },
        'REJECTED':  { label: '반려됨', badgeClass: 'status-rejected' },
        'CANCELED':  { label: '취소됨', badgeClass: 'status-canceled' },
        'DELIVERED': { label: '지점 배송 완료', badgeClass: 'status-delivered' },
        'COMPLETED': { label: '지점 입고 완료', badgeClass: 'status-completed' },
        'default':   { label: '-', badgeClass: 'status-canceled' }
    };

    function normalizeStatus(status) {
        var value = String(status || '').toUpperCase();

        if (value === '출고대기') return 'PENDING';
        if (value === '준비중') return 'APPROVED';
        if (value === '출고완료') return 'DELIVERED';

        return value;
    }

    function getStatusMeta(status) {
        return STATUS_CONFIG[normalizeStatus(status)] || STATUS_CONFIG['default'];
    }

    function renderStatusBadge(status) {
        var meta = getStatusMeta(status);
        return '<span class="' + meta.badgeClass + '">' + meta.label + '</span>';
    }

    // ============================================================
    // 전역 상태
    // ============================================================
    var allRecords          = [];
    var filteredRecords     = [];
    var currentStatusFilter = '전체';
    var currentPage         = 1;
    var itemsPerPage        = 10;
    var PAGE_SIZE           = 5;

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
	         event.preventDefault();
	         event.stopPropagation();
	     }
	
	     customDateTargetId = inputId;
	
	     var input = document.getElementById(inputId);
	     var picker = document.getElementById('customDatePicker');
	
	     if (!input || !picker) {
	         console.error('커스텀 달력 요소를 찾을 수 없습니다.');
	         return;
	     }
	
	     var selectedDate = parseDateLocal(input.value);
	     customPickerDate = selectedDate || new Date();
	
	     renderCustomDatePicker();
	
	     picker.classList.remove('hidden');
	     positionCustomDatePicker(input);
	 }
	
	 function positionCustomDatePicker(input) {
	     var picker = document.getElementById('customDatePicker');
	     var rect = input.getBoundingClientRect();
	
	     var pickerWidth = 300;
	     var pickerHeight = 330;
	
	     var top = rect.bottom + 6;
	     var left = rect.left;
	
	     if (left + pickerWidth > window.innerWidth) {
	         left = window.innerWidth - pickerWidth - 12;
	     }
	
	     if (top + pickerHeight > window.innerHeight) {
	         top = rect.top - pickerHeight - 6;
	     }
	
	     if (left < 12) {
	         left = 12;
	     }
	
	     if (top < 12) {
	         top = 12;
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
	
	     customPickerDate = new Date(
	         Number(yearSelect.value),
	         Number(monthSelect.value),
	         1
	     );
	
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
	
	     if (customDateTargetId && document.getElementById(customDateTargetId)) {
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
	     closeCustomDatePicker();
	 }
	
	 function closeCustomDatePicker() {
	     var picker = document.getElementById('customDatePicker');
	
	     if (picker) {
	         picker.classList.add('hidden');
	     }
	
	     customDateTargetId = null;
	 }
	
	 document.addEventListener('mousedown', function(event) {
		    var picker = document.getElementById('customDatePicker');

		    if (!picker || picker.classList.contains('hidden')) {
		        return;
		    }

		    if (picker.contains(event.target)) {
		        return;
		    }

		    if (
		        customDateTargetId &&
		        document.getElementById(customDateTargetId) &&
		        document.getElementById(customDateTargetId).contains(event.target)
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
        commonShowAlert('알림', '로그아웃되었습니다.');
        window.location.href = '<%=request.getContextPath()%>/login';
    }

    var sidebarBackdrop = document.getElementById('sidebarBackdrop');

    if (sidebarBackdrop) {
        sidebarBackdrop.addEventListener('click', toggleSidebar);
    }
    document.addEventListener('click', function(e) {
        var userMenu = document.getElementById('userMenu');

        if (!userMenu) {
            return;
        }

        if (!e.target.closest('button[onclick="toggleUserMenu()"]') && !e.target.closest('#userMenu')) {
            userMenu.classList.add('hidden');
        }
    });

    // ============================================================
    // 날짜 기본값 (이번달 1일 ~ 오늘)
    // ============================================================
    function initDateRange() {
        var today = new Date();
        var mm    = String(today.getMonth() + 1).padStart(2, '0');
        var dd    = String(today.getDate()).padStart(2, '0');
        var yyyy  = today.getFullYear();
        document.getElementById('filterStartDate').value = yyyy + '-' + mm + '-01';
        document.getElementById('filterEndDate').value   = yyyy + '-' + mm + '-' + dd;
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
        filteredRecords = (currentStatusFilter === '전체')
            ? allRecords
            : allRecords.filter(function(r) { return normalizeStatus(r.status) === currentStatusFilter; });
        currentPage = 1;
        renderTable();
    }

    function updateStatusCounts() {
        var counts = { PENDING: 0, APPROVED: 0, DELIVERED: 0 };
        allRecords.forEach(function(r) {
            var key = normalizeStatus(r.status);
            if (key in counts) counts[key]++;
        });
        document.getElementById('countAll').textContent       = allRecords.length + '건';
        document.getElementById('countWaiting').textContent   = counts.PENDING + '건';
        document.getElementById('countPreparing').textContent = counts.APPROVED + '건';
        document.getElementById('countCompleted').textContent = counts.DELIVERED + '건';
    }

    // ============================================================
    // 데이터 조회 (API)
    // ============================================================
    async function applyFilters() {
        var params = new URLSearchParams({
            branchName: document.getElementById('filterBranch').value,
            startDate:  document.getElementById('filterStartDate').value,
            endDate:    document.getElementById('filterEndDate').value
        });

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/outbound?' + params);

            if (!res.ok) {
                let errMsg = 'HTTP ' + res.status;
                try {
                    const errData = await res.json();
                    errMsg = errData.message || errMsg;
                } catch (e) {}
                throw new Error(errMsg);
            }

            var result = await res.json();
            if (!result || result.status != 'success') {
                throw new Error((result && result.message) || '데이터 오류');
            }

            allRecords = result.data || [];

        } catch (err) {
            console.error('출고 목록 조회 실패:', err);
            allRecords = [];   // ⭐ 여기만 바꿈 (UI는 공통 처리)
        }

        currentPage = 1;
        applyStatusFilter();
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
	     var tbody = document.getElementById('outboundTableBody');
	     var emptyState = document.getElementById('emptyState');
	     var paginationContainer = document.getElementById('paginationContainer');
	
	     tbody.innerHTML = '';
	
	     document.getElementById('recordCount').textContent = filteredRecords.length + '건';
	
	     if (filteredRecords.length === 0) {
	         emptyState.classList.remove('hidden');
	         paginationContainer.classList.add('hidden');
	         return;
	     }
	
	     emptyState.classList.add('hidden');
	
	     var totalPages = Math.ceil(filteredRecords.length / itemsPerPage);
	     var startIndex = (currentPage - 1) * itemsPerPage;
	     var endIndex = startIndex + itemsPerPage;
	     var pageRecords = filteredRecords.slice(startIndex, endIndex);
	
	     pageRecords.forEach(function(record) {
	         var meta = STATUS_CONFIG[record.status] || STATUS_CONFIG['default'];
	         var tr = document.createElement('tr');
	
	         tr.className = 'border-b border-gray-100 hover:bg-gray-50';
	
	         tr.innerHTML =
	             '<td class="py-4 px-6 font-mono text-sm text-blue-600">' + record.poNo + '</td>' +
	             '<td class="py-4 px-6 font-medium text-gray-900">' +
	                 '<i class="fas fa-map-pin text-gray-400 mr-2"></i>' + record.branchName +
	             '</td>' +
	             '<td class="py-4 px-6 text-gray-700 text-sm">' +
	                 '<i class="fas fa-calendar text-gray-400 mr-2"></i>' + record.outboundAt +
	             '</td>' +
	             '<td class="py-4 px-6 text-gray-700 text-sm">' + (record.handler || '-') + '</td>' +
	             '<td class="py-4 px-6 text-center">' + renderStatusBadge(record.status) + '</td>' +

	             '<td class="py-4 px-6 text-center">' +
	                 '<button onclick="openDetail(\'' + record.hqOutboundNo + '\')" class="text-blue-600 hover:text-blue-700 text-sm font-medium">상세조회</button>' +
	             '</td>';
	
	         tbody.appendChild(tr);
	     });
	
	     updatePagination(totalPages, startIndex, endIndex);
	 }
	
	 // ============================================================
	 // 페이지네이션
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
	         + Math.min(endIndex, filteredRecords.length)
	         + ' / '
	         + filteredRecords.length
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
    // 상세보기 모달
    // ============================================================
    async function openDetail(outboundId) {
        var tbody = document.getElementById('itemsTableBody');
        tbody.innerHTML = '<tr><td colspan="6" class="py-8 text-center text-gray-500">로딩 중...</td></tr>';
        document.getElementById('detailModal').classList.remove('hidden');

        try {
            var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/outbound/' + encodeURIComponent(outboundId));
            if (!res.ok) throw new Error('API 실패: ' + res.status);

            var json        = await res.json();
            var data        = json.data;
            var isCompleted = (normalizeStatus(data.status) === 'DELIVERED');

            // 기본 정보
            document.getElementById('modalSubtitle').textContent  = data.branchName + ' · ' + data.poNo;
            document.getElementById('detailOrderId').textContent  = data.poNo;
            document.getElementById('detailBranch').textContent   = data.branchName;
            document.getElementById('detailDate').textContent     = data.outboundAt;
            document.getElementById('detailHandler').textContent  = data.handler || '-';
            document.getElementById('detailStatus').innerHTML = renderStatusBadge(data.status);

            // 품목 테이블 헤더
            document.getElementById('itemsTitle').textContent = isCompleted ? '출고 품목' : '발주 품목';
            document.getElementById('itemsTableHeader').innerHTML =
                '<th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">품목코드</th>'       +
                '<th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">품목명</th>'         +
                '<th class="text-left  py-3 px-4 text-sm font-semibold text-gray-900">카테고리</th>'       +
                '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">발주 요청 수량</th>' +
                '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">출고 수량</th>'      +
                (!isCompleted ? '<th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">창고 재고</th>' : '');

            // 품목 목록
            var items = data.items || [];
            if (items.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="py-8 text-center text-gray-500">품목 정보가 없습니다</td></tr>';
                return;
            }

            tbody.innerHTML = '';
            items.forEach(function(item) {
                var isInsufficient = !isCompleted && (item.warehouseStock < item.requestedQty);
                var tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100' + (isInsufficient ? ' bg-red-50' : '');
                var rowHtml =
                    '<td class="py-3 px-4 font-mono text-sm text-gray-600">' + item.itemCode + '</td>' +
                    '<td class="py-3 px-4 font-medium text-gray-900">'       + item.itemName + '</td>' +
                    '<td class="py-3 px-4 text-sm"><span class="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">' + item.category + '</span></td>' +
                    '<td class="py-3 px-4 text-right font-semibold text-blue-600">'  + item.requestedQty + item.unit + '</td>' +
                    '<td class="py-3 px-4 text-right font-semibold text-green-600">' + (item.confirmedQty != null ? item.confirmedQty : 0) + item.unit + '</td>';
                if (!isCompleted) {
                    var stockClass = isInsufficient ? 'text-red-600' : 'text-green-600';
                    rowHtml += '<td class="py-3 px-4 text-right font-semibold ' + stockClass + '">' + item.warehouseStock + item.unit + '</td>';
                }
                tr.innerHTML = rowHtml;
                tbody.appendChild(tr);
            });

        } catch (err) {
            tbody.innerHTML = '<tr><td colspan="6" class="py-8 text-center text-red-500">데이터를 불러오지 못했습니다: ' + err.message + '</td></tr>';
        }
    }

    function closeDetailModal() {
        document.getElementById('detailModal').classList.add('hidden');
    }

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