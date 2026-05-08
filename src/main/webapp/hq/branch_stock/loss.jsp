<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<title>지점 손실 관리 - ZERO LOSS 본사 관리 시스템</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="<%=request.getContextPath()%>/common/js/modal.js"></script>

<style>
.sidebar-open .sidebar {
	transform: translateX(0);
}

.sidebar-open #sidebarBackdrop {
	display: block;
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
	<%@ include file="/hq/common/sidebar.jsp"%>
	<!-- 메인 콘텐츠 -->
	<div class="lg:pl-72">

		<!-- 페이지 콘텐츠 -->
		<main class="p-6">
			<!-- ===== 페이지 헤더 ===== -->
			<div class="mb-6">
			    <h2 class="text-3xl font-bold text-gray-900">지점 재고 리스크 현황</h2>
			    <p class="text-gray-500 mt-1">유통기한 임박 품목 및 손실 기록 현황을 조회하세요</p>
			</div>
			
			<!-- ===== 검색 필터 영역 ===== -->
			<div class="bg-white rounded-xl border border-gray-200 p-6 shadow-sm mb-6">
			    <div class="flex flex-col gap-4">
			
			        <!-- 상단: 설명 -->
			        <div>
			            <h3 class="text-sm font-semibold text-gray-800">재고 리스크 검색</h3>
			            <p class="text-xs text-gray-500 mt-1">
			                지점과 조회 기간을 선택하여 유통기한 임박 품목 및 폐기 손실 현황을 조회할 수 있습니다.
			            </p>
			        </div>
			
			        <!-- 하단: 필터 + 버튼 -->
			        <div class="flex flex-col xl:flex-row xl:items-center xl:justify-between gap-4 pt-4 border-t border-gray-100">
			
			            <!-- 필터 영역 -->
			            <div class="flex flex-wrap items-center gap-3 flex-1">
			
			                <!-- 지점 선택 -->
			                <select id="branchSelect"
			                        class="w-52 px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white">
			                    <option value="">전체 지점</option>
			
			                    <c:forEach var="branch" items="${branchList}">
			                        <c:if test="${branch.branchCode != 1}">
			                            <option value="${branch.branchCode}">
			                                ${branch.branchName}
			                            </option>
			                        </c:if>
			                    </c:forEach>
			                </select>
			
			                <!-- 시작일 -->
			                <div class="relative w-52">
			                    <input type="text"
			                           id="startDate"
			                           value="${startDate}"
			                           readonly
			                           onclick="openCustomDatePicker('startDate', event)"
			                           placeholder="시작일 선택"
			                           class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
			
			                    <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
			                </div>
			
			                <span class="text-gray-500 text-sm">~</span>
			
			                <!-- 종료일 -->
			                <div class="relative w-52">
			                    <input type="text"
			                           id="endDate"
			                           value="${endDate}"
			                           readonly
			                           onclick="openCustomDatePicker('endDate', event)"
			                           placeholder="종료일 선택"
			                           class="w-full pl-3 pr-10 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all bg-white cursor-pointer">
			
			                    <i class="fas fa-calendar-check absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
			                </div>
			            </div>
			
			            <!-- 버튼 영역 -->
			            <div class="flex items-center gap-2 xl:shrink-0">
			                <button type="button"
			                        onclick="handleFilter()"
			                        class="px-5 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">
			                    조회
			                </button>
			
			                <button type="button"
			                        onclick="handleReset()"
			                        class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">
			                    초기화
			                </button>
			            </div>
			        </div>
			    </div>
			</div>

			<!-- 통합 통계 카드 -->
			<div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
				<div class="bg-white rounded-lg border border-gray-200 p-6">
					<div class="flex items-center justify-between">
						<div>
							<p class="text-sm text-gray-600">유통기한 임박 (긴급)</p>
							<p class="text-3xl font-bold text-red-600" id="urgentCount">0</p>
						</div>
						<i
							class="fas fa-exclamation-circle text-red-600 text-4xl opacity-20"></i>
					</div>
				</div>

				<div class="bg-white rounded-lg border border-gray-200 p-6">
					<div class="flex items-center justify-between">
						<div>
							<p class="text-sm text-gray-600">유통기한 임박 (주의)</p>
							<p class="text-3xl font-bold text-yellow-600" id="warningCount">0</p>
						</div>
						<i
							class="fas fa-exclamation-triangle text-yellow-600 text-4xl opacity-20"></i>
					</div>
				</div>

				<div class="bg-white rounded-lg border border-gray-200 p-6">
					<div class="flex items-center justify-between">
						<div>
							<p class="text-sm text-gray-600">폐기 건수</p>
							<p class="text-3xl font-bold text-blue-600"
								id="disposalRecordCount">0</p>
							<p class="text-xs text-gray-500 mt-2" id="disposalReasonSummary">만료
								0건 | 품질 0건 | 기타 0건</p>
						</div>
						<i class="fas fa-trash text-blue-600 text-4xl opacity-20"></i>
					</div>
				</div>

				<div class="bg-white rounded-lg border border-gray-200 p-6">
					<div class="flex items-center justify-between">
						<div>
							<p class="text-sm text-gray-600">총 손실액</p>
							<p class="text-3xl font-bold text-red-700" id="totalLossAmount">0원</p>

							<div class="text-xs text-gray-500 mt-2 flex flex-col gap-1"
								id="lossAmountSummary"></div>
						</div>

						<i class="fas fa-sack-dollar text-red-700 text-4xl opacity-20"></i>
					</div>
				</div>
			</div>

			<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
				<!-- 좌측: 유통기한 임박 품목 -->
				<section>
					<div class="flex items-center justify-between mb-3">
						<h3 class="text-lg font-semibold text-gray-900">유통기한 임박 품목
							리스트</h3>
					</div>
					<div id="branchListContainer"
						class="space-y-4 max-h-[430px] overflow-y-auto pr-1">
						<!-- 동적으로 생성됨 -->
					</div>
				</section>

				<!-- 우측: 폐기 리스트 -->
				<section>
					<div class="flex items-center justify-between mb-3">
						<h3 class="text-lg font-semibold text-gray-900">폐기 건수 리스트</h3>
					</div>
					<div
						class="bg-white rounded-lg border border-gray-200 overflow-hidden max-h-[430px]">
						<div class="max-h-[430px] overflow-y-auto">
							<table class="w-full">
								<thead class="bg-gray-50 border-b border-gray-200">
									<tr>
										<th
											class="text-left py-4 px-6 text-sm font-semibold text-gray-900">날짜</th>
										<th
											class="text-left py-4 px-6 text-sm font-semibold text-gray-900">지점</th>
										<th
											class="text-left py-4 px-6 text-sm font-semibold text-gray-900">품목명</th>
										<th
											class="text-right py-4 px-6 text-sm font-semibold text-gray-900">수량</th>
										<th
											class="text-right py-4 px-6 text-sm font-semibold text-gray-900">손실액</th>
										<th
											class="text-left py-4 px-6 text-sm font-semibold text-gray-900">사유</th>
									</tr>
								</thead>
								<tbody id="disposalTableBody">
									<!-- 동적으로 생성됨 -->
								</tbody>
							</table>
						</div>
					</div>
				</section>
			</div>
		</main>
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
	const contextPath = "${contextPath}";
	
     // 전역 상태
     let filteredExpiryData = [];
     let filteredDisposalData = [];

     // 커스텀 달력
     let customDateTargetId = null;
     let customPickerDate = new Date();

     function parseDateLocal(dateStr) {
         if (!dateStr) return null;

         const parts = String(dateStr).split('-');

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

         const input = document.getElementById(inputId);
         const selectedDate = parseDateLocal(input.value);

         customPickerDate = selectedDate || new Date();

         renderCustomDatePicker();
         positionCustomDatePicker(input);

         document.getElementById('customDatePicker').classList.remove('hidden');
     }

     function positionCustomDatePicker(input) {
         const picker = document.getElementById('customDatePicker');
         const rect = input.getBoundingClientRect();

         let top = rect.bottom + 6;
         let left = rect.left;

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
         const yearSelect = document.getElementById('customDatePickerYear');
         const monthSelect = document.getElementById('customDatePickerMonth');

         const selectedYear = Number(yearSelect.value);
         const selectedMonth = Number(monthSelect.value);

         customPickerDate = new Date(selectedYear, selectedMonth, 1);
         renderCustomDatePicker();
     }

     function renderCustomDatePicker() {
         const year = customPickerDate.getFullYear();
         const month = customPickerDate.getMonth();

         renderCustomPickerYearMonthSelect(year, month);

         const firstDay = new Date(year, month, 1);
         const lastDay = new Date(year, month + 1, 0);
         const prevLastDay = new Date(year, month, 0);

         const startDay = firstDay.getDay();
         const days = [];

         for (let i = startDay - 1; i >= 0; i--) {
             const prevDate = prevLastDay.getDate() - i;

             days.push({
                 date: new Date(year, month - 1, prevDate),
                 currentMonth: false
             });
         }

         for (let d = 1; d <= lastDay.getDate(); d++) {
             days.push({
                 date: new Date(year, month, d),
                 currentMonth: true
             });
         }

         while (days.length < 42) {
             const nextDate = days.length - (startDay + lastDay.getDate()) + 1;

             days.push({
                 date: new Date(year, month + 1, nextDate),
                 currentMonth: false
             });
         }

         const todayValue = formatDateLocal(new Date());
         let selectedValue = '';

         if (customDateTargetId) {
             selectedValue = document.getElementById(customDateTargetId).value;
         }

         let html = '';

         for (let j = 0; j < days.length; j++) {
             const dateValue = formatDateLocal(days[j].date);
             let className = 'custom-date-day';

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
         const yearSelect = document.getElementById('customDatePickerYear');
         const monthSelect = document.getElementById('customDatePickerMonth');

         let yearHtml = '';
         const startYear = year - 10;
         const endYear = year + 10;

         for (let y = startYear; y <= endYear; y++) {
             yearHtml += '<option value="' + y + '"';

             if (y === year) {
                 yearHtml += ' selected';
             }

             yearHtml += '>' + y + '년</option>';
         }

         let monthHtml = '';

         for (let m = 0; m < 12; m++) {
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
         const picker = document.getElementById('customDatePicker');

         if (!picker || picker.classList.contains('hidden')) {
             return;
         }

         const target = event.target;

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
        
        // 사이드바 토글
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const backdrop = document.getElementById('sidebarBackdrop');
            const menuIcon = document.getElementById('menuIcon');
            
            sidebar.classList.toggle('-translate-x-full');
            backdrop.classList.toggle('hidden');
            
            if (backdrop.classList.contains('hidden')) {
                menuIcon.classList.remove('fa-xmark');
                menuIcon.classList.add('fa-bars');
            } else {
                menuIcon.classList.remove('fa-bars');
                menuIcon.classList.add('fa-xmark');
            }
        }

        // 사이드바 메뉴 닫기
        function closeSidebar() {
            document.getElementById('sidebar').classList.add('-translate-x-full');
            document.getElementById('sidebarBackdrop').classList.add('hidden');
            document.getElementById('menuIcon').classList.remove('fa-xmark');
            document.getElementById('menuIcon').classList.add('fa-bars');
        }

        // 메뉴 토글
        function toggleMenu(button) {
            const submenu = button.nextElementSibling;
            const icon = button.querySelector('i:last-child');
            
            if (submenu && submenu.classList.contains('submenu')) {
                submenu.classList.toggle('hidden');
                icon.classList.toggle('fa-chevron-down');
                icon.classList.toggle('fa-chevron-right');
            }
        }

        // 사용자 메뉴 토글
        function toggleUserMenu() {
            document.getElementById('userMenu').classList.toggle('hidden');
        }

        // 로그아웃
        function logout() {
            commonShowAlert('알림','로그아웃되었습니다.');
            window.location.href = '<%=request.getContextPath()%>/common/login.jsp';
        }

        // 백드롭 클릭 시 사이드바 닫기
        document.getElementById('sidebarBackdrop').addEventListener('click', closeSidebar);

        function applyServerData(data) {

        	// 1. 리스트 세팅
        	filteredExpiryData = data.expireRiskList || [];
        	filteredDisposalData = data.disposalRiskList || [];

        	// 2. 카드 값 직접 세팅 (서버값 사용)
        	document.getElementById('urgentCount').textContent = data.summary.urgentCount;
        	document.getElementById('warningCount').textContent = data.summary.warningCount;
        	document.getElementById('disposalRecordCount').textContent = data.summary.disposalCount;

        	// 3. 화면 렌더링
        	renderExpirySection();
        	renderDisposalSection();
        	console.log(data.summary);
        	renderSummaryCards();
        }
        
        // 필터링
        function handleFilter() {
			const branchCode = document.getElementById('branchSelect').value;
			const startDate = document.getElementById('startDate').value;
			const endDate = document.getElementById('endDate').value;

			const params = new URLSearchParams();
			if (branchCode) params.append('branchCode', branchCode);
			if (startDate) params.append('startDate', startDate);
			if (endDate) params.append('endDate', endDate);

			fetch(contextPath + '/hq/branch_stock/loss', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded'
				},
				body: params.toString()
			})
			.then(res => res.json())
			.then(data => {
				console.log(data);
				applyServerData(data);
			})
			.catch(err => console.error(err));
		}

        // 초기화
        function handleReset() {
            document.getElementById('branchSelect').value = '';
            document.getElementById('startDate').value = '${startDate}';
            document.getElementById('endDate').value = '${endDate}';

            handleFilter();
        }

        function renderUnifiedView() {
            renderSummaryCards();
            renderExpirySection();
            renderDisposalSection();
        }

        function renderSummaryCards() {
            const urgentCount = filteredExpiryData.filter(i => i.dDay <= 1).length;
            const warningCount = filteredExpiryData.filter(i => i.dDay > 1 && i.dDay <= 3).length;

            const expiryReasonCount = filteredDisposalData.filter(r => r.reason && r.reason.includes('유통기한')).length;
            const qualityReasonCount = filteredDisposalData.filter(r => r.reason && (r.reason.includes('품질') || r.reason.includes('파손') || r.reason.includes('냉장'))).length;
            const disposalCount = filteredDisposalData.length;
            const otherReasonCount = disposalCount - expiryReasonCount - qualityReasonCount;

            document.getElementById('urgentCount').textContent = urgentCount;
            document.getElementById('warningCount').textContent = warningCount;
            document.getElementById('disposalRecordCount').textContent = disposalCount;
            document.getElementById('disposalReasonSummary').textContent = '만료 ' + expiryReasonCount + '건 | 품질 ' + qualityReasonCount + '건 | 기타 ' + otherReasonCount + '건';
            
            const totalLossAmount = filteredDisposalData.reduce((sum, item) => sum + (item.lossAmount || 0),0);

            const expiredLossAmount = filteredDisposalData
            	    .filter(r => r.reason && r.reason.includes('유통기한'))
            	    .reduce((sum, item) => sum + (item.lossAmount || 0), 0);

            	const qualityLossAmount = filteredDisposalData
            	    .filter(r => r.reason && (
            	        r.reason.includes('품질') ||
            	        r.reason.includes('파손') ||
            	        r.reason.includes('냉장')
            	    ))
            	    .reduce((sum, item) => sum + (item.lossAmount || 0), 0);

            	const otherLossAmount =
            	    totalLossAmount - expiredLossAmount - qualityLossAmount;

            	document.getElementById('totalLossAmount').textContent = totalLossAmount.toLocaleString('ko-KR') + '원';

            	document.getElementById('lossAmountSummary').innerHTML =
            	    '<div>만료 ' + expiredLossAmount.toLocaleString('ko-KR') + '원 | 품질 ' +
            	    qualityLossAmount.toLocaleString('ko-KR') + '원</div>' +
            	    '<div>기타 ' + otherLossAmount.toLocaleString('ko-KR') + '원</div>';
        }

        // 유통기한 임박 섹션 렌더링
        function renderExpirySection() {

            // 지점별 그룹핑
            const branchGroups = {};
            filteredExpiryData.forEach(item => {
                if (!branchGroups[item.branchName]) {
                    branchGroups[item.branchName] = [];
                }
                branchGroups[item.branchName].push(item);
            });

            // 지점별 카드 렌더링
            const branchListContainer = document.getElementById('branchListContainer');
            branchListContainer.innerHTML = '';

            Object.keys(branchGroups).sort().forEach(branch => {
                const items = branchGroups[branch];
                const urgentItems = items.filter(i => i.dDay <= 1).length;
                const warningItems = items.filter(i => i.dDay > 1 && i.dDay <= 3).length;

                let branchCardHtml = '<div class="p-6 border-b border-gray-200 bg-gray-50"><div class="flex items-center justify-between"><h3 class="font-semibold text-gray-900">' + branch + '</h3><div class="flex gap-2"><span class="px-3 py-1 bg-red-100 text-red-700 rounded-full text-sm font-medium">긴급: ' + urgentItems + '</span><span class="px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full text-sm font-medium">주의: ' + warningItems + '</span></div></div></div><div class="overflow-x-auto"><table class="w-full"><thead class="bg-gray-50 border-b border-gray-200"><tr><th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">품목명</th><th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">수신일</th><th class="text-left py-3 px-4 text-sm font-semibold text-gray-900">유통기한</th><th class="text-center py-3 px-4 text-sm font-semibold text-gray-900">남은 일수</th><th class="text-right py-3 px-4 text-sm font-semibold text-gray-900">재고</th></tr></thead><tbody>';

                items.forEach(item => {
                    const daysLeftClass = item.dDay <= 1 ? 'text-red-600 font-semibold' : item.dDay <= 3 ? 'text-yellow-600 font-semibold' : 'text-green-600';
                    const statusBadge = item.dDay <= 1 ? '<span class="px-2 py-1 bg-red-100 text-red-700 rounded text-xs font-medium">긴급</span>' : item.dDay <= 3 ? '<span class="px-2 py-1 bg-yellow-100 text-yellow-700 rounded text-xs font-medium">주의</span>' : '<span class="px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-medium">정상</span>';
                    
                    branchCardHtml += '<tr class="border-b border-gray-100 hover:bg-gray-50"><td class="py-3 px-4 text-sm text-gray-900">' + item.materialName + '</td><td class="py-3 px-4 text-sm text-gray-600">' + item.receivedDate + '</td><td class="py-3 px-4 text-sm text-gray-600">' + item.expireDate + '</td><td class="py-3 px-4 text-center">' + statusBadge + '<span class="block text-sm ' + daysLeftClass + ' mt-1">' + item.dDay + '일</span></td><td class="py-3 px-4 text-right text-sm font-medium text-gray-900">' + item.qty + item.unit + '</td></tr>';
                });

                branchCardHtml += '</tbody></table></div>';
                
                const branchCard = document.createElement('div');
                branchCard.className = 'bg-white rounded-lg border border-gray-200 overflow-hidden';
                branchCard.innerHTML = branchCardHtml;
                branchListContainer.appendChild(branchCard);
            });

            if (branchListContainer.innerHTML === '') {
                branchListContainer.innerHTML = '<div class="bg-white rounded-lg border border-gray-200 p-12 text-center"><i class="fas fa-box w-16 h-16 mx-auto mb-4 text-gray-300"></i><h3 class="text-lg font-semibold text-gray-900 mb-2">데이터 없음</h3><p class="text-gray-500">조건에 맞는 유통기한 임박 상품이 없습니다</p></div>';
            }
        }

        // 폐기 이력 섹션 렌더링
        function renderDisposalSection() {
            // 테이블 렌더링
            const tbody = document.getElementById('disposalTableBody');
            tbody.innerHTML = '';

            if (filteredDisposalData.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" class="py-12 text-center text-gray-500"><i class="fas fa-box w-12 h-12 mx-auto mb-3 text-gray-400"></i><p>폐기 이력이 없습니다</p></td></tr>';
                return;
            }

            filteredDisposalData.forEach(record => {
                const reasonColorClass = record.reason === '유통기한 만료' ? 'bg-red-100 text-red-700' : record.reason === '품질 불량' ? 'bg-yellow-100 text-yellow-700' : 'bg-orange-100 text-orange-700';
                const tr = document.createElement('tr');
                tr.className = 'border-b border-gray-100 hover:bg-gray-50';
                
                const amount = record.lossAmount.toLocaleString('ko-KR');
                tr.innerHTML = '<td class="py-4 px-6 text-sm text-gray-900">' +  record.disposalDate + '</td><td class="py-4 px-6 text-sm"><span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-700">' + record.branchName + '</span></td><td class="py-4 px-6 text-sm font-medium text-gray-900">' + record.materialName + '</td><td class="py-4 px-6 text-right text-sm text-gray-600">' + record.qty + (record.unit || '') + '</td><td class="py-4 px-6 text-right text-sm font-semibold text-red-600">' + amount + '원</td><td class="py-4 px-6 text-sm"><span class="inline-flex items-center px-2 py-1 rounded text-xs font-medium ' + reasonColorClass + '">' + record.reason + '</span></td>';
                
                tbody.appendChild(tr);
            });
        }

        // 사용자 메뉴 외부 클릭 시 닫기
        document.addEventListener('click', function(e) {
            const userMenu = document.getElementById('userMenu');
            if (!e.target.closest('button[onclick="toggleUserMenu()"]') && 
                !e.target.closest('#userMenu')) {
                userMenu.classList.add('hidden');
            }
        });

        // 초기 로드
        window.addEventListener('DOMContentLoaded', function() {
            renderUnifiedView();
            handleFilter();
        });
    </script>
</body>
</html>


