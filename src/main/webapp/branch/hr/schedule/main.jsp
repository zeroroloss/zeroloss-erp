<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dto.AccountDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
	.type-OFF {background: #6b7280;}
	.employee-name-link {cursor: pointer; text-decoration: underline; text-underline-offset: 2px; font-weight: 600}
	.employee-name-link:hover {opacity: 0.8;}

    .modal-overlay { position: fixed; inset: 0; background: transparent; display: none; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box; z-index: 2000; }
    .modal-overlay.open { display: flex; }
    .modal-frame { width: min(820px, 100%); height: min(92vh, 920px); border: 0; border-radius: 16px; background: transparent; box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22); }
    .modal-close { position: absolute; top: 18px; right: 18px; width: 36px; height: 36px; border: 0; border-radius: 999px; background: #fff; color: #374151; font-size: 22px; line-height: 36px; cursor: pointer; z-index: 2001; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12); }
	.modal-hidden {display: none !important;}

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
					
					                <div class="flex items-center gap-2">
					                    <div class="w-3 h-3 bg-gray-500 rounded-full"></div>
					                    <span class="text-gray-600">휴무</span>
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
	
	var currentDate = new Date();
	var isSearched = false;
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
    
    window.addEventListener('DOMContentLoaded', function() {
    	renderCalendar();
    	
    	var addBtn = document.getElementById("openAddScheduleModal");
    	addBtn.addEventListener("click", function() {
    	    showAddModal();
    	});
    });
    
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
    
    function renderCalendar() {
        var year = currentDate.getFullYear();
        var month = currentDate.getMonth();
        var currentSchedules = getFilteredSchedules();

        document.getElementById('monthTitle').textContent = year + '년 ' + (month + 1) + '월';

        var dayHeaders = document.getElementById('dayHeaders');
        dayHeaders.innerHTML =
            '<div class="day-header">일</div>' +
            '<div class="day-header">월</div>' +
            '<div class="day-header">화</div>' +
            '<div class="day-header">수</div>' +
            '<div class="day-header">목</div>' +
            '<div class="day-header">금</div>' +
            '<div class="day-header">토</div>';

        var days = [];
        var firstDay = new Date(year, month, 1);
        var lastDay = new Date(year, month + 1, 0);
        var prevLastDay = new Date(year, month, 0);
        var startDay = firstDay.getDay();

        for (var i = startDay - 1; i >= 0; i--) {
            var prevDate = prevLastDay.getDate() - i;
            days.push({
                day: prevDate,
                currentMonth: false,
                date: new Date(year, month - 1, prevDate)
            });
        }

        for (var d = 1; d <= lastDay.getDate(); d++) {
            days.push({
                day: d,
                currentMonth: true,
                date: new Date(year, month, d)
            });
        }

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

        var html = '';

        for (var j = 0; j < days.length; j++) {
            var dayObj = days[j];

            var dateStr =
                dayObj.date.getFullYear() + '-' +
                String(dayObj.date.getMonth() + 1).padStart(2, '0') + '-' +
                String(dayObj.date.getDate()).padStart(2, '0');

            var daySchedules = currentSchedules.filter(function(s) {
                return s.workDate === dateStr;
            });

            var isToday = new Date().toLocaleDateString() === dayObj.date.toLocaleDateString();

            var cellClass =
                'day-cell p-2 cursor-pointer hover:bg-blue-50 ' +
                (dayObj.currentMonth ? '' : 'other-month ') +
                (isToday ? 'today' : '');

            html += '<div class="' + cellClass + '" style="min-height:120px;" onclick="selectDateForModal(\'' + dateStr + '\')">';
            html += '<div class="text-xs font-medium mb-1 text-gray-900">' + dayObj.day + '</div>';

            var openSchedules = [];
            var middleSchedules = [];
            var closeSchedules = [];

            for (var k = 0; k < daySchedules.length; k++) {
                var s = daySchedules[k];

                if (s.type === 'OPEN') {
                    openSchedules.push(s);
                } else if (s.type === 'MIDDLE') {
                    middleSchedules.push(s);
                } else if (s.type === 'CLOSE') {
                    closeSchedules.push(s);
                }
            }
            
            html += '<div class="mt-2 space-y-1 text-xs">';

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
            html += '</div>';
        }

        var container = document.getElementById('calendarContainer');
        container.innerHTML = html;
        container.style.gridTemplateColumns = 'repeat(7, 1fr)';
        dayHeaders.style.gridTemplateColumns = 'repeat(7, 1fr)';
    }
    
    function showAddModal(selectedDate) {
    	var today = new Date();
        var todayStr =
            today.getFullYear() + '-' +
            String(today.getMonth() + 1).padStart(2, '0') + '-' +
            String(today.getDate()).padStart(2, '0');

        var targetDate = selectedDate || todayStr;

        document.getElementById('empName').value = '';
        document.getElementById('empNo').value = '';
        document.getElementById('employeeCheckboxes').classList.add('hidden');
        document.getElementById('employeeList').innerHTML = '';

        document.getElementById('workType').value = 'OPEN';
        document.getElementById('startDate').value = targetDate;
        document.getElementById('endDate').value = targetDate;
        document.getElementById('startTime').value = '';
        document.getElementById('endTime').value = '';
        document.getElementById('isRepeat').value = '1';
        document.getElementById('memo').value = '';

        toggleRepeatOptions();

        document.getElementById('addModal').classList.remove('modal-hidden');
    }
    
    function toggleRepeatOptions() {
        var isRepeat = document.getElementById('isRepeat').value;
        var weekdayOptions = document.getElementById('weekdayOptions');

        var startDate = document.getElementById('startDate');
        var endDate = document.getElementById('endDate');

        if (isRepeat === '1') {
            // 반복 없음: 하루 일정만 등록
            weekdayOptions.classList.add('hidden');

            endDate.value = startDate.value;
            endDate.disabled = true;

            clearWeekdayChecks();

        } else if (isRepeat === '2') {
            // 매주 반복: 기간 + 요일 선택
            weekdayOptions.classList.remove('hidden');

            endDate.disabled = false;

        } else if (isRepeat === '3') {
            // 매월 반복: 기간만 사용, 요일 선택 없음
            weekdayOptions.classList.add('hidden');

            endDate.disabled = false;

            clearWeekdayChecks();
        }
    }
    
    function clearWeekdayChecks() {
        var checks = document.querySelectorAll('input[name="weekdayRepeat"]');

        for (var i = 0; i < checks.length; i++) {
            checks[i].checked = false;
        }
    }
    
    function changeStartDate() {
        var isRepeat = document.getElementById('isRepeat').value;
        var startDate = document.getElementById('startDate');
        var endDate = document.getElementById('endDate');

        if (isRepeat === '1') {
            endDate.value = startDate.value;
        }
    }
    
    function closeAddModal() {
        document.getElementById("addModal").classList.add("modal-hidden");
    }
    
    function saveSchedule() {
    	var empNo = document.getElementById('empNo').value;
        var empName = document.getElementById('empName').value;
        var workType = document.getElementById('workType').value;
        var startDate = document.getElementById('startDate').value;
        var endDate = document.getElementById('endDate').value;
        var startTime = document.getElementById('startTime').value;
        var endTime = document.getElementById('endTime').value;
        var isRepeat = document.getElementById('isRepeat').value;
        
        if (isRepeat === '1') {
            endDate = startDate;
        }

        if (!empNo) {
            commonShowAlert('알림', '직원을 선택해주세요.');
            return;
        }

        if (!startDate || !endDate) {
            commonShowAlert('알림', '기간을 선택해주세요.');
            return;
        }

        if (startDate > endDate) {
            commonShowAlert('알림', '종료 날짜는 시작 날짜보다 빠를 수 없습니다.');
            return;
        }

        if (!startTime || !endTime) {
            commonShowAlert('알림', '근무 시간을 입력해주세요.');
            return;
        }

        if (startTime >= endTime) {
            commonShowAlert('알림', '종료 시간은 시작 시간보다 늦어야 합니다.');
            return;
        }

        if (isRepeat === '2') {
            var checkedDays = document.querySelectorAll('input[name="weekdayRepeat"]:checked');

            if (checkedDays.length === 0) {
                commonShowAlert('알림', '반복 요일을 선택해주세요.');
                return;
            }
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
        params.append('memo', document.getElementById('memo').value);

        var checkedDays = document.querySelectorAll('input[name="weekdayRepeat"]:checked');

        for (var i = 0; i < checkedDays.length; i++) {
            params.append('weekdayRepeat', checkedDays[i].value);
        }

        fetch('<%= request.getContextPath() %>/branch/hr/branchschedule', {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('서버 응답 오류');
            }

            return response.json();
        })
        .then(function(result) {
            if (!result.success) {
                commonShowAlert('알림', result.message || '일정 추가에 실패했습니다.');
                return;
            }

            commonShowAlert('알림', result.message || '일정이 추가되었습니다.');
            location.reload();
        })
        .catch(function(error) {
            console.error(error);
            commonShowAlert('알림', '일정 추가 중 오류가 발생했습니다.');
        });
    }
    
    function addWeeklyRepeatSchedules(tempId, empNo, empName, workType, startDate, endDate, startTime, endTime, isRepeat, memo) {
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

            var weekdayValue;
            if (day === 0) {
                weekdayValue = 7;
            } else {
                weekdayValue = day;
            }

            if (selectedDays.includes(weekdayValue)) {
                var dateStr =
                    current.getFullYear() + '-' +
                    String(current.getMonth() + 1).padStart(2, '0') + '-' +
                    String(current.getDate()).padStart(2, '0');

                branchSchedules.push({
                    id: tempId + '_' + dateStr,
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
                });
            }

            current.setDate(current.getDate() + 1);
        }
    }
    
    function addScheduleToCalendarFromInput() {
        var empNo = document.getElementById('empNo').value;
        var empName = document.getElementById('empName').value;
        var workType = document.getElementById('workType').value;
        var startDate = document.getElementById('startDate').value;
        var endDate = document.getElementById('endDate').value;
        var startTime = document.getElementById('startTime').value;
        var endTime = document.getElementById('endTime').value;
        var isRepeat = document.getElementById('isRepeat').value;
        var memo = document.getElementById('memo').value;

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
            return;
        }
    }
    
    // 매주 반복
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

            var weekdayValue;
            if (day === 0) {
                weekdayValue = 7;
            } else {
                weekdayValue = day;
            }

            if (selectedDays.includes(weekdayValue)) {
                var dateStr =
                    current.getFullYear() + '-' +
                    String(current.getMonth() + 1).padStart(2, '0') + '-' +
                    String(current.getDate()).padStart(2, '0');

                branchSchedules.push({
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
                });
            }

            current.setDate(current.getDate() + 1);
        }
    }
    
    // 매월 반복
    function addMonthlySchedulesToCalendar(empNo, empName, workType, startDate, endDate, startTime, endTime, isRepeat, memo) {
	    var repeatGroupId = 'TEMP_GROUP_' + new Date().getTime();
	
	    var start = new Date(startDate);
	    var last = new Date(endDate);
	
	    var targetDay = start.getDate();
	    var current = new Date(start);
	
	    while (current <= last) {
	        if (current.getDate() === targetDay) {
	            var dateStr =
	                current.getFullYear() + '-' +
	                String(current.getMonth() + 1).padStart(2, '0') + '-' +
	                String(current.getDate()).padStart(2, '0');
	
	            branchSchedules.push({
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
	            });
	        }
	
	        current.setMonth(current.getMonth() + 1);
	    }
	}
    
    function updateSchedule(scope) {
        var scheduleId = document.getElementById('editScheduleId').value;
        var empNo = document.getElementById('editEmpNo').value;
        var branchCode = document.getElementById('editBranchCode').value;
        var repeatGroupId = document.getElementById('editRepeatGroupId').value;
        var workType = document.getElementById('editWorkType').value;
        var isRepeat = document.getElementById('editIsRepeat').value;
        var workDate = document.getElementById('editWorkDate').value;
        var startTime = document.getElementById('editStartTime').value;
        var endTime = document.getElementById('editEndTime').value;
        var memo = document.getElementById('editMemo').value;

        if (!workDate) {
            commonShowAlert('알림', '근무 날짜를 선택해주세요.');
            return;
        }

        if (!startTime || !endTime) {
            commonShowAlert('알림', '근무 시간을 입력해주세요.');
            return;
        }

        if (startTime >= endTime) {
            commonShowAlert('알림', '종료 시간은 시작 시간보다 늦어야 합니다.');
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
        .then(function(response) {
            return response.json();
        })
        .then(function(result) {
            if (!result.success) {
                commonShowAlert('알림', result.message || '일정 수정에 실패했습니다.');
                return;
            }

            if (scope === 'ONE') {
                var schedule = branchSchedules.find(function(s) {
                    return String(s.id) === String(scheduleId);
                });

                if (schedule) {
                    schedule.type = workType;
                    schedule.title = workType;
                    schedule.workDate = workDate;
                    schedule.startTime = startTime;
                    schedule.endTime = endTime;
                    schedule.notes = memo;
                }
            } else {
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

            renderCalendar();
            closeEditModal();

            commonShowAlert('알림', result.message || '일정이 수정되었습니다.');
        })
        .catch(function(error) {
            console.error(error);
            commonShowAlert('알림', '일정 수정 중 오류가 발생했습니다.');
        });
    }
    
    function deleteSchedule(scope) {
        var scheduleId = document.getElementById('editScheduleId').value;
        var repeatGroupId = document.getElementById('editRepeatGroupId').value;

        if (!scheduleId) {
            commonShowAlert('알림', '삭제할 일정을 찾을 수 없습니다.');
            return;
        }

        var message = scope === 'ALL'
            ? '반복 일정 전체를 삭제하시겠습니까?'
            : '선택한 일정을 삭제하시겠습니까?';

        commonShowConfirm('확인', message, async function() {

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
        .then(function(response) {
            return response.json();
        })
        .then(function(result) {
            if (!result.success) {
                commonShowAlert('알림', result.message || '일정 삭제에 실패했습니다.');
                return;
            }

            if (scope === 'ONE') {
                branchSchedules = branchSchedules.filter(function(s) {
                    return String(s.id) !== String(scheduleId);
                });
            } else {
                branchSchedules = branchSchedules.filter(function(s) {
                    return String(s.repeatGroupId) !== String(repeatGroupId);
                });
            }

            renderCalendar();
            closeEditModal();

            commonShowAlert('알림', result.message || '일정이 삭제되었습니다.');
        })
        .catch(function(error) {
            console.error(error);
            commonShowAlert('알림', '일정 삭제 중 오류가 발생했습니다.');
        });
    }
    
    function closeEditModal() {
        document.getElementById('editModal').classList.add('modal-hidden');
    }
    
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

        var filtered = employees.filter(function(e) {
            return e.name.includes(keyword);
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
    
    function selectFirstEmployeeByEnter(event) {
        event.preventDefault();

        var keyword = document.getElementById('empName').value.trim();

        if (!keyword) {
            return;
        }

        var filtered = employees.filter(function(e) {
            return e.name.includes(keyword);
        });

        if (filtered.length === 0) {
            commonShowAlert('알림', '검색된 직원이 없습니다.');
            return;
        }

        var emp = filtered[0];

        selectEmployeeForSchedule(emp.id, emp.name);
    }
    
    function selectEmployeeForSchedule(empNo, empName) {
        document.getElementById('empNo').value = empNo;
        document.getElementById('empName').value = empName;
        document.getElementById('employeeCheckboxes').classList.add('hidden');
    }
    
    function getFilteredSchedules() {
    	if(!isSearched) {
    		return [];
    	}
    	
        var keyword = document.getElementById('searchInput').value.trim();
        var schedules = branchSchedules;

        if (!keyword) {
            return schedules;
        }

        return schedules.filter(function(s) {
            return String(s.employeeId || '').includes(keyword)
                || String(s.employee || '').includes(keyword)
                || String(s.branch || '').includes(keyword)
                || String(s.type || '').includes(keyword);
        });
    }
    
    function previousPeriod() {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
    }

    function nextPeriod() {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
    }
    
	 // 오늘로 이동
    function goToday() {
        currentDate = new Date();
        renderCalendar();
    }
	 
    function selectDateForModal(dateStr) {
        showAddModal(dateStr);
    }
    
    function applyFilters() {
    	isSearched = true;
        renderCalendar();
    }
    
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        isSearched = false;
        renderCalendar();
    }
    
    function viewSchedule(id) {
        var schedule = branchSchedules.find(function(s) {
            return String(s.id) === String(id);
        });

        if (!schedule) {
            commonShowAlert('알림', '일정을 찾을 수 없습니다.');
            return;
        }

        document.getElementById('editEmpNo').value = schedule.employeeId || '';
        document.getElementById('editBranchCode').value = schedule.branchCode || '';
        document.getElementById('editScheduleId').value = schedule.id;
        document.getElementById('editRepeatGroupId').value = schedule.repeatGroupId || '';
        document.getElementById('editIsRepeat').value = schedule.isRepeat || '1';

        document.getElementById('editEmployeeName').value = schedule.employee || '';
        document.getElementById('editWorkType').value = schedule.type || 'OPEN';
        document.getElementById('editWorkDate').value = schedule.workDate || '';
        document.getElementById('editStartTime').value = (schedule.startTime || '').substring(0, 5);
        document.getElementById('editEndTime').value = (schedule.endTime || '').substring(0, 5);
        document.getElementById('editMemo').value = schedule.notes || '';

        var isRepeat = String(schedule.isRepeat) !== '1'
            && schedule.repeatGroupId !== null
            && schedule.repeatGroupId !== ''
            && schedule.repeatGroupId !== 'null'
            && schedule.repeatGroupId !== 'undefined';

        document.getElementById('editRepeatNotice').classList.toggle('hidden', !isRepeat);
        document.getElementById('deleteRepeatBtn').classList.toggle('hidden', !isRepeat);

        document.getElementById('editModal').classList.remove('modal-hidden');
    }
</script>
</body>
</html>
