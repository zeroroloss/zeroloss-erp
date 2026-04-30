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
	Integer lowStockTotalCount = (Integer) request.getAttribute("lowStockTotalCount");
	if (lowStockTotalCount == null) lowStockTotalCount = 0;

	Object draftAttr = request.getAttribute("draft");
	String draftJson = new com.google.gson.Gson().toJson(
        draftAttr != null ? draftAttr : new dto.branch.place_order.PlaceOrderDraftDTO()
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
		            <a class="btn btn-primary open-place-popup" data-type="send"
						href="<%= request.getContextPath() %>/branch/place_order/send.jsp">✈ 본사 전송</a>
		        </div>
		    </div>
		
		    <section class="card warn">
		        <div class="card-head">
		            <div class="card-title-wrap">
		                <div class="card-icon">⚠</div>
		                <div>
		                    <h2 class="card-title">안전재고 미달 품목</h2>
		                    <p class="card-sub">총 <%= lowStockTotalCount %>개 품목이 안전 재고 미달입니다</p>
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
		                <a class="btn btn-add open-place-popup" data-type="add" 
							href="<%= request.getContextPath() %>/branch/place_order/create_add.jsp">＋ 품목 추가</a>
		    </div>
		</div>
	</div>
</div>

<div id="placePopupOverlay" class="place-popup-overlay" aria-hidden="true">
        <iframe id="placePopupFrame" class="place-popup-frame" title="발주 팝업"></iframe>
</div>

<script type="application/json" id="draftJson"><%= draftJson %></script>
<script>
	// JS에서 데이터 파싱
	var draftData = {};
	var lowStockData = [];
	var addedItemData = [];
	
	try {
		draftData = JSON.parse(document.getElementById('draftJson').textContent || '{}');
		
		var details = draftData.details || [];
		
		details.forEach(function(item) {
			if (item.sourceType === 'LOW_STOCK') {
				lowStockData.push(item);
			} else {
				addedItemData.push(item);
			}
		});
		
	} catch (e) {
		draftData = {};
		lowStockData = [];
		addedItemData = [];
	}
	
	
	// 데이터 행 html
	function buildRow(item, isLowStock) {
	    var stockClass = isLowStock ? 'stock-low' : '';
	
	    return '<tr data-id="' + item.materialCode + '">' +
	        '<td>' + item.materialCode + '</td>' +
	        '<td>' + item.materialName + '</td>' +
	        '<td><span class="chip">' + item.categoryName + '</span></td>' +
	        '<td class="' + stockClass + '">' + (item.currentStock || 0) + (item.unit || '') + '</td>' +
	        '<td>' + (item.safeStock || 0) + (item.unit || '') + '</td>' +
	        '<td>' +
	            '<span class="qty-cell">' +
					'<input class="qty-input" type="number" ' +
						'value="' + (item.requestedQty != null ? item.requestedQty : (item.safeStock != null ? item.safeStock : 0)) + '" ' +
						'min="0" step="1">' +
	                '<span class="unit">' + (item.unit || '') + '</span>' +
	            '</span>' +
	        '</td>' +
	        '<td class="center"><span class="trash">🗑</span></td>' +
	    '</tr>';
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

	function syncPopupState() {
		var frame = document.getElementById('placePopupFrame');
		if (!frame || !frame.contentWindow) return;

		frame.contentWindow.postMessage({
			type: 'sync-order-state',
			data: {
				lowStock: lowStockData,
				added: addedItemData
			}
		}, '*');
	}

	function persistDraftChange(action, item) {
		return fetch('<%= request.getContextPath() %>/api/branch/place_order/draft', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json; charset=UTF-8',
				'Accept': 'application/json'
			},
			body: JSON.stringify({
				action: action,
				item: item
			})
		}).then(function(response) {
			if (!response.ok) {
				return response.json().catch(function() { return {}; }).then(function(payload) {
					throw new Error((payload && payload.message) || '발주 임시저장 반영에 실패했습니다.');
				});
			}
			return response.json().catch(function() { return {}; });
		});
	}

	function applyLocalDraftChange(action, item) {
		if (!item || !item.materialCode) return;

		if (action === 'add') {
			var normalized = {
				materialCode: item.materialCode,
				materialName: item.materialName || '',
				categoryName: item.categoryName || '',
				currentStock: Number(item.currentStock || 0),
				safeStock: Number(item.safeStock || 0),
				unit: item.unit || '',
				sourceType: item.sourceType || 'MANUAL',
				requestedQty: item.requestedQty != null ? Number(item.requestedQty) : (Number(item.safeStock || 0))
			};

			if (normalized.sourceType === 'LOW_STOCK') {
				if (!lowStockData.some(function(existing) { return existing.materialCode === normalized.materialCode; })) {
					lowStockData.unshift(normalized);
				}
			} else if (!addedItemData.some(function(existing) { return existing.materialCode === normalized.materialCode; })) {
				addedItemData.unshift(normalized);
			}
			return;
		}

		lowStockData = lowStockData.filter(function(existing) {
			return existing.materialCode !== item.materialCode;
		});
		addedItemData = addedItemData.filter(function(existing) {
			return existing.materialCode !== item.materialCode;
		});
	}
	
	// 카운트 동적 처리
	function updateCounts() {
	    var lowCount = lowStockData.length;
	    var addCount = addedItemData.length;

	    // 카드 개수
	    document.querySelector('.card.warn .card-count').textContent = lowCount + '개';
	    document.querySelector('.card.added .card-count').textContent = addCount + '개';
	}
	

	renderTables();
</script>

<script>
    (function () {
        var overlay = document.getElementById('placePopupOverlay');
        var frame = document.getElementById('placePopupFrame');

		function openPopup(url, popupType) {
            if (!overlay || !frame || !url) return;
            frame.src = url;
            overlay.classList.add('active');
            overlay.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';

			frame.onload = function () {
				syncPopupState();

				// send 팝업일 때만 데이터 전달
				// postMessage가 'message' 이벤트를 발생시킴
				if (popupType === 'send') {
					frame.contentWindow.postMessage({
						type: 'init-order-data',
						data: {
							lowStock: lowStockData,
							added: addedItemData
						}
					}, '*');
				}
			};
        }

		// send.jsp에 데이터 넘기는 함수
		function buildSummary() {
			var allItems = lowStockData.concat(addedItemData);

			var totalQty = 0;
			allItems.forEach(function(item) {
				totalQty += Number(item.requestedQty || 0);
			});

			return {
				itemCount: allItems.length,
				totalQty: totalQty,
				lowStockCount: lowStockData.length
			};
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

			var type = target.dataset.type;
			var url = target.getAttribute('href');

			openPopup(url, type);
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
		    	// 안전재고 미달 품목
		        lowStockData = lowStockData.filter(i => i.materialCode !== id);
		    } else {
		    	// 수동 추가 품목
		        addedItemData = addedItemData.filter(i => i.materialCode !== id);
		    }
		    
	        renderTables();
	        syncPopupState();
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
			    var item = lowStockData.find(i => i.materialCode === id);
			    if (item) item.requestedQty = qty;
			} else {
			    var item = addedItemData.find(i => i.materialCode === id);
			    if (item) item.requestedQty = qty;
			}
			syncPopupState();
     	});

		  // 입력 필드에서 포커스가 빠져나갈 때 서버에 요청수량을 반영한다 (blur / focusout)
		  document.addEventListener('focusout', function(e) {
			  if (!e.target.classList.contains('qty-input')) return;

			  var row = e.target.closest('tr');
			  if (!row) return;
			  var id = row.dataset.id;
			  var qty = Number(e.target.value) || 0;

			  var payload = { materialCode: id, requestedQty: qty };

			  persistDraftChange('update-qty', payload)
				  .then(function() {
					  // 성공 시 추가 동작 없음 (로컬 상태는 이미 업데이트되어 있음)
				  })
				  .catch(function(error) {
					  alert(error.message || '요청 수량 반영에 실패했습니다.');
				  });
		  });
     	

        if (overlay) {
            overlay.addEventListener('click', function (event) {
                if (event.target === overlay) closePopup();
            });
        }

        window.addEventListener('message', function (event) {
			if (!event.data || !event.data.type) return;

			if (event.data.type === 'close-place-popup') {
				closePopup();
				return;
			}

			if (event.data.type === 'add-item') {
				var addItem = event.data.item || {};
				if (!addItem.materialCode) return;

				persistDraftChange('add', addItem)
					.then(function() {
						applyLocalDraftChange('add', addItem);
						renderTables();
						syncPopupState();
					})
					.catch(function(error) {
						alert(error.message || '발주 임시저장 반영에 실패했습니다.');
						syncPopupState();
					});
				return;
			}

			if (event.data.type === 'remove-item') {
				var removeItem = event.data.item || {};
				if (!removeItem.materialCode) return;

				persistDraftChange('remove', removeItem)
					.then(function() {
						applyLocalDraftChange('remove', removeItem);
						renderTables();
						syncPopupState();
					})
					.catch(function(error) {
						alert(error.message || '발주 임시저장 반영에 실패했습니다.');
						syncPopupState();
					});
			}
        });
    })();
</script>
</body>
</html>
