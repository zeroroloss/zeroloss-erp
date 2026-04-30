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
            <input type="hidden" id="editScheduleId">
            <input type="hidden" id="editRepeatGroupId">
            <input type="hidden" id="editIsRepeat">

            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">직원</label>
                    <input type="text" id="editEmployeeName" class="modal-input modal-readonly" readonly>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        근무 유형 <span class="text-red-500">*</span>
                    </label>
                    <select id="editWorkType" class="modal-select">
                        <option value="OPEN">오픈</option>
                        <option value="MIDDLE">미들</option>
                        <option value="CLOSE">마감</option>
                        <option value="OFF">휴무</option>
                    </select>
                </div>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    근무 날짜 <span class="text-red-500">*</span>
                </label>
                <input type="date" id="editWorkDate" class="modal-input">
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                    근무 시간 <span class="text-red-500">*</span>
                </label>
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

            <div id="editRepeatNotice" class="hidden rounded-lg bg-yellow-50 border border-yellow-200 p-3 text-sm text-yellow-800">
                반복 일정입니다. 저장/삭제 시 선택한 일정만 처리할지, 반복 전체를 처리할지 선택할 수 있습니다.
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">메모</label>
                <textarea id="editMemo" class="modal-textarea" placeholder="추가 정보나 특이사항을 입력하세요..."></textarea>
            </div>
        </div>

        <div class="border-t border-gray-200 px-6 py-4 flex justify-between items-center sticky bottom-0 bg-white">
            <div class="flex gap-2">
                <button type="button" onclick="deleteSchedule('ONE')" class="inline-flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm">
                    <i class="fas fa-trash-alt"></i>
                    선택 일정 삭제
                </button>
                <button type="button" id="deleteRepeatBtn" onclick="deleteSchedule('ALL')" class="hidden inline-flex items-center gap-2 px-4 py-2 bg-red-700 text-white rounded-lg hover:bg-red-800 transition-colors text-sm">
                    반복 전체 삭제
                </button>
            </div>

            <div class="flex gap-3">
                <button type="button" onclick="closeEditModal()" class="px-5 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors text-sm">
                    취소
                </button>
                <button type="button" onclick="updateSchedule('ONE')" class="px-5 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors text-sm">
                    선택 일정 저장
                </button>
                <button type="button" id="updateRepeatBtn" onclick="updateSchedule('ALL')" class="hidden px-5 py-2 bg-[#006B2F] text-white rounded-lg hover:bg-[#005828] transition-colors text-sm">
                    반복 전체 저장
                </button>
            </div>
        </div>
    </div>
</div>