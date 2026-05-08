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

<!-- flatpickr -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

<style>
.sidebar-open .sidebar {
	transform: translateX(0);
}

.sidebar-open #sidebarBackdrop {
	display: block;
}

.date-picker-wrap {
	position: relative;
}

.date-picker-wrap input {
	padding-left: 42px !important;
	background-image:
		url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%239ca3af'%3E%3Cpath fill-rule='evenodd' d='M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2z' clip-rule='evenodd' /%3E%3C/svg%3E");
	background-repeat: no-repeat;
	background-position: 12px center;
	background-size: 20px;
}

/* flatpickr 커스텀 컬러 */
.flatpickr-day.selected, .flatpickr-day.startRange, .flatpickr-day.endRange,
	.flatpickr-day.selected:hover, .flatpickr-day.startRange:hover,
	.flatpickr-day.endRange:hover {
	background: #00853d !important;
	border-color: #00853d !important;
}

.flatpickr-day.today {
	border-color: #00853d !important;
}

.flatpickr-day:hover {
	background: #e7f4ec !important;
}

.flatpickr-months .flatpickr-month, .flatpickr-current-month .flatpickr-monthDropdown-months
	{
	color: #111 !important;
}

.flatpickr-day.selected {
	color: #fff !important;
}

.flatpickr-calendar.arrowTop:before, .flatpickr-calendar.arrowTop:after
	{
	border-bottom-color: #fff !important;
}
</style>
</head>
<body class="bg-gray-50">
	<%@ include file="/hq/common/sidebar.jsp"%>
	<!-- 메인 콘텐츠 -->
	<div class="lg:pl-72">

		<!-- 페이지 콘텐츠 -->
		<main class="p-6">
			<!-- 헤더 -->
			<div class="mb-6">
				<h2 class="text-3xl font-bold text-gray-900">지점 재고 리스크 현황</h2>
				<p class="text-gray-500 mt-1">유통기한 임박 품목 및 손실 기록 현황을 조회하세요</p>
			</div>

			<!-- 필터 -->
			<div class="bg-white rounded-lg border border-gray-200 p-6 mb-6">
				<div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
					<!-- 지점 선택 -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">지점
							선택</label> <select id="branchSelect"
							class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
							<option value="">전체</option>

							<c:forEach var="branch" items="${branchList}">
								<c:if test="${branch.branchCode != 1}">
									<option value="${branch.branchCode}">
										${branch.branchName}</option>
								</c:if>
							</c:forEach>
						</select>
					</div>

					<!-- 시작 날짜 -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">시작
							날짜</label>
						<div class="date-picker-wrap">
							<input type="text" id="startDate" value="${startDate}"
								placeholder="시작일 선택"
								class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
						</div>
					</div>

					<!-- 종료 날짜 -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">종료
							날짜</label>
						<div class="date-picker-wrap">
							<input type="text" id="endDate" value="${endDate}"
								placeholder="종료일 선택"
								class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent">
						</div>
					</div>
				</div>

				<div class="flex items-center gap-2">
					<button onclick="handleFilter()"
						class="px-6 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] font-medium transition-colors">
						조회하기</button>
					<button onclick="handleReset()"
						class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium transition-colors">
						초기화</button>
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

	<script>
	const contextPath = "${contextPath}";
	
	flatpickr.localize(flatpickr.l10ns.ko);

	const commonDateConfig = {
		dateFormat: "Y-m-d",
		allowInput: true
	};

	flatpickr("#startDate", {
		...commonDateConfig,
		defaultDate: document.getElementById("startDate").value || "today"
	});

	flatpickr("#endDate", {
		...commonDateConfig,
		defaultDate: document.getElementById("endDate").value || "today"
	});
	
        // 전역 상태
        let filteredExpiryData = [];
        let filteredDisposalData = [];

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
            alert('로그아웃되었습니다.');
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


