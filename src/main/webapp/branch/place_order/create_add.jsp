<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>발주 품목 추가</title>
<style>
* { box-sizing: border-box; }
body {
	margin: 0;
	font-family: "Malgun Gothic", sans-serif;
	background: transparent;
	color: #111827;
}

.overlay {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 16px;
}

.modal {
	width: min(940px, 100%);
	height: min(95vh, 1700px);
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
}

.title {
	margin: 0;
	font-size: 24px;
	line-height: 1.1;
	font-weight: 900;
	color: #111827;
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
}

.filter-card {
	margin-top: 12px;
	padding: 10px;
	background: #f8fafc;
	border: 1px solid #e5e7eb;
	border-radius: 10px;
}

.filter-grid {
	display: grid;
	grid-template-columns: repeat(3, minmax(0, 1fr));
	gap: 8px;
}

.filter-group label {
	display: block;
	font-size: 12px;
	font-weight: 700;
	color: #6b7280;
	margin-bottom: 4px;
}

.filter-select,
.filter-input {
	width: 100%;
	height: 36px;
	border: 1px solid #d1d5db;
	border-radius: 8px;
	padding: 0 10px;
	font-size: 13px;
	background: #fff;
}

.modal-body {
    display: flex;
    flex: 1;
    overflow: hidden;
}

.pane {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.pane + .pane {
    border-left: 1px solid #e5e7eb;
}

.pane-scroll {
    overflow-y: auto;
    flex: 1;
}

.pane-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 14px;
    border-bottom: 1px solid #e5e7eb;
    background: #f9fafb;
}

.pane-title {
    font-size: 14px;
    font-weight: 800;
    color: #111827;
}

.count-badge {
    min-width: 28px;
    height: 26px;
    padding: 0 10px;
    border-radius: 999px;
    background: #e5e7eb;
    color: #374151;
    font-size: 13px;
    font-weight: 800;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* 추가된 쪽 강조 */
.count-badge.added {
    background: #2563eb;
    color: #fff;
}

.table-wrap {
	border: 1px solid #e5e7eb;
	border-radius: 10px;
	overflow: hidden;
}

.list-table {
	width: 100%;
	border-collapse: collapse;
}

.list-table th,
.list-table td {
	padding: 12px 10px;
	border-bottom: 1px solid #eef2f7;
	font-size: 13px;
	vertical-align: middle;
}

.list-table th {
	background: #f9fafb;
	font-weight: 800;
	color: #374151;
	text-align: left;
}

.list-table tbody tr:hover {
	background: #f8fafc;
}

.list-table tbody tr.is-low {
	background: #fffbeb;
}

.list-table tbody tr.is-low:hover {
	background: #fef3c7;
}

.info-cell {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
}

.info-main {
	min-width: 0;
}

.item-name {
	font-size: 14px;
	font-weight: 800;
	color: #111827;
}

.info-sub {
	margin-top: 4px;
	display: flex;
	align-items: center;
	gap: 6px;
	flex-wrap: wrap;
}

.chip {
	display: inline-flex;
	align-items: center;
	height: 22px;
	padding: 0 8px;
	border-radius: 999px;
	font-size: 11px;
	font-weight: 700;
}

.chip-category {
	background: #eef2f7;
	color: #475569;
}

.chip-low {
	background: #fde68a;
	color: #92400e;
}

.chip-added-low {
	background: #fcd34d;
	color: #78350f;
}

.chip-added-manual {
	background: #dbeafe;
	color: #1e40af;
}

.stock-value {
	font-weight: 800;
}

.text-right {
	text-align: right;
}

.btn-action {
	border: 0;
	height: 30px;
	min-width: 68px;
	padding: 0 10px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 800;
	cursor: pointer;
}

.btn-add {
	background: #2563eb;
	color: #fff;
}

.btn-remove {
	background: #ef4444;
	color: #fff;
}

.empty {
	display: none;
	padding: 30px;
	text-align: center;
	color: #9aa3af;
	font-size: 13px;
}

.modal-foot {
	border-top: 1px solid #e5e7eb;
	padding: 12px 18px;
}

.btn-close {
	width: 100%;
	height: 40px;
	border: 1px solid #d1d5db;
	background: #f9fafb;
	color: #374151;
	border-radius: 10px;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
}

@media (max-width: 760px) {
	.overlay { padding: 8px; }
	.modal { width: 100%; height: 96vh; }
	.filter-grid { grid-template-columns: 1fr; }
	.list-table th,
	.list-table td { font-size: 12px; padding: 10px 8px; }
	.item-name { font-size: 13px; }
	.btn-action { min-width: 60px; }
}
</style>
</head>
<body>
<div class="overlay">
	<section class="modal" role="dialog" aria-modal="true" aria-label="발주 품목 추가">
		<div class="modal-head">
			<div class="head-row">
				<div>
					<h1 class="title">발주 품목 추가</h1>
					<p class="subtitle">추가된 품목은 우측에 표시됩니다</p>
				</div>
				<button class="close-x" type="button" aria-label="닫기">×</button>
			</div>

			<div class="filter-card">
				<div class="filter-grid">
					<div class="filter-group">
						<label for="categoryFilter">카테고리</label>
						<select id="categoryFilter" class="filter-select"></select>
					</div>
					<div class="filter-group">
						<label for="itemFilter">품목명</label>
						<select id="itemFilter" class="filter-select"></select>
					</div>
					<div class="filter-group">
						<label for="searchFilter">검색</label>
						<input id="searchFilter" class="filter-input" type="text" placeholder="품목코드, 카테고리, 품목 검색" />
					</div>
				</div>
			</div>
		</div>

		<div class="modal-body">

            <!-- 좌: 미추가 -->
            <div class="pane">
                <div class="pane-head">
                    <span class="pane-title">전체 품목</span>
                    <span id="countLeft" class="count-badge">0</span>
                </div>
                <div class="pane-scroll">
                    <table class="list-table">
                        <thead>
                            <tr>
                                <th>품목명</th>
                                <th class="text-right">현재재고</th>
                                <th class="text-right">안전재고</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="leftBody"></tbody>
                    </table>
                </div>
            </div>

            <!-- 우: 추가됨 -->
            <div class="pane">
                <div class="pane-head">
                    <span class="pane-title">추가된 품목</span>
                    <span id="countRight" class="count-badge added">0</span>
                </div>
                <div class="pane-scroll">
                    <table class="list-table">
                        <thead>
                            <tr>
                                <th>품목명</th>
                                <th class="text-right">현재재고</th>
                                <th class="text-right">안전재고</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="rightBody"></tbody>
                    </table>
                </div>
            </div>

        </div>

		<div class="modal-foot">
			<button class="btn-close" type="button">닫기</button>
		</div>
	</section>
</div>

<script>
(function() {
	var apiUrl = '<%=request.getContextPath()%>/api/branch/place_order/create/items';
	var items = [];
	var pendingParentState = null;
	var selectedCategory = '전체';
	var selectedItemName = '전체';
	var searchText = '';

	var categoryFilter = document.getElementById('categoryFilter');
	var itemFilter = document.getElementById('itemFilter');
	var searchFilter = document.getElementById('searchFilter');

    var leftBody  = document.getElementById('leftBody');
    var rightBody = document.getElementById('rightBody');
    var countLeft = document.getElementById('countLeft');
    var countRight= document.getElementById('countRight');

	function hasText(value) {
		return value !== null && value !== undefined && String(value).trim() !== '';
	}

	function toNumber(value) {
		var parsed = Number(value);
		return isNaN(parsed) ? 0 : parsed;
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
		if (payload.status === 'success' && Array.isArray(payload.data)) { return payload.data; }
		if (Array.isArray(payload)) { return payload; }
		if (Array.isArray(payload.data)) { return payload.data; }
		return [];
	}

	function buildOptionHtml(values) {
		return values.map(function(v) {
			return '<option value="' + escapeHtml(v) + '">' + escapeHtml(v) + '</option>';
		}).join('');
	}

	function loadItems() {
		var params = [];
		if (selectedCategory !== '전체') { params.push('category=' + encodeURIComponent(selectedCategory)); }
		if (selectedItemName !== '전체') { params.push('item=' + encodeURIComponent(selectedItemName)); }
		if (hasText(searchText)) { params.push('search=' + encodeURIComponent(searchText)); }

		var url = apiUrl + (params.length ? '?' + params.join('&') : '');
		fetch(url, { headers: { 'Accept': 'application/json' } })
			.then(function(res) { return res.json(); })
			.then(function(payload) {
				items = normalizeResponse(payload).map(function(item) {
					item.currentStock = toNumber(item.currentStock);
					item.safeStock = toNumber(item.safeStock);
					item.isLowStock = String(item.isLowStock) === '1' || item.isLowStock === true;
					item.isAdded = String(item.isAdded) === '1' || item.isAdded === true;
					item.sourceType = item.sourceType || (item.isLowStock ? 'LOW_STOCK' : 'MANUAL');
					return item;
				});
				if (pendingParentState) {
					applyParentState(pendingParentState);
				}
				updateCategoryFilter();
				updateItemFilter();
				renderBothPanes();
			})
			.catch(function() {
                leftBody.innerHTML = '<tr><td colspan="4">데이터를 불러오지 못했습니다</td></tr>';
                rightBody.innerHTML = '';
                countLeft.textContent = 0;
                countRight.textContent = 0;
            });
	}

	function updateCategoryFilter() {
		var values = ['전체'];
		var seen = {};
		items.forEach(function(item) {
			var category = item.categoryName || '';
			if (hasText(category) && !seen[category]) {
				seen[category] = true;
				values.push(category);
			}
		});
		categoryFilter.innerHTML = buildOptionHtml(values);
		if (!seen[selectedCategory] && selectedCategory !== '전체') {
			selectedCategory = '전체';
		}
		categoryFilter.value = selectedCategory;
	}

	function updateItemFilter() {
		var values = ['전체'];
		var seen = {};
		items.forEach(function(item) {
			var category = item.categoryName || '';
			if (selectedCategory !== '전체' && category !== selectedCategory) {
				return;
			}
			var name = item.materialName || '';
			if (hasText(name) && !seen[name]) {
				seen[name] = true;
				values.push(name);
			}
		});
		itemFilter.innerHTML = buildOptionHtml(values);
		if (!seen[selectedItemName] && selectedItemName !== '전체') {
			selectedItemName = '전체';
		}
		itemFilter.value = selectedItemName;
	}

	function getFilteredItems() {
		var filtered = items.filter(function(item) {
			var category = item.categoryName || '';
			var name = item.materialName || '';
			var code = item.materialCode || '';
			if (selectedCategory !== '전체' && category !== selectedCategory) { return false; }
			if (selectedItemName !== '전체' && name !== selectedItemName) { return false; }
			if (hasText(searchText)) {
				var keyword = searchText.toLowerCase();
				if (code.toLowerCase().indexOf(keyword) < 0
					&& name.toLowerCase().indexOf(keyword) < 0
					&& category.toLowerCase().indexOf(keyword) < 0) {
					return false;
				}
			}
			return true;
		});

		filtered.sort(function(a, b) {
			if (a.isAdded !== b.isAdded) {
				return a.isAdded ? -1 : 1;
			}
			if (a.isLowStock !== b.isLowStock) {
				return a.isLowStock ? -1 : 1;
			}
			return String(a.materialName || '').localeCompare(String(b.materialName || ''), 'ko');
		});

		return filtered;
	}

	function getActionButtonHtml(item) {
		var code = escapeHtml(item.materialCode || '');
		if (item.isAdded) {
			return '<button class="btn-action btn-remove" data-action="remove" data-code="' + code + '">제외</button>';
		}
		return '<button class="btn-action btn-add" data-action="add" data-code="' + code + '">추가</button>';
	}

    function renderBothPanes() {
        var filtered = getFilteredItems();

        var leftItems = filtered.filter(i => !i.isAdded);

        var rightItems = filtered.filter(i => i.isAdded);

        leftItems.sort(function(a, b) {
            if (a.isLowStock !== b.isLowStock) return a.isLowStock ? -1 : 1;
            return a.materialName.localeCompare(b.materialName, 'ko');
        });

        rightItems.sort(function(a, b) {
            if (a.isLowStock !== b.isLowStock) return a.isLowStock ? -1 : 1;
            return a.materialName.localeCompare(b.materialName, 'ko');
        });

        countLeft.textContent = leftItems.length;
        countRight.textContent = rightItems.length;

        if (leftItems.length) {
            leftBody.innerHTML = leftItems.map(buildRow).join('');
        } else {
            leftBody.innerHTML = '<tr><td colspan="4">조회 결과가 없습니다</td></tr>';
        }

        if (rightItems.length) {
            rightBody.innerHTML = rightItems.map(buildRow).join('');
        } else {
            rightBody.innerHTML = '<tr><td colspan="4">추가된 품목이 없습니다</td></tr>';
        }
    }

	function findItemByCode(code) {
		for (var i = 0; i < items.length; i += 1) {
			if (String(items[i].materialCode) === String(code)) {
				return items[i];
			}
		}
		return null;
	}

	function applyParentState(state) {
		pendingParentState = state || null;
		if (!items.length || !pendingParentState) {
			return;
		}

		var parentMap = {};
		(pendingParentState.lowStock || []).forEach(function(item) {
			if (item && item.materialCode) {
				parentMap[item.materialCode] = item;
			}
		});
		(pendingParentState.added || []).forEach(function(item) {
			if (item && item.materialCode) {
				parentMap[item.materialCode] = item;
			}
		});

		items.forEach(function(item) {
			var parentItem = parentMap[item.materialCode];
			item.isAdded = !!parentItem;
			if (parentItem) {
				item.currentStock = toNumber(parentItem.currentStock);
				item.safeStock = toNumber(parentItem.safeStock);
				item.unit = parentItem.unit || item.unit;
				item.sourceType = parentItem.sourceType || item.sourceType;
			}
		});

		updateCategoryFilter();
		updateItemFilter();
		renderBothPanes();
	}

    function buildRow(item) {
        var unit = escapeHtml(item.unit || '');
        var code = escapeHtml(item.materialCode || '');

        var btn = item.isAdded
            ? '<button class="btn-action btn-remove" data-action="remove" data-code="'+code+'">제외</button>'
            : '<button class="btn-action btn-add" data-action="add" data-code="'+code+'">추가</button>';

        return `
        <tr data-code="\${item.materialCode}" class="\${item.isLowStock ? 'is-low' : ''}">
            <td>
                <div class="item-name">\${escapeHtml(item.materialName)}</div>
                <div class="info-sub">
                    <span class="chip chip-category">\${escapeHtml(item.categoryName)}</span>
                    \${item.isLowStock ? '<span class="chip chip-low">재고부족</span>' : ''}
                </div>
            </td>
            <td class="text-right">\${item.currentStock}\${unit}</td>
            <td class="text-right">\${item.safeStock}\${unit}</td>
            <td>\${btn}</td>
        </tr>`;
    }

	function notifyParent(action, item) {
		if (!item) { return; }
		if (window.parent && window.parent !== window) {
			window.parent.postMessage({
				type: action === 'add' ? 'add-item' : 'remove-item',
				item: {
					materialCode: item.materialCode,
					materialName: item.materialName,
					categoryName: item.categoryName,
					currentStock: item.currentStock,
					safeStock: item.safeStock,
					unit: item.unit,
					sourceType: item.sourceType || (item.isLowStock ? 'LOW_STOCK' : 'MANUAL')
				}
			}, '*');
		}
	}

	function closePopup() {
		if (window.parent && window.parent !== window) {
			window.parent.postMessage({ type: 'close-place-popup' }, '*');
		}
	}

	window.addEventListener('message', function(event) {
		if (!event.data || !event.data.type) return;
		if (event.data.type === 'sync-order-state') {
			applyParentState(event.data.data || {});
		}
	});

	categoryFilter.addEventListener('change', function() {
		selectedCategory = categoryFilter.value;
		selectedItemName = '전체';
		updateItemFilter();
		renderBothPanes();
	});

	itemFilter.addEventListener('change', function() {
		selectedItemName = itemFilter.value;
		renderBothPanes();
	});

	searchFilter.addEventListener('input', function() {
		searchText = (searchFilter.value || '').trim();
		renderBothPanes();
	});

    leftBody.addEventListener('click', handleAction);
    rightBody.addEventListener('click', handleAction);

    function handleAction(e) {
        var btn = e.target.closest('button[data-action]');
        var row = e.target.closest('tr');

        if (!btn && row) {
            var code = row.dataset.code;
            var item = findItemByCode(code);
            if (!item) return;

            item.isAdded = !item.isAdded;

            notifyParent(item.isAdded ? 'add' : 'remove', item);

            renderBothPanes();
            return;
        }

        if (!btn) return;

        var action = btn.dataset.action;
        var code = btn.dataset.code;
        var item = findItemByCode(code);

        if (!item) return;

        item.isAdded = (action === 'add');

        notifyParent(action, item);
		pendingParentState = null;
        
        renderBothPanes();
    }

	document.querySelectorAll('.close-x, .btn-close').forEach(function(element) {
		element.addEventListener('click', function(event) {
			event.preventDefault();
			closePopup();
		});
	});

	loadItems();
})();
</script>
</body>
</html>
