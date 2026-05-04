<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dto.AccountDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>레시피 조회 - ZERO LOSS 직영점 관리 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .sidebar-open .sidebar { transform: translateX(0); }
        .modal-hidden { display: none !important; visibility: hidden !important; opacity: 0 !important; pointer-events: none !important; }
    </style>
</head>
<body class="bg-gray-50">
<div class="min-h-screen">
    <div id="sidebarBackdrop" class="fixed inset-0 bg-black bg-opacity-50 z-20 hidden lg:hidden"></div>

    <aside id="sidebar" class="fixed top-0 left-0 h-full w-72 bg-white border-r border-gray-200 z-30 transform -translate-x-full transition-transform duration-200 lg:translate-x-0 overflow-y-auto">
        <%@ include file="/branch/common/layout/sidebar.jsp" %>
    </aside>

    <div class="lg:pl-72">
        <main class="p-6">
            <div class="space-y-6">
                <div class="flex justify-between items-start">
                    <div>
                        <h2 class="text-3xl font-bold text-gray-900">레시피 조회</h2>
                        <p class="text-gray-500 mt-2">매장에서 사용하는 레시피를 조회하고 숙지하세요</p>
                    </div>
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
        </div>
    </div>
</div>

<script>
    let mainCategories = [];
    let currentRecipes = [];
    let selectedCategoryName = '전체';
    let selectedSubCategoryCode = null;
    let activeFilter = 'all';
    let selectedRecipeForView = null;

    const ctx = '<%= request.getContextPath() %>';

    async function init() {
        try {
            await Promise.all([fetchMainCategories(), fetchRecipes()]);
        } catch (e) {
            console.error("초기화 중 오류 발생", e);
        }
    }

    async function fetchMainCategories() {
        const response = await fetch(ctx + '/RecipeManagementController?action=categories');
        mainCategories = await response.json();
        renderCategoryFilters();
    }

    async function fetchRecipes() {
        const response = await fetch(ctx + '/RecipeManagementController?action=list');
        currentRecipes = await response.json();
        applyFilters();
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
                    wholeCat ? `<button onclick="setSubCategory(null)" class="px-4 py-2 rounded-lg text-sm font-medium transition-colors \${selectedSubCategoryCode === null ? 'bg-[#00853D] text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">전체</button>` : '',
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
                     <div class="relative h-48"><img src="\${displayImage}" class="w-full h-full object-contain bg-white"  onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'"><div class="absolute top-2 right-2">\${statusBadge}</div><div class="absolute top-2 left-2"><span class="px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-700">\${recipe.category}</span></div></div>
                     <div class="p-4"><h3 class="font-semibold text-lg text-gray-900 mb-2">\${recipe.name}</h3><p class="text-sm text-gray-500 mb-3 line-clamp-2">\${recipe.description || '-'}</p>
                     <div class="flex items-center justify-between text-sm"><div><span class="text-gray-500">판매가</span><p class="font-semibold text-gray-900">₩\${recipe.price.toLocaleString()}</p></div><div><span class="text-gray-500">원가</span><p class="font-semibold text-orange-600">₩\${(recipe.cost || 0).toLocaleString()}</p></div></div>
                     </div></div>`;
         }).join('');
         document.getElementById('recipeGrid').innerHTML = html;
     }

    async function viewRecipe(recipeId) {
        try {
            const response = await fetch(ctx + `/RecipeManagementController?action=detail&id=\${recipeId}`);
            const r = await response.json();
            selectedRecipeForView = r;

            const statusBadge = r.isActive ? '<span class="px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-700">활성화</span>' : '<span class="px-3 py-1 rounded-full text-sm font-medium bg-gray-100 text-gray-700">비활성화</span>';

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
                    <div><h4 class="font-semibold text-gray-900 mb-3">필요 재료(BOM)</h4><div class="bg-gray-50 rounded-lg overflow-hidden"><table class="w-full"><thead class="bg-gray-100"><tr><th class="px-4 py-2 text-left text-xs font-semibold text-gray-700">재료명</th><th class="px-4 py-2 text-right text-xs font-semibold text-gray-700">수량</th></tr></thead><tbody>\${ingredientsList}</tbody></table></div></div>
                    <div><h4 class="font-semibold text-gray-900 mb-2">조리법</h4><p class="text-gray-700 whitespace-pre-line">\${r.instructions || '-'}</p></div>`;

            document.getElementById('viewModalContent').innerHTML = html;
            document.getElementById('viewModal').classList.remove('modal-hidden');
        } catch (e) { alert('상세조회 실패'); }
    }

    function closeModals() {
        document.getElementById('viewModal').classList.add('modal-hidden');
        selectedRecipeForView = null;
    }

    document.addEventListener('DOMContentLoaded', () => {
        const v = document.getElementById('viewModal');
        v.addEventListener('click', e => { if(e.target === v) closeModals(); });
        v.querySelector('.bg-white').addEventListener('click', e => e.stopPropagation());
    });

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' || e.keyCode === 27) {
            closeModals();
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

    function logout() {
        window.location.href = ctx + '/common/login.jsp';
    }

    init();
</script>

</body>
</html>
