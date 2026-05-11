<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
        	<input type="hidden" id="editEmpNo" name="empNo">
            <input type="hidden" id="editBranchCode" name="branchCode">
            <input type="hidden" id="editScheduleId" name="scheduleId">
            <input type="hidden" id="editRepeatGroupId" name="repeatGroupId">
            <input type="hidden" id="editIsRepeat" name="isRepeat">

            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        직원
                    </label>
                    <input type="text"
                           id="editEmployeeName"
                           name="empName"
                           readonly
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        근무 유형 <span class="text-red-500">*</span>
                    </label>
                    <select id="editWorkType"
                            name="workType"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                        <option value="OPEN">오픈</option>
                        <option value="MIDDLE">미들</option>
                        <option value="CLOSE">마감</option>
                    </select>
                </div>
            </div>

            <!-- 근무 날짜 -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    근무 날짜 <span class="text-red-500">*</span>
                </label>
                <input type="text"
                       id="editWorkDate"
                       name="workDate"
                       readonly
                       onclick="openCustomDatePicker('editWorkDate', event)"
                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
            </div>

            <!-- 근무 시간 -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    근무 시간 <span class="text-red-500">*</span>
                </label>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs text-gray-500 mb-1">시작 시간</label>
                        <input type="time"
                               id="editStartTime"
                               name="startTime"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                    </div>

                    <div>
                        <label class="block text-xs text-gray-500 mb-1">종료 시간</label>
                        <input type="time"
                               id="editEndTime"
                               name="endTime"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                    </div>
                </div>
            </div>

            <!-- 반복 일정 안내 -->
            <div id="editRepeatNotice" class="hidden rounded-lg bg-yellow-50 border border-yellow-200 p-3 text-sm text-yellow-800">
                반복 일정입니다. 삭제 시 선택한 일정만 삭제하거나, 반복 전체를 삭제할 수 있습니다.
            </div>

            <!-- 메모 -->
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">메모</label>
                <textarea id="editMemo"
                          name="memo"
                          placeholder="추가 정보나 특이사항을 입력하세요..."
                          rows="4"
                          class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm"></textarea>
            </div>
        </div>

        <div class="border-t border-gray-200 px-6 py-4 sticky bottom-0 bg-white">
		    <div class="flex items-center justify-between gap-4">
		
		        <!-- 왼쪽: 삭제 버튼 영역 -->
		        <div class="flex items-center gap-2">
		            <button type="button"
		                    id="deleteRepeatBtn"
		                    onclick="deleteSchedule('ALL')"
		                    class="hidden inline-flex items-center gap-2 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors text-xs font-medium">
		                <i class="fas fa-trash-alt"></i>
		                일정 전체 삭제
		            </button>
		
		            <button type="button"
		                    onclick="deleteSchedule('ONE')"
		                    class="inline-flex items-center gap-2 px-4 py-2 border border-red-200 bg-red-50 text-red-600 rounded-lg hover:bg-red-100 hover:border-red-300 transition-colors text-xs font-medium">
		                <i class="fas fa-trash-alt"></i>
		                선택 일정 삭제
		            </button>
		        </div>
		
		        <!-- 오른쪽: 취소/저장 버튼 영역 -->
		        <div class="flex items-center gap-2">
		            <button type="button"
		                    onclick="closeEditModal()"
		                    class="px-5 py-2 border border-gray-300 rounded-lg text-gray-700 bg-white hover:bg-gray-50 transition-colors text-xs font-medium">
		                취소
		            </button>
		
		            <button type="button"
		                    onclick="updateSchedule('ONE')"
		                    class="px-5 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors text-xs font-medium shadow-sm">
		                선택 일정 저장
		            </button>
		        </div>
		    </div>
		</div>
    </div>
</div>