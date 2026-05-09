<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
<title>입고 처리</title>
<style>
body {
	margin: 0;
	font-family: "Malgun Gothic", sans-serif;
	background: #f4f7fb;
	color: #111827;
}

.center {
	text-align: center;
}

.wrap {
	width: 100%;
	max-width: none;
	margin: 0;
}

.page-head {
	padding: 18px 0 10px;
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	gap: 16px;
}

.page-title {
	margin: 0;
	font-size: 30px;
	line-height: 1.15;
	font-weight: 800;
	letter-spacing: -0.03em;
}

.page-sub {
	margin: 8px 0 0;
	font-size: 15px;
	color: #6b7280;
}

.order-list {
	margin-top: 14px;
	display: grid;
	gap: 14px;
}

.order-card {
	background: #fff;
	border: 1px solid #e5e7eb;
	border-radius: 14px;
	overflow: hidden;
	box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
}

.order-card.open {
	border-color: #dbe5ff;
}

.order-head {
	width: 100%;
	border: 0;
	background: #fff;
	padding: 18px 20px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
	cursor: pointer;
	text-align: left;
}

.order-left {
	display: flex;
	align-items: center;
	gap: 14px;
	min-width: 0;
}

.icon-box {
	width: 52px;
	height: 52px;
	border-radius: 14px;
	background: #dbeafe;
	display: grid;
	place-items: center;
	color: #2563eb;
	font-size: 22px;
	flex: 0 0 52px;
}

.icon-img {
	width: 24px;
	height: 24px;
	display: block;
}

.order-meta {
	min-width: 0;
}

.order-line1 {
	display: flex;
	align-items: center;
	gap: 10px;
	flex-wrap: wrap;
}

.order-no {
	font-size: 20px;
	font-weight: 800;
	letter-spacing: -0.02em;
}

.status-pill {
	display: inline-flex;
	align-items: center;
	padding: 5px 10px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 700;
}

.status-wait {
	background: #fff4b8;
	color: #b45309;
}

.status-partial {
	background: #ffedd5;
	color: #c2410c;
}

.discrepancy {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	color: #ea580c;
	font-size: 13px;
	font-weight: 700;
}

.discrepancy-icon {
	width: 14px;
	height: 14px;
	display: block;
}

.order-line2 {
	margin-top: 8px;
	display: flex;
	gap: 18px;
	flex-wrap: wrap;
	color: #6b7280;
	font-size: 14px;
}

.chev {
	color: #9ca3af;
	font-size: 18px;
}

.chev-icon {
	width: 18px;
	height: 18px;
	display: block;
}

.order-body {
	border-top: 1px solid #edf0f5;
	padding: 18px 20px 20px;
}

.section-title {
	margin: 0 0 14px;
	font-size: 18px;
	font-weight: 800;
}

.items-table {
	width: 100%;
	border-collapse: collapse;
    text-align: center;
}

.items-table th, .items-table td {
    padding: 13px 14px;
    border-bottom: 1px solid #edf0f5;
    font-size: 14px;
    text-align: center;
    vertical-align: middle;
}

.items-table th {
	background: #fafbfc;
	color: #4b5563;
	font-weight: 700;
}

.items-table input[type="number"], .items-table input[type="text"] {
	width: 100%;
	box-sizing: border-box;
	height: 40px;
	padding: 0 12px;
	border: 1px solid #d6dae3;
	border-radius: 10px;
	font-size: 14px;
    text-align: center;
}

.items-table input.qty-warn {
	border-color: #fb923c;
	background: #fff7ed;
}

.history-toggle {
	margin-top: 18px;
	color: #334155;
	font-weight: 700;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	cursor: pointer;
}

.history-toggle-icon {
	width: 14px;
	height: 14px;
	display: block;
}

.history-panel {
	margin-top: 14px;
	padding: 14px 16px;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	background: #fafbfc;
	display: none;
}

.history-item {
	display: flex;
	align-items: center;
	gap: 12px;
	padding: 8px 0;
	font-size: 14px;
	color: #374151;
}

.dot {
	width: 8px;
	height: 8px;
	border-radius: 999px;
	background: #2563eb;
}

.actions {
	margin-top: 20px;
	display: flex;
	justify-content: flex-end;
	gap: 12px;
}

.btn {
	height: 42px;
	padding: 0 18px;
	border-radius: 12px;
	font-weight: 700;
	border: 0;
	cursor: pointer;
}

.btn-cancel {
	background: #fff;
	border: 1px solid #d6dae3;
	color: #111827;
}

.btn-confirm {
	background: #2563eb;
	color: #fff;
	display: inline-flex;
	align-items: center;
	gap: 8px;
}

.btn-icon {
	width: 14px;
	height: 14px;
	display: block;
}

.toast {
	position: fixed;
	top: 18px;
	right: 18px;
	z-index: 1000;
	background: #fff;
	border: 1px solid #dbe5ff;
	border-left: 4px solid #2563eb;
	box-shadow: 0 12px 28px rgba(15, 23, 42, 0.14);
	border-radius: 12px;
	padding: 14px 16px;
	display: none;
	max-width: 360px;
}

.toast.show {
	display: block;
}

.toast strong {
	display: block;
	margin-bottom: 4px;
}

@media ( max-width : 960px) {
	.page-head {
		flex-direction: column;
	}
	.order-head {
		align-items: flex-start;
	}
	.order-left {
		align-items: flex-start;
	}
}

@media ( max-width : 720px) {
	.items-table, .items-table thead, .items-table tbody, .items-table th,
		.items-table td, .items-table tr {
		display: block;
		width: 100%;
	}
	.items-table thead {
		display: none;
	}
	.items-table tr {
		padding: 12px 0;
		border-bottom: 1px solid #edf0f5;
	}
	.items-table td {
		border: 0;
		padding: 6px 0;
	}
	.items-table td::before {
		content: attr(data-label);
		display: block;
		font-size: 12px;
		color: #6b7280;
		margin-bottom: 4px;
		font-weight: 700;
	}
}
</style>

<%@ include file="/branch/common/layout/layout_head.jsp"%>
</head>
<body>
	<div class="zl-app">
		<%@ include file="/branch/common/layout/sidebar.jsp"%>
		<div class="zl-content">
			<div class="wrap p-6">
				<div class="page-head">
					<div>
						<h1 class="page-title">입고 처리</h1>
						<p class="page-sub">본사로부터 받은 물품을 확인 후 입고를 확정합니다</p>
					</div>
				</div>

				<div class="order-list" id="orderList">
					<!-- Loading / content will be rendered dynamically by JS -->
					<div id="loadingPlaceholder" class="p-6 text-center text-gray-600">로딩
						중...</div>
				</div>
			</div>
		</div>
	</div>

	<div class="toast" id="toastBox">
		<strong>입고가 완료되었습니다.</strong><span>재고가 자동으로 반영되었습니다.</span>
	</div>

	<script>
(function(){
	const container = document.getElementById('orderList');
	const loadingPlaceholder = document.getElementById('loadingPlaceholder');
	const toast = document.getElementById('toastBox');

	function showToast() {
		if (!toast) return;
		toast.classList.add('show');
		setTimeout(() => toast.classList.remove('show'), 2800);
	}

	// Event delegation for card toggle, history toggle, and confirm buttons
	container.addEventListener('click', async function(e){
		const head = e.target.closest('.order-head');
		if (head && container.contains(head)) {
			const card = head.closest('.order-card');
			if (!card) return;
			const body = card.querySelector('.order-body');
			const isOpen = card.classList.contains('open');
			if (isOpen) {
				body.style.display = 'none';
				card.classList.remove('open');
			} else {
				body.style.display = 'block';
				card.classList.add('open');
			}
			const chev = head.querySelector('.chev-icon');
			if (chev) {
				chev.src = isOpen
					? '<%=request.getContextPath()%>/branch/icons/receipt/chevron-down.svg'
					: '<%=request.getContextPath()%>/branch/icons/receipt/chevron-up.svg';
			}
			return;
		}

		const historyToggle = e.target.closest('.history-toggle');
		if (historyToggle) {
			const tgtId = historyToggle.getAttribute('data-history-target');
			const tgt = document.getElementById(tgtId);
			if (tgt) tgt.style.display = (tgt.style.display === 'block') ? 'none' : 'block';
			return;
		}

		// handle confirm (입고 확정) button clicks
		const confirmBtn = e.target.closest('.btn-confirm');
		if (confirmBtn) {
			const card = confirmBtn.closest('.order-card');
			if (!card) return;

			const poNo = card.getAttribute('data-po-no');
			const rows = Array.from(card.querySelectorAll('tbody tr'));
			const items = rows.map(row => {
				const qtyInput = row.querySelector('.received-qty');
				const noteInput = row.querySelector('.received-note');
				return {
					hqOutboundDetailId: Number(row.getAttribute('data-hq-outbound-detail-id')),
					receivedQty: qtyInput ? Number(qtyInput.value || 0) : 0,
					note: noteInput ? String(noteInput.value || '') : ''
				};
			});

			try {
				confirmBtn.disabled = true;
				const res = await fetch('<%=request.getContextPath()%>/api/branch/inbound/processing', {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({ poNo, items })
				});

				const body = await res.json().catch(() => ({}));
				if (!res.ok || body.status !== 'success') {
					throw new Error(body.message || ('입고 확정 실패: ' + res.status));
				}

				showToast();
				await loadReceivingList();
			} catch (err) {
				commonShowAlert('알림', err.message || '입고 확정 중 오류가 발생했습니다.');
			} finally {
				confirmBtn.disabled = false;
			}
			return;
		}
	});

	async function loadReceivingList() {
		try {
			if (loadingPlaceholder) loadingPlaceholder.textContent = '로딩 중...';
			// load list of orders eligible for inbound processing
			const res = await fetch('<%=request.getContextPath()%>/api/branch/inbound/processing');
			if (!res.ok) throw new Error('네트워크 오류: ' + res.status);
			const data = await res.json();
            console.log('입고 처리 데이터', data);
			renderOrders(Array.isArray(data) ? data : []);
		} catch (err) {
			console.error('데이터 조회 실패:', err);
			if (loadingPlaceholder) loadingPlaceholder.textContent = '데이터를 불러오지 못했습니다.';
			container.innerHTML = '<div class="p-6 text-center text-red-500">데이터를 불러오지 못했습니다. 콘솔을 확인하세요.</div>';
		}
	}

	function escapeHtml(str) {
		if (str == null) return '';
		return String(str)
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#039;');
	}

	function renderOrders(list) {
		container.innerHTML = '';
		if (!list || list.length === 0) {
			container.innerHTML = '<div class="p-6 text-center text-gray-600">본사로부터 받은 품목이 없습니다.</div>';
			return;
		}

		list.forEach(order => {
			const itemsHtml = (order.items || []).map(item => {
				return '<tr data-hq-outbound-detail-id="' + escapeHtml(item.hqOutboundDetailId || '') + '">' +
                    '<td data-label="재고번호">' + escapeHtml(item.stockNo || '-') + '</td>' +
					'<td data-label="품목명">' + escapeHtml(item.materialName || '-') + '</td>' +
					'<td data-label="카테고리">' + escapeHtml(item.category || '-') + '</td>' +
					'<td data-label="발주 수량" class="center">' + escapeHtml((item.requestedQty ?? 0) + ' ' + (item.unit || '')) + '</td>' +
                    '<td data-label="본사 출고 수량" class="center">' + escapeHtml((item.outboundQty ?? 0) + ' ' + (item.unit || '')) + '</td>' +
					'<td data-label="입고 수량" class="center">' +
                        '<div style="display:flex; align-items:center; gap:4px; justify-content:center;">' +
                            '<input type="number" class="received-qty" min="0" step="0.01" value="' + escapeHtml(item.outboundQty ?? 0) + '" style="width:80px;" />' +
                            '<span>' + escapeHtml(item.unit || '') + '</span>' +
                        '</div>' +
                    '</td>' +    
					'<td data-label="유통기한">' + escapeHtml(item.expiryDate || '-') + '</td>' +
					'<td data-label="비고"><input type="text" class="received-note" value="' + escapeHtml('') + '" /></td>' +
				'</tr>';
			}).join('');

			const cardHtml =
				'<div class="order-card" id="order-' + escapeHtml(order.poNo || '') + '" data-po-no="' + escapeHtml(order.poNo || '') + '">' +
					'<button class="order-head" type="button">' +
						'<div class="order-left">' +
							'<div class="icon-box">📦</div>' +
							'<div class="order-meta">' +
								'<div class="order-line1"><span class="order-no">발주 번호: ' + escapeHtml(order.poNo || '-') + '</span></div>' +
								'<div class="order-line2"><span>발주 요청 일시: ' + escapeHtml(order.requestedAt || '-') + '</span>' +
								'<span>출고 일시: ' + escapeHtml(order.outboundAt || '-') + '</span></div>' +
							'</div>' +
						'</div>' +
						'<span class="chev"><img class="chev-icon" src="<%=request.getContextPath()%>/branch/icons/receipt/chevron-down.svg" alt="열기" /></span>' +
					'</button>' +
					'<div class="order-body" style="display:none">' +
						'<h2 class="section-title">입고 품목</h2>' +
						'<table class="items-table"><thead>' +
							'<tr>' +
								'<th>재고 번호</th><th>품목명</th><th>카테고리</th><th class="center">발주 수량</th><th class="center">본사 출고 수량</th><th class="center">입고 수량</th><th>유통기한</th><th>비고</th>' +
							'</tr></thead><tbody>' + itemsHtml + '</tbody></table>' +
						'<div class="actions"><button class="btn btn-confirm">입고 확정</button></div>' +
					'</div>' +
				'</div>';

			container.insertAdjacentHTML('beforeend', cardHtml);
		});
	}

	// Initialize
	document.addEventListener('DOMContentLoaded', function(){
		loadReceivingList();
	});

})();
	</script>
</body>
</html>
