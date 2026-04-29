<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>발주 품목 추가</title>
<style>
	* { margin: 0; padding: 0; box-sizing: border-box; }
	body { font-family: "Malgun Gothic", sans-serif; background: transparent; color: #111827; }
	
	.overlay {
		min-height: 100vh;
		background: transparent;
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 16px;
	}
	
	.modal {
		width: min(940px, 100%);
		height: min(95vh, 1800px);
		background: #fff;
		border-radius: 16px;
		display: flex;
		flex-direction: column;
		overflow: hidden;
		border: 1px solid #e5e7eb;
		box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22);
	}
	
	.modal-head {
		padding: 18px 22px 12px;
		border-bottom: 1px solid #e5e7eb;
		background: #fff;
	}
	
	.head-row {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 12px;
		margin-bottom: 14px;
	}
	
	.title {
		margin: 0;
		font-size: 24px;
		line-height: 1.1;
		font-weight: 900;
		color: #111827;
		letter-spacing: -0.02em;
	}
	
	.subtitle {
		margin: 8px 0 0;
		font-size: 14px;
		color: #6b7280;
	}
	
	.close-x {
		border: 0;
		background: transparent;
		color: #9aa3af;
		font-size: 24px;
		line-height: 1;
		cursor: pointer;
		transition: color 0.15s;
	}
	
	.close-x:hover { color: #374151; }
	
	/* 필터 영역 */
	.filter-card {
		background: #fafbfc;
		border-top: 1px solid #e5e7eb;
		border-bottom: 1px solid #e5e7eb;
		padding: 12px 22px;
	}
	
	.filter-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
		gap: 10px;
	}
	
	.filter-group {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}
	
	.filter-label {
		font-size: 12px;
		font-weight: 700;
		color: #6b7280;
		text-transform: uppercase;
		letter-spacing: 0.5px;
	}
	
	.filter-select, .filter-search {
		height: 36px;
		padding: 0 10px;
		border: 1px solid #d1d5db;
		border-radius: 8px;
		font-size: 13px;
		background: #fff;
		color: #111827;
		transition: border-color 0.15s, box-shadow 0.15s;
	}
	
	.filter-select:focus, .filter-search:focus {
		outline: none;
		border-color: #2563eb;
		box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.1);
	}
	
	/* 본문 */
	.modal-body {
		flex: 1;
		overflow: auto;
		padding: 16px 18px;
	}
	
	.item-list {
		display: grid;
		gap: 10px;
	}
	
	.item {
		background: #fff;
		border: 1px solid #e5e7eb;
		border-radius: 10px;
		padding: 12px;
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 14px;
		transition: all 0.15s;
	}
	
	.item:hover { border-color: #d1d5db; background: #fafbfc; }
	.item.low { border-color: #fde68a; background: #fffbeb; }
	.item.added { border-color: #9ec6ff; background: #eaf2ff; }
	
	.item-left {
		flex: 1;
		min-width: 0;
	}
	
	.item-title {
		font-size: 16px;
		font-weight: 800;
		color: #111827;
		margin-bottom: 4px;
		display: flex;
		align-items: center;
		gap: 8px;
		flex-wrap: wrap;
	}
	
	.item-code {
		font-size: 12px;
		color: #9aa3af;
		margin-bottom: 4px;
	}
	
	.item-meta {
		font-size: 12px;
		color: #6b7280;
		display: flex;
		gap: 12px;
		flex-wrap: wrap;
	}
	
	.chip {
		display: inline-flex;
		align-items: center;
		height: 22px;
		padding: 0 8px;
		border-radius: 6px;
		background: #eef2f7;
		color: #6b7280;
		font-size: 11px;
		font-weight: 700;
	}
	
	.chip.low { background: #fff2cc; color: #b7791f; }
	.chip.added { background: #d9e8ff; color: #2563eb; }
	
	.item-actions {
		display: flex;
		gap: 6px;
		flex-shrink: 0;
	}
	
	.btn-action {
		border: 0;
		height: 32px;
		padding: 0 12px;
		border-radius: 6px;
		font-size: 12px;
		font-weight: 700;
		cursor: pointer;
		transition: all 0.15s;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 4px;
	}
	
	.btn-add {
		background: #2563eb;
		color: #fff;
		border: 1px solid #1d4ed8;
	}
	
	.btn-add:hover {
		background: #1d4ed8;
		box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
	}
	
	.btn-add:active { transform: translateY(1px); }
	
	.btn-add.disabled, .btn-add:disabled {
		background: #f3f4f6;
		color: #6b7280;
		border-color: #d1d5db;
		cursor: not-allowed;
		box-shadow: none;
	}
	
	.btn-remove {
		background: #ef4444;
		color: #fff;
		border: 1px solid #dc2626;
	}
	
	.btn-remove:hover {
		background: #dc2626;
		box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
	}
	
	.btn-remove:active { transform: translateY(1px); }
	
	.empty-state {
		text-align: center;
		padding: 40px 20px;
		color: #9ca3af;
	}
	
	.empty-state-icon {
		font-size: 48px;
		margin-bottom: 12px;
	}
	
	.empty-state-text {
		font-size: 14px;
		margin-bottom: 4px;
	}
	
	.empty-state-sub {
		font-size: 12px;
		color: #bbb;
	}
	
	/* 푸터 */
	.modal-foot {
		border-top: 1px solid #e5e7eb;
		background: #fff;
		padding: 12px 18px;
	}
	
	.btn-close {
		width: 100%;
		height: 40px;
		border: 1px solid #d1d5db;
		background: #f9fafb;
		color: #374151;
		border-radius: 8px;
		font-size: 14px;
		font-weight: 700;
		text-decoration: none;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		transition: all 0.15s;
	}
	
	.btn-close:hover { background: #f3f4f6; }
	.btn-close:active { transform: translateY(1px); }
	
	@media (max-width: 768px) {
		.modal { width: 100%; height: 96vh; }
		.title { font-size: 20px; }
		.subtitle { font-size: 13px; }
		.filter-grid { grid-template-columns: 1fr; }
		.item { flex-direction: column; align-items: flex-start; }
		.item-actions { width: 100%; }
		.btn-action { flex: 1; }
		.item-title { font-size: 14px; }
		.item-code { font-size: 11px; }
		.item-meta { font-size: 11px; }
	}
</style>
</head>
<body>
<div class="overlay">
	<section class="modal" role="dialog" aria-modal="true" aria-label="발주 품목 추가">
		<!-- 헤더 -->
		<div class="modal-head">
			<div class="head-row">
				<div>
					<h1 class="title">발주 품목 추가</h1>
					<p class="subtitle">발주할 품목을 선택하거나 제외하세요</p>
				</div>
				<button class="close-x" type="button" aria-label="닫기">×</button>
			</div>
			
			<!-- 필터 영역 -->
			<div class="filter-card">
				<div class="filter-grid">
					<div class="filter-group">
						<label class="filter-label">카테고리</label>
						<select id="categoryFilter" class="filter-select" onchange="handleCategoryChange()">
							<option value="전체">전체</option>
						</select>
					</div>
					<div class="filter-group">
						<label class="filter-label">품목명</label>
						<select id="itemFilter" class="filter-select" onchange="handleItemChange()">
							<option value="전체">전체</option>
						</select>
					</div>
					<div class="filter-group">
						<label class="filter-label">검색</label>
						<input type="text" id="searchFilter" class="filter-search" placeholder="코드, 품목명, 카테고리..." onkeyup="handleSearchChange()" />
					</div>
				</div>
			</div>
		</div>

		<!-- 본문 -->
		<div class="modal-body">
			<div id="itemList" class="item-list"></div>
			<div id="emptyState" class="empty-state hidden">
				<div class="empty-state-icon">📦</div>
				<p class="empty-state-text">조회 결과가 없습니다</p>
				<p class="empty-state-sub">다른 필터 조건으로 검색해보세요</p>
			</div>
		</div>

		<!-- 푸터 -->
		<div class="modal-foot">
			<button class="btn-close" type="button">닫기</button>
		</div>
	</section>
</div>

<script>
	// ============================================
	// 전역 상태
	// ============================================
	var apiUrl = '<%=request.getContextPath()%>/api/branch/place_order/create/items';
	var items = [];
	var selectedCategory = '전체';
	var selectedItemName = '전체';
	var searchText = '';
	var addedItemCodes = new Set();

	// ============================================
	// 유틸리티
	// ============================================
	function hasText(value) {
		return value !== null && value !== undefined && String(value).trim() !== '';
	}

	function escapeHtml(value) {
		return String(value || '')
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#39;');
	}

	function normalizeResponse(payload) {
		if (!payload) { return []; }
		if (Array.isArray(payload)) { return payload; }
		if (payload.status === 'success' && Array.isArray(payload.data)) { return payload.data; }
		if (Array.isArray(payload.data)) { return payload.data; }
		return [];
	}

	// ============================================
	// API 통신
	// ============================================
	function loadItems() {
		var params = [];
		if (selectedCategory !== '전체') {
			params.push('category=' + encodeURIComponent(selectedCategory));
		}
		if (selectedItemName !== '전체') {
			params.push('item=' + encodeURIComponent(selectedItemName));
		}
		if (searchText.trim()) {
			params.push('search=' + encodeURIComponent(searchText.trim()));
		}
		
		var url = apiUrl + (params.length > 0 ? '?' + params.join('&') : '');
		
		fetch(url, { headers: { 'Accept': 'application/json' } })
			.then(function(response) { return response.json(); })
			.then(function(payload) {
				items = normalizeResponse(payload);
				updateCategoryFilter();
				updateItemFilter();
				renderTable();
			})
			.catch(function(error) {
				console.error('Error loading items:', error);
				items = [];
				renderTable();
			});
	}

	// ============================================
	// 필터 관리
	// ============================================
	function updateCategoryFilter() {
		var select = document.getElementById('categoryFilter');
		var values = ['전체'];
		var seen = {};
		
		items.forEach(function(item) {
			var cat = item.categoryName || item.category || item.groupName || '';
			if (hasText(cat) && !seen[cat]) {
				seen[cat] = true;
				values.push(cat);
			}
		});
		
		select.innerHTML = values.map(function(v) {
			return '<option value="' + escapeHtml(v) + '">' + escapeHtml(v) + '</option>';
		}).join('');
		select.value = selectedCategory;
	}

	function updateItemFilter() {
		var select = document.getElementById('itemFilter');
		
		if (selectedCategory === '전체') {
			select.innerHTML = '<option value="전체">전체</option>';
			select.value = '전체';
			return;
		}
		
		var values = ['전체'];
		var seen = {};
		
		items.forEach(function(item) {
			var cat = item.categoryName || item.category || item.groupName || '';
			var name = item.materialName || item.itemName || item.name || '';
			
			if (cat !== selectedCategory) { return; }
			
			if (hasText(name) && !seen[name]) {
				seen[name] = true;
				values.push(name);
			}
		});
		
		select.innerHTML = values.map(function(v) {
			return '<option value="' + escapeHtml(v) + '">' + escapeHtml(v) + '</option>';
		}).join('');
		select.value = selectedItemName;
	}

	function handleCategoryChange() {
		selectedCategory = document.getElementById('categoryFilter').value;
		selectedItemName = '전체';
		updateItemFilter();
		renderTable();
	}

	function handleItemChange() {
		selectedItemName = document.getElementById('itemFilter').value;
		renderTable();
	}

	function handleSearchChange() {
		searchText = document.getElementById('searchFilter').value;
		selectedCategory = '전체';
		selectedItemName = '전체';
		document.getElementById('categoryFilter').value = '전체';
		document.getElementById('itemFilter').value = '전체';
		updateCategoryFilter();
		updateItemFilter();
		renderTable();
	}

	// ============================================
	// 테이블 렌더링
	// ============================================
	function getFilteredItems() {
		return items.filter(function(item) {
			var cat = item.categoryName || item.category || item.groupName || '';
			var name = item.materialName || item.itemName || item.name || '';
			var code = item.materialCode || item.itemCode || '';
			
			// 카테고리 필터
			if (selectedCategory !== '전체' && cat !== selectedCategory) {
				return false;
			}
			
			// 품목명 필터
			if (selectedItemName !== '전체' && name !== selectedItemName) {
				return false;
			}
			
			// 검색 필터
			if (searchText.trim()) {
				var searchLower = searchText.toLowerCase();
				if (!code.toLowerCase().includes(searchLower) &&
					!name.toLowerCase().includes(searchLower) &&
					!cat.toLowerCase().includes(searchLower)) {
					return false;
				}
			}
			
			return true;
		});
	}

	function renderTable() {
		var filtered = getFilteredItems();
		var html = '';
		var empty = document.getElementById('emptyState');
		var list = document.getElementById('itemList');
		
		if (filtered.length === 0) {
			list.innerHTML = '';
			empty.classList.remove('hidden');
			return;
		}
		
		empty.classList.add('hidden');
		
		filtered.forEach(function(item) {
			var code = item.materialCode || item.itemCode || '';
			var name = item.materialName || item.itemName || '';
			var cat = item.categoryName || item.category || item.groupName || '';
			var unit = item.unit || '';
			var qty = item.currentQty || item.qty || 0;
			var safeQty = item.safeStockQty || item.safeQty || 0;
			var isAdded = addedItemCodes.has(code);
			
			var lowClass = qty < safeQty ? 'low' : '';
			var addedClass = isAdded ? 'added' : '';
			
			html += '<div class="item ' + lowClass + ' ' + addedClass + '" data-code="' + escapeHtml(code) + '">';
			html += '  <div class="item-left">';
			html += '    <div class="item-title">';
			html += '      <span>' + escapeHtml(name) + '</span>';
			html += '      <span class="chip">' + escapeHtml(cat) + '</span>';
			if (qty < safeQty) {
				html += '      <span class="chip low">⚠ 재고 부족</span>';
			}
			html += '    </div>';
			html += '    <div class="item-code">품목코드: ' + escapeHtml(code) + '</div>';
			html += '    <div class="item-meta">';
			html += '      <span><strong>현재: ' + qty + unit + '</strong></span>';
			html += '      <span>안전: ' + safeQty + unit + '</span>';
			if (qty < safeQty) {
				html += '      <span style="color: #ef4444; font-weight: 700;">부족: ' + (safeQty - qty) + unit + '</span>';
			}
			html += '    </div>';
			html += '  </div>';
			html += '  <div class="item-actions">';
			
			if (isAdded) {
				html += '    <button class="btn-action btn-remove" onclick="handleRemove(\'' + escapeHtml(code) + '\')">제외</button>';
			} else {
				html += '    <button class="btn-action btn-add" onclick="handleAdd(\'' + escapeHtml(code) + '\')">추가</button>';
			}
			
			html += '  </div>';
			html += '</div>';
		});
		
		list.innerHTML = html;
	}

	// ============================================
	// 액션 핸들러
	// ============================================
	function handleAdd(code) {
		addedItemCodes.add(code);
		notifyParent('add', code);
		renderTable();
	}

	function handleRemove(code) {
		addedItemCodes.delete(code);
		notifyParent('remove', code);
		renderTable();
	}

	function notifyParent(action, code) {
		var item = items.find(function(i) { return (i.materialCode || i.itemCode) === code; });
		if (!item) { return; }
		
		var name = item.materialName || item.itemName || '';
		
		if (window.parent && window.parent !== window) {
			window.parent.postMessage({
				type: action === 'add' ? 'add-item' : 'remove-item',
				item: {
					materialCode: code,
					materialName: name
				}
			}, '*');
		}
	}

	// ============================================
	// 초기화 및 이벤트
	// ============================================
	function closePopup() {
		if (window.parent && window.parent !== window) {
			window.parent.postMessage({
				type: 'close-place-popup'
			}, '*');
		}
	}

	// 초기 로드
	loadItems();

	// 닫기 버튼 이벤트
	document.querySelectorAll('.close-x, .btn-close').forEach(function(btn) {
		btn.addEventListener('click', function(e) {
			e.preventDefault();
			closePopup();
		});
	});
</script>
</body>
</html>
