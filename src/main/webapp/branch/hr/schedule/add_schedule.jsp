<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 일정 추가 모달 -->
<div id="addModal" class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onclick="if(event.target === this) closeAddModal()">
    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto" onclick="event.stopPropagation()">
	        <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between sticky top-0 bg-white">
	            <h3 class="text-lg font-bold text-gray-900">일정 추가</h3>
	            <button type="button" onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
	                <i class="fas fa-times w-5 h-5"></i>
	            </button>
	        </div>
	
	        <div class="p-6 space-y-6">
	            <div class="grid grid-cols-2 gap-4">
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-2">
	                        직원 이름 <span class="text-red-500">*</span>
	                    </label>
	                    <input id="empName" name="empName" type="text"
	                           oninput="searchEmployeesByName()"
	                           onkeydown="if(event.key === 'Enter') selectFirstEmployeeByEnter(event)"
	                           placeholder="직원 이름을 입력하세요"
	                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent mb-3">
	                    <input type="hidden" id="empNo" name="empNo">
	
	                    <div id="employeeCheckboxes" class="border border-gray-300 rounded-lg p-3 max-h-48 overflow-y-auto bg-gray-50 hidden">
	                        <div class="space-y-2" id="employeeList"></div>
	                    </div>
	
	                    <p class="text-xs text-gray-500 mt-1">이름을 입력하면 해당 직원이 표시됩니다</p>
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-2">
	                        근무 유형 <span class="text-red-500">*</span>
	                    </label>
	                    <select id="workType" name="workType" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
	                        <option value="OPEN">오픈</option>
	                        <option value="MIDDLE">미들</option>
	                        <option value="CLOSE">마감</option>
	                        <option value="OFF">휴무</option>
	                    </select>
	                </div>
	            </div>

	            <!-- 반복 설정 -->
	            <div>
	                <label class="block text-sm font-medium text-gray-700 mb-2">
	                    반복 설정 <span class="text-red-500">*</span>
	                </label>
	                <select id="isRepeat" onchange="toggleRepeatOptions()" name="isRepeat"
	                        class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
	                    <option value="1">반복 없음</option>
	                    <option value="2">매주 반복</option>
	                    <option value="3">매월 반복</option>
	                </select>
	            </div>
	
	            <!-- 기간 설정 -->
	            <div>
	                <label class="block text-sm font-medium text-gray-700 mb-2">
	                    기간 <span class="text-red-500">*</span>
	                </label>
	                <div class="grid grid-cols-2 gap-4">
	                    <div>
	                        <label class="block text-xs text-gray-500 mb-1">시작 날짜</label>
	                        <input type="date" id="startDate" name="startDate" onchange="changeStartDate()"
	                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
	                    </div>
	                    <div>
	                        <label class="block text-xs text-gray-500 mb-1">종료 날짜</label>
	                        <input type="date" id="endDate" name="endDate"
	                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
	                    </div>
	                </div>
	            </div>
	
	            <!-- 근무 시간 -->
	            <div>
	                <label class="block text-sm font-medium text-gray-700 mb-2">
	                    근무 시간 <span class="text-red-500">*</span>
	                </label>
	                <div class="grid grid-cols-2 gap-4">
	                    <div>
	                        <label class="block text-xs text-gray-500 mb-1">시작 시간</label>
	                        <input type="time" id="startTime" name="startTime"
	                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
	                    </div>
	                    <div>
	                        <label class="block text-xs text-gray-500 mb-1">종료 시간</label>
	                        <input type="time" id="endTime" name="endTime"
	                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
	                    </div>
	                </div>
	            </div>
	
	            <!-- 매주 반복 요일 -->
	            <div id="weekdayOptions" class="hidden">
	                <label class="block text-sm font-medium text-gray-700 mb-2">
	                    반복 요일 <span class="text-red-500">*</span>
	                </label>
	                <div class="grid grid-cols-7 gap-2 text-sm">
	                    <label class="flex items-center justify-center gap-1 border border-gray-300 rounded-lg py-2 cursor-pointer">
	                        <input type="checkbox" name="weekdayRepeat" value="1"> 월
	                    </label>
	                    <label class="flex items-center justify-center gap-1 border border-gray-300 rounded-lg py-2 cursor-pointer">
	                        <input type="checkbox" name="weekdayRepeat" value="2"> 화
	                    </label>
	                    <label class="flex items-center justify-center gap-1 border border-gray-300 rounded-lg py-2 cursor-pointer">
	                        <input type="checkbox" name="weekdayRepeat" value="3"> 수
	                    </label>
	                    <label class="flex items-center justify-center gap-1 border border-gray-300 rounded-lg py-2 cursor-pointer">
	                        <input type="checkbox" name="weekdayRepeat" value="4"> 목
	                    </label>
	                    <label class="flex items-center justify-center gap-1 border border-gray-300 rounded-lg py-2 cursor-pointer">
	                        <input type="checkbox" name="weekdayRepeat" value="5"> 금
	                    </label>
	                    <label class="flex items-center justify-center gap-1 border border-gray-300 rounded-lg py-2 cursor-pointer">
	                        <input type="checkbox" name="weekdayRepeat" value="6"> 토
	                    </label>
	                    <label class="flex items-center justify-center gap-1 border border-gray-300 rounded-lg py-2 cursor-pointer">
	                        <input type="checkbox" name="weekdayRepeat" value="7"> 일
	                    </label>
	                </div>
	            </div>
	
	            <!-- 메모 -->
	            <div>
	                <label class="block text-sm font-medium text-gray-700 mb-2">메모</label>
	                <textarea id="memo" name="memo" placeholder="추가 정보나 특이사항을 입력하세요..."
	                          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm"
	                          rows="4"></textarea>
	            </div>
	        </div>
	
	        <div class="border-t border-gray-200 px-6 py-4 flex justify-between items-center sticky bottom-0 bg-white">
	            <div class="text-sm text-gray-500">
	                <span class="text-red-500">*</span> 필수 입력 항목
	            </div>
	            <div class="flex gap-3">
	                <button type="button" onclick="closeAddModal()" class="px-5 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors text-sm">
	                    취소
	                </button>
	                <button type="button" onclick="saveSchedule()" class="px-5 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors text-sm">
	                    일정 추가
	                </button>
	            </div>
       		</div>
    </div>
</div>