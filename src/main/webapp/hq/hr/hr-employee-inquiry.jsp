<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>본사 및 지점별 직원 정보 통합 조회 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
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
        /* 커스텀 날짜 선택기 */
		.custom-date-picker {
		    position: fixed;
		    width: 300px;
		    background: #fff;
		    border: 1px solid #d1d5db;
		    border-radius: 0.75rem;
		    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
		    z-index: 9999;
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
                           <h2 class="text-3xl font-bold text-gray-900">본사 및 지점별 직원 정보 통합 조회</h2>
                           <p class="text-gray-500 mt-1">전체 직원 정보를 통합하여 관리하세요</p>
                       </div>
                       <button onclick="showAddModal()" class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2.5 rounded-lg hover:bg-[#006B2F] transition-colors">
                           <i class="fas fa-user-plus w-5 h-5"></i>
                           <span>신규 직원 등록</span>
                       </button>
                   </div>

                   <!-- 통계 카드 -->
				<div class="grid grid-cols-1 md:grid-cols-3 gap-4">
				    <div class="bg-white rounded-lg border border-gray-200 p-4">
				        <div class="flex items-center gap-4">
				            <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
				                <i class="fas fa-users w-6 h-6 text-green-600"></i>
				            </div>
				            <div>
				                <p class="text-sm text-gray-500">총 재직 인원</p>
				                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalEmp">${totalEmp}</p>
				            </div>
				        </div>
				    </div>
				
				    <div class="bg-white rounded-lg border border-gray-200 p-4">
				        <div class="flex items-center gap-4">
				            <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
				                <i class="fas fa-building w-6 h-6 text-blue-600"></i>
				            </div>
				            <div>
				                <p class="text-sm text-gray-500">전체 직영점 수</p>
				                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalBranch">${totalBranch - 1}</p>
				            </div>
				        </div>
				    </div>
				
				    <div class="bg-white rounded-lg border border-gray-200 p-4">
				        <div class="flex items-center gap-4">
				            <div class="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center">
				                <i class="fas fa-user-plus w-6 h-6 text-yellow-600"></i>
				            </div>
				            <div>
				                <p class="text-sm text-gray-500">올해 신입 인원</p>
				                <p class="text-2xl font-bold text-gray-900 mt-1" id="newEmpCnt">${newEmpCnt}</p>
				            </div>
				        </div>
				    </div>
				</div>

                   <!-- 필터 섹션 -->
                   <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
                       <div class="flex flex-col gap-4">
                           <!-- 검색 -->
                           <div class="flex items-center justify-between gap-4">
                           	<div>
                           		<h3 class="text-sm font-semibold text-gray-800">직원 검색</h3>
                           		<p class="text-xs text-gray-500 mt-1">사번, 소속, 부서, 이름 기준으로 검색할 수 있습니다.</p>
                           	</div>
                           	
                           	<div class="flex items-center gap-2">
                           		<!-- 소속명 선택 -->
				                <select id="branchNameSelect"
				                        class="w-44 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
				                    <option value="">전체 소속</option>
									<c:forEach var="branch" items="${branchNameList}">
									    <option value="${branch.branchName}">
									        ${branch.branchName}
									    </option>
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

                    <!-- 직원 테이블 -->
					<div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
					    <div class="overflow-x-auto">
					        <table class="w-full">
					            <thead class="bg-gray-50 border-b border-gray-200">
					                <tr>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">이름</th>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">소속</th>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">부서</th>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">직급</th>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">역할</th>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">연락처</th>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
					                    <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
					                </tr>
					            </thead>
					            <tbody id="employeeTableBody" class="bg-white divide-y divide-gray-200">
					                <!-- 동적 생성 -->
					            </tbody>
					        </table>
					    </div>
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
                </div>
            </main>
        </div>
    </div>
    
    <!-- 신규 직원 등록 모달 -->
    <div id="addModal" class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onclick="if(event.target === this) closeAddModal()">
        <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto" onclick="event.stopPropagation()">
            <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white">
                <h3 class="text-lg font-bold text-gray-900">신규 직원 등록</h3>
                <button onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times w-5 h-5"></i>
                </button>
            </div>

            <div class="p-6 space-y-4">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">이름</label>
                        <input type="text" id="name" name="name" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent" placeholder="홍길동">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">사번</label>
                        <input type="text" id="empNo" name="empNo" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent" placeholder="EMP-007">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">소속</label>
                        <select name="branchCode" id ="branchCode" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
                            <option value="">선택하세요</option>
	                        <c:forEach var="branch" items="${branchNameList}">
	                        	<option value="${branch.branchCode }" class="text-gray-900 bg-white">${branch.branchName}</option>
	                        </c:forEach>
	                    </select>
	                </div>
	                <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">부서</label>
                        <input type="text" id="dept" name="dept" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent" placeholder="영업팀">
                    </div>
	                
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">직급</label>
                        <select id="gradeCode" name="gradeCode" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
					        <option value="">선택하세요</option>
					        <option value="">선택 안 함</option>
					        <option value="GR_DIR">부장</option>
					        <option value="GR_DPT">차장</option>
					        <option value="GR_MGR">과장</option>
					        <option value="GR_AST">대리</option>
					        <option value="GR_STF">사원</option>
					        <option value="GR_DRV">배달기사</option>
					    </select>
                    </div>
	                <div>
					    <label class="block text-sm font-medium text-gray-700 mb-1">역할</label>
					    <select id="positionCode" name="positionCode" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
					        <option value="">선택하세요</option>
					        <option value="">선택 안 함</option>
					        <option value="POS_MGR">점장</option>
					        <option value="POS_SUP">매니저</option>
					        <option value="POS_STF">직원</option>
					        <option value="POS_PTM">알바</option>
					    </select>
					</div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">연락처</label>
                        <input type="tel" id="phone" name="phone" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent" placeholder="010-0000-0000">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
                        <input type="email" id="email" name="email" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent" placeholder="user@zeroloss.com">
                    </div>
                    <div>
					    <label class="block text-sm font-medium text-gray-700 mb-1">입사일</label>
					    <div class="relative">
					        <input type="text" id="hireDate" name="hireDate" readonly onclick="openCustomDatePicker('hireDate', event)" placeholder="YYYY-MM-DD" class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent bg-white cursor-pointer">
					        <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
					    </div>
					</div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
                        <select id="status" name="status" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
                            <option value="ACTIVE">재직</option>
					        <option value="LEAVE">휴직</option>
					        <option value="RESIGNED">퇴사</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
                <button onclick="closeAddModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                    취소
                </button>
                <button type="button" onclick="saveEmployee()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
                    추가
                </button>
            </div>
        </div>
    </div>

    <!-- Edit Employee Modal -->
	<div id="editModal" class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4" onclick="if(event.target === this) closeEditModal()">
	    <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto" onclick="event.stopPropagation()">
	        <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white">
	            <h3 class="text-lg font-bold text-gray-900">직원 상세 조회</h3>
	            <div class="flex items-center gap-3">
	                <button type="button" id="editModeBtn" onclick="changeToEditMode()"
	                        class="px-3 py-1.5 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
	                    수정
	                </button>
	
	                <button type="button" onclick="closeEditModal()" class="text-gray-400 hover:text-gray-600">
	                    <i class="fas fa-times w-5 h-5"></i>
	                </button>
	            </div>
	        </div>
	
	        <div class="p-6 space-y-4">
	            <input type="hidden" id="editEmpNo" name="editEmpNo">
	
	            <div class="grid grid-cols-2 gap-4">
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">이름</label>
	                    <input type="text" id="editName" readonly
	                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">사번</label>
	                    <input type="text" id="editEmpNoView" readonly
	                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">소속</label>
	                    <select name="editBranchCode" id="editBranchCode" disabled
	                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-500 bg-gray-100 cursor-not-allowed">
	                        <option value="">선택하세요</option>
	                        <c:forEach var="branch" items="${branchNameList}">
	                            <option value="${branch.branchCode}" class="text-gray-900 bg-white">${branch.branchName}</option>
	                        </c:forEach>
	                    </select>
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">부서</label>
	                    <input type="text" id="editDept" name="editDept" readonly
	                           class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">직급</label>
	                    <select id="editGradeCode" name="editGradeCode" disabled
	                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-500 bg-gray-100 cursor-not-allowed">
	                        <option value="">선택하세요</option>
	                        <option value="">선택 안 함</option>
	                        <option value="GR_DIR">부장</option>
	                        <option value="GR_DPT">차장</option>
	                        <option value="GR_MGR">과장</option>
	                        <option value="GR_AST">대리</option>
	                        <option value="GR_STF">사원</option>
	                        <option value="GR_DRV">배달기사</option>
	                    </select>
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">역할</label>
	                    <select id="editPositionCode" name="editPositionCode" disabled
	                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-500 bg-gray-100 cursor-not-allowed">
	                        <option value="">선택하세요</option>
	                        <option value="">선택 안 함</option>
	                        <option value="POS_MGR">점장</option>
	                        <option value="POS_SUP">매니저</option>
	                        <option value="POS_STF">직원</option>
	                        <option value="POS_PTM">알바</option>
	                    </select>
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">연락처</label>
	                    <input type="text" id="editPhone" name="editPhone" readonly
	                           class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
	                    <input type="email" id="editEmail" name="editEmail" readonly
	                           class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">입사일</label>
	                    <input type="text" id="editHireDate" readonly
	                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
	                </div>
	
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
	                    <select id="editStatus" name="editStatus" disabled
	                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-500 bg-gray-100 cursor-not-allowed">
	                        <option value="ACTIVE">재직</option>
	                        <option value="LEAVE">휴직</option>
	                        <option value="RESIGNED">퇴사</option>
	                    </select>
	                </div>
	            </div>
	        </div>
	
	        <div class="border-t border-gray-200 px-6 py-3 flex justify-end gap-3 sticky bottom-0 bg-white">
	            <button type="button" onclick="closeEditModal()"
	                    class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
	                닫기
	            </button>
	
	            <button type="button" id="saveBtn" onclick="updateEmployee()"
	                    class="hidden px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
	                저장
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
	    /************************************************************
	     커스텀 날짜 선택기
	     ************************************************************/
	
	    var customDateTargetId = null;
	    var customPickerDate = new Date();
	
	    function formatDateLocal(date) {
	        return date.getFullYear() + '-' +
	            String(date.getMonth() + 1).padStart(2, '0') + '-' +
	            String(date.getDate()).padStart(2, '0');
	    }
	
	    function parseDateLocal(dateStr) {
	        if (!dateStr) {
	            return null;
	        }
	
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
	
	    function openCustomDatePicker(inputId, event) {
	        if (event) {
	            event.stopPropagation();
	        }
	
	        customDateTargetId = inputId;
	
	        var input = document.getElementById(inputId);
	
	        if (!input) {
	            return;
	        }
	
	        var selectedDate = parseDateLocal(input.value);
	
	        customPickerDate = selectedDate || new Date();
	
	        renderCustomDatePicker();
	        positionCustomDatePicker(input);
	
	        document.getElementById('customDatePicker').classList.remove('hidden');
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
	
	        var selectedYear = Number(yearSelect.value);
	        var selectedMonth = Number(monthSelect.value);
	
	        customPickerDate = new Date(selectedYear, selectedMonth, 1);
	
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
	            days.push({
	                date: new Date(year, month - 1, prevLastDay.getDate() - i),
	                currentMonth: false
	            });
	        }
	
	        for (var d = 1; d <= lastDay.getDate(); d++) {
	            days.push({
	                date: new Date(year, month, d),
	                currentMonth: true
	            });
	        }
	
	        var nextDay = 1;
	
	        while (days.length < 42) {
	            days.push({
	                date: new Date(year, month + 1, nextDay),
	                currentMonth: false
	            });
	
	            nextDay++;
	        }
	
	        var targetInput = customDateTargetId ? document.getElementById(customDateTargetId) : null;
	        var selectedValue = targetInput ? targetInput.value : '';
	        var todayValue = formatDateLocal(new Date());
	
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
	
	    document.addEventListener('mousedown', function (event) {
	        var picker = document.getElementById('customDatePicker');
	
	        if (!picker || picker.classList.contains('hidden')) {
	            return;
	        }
	
	        var target = event.target;
	
	        if (picker.contains(target)) {
	            return;
	        }
	
	        if (
	            customDateTargetId &&
	            document.getElementById(customDateTargetId) &&
	            document.getElementById(customDateTargetId).contains(target)
	        ) {
	            return;
	        }
	
	        closeCustomDatePicker();
	    });
    
	    /************************************************************
	     * 1. 전역 변수
	     ************************************************************/
	
	    // 상세 조회 또는 수정 중인 직원 정보
	    var selectedEmployee = null;
	
	    // 현재 페이지 번호
	    var currentPage = 1;
	
	    // 한 페이지에 보여줄 직원 수
	    var pageSize = 10;
	
	    // 페이지네이션에서 한 번에 보여줄 페이지 버튼 개수
	    var PAGE_SIZE = 5;
	
	
	    /************************************************************
	     * 2. 서버에서 전달받은 직원 데이터
	     ************************************************************/
	
	    var employees = [
	        <c:forEach var="emp" items="${employeeList}" varStatus="st">
	        {
	            empNo: "${emp.empNo}",
	            name: "${emp.name}",
	            branchCode: "${emp.branchCode}",
	            branchName: "${emp.branchName}",
	            dept: "${emp.dept}",
	            gradeCode: "${emp.gradeCode}",
	            gradeName: "${emp.gradeName}",
	            positionCode: "${emp.positionCode}",
	            positionName: "${emp.positionName}",
	            phone: "${emp.phone}",
	            email: "${emp.email}",
	            hireDate: "${emp.hireDate}",
	            status: "${emp.status}"
	        }<c:if test="${!st.last}">,</c:if>
	        </c:forEach>
	    ];
	
	
	    /************************************************************
	     * 3. 초기 실행
	     ************************************************************/
	
	    window.addEventListener("DOMContentLoaded", function () {
	        // 처음 화면에서는 바로 목록을 보여주지 않고 안내 문구만 표시
	        clearEmployeeTable();
	
	        // 모바일 사이드바 버튼 이벤트 연결
	        setupSidebarToggle();
	    });
	
	
	    /************************************************************
	     * 4. 사이드바 / 사용자 메뉴
	     ************************************************************/
	
	    // 모바일 사이드바 토글 이벤트 연결
	    function setupSidebarToggle() {
	        var sidebarToggle = document.getElementById('mobileMenuBtn');
	        var sidebar = document.getElementById('sidebar');
	        var backdrop = document.getElementById('sidebarBackdrop');
	
	        if (sidebarToggle) {
	            sidebarToggle.addEventListener('click', function () {
	                toggleSidebar();
	            });
	        }
	
	        if (backdrop) {
	            backdrop.addEventListener('click', function () {
	                if (sidebar) {
	                    sidebar.classList.add('-translate-x-full');
	                }
	
	                backdrop.classList.add('hidden');
	            });
	        }
	    }
	
	    // 모바일 사이드바 열기 / 닫기
	    function toggleSidebar() {
	        var sidebar = document.getElementById('sidebar');
	        var backdrop = document.getElementById('sidebarBackdrop');
	
	        if (sidebar) {
	            sidebar.classList.toggle('-translate-x-full');
	        }
	
	        if (backdrop) {
	            backdrop.classList.toggle('hidden');
	        }
	    }
	
	    // 우측 상단 사용자 메뉴 열기 / 닫기
	    function toggleUserMenu() {
	        var userMenu = document.getElementById('userMenu');
	
	        if (userMenu) {
	            userMenu.classList.toggle('hidden');
	        }
	    }
	
	    // 로그아웃 처리
	    function logout() {
	        commonShowAlert('알림', '로그아웃되었습니다.');
	    }
	
	    // 사이드바 하위 메뉴 열기 / 닫기
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
	
	
	    /************************************************************
	     * 5. 직원 목록 조회 / 렌더링
	     ************************************************************/
	
	    // 검색 조건에 맞는 직원 목록 반환
	    function getFilteredEmployees() {
	        var searchTerm = document.getElementById("searchInput").value.trim().toLowerCase();
	        var selectedBranchName = document.getElementById("branchNameSelect").value.trim();
	
	        return employees.filter(function (employee) {
	            var empNo = String(employee.empNo || "").toLowerCase();
	            var name = String(employee.name || "").toLowerCase();
	            var branchName = String(employee.branchName || "").toLowerCase();
	            var dept = String(employee.dept || "").toLowerCase();
	            var gradeName = String(employee.gradeName || "").toLowerCase();
	            var gradeCode = String(employee.gradeCode || "").toLowerCase();
	            var positionName = String(employee.positionName || "").toLowerCase();
	            var positionCode = String(employee.positionCode || "").toLowerCase();
	
	            // 검색어가 없으면 검색 조건은 통과
	            var matchesSearch = searchTerm === "" ||
	                empNo.includes(searchTerm) ||
	                name.includes(searchTerm) ||
	                branchName.includes(searchTerm) ||
	                dept.includes(searchTerm) ||
	                gradeName.includes(searchTerm) ||
	                gradeCode.includes(searchTerm) ||
	                positionName.includes(searchTerm) ||
	                positionCode.includes(searchTerm);
	
	            // 소속을 선택하지 않았으면 소속 조건은 통과
	            var matchesBranch = selectedBranchName === "" ||
	                employee.branchName === selectedBranchName;
	
	            return matchesSearch && matchesBranch;
	        });
	    }
	
	    // 직원 테이블 렌더링
	    function renderEmployees() {
	        var filtered = getFilteredEmployees();
	        var tbody = document.getElementById('employeeTableBody');
	
	        if (filtered.length === 0) {
	            tbody.innerHTML =
	                '<tr>' +
	                    '<td colspan="8" class="px-6 py-8 text-center text-gray-500">' +
	                        '검색 결과가 없습니다.' +
	                    '</td>' +
	                '</tr>';
	
	            renderPagination(0, 0);
	            return;
	        }
	
	        var totalPages = Math.ceil(filtered.length / pageSize);
	
	        if (currentPage > totalPages) {
	            currentPage = totalPages;
	        }
	
	        var start = (currentPage - 1) * pageSize;
	        var end = start + pageSize;
	        var pageList = filtered.slice(start, end);
	
	        tbody.innerHTML = pageList.map(function (emp) {
	            return makeEmployeeRow(emp);
	        }).join('');
	
	        renderPagination(totalPages, filtered.length);
	    }
	
	    // 직원 테이블 한 줄 HTML 생성
	    function makeEmployeeRow(emp) {
	        var statusInfo = getStatusInfo(emp.status);
	
	        return '<tr class="hover:bg-gray-50">' +
	            '<td class="px-4 py-3 whitespace-nowrap">' +
	                '<div class="flex items-center gap-3">' +
	                    '<div class="w-8 h-8 rounded-full bg-[#00853D] flex items-center justify-center text-white font-semibold text-xs">' +
	                        (emp.name ? emp.name.charAt(0) : '-') +
	                    '</div>' +
	                    '<div>' +
	                        '<div class="font-medium text-gray-900 text-sm">' + (emp.name || '-') + '</div>' +
	                        '<div class="text-xs text-gray-500">사번: ' + (emp.empNo || '-') + '</div>' +
	                    '</div>' +
	                '</div>' +
	            '</td>' +
	
	            '<td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">' + (emp.branchName || '-') + '</td>' +
	            '<td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">' + (emp.dept || '-') + '</td>' +
	            '<td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">' + (emp.gradeName || '-') + '</td>' +
	            '<td class="px-4 py-3 whitespace-nowrap text-sm text-gray-900">' + (emp.positionName || '-') + '</td>' +
	
	            '<td class="px-4 py-3 whitespace-nowrap">' +
	                '<div class="text-sm text-gray-900">' + (emp.phone || '-') + '</div>' +
	                '<div class="text-xs text-gray-500">' + (emp.email || '-') + '</div>' +
	            '</td>' +
	
	            '<td class="px-4 py-3 whitespace-nowrap">' +
	                '<span class="inline-flex px-2 py-0.5 text-xs font-medium rounded-full ' + statusInfo.className + '">' +
	                    statusInfo.text +
	                '</span>' +
	            '</td>' +
	
	            '<td class="px-4 py-3 whitespace-nowrap">' +
	                '<button onclick="openEmployeeModal(\'' + emp.empNo + '\')" class="text-blue-600 hover:text-blue-700 text-sm font-medium">' +
	                    '상세보기' +
	                '</button>' +
	            '</td>' +
	        '</tr>';
	    }
	
	    // 직원 상태값에 따른 표시명과 색상 반환
	    function getStatusInfo(status) {
	        if (status === 'ACTIVE') {
	            return {
	                text: '재직',
	                className: 'bg-green-100 text-green-700'
	            };
	        }
	
	        if (status === 'LEAVE') {
	            return {
	                text: '휴직',
	                className: 'bg-yellow-100 text-yellow-700'
	            };
	        }
	
	        if (status === 'RESIGNED') {
	            return {
	                text: '퇴사',
	                className: 'bg-red-100 text-red-700'
	            };
	        }
	
	        return {
	            text: status || '-',
	            className: 'bg-gray-100 text-gray-700'
	        };
	    }
	
	    // 최초 진입 또는 초기화 시 안내 문구 표시
	    function clearEmployeeTable() {
	        var tbody = document.getElementById('employeeTableBody');
	
	        tbody.innerHTML =
	            '<tr>' +
	                '<td colspan="8" class="px-6 py-8 text-center text-gray-500">' +
	                    '조회 버튼을 눌러 직원을 검색하세요.' +
	                '</td>' +
	            '</tr>';
	    }
	
	
	    /************************************************************
	     * 6. 페이지네이션
	     ************************************************************/
	
	    // 페이지네이션 렌더링
	    function renderPagination(totalPages, totalItems) {
	        var paginationContainer = document.getElementById('paginationContainer');
	        var paginationInfo = document.getElementById('paginationInfo');
	        var pageButtons = document.getElementById('pageButtons');
	
	        if (!paginationContainer || !paginationInfo || !pageButtons) {
	            console.error('페이지네이션 HTML 요소를 찾을 수 없습니다.');
	            return;
	        }
	
	        // 1페이지 이하면 페이지네이션 숨김
	        if (totalPages <= 1 || totalItems <= pageSize) {
	            paginationContainer.classList.add('hidden');
	            paginationInfo.textContent = '';
	            pageButtons.innerHTML = '';
	            return;
	        }
	
	        paginationContainer.classList.remove('hidden');
	
	        var startIndex = (currentPage - 1) * pageSize;
	        var endIndex = Math.min(startIndex + pageSize, totalItems);
	
	        paginationInfo.textContent =
	            (startIndex + 1) + '-' + endIndex + ' / ' + totalItems + '개';
	
	        var baseClass = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
	        var activeClass = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
	        var arrowClass = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';
	
	        var blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
	        var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);
	
	        var html = '';
	
	        // 첫 페이지 버튼
	        html += '<button class="' + arrowClass + '" onclick="changePage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
	        html += '<i class="fas fa-angles-left text-xs"></i>';
	        html += '</button>';
	
	        // 이전 페이지 블록 버튼
	        var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
	
	        html += '<button class="' + arrowClass + '" onclick="changePage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
	        html += '<i class="fas fa-chevron-left text-xs"></i>';
	        html += '</button>';
	
	        // 숫자 페이지 버튼
	        for (var i = blockStart; i <= blockEnd; i++) {
	            html += '<button class="' + (i === currentPage ? activeClass : baseClass) + '" onclick="changePage(' + i + ')">';
	            html += i;
	            html += '</button>';
	        }
	
	        // 다음 페이지 블록 버튼
	        var nextBlockPage = Math.min(totalPages, blockEnd + 1);
	
	        html += '<button class="' + arrowClass + '" onclick="changePage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
	        html += '<i class="fas fa-chevron-right text-xs"></i>';
	        html += '</button>';
	
	        // 마지막 페이지 버튼
	        html += '<button class="' + arrowClass + '" onclick="changePage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
	        html += '<i class="fas fa-angles-right text-xs"></i>';
	        html += '</button>';
	
	        pageButtons.innerHTML = html;
	    }
	
	    // 페이지 변경
	    function changePage(page) {
	        var filtered = getFilteredEmployees();
	        var totalPages = Math.ceil(filtered.length / pageSize);
	
	        if (page < 1 || page > totalPages) {
	            return;
	        }
	
	        currentPage = page;
	        renderEmployees();
	
	        window.scrollTo({
	            top: 0,
	            behavior: 'smooth'
	        });
	    }
	
	
	    /************************************************************
	     * 7. 신규 직원 등록
	     ************************************************************/
	
	    // 신규 직원 등록 모달 열기
	    function showAddModal() {
	    	var hireDateInput = document.getElementById("hireDate");

	        if (hireDateInput && !hireDateInput.value) {
	            hireDateInput.value = formatDateLocal(new Date());
	        }
	        document.getElementById("addModal").classList.remove("modal-hidden");
	    }
	
	    // 신규 직원 등록 모달 닫기 및 입력값 초기화
	    function closeAddModal() {
	    	closeCustomDatePicker();
	    	
	        var modal = document.getElementById("addModal");
	
	        modal.classList.add("modal-hidden");
	
	        modal.querySelectorAll("input").forEach(function (input) {
	            input.value = "";
	        });
	
	        modal.querySelectorAll("select").forEach(function (select) {
	            select.selectedIndex = 0;
	        });
	
	        document.getElementById("status").value = "ACTIVE";
	    }
	
	    // 신규 직원 저장
	    function saveEmployee() {
	        var params = new URLSearchParams();
	
	        var branchSelect = document.getElementById("branchCode");
	        var branchName = branchSelect.options[branchSelect.selectedIndex]
	            ? branchSelect.options[branchSelect.selectedIndex].text.trim()
	            : "";
	
	        params.append("action", "add");
	        params.append("empNo", document.getElementById("empNo").value);
	        params.append("name", document.getElementById("name").value);
	        params.append("branchCode", branchSelect.value);
	        params.append("branchName", branchName);
	        params.append("dept", document.getElementById("dept").value);
	        params.append("gradeCode", document.getElementById("gradeCode").value);
	        params.append("positionCode", document.getElementById("positionCode").value);
	        params.append("phone", document.getElementById("phone").value);
	        params.append("email", document.getElementById("email").value);
	        params.append("hireDate", document.getElementById("hireDate").value);
	        params.append("status", document.getElementById("status").value);
	
	        fetch("<%= request.getContextPath() %>/hq/hr/employee", {
	            method: "POST",
	            headers: {
	                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
	            },
	            body: params.toString()
	        })
	        .then(function (response) {
	            return response.text();
	        })
	        .then(function (text) {
	            var data = JSON.parse(text);
	
	            if (data.success) {
	                commonShowAlert('알림', "직원이 등록되었습니다.");
	                closeAddModal();
	                location.reload();
	            } else {
	                commonShowAlert('알림', data.message || "직원 등록에 실패했습니다.");
	            }
	        })
	        .catch(function (error) {
	            console.error(error);
	            commonShowAlert('알림', "직원 등록 중 오류가 발생했습니다.");
	        });
	    }
	
	
	    /************************************************************
	     * 8. 직원 상세 조회 / 수정
	     ************************************************************/
	
	    // 직원 상세 모달 열기
	    function openEmployeeModal(empNo) {
	        selectedEmployee = employees.find(function (emp) {
	            return String(emp.empNo) === String(empNo);
	        });
	
	        if (!selectedEmployee) {
	            commonShowAlert('알림', "직원 정보를 찾을 수 없습니다.");
	            return;
	        }
	
	        resetEditMode();
	        setEmployeeDetailValues(selectedEmployee);
	
	        document.getElementById("editModal").classList.remove("modal-hidden");
	    }
	
	    // 상세 모달에 직원 데이터 세팅
	    function setEmployeeDetailValues(employee) {
	        document.getElementById("editEmpNo").value = employee.empNo;
	        document.getElementById("editEmpNoView").value = employee.empNo;
	        document.getElementById("editName").value = employee.name || "";
	        document.getElementById("editBranchCode").value = employee.branchCode || "";
	        document.getElementById("editDept").value = employee.dept || "";
	        document.getElementById("editGradeCode").value = employee.gradeCode || "";
	        document.getElementById("editPositionCode").value = employee.positionCode || "";
	        document.getElementById("editPhone").value = employee.phone || "";
	        document.getElementById("editEmail").value = employee.email || "";
	        document.getElementById("editHireDate").value = employee.hireDate || "";
	        document.getElementById("editStatus").value = employee.status || "ACTIVE";
	    }
	
	    // 상세 모달 닫기
	    function closeEditModal() {
	        document.getElementById('editModal').classList.add('modal-hidden');
	    }
	
	    // 상세 조회 모드에서 수정 모드로 변경
	    function changeToEditMode() {
	        document.querySelector("#editModal h3").innerText = "직원 정보 수정";
	        document.getElementById("editModeBtn").classList.add("hidden");
	        document.getElementById("saveBtn").classList.remove("hidden");
	
	        document.querySelectorAll(".editable-field").forEach(function (field) {
	            if (field.tagName === "SELECT") {
	                field.disabled = false;
	            } else {
	                field.readOnly = false;
	            }
	
	            field.classList.remove("bg-gray-100", "text-gray-500", "cursor-not-allowed");
	            field.classList.add("bg-white", "text-gray-900", "focus:ring-2", "focus:ring-[#00853D]", "focus:border-transparent");
	        });
	
	        applyEditRestrictions();
	    }
	
	    // 직원 소속에 따른 수정 제한 적용
	    function applyEditRestrictions() {
	        if (!selectedEmployee) {
	            return;
	        }
	
	        var branchName = String(selectedEmployee.branchName || "").trim();
	
	        var positionField = document.getElementById("editPositionCode");
	        var gradeField = document.getElementById("editGradeCode");
	
	        // 본사 소속이면 역할 수정 불가
	        if (branchName === "본사") {
	            disableEditField(positionField);
	        }
	
	        // 본사 소속이 아니면 직급 수정 불가
	        if (branchName !== "본사") {
	            disableEditField(gradeField);
	        }
	    }
	
	    // 특정 필드를 비활성화 상태로 변경
	    function disableEditField(field) {
	        if (!field) {
	            return;
	        }
	
	        if (field.tagName === "SELECT") {
	            field.disabled = true;
	        } else {
	            field.readOnly = true;
	        }
	
	        field.classList.add("bg-gray-100", "text-gray-500", "cursor-not-allowed");
	        field.classList.remove("bg-white", "text-gray-900", "focus:ring-2", "focus:ring-[#00853D]", "focus:border-transparent");
	    }
	
	    // 수정 모드를 다시 상세 조회 모드로 초기화
	    function resetEditMode() {
	        document.querySelector("#editModal h3").innerText = "직원 상세 조회";
	        document.getElementById("editModeBtn").classList.remove("hidden");
	        document.getElementById("saveBtn").classList.add("hidden");
	
	        document.querySelectorAll(".editable-field").forEach(function (field) {
	            if (field.tagName === "SELECT") {
	                field.disabled = true;
	            } else {
	                field.readOnly = true;
	            }
	
	            field.classList.remove("bg-white", "text-gray-900", "focus:ring-2", "focus:ring-[#00853D]", "focus:border-transparent");
	            field.classList.add("bg-gray-100", "text-gray-500", "cursor-not-allowed");
	        });
	    }
	
	    // 직원 수정 저장
	    function updateEmployee() {
	        if (!selectedEmployee) {
	            return;
	        }
	
	        var params = new URLSearchParams();
	
	        params.append("action", "update");
	        params.append("empNo", selectedEmployee.empNo);
	        params.append("branchCode", document.getElementById("editBranchCode").value);
	        params.append("dept", document.getElementById("editDept").value);
	        params.append("gradeCode", document.getElementById("editGradeCode").value);
	        params.append("positionCode", document.getElementById("editPositionCode").value);
	        params.append("phone", document.getElementById("editPhone").value);
	        params.append("email", document.getElementById("editEmail").value);
	        params.append("status", document.getElementById("editStatus").value);
	
	        fetch("<%= request.getContextPath() %>/hq/hr/employee", {
	            method: "POST",
	            headers: {
	                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
	            },
	            body: params.toString()
	        })
	        .then(function (response) {
	            return response.json();
	        })
	        .then(function (data) {
	            if (data.success) {
	                commonShowAlert('알림', "직원 정보가 수정되었습니다.");
	                closeEditModal();
	                location.reload();
	            } else {
	                commonShowAlert('알림', data.message || "직원 수정에 실패했습니다.");
	            }
	        })
	        .catch(function (error) {
	            console.error(error);
	            location.href = "<%= request.getContextPath() %>/common/500.jsp";
	        });
	    }
	
	
	    /************************************************************
	     * 9. 검색 / 초기화
	     ************************************************************/
	
	    // 조회 버튼 클릭 또는 Enter 입력 시 실행
	    function applyFilters() {
	        currentPage = 1;
	        renderEmployees();
	    }
	
	    // 검색 조건 초기화
	    function resetFilters() {
	        document.getElementById("searchInput").value = "";
	        document.getElementById('branchNameSelect').value = '';
	
	        currentPage = 1;
	
	        clearEmployeeTable();
	        clearPagination();
	    }
	
	    // 페이지네이션 영역 초기화
	    function clearPagination() {
	        document.getElementById('paginationContainer').classList.add('hidden');
	        document.getElementById('paginationInfo').textContent = '';
	        document.getElementById('pageButtons').innerHTML = '';
	    }
	</script>
</body>
</html>

