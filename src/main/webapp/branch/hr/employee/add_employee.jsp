<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 신규 직원 등록 모달 -->
<div id="addModal"
     class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
     onclick="if(event.target === this) closeAddModal()">

    <div class="bg-white rounded-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-xl"
         onclick="event.stopPropagation()">

        <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between sticky top-0 bg-white z-10">
            <h3 class="text-lg font-bold text-gray-900">신규 알바생 등록</h3>
            <button type="button" onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-5 h-5"></i>
            </button>
        </div>

        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이름</label>
                    <input type="text" id="name" name="name" placeholder="홍길동"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">사번</label>
                    <input type="text" id="empNo" name="empNo" placeholder="1"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>
                
                <input type="hidden" id="branchCode" name="branchCode" value="${sessionScope.branchCode }">
                
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">소속</label>
                    <input type="text" value="${sessionScope.branchName}" readonly
       					   class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-900">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">역할</label>
                    <select id="positionCode" name="positionCode"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900 focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                        <option value="POS_PTM">알바</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">연락처</label>
                    <input type="tel" id="phone" name="phone" placeholder="010-0000-0000"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
                    <input type="email" id="email" name="email" placeholder="user@zeroloss.com"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
				    <label class="block text-sm font-medium text-gray-700 mb-1">입사일</label>
				    <div class="relative">
						<input type="text" id="hireDate" name="hireDate" readonly data-open-when-readonly onclick="openCustomDatePicker('hireDate', event)" placeholder="YYYY-MM-DD" class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none bg-white cursor-pointer">
				        <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
				    </div>
				</div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
                    <select id="status" name="status"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900 focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                        <option value="ACTIVE">재직</option>
                        <option value="LEAVE">휴직</option>
                        <option value="RESIGNED">퇴사</option>
                    </select>
                </div>

            </div>
        </div>

        <div class="border-t border-gray-200 px-6 py-4 flex justify-end gap-3 sticky bottom-0 bg-white">
            <button type="button" onclick="closeAddModal()"
                    class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                취소
            </button>
            <button type="button" onclick="saveEmployee()"
                    class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
                추가
            </button>
        </div>
    </div>
</div>
