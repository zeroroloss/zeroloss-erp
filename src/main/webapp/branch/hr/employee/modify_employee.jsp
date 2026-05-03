<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Edit Employee Modal -->
<div id="editModal"
     class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
     onclick="if(event.target === this) closeEditModal()">

    <div class="bg-white rounded-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto shadow-xl"
         onclick="event.stopPropagation()">

        <!-- 헤더 -->
        <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between sticky top-0 bg-white z-10">
            <h3 class="text-lg font-bold text-gray-900">직원 상세 조회</h3>

            <div class="flex items-center gap-3">
	            <button type="button"
	                    id="editModeBtn"
	                    onclick="changeToEditMode()"
	                    class="px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B2F] transition-colors">
	                수정
	            </button>

                <button type="button"
                        onclick="closeEditModal()"
                        class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times w-5 h-5"></i>
                </button>
            </div>
        </div>

        <!-- 본문 -->
        <div class="p-6">
            <input type="hidden" id="editEmpNo" name="editEmpNo">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이름</label>
                    <input type="text"
                           id="editName"
                           readonly
                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">사번</label>
                    <input type="text"
                           id="editEmpNoView"
                           readonly
                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

				<input type="hidden" id="editBranchCode" name="editBranchCode">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">역할</label>
                    <select id="editPositionCode"
                            name="editPositionCode"
                            disabled
                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                        <option value="POS_STF">직원</option>
                        <option value="POS_PTM">알바</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">연락처</label>
                    <input type="text"
                           id="editPhone"
                           name="editPhone"
                           readonly
                           class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
                    <input type="email"
                           id="editEmail"
                           name="editEmail"
                           readonly
                           class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">입사일</label>
                    <input type="text"
                           id="editHireDate"
                           readonly
                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
                    <select id="editStatus"
                            name="editStatus"
                            disabled
                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                        <option value="ACTIVE">재직</option>
                        <option value="LEAVE">휴직</option>
                        <option value="RESIGNED">퇴사</option>
                    </select>
                </div>

            </div>
        </div>

        <!-- 하단 버튼 -->
        <div class="border-t border-gray-200 px-6 py-4 flex justify-end gap-3 sticky bottom-0 bg-white">
            <button type="button"
                    onclick="closeEditModal()"
                    class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 text-sm hover:bg-gray-50 transition-colors">
                닫기
            </button>

            <button type="button"
                    id="saveBtn"
                    onclick="updateEmployee()"
                    class="hidden px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B2F] transition-colors">
                저장
            </button>
        </div>

    </div>
</div>