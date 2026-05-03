<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직원 일정 관리 - ZERO LOSS 본사 관리 시스템</title>
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
	    .calendar-grid {
	        display: grid;
	        grid-template-columns: repeat(7, 1fr);
	        gap: 0;
	    }
	    .day-cell {
	        border: 1px solid #e5e7eb;
	        padding: 8px;
	        overflow: hidden;
	        overflow-y: auto;
	    }
	    .day-cell.other-month {
	        background-color: #f9fafb;
	    }
	    .day-cell.today {
	        background-color: #ecfdf3;
	        border-left: 3px solid #00853D;
	    }
	    .day-header {
	        text-align: center;
	        padding: 12px 8px;
	        font-weight: 600;
	        border-bottom: 2px solid #e5e7eb;
	        background-color: #f3f4f6;
	        font-size: 14px;
	        color: #374151;
	    }
	    .schedule-event {
	        font-size: 12px;
	        padding: 6px;
	        margin-bottom: 4px;
	        border-radius: 4px;
	        color: white;
	        cursor: pointer;
	        transition: opacity 0.2s;
	    }
	    .schedule-event:hover {
	        opacity: 0.9;
	    }
	    .employee-name-link {
		    cursor: pointer;
		    text-decoration: underline;
		    text-underline-offset: 2px;
		    font-weight: 600;
		}
		
		.employee-name-link:hover {
		    opacity: 0.8;
		}
		.readonly-gray,
		.readonly-gray:disabled,
		.readonly-gray[readonly] {
		    background-color: #f3f4f6 !important;
		    color: #6b7280 !important;
		    cursor: not-allowed !important;
		}
	    .type-OFF { background-color: #10b981; }
	    .type-TRAINING { background-color: #a855f7; }
	    .type-VISIT { background-color: #DC2626; }
	    .type-BUSINESS_TRIP { background-color: #3b82f6; }
	    .type-OPEN { background-color: #00853D; }
		.type-MIDDLE { background-color: #2563eb; }
		.type-CLOSE { background-color: #9333ea; }
	
	    /* 수정 모달 전용 */
	    .modal-input,
	    .modal-select,
	    .modal-textarea {
	        width: 100%;
	        border: 1px solid #d1d5db;
	        border-radius: 0.5rem;
	        padding: 0.625rem 0.875rem;
	        font-size: 0.875rem;
	        outline: none;
	        transition: all 0.2s;
	        background: #fff;
	    }
	    .modal-input:focus,
	    .modal-select:focus,
	    .modal-textarea:focus {
	        border-color: #00853D;
	        box-shadow: 0 0 0 3px rgba(0, 133, 61, 0.12);
	    }
	    .modal-textarea {
	        min-height: 96px;
	        resize: none;
	    }
	    .modal-readonly {
	        background-color: #f3f4f6;
	        color: #6b7280;
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
                            <h2 class="text-3xl font-bold text-gray-900">직원 일정 관리</h2>
                            <p class="text-gray-500 mt-1">모든 매장 및 본사 직원의 일정을 통합 관리합니다</p>
                        </div>
                        <div class="flex items-center gap-2">
					        <button
							    type="button"
							    id="hqScheduleBtn"
							    onclick="changeScheduleView('hq')"
							    class="flex items-center gap-2 bg-[#00853D] text-white border border-[#00853D] px-4 py-2.5 rounded-lg transition-colors">
							    <i class="fas fa-building w-5 h-5"></i>
							    <span>본사 스케줄 조회</span>
							</button>
					
							<button
							    type="button"
							    id="branchScheduleBtn"
							    onclick="changeScheduleView('branch')"
							    class="flex items-center gap-2 bg-white text-[#00853D] border border-[#00853D] px-4 py-2.5 rounded-lg hover:bg-[#00853D] hover:text-white transition-colors">
							    <i class="fas fa-store w-5 h-5"></i>
							    <span>직영점 스케줄 조회</span>
							</button>
					
					        <button id="addScheduleBtn" onclick="showAddModal()" class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2.5 rounded-lg hover:bg-[#006B2F] transition-colors">
					            <i class="fas fa-plus w-5 h-5"></i>
					            <span>일정 추가</span>
					        </button>
					    </div>
					</div>

                    <!-- 필터 섹션 -->
                    <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
                        <div class="flex flex-col gap-4">
                            <!-- 검색 -->
                            <div class="flex items-center justify-between gap-4">
                            	<div>
                            		<h3 class="text-sm font-semibold text-gray-800">직원 검색</h3>
                            		<p class="text-xs text-gray-500 mt-1">사번, 이름 기준으로 검색할 수 있습니다.</p>
                            	</div>
                            	
                            	<div class="flex items-center gap-2">
                            		<!-- 직영점 모드에서만 사용 -->
								    <select id="branchSelect"
								            class="hidden w-48 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
								        <option value="">소속 선택</option>
								        <c:forEach var="b" items="${branchNameList}">
								        	<c:if test="${b.branchName ne '본사'}">
								            	<option value="${b.branchCode}">${b.branchName}</option>
								        	</c:if>
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
                        <div id="legendArea" class="flex items-center gap-6 mb-4 flex-wrap text-sm">
                            <div class="flex items-center gap-2">
                                <div class="w-3 h-3 bg-purple-500 rounded-full"></div>
                                <span class="text-gray-600">교육</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <div class="w-3 h-3 bg-blue-500 rounded-full"></div>
                                <span class="text-gray-600">출장</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                                <span class="text-gray-600">지점점검</span>
                            </div>
                            <div class="flex items-center gap-2">
                                <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                                <span class="text-gray-600">휴가</span>
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

    <!-- 일정 추가 모달 -->
    <div id="addModal" class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onclick="if(event.target === this) closeAddModal()">
        <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto" onclick="event.stopPropagation()">
            <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between sticky top-0 bg-white">
                <h3 class="text-lg font-bold text-gray-900">일정 추가</h3>
                <button onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times w-5 h-5"></i>
                </button>
            </div>

            <div class="p-6 space-y-6">
                <!-- 직원 및 매장 선택 -->
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            직원 이름 <span class="text-red-500">*</span>
                        </label>
                        <input id="empName" type="text" oninput="searchEmployeesByName()" onkeydown="if(event.key === 'Enter') selectFirstEmployeeByEnter(event)" placeholder="직원 이름을 입력하세요" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent mb-3">
                    	<input type="hidden" id="empNo">
                    	<div id="employeeCheckboxes" class="border border-gray-300 rounded-lg p-3 max-h-48 overflow-y-auto bg-gray-50 hidden">
					        <div class="space-y-2" id="employeeList"></div>
					    </div>
					
					    <p class="text-xs text-gray-500 mt-1">이름을 입력하면 해당 직원이 표시됩니다</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            근무 유형 <span class="text-red-500">*</span>
                        </label>
                        <select id="scheduleType" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                            <option value="TRAINING">교육</option>
                            <option value="BUSINESS_TRIP">출장</option>
                            <option value="VISIT">지점점검</option>
                            <option value="OFF">휴가</option>
                        </select>
                    </div>
                </div>

                <!-- 기간설정 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">기간 <span class="text-red-500">*</span>
                    </label>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs text-gray-500 mb-1">시작 날짜</label>
                            <input type="date" id="startDay" value="2026-01-01" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                        </div>
                        <div>
                            <label class="block text-xs text-gray-500 mb-1">종료 날짜</label>
                            <input type="date" id="endDay" value="2026-12-31" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                        </div>
                    </div>
                </div>

                <!-- 메모 -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">메모</label>
                    <textarea id="notes" placeholder="추가 정보나 특이사항을 입력하세요..." class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm" rows="4"></textarea>
                </div>
            </div>

            <div class="border-t border-gray-200 px-6 py-4 flex justify-between items-center sticky bottom-0 bg-white">
                <div class="text-sm text-gray-500">
                    <span class="text-red-500">*</span> 필수 입력 항목
                </div>
                <div class="flex gap-3">
                    <button onclick="closeAddModal()" class="px-5 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors text-sm">
                        취소
                    </button>
                    <button onclick="saveSchedule()" class="px-5 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors text-sm">
                        일정 추가
                    </button>
                </div>
            </div>
        </div>
    </div>
    
	<!-- 일정 수정 모달 -->
	<div id="editModal" class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onclick="if(event.target === this) closeEditModal()">
	    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto" onclick="event.stopPropagation()">
	        <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between sticky top-0 bg-white">
	            <h3 class="text-lg font-bold text-gray-900">일정 수정</h3>
	            <button type="button" onclick="closeEditModal()" class="text-gray-400 hover:text-gray-600">
	                <i class="fas fa-times w-5 h-5"></i>
	            </button>
	        </div>
	
	        <div class="p-6 space-y-6">
	            <input type="hidden" id="editScheduleId">
	
	            <!-- 직원 및 매장 -->
	            <div class="grid grid-cols-2 gap-4">
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-2">직원</label>
	                    <input type="text" id="editEmployeeName" class="modal-input modal-readonly" readonly>
	                </div>
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-2">근무 유형</label>
	                    <select id="editScheduleType" class="modal-select">
	                        <option value="TRAINING">교육</option>
	                        <option value="BUSINESS_TRIP">출장</option>
	                        <option value="VISIT">지점점검</option>
	                        <option value="OFF">휴가</option>
	                    </select>
	                </div>
	            </div>
	            
	            <!-- 근무 기간 -->
	            <div>
	                <label class="block text-sm font-medium text-gray-700 mb-2">기간</label>
	                <div class="grid grid-cols-2 gap-4">
	                    <div>
	                        <label class="block text-xs text-gray-500 mb-1">시작 날짜</label>
	                        <input type="date" id="editStartDay" class="modal-input">
	                    </div>
	                    <div>
	                        <label class="block text-xs text-gray-500 mb-1">종료 날짜</label>
	                        <input type="date" id="editEndDay" class="modal-input">
	                    </div>
	                </div>
	            </div>
	            
	            <!-- 근무 시간 -->
				<div id="editTimeArea">
				    <label class="block text-sm font-medium text-gray-700 mb-2">근무 시간</label>
				    <div class="grid grid-cols-2 gap-4">
				        <div>
				            <label class="block text-xs text-gray-500 mb-1">시작 시간</label>
				            <input type="time" id="editStartTime" class="modal-input">
				        </div>
				        <div>
				            <label class="block text-xs text-gray-500 mb-1">종료 시간</label>
				            <input type="time" id="editEndTime" class="modal-input">
				        </div>
				    </div>
				</div>

	            <!-- 메모 -->
	            <div>
	                <label class="block text-sm font-medium text-gray-700 mb-2">메모</label>
	                <textarea id="editNotes" class="modal-textarea" placeholder="추가 정보나 특이사항을 입력하세요..."></textarea>
	            </div>
	        </div>
	
	        <div class="border-t border-gray-200 px-6 py-4 flex justify-between items-center sticky bottom-0 bg-white">
	            <button type="button" onclick="deleteSchedule()" class="inline-flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm">
	                <i class="fas fa-trash-alt"></i>
	                삭제
	            </button>
	
	            <div class="flex gap-3">
	                <button type="button" onclick="closeEditModal()" class="px-5 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors text-sm">
	                    취소
	                </button>
	                <button type="button" onclick="updateSchedule()" class="px-5 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors text-sm">
	                    저장
	                </button>
	            </div>
	        </div>
	    </div>
	</div>

	<script>
		var hqSchedules = [
			<c:forEach var="s" items="${scheduleList}" varStatus="st">
			{
				id: "${s.scheduleId}",
				employeeId: "${s.empNo}",
				employee: "${s.empName}",
				branchCode: "${s.branchCode}",
				branch: "${s.branchName}",
				type: "${s.workType}",
				title: "${s.workType}",
				startDay: "${s.startDay}",
				endDay: "${s.endDay}",
				notes: "${s.memo}"
			}<c:if test="${!st.last}">,</c:if>
			</c:forEach>
		];
		var branchSchedules = [
			<c:forEach var="b" items="${branchScheduleList}" varStatus="bt">
			{
				id: "${b.scheduleId}",
				employeeId: "${b.empNo}",
		        employee: "${b.empName}",
		        branchCode: "${b.branchCode}",
		        branch: "${b.branchName}",
		        type: "${b.workType}",
		        date: "${b.workDate}".substring(0,10),
		        startTime: "${b.startTime}",
		        endTime: "${b.endTime}",
		        notes: "${b.memo}"
			}<c:if test="${!bt.last}">,</c:if>
			</c:forEach>
		];
		
		var scheduleViewMode = 'hq'; // hq 또는 branch
	    var currentDate = new Date();
	    var selectedEmployees = [];
	    var isSearched = false;
	    var filteredBranchSchedules = [];
	    
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
	    });
	
	    function getCurrentSchedules() {
	        return scheduleViewMode === 'hq' ? hqSchedules : filteredBranchSchedules;
	    }

	    function changeScheduleView(mode) {
	    	var addBtn = document.getElementById('addScheduleBtn');
	        var hqBtn = document.getElementById('hqScheduleBtn');
	        var branchBtn = document.getElementById('branchScheduleBtn');

	        scheduleViewMode = mode;
	        isSearched = false;
	        document.getElementById('searchInput').value = '';

	        if (mode === 'hq') {
	            addBtn.disabled = false;
	            addBtn.classList.remove('bg-gray-300', 'text-gray-500', 'cursor-not-allowed');
	            addBtn.classList.add('bg-[#00853D]', 'text-white', 'hover:bg-[#006B2F]');

	            hqBtn.className = 'flex items-center gap-2 bg-[#00853D] text-white border border-[#00853D] px-4 py-2.5 rounded-lg transition-colors';
	            branchBtn.className = 'flex items-center gap-2 bg-white text-[#00853D] border border-[#00853D] px-4 py-2.5 rounded-lg hover:bg-[#00853D] hover:text-white transition-colors';

	            document.getElementById('branchSelect').classList.add('hidden');
	            document.getElementById('searchInput').disabled = false;
	            document.getElementById('searchInput').value = '';
	            document.getElementById('searchInput').placeholder = '사번, 이름을 입력하세요';
	            document.getElementById('searchInput').classList.remove('bg-gray-100', 'cursor-not-allowed');
	            
	            renderCalendar();
	        }

	        if (mode === 'branch') {
	            addBtn.disabled = true;
	            addBtn.classList.remove('bg-[#00853D]', 'text-white', 'hover:bg-[#006B2F]');
	            addBtn.classList.add('bg-gray-300', 'text-gray-500', 'cursor-not-allowed');

	            hqBtn.className = 'flex items-center gap-2 bg-white text-[#00853D] border border-[#00853D] px-4 py-2.5 rounded-lg hover:bg-[#00853D] hover:text-white transition-colors';
	            branchBtn.className = 'flex items-center gap-2 bg-[#00853D] text-white border border-[#00853D] px-4 py-2.5 rounded-lg transition-colors';

	            document.getElementById('branchSelect').classList.remove('hidden');
	            document.getElementById('branchSelect').value = '';
	            document.getElementById('searchInput').value = '';
	            document.getElementById('searchInput').disabled = true;
	            document.getElementById('searchInput').placeholder = '직영점 모드에서는 소속을 선택하세요';
	            document.getElementById('searchInput').classList.add('bg-gray-100', 'cursor-not-allowed');

	            filteredBranchSchedules = [];
	            isSearched = false;
	            renderCalendar();
	        }
	    }
	    
	    function normalizeDate(value) {
	        if (!value) return '';

	        return String(value)
	            .trim()
	            .replace(/\./g, '-')
	            .substring(0, 10);
	    }
	    
	    function normalizeTime(value) {
	        if (!value) return '';

	        return String(value)
	            .trim()
	            .substring(0, 5);
	    }
	    
	    function makeNameLinks(scheduleArr) {
	        var namesHtml = [];

	        for (var i = 0; i < scheduleArr.length; i++) {
	            var item = scheduleArr[i];

	            namesHtml.push(
	                '<span class="employee-name-link" ' +
	                'onclick="event.stopPropagation(); viewSchedule(\'' + item.id + '\')" ' +
	                'title="' + item.employee + ' 일정 조회">' +
	                item.employee +
	                '</span>'
	            );
	        }

	        return namesHtml.join(', ');
	    }
	    
	    function renderCalendar() {
	    	renderLegend();
	    	
	        var year = currentDate.getFullYear();
	        var month = currentDate.getMonth();
	        var currentSchedules = isSearched ? getFilteredSchedules() : [];
	
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
	                if (scheduleViewMode === 'hq') {
	                    return normalizeDate(s.startDay) <= dateStr && normalizeDate(s.endDay) >= dateStr;
	                }

	                return normalizeDate(s.date) === dateStr;
	            });
	
	            var isToday = new Date().toLocaleDateString() === dayObj.date.toLocaleDateString();
	
	            var cellClass =
	                'day-cell p-2 cursor-pointer hover:bg-blue-50 ' +
	                (dayObj.currentMonth ? '' : 'other-month ') +
	                (isToday ? 'today' : '');
	
	            html += '<div class="' + cellClass + '" style="min-height:120px;" onclick="selectDateForModal(\'' + dateStr + '\')">';
	            html += '<div class="text-xs font-medium mb-1 text-gray-900">' + dayObj.day + '</div>';
	
	            if (scheduleViewMode === 'branch') {
	                var openSchedules = [];
	                var middleSchedules = [];
	                var closeSchedules = [];
	                var offSchedules = [];

	                for (var k = 0; k < daySchedules.length; k++) {
	                    var bs = daySchedules[k];

	                    if (bs.type === 'OPEN') {
	                        openSchedules.push(bs);
	                    } else if (bs.type === 'MIDDLE') {
	                        middleSchedules.push(bs);
	                    } else if (bs.type === 'CLOSE') {
	                        closeSchedules.push(bs);
	                    } else if (bs.type === 'OFF') {
	                        offSchedules.push(bs);
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

	                if (offSchedules.length > 0) {
	                    html += '<div class="schedule-event type-OFF">';
	                    html += '<span class="font-semibold">휴무</span> ';
	                    html += makeNameLinks(offSchedules);
	                    html += '</div>';
	                }

	                html += '</div>';

	            } else {
	                for (var k = 0; k < Math.min(daySchedules.length, 3); k++) {
	                    var s = daySchedules[k];
	                    var empName = String(s.employee || '').substring(0, 3);
	                    var workType = String(s.type || '');

	                    html += '<div class="schedule-event type-' + workType + '" onclick="event.stopPropagation(); viewSchedule(\'' + s.id + '\')" title="' + s.employee + ' - ' + workType + '">';
	                    html += '<span class="text-xs font-semibold">' + empName + '</span> <span class="text-xs">' + workType + '</span>';
	                    html += '</div>';
	                }

	                if (daySchedules.length > 3) {
	                    html += '<div class="text-xs text-gray-600 text-center font-medium mt-1">+' + (daySchedules.length - 3) + '개 더보기</div>';
	                }
	            }
	            html += '</div>';
	        }
	
	        var container = document.getElementById('calendarContainer');
	        container.innerHTML = html;
	        container.style.gridTemplateColumns = 'repeat(7, 1fr)';
	        dayHeaders.style.gridTemplateColumns = 'repeat(7, 1fr)';
	    }
	    
	    function renderLegend() {
	        var legendArea = document.getElementById('legendArea');

	        if (scheduleViewMode === 'branch') {
	            legendArea.innerHTML =
	                '<div class="flex items-center gap-2">' +
	                    '<div class="w-3 h-3 bg-green-500 rounded-full"></div>' +
	                    '<span class="text-gray-600">오픈</span>' +
	                '</div>' +
	                '<div class="flex items-center gap-2">' +
	                    '<div class="w-3 h-3 bg-blue-500 rounded-full"></div>' +
	                    '<span class="text-gray-600">미들</span>' +
	                '</div>' +
	                '<div class="flex items-center gap-2">' +
	                    '<div class="w-3 h-3 bg-purple-500 rounded-full"></div>' +
	                    '<span class="text-gray-600">마감</span>' +
	                '</div>' +
	                '<div class="flex items-center gap-2">' +
	                    '<div class="w-3 h-3 bg-gray-500 rounded-full"></div>' +
	                    '<span class="text-gray-600">휴무</span>' +
	                '</div>';
	            return;
	        }

	        legendArea.innerHTML =
	            '<div class="flex items-center gap-2">' +
	                '<div class="w-3 h-3 bg-purple-500 rounded-full"></div>' +
	                '<span class="text-gray-600">교육</span>' +
	            '</div>' +
	            '<div class="flex items-center gap-2">' +
	                '<div class="w-3 h-3 bg-blue-500 rounded-full"></div>' +
	                '<span class="text-gray-600">출장</span>' +
	            '</div>' +
	            '<div class="flex items-center gap-2">' +
	                '<div class="w-3 h-3 bg-red-500 rounded-full"></div>' +
	                '<span class="text-gray-600">지점점검</span>' +
	            '</div>' +
	            '<div class="flex items-center gap-2">' +
	                '<div class="w-3 h-3 bg-green-500 rounded-full"></div>' +
	                '<span class="text-gray-600">휴가</span>' +
	            '</div>';
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
	    	if (scheduleViewMode === 'branch') {
	            return filteredBranchSchedules;
	        }

	        var keyword = document.getElementById('searchInput').value.trim();
	        var schedules = hqSchedules;

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
	    	if (scheduleViewMode === 'branch') {
	            return;
	        }
	        showAddModal(dateStr);
	    }
	
	    function applyFilters() {
	        if (scheduleViewMode === 'branch') {
	            var branchCode = String(document.getElementById('branchSelect').value).trim();

	            if (!branchCode) {
	                alert('조회할 직영점을 선택하세요.');
	                return;
	            }

	            filteredBranchSchedules = branchSchedules.filter(function(s) {
	                return String(s.branchCode || '').trim() === branchCode;
	            });

	            isSearched = true;
	            renderCalendar();
	            return;
	        }

	        isSearched = true;
	        renderCalendar();
	    }
	
	    function resetFilters() {
	    	isSearched = false;
	        document.getElementById('searchInput').value = '';
	        var branchSelect = document.getElementById('branchSelect');
	        if (branchSelect) {
	            branchSelect.value = '';
	        }

	        filteredBranchSchedules = [];
	        renderCalendar();
	    }
	
	    function updateSelectedEmployees() {
	        var checkboxes = document.querySelectorAll('#employeeList input[type="checkbox"]:checked');
	        selectedEmployees = [];
	
	        for (var i = 0; i < checkboxes.length; i++) {
	            selectedEmployees.push(checkboxes[i].value);
	        }
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

	        document.getElementById('scheduleType').value = 'TRAINING';
	        document.getElementById('startDay').value = targetDate;
	        document.getElementById('endDay').value = targetDate;
	        document.getElementById('notes').value = '';

	        document.getElementById('addModal').classList.remove('modal-hidden');
	    }
	
	    function closeAddModal() {
	        document.getElementById('addModal').classList.add('modal-hidden');
	    }
	
	    function saveSchedule() {
	        var empNo = document.getElementById('empNo').value;
	        var startDay = document.getElementById('startDay').value;
	        var endDay = document.getElementById('endDay').value;
	        var type = document.getElementById('scheduleType').value;
	        var notes = document.getElementById('notes').value;

	        if (!empNo || !startDay || !endDay || !type) {
	            alert('필수 항목을 모두 입력하세요.');
	            return;
	        }

	        if (endDay < startDay) {
	            alert('종료 날짜는 시작 날짜보다 빠를 수 없습니다.');
	            return;
	        }

	        fetch('<%= request.getContextPath() %>/hq/hr/hqschedule', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
	            },
	            body:
	                'action=add' +
	                '&empNo=' + encodeURIComponent(empNo) +
	                '&branchCode=1' +
	                '&startDay=' + encodeURIComponent(startDay) +
	                '&endDay=' + encodeURIComponent(endDay) +
	                '&memo=' + encodeURIComponent(notes) +
	                '&workType=' + encodeURIComponent(type)
	        })
	        .then(function(res) {
	            return res.json();
	        })
	        .then(function(data) {
	            if (data.success) {
	                alert(data.message || '일정이 등록되었습니다.');
	                location.reload();
	            } else {
	                alert(data.message || '일정 등록 실패');
	            }
	        });
	    }
	
	    function viewSchedule(id) {
	    	var schedules = getCurrentSchedules();
	        var schedule = schedules.find(function(s) {
	            return String(s.id) === String(id);
	        });
	
	        if (!schedule) {
	            alert('일정을 찾을 수 없습니다.');
	            return;
	        }
	
	    	setEditScheduleTypeOptions(scheduleViewMode);
	    	
	        document.getElementById('editScheduleId').value = schedule.id;
	        document.getElementById('editEmployeeName').value = schedule.employee || '';
	        document.getElementById('editScheduleType').value = schedule.type || '교육';
	        document.getElementById('editStartDay').value = schedule.startDay || schedule.date || '';
	        document.getElementById('editEndDay').value = schedule.endDay || schedule.date || '';
	        document.getElementById('editStartTime').value = normalizeTime(schedule.startTime);
	        document.getElementById('editEndTime').value = normalizeTime(schedule.endTime);
	        document.getElementById('editNotes').value = schedule.notes || '';
	        
	        var saveBtn = document.querySelector('#editModal button[onclick="updateSchedule()"]');
	        var deleteBtn = document.querySelector('#editModal button[onclick="deleteSchedule()"]');

	        if (scheduleViewMode === 'branch') {
	        	document.getElementById('editTimeArea').classList.remove('hidden');
	            document.querySelector('#editModal h3').textContent = '직영점 일정 조회';

	            var editEmployeeName = document.getElementById('editEmployeeName');
	            var editScheduleType = document.getElementById('editScheduleType');
	            var editStartDay = document.getElementById('editStartDay');
	            var editEndDay = document.getElementById('editEndDay');
	            var editStartTime = document.getElementById('editStartTime');
	            var editEndTime = document.getElementById('editEndTime');
	            var editNotes = document.getElementById('editNotes');

	            editEmployeeName.readOnly = true;
	            editScheduleType.disabled = true;
	            editStartDay.readOnly = true;
	            editEndDay.readOnly = true;
	            editStartTime.readOnly = true;
	            editEndTime.readOnly = true;
	            editNotes.readOnly = true;

	            editEmployeeName.classList.add('readonly-gray');
	            editScheduleType.classList.add('readonly-gray');
	            editStartDay.classList.add('readonly-gray');
	            editEndDay.classList.add('readonly-gray');
	            editStartTime.classList.add('readonly-gray');
	            editEndTime.classList.add('readonly-gray');
	            editNotes.classList.add('readonly-gray');

	            if (saveBtn) saveBtn.classList.add('hidden');
	            if (deleteBtn) deleteBtn.classList.add('hidden');
	        } else {
	        	document.getElementById('editTimeArea').classList.add('hidden');
	            document.querySelector('#editModal h3').textContent = '일정 수정';

	            var editEmployeeName = document.getElementById('editEmployeeName');
	            var editScheduleType = document.getElementById('editScheduleType');
	            var editStartDay = document.getElementById('editStartDay');
	            var editEndDay = document.getElementById('editEndDay');
	            var editNotes = document.getElementById('editNotes');

	            editEmployeeName.readOnly = true;
	            editScheduleType.disabled = false;
	            editStartDay.readOnly = false;
	            editEndDay.readOnly = false;
	            editNotes.readOnly = false;

	            editEmployeeName.classList.add('readonly-gray');
	            editScheduleType.classList.remove('readonly-gray');
	            editStartDay.classList.remove('readonly-gray');
	            editEndDay.classList.remove('readonly-gray');
	            editNotes.classList.remove('readonly-gray');

	            if (saveBtn) saveBtn.classList.remove('hidden');
	            if (deleteBtn) deleteBtn.classList.remove('hidden');
	        }
	        document.getElementById('editModal').classList.remove('modal-hidden');
	    }
	    
	    function setEditScheduleTypeOptions(mode) {
	        var select = document.getElementById('editScheduleType');

	        if (mode === 'branch') {
	            select.innerHTML =
	                '<option value="OPEN">오픈</option>' +
	                '<option value="MIDDLE">미들</option>' +
	                '<option value="CLOSE">마감</option>' +
	                '<option value="OFF">휴무</option>';
	            return;
	        }

	        select.innerHTML =
	            '<option value="TRAINING">교육</option>' +
	            '<option value="BUSINESS_TRIP">출장</option>' +
	            '<option value="VISIT">지점점검</option>' +
	            '<option value="OFF">휴가</option>';
	    }
	
	    function closeEditModal() {
	        document.getElementById('editModal').classList.add('modal-hidden');
	    }
	
	    function updateSchedule() {
	    	if (scheduleViewMode === 'branch') {
	    	    alert('직영점 일정은 조회만 가능합니다.');
	    	    return;
	    	}
	    	
	        var scheduleId = document.getElementById('editScheduleId').value;
	        var type = document.getElementById('editScheduleType').value;
	        var notes = document.getElementById('editNotes').value;
	        var startDay = document.getElementById('editStartDay').value;
	        var endDay = document.getElementById('editEndDay').value;

	        if (!scheduleId || !startDay || !endDay || !type) {
	            alert('필수 항목을 모두 입력하세요.');
	            return;
	        }

	        if (endDay < startDay) {
	            alert('종료 날짜는 시작 날짜보다 빠를 수 없습니다.');
	            return;
	        }

	        fetch('<%= request.getContextPath() %>/hq/hr/hqschedule', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
	            },
	            body:
	                'action=update' +
	                '&scheduleId=' + encodeURIComponent(scheduleId) +
	                '&startDay=' + encodeURIComponent(startDay) +
	                '&endDay=' + encodeURIComponent(endDay) +
	                '&memo=' + encodeURIComponent(notes) +
	                '&workType=' + encodeURIComponent(type)
	        })
	        .then(function(res) {
	            return res.json();
	        })
	        .then(function(data) {
	            if (data.success) {
	                alert(data.message || '일정이 수정되었습니다.');
	                location.reload(); // DB에서 다시 조회해서 캘린더 반영
	            } else {
	                alert(data.message || '일정 수정 실패');
	            }
	        });
	    }
	
	    function deleteSchedule() {
	    	if (scheduleViewMode === 'branch') {
	    	    alert('직영점 일정은 조회만 가능합니다.');
	    	    return;
	    	}
	    	
	        var scheduleId = document.getElementById('editScheduleId').value;
	
	        if (!confirm('이 일정을 삭제하시겠습니까?')) {
	            return;
	        }
	
	        fetch('<%= request.getContextPath() %>/hq/hr/hqschedule', {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
	            },
	            body:
	                'action=delete' +
	                '&scheduleId=' + encodeURIComponent(scheduleId)
	        })
	        .then(function(res) {
	            return res.json();
	        })
	        .then(function(data) {
	            if (data.success) {
	                alert(data.message || '일정이 삭제되었습니다.');
	                location.reload();
	            } else {
	                alert(data.message || '일정 삭제 실패');
	            }
	        });
	    }
	
	    function toggleMenu(button) {
	        var submenu = button.nextElementSibling;
	
	        if (submenu && submenu.classList.contains('submenu')) {
	            submenu.classList.toggle('hidden');
	
	            var arrow = button.querySelector('i:last-child');
	            if (arrow) {
	                arrow.classList.toggle('fa-chevron-right');
	                arrow.classList.toggle('fa-chevron-down');
	            }
	        }
	    }
	    
	    function toggleSidebar() {
	        var sidebar = document.getElementById('sidebar');
	        var backdrop = document.getElementById('sidebarBackdrop');
	
	        if (sidebar) sidebar.classList.toggle('-translate-x-full');
	        if (backdrop) backdrop.classList.toggle('hidden');
	    }
	
	    function toggleUserMenu() {
	        var userMenu = document.getElementById('userMenu');
	        if (userMenu) userMenu.classList.toggle('hidden');
	    }
	
	    function logout() {
	        alert('로그아웃 되었습니다.');
	    }
	</script>
</body>
</html>