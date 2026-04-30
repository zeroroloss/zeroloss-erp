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
	.day-header {padding: 12px 8px; text-align: center; font-size: 13px; font-weight: 700; color: #374151; border-right: 1px solid #e5e7eb;}
	.day-header:last-child { border-right: 0;}	
	.day-cell {min-height: 120px; border-top: 1px solid #e5e7eb; border-right: 1px solid #e5e7eb; background: white;}
	.day-cell:nth-child(7n) {border-right: 0;}
	.other-month {background: #f9fafb; color: #9ca3af;}
	.today {background: #ecfdf5;}
	.schedule-event {margin-top: 4px; padding: 3px 6px; border-radius: 6px; font-size: 12px; color: white; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;}
	.type-OPEN {background: #00853D;}
	.type-MIDDLE {background: #2563eb;}
	.type-CLOSE {background: #9333ea;}
	.type-OFF {background: #6b7280;}

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
    <%@ include file="/branch/common/layout/topbar.jsp" %>
    
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
          			
          			<!-- 필터 -->
			        <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
			          <div class="flex flex-col gap-4">
			
			            <div class="flex items-center justify-between gap-4">
			              <div>
			                <h3 class="text-sm font-semibold text-gray-800">직원 검색</h3>
			                <p class="text-xs text-gray-500 mt-1">사번, 이름, 역할 기준으로 검색할 수 있습니다.</p>
			              </div>
			
			              <div class="flex items-center gap-2">
			                <div class="relative w-80">
			                  <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-sm"></i>
			                  <input type="text" id="searchInput" onkeydown="if(event.key === 'Enter') applyFilters();" placeholder="검색어를 입력하세요" class="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
			                </div>
			                <button type="button" onclick="applyFilters()" class="px-5 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">조회</button>
			                <button type="button" onclick="resetFilters()" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">초기화</button>
			              </div>
			            </div>
			          </div>
			        </div>
			        
			        <!-- 캘린더 컨트롤 -->
                    <div class="bg-white rounded-lg border border-gray-200 p-4">
                        <div class="flex items-center justify-between mb-6">
                            <div class="flex items-center gap-4">
                                <button onclick="previousPeriod()" class="p-2 rounded-lg hover:bg-gray-100">
                                    <i class="fas fa-chevron-left w-5 h-5"></i>
                                </button>
                                
                                <h3 id="monthTitle" class="text-lg font-semibold text-gray-900 min-w-64 text-center">2026년 4월</h3>
                                <button onclick="nextPeriod()" class="p-2 rounded-lg hover:bg-gray-100">
                                    <i class="fas fa-chevron-right w-5 h-5"></i>
                                </button>
                            </div>
                            <div>
                                <button onclick="goToday()"
							        class="px-4 py-2 text-sm font-medium bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors">
							        오늘
							    </button>
                            </div>
                        </div>

                        <!-- 캘린더 범례 -->
                        <div class="flex items-center gap-6 mb-4 flex-wrap text-sm">
                            <div class="flex items-center gap-2">
                                <div class="w-3 h-3 bg-green-500 rounded-full"></div>
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
                                <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                                <span class="text-gray-600">휴무</span>
                            </div>
                        </div>

                        <!-- 캘린더 그리드 -->
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
                                <!-- 동적으로 생성됨 -->
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
			repeatGroupId: "${repeatGroupId}",
			notes: "${s.memo}"
		}<c:if test="${!st.last}">,</c:if>
		</c:forEach>
	];
	
	var currentDate = new Date();
    var employees = [
    	<c:forEach var="e" items="${hqEmployeeList}" varStatus="st">
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

            for (var k = 0; k < Math.min(daySchedules.length, 3); k++) {
                var s = daySchedules[k];
                var empName = s.employee.substring(0, 3);

                html += '<div class="schedule-event type-' + s.type + '" onclick="event.stopPropagation(); viewSchedule(\'' + s.id + '\')" title="' + s.employee + ' - ' + s.type + '">';
                html += '<span class="text-xs font-semibold">' + empName + '</span> <span class="text-xs">' + s.type + '</span>';
                html += '</div>';
            }

            if (daySchedules.length > 3) {
                html += '<div class="text-xs text-gray-600 text-center font-medium mt-1">+' + (daySchedules.length - 3) + '개 더보기</div>';
            }

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
    
    function closeAddModal() {
    	document.getElementById("addModal").classList.add("modal-hidden");
    }
    
    function toggleRepeatOptions() {
        var isRepeat = document.getElementById('isRepeat').value;
        var weekdayOptions = document.getElementById('weekdayOptions');

        if (isRepeat === '2') {
            weekdayOptions.classList.remove('hidden');
        } else {
            weekdayOptions.classList.add('hidden');

            var checks = document.querySelectorAll('input[name="weekdayRepeat"]');
            for (var i = 0; i < checks.length; i++) {
                checks[i].checked = false;
            }
        }
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
            html += '<span class="text-gray-500 ml-1">(' + (emp.dept || '-') + ')</span>';
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
            alert('검색된 직원이 없습니다.');
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
        renderCalendar();
    }
    
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        renderCalendar();
    }
    
    function viewSchedule(id) {
        var schedule = branchSchedules.find(function(s) {
            return String(s.id) === String(id);
        });

        if (!schedule) {
            alert('일정을 찾을 수 없습니다.');
            return;
        }

        document.getElementById('editScheduleId').value = schedule.id;
        document.getElementById('editRepeatGroupId').value = schedule.repeatGroupId || '';
        document.getElementById('editIsRepeat').value = schedule.isRepeat || '1';

        document.getElementById('editEmployeeName').value = schedule.employee || '';
        document.getElementById('editWorkType').value = schedule.type || 'OPEN';
        document.getElementById('editWorkDate').value = schedule.workDate || '';
        document.getElementById('editStartTime').value = schedule.startTime || '';
        document.getElementById('editEndTime').value = schedule.endTime || '';
        document.getElementById('editMemo').value = schedule.notes || '';

        var isRepeat = String(schedule.isRepeat) !== '1';

        document.getElementById('editRepeatNotice').classList.toggle('hidden', !isRepeat);
        document.getElementById('deleteRepeatBtn').classList.toggle('hidden', !isRepeat);
        document.getElementById('updateRepeatBtn').classList.toggle('hidden', !isRepeat);

        document.getElementById('editModal').classList.remove('modal-hidden');
    }
</script>
</body>
</html>
