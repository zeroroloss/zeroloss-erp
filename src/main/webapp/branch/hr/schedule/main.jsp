<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dto.AccountDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
  <title>직원 일정 관리 - 월간</title>
  <style>
    body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #f3f4f6; color: #111827; }
    .wrap {
    width: 100%; max-width: none; margin: 0; }
    .head { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; padding: 8px 0 14px; }
    .title { margin: 0; font-size: 34px; letter-spacing: -0.03em; }
    .sub { margin: 8px 0 0; font-size: 17px; color: #6b7280; }
    .add-btn { height: 44px; padding: 0 18px; border: 0; border-radius: 12px; background: #00853d; color: #fff; display: inline-flex; align-items: center; gap: 8px; font-size: 15px; font-weight: 700; cursor: pointer; text-decoration: none; }
    .ico-16 { width: 16px; height: 16px; display: block; }

    .notice { background: #f3ecff; border: 1px solid #e5d5ff; border-radius: 14px; padding: 14px 16px; display: flex; align-items: flex-start; gap: 10px; color: #7c3aed; font-size: 14px; margin-bottom: 12px; }
    .notice p { margin: 0; line-height: 1.45; }

    .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 12px; }
    .card { background: #fff; border: 1px solid #d1d5db; border-radius: 14px; padding: 14px; display: flex; align-items: center; gap: 12px; }
    .icon-box { width: 52px; height: 52px; border-radius: 12px; display: grid; place-items: center; }
    .b1 { background: #dbeafe; color: #2563eb; } .b2 { background: #dcfce7; color: #16a34a; }
    .b3 { background: #f3e8ff; color: #9333ea; } .b4 { background: #fef3c7; color: #ca8a04; }
    .k { font-size: 14px; color: #6b7280; }
    .v { margin-top: 2px; font-size: 30px; font-weight: 800; }

    .panel { background: #fff; border: 1px solid #d1d5db; border-radius: 14px; padding: 12px; margin-bottom: 12px; }
    .panel-head { display: inline-flex; align-items: center; gap: 8px; color: #374151; font-size: 18px; font-weight: 700; margin-bottom: 10px; }
    .filter-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 12px; }
    .field label { display: block; margin-bottom: 6px; color: #374151; font-size: 15px; font-weight: 700; }
    .input { width: 100%; height: 44px; box-sizing: border-box; border: 1px solid #cbd5e1; border-radius: 12px; padding: 0 14px; font-size: 15px; }

    .cal-wrap { background: #fff; border: 1px solid #d1d5db; border-radius: 14px; padding: 12px; }
    .cal-top { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }
    .cal-nav { display: inline-flex; align-items: center; gap: 10px; }
    .nav-btn { width: 38px; height: 38px; border: 0; border-radius: 10px; background: #fff; cursor: pointer; }
    .date-label { font-size: 28px; font-weight: 800; letter-spacing: -0.02em; }
	.day-cell.today {background-color: #ecfdf3; border-left: 3px solid #00853D;}

    .view-tabs a { text-decoration: none; width: 40px; height: 40px; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; margin-left: 6px; font-weight: 700; color: #4b5563; background: #f3f4f6; font-size: 15px; }
    .view-tabs a.active { background: #0a8b43; color: #fff; }

    .legend { margin-top: 12px; display: flex; flex-wrap: wrap; gap: 16px; color: #4b5563; font-size: 14px; }
    .dot { width: 11px; height: 11px; border-radius: 999px; display: inline-block; margin-right: 6px; }

    .month-grid { margin-top: 12px; border: 1px solid #d1d5db; border-radius: 12px; overflow: hidden; }
    .week-head, .week-row { display: grid; grid-template-columns: repeat(7, 1fr); }
    .week-head div { background: #f8fafc; text-align: center; padding: 8px 0; font-size: 14px; font-weight: 700; color: #374151; border-right: 1px solid #e5e7eb; }
    .week-head div:last-child { border-right: 0; }
    .week-row .cell { min-height: 120px; border-top: 1px solid #e5e7eb; border-right: 1px solid #e5e7eb; padding: 10px; font-size: 15px; color: #111827; }
    .week-row .cell:last-child { border-right: 0; }
    .sun { color: #dc2626; } .sat { color: #2563eb; }
    .out { color: #9ca3af; background: #f8fafc; }
    .picked { display: inline-flex; width: 30px; height: 30px; border-radius: 999px; align-items: center; justify-content: center; background: #2563eb; color: #fff; font-size: 18px; font-weight: 700; }

	.calendar-grid {display: grid; grid-template-columns: repeat(7, 1fr);}
	.calendar-grid {display: grid; grid-template-columns: repeat(7, 1fr); gap: 0;}
	.day-header {text-align: center; padding: 12px 8px; font-weight: 600; border-bottom: 2px solid #e5e7eb; background-color: #f3f4f6; font-size: 14px; color: #374151;}
	.day-cell {min-height: 120px; border: 1px solid #e5e7eb; padding: 8px; background: white; overflow: hidden; overflow-y: auto;}
	.day-cell.other-month,
	.other-month {background-color: #f9fafb; color: #9ca3af;}
	.day-cell.today {background-color: #ecfdf3; border-left: 3px solid #00853D;}
	.schedule-event {font-size: 12px; padding: 6px; margin-bottom: 4px; border-radius: 4px; color: white; cursor: pointer; transition: opacity 0.2s; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
	.schedule-event:hover {opacity: 0.9;}
	.other-month {background: #f9fafb; color: #9ca3af;}
	.today {background: #ecfdf5;}
	.schedule-event {margin-top: 4px; padding: 3px 6px; border-radius: 6px; font-size: 12px; color: white; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
	.type-OPEN {background: #00853D;}
	.type-MIDDLE {background: #2563eb;}
	.type-CLOSE {background: #9333ea;}
	.employee-name-link {cursor: pointer; text-decoration: underline; text-underline-offset: 2px; font-weight: 600}
	.employee-name-link:hover {opacity: 0.8;}

    .modal-overlay { position: fixed; inset: 0; background: transparent; display: none; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box; z-index: 2000; }
    .modal-overlay.open { display: flex; }
    .modal-frame { width: min(820px, 100%); height: min(92vh, 920px); border: 0; border-radius: 16px; background: transparent; box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22); }
    .modal-close { position: absolute; top: 18px; right: 18px; width: 36px; height: 36px; border: 0; border-radius: 999px; background: #fff; color: #374151; font-size: 22px; line-height: 36px; cursor: pointer; z-index: 2001; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12); }
	.modal-hidden {display: none !important;}

    /* Custom date picker (sales style) */
    .custom-date-picker {
        position: fixed;
        width: 340px;
        background: #fff;
        border: 1px solid #d1d5db;
        border-radius: 0.75rem;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        z-index: 9999;
        padding: 12px;
    }
    .custom-date-picker.hidden { display: none; }
    .custom-date-picker-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
    .custom-date-picker select { height: 30px; min-width: auto; width: auto; border-radius: 0.5rem; padding: 0 8px; font-size: 12px; font-weight: 600; background: #fff; }
    .custom-date-nav-btn { width: 30px; height: 30px; border-radius: 0.5rem; border: 1px solid #e5e7eb; color: #4b5563; background: #fff; cursor: pointer; }
    .custom-date-nav-btn:hover { background: #f3f4f6; }
    .custom-date-weekdays, .custom-date-days { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; }
    .custom-date-weekdays div { text-align: center; font-size: 11px; font-weight: 700; color: #6b7280; padding: 4px 0; }
    .custom-date-day { height: 32px; border-radius: 0.5rem; border: none; background: #fff; font-size: 12px; cursor: pointer; color: #111827; }
    .custom-date-day:hover { background: #ecfdf3; color: #00853D; font-weight: 700; }
    .custom-date-day.other-month { color: #c4c4c4; }
    .custom-date-day.today { border: 1px solid #00853D; color: #00853D; font-weight: 700; }
    .custom-date-day.selected { background: #00853D; color: #fff; font-weight: 700; }

    @media (max-width: 1200px) {
      .title { font-size: 30px; } .sub { font-size: 16px; }
      .add-btn { font-size: 14px; height: 42px; }
      .k { font-size: 13px; } .v { font-size: 24px; }
      .panel-head { font-size: 16px; }
      .field label { font-size: 14px; }
      .date-label { font-size: 22px; }
      .input, .today, .week-head div, .week-row .cell, .legend, .view-tabs a { font-size: 14px; }
      .stats { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 760px) {
      .title { font-size: 30px; } .sub { font-size: 14px; }
      .filter-grid { grid-template-columns: 1fr; }
      .stats { grid-template-columns: 1fr; }
      .date-label { font-size: 22px; }
      .week-row .cell { min-height: 90px; font-size: 14px; }
      .week-head div { font-size: 13px; }
      .legend { font-size: 13px; }
      .add-btn { font-size: 14px; }
      .input { font-size: 14px; }
    }
  </style>
  <%@ include file="/branch/common/layout/layout_head.jsp" %>
</head>
<body class="bg-gray-50">
<div class="zl-app">
  <%@ include file="/branch/common/layout/sidebar.jsp" %>
  
  <div class="zl-content">
    
      <div class="p-6">
      	<main>
        	<div class="space-y-6">
        		<!-- 페이지 헤더 -->
                    <div class="flex items-center justify-between">
                        <div>
                            <h2 class="text-3xl font-bold text-gray-900">직원 일정 관리</h2>
                            <p class="text-gray-500 mt-1">${sessionScope.branchName} 직원의 일정을 통합 관리합니다</p>
                        </div>
                        <div class="flex items-center gap-2">
					        <button id="openAddScheduleModal" type="button" class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2.5 rounded-lg hover:bg-[#006B2F] transition-colors">
					            <i class="fas fa-plus w-5 h-5"></i>
					            <span>일정 추가</span>
					        </button>
					    </div>
					</div>  
          			
			        <!-- 캘린더 카드 전체 -->
					<div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
					
					    <!-- 캘린더 상단 헤더 + 필터 -->
					    <div class="p-5 border-b border-gray-200">
					        <div class="flex flex-col gap-4">
					
					            <!-- 1줄: 월 이동 / 제목 / 오늘 버튼 -->
					            <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-3">
					                <div class="flex items-center gap-3">
					                    <button type="button"
					                            onclick="previousPeriod()"
					                            class="w-9 h-9 rounded-lg border border-gray-300 text-gray-600 hover:bg-gray-50 transition-colors">
					                        <i class="fas fa-chevron-left text-xs"></i>
					                    </button>
					
					                    <h3 id="monthTitle" class="text-lg font-bold text-gray-900 min-w-[120px] text-center">
					                        2026년 4월
					                    </h3>
					
					                    <button type="button"
					                            onclick="nextPeriod()"
					                            class="w-9 h-9 rounded-lg border border-gray-300 text-gray-600 hover:bg-gray-50 transition-colors">
					                        <i class="fas fa-chevron-right text-xs"></i>
					                    </button>
					
					                    <button type="button"
					                            onclick="goToday()"
					                            class="px-3 py-2 border border-gray-300 rounded-lg bg-white text-gray-700 text-sm font-medium hover:bg-[#00853D] hover:text-white hover:border-[#00853D] outline-none transition-all">
					                        오늘
					                    </button>
					                </div>
					
					                <!-- 오른쪽: 직원 검색 필터 -->
					                <div class="flex flex-wrap items-center gap-2">
					                    <div class="relative w-80">
					                        <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-sm"></i>
					                        <input type="text"
					                               id="searchInput"
					                               onkeydown="if(event.key === 'Enter') applyFilters();"
					                               placeholder="사번, 이름을 입력하세요"
					                               class="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
					                    </div>
					
					                    <button type="button"
					                            onclick="applyFilters()"
					                            class="px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">
					                        조회
					                    </button>
					
					                    <button type="button"
					                            onclick="resetFilters()"
					                            class="px-3 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">
					                        초기화
					                    </button>
					                </div>
					            </div>
					
					            <!-- 캘린더 범례 -->
					            <div id="legendArea" class="flex items-center gap-5 flex-wrap text-sm">
					                <div class="flex items-center gap-2">
					                    <div class="w-3 h-3 bg-[#00853D] rounded-full"></div>
					                    <span class="text-gray-600">오픈</span>
					                </div>
					
					                <div class="flex items-center gap-2">
					                    <div class="w-3 h-3 bg-blue-500 rounded-full"></div>
					                    <span class="text-gray-600">미들</span>
					                </div>
					
					                <div class="flex items-center gap-2">
					                    <div class="w-3 h-3 bg-purple-500 rounded-full"></div>
					                    <span class="text-gray-600">마감</span>
					                </div>
					            </div>
					
					        </div>
					    </div>
					
					    <!-- 캘린더 그리드 -->
					    <div class="p-5">
					        <div class="border border-gray-200 rounded-lg overflow-hidden">
					            <!-- 요일 헤더 -->
					            <div id="dayHeaders" class="calendar-grid gap-0 bg-gray-50">
					                <div class="day-header">일</div>
					                <div class="day-header">월</div>
					                <div class="day-header">화</div>
					                <div class="day-header">수</div>
					                <div class="day-header">목</div>
					                <div class="day-header">금</div>
					                <div class="day-header">토</div>
					            </div>
					
					            <!-- 캘린더 셀 -->
					            <div id="calendarContainer" class="calendar-grid gap-0">
					                <!-- renderCalendar()에서 동적으로 생성됨 -->
					            </div>
					        </div>
					    </div>
					</div>
				</div>
            </main>
        </div>
    </div>  
</div>       

<%@ include file="/branch/hr/schedule/add_schedule.jsp" %>
<%@ include file="/branch/hr/schedule/modify_schedule.jsp" %>
<script>
    /************************************************************
     * 1. 서버에서 전달받은 데이터
     ************************************************************/

    // 지점 스케줄 목록
    var branchSchedules = [
        <c:forEach var="s" items="${scheduleList}" varStatus="st">
        {
            id: "${s.scheduleId}",
            employeeId: "${s.empNo}",
            employee: "${s.empName}",
            branchCode: "${s.branchCode}",
            branch: "${s.branchName}",
            workDate: "${s.workDate}",
            type: "${s.workType}",
            title: "${s.workType}",
            startTime: "${s.startTime}",
            endTime: "${s.endTime}",
            isRepeat: "${s.isRepeat}",
            repeatGroupId: "${s.repeatGroupId}",
            notes: "${s.memo}"
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    // 지점 직원 목록
    var employees = [
        <c:forEach var="e" items="${branchEmployeeList}" varStatus="st">
        {
            id: "${e.empNo}",
            name: "${e.name}",
            grade: "${e.gradeCode}",
            dept: "${e.dept}",
            branch: "${e.branchName}",
            branchCode: "${e.branchCode}"
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];


    /************************************************************
     * 2. 전역 변수
     ************************************************************/

    // 현재 캘린더 기준 날짜
    var currentDate = new Date();

    // 조회 버튼을 눌렀는지 여부
    // false이면 캘린더에 스케줄을 표시하지 않음
    var isSearched = false;


    /************************************************************
     * 3. 초기 실행
     ************************************************************/

    window.addEventListener('DOMContentLoaded', function () {
        // 캘린더 최초 렌더링
        renderCalendar();

        // 일정 추가 버튼 이벤트 연결
        var addBtn = document.getElementById("openAddScheduleModal");

        if (addBtn) {
            addBtn.addEventListener("click", function () {
                showAddModal();
            });
        }
    });


    /************************************************************
     * 4. 공통 유틸 함수
     ************************************************************/

    // Date 객체를 YYYY-MM-DD 문자열로 변환
    function formatDate(date) {
        return date.getFullYear() + '-' +
            String(date.getMonth() + 1).padStart(2, '0') + '-' +
            String(date.getDate()).padStart(2, '0');
    }

    // 시간 값을 HH:mm 형태로 정리
    function formatTime(value) {
        return String(value || '').substring(0, 5);
    }

    // 특정 input/select 값 가져오기
    function getValue(id) {
        var el = document.getElementById(id);
        return el ? el.value : '';
    }

    // 특정 input/select 값 세팅하기
    function setValue(id, value) {
        var el = document.getElementById(id);

        if (el) {
            el.value = value || '';
        }
    }


    /************************************************************
     * 5. 캘린더 렌더링
     ************************************************************/

    // 캘린더 전체 렌더링
    function renderCalendar() {
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth();
        var currentSchedules = getFilteredSchedules();

        document.getElementById('monthTitle').textContent = year + '년 ' + (month + 1) + '월';

        renderDayHeaders();

        var days = makeCalendarDays(year, month);
        var html = '';

        for (var i = 0; i < days.length; i++) {
            html += makeCalendarCell(days[i], currentSchedules);
        }

        var container = document.getElementById('calendarContainer');
        var dayHeaders = document.getElementById('dayHeaders');

        container.innerHTML = html;
        container.style.gridTemplateColumns = 'repeat(7, 1fr)';
        dayHeaders.style.gridTemplateColumns = 'repeat(7, 1fr)';
    }

    // 요일 헤더 생성
    function renderDayHeaders() {
        document.getElementById('dayHeaders').innerHTML =
            '<div class="day-header">일</div>' +
            '<div class="day-header">월</div>' +
            '<div class="day-header">화</div>' +
            '<div class="day-header">수</div>' +
            '<div class="day-header">목</div>' +
            '<div class="day-header">금</div>' +
            '<div class="day-header">토</div>';
    }

    // 캘린더에 표시할 날짜 배열 생성
    function makeCalendarDays(year, month) {
        var days = [];

        var firstDay = new Date(year, month, 1);
        var lastDay = new Date(year, month + 1, 0);
        var prevLastDay = new Date(year, month, 0);
        var startDay = firstDay.getDay();

        // 이전 달 날짜 채우기
        for (var i = startDay - 1; i >= 0; i--) {
            var prevDate = prevLastDay.getDate() - i;

            days.push({
                day: prevDate,
                currentMonth: false,
                date: new Date(year, month - 1, prevDate)
            });
        }

        // 현재 달 날짜 채우기
        for (var d = 1; d <= lastDay.getDate(); d++) {
            days.push({
                day: d,
                currentMonth: true,
                date: new Date(year, month, d)
            });
        }

        // 다음 달 날짜 채우기
        var totalCells = Math.ceil(days.length / 7) * 7;
        var nextDay = 1;

        while (days.length < totalCells) {
            days.push({
                day: nextDay,
                currentMonth: false,
                date: new Date(year, month + 1, nextDay)
            });

            nextDay++;
        }

        return days;
    }

    // 날짜 셀 HTML 생성
    function makeCalendarCell(dayObj, currentSchedules) {
        var dateStr = formatDate(dayObj.date);

        var daySchedules = currentSchedules.filter(function (schedule) {
            return schedule.workDate === dateStr;
        });

        var isToday = new Date().toLocaleDateString() === dayObj.date.toLocaleDateString();

        var cellClass =
            'day-cell p-2 cursor-pointer hover:bg-blue-50 ' +
            (dayObj.currentMonth ? '' : 'other-month ') +
            (isToday ? 'today' : '');

        var html = '';

        html += '<div class="' + cellClass + '" style="min-height:120px;" onclick="selectDateForModal(\'' + dateStr + '\')">';
        html += '<div class="text-xs font-medium mb-1 text-gray-900">' + dayObj.day + '</div>';
        html += makeScheduleGroupHtml(daySchedules);
        html += '</div>';

        return html;
    }

    // 하루 일정들을 오픈 / 미들 / 마감별로 묶어서 HTML 생성
    function makeScheduleGroupHtml(daySchedules) {
        var openSchedules = [];
        var middleSchedules = [];
        var closeSchedules = [];

        for (var i = 0; i < daySchedules.length; i++) {
            var schedule = daySchedules[i];

            if (schedule.type === 'OPEN') {
                openSchedules.push(schedule);
            } else if (schedule.type === 'MIDDLE') {
                middleSchedules.push(schedule);
            } else if (schedule.type === 'CLOSE') {
                closeSchedules.push(schedule);
            }
        }

        var html = '<div class="mt-2 space-y-1 text-xs">';

        if (openSchedules.length > 0) {
            html += '<div class="schedule-event type-OPEN">';
            html += '<span class="font-semibold">오픈</span> ';
            html += makeNameLinks(openSchedules);
            html += '</div>';
        }

        if (middleSchedules.length > 0) {
            html += '<div class="schedule-event type-MIDDLE">';
            html += '<span class="font-semibold">미들</span> ';
            html += makeNameLinks(middleSchedules);
            html += '</div>';
        }

        if (closeSchedules.length > 0) {
            html += '<div class="schedule-event type-CLOSE">';
            html += '<span class="font-semibold">마감</span> ';
            html += makeNameLinks(closeSchedules);
            html += '</div>';
        }

        html += '</div>';

        return html;
    }

    // 캘린더 일정에 표시될 직원 이름 링크 생성
    function makeNameLinks(scheduleArr) {
        var namesHtml = [];

        for (var i = 0; i < scheduleArr.length; i++) {
            var item = scheduleArr[i];

            namesHtml.push(
                '<span class="employee-name-link" ' +
                'onclick="event.stopPropagation(); viewSchedule(\'' + item.id + '\')" ' +
                'title="' + item.employee + ' 일정 수정">' +
                item.employee +
                '</span>'
            );
        }

        return namesHtml.join(', ');
    }


    /************************************************************
     * 6. 캘린더 이동 / 조회 / 초기화
     ************************************************************/

    // 이전 달 이동
    function previousPeriod() {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
    }

    // 다음 달 이동
    function nextPeriod() {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
    }

    // 오늘 날짜로 이동
    function goToday() {
        currentDate = new Date();
        renderCalendar();
    }

    // 날짜 셀 클릭 시 해당 날짜로 일정 추가 모달 열기
    function selectDateForModal(dateStr) {
        showAddModal(dateStr);
    }

    // 조회 버튼 클릭 시 스케줄 표시
    function applyFilters() {
        isSearched = true;
        renderCalendar();
    }

    // 조회 조건 초기화
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        isSearched = false;
        renderCalendar();
    }

    // 검색 조건에 맞는 스케줄 목록 반환
    function getFilteredSchedules() {
        if (!isSearched) {
            return [];
        }

        var keyword = document.getElementById('searchInput').value.trim();
        var schedules = branchSchedules;

        if (!keyword) {
            return schedules;
        }

        return schedules.filter(function (schedule) {
            return String(schedule.employeeId || '').includes(keyword)
                || String(schedule.employee || '').includes(keyword)
                || String(schedule.branch || '').includes(keyword)
                || String(schedule.type || '').includes(keyword);
        });
    }


    /************************************************************
     * 7. 일정 추가 모달
     ************************************************************/

    // 일정 추가 모달 열기
    function showAddModal(selectedDate) {
        var targetDate = selectedDate || formatDate(new Date());

        setValue('empName', '');
        setValue('empNo', '');

        var employeeCheckboxes = document.getElementById('employeeCheckboxes');
        var employeeList = document.getElementById('employeeList');

        if (employeeCheckboxes) {
            employeeCheckboxes.classList.add('hidden');
        }

        if (employeeList) {
            employeeList.innerHTML = '';
        }

        setValue('workType', 'OPEN');
        setValue('startDate', targetDate);
        setValue('endDate', targetDate);
        setValue('startTime', '');
        setValue('endTime', '');
        setValue('isRepeat', '1');
        setValue('memo', '');

        toggleRepeatOptions();

        document.getElementById('addModal').classList.remove('modal-hidden');
    }

    // 일정 추가 모달 닫기
    function closeAddModal() {
        document.getElementById("addModal").classList.add("modal-hidden");
    }

    // 일정 저장
    function saveSchedule() {
        var empNo = getValue('empNo');
        var empName = getValue('empName');
        var workType = getValue('workType');
        var startDate = getValue('startDate');
        var endDate = getValue('endDate');
        var startTime = getValue('startTime');
        var endTime = getValue('endTime');
        var isRepeat = getValue('isRepeat');

        if (isRepeat === '1') {
            endDate = startDate;
        }

        if (!validateScheduleInput(empNo, startDate, endDate, startTime, endTime, isRepeat)) {
            return;
        }

        var params = new URLSearchParams();

        params.append('action', 'add');
        params.append('empNo', empNo);
        params.append('empName', empName);
        params.append('workType', workType);
        params.append('startDate', startDate);
        params.append('endDate', endDate);
        params.append('startTime', startTime);
        params.append('endTime', endTime);
        params.append('isRepeat', isRepeat);
        params.append('memo', getValue('memo'));

        appendCheckedWeekdays(params);

        fetch('<%= request.getContextPath() %>/branch/hr/branchschedule', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(function (response) {
            if (!response.ok) {
                throw new Error('서버 응답 오류');
            }

            return response.json();
        })
        .then(function (result) {
            if (!result.success) {
                commonShowAlert('알림', result.message || '일정 추가에 실패했습니다.');
                return;
            }

            commonShowAlert('알림', result.message || '일정이 추가되었습니다.');
            location.reload();
        })
        .catch(function (error) {
            console.error(error);
            commonShowAlert('알림', '일정 추가 중 오류가 발생했습니다.');
        });
    }

    // 일정 추가 입력값 검증
    function validateScheduleInput(empNo, startDate, endDate, startTime, endTime, isRepeat) {
        if (!empNo) {
            commonShowAlert('알림', '직원을 선택해주세요.');
            return false;
        }

        if (!startDate || !endDate) {
            commonShowAlert('알림', '기간을 선택해주세요.');
            return false;
        }

        if (startDate > endDate) {
            commonShowAlert('알림', '종료 날짜는 시작 날짜보다 빠를 수 없습니다.');
            return false;
        }

        if (!startTime || !endTime) {
            commonShowAlert('알림', '근무 시간을 입력해주세요.');
            return false;
        }

        if (startTime >= endTime) {
            commonShowAlert('알림', '종료 시간은 시작 시간보다 늦어야 합니다.');
            return false;
        }

        if (isRepeat === '2') {
            var checkedDays = document.querySelectorAll('input[name="weekdayRepeat"]:checked');

            if (checkedDays.length === 0) {
                commonShowAlert('알림', '반복 요일을 선택해주세요.');
                return false;
            }
        }

        return true;
    }

    // 선택된 반복 요일을 요청 파라미터에 추가
    function appendCheckedWeekdays(params) {
        var checkedDays = document.querySelectorAll('input[name="weekdayRepeat"]:checked');

        for (var i = 0; i < checkedDays.length; i++) {
            params.append('weekdayRepeat', checkedDays[i].value);
        }
    }


    /************************************************************
     * 8. 반복 옵션 제어
     ************************************************************/

    // 반복 여부에 따라 종료일 / 요일 선택 영역 제어
    function toggleRepeatOptions() {
        var isRepeat = getValue('isRepeat');
        var weekdayOptions = document.getElementById('weekdayOptions');
        var startDate = document.getElementById('startDate');
        var endDate = document.getElementById('endDate');

        if (isRepeat === '1') {
            // 반복 없음: 하루 일정만 등록
            weekdayOptions.classList.add('hidden');

            endDate.value = startDate.value;
            endDate.disabled = true;

            clearWeekdayChecks();
            return;
        }

        if (isRepeat === '2') {
            // 매주 반복: 기간 + 요일 선택
            weekdayOptions.classList.remove('hidden');
            endDate.disabled = false;
            return;
        }

        if (isRepeat === '3') {
            // 매월 반복: 기간만 사용, 요일 선택 없음
            weekdayOptions.classList.add('hidden');
            endDate.disabled = false;

            clearWeekdayChecks();
        }
    }

    // 반복 요일 체크박스 초기화
    function clearWeekdayChecks() {
        var checks = document.querySelectorAll('input[name="weekdayRepeat"]');

        for (var i = 0; i < checks.length; i++) {
            checks[i].checked = false;
        }
    }

    // 시작일 변경 시 반복 없음이면 종료일도 시작일과 동일하게 변경
    function changeStartDate() {
        var isRepeat = getValue('isRepeat');
        var startDate = document.getElementById('startDate');
        var endDate = document.getElementById('endDate');

        if (isRepeat === '1') {
            endDate.value = startDate.value;
        }
    }


    /************************************************************
     * 9. 직원 검색 / 선택
     ************************************************************/

    // 일정 추가 모달에서 직원 이름 검색
    function searchEmployeesByName() {
        var keyword = document.getElementById('empName').value.trim();
        var container = document.getElementById('employeeCheckboxes');
        var list = document.getElementById('employeeList');

        document.getElementById('empNo').value = '';

        if (!keyword) {
            container.classList.add('hidden');
            list.innerHTML = '';
            return;
        }

        var filtered = employees.filter(function (employee) {
            return employee.name.includes(keyword);
        });

        var html = '';

        for (var i = 0; i < filtered.length; i++) {
            var emp = filtered[i];

            html += '<div onclick="selectEmployeeForSchedule(\'' + emp.id + '\', \'' + emp.name + '\')" class="flex items-center gap-2 p-2 hover:bg-gray-100 rounded cursor-pointer">';
            html += '<div class="w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center text-white text-xs font-semibold">' + emp.name.charAt(0) + '</div>';
            html += '<div class="text-sm">';
            html += '<span class="font-medium text-gray-900">' + emp.name + '</span>';
            html += '</div>';
            html += '</div>';
        }

        if (filtered.length === 0) {
            html = '<p class="text-sm text-gray-500 text-center py-4">검색된 직원이 없습니다</p>';
        }

        list.innerHTML = html;
        container.classList.remove('hidden');
    }

    // 직원 이름 입력 후 Enter 시 첫 번째 검색 결과 선택
    function selectFirstEmployeeByEnter(event) {
        event.preventDefault();

        var keyword = document.getElementById('empName').value.trim();

        if (!keyword) {
            return;
        }

        var filtered = employees.filter(function (employee) {
            return employee.name.includes(keyword);
        });

        if (filtered.length === 0) {
            commonShowAlert('알림', '검색된 직원이 없습니다.');
            return;
        }

        selectEmployeeForSchedule(filtered[0].id, filtered[0].name);
    }

    // 직원 선택 처리
    function selectEmployeeForSchedule(empNo, empName) {
        setValue('empNo', empNo);
        setValue('empName', empName);

        document.getElementById('employeeCheckboxes').classList.add('hidden');
    }


    /************************************************************
     * 10. 일정 상세 조회 / 수정 모달
     ************************************************************/

    // 일정 클릭 시 수정 모달 열기
    function viewSchedule(id) {
        var schedule = branchSchedules.find(function (item) {
            return String(item.id) === String(id);
        });

        if (!schedule) {
            commonShowAlert('알림', '일정을 찾을 수 없습니다.');
            return;
        }

        setEditScheduleValues(schedule);
        toggleRepeatEditButtons(schedule);

        document.getElementById('editModal').classList.remove('modal-hidden');
    }

    // 수정 모달에 일정 정보 세팅
    function setEditScheduleValues(schedule) {
        setValue('editEmpNo', schedule.employeeId || '');
        setValue('editBranchCode', schedule.branchCode || '');
        setValue('editScheduleId', schedule.id);
        setValue('editRepeatGroupId', schedule.repeatGroupId || '');
        setValue('editIsRepeat', schedule.isRepeat || '1');

        setValue('editEmployeeName', schedule.employee || '');
        setValue('editWorkType', schedule.type || 'OPEN');
        setValue('editWorkDate', schedule.workDate || '');
        setValue('editStartTime', formatTime(schedule.startTime));
        setValue('editEndTime', formatTime(schedule.endTime));
        setValue('editMemo', schedule.notes || '');
    }

    // 반복 일정 여부에 따라 반복 삭제 버튼 / 안내문 표시
    function toggleRepeatEditButtons(schedule) {
        var isRepeat = String(schedule.isRepeat) !== '1'
            && schedule.repeatGroupId !== null
            && schedule.repeatGroupId !== ''
            && schedule.repeatGroupId !== 'null'
            && schedule.repeatGroupId !== 'undefined';

        document.getElementById('editRepeatNotice').classList.toggle('hidden', !isRepeat);
        document.getElementById('deleteRepeatBtn').classList.toggle('hidden', !isRepeat);
    }

    // 수정 모달 닫기
    function closeEditModal() {
        document.getElementById('editModal').classList.add('modal-hidden');
    }

    // 일정 수정
    function updateSchedule(scope) {
        var scheduleId = getValue('editScheduleId');
        var empNo = getValue('editEmpNo');
        var branchCode = getValue('editBranchCode');
        var repeatGroupId = getValue('editRepeatGroupId');
        var workType = getValue('editWorkType');
        var isRepeat = getValue('editIsRepeat');
        var workDate = getValue('editWorkDate');
        var startTime = getValue('editStartTime');
        var endTime = getValue('editEndTime');
        var memo = getValue('editMemo');

        if (!validateEditScheduleInput(workDate, startTime, endTime)) {
            return;
        }

        var params = new URLSearchParams();

        params.append('action', 'modify');
        params.append('scope', scope);
        params.append('scheduleId', scheduleId);
        params.append('empNo', empNo);
        params.append('branchCode', branchCode);
        params.append('repeatGroupId', repeatGroupId);
        params.append('workType', workType);
        params.append('isRepeat', isRepeat);
        params.append('workDate', workDate);
        params.append('startTime', startTime);
        params.append('endTime', endTime);
        params.append('memo', memo);

        fetch('<%= request.getContextPath() %>/branch/hr/branchschedule', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(function (response) {
            return response.json();
        })
        .then(function (result) {
            if (!result.success) {
                commonShowAlert('알림', result.message || '일정 수정에 실패했습니다.');
                return;
            }

            updateScheduleLocally(scope, scheduleId, repeatGroupId, workType, workDate, startTime, endTime, memo);

            renderCalendar();
            closeEditModal();

            commonShowAlert('알림', result.message || '일정이 수정되었습니다.');
        })
        .catch(function (error) {
            console.error(error);
            commonShowAlert('알림', '일정 수정 중 오류가 발생했습니다.');
        });
    }

    // 수정 모달 입력값 검증
    function validateEditScheduleInput(workDate, startTime, endTime) {
        if (!workDate) {
            commonShowAlert('알림', '근무 날짜를 선택해주세요.');
            return false;
        }

        if (!startTime || !endTime) {
            commonShowAlert('알림', '근무 시간을 입력해주세요.');
            return false;
        }

        if (startTime >= endTime) {
            commonShowAlert('알림', '종료 시간은 시작 시간보다 늦어야 합니다.');
            return false;
        }

        return true;
    }

    // 수정 성공 후 화면 데이터도 갱신
    function updateScheduleLocally(scope, scheduleId, repeatGroupId, workType, workDate, startTime, endTime, memo) {
        if (scope === 'ONE') {
            var schedule = branchSchedules.find(function (item) {
                return String(item.id) === String(scheduleId);
            });

            if (schedule) {
                schedule.type = workType;
                schedule.title = workType;
                schedule.workDate = workDate;
                schedule.startTime = startTime;
                schedule.endTime = endTime;
                schedule.notes = memo;
            }

            return;
        }

        for (var i = 0; i < branchSchedules.length; i++) {
            if (String(branchSchedules[i].repeatGroupId) === String(repeatGroupId)) {
                branchSchedules[i].type = workType;
                branchSchedules[i].title = workType;
                branchSchedules[i].startTime = startTime;
                branchSchedules[i].endTime = endTime;
                branchSchedules[i].notes = memo;
            }
        }
    }

    // 일정 삭제
    function deleteSchedule(scope) {
        var scheduleId = getValue('editScheduleId');
        var repeatGroupId = getValue('editRepeatGroupId');

        if (!scheduleId) {
            commonShowAlert('알림', '삭제할 일정을 찾을 수 없습니다.');
            return;
        }

        var message = scope === 'ALL'
            ? '반복 일정 전체를 삭제하시겠습니까?'
            : '선택한 일정을 삭제하시겠습니까?';

        commonShowConfirm('확인', message, function () {
            requestDeleteSchedule(scope, scheduleId, repeatGroupId);
        });
    }

    // 일정 삭제 요청
    function requestDeleteSchedule(scope, scheduleId, repeatGroupId) {
        var params = new URLSearchParams();

        params.append('action', 'delete');
        params.append('scope', scope);
        params.append('scheduleId', scheduleId);
        params.append('repeatGroupId', repeatGroupId);

        fetch('<%= request.getContextPath() %>/branch/hr/branchschedule', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(function (response) {
            return response.json();
        })
        .then(function (result) {
            if (!result.success) {
                commonShowAlert('알림', result.message || '일정 삭제에 실패했습니다.');
                return;
            }

            deleteScheduleLocally(scope, scheduleId, repeatGroupId);

            renderCalendar();
            closeEditModal();

            commonShowAlert('알림', result.message || '일정이 삭제되었습니다.');
        })
        .catch(function (error) {
            console.error(error);
            commonShowAlert('알림', '일정 삭제 중 오류가 발생했습니다.');
        });
    }

    // 삭제 성공 후 화면 데이터에서도 제거
    function deleteScheduleLocally(scope, scheduleId, repeatGroupId) {
        if (scope === 'ONE') {
            branchSchedules = branchSchedules.filter(function (schedule) {
                return String(schedule.id) !== String(scheduleId);
            });

            return;
        }

        branchSchedules = branchSchedules.filter(function (schedule) {
            return String(schedule.repeatGroupId) !== String(repeatGroupId);
        });
    }


    /************************************************************
     * 11. 화면 선반영용 함수
     * 현재 saveSchedule()은 서버 저장 후 reload 방식이라 아래 함수들은
     * 직접 호출되지 않아도 삭제해도 됩니다.
     ************************************************************/

    // 입력값 기준으로 캘린더 배열에 임시 일정 추가
    function addScheduleToCalendarFromInput() {
        var empNo = getValue('empNo');
        var empName = getValue('empName');
        var workType = getValue('workType');
        var startDate = getValue('startDate');
        var endDate = getValue('endDate');
        var startTime = getValue('startTime');
        var endTime = getValue('endTime');
        var isRepeat = getValue('isRepeat');
        var memo = getValue('memo');

        if (isRepeat === '1') {
            branchSchedules.push({
                id: 'TEMP_' + new Date().getTime(),
                employeeId: empNo,
                employee: empName,
                workDate: startDate,
                type: workType,
                title: workType,
                startTime: startTime,
                endTime: endTime,
                isRepeat: isRepeat,
                repeatGroupId: '',
                notes: memo
            });

            return;
        }

        if (isRepeat === '2') {
            addWeeklySchedulesToCalendar(empNo, empName, workType, startDate, endDate, startTime, endTime, isRepeat, memo);
            return;
        }

        if (isRepeat === '3') {
            addMonthlySchedulesToCalendar(empNo, empName, workType, startDate, endDate, startTime, endTime, isRepeat, memo);
        }
    }

    // 매주 반복 일정을 화면 배열에 임시 추가
    function addWeeklySchedulesToCalendar(empNo, empName, workType, startDate, endDate, startTime, endTime, isRepeat, memo) {
        var checkedDays = document.querySelectorAll('input[name="weekdayRepeat"]:checked');
        var selectedDays = [];

        for (var i = 0; i < checkedDays.length; i++) {
            selectedDays.push(Number(checkedDays[i].value));
        }

        var repeatGroupId = 'TEMP_GROUP_' + new Date().getTime();

        var current = new Date(startDate);
        var last = new Date(endDate);

        while (current <= last) {
            var day = current.getDay();
            var weekdayValue = day === 0 ? 7 : day;

            if (selectedDays.includes(weekdayValue)) {
                branchSchedules.push(makeTempSchedule(empNo, empName, workType, current, startTime, endTime, isRepeat, repeatGroupId, memo));
            }

            current.setDate(current.getDate() + 1);
        }
    }

    // 매월 반복 일정을 화면 배열에 임시 추가
    function addMonthlySchedulesToCalendar(empNo, empName, workType, startDate, endDate, startTime, endTime, isRepeat, memo) {
        var repeatGroupId = 'TEMP_GROUP_' + new Date().getTime();

        var start = new Date(startDate);
        var last = new Date(endDate);
        var targetDay = start.getDate();
        var current = new Date(start);

        while (current <= last) {
            if (current.getDate() === targetDay) {
                branchSchedules.push(makeTempSchedule(empNo, empName, workType, current, startTime, endTime, isRepeat, repeatGroupId, memo));
            }

            current.setMonth(current.getMonth() + 1);
        }
    }

    // 임시 일정 객체 생성
    function makeTempSchedule(empNo, empName, workType, date, startTime, endTime, isRepeat, repeatGroupId, memo) {
        var dateStr = formatDate(date);

        return {
            id: 'TEMP_' + dateStr + '_' + new Date().getTime(),
            employeeId: empNo,
            employee: empName,
            workDate: dateStr,
            type: workType,
            title: workType,
            startTime: startTime,
            endTime: endTime,
            isRepeat: isRepeat,
            repeatGroupId: repeatGroupId,
            notes: memo
        };
    }
</script>
<!-- custom date picker element -->
<div id="customDatePicker" class="custom-date-picker hidden" onclick="event.stopPropagation()">
    <div class="custom-date-picker-header">
        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(-1)">
            <i class="fas fa-chevron-left text-xs"></i>
        </button>

        <div style="display:flex;align-items:center;gap:8px;">
            <select id="customDatePickerYear" onchange="changeCustomPickerYearMonth()" class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold outline-none"></select>
            <select id="customDatePickerMonth" onchange="changeCustomPickerYearMonth()" class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold outline-none"></select>
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
// Shared custom date picker for schedule modals
(function(){
    function pad(n){ return String(n).padStart(2,'0'); }
    function parseDateLocal(dateStr) { if (!dateStr) return null; var parts = String(dateStr).split('-'); if (parts.length !== 3) return null; return new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2])); }
    function formatDateLocal(date) { return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate()); }

    var customDateTargetId = null;
    var customPickerDate = new Date();

    window.openCustomDatePicker = function(inputId, event) {
        if (event) event.stopPropagation();
        var input = document.getElementById(inputId); if (!input) return;
        customDateTargetId = inputId; var selected = parseDateLocal(input.value); customPickerDate = selected || new Date(); renderCustomDatePicker(); positionCustomDatePicker(input);
        document.getElementById('customDatePicker').classList.remove('hidden');
    };

    window.changeCustomPickerMonth = function(amount) { customPickerDate.setMonth(customPickerDate.getMonth() + amount); renderCustomDatePicker(); };
    window.changeCustomPickerYearMonth = function() { var ys = document.getElementById('customDatePickerYear'); var ms = document.getElementById('customDatePickerMonth'); customPickerDate = new Date(Number(ys.value), Number(ms.value), 1); renderCustomDatePicker(); };

    function renderCustomPickerYearMonthSelect(year, month) {
        var yearSelect = document.getElementById('customDatePickerYear'); var monthSelect = document.getElementById('customDatePickerMonth'); var htmlY='';
        for (var y = year - 10; y <= year + 10; y++) htmlY += '<option value="'+y+'"' + (y===year? ' selected': '') + '>' + y + '년</option>';
        var htmlM=''; for (var m=0;m<12;m++) htmlM += '<option value="'+m+'"' + (m===month? ' selected': '') + '>' + (m+1) + '월</option>';
        yearSelect.innerHTML = htmlY; monthSelect.innerHTML = htmlM;
    }

    function renderCustomDatePicker() {
        var year = customPickerDate.getFullYear(); var month = customPickerDate.getMonth(); renderCustomPickerYearMonthSelect(year, month);
        var firstDay = new Date(year, month, 1); var lastDay = new Date(year, month+1, 0); var prevLast = new Date(year, month, 0);
        var startDay = firstDay.getDay(); var days = [];
        for (var i = startDay - 1; i >= 0; i--) days.push({ date: new Date(year, month - 1, prevLast.getDate() - i), currentMonth: false });
        for (var d = 1; d <= lastDay.getDate(); d++) days.push({ date: new Date(year, month, d), currentMonth: true });
        var nextDay = 1; while (days.length < 42) { days.push({ date: new Date(year, month+1, nextDay), currentMonth: false }); nextDay++; }
        var targetInput = customDateTargetId ? document.getElementById(customDateTargetId) : null; var selectedValue = targetInput ? targetInput.value : ''; var todayValue = formatDateLocal(new Date());
        var html=''; for (var j=0;j<days.length;j++){ var dateValue = formatDateLocal(days[j].date); var className='custom-date-day'; if (!days[j].currentMonth) className += ' other-month'; if (dateValue === todayValue) className += ' today'; if (dateValue === selectedValue) className += ' selected'; html += '<button type="button" class="' + className + '" onclick="selectCustomDate(\'' + dateValue + '\')">' + days[j].date.getDate() + '</button>'; }
        document.getElementById('customDatePickerDays').innerHTML = html;
    }

    window.selectCustomDate = function(dateValue) {
        if (!customDateTargetId) return; var input = document.getElementById(customDateTargetId); if (!input) return; input.value = dateValue;
        // if selecting startDate, ensure endDate not earlier and trigger changeStartDate()
        if (customDateTargetId === 'startDate') {
            var edEl = document.getElementById('endDate'); if (edEl) {
                var sd = parseDateLocal(dateValue); var ed = parseDateLocal(edEl.value);
                if (!ed || ed < sd) { edEl.value = dateValue; }
            }
            if (typeof changeStartDate === 'function') changeStartDate();
        } else if (customDateTargetId === 'endDate') {
            var sdEl = document.getElementById('startDate'); if (sdEl) {
                var ed = parseDateLocal(dateValue); var sd = parseDateLocal(sdEl.value);
                if (!sd || sd > ed) { sdEl.value = dateValue; if (typeof changeStartDate === 'function') changeStartDate(); }
            }
        }

        closeCustomDatePicker();
    };

    function positionCustomDatePicker(input) {
        var picker = document.getElementById('customDatePicker'); var rect = input.getBoundingClientRect(); var pickerWidth = 340; var pickerHeight = 320;
        var top = rect.bottom + 6; var left = rect.left; picker.style.width = pickerWidth + 'px';
        if (left + pickerWidth > window.innerWidth) left = window.innerWidth - pickerWidth - 12;
        if (top + pickerHeight > window.innerHeight) top = rect.top - pickerHeight - 6;
        picker.style.top = top + 'px'; picker.style.left = left + 'px';
    }

    function closeCustomDatePicker() { var p = document.getElementById('customDatePicker'); if (p) p.classList.add('hidden'); customDateTargetId = null; }
    document.addEventListener('mousedown', function(event){ var picker = document.getElementById('customDatePicker'); if (!picker || picker.classList.contains('hidden')) return; if (picker.contains(event.target)) return; if (customDateTargetId && document.getElementById(customDateTargetId) && document.getElementById(customDateTargetId).contains(event.target)) return; closeCustomDatePicker(); });

})();
</script>
</body>
</html>
