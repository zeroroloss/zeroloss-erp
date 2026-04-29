<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>발주서 작성</title>
    <style>
        body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #f4f7fb; color: #111827; }
        .wrap {
    width: 100%; max-width: none; margin: 0; }
        .page-head { padding: 18px 0 12px; display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
        .page-title { margin: 0; font-size: 30px; line-height: 1.15; font-weight: 800; letter-spacing: -0.03em; }
        .page-sub { margin: 8px 0 0; font-size: 15px; color: #6b7280; }

        .head-actions { display: flex; gap: 10px; }
        .btn { height: 42px; padding: 0 16px; border-radius: 12px; border: 1px solid #d6dae3; background: #fff; color: #111827; font-size: 14px; font-weight: 800; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; cursor: pointer; }
        .btn:hover { background: #f9fafb; }
        .btn-primary { border-color: #2563eb; background: #2563eb; color: #fff; }
        .btn-primary:hover { background: #1d4ed8; }
        .btn-add { border: 0; background: #16a34a; color: #fff; min-width: 150px; justify-content: center; box-shadow: 0 8px 18px rgba(22, 163, 74, 0.3); }
        .btn-add:hover { background: #15803d; }

        .place-popup-overlay { position: fixed; inset: 0; z-index: 3000; background: rgba(0, 0, 0, 0.72); display: none; align-items: center; justify-content: center; padding: 18px; box-sizing: border-box; }
        .place-popup-overlay.active { display: flex; }
        .place-popup-frame { width: min(980px, 100%); height: min(94vh, 920px); border: 0; border-radius: 14px; background: transparent; }

        .card { margin-top: 12px; background: #fff; border: 1px solid #e5e7eb; border-radius: 14px; overflow: hidden; box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05); }
        .card.warn { border-color: #e7ce57; }
        .card.warn .card-head { background: #fef9dd; border-bottom-color: #e7ce57; }
        .card.added { border-color: #9ec6ff; }
        .card.added .card-head { background: #eaf2ff; border-bottom-color: #9ec6ff; }

        .card-head { height: 74px; padding: 0 22px; border-bottom: 1px solid #e5e7eb; display: flex; align-items: center; justify-content: space-between; gap: 14px; }
        .card-title-wrap { display: flex; align-items: center; gap: 12px; }
        .card-icon { width: 42px; height: 42px; border-radius: 12px; display: grid; place-items: center; font-size: 20px; }
        .card.warn .card-icon { background: #fff1b3; color: #b7791f; }
        .card.added .card-icon { background: #d9e8ff; color: #2563eb; }
        .card-title { margin: 0; font-size: 20px; line-height: 1.1; font-weight: 800; letter-spacing: -0.02em; }
        .card-sub { margin: 4px 0 0; font-size: 13px; color: #6b7280; font-weight: 700; }
        .card-count { height: 32px; min-width: 40px; padding: 0 10px; border-radius: 10px; font-size: 14px; font-weight: 700; display: inline-flex; align-items: center; justify-content: center; }
        .card.warn .card-count { background: #fde68a; color: #7c5f00; }
        .card.added .card-count { background: #bfdbfe; color: #1d4ed8; }

        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 14px; border-bottom: 1px solid #edf0f5; text-align: left; font-size: 14px; }
        th { background: #fafbfc; color: #111827; font-weight: 900; }
        tbody tr:last-child td { border-bottom: 0; }

        .chip { display: inline-flex; align-items: center; height: 24px; padding: 0 9px; border-radius: 999px; background: #eef2f7; color: #475569; font-size: 12px; font-weight: 700; }
        .stock-low { color: #ef4444; font-weight: 900; }
        .qty-cell { display: inline-flex; align-items: center; gap: 8px; }
        .qty-input { width: 80px; height: 36px; box-sizing: border-box; padding: 0 10px; border: 1px solid #cfd6e2; border-radius: 10px; font-size: 14px; font-weight: 700; color: #2563eb; }
        .trash { color: #ef4444; font-size: 15px; font-weight: 700; }
        .center { text-align: center; }
        .unit { color: #475569; font-weight: 700; }
        .add-action { margin-top: 16px; display: flex; justify-content: center; }

        @media (max-width: 1280px) {
            .page-title { font-size: 28px; }
            .card-title { font-size: 18px; }
            .card-count { font-size: 16px; }
            th, td { font-size: 13px; }
            .chip { font-size: 11px; }
            .qty-input { font-size: 13px; }
            .trash { font-size: 14px; }
        }

        @media (max-width: 980px) {
            .page-head { flex-direction: column; }
            .page-title { font-size: 26px; }
            .card-title { font-size: 16px; }
            .card-count { font-size: 14px; min-width: 34px; height: 26px; }
            th, td { font-size: 14px; }
            .chip { font-size: 11px; height: 22px; }
            .qty-input { width: 70px; height: 34px; font-size: 13px; }
            .trash { font-size: 14px; }
        }
    </style>

<%@ include file="/branch/common/layout/layout_head.jsp" %>
<%
	Object lowStockListAttr = request.getAttribute("lowStockList");   // 안전재고 미달 품목
	Object addedItemListAttr = request.getAttribute("addedItemList"); // 추가 발주 품목
	
	// 안전재고 미달
	String lowStockJson = new com.google.gson.Gson().toJson(
		lowStockListAttr != null ? lowStockListAttr : java.util.Collections.emptyList()
	);
	
	// 
	String addedItemJson = new com.google.gson.Gson().toJson(
		addedItemListAttr != null ? addedItemListAttr : java.util.Collections.emptyList()
	);
%>
</head>

<body>
<div class="zl-app">
	<%@ include file="/branch/common/layout/sidebar.jsp" %>
	<div class="zl-content">
		<%@ include file="/branch/common/layout/topbar.jsp" %>
		<div class="wrap p-6">
		    <div class="page-head">
		        <div>
		            <h1 class="page-title">발주서 작성</h1>
		            <p class="page-sub">자동 생성된 발주서를 확인하고 품목을 추가하거나 수정하세요</p>
		        </div>
		        <div class="head-actions">
		            <a class="btn btn-primary open-place-popup" href="<%= request.getContextPath() %>/branch/place_order/send.jsp">✈ 본사 전송</a>
		        </div>
		    </div>
		
		    <section class="card warn">
		        <div class="card-head">
		            <div class="card-title-wrap">
		                <div class="card-icon">⚠</div>
		                <div>
		                    <h2 class="card-title">안전재고 미달 품목</h2>
		                    <p class="card-sub"><!-- 0개 품목이 안전 재고보다 부족합니다 --></p>
		                </div>
		            </div>
		            <div class="card-count"><!-- 0개 --></div>
		        </div>
		        <div class="table-wrap">
		            <table>
		                <thead>
		                <tr>
		                    <th>품목코드</th>
		                    <th>품목명</th>
		                    <th>카테고리</th>
		                    <th>현재 재고 합계</th>
		                    <th>안전 재고</th>
		                    <th>요청 수량</th>
		                    <th class="center">삭제</th>
		                </tr>
		                </thead>
		                <!-- 안전재고 미달 -->
		                <tbody id="lowStockTbody">
		                </tbody>
		            </table>
		        </div>
		    </section>
		
		    <section class="card added">
		        <div class="card-head">
		            <div class="card-title-wrap">
		                <div class="card-icon">＋</div>
		                <div>
		                    <h2 class="card-title">추가 발주 품목</h2>
		                    <p class="card-sub">수동으로 추가한 발주 품목입니다</p>
		                </div>
		            </div>
		            <div class="card-count">0개</div>
		        </div>
		        <div class="table-wrap">
		            <table>
		                <thead>
		                <tr>
		                    <th>품목코드</th>
		                    <th>품목명</th>
		                    <th>카테고리</th>
		                    <th>현재 재고 합계</th>
		                    <th>안전 재고</th>
		                    <th>요청 수량</th>
		                    <th class="center">삭제</th>
		                </tr>
		                </thead>
		                <tbody id="addedItemTbody">
		                </tbody>
		            </table>
		        </div>
		    </section>
		
		    <div class="add-action">
		                <a class="btn btn-add open-place-popup" href="<%= request.getContextPath() %>/branch/place_order/create_add.jsp">＋ 품목 추가</a>
		    </div>
		</div>
	</div>
</div>

<div id="placePopupOverlay" class="place-popup-overlay" aria-hidden="true">
        <iframe id="placePopupFrame" class="place-popup-frame" title="발주 팝업"></iframe>
</div>

<!-- JSON을 JS로 전달 -->
<script type="application/json" id="lowStockJson"><%= lowStockJson %></script>
<script type="application/json" id="addedItemJson"><%= addedItemJson %></script>

<script>
	// JS에서 데이터 파싱
	var lowStockData = [];
	var addedItemData = [];
	
	try {
	    lowStockData = JSON.parse(document.getElementById('lowStockJson').textContent || '[]');
	    addedItemData = JSON.parse(document.getElementById('addedItemJson').textContent || '[]');
	} catch (e) {
	    lowStockData = [];
	    addedItemData = [];
	}
	
	
	// 데이터 행 html
	function buildRow(item, isLowStock) {
	    var stockClass = isLowStock && item.currentStock < item.safeStock ? 'stock-low' : '';

	    return `
	        <tr data-id="${item.itemCode}">      
	        	<td>${item.itemCode}</td>
	            <td>${item.itemName}</td>
	            <td><span class="chip">${item.category}</span></td>
	            <td class="${stockClass}">${item.currentStock}${item.unit}</td>
	            <td>${item.safeStock}${item.unit}</td>
	            <td>
	                <span class="qty-cell">
	                    <input class="qty-input" type="number" 
	                    	min="${item.minQty != null ? item.minQty : 0}" 
	                    	max="${item.maxQty != null ? item.maxQty : ''}" 
	                    	step = "1"
	                    	value="${item.requestQty != null ? item.requestQty : 0}" 
                    	/>
	                    <span class="unit">${item.unit}</span>
	                </span>
	            </td>
	            <td class="center"><span class="trash">🗑</span></td>
	        </tr>
	    `;
	}
	
	// 테이블에 데이터 넣기
	function renderTables() {
	    var lowTbody = document.getElementById('lowStockTbody');
	    var addTbody = document.getElementById('addedItemTbody');
	
	    lowTbody.innerHTML = '';
	    addTbody.innerHTML = '';
	
    	// 데이터 행 넣기
	    lowStockData.forEach(function(item) {
	        lowTbody.insertAdjacentHTML('beforeend', buildRow(item, true));
	    });
	
	    addedItemData.forEach(function(item) {
	        addTbody.insertAdjacentHTML('beforeend', buildRow(item, false));
	    });
	
	    updateCounts();
	}
	
	// 카운트 동적 처리
	function updateCounts() {
	    var lowCount = lowStockData.length;
	    var addCount = addedItemData.length;

	    // 카드 개수
	    document.querySelector('.card.warn .card-count').textContent = lowCount + '개';
	    document.querySelector('.card.added .card-count').textContent = addCount + '개';

	    // 설명 텍스트
	    document.querySelector('.card.warn .card-sub').textContent =
	        lowCount + '개 품목이 안전 재고보다 부족합니다';
	}
	

	renderTables();
</script>

<!--  -->
<script>
    (function () {
        var overlay = document.getElementById('placePopupOverlay');
        var frame = document.getElementById('placePopupFrame');

        function openPopup(url) {
            if (!overlay || !frame || !url) return;
            frame.src = url;
            overlay.classList.add('active');
            overlay.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';
        }

        function closePopup() {
            if (!overlay || !frame) return;
            overlay.classList.remove('active');
            overlay.setAttribute('aria-hidden', 'true');
            frame.src = '';
            document.body.style.overflow = '';
        }

        document.addEventListener('click', function (event) {
            var target = event.target.closest('.open-place-popup');
            if (!target) return;

            event.preventDefault();
            openPopup(target.getAttribute('href'));
        });
        
     	// 삭제 버튼 클릭 시 해당 row 제거
        document.addEventListener('click', function (event) {
		    var btn = event.target.closest('.trash');
		    if (!btn) return;
		
		    var row = btn.closest('tr'); // 선택된 trash가 포함된 가장 가까운 tr
		    var id = row.dataset.id;
		    
		    if (!row || !confirm('발주 대상에서 삭제하시겠습니까?')) return;


		    // 배열 데이터에서도 제거
	    	// confirm은 동기함수. 버튼 누를 때까지 멈춰 있는다.
		    if (row.parentNode.id === 'lowStockTbody') {
		        lowStockData = lowStockData.filter(i => i.itemCode !== id);
		    } else {
		        addedItemData = addedItemData.filter(i => i.itemCode !== id);
		    }
		    
	        renderTables();
		});
     	
     	// 입력 시마다 호출되는 이벤트!
     	// 요청 수량 변경 시 -> 데이터 반영
     	document.addEventListener('input', function(e) {
     		if (!e.target.classList.contains('qty-input')) return;
     		
     		var row = e.target.closest('tr');
     		var id = row.dataset.id;
     		var qty = Number(e.target.value) || 0; // 수량
     		
     	    // 품목 발주 수량 검사
     	    var min = Number(e.target.min) || 0;
     	    var max = e.target.max ? Number(e.target.max) : Infinity;

     	    if (qty < min) qty = min;
     	    if (qty > max) qty = max;

     	    // 보정 된 값 다시 input에 반영
     	    e.target.value = qty;
     		
     	    // 데이터 반영
     	    if (row.parentNode.id === 'lowStockTbody') {
     	        var item = lowStockData.find(i => i.itemCode === id);
     	        if (item) item.requestQty = qty;
     	    } else {
     	        var item = addedItemData.find(i => i.itemCode === id);
     	        if (item) item.requestQty = qty;
     	    }
     	});
     	

        if (overlay) {
            overlay.addEventListener('click', function (event) {
                if (event.target === overlay) closePopup();
            });
        }

        window.addEventListener('message', function (event) {
            if (event.data && event.data.type === 'close-place-popup') {
                closePopup();
            }
        });
    })();
</script>
</body>
</html>
