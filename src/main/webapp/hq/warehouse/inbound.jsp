<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>본사 물류창고 입고 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<%@ page import="com.google.gson.Gson"%>
<style>
.sidebar-open .sidebar {
	transform: translateX(0);
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
<%
@SuppressWarnings("unchecked")
List<String> supplierNameList = (List<String>) request.getAttribute("supplierNameList");
@SuppressWarnings("unchecked")
Map<String, List<String>> categoryMaterialMap = (Map<String, List<String>>) request.getAttribute("categoryMaterialMap");

Gson gson = new Gson();
String supplierJson = gson.toJson(supplierNameList);
String categoryJson = gson.toJson(categoryMaterialMap);

// 품목 - 단가
@SuppressWarnings("unchecked")
Map<String, Integer> materialPriceMap = (Map<String, Integer>) request.getAttribute("materialPriceMap");
String priceJson = gson.toJson(materialPriceMap);
%>

<script>
	const supplierNameList = <%=supplierJson%>;
	const categoryMaterialMap = <%=categoryJson%>;
    const materialPriceMap = <%=priceJson%>;
</script>
</head>
<body class="bg-gray-50">

	<%@ include file="/hq/common/sidebar.jsp"%>

	<div class="lg:pl-72">
		<main class="p-6">

			<!-- ===== 페이지 헤더 ===== -->
			<div class="flex items-center justify-between mb-6">
			    <div>
			        <h2 class="text-3xl font-bold text-gray-900">본사 물류창고 입고</h2>
			        <p class="text-gray-500 mt-1">신규 입고를 등록하고 입고 이력을 관리하세요</p>
			    </div>
			
			    <button type="button"
			            onclick="openReceiveModal()"
			            class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2.5 rounded-lg hover:bg-[#006B2F] transition-colors">
			        <i class="fas fa-plus w-5 h-5"></i>
			        <span>신규 입고 등록</span>
			    </button>
			</div>
			
			<!-- ===== 검색 필터 영역 ===== -->
			<div class="bg-white rounded-xl border border-gray-200 p-6 shadow-sm mb-6">
			    <div class="flex flex-col gap-4">
			
			        <!-- 상단: 설명 -->
			        <div>
			            <h3 class="text-sm font-semibold text-gray-800">입고 이력 검색</h3>
			            <p class="text-xs text-gray-500 mt-1">
			                공급사, 카테고리, 품목명, 일자 범위 기준으로 입고 이력을 조회할 수 있습니다.
			            </p>
			        </div>
			
			        <!-- 하단: 필터 + 버튼 -->
			        <div class="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-4 pt-4 border-t border-gray-100">
			
			            <!-- 필터 영역 -->
			            <div class="flex flex-wrap items-center gap-3">
			
			                <!-- 공급사 -->
			                <select id="filterSupplier"
			                        class="w-52 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
			                    <option value="전체">전체 공급사</option>
			                    <%
			                    if (supplierNameList != null) {
			                        for (String supplier : supplierNameList) {
			                    %>
			                    <option value="<%=supplier%>"><%=supplier%></option>
			                    <%
			                        }
			                    }
			                    %>
			                </select>
			
			                <!-- 카테고리 -->
			                <select id="filterCategory"
			                        onchange="updateFilterItemNames()"
			                        class="w-48 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
			                    <option value="전체">전체 카테고리</option>
			                    <%
			                    if (categoryMaterialMap != null) {
			                        for (String category : categoryMaterialMap.keySet()) {
			                    %>
			                    <option value="<%=category%>"><%=category%></option>
			                    <%
			                        }
			                    }
			                    %>
			                </select>
			
			                <!-- 품목명 -->
			                <select id="filterItemName"
			                        class="w-52 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
			                    <option value="전체">전체 품목</option>
			                </select>
			
			                <!-- 시작일 -->
							<div class="relative w-52">
							    <input type="text"
							           id="filterStartDate"
							           readonly
							           onclick="openCustomDatePicker('filterStartDate', event)"
							           placeholder="시작일 선택"
							           class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
							
							    <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
							</div>
							
							<span class="text-gray-500 text-sm">~</span>
							
							<!-- 종료일 -->
							<div class="relative w-52">
							    <input type="text"
							           id="filterEndDate"
							           readonly
							           onclick="openCustomDatePicker('filterEndDate', event)"
							           placeholder="종료일 선택"
							           class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
							
							    <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
							</div>
			            </div>
			
			            <!-- 버튼 영역 -->
			            <div class="flex items-center gap-2 xl:ml-4 xl:shrink-0">
			                <button type="button"
			                        onclick="applyFilters()"
			                        class="px-5 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">
			                    조회
			                </button>
			
			                <button type="button"
			                        onclick="resetFilters()"
			                        class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">
			                    초기화
			                </button>
			            </div>
			        </div>
			    </div>
			</div>

			<!-- ===== 입고 이력 테이블 ===== -->
			<div
				class="bg-white rounded-lg border border-gray-200 overflow-hidden">
				<div
					class="px-6 py-3 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
					<h3 class="text-base font-semibold text-gray-900">입고 이력 리스트</h3>
					<p class="text-base text-gray-500">
						조회 건수 <span id="totalRecords" class="font-semibold text-gray-700">0건</span>
					</p>
				</div>
				<div class="overflow-x-auto">
					<table class="w-full">
						<thead class="bg-gray-50 border-b border-gray-200">
							<tr>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">날짜/시간</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">공급사</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">카테고리</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">품목명</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">수량</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">단가</th>
								<th
									class="text-right py-4 px-6 text-sm font-semibold text-gray-900">합계</th>
								<th
									class="text-left  py-4 px-6 text-sm font-semibold text-gray-900">유통기한</th>
							</tr>
						</thead>
						<tbody id="inboundTableBody"></tbody>
					</table>
				</div>

				<!-- 페이지네이션 -->
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

		</main>
	</div>

	<!-- ===== 신규 입고 등록 모달 ===== -->
	<div id="receiveModal"
	     class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
	     onclick="if(event.target === this) closeReceiveModal()">
	
	    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto"
	         onclick="event.stopPropagation()">
	
	        <!-- 모달 헤더 -->
	        <div class="border-b border-gray-200 px-6 py-3 flex items-center justify-between sticky top-0 bg-white">
	            <h3 class="text-lg font-bold text-gray-900">신규 입고 등록</h3>
	            <button type="button" onclick="closeReceiveModal()" class="text-gray-400 hover:text-gray-600">
	                <i class="fas fa-times w-5 h-5"></i>
	            </button>
	        </div>
	
	        <!-- 입고 등록 폼 -->
	        <div class="p-6 space-y-4">
	            <div class="grid grid-cols-2 gap-4">
	
	                <!-- 공급사 -->
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">공급사 <span class="text-red-500">*</span></label>
	                    <select id="formSupplier"
	                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
	                        <option value="">선택하세요</option>
	                        <%
	                        for (String supplier : supplierNameList) {
	                        %>
	                        <option value="<%=supplier%>"><%=supplier%></option>
	                        <%
	                        }
	                        %>
	                    </select>
	                </div>
	
	                <!-- 카테고리 -->
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">카테고리 <span class="text-red-500">*</span></label>
	                    <select id="formCategory"
	                            onchange="updateFormItemNames()"
	                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
	                        <option value="">선택하세요</option>
	                        <%
	                        for (String category : categoryMaterialMap.keySet()) {
	                        %>
	                        <option value="<%=category%>"><%=category%></option>
	                        <%
	                        }
	                        %>
	                    </select>
	                </div>
	
	                <!-- 품목 -->
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">품목명 <span class="text-red-500">*</span></label>
	                    <select id="formItem"
	                            onchange="handleItemChange()"
	                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm text-gray-900 bg-white">
	                        <option value="">카테고리를 먼저 선택하세요</option>
	                    </select>
	                </div>
	
	                <!-- 수량 -->
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">수량 <span class="text-red-500">*</span></label>
	                    <input type="number"
	                           id="formQuantity"
	                           min="1"
	                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
	                </div>
	
	                <!-- 단가 -->
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">단가</label>
	                    <div class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100 text-sm text-gray-900">
	                        <p id="unitPriceDisplay">₩0</p>
	                    </div>
	                </div>
	
	                <!-- 합계 -->
	                <div>
	                    <label class="block text-sm font-medium text-gray-700 mb-1">합계</label>
	                    <div class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-50 text-sm text-gray-900">
	                        <p id="totalAmount">₩0</p>
	                    </div>
	                </div>
	
	                <!-- 유통기한 -->
					<div>
					    <label class="block text-sm font-medium text-gray-700 mb-1">유통기한 <span class="text-red-500">*</span></label>
					
					    <div class="relative">
					        <input type="text"
					               id="formExpiryDate"
					               readonly
					               onclick="openCustomDatePicker('formExpiryDate', event)"
					               placeholder="YYYY-MM-DD"
					               class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm bg-white cursor-pointer">
					
					        <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
					    </div>
					</div>
	
	            </div>
	        </div>
	
	        <!-- 하단 버튼 -->
			<div class="border-t border-gray-200 px-6 py-3 flex items-center justify-between sticky bottom-0 bg-white">
			    <!-- 필수 항목 안내 -->
			    <p class="text-xs text-gray-500">
			        <span class="text-red-500 font-semibold">*</span> 필수 항목
			    </p>
			
			    <div class="flex justify-end gap-3">
			        <button type="button"
			                onclick="closeReceiveModal()"
			                class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
			            취소
			        </button>
			        <button type="button"
			                onclick="handleReceive()"
			                class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
			            입고 등록
			        </button>
			    </div>
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
    // ============================================================
    // 상수 / 설정
    // ============================================================
    var ITEMS_PER_PAGE = 10;

    // ============================================================
    // 전역 상태
    // ============================================================
    var allRecords = [];
    var filteredRecords = [];
    var currentPage = 1;
    function toggleMenu(button) {
        var submenu = button.nextElementSibling;
        if (submenu && submenu.classList.contains('submenu')) {
            submenu.classList.toggle('hidden');
            var icon = button.querySelector('i:last-child');
            icon.classList.toggle('fa-chevron-down');
            icon.classList.toggle('fa-chevron-right');
        }
    }

    function toggleUserMenu() { document.getElementById('userMenu').classList.toggle('hidden'); }

    function logout() {
        commonShowAlert('알림', '로그아웃되었습니다.');
        window.location.href = '<%=request.getContextPath()%>/common/login.jsp';
    }

    document.addEventListener('click', function(e) {
        if (!e.target.closest('button[onclick="toggleUserMenu()"]') && !e.target.closest('#userMenu')) {
            document.getElementById('userMenu').classList.add('hidden');
        }
    });
    
	 // ============================================================
	 // 커스텀 달력
	 // ============================================================
	 var customDateTargetId = null;
	 var customPickerDate = new Date();
	
	 function parseDateLocal(dateStr) {
	     if (!dateStr) return null;
	
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
	
	 function formatDateLocal(date) {
	     return date.getFullYear() + '-' +
	         String(date.getMonth() + 1).padStart(2, '0') + '-' +
	         String(date.getDate()).padStart(2, '0');
	 }
	
	 function openCustomDatePicker(inputId, event) {
	     if (event) {
	         event.stopPropagation();
	     }
	
	     customDateTargetId = inputId;
	
	     var input = document.getElementById(inputId);
	     var selectedDate = parseDateLocal(input.value);
	
	     customPickerDate = selectedDate || new Date();
	
	     renderCustomDatePicker();
	     positionCustomDatePicker(input);
	
	     document.getElementById('customDatePicker').classList.remove('hidden');
	 }
	
	 function positionCustomDatePicker(input) {
	     var picker = document.getElementById('customDatePicker');
	     var rect = input.getBoundingClientRect();
	
	     var top = rect.bottom + 6;
	     var left = rect.left;
	
	     if (left + 300 > window.innerWidth) {
	         left = window.innerWidth - 312;
	     }
	
	     if (top + 330 > window.innerHeight) {
	         top = rect.top - 330;
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
	         var prevDate = prevLastDay.getDate() - i;
	
	         days.push({
	             date: new Date(year, month - 1, prevDate),
	             currentMonth: false
	         });
	     }
	
	     for (var d = 1; d <= lastDay.getDate(); d++) {
	         days.push({
	             date: new Date(year, month, d),
	             currentMonth: true
	         });
	     }
	
	     while (days.length < 42) {
	         var nextDate = days.length - (startDay + lastDay.getDate()) + 1;
	
	         days.push({
	             date: new Date(year, month + 1, nextDate),
	             currentMonth: false
	         });
	     }
	
	     var todayValue = formatDateLocal(new Date());
	     var selectedValue = '';
	
	     if (customDateTargetId) {
	         selectedValue = document.getElementById(customDateTargetId).value;
	     }
	
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
	     document.getElementById('customDatePicker').classList.add('hidden');
	
	     customDateTargetId = null;
	 }
	
	 function closeCustomDatePicker() {
	     document.getElementById('customDatePicker').classList.add('hidden');
	     customDateTargetId = null;
	 }
	
	 document.addEventListener('mousedown', function(event) {
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

    // ============================================================
    // 필터 품목명 연동
    // ============================================================
    function updateFilterItemNames() {
        var select   = document.getElementById('filterItemName');
        var categoryName = document.getElementById('filterCategory').value;
        select.innerHTML = '<option value="전체">전체</option>';
        (categoryMaterialMap[categoryName] || []).forEach(function(item) {
            var opt = document.createElement('option');
            opt.value = item;
            opt.textContent = item;
            select.appendChild(opt);
        });
    }

    // ============================================================
    // 모달 품목명 연동
    // ============================================================
    function updateFormItemNames() {
        var select   = document.getElementById('formItem');
        var categoryName = document.getElementById('formCategory').value;
        
     	// 품목 초기화
        select.innerHTML = '<option value="">선택하세요</option>';
        (categoryMaterialMap[categoryName] || []).forEach(function(item) {
            var opt = document.createElement('option');
            opt.value = item;
            opt.textContent = item;
            select.appendChild(opt);
        });
        
        // 단가 / 합계 초기화
        selectedUnitPrice = 0;
        document.getElementById('unitPriceDisplay').textContent = '₩0';
        document.getElementById('totalAmount').textContent = '₩0';
    }
    
    // ============================================================
    // 품목 선택 시 단가 자동 세팅
    // ============================================================
   	let selectedUnitPrice = 0;
   	function handleItemChange() {
   	    const itemName = document.getElementById('formItem').value;

   	    selectedUnitPrice = materialPriceMap[itemName] || 0;

   	    // 단가 표시
   	    document.getElementById('unitPriceDisplay').textContent =
   	        '₩' + selectedUnitPrice.toLocaleString('ko-KR');

   	    calculateTotal();
   	}
   	
    // ============================================================
    // 모달 열기 / 닫기
    // ============================================================
    function openReceiveModal() {
        document.getElementById('formSupplier').value  = '';
        document.getElementById('formCategory').value  = '';
        document.getElementById('formItem').innerHTML  = '<option value="">카테고리를 먼저 선택하세요</option>';
        document.getElementById('formQuantity').value  = '';
        document.getElementById('formExpiryDate').value = '';

        selectedUnitPrice = 0;

        document.getElementById('unitPriceDisplay').textContent = '₩0';
        document.getElementById('totalAmount').textContent = '₩0';

        document.getElementById('receiveModal').classList.remove('hidden');
    }

    function closeReceiveModal() {
        document.getElementById('receiveModal').classList.add('hidden');
    }

    document.getElementById('receiveModal').addEventListener('click', function(e) {
        if (e.target == this) closeReceiveModal();
    });

    // ============================================================
    // 합계 실시간 계산
    // ============================================================
    function calculateTotal() {
        const quantity = parseInt(document.getElementById('formQuantity').value) || 0;
        
        // 품목 선택 안 했으면 계산 안함
        if (selectedUnitPrice === 0) {
		    document.getElementById('totalAmount').textContent = '₩0';
		    return;
		}

        const total = quantity * selectedUnitPrice;

        document.getElementById('totalAmount').textContent =
            '₩' + total.toLocaleString('ko-KR');
    }

    // ============================================================
    // 입고 등록 (POST API)
    // ============================================================
    async function handleReceive() {
	    const supplier = document.getElementById('formSupplier').value.trim();
	    const category = document.getElementById('formCategory').value.trim();
	    const item     = document.getElementById('formItem').value.trim();
	    const quantity = parseInt(document.getElementById('formQuantity').value);
	    const expiry   = document.getElementById('formExpiryDate').value;
	
	    // 필수값 검사 (한 번에 처리)
	    const validations = [
	        [supplier, '공급사를 선택해주세요.'],
	        [category, '카테고리를 선택해주세요.'],
	        [item, '품목을 선택해주세요.'],
	        [quantity && quantity > 0, '수량을 1 이상 입력해주세요.'],
	        [expiry, '유통기한을 선택해주세요.'],
	        [selectedUnitPrice > 0, '품목을 올바르게 선택해주세요.']
	    ];
	
	    for (const [condition, message] of validations) {
	        if (!condition) {
            commonShowAlert('알림', message);
	            return;
	        }
	    }
	
	    const payload = {
	        supplier,
	        categoryName: category,
	        itemName: item,
	        quantity,
	        unitPrice: selectedUnitPrice,
	        expiryDate: expiry
	    };
	
	    try {
	        const res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/inbound', {
	            method: 'POST',
	            headers: { 'Content-Type': 'application/json' },
	            body: JSON.stringify(payload)
	        });
	
	        const result = await res.json();
	        if (!res.ok || result.status !== 'success') {
	            throw new Error(result.message || '등록 실패');
	        }
	
	        closeReceiveModal();
        commonShowAlert('알림', '입고 처리가 완료되었습니다.');
	        applyFilters();
	
	    } catch (err) {
        commonShowAlert('알림', '입고 등록 중 오류가 발생했습니다: ' + err.message);
	    }
	}

    // ============================================================
    // 데이터 조회 (GET API)
    // ============================================================
    async function applyFilters() {
        var params = new URLSearchParams({
            supplier:  document.getElementById('filterSupplier').value,
            categoryName:  document.getElementById('filterCategory').value,
            itemName:  document.getElementById('filterItemName').value,
            startDate: document.getElementById('filterStartDate').value,
            endDate:   document.getElementById('filterEndDate').value
        });

        try {
        	var res = await fetch('<%=request.getContextPath()%>/api/hq/warehouse/inbound?' + params);
					if (!res.ok) {
						var errData = await
						res.json();
						throw new Error(errData.message || 'HTTP ' + res.status);
					}
					var result = await
					res.json();
					if (!result || result.status != 'success')
						throw new Error((result && result.message) || '데이터 오류');

					allRecords = result.data || [];
					filteredRecords = allRecords;

				} catch (err) {
					allRecords = [];
					filteredRecords = [];
				}

				currentPage = 1;
				renderTable();
				document.getElementById('totalRecords').textContent = filteredRecords.length
						+ '건';
			}

			function resetFilters() {
				document.getElementById('filterSupplier').value = '전체';
				document.getElementById('filterCategory').value = '전체';
				updateFilterItemNames();
				document.getElementById('filterItemName').value = '전체';
				var today = new Date();
				var mm = String(today.getMonth() + 1).padStart(2, '0');
				var dd = String(today.getDate()).padStart(2, '0');
				var yyyy = today.getFullYear();
				var firstDay = yyyy + '-' + mm + '-01';
				var todayStr = yyyy + '-' + mm + '-' + dd;
				document.getElementById('filterStartDate').value = firstDay;
				document.getElementById('filterEndDate').value = todayStr;
				applyFilters();
			}

			// ============================================================
			// 테이블 렌더링
			// ============================================================
			function renderTable() {
				var tbody = document.getElementById('inboundTableBody');
				var totalPages = Math.ceil(filteredRecords.length
						/ ITEMS_PER_PAGE);
				var startIndex = (currentPage - 1) * ITEMS_PER_PAGE;
				var endIndex = startIndex + ITEMS_PER_PAGE;
				var pageItems = filteredRecords.slice(startIndex, endIndex);

				tbody.innerHTML = '';

				if (pageItems.length == 0) {
					tbody.innerHTML = '<tr><td colspan="9" class="py-12 text-center text-gray-500">'
							+ '<i class="fas fa-box w-12 h-12 mx-auto mb-3 text-gray-400"></i>'
							+ '<p>조회 결과가 없습니다</p></td></tr>';
					document.getElementById('paginationContainer').classList
							.add('hidden');
					return;
				}

				pageItems
						.forEach(function(record) {
							var unitPriceFmt = record.unitPrice
									.toLocaleString('ko-KR');
							var totalFmt = record.totalPrice
									.toLocaleString('ko-KR');
							var tr = document.createElement('tr');
							tr.className = 'border-b border-gray-100 hover:bg-gray-50';
							tr.innerHTML = '<td class="py-4 px-6 text-sm text-gray-900">'
									+ record.receivedAt
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm text-gray-900">'
									+ record.supplierName
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm text-gray-600">'
									+ record.categoryName
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm font-medium text-gray-900">'
									+ record.itemName
									+ '</td>'
									+ '<td class="py-4 px-6 text-right text-sm text-gray-600">'
									+ record.quantity
									+ ' '
									+ (record.unit || '')
									+ '</td>'
									+ '<td class="py-4 px-6 text-right text-sm text-gray-600">&#8361;'
									+ unitPriceFmt
									+ '</td>'
									+ '<td class="py-4 px-6 text-right text-sm font-semibold text-[#00853D]">&#8361;'
									+ totalFmt
									+ '</td>'
									+ '<td class="py-4 px-6 text-sm text-gray-600">'
									+ record.expiryDate + '</td>';
							tbody.appendChild(tr);
						});

				updatePagination(totalPages, startIndex, endIndex);
			}

			// ============================================================
			// 페이지네이션
			// ============================================================
			const PAGE_SIZE = 5; // 한 번에 보여줄 페이지 버튼 개수

			function updatePagination(totalPages, startIndex, endIndex) {
			    var container = document.getElementById('paginationContainer');
			
			    if (totalPages <= 1) {
			        container.classList.add('hidden');
			        return;
			    }
			
			    container.classList.remove('hidden');
			
			    document.getElementById('paginationInfo').textContent =
			        (startIndex + 1)
			        + '-'
			        + Math.min(endIndex, filteredRecords.length)
			        + ' / '
			        + filteredRecords.length
			        + '개';
			
			    var pageButtons = document.getElementById('pageButtons');
			
			    var base = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700';
			    var active = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white';
			    var arrow = 'min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white';
			
			    var blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
			    var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);
			
			    var html = '';
			
			    html += '<button class="' + arrow + '" onclick="goToPage(1)" ' + (currentPage === 1 ? 'disabled' : '') + '>';
			    html += '<i class="fas fa-angles-left text-xs"></i>';
			    html += '</button>';
			
			    var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
			    html += '<button class="' + arrow + '" onclick="goToPage(' + prevBlockPage + ')" ' + (blockStart === 1 ? 'disabled' : '') + '>';
			    html += '<i class="fas fa-chevron-left text-xs"></i>';
			    html += '</button>';
			
			    for (var i = blockStart; i <= blockEnd; i++) {
			        html += '<button class="' + (i === currentPage ? active : base) + '" onclick="goToPage(' + i + ')">';
			        html += i;
			        html += '</button>';
			    }
			
			    var nextBlockPage = Math.min(totalPages, blockEnd + 1);
			    html += '<button class="' + arrow + '" onclick="goToPage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? 'disabled' : '') + '>';
			    html += '<i class="fas fa-chevron-right text-xs"></i>';
			    html += '</button>';
			
			    html += '<button class="' + arrow + '" onclick="goToPage(' + totalPages + ')" ' + (currentPage === totalPages ? 'disabled' : '') + '>';
			    html += '<i class="fas fa-angles-right text-xs"></i>';
			    html += '</button>';
			
			    pageButtons.innerHTML = html;
			}
			
			function goToPage(page) {
			    currentPage = page;
			    renderTable();
			
			    window.scrollTo({
			        top: 0,
			        behavior: 'smooth'
			    });
			}
			
			function previousPage() {
			    if (currentPage > 1) {
			        goToPage(currentPage - 1);
			    }
			}
			
			function nextPage() {
			    var totalPages = Math.ceil(filteredRecords.length / ITEMS_PER_PAGE);
			
			    if (currentPage < totalPages) {
			        goToPage(currentPage + 1);
			    }
			}
			
			// ============================================================
			// 초기화
			// ============================================================
			window.addEventListener('DOMContentLoaded', function() {
				
			    document.getElementById('formQuantity').addEventListener('input', calculateTotal);

				var today = new Date();
				var mm = String(today.getMonth() + 1).padStart(2, '0');
				var dd = String(today.getDate()).padStart(2, '0');
				var yyyy = today.getFullYear();
				var firstDay = yyyy + '-' + mm + '-01';
				var todayStr = yyyy + '-' + mm + '-' + dd;
				document.getElementById('filterStartDate').value = firstDay;
				document.getElementById('filterEndDate').value = todayStr;

				updateFilterItemNames();
				applyFilters();
			});
		</script>
</body>
</html>


