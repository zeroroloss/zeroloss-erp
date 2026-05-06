<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>레시피 관리 - ZERO LOSS 본사 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
        .modal-hidden { display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; }
        .drag-over { border-color: #00853D; background-color: #F0FAF5; }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="/hq/common/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">
            <div class="flex justify-between items-start">
                <div>
                    <h2 class="text-3xl font-bold text-gray-900">레시피 관리</h2>
                    <p class="text-gray-500 mt-2">메뉴 레시피를 등록하고 관리하세요</p>
                </div>
                <button onclick="openCreateModal()" class="px-6 py-3 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] transition-colors flex items-center gap-2 font-medium whitespace-nowrap">
                    <i class="fas fa-plus w-4 h-4"></i> 신규 레시피 등록
                </button>
            </div>

            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="space-y-4">
                    <div class="flex flex-col lg:flex-row gap-6">
                        <div class="flex-1">
                            <label class="text-sm font-medium text-gray-700 mb-2 block">카테고리</label>
                            <div id="categoryFilters" class="flex flex-wrap gap-2"></div>
                        </div>

                        <div id="subCategorySection" class="hidden flex-1">
                            <label class="text-sm font-medium text-gray-700 mb-2 block">서브 카테고리</label>
                            <div id="subCategoryFilters" class="flex flex-wrap gap-2"></div>
                        </div>
                    </div>

                    <div class="flex flex-col sm:flex-row gap-4">
                        <div class="flex-1 relative">
                            <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400"></i>
                            <input type="text" id="searchInput" placeholder="레시피명 검색..." onkeyup="handleSearchKeyup(event)" class="w-full pl-10 pr-12 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] focus:border-transparent text-sm">
                            <button onclick="applyFilters()" class="absolute right-2 top-1/2 transform -translate-y-1/2 p-2 text-gray-400 hover:text-[#00853D] transition-colors">
                                <i class="fas fa-search w-4 h-4"></i>
                            </button>
                        </div>
                        <div class="flex gap-2">
                            <button onclick="setActiveFilter('all')" id="filterAll" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors bg-gray-900 text-white">전체</button>
                            <button onclick="setActiveFilter('active')" id="filterActive" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors bg-gray-100 text-gray-700 hover:bg-gray-200">활성화</button>
                            <button onclick="setActiveFilter('inactive')" id="filterInactive" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors bg-gray-100 text-gray-700 hover:bg-gray-200">비활성화</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="recipeGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6"></div>

            <div id="emptyState" class="bg-white rounded-lg border border-gray-200 p-12 text-center hidden">
                <i class="fas fa-book w-16 h-16 text-gray-300 mx-auto mb-4"></i>
                <p class="text-gray-500 text-lg mb-2">검색 결과가 없습니다</p>
                <p class="text-gray-400 text-sm">다른 검색어나 필터를 시도해보세요</p>
            </div>
        </div>
    </main>
</div>

<div id="viewModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4 modal-hidden">
    <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <h3 class="text-xl font-bold text-gray-900">레시피 상세</h3>
            <button onclick="closeModals()" class="text-gray-400 hover:text-gray-600 text-2xl" title="닫기"><i class="fas fa-times"></i></button>
        </div>
        <div id="viewModalContent" class="p-6 space-y-6"></div>
        <div class="sticky bottom-0 bg-white border-t border-gray-200 px-6 py-4 flex gap-3 justify-end">
            <button onclick="closeModals()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">닫기</button>
            <button onclick="openEditModal()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F]"><i class="fas fa-edit"></i> 수정</button>
            <button onclick="deleteRecipeFromView()" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"><i class="fas fa-trash"></i> 삭제</button>
        </div>
    </div>
</div>

<div id="formModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4 modal-hidden">
    <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <h3 id="formModalTitle" class="text-xl font-bold text-gray-900">신규 레시피 등록</h3>
            <button onclick="closeFormModal()" class="text-gray-400 hover:text-gray-600 text-2xl" title="닫기"><i class="fas fa-times"></i></button>
        </div>

        <div class="p-6 space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="md:col-span-1">
                    <label class="block text-sm font-medium text-gray-700 mb-2">레시피 이미지</label>
                    <div id="imageUploadArea" class="w-full h-48 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300 flex items-center justify-center text-center cursor-pointer hover:border-green-500 transition">
                        <div id="imagePreview">
                            <i class="fas fa-image text-4xl text-gray-400"></i>
                            <p class="mt-2 text-sm text-gray-600">드래그 앤 드롭 또는 클릭</p>
                        </div>
                    </div>
                    <input type="file" id="imageUploadInput" class="hidden" accept="image/png, image/jpeg">
                    <button id="removeImageBtn" onclick="removeImage()" class="hidden text-xs text-red-500 hover:text-red-700 mt-2">이미지 삭제</button>
                </div>

                <div class="md:col-span-2 space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">레시피명</label>
                        <input type="text" id="formRecipeName" placeholder="예: 안창 비프" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none text-sm">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">메인 카테고리</label>
                            <select id="formMainCategory" onchange="handleMainCategoryChange()" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none text-sm">
                                <option value="">선택</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">서브 카테고리</label>
                            <select id="formSubCategory" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none text-sm" disabled>
                                <option value="">메인을 먼저 선택</option>
                            </select>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">판매가 (원)</label>
                            <input type="number" id="formPrice" placeholder="0" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none text-sm">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">원가 (원)</label>
                            <input type="number" id="formCost" placeholder="0" readonly class="w-full px-3 py-2 border-gray-200 bg-gray-100 rounded-lg text-sm text-gray-500">
                        </div>
                    </div>
                </div>
            </div>

            <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">조리법 및 설명</label>
                <textarea id="formInstructions" placeholder="예: 1. 빵을 데웁니다.&#10;2. 재료를 올립니다." rows="3" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#00853D] outline-none text-sm"></textarea>
            </div>

            <div class="border-t border-gray-200 pt-4">
                <div class="flex justify-between items-center mb-2">
                    <label class="block text-sm font-medium text-gray-700">필요 재료 (BOM) 구성</label>
                    <button type="button" onclick="addIngredientRow()" class="text-xs bg-blue-50 text-blue-600 px-3 py-1 rounded-lg hover:bg-blue-100 border border-blue-200">
                        <i class="fas fa-plus mr-1"></i> 재료 추가
                    </button>
                </div>
                <div id="ingredientRowsContainer" class="space-y-2 bg-gray-50 p-3 rounded-lg border border-gray-100 max-h-48 overflow-y-auto">
                </div>
            </div>

            <div>
                <label class="flex items-center gap-2 text-sm mt-2">
                    <input type="checkbox" id="formIsActive" checked class="rounded border-gray-300 text-[#00853D] focus:ring-[#00853D]">
                    <span class="text-gray-700">활성화 (매장 노출)</span>
                </label>
            </div>
        </div>

        <div class="sticky bottom-0 bg-white border-t border-gray-200 px-6 py-4 flex gap-3 justify-end">
            <button onclick="closeFormModal()" class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">취소</button>
            <button onclick="saveRecipe()" class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F]">저장</button>
        </div>
    </div>
</div>

<script>
    let mainCategories = [];
    let materialList = [];
    let currentRecipes = [];
    let formIngredients = [];
    let selectedImageFile = null;

    let selectedCategoryName = '전체';
    let selectedSubCategoryCode = null;
    let activeFilter = 'all';
    let selectedRecipeForView = null;
    let selectedRecipeForEdit = null;

    // 프로젝트 Context Path
    const ctx = '<%= request.getContextPath() %>';

    async function init() {
        try {
            await Promise.all([fetchMainCategories(), fetchMaterials(), fetchRecipes()]);
            setupDragAndDrop();
        } catch (e) {
            console.error("초기화 중 오류 발생", e);
        }
    }

    async function fetchMainCategories() {
        const response = await fetch(ctx + '/RecipeManagementController?action=categories');
        mainCategories = await response.json();
        renderCategoryFilters();
        let html = '<option value="">메인 카테고리 선택</option>';
        mainCategories.forEach(cat => {
            html += `<option value="\${cat.categoryId}">\${cat.name}</option>`;
        });
        document.getElementById('formMainCategory').innerHTML = html;
    }

    async function handleMainCategoryChange() {
        const mainCategoryId = document.getElementById('formMainCategory').value;
        const subSelect = document.getElementById('formSubCategory');
        if (!mainCategoryId) {
            subSelect.innerHTML = '<option value="">메인을 먼저 선택하세요</option>';
            subSelect.disabled = true;
            return;
        }
        const response = await fetch(ctx + `/RecipeManagementController?action=subcategories&mainCategoryId=\${mainCategoryId}`);
        const subCats = await response.json();

        // 전체 제외
        const filtered = subCats.filter(sub => sub.name !== '전체');
        let html = '<option value="">서브 카테고리 선택</option>';
        filtered.forEach(sub => {
            html += '<option value="' + sub.subCategoryCode + '">' + sub.name + '</option>';
        });
        subSelect.innerHTML = html;
        subSelect.disabled = false;
    }

    async function fetchMaterials() {
        const response = await fetch(ctx + '/RecipeManagementController?action=materials');
        materialList = await response.json();
    }

    async function fetchRecipes() {
        const response = await fetch(ctx + '/RecipeManagementController?action=list');
        currentRecipes = await response.json();
        applyFilters();
    }

    function updateTotalCost() {
        const totalCost = formIngredients.reduce((sum, ing) => {
            const material = materialList.find(m => String(m.materialCode) === String(ing.materialCode));
            const quantity = parseFloat(ing.quantity) || 0;
            const cost = material ? parseFloat(material.materialPrice) : 0;
            return sum + (quantity * cost);
        }, 0);
        document.getElementById('formCost').value = Math.round(totalCost);
    }

    function addIngredientRow() {
        formIngredients.push({ materialCode: '', quantity: '' });
        renderIngredientRows();
        updateTotalCost();
    }

    function removeIngredientRow(index) {
        formIngredients.splice(index, 1);
        renderIngredientRows();
        updateTotalCost();
    }

    function updateIngredient(index, field, value) {
        formIngredients[index][field] = value;
        if (field === 'materialCode') {
            renderIngredientRows();
        }
        updateTotalCost();
    }

    function renderIngredientRows() {
        const container = document.getElementById('ingredientRowsContainer');
        if (formIngredients.length === 0) {
            container.innerHTML = '<p class="text-sm text-gray-400 text-center py-2">추가된 재료가 없습니다.</p>';
            return;
        }

        container.innerHTML = formIngredients.map((ing, i) => {
            const selectedMaterial = materialList.find(m => String(m.materialCode) === String(ing.materialCode));
            const unit = selectedMaterial ? selectedMaterial.unit : '-';

            // 💡 에러의 원인이었던 '백틱 안의 백틱' 중첩을 피하기 위해,
            // 옵션 목록(optionsHtml)을 일반 문자열 덧셈(+)으로 먼저 안전하게 조립합니다.
            let optionsHtml = '<option value="">재료 선택</option>';
            materialList.forEach(m => {
                const price = m.materialPrice !== null && m.materialPrice !== undefined ? m.materialPrice : 0;
                const isSelected = String(m.materialCode) === String(ing.materialCode) ? 'selected' : '';
                optionsHtml += '<option value="' + m.materialCode + '" ' + isSelected + '>' + m.materialName + ' (' + price.toLocaleString() + '원/' + m.unit + ')</option>';
            });

            // 조립된 optionsHtml 변수를 템플릿에 꽂아 넣습니다.
            return `
            <div class="flex items-center gap-2 bg-white p-2 rounded border border-gray-200 shadow-sm">
                <select onchange="updateIngredient(\${i}, 'materialCode', this.value)" class="flex-1 px-2 py-1 text-sm border border-gray-300 rounded outline-none">
                    \${optionsHtml}
                </select>
                <input type="number" step="0.1" value="\${ing.quantity}" oninput="updateIngredient(\${i}, 'quantity', this.value)" placeholder="투입량" class="w-24 px-2 py-1 text-sm border border-gray-300 rounded text-right outline-none">
                <span class="text-sm text-gray-500 w-8 text-center">\${unit}</span>
                <button type="button" onclick="removeIngredientRow(\${i})" class="text-gray-400 hover:text-red-500 px-2"><i class="fas fa-minus-circle"></i></button>
            </div>`;
        }).join('');
    }

    function renderCategoryFilters() {
        const allCats = ['전체', ...mainCategories.map(c => c.name)];
        const html = allCats.map(cat => {
            const isSelected = selectedCategoryName === cat;
            const btnClass = isSelected ? 'bg-[#00853D] text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200';
            return `<button onclick="setCategory('\${cat}')" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors \${btnClass}">\${cat}</button>`;
        }).join('');
        document.getElementById('categoryFilters').innerHTML = html;
    }

    function setCategory(catName) {
        selectedCategoryName = catName;
        selectedSubCategoryCode = null;
        renderCategoryFilters();
        renderSubCategoryFilters();
        applyFilters();
    }

    function renderSubCategoryFilters() {
        const subCategorySection = document.getElementById('subCategorySection');
        const subCategoryFilters = document.getElementById('subCategoryFilters');

        if (selectedCategoryName === '전체') {
            subCategorySection.classList.add('hidden');
            subCategoryFilters.innerHTML = '';
            return;
        }

        const selectedCat = mainCategories.find(c => c.name === selectedCategoryName);
        if (!selectedCat) {
            subCategorySection.classList.add('hidden');
            return;
        }

        fetch(ctx + `/RecipeManagementController?action=subcategories&mainCategoryId=\${selectedCat.categoryId}`)
            .then(res => res.json())
            .then(subCats => {
                if (subCats.length === 0) {
                    subCategorySection.classList.add('hidden');
                    return;
                }

                subCategorySection.classList.remove('hidden');
                const wholeCat = subCats.find(cat => cat.name === '전체');
                const otherCats = subCats.filter(cat => cat.name !== '전체');

                const subHtml = [
                    wholeCat ? `<button onclick="setSubCategory(null)" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors \${
                        selectedSubCategoryCode === null ? 'bg-[#00853D] text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                    }">전체</button>` : '',
                    ...otherCats.map(sub => {
                        const isSelected = selectedSubCategoryCode === sub.subCategoryCode;
                        const btnClass = isSelected ? 'bg-[#00853D] text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200';
                        return `<button onclick="setSubCategory('\${sub.subCategoryCode}')" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors \${btnClass}">\${sub.name}</button>`;
                    })
                ].filter(html => html !== '').join('');
                subCategoryFilters.innerHTML = subHtml;
            })
            .catch(err => console.error('서브카테고리 로드 실패:', err));
    }

    function setSubCategory(subCode) {
        selectedSubCategoryCode = subCode;
        renderSubCategoryFilters();
        applyFilters();
    }

    function setActiveFilter(filter) {
        activeFilter = filter;
        ['filterAll', 'filterActive', 'filterInactive'].forEach(id => {
            document.getElementById(id).className = "px-4 py-2 rounded-lg text-sm font-medium transition-colors bg-gray-100 text-gray-700 hover:bg-gray-200";
        });
        if (filter === 'all') document.getElementById('filterAll').classList.add('bg-gray-900', 'text-white');
        else if (filter === 'active') document.getElementById('filterActive').classList.add('bg-green-600', 'text-white');
        else document.getElementById('filterInactive').classList.add('bg-orange-600', 'text-white');
        applyFilters();
    }

    function applyFilters() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const filtered = currentRecipes.filter(recipe => {
            const matchesCategory = selectedCategoryName === '전체' || recipe.category === selectedCategoryName;
            const matchesSubCategory = selectedSubCategoryCode === null || recipe.subCategoryCode === selectedSubCategoryCode;
            const matchesSearch = recipe.name.toLowerCase().includes(searchTerm);
            const matchesActive = activeFilter === 'all' || (activeFilter === 'active' && recipe.isActive) || (activeFilter === 'inactive' && !recipe.isActive);
            return matchesCategory && matchesSubCategory && matchesSearch && matchesActive;
        });
        renderRecipesList(filtered);
    }

    function handleSearchKeyup(event) {
        if (event.key === 'Enter') {
            applyFilters();
        }
    }

    function renderRecipesList(list) {
        if (list.length === 0) {
            document.getElementById('recipeGrid').innerHTML = '';
            document.getElementById('emptyState').classList.remove('hidden');
            return;
        }
        document.getElementById('emptyState').classList.add('hidden');
        const html = list.map(recipe => {
            const statusBadge = recipe.isActive ? '<span class="px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-700">활성화</span>' : '<span class="px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-700">비활성화</span>';
            let displayImage = 'https://via.placeholder.com/400x300?text=No+Image';
            if (recipe.image && recipe.image !== '-' && recipe.image.trim() !== '') {
                displayImage = ctx + '/' + recipe.image;
            }

            return `
                 <div class="bg-white rounded-lg border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow cursor-pointer" onclick="viewRecipe('\${recipe.id}')">
                     <div class="relative h-48">
                         <img src="\${displayImage}" class="w-full h-full object-contain bg-white" onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
                         <div class="absolute top-2 right-2">\${statusBadge}</div>
                         <div class="absolute top-2 left-2"><span class="px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700">\${recipe.category}</span></div>
                     </div>
                     <div class="p-4">
                         <h3 class="font-semibold text-lg text-gray-900 mb-2">\${recipe.name}</h3>
                         <p class="text-sm text-gray-500 mb-3 line-clamp-2">\${recipe.description || '-'}</p>
                         <div class="flex items-center justify-between text-sm">
                             <div>
                                 <span class="text-gray-500">판매가</span>
                                 <p class="font-semibold text-gray-900">₩\${recipe.price.toLocaleString()}</p>
                             </div>
                             <div>
                                 <span class="text-gray-500">원가</span>
                                 <p class="font-semibold text-orange-600">₩\${(recipe.cost || 0).toLocaleString()}</p>
                             </div>
                         </div>
                     </div>
                 </div>`;
        }).join('');
        document.getElementById('recipeGrid').innerHTML = html;
    }

    async function viewRecipe(recipeId) {
        try {
            const response = await fetch(ctx + `/RecipeManagementController?action=detail&id=\${recipeId}`);
            const r = await response.json();
            selectedRecipeForView = r;

            const statusBadge = r.isActive ?
                '<span class="px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-700">활성화</span>' : '<span class="px-3 py-1 rounded-full text-sm font-medium bg-gray-100 text-gray-700">비활성화</span>';

            let ingredientsList = '<tr><td colspan="2" class="px-4 py-3 text-center text-gray-500">등록된 재료가 없습니다.</td></tr>';
            if(r.ingredients && r.ingredients.length > 0) {
                ingredientsList = r.ingredients.map(ing => `<tr class="border-b border-gray-200 hover:bg-gray-50"><td class="px-4 py-3 text-sm text-gray-900">\${ing.name}</td><td class="px-4 py-3 text-sm text-gray-600 text-right">\${ing.quantity} \${ing.unit}</td></tr>`).join('');
            }

            let modalImg = 'https://via.placeholder.com/600x400?text=No+Image';
            if (r.image && r.image !== '-' && r.image.trim() !== '') {
                modalImg = ctx + '/' + r.image;
            }

            const html = `
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div><img src="\${modalImg}" class="w-full h-64 object-cover rounded-lg" onerror="this.src='https://via.placeholder.com/600x400?text=No+Image'"></div>
                        <div class="space-y-4">
                            <div><span class="text-sm text-gray-500">레시피명</span><p class="text-2xl font-bold text-gray-900">\${r.name}</p></div>
                            <div><span class="text-sm text-gray-500">카테고리</span><p class="text-lg text-gray-900">\${r.category} > \${r.subCategoryName || 'N/A'}</p></div>
                            <div class="flex items-center gap-2"><span class="text-sm text-gray-500">상태</span>\${statusBadge}</div>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-blue-50 rounded-lg p-4"><p class="text-sm text-blue-600 mb-1">판매가</p><p class="text-2xl font-bold text-blue-700">₩\${r.price.toLocaleString()}</p></div>
                        <div class="bg-orange-50 rounded-lg p-4"><p class="text-sm text-orange-600 mb-1">원가</p><p class="text-2xl font-bold text-orange-700">₩\${(r.cost||0).toLocaleString()}</p></div>
                    </div>
                    <div>
                        <h4 class="font-semibold text-gray-900 mb-3">필요 재료(BOM)</h4>
                        <div class="bg-gray-50 rounded-lg overflow-hidden">
                            <table class="w-full">
                                <thead class="bg-gray-100">
                                    <tr>
                                        <th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">재료명</th>
                                        <th class="px-4 py-2 text-right text-xs font-semibold text-gray-700">수량</th>
                                    </tr>
                                </thead>
                                <tbody>\${ingredientsList}</tbody>
                            </table>
                        </div>
                    </div>
                    <div><h4 class="font-semibold text-gray-900 mb-2">조리법</h4><p class="text-gray-700 whitespace-pre-line">\${r.instructions || '-'}</p></div>`;

            document.getElementById('viewModalContent').innerHTML = html;
            document.getElementById('viewModal').classList.remove('modal-hidden');
        } catch (e) {
            alert('상세조회 실패');
        }
    }

    function clearFormFields() {
        document.getElementById('formRecipeName').value = '';
        document.getElementById('formMainCategory').value = '';
        document.getElementById('formSubCategory').value = '';
        document.getElementById('formSubCategory').disabled = true;
        document.getElementById('formPrice').value = '';
        document.getElementById('formCost').value = '0';
        document.getElementById('formInstructions').value = '';
        document.getElementById('formIsActive').checked = true;
        formIngredients = [];
        renderIngredientRows();
        removeImage();
    }

    function openCreateModal() {
        selectedRecipeForEdit = null;
        clearFormFields();
        document.getElementById('formModalTitle').innerText = '신규 레시피 등록';
        document.getElementById('formModal').classList.remove('modal-hidden');
    }

    async function openEditModal() {
        if (!selectedRecipeForView) return;
        selectedRecipeForEdit = selectedRecipeForView;
        const r = selectedRecipeForEdit;

        clearFormFields();

        document.getElementById('formRecipeName').value = r.name;
        document.getElementById('formPrice').value = r.price;
        document.getElementById('formInstructions').value = r.instructions;
        document.getElementById('formIsActive').checked = r.isActive;
        document.getElementById('formMainCategory').value = r.categoryId;

        await handleMainCategoryChange();
        if(r.subCategoryCode) document.getElementById('formSubCategory').value = r.subCategoryCode;

        formIngredients = r.ingredients && r.ingredients.length > 0 ?
            r.ingredients.map(i => ({materialCode: i.materialCode, quantity: i.quantity})) : [];
        renderIngredientRows();
        updateTotalCost();

        if (r.image && r.image !== '-' && r.image.trim() !== '') {
            const imageUrl = ctx + '/' + r.image;
            setImagePreview(imageUrl);
        }

        document.getElementById('formModalTitle').innerText = '레시피 수정';
        closeModals();
        document.getElementById('formModal').classList.remove('modal-hidden');
    }

    async function saveRecipe() {
        const formData = new FormData();
        if (selectedRecipeForEdit) {
            formData.append('id', selectedRecipeForEdit.id);
        }
        formData.append('name', document.getElementById('formRecipeName').value.trim());
        formData.append('categoryId', document.getElementById('formMainCategory').value);
        formData.append('subCategoryCode', document.getElementById('formSubCategory').value);
        formData.append('price', document.getElementById('formPrice').value || 0);
        formData.append('instructions', document.getElementById('formInstructions').value.trim());
        formData.append('isActive', document.getElementById('formIsActive').checked);

        const categorySelect = document.getElementById('formMainCategory');
        const categoryName = categorySelect.options[categorySelect.selectedIndex].text;
        formData.append("categoryName", categoryName);

        const validIngredients = formIngredients.filter(ing => ing.materialCode && ing.quantity);
        formData.append('ingredients', JSON.stringify(validIngredients));

        if (selectedImageFile) {
            formData.append('image', selectedImageFile);
        }

        if (!formData.get('name') || !formData.get('categoryId') || !formData.get('subCategoryCode') || !formData.get('price')) {
            alert('이름, 메인/서브 카테고리, 판매가는 필수입니다.');
            return;
        }

        try {
            const res = await fetch(ctx + '/RecipeManagementController?action=save', {
                method: 'POST',
                body: formData
            });
            const result = await res.json();
            if (result.success) {
                alert('저장되었습니다.');
                closeFormModal();
                fetchRecipes();
            } else {
                alert('저장 실패: ' + (result.message || '알 수 없는 오류'));
            }
        } catch (e) {
            console.error(e);
            alert('서버 통신 오류');
        }
    }

    async function deleteRecipeFromView() {
        if (!confirm('정말로 이 레시피를 삭제하시겠습니까?')) return;
        try {
            const response = await fetch(ctx + `/RecipeManagementController?action=delete&id=\${selectedRecipeForView.id}`, {
                method: 'POST'
            });
            const result = await response.json();

            if (result.success) {
                alert('레시피가 성공적으로 삭제되었습니다.');
                closeModals();
                fetchRecipes();
            } else {
                alert(result.message || '레시피 삭제에 실패했습니다.');
            }
        } catch (error) {
            console.error('삭제 중 오류 발생:', error);
            alert('레시피 삭제 중 오류가 발생했습니다. 네트워크 연결을 확인해주세요.');
        }
    }

    // Image Upload Functions
    function setupDragAndDrop() {
        const dropArea = document.getElementById('imageUploadArea');
        const fileInput = document.getElementById('imageUploadInput');

        dropArea.addEventListener('click', () => fileInput.click());

        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, () => dropArea.classList.add('drag-over'), false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, () => dropArea.classList.remove('drag-over'), false);
        });

        dropArea.addEventListener('drop', handleDrop, false);
        fileInput.addEventListener('change', (e) => handleFiles(e.target.files));
    }

    function handleDrop(e) {
        let dt = e.dataTransfer;
        let files = dt.files;
        handleFiles(files);
    }

    function handleFiles(files) {
        if (files.length > 0) {
            const file = files[0];
            if (file.type.startsWith('image/')) {
                selectedImageFile = file;
                const reader = new FileReader();
                reader.onload = (e) => {
                    setImagePreview(e.target.result);
                };
                reader.readAsDataURL(file);
            } else {
                alert('이미지 파일(jpg, png)만 업로드 가능합니다.');
            }
        }
    }

    function setImagePreview(src) {
        const preview = document.getElementById('imagePreview');
        preview.innerHTML = `<img src="\${src}" class="w-full h-full object-contain">`;
        document.getElementById('removeImageBtn').classList.remove('hidden');
    }

    function removeImage() {
        selectedImageFile = null;
        const preview = document.getElementById('imagePreview');
        preview.innerHTML = `<i class="fas fa-image text-4xl text-gray-400"></i><p class="mt-2 text-sm text-gray-600">드래그 앤 드롭 또는 클릭</p>`;
        document.getElementById('imageUploadInput').value = '';
        document.getElementById('removeImageBtn').classList.add('hidden');
    }

    function closeModals() {
        document.getElementById('viewModal').classList.add('modal-hidden');
        selectedRecipeForView = null;
    }

    function closeFormModal() {
        document.getElementById('formModal').classList.add('modal-hidden');
        selectedRecipeForEdit = null;
        clearFormFields();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const v = document.getElementById('viewModal');
        const f = document.getElementById('formModal');
        v.addEventListener('click', e => { if(e.target === v) closeModals(); });
        v.querySelector('.bg-white').addEventListener('click', e => e.stopPropagation());
        f.addEventListener('click', e => { if(e.target === f) closeFormModal(); });
        f.querySelector('.bg-white').addEventListener('click', e => e.stopPropagation());
    });

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' || e.keyCode === 27) {
            closeModals();
            closeFormModal();
        }
    });

    document.getElementById('sidebarBackdrop').addEventListener('click', () => {
        document.getElementById('sidebar').classList.add('-translate-x-full');
        document.getElementById('sidebarBackdrop').classList.add('hidden');
    });

    function toggleSidebar() {
        const s = document.getElementById('sidebar');
        const b = document.getElementById('sidebarBackdrop');
        if(s.classList.contains('-translate-x-full')){
            s.classList.remove('-translate-x-full');
            b.classList.remove('hidden');
        } else {
            s.classList.add('-translate-x-full');
            b.classList.add('hidden');
        }
    }

    function toggleMenu(element) {
        const submenu = element.nextElementSibling;
        if (submenu && submenu.classList.contains('submenu')) {
            submenu.classList.toggle('hidden');
            const icon = element.querySelector('i.fa-chevron-right, i.fa-chevron-down');
            if (icon) {
                icon.classList.toggle('fa-chevron-right');
                icon.classList.toggle('fa-chevron-down');
            }
        }
    }

    function logout() {
        window.location.href = ctx + '/common/login.jsp';
    }

    init();
</script>

</body>
</html>