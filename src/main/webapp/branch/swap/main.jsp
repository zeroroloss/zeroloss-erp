<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>재고 교환/요청</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=b3f3ddf0ffba921a86ad77da212f65bb&libraries=services"></script>

    <style>
        :root { --line: #d1d5db; --bg: #f3f4f6; --text: #111827; --muted: #6b7280; --blue: #2563eb; --green: #16a34a; --purple: #9333ea; --orange: #f97316; }
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: var(--bg); color: var(--text); }
        .wrap { width: 100%; max-width: none; margin: 0; padding: 24px; }
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; gap: 24px; margin-bottom: 24px; }
        .head { flex-shrink: 0; }
        .head h1 { font-size: 1.875rem; line-height: 2.25rem; font-weight: 700; margin: 0; }
        .head p { color: #6b7280; margin: 4px 0 0; }
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; flex-grow: 1; max-width: 720px; }
        .stat { background: #fff; border: 1px solid var(--line); border-radius: 14px; padding: 14px 16px; display: flex; align-items: center; gap: 12px; transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .stat:hover { transform: translateY(-3px); box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .stat .n { font-size: 1.375rem; font-weight: 700; line-height: 1; color: var(--text); }
        .stat .l { font-size: 0.875rem; color: var(--muted); margin-top: 3px; }
        .stat-ico { width: 36px; height: 36px; border-radius: 10px; display: grid; place-items: center; flex-shrink: 0; font-size: 16px; }
        .s1 { background: #e0e7ff; color: #3730a3; }
        .s2 { background: #dcfce7; color: #166534; }
        .s3 { background: #f3e8ff; color: #6b21a8; }
        .s4 { background: #ffedd5; color: #9a3412; }
        .stat-text { display: flex; flex-direction: column; min-width: 0; }
        .tabs { display: flex; gap: 0; border-bottom: 2px solid var(--line); margin-top: 24px; }
        .tab { height: auto; border: none; border-bottom: 3px solid transparent; border-radius: 0; background: transparent; color: var(--muted); font-size: 1rem; font-weight: 700; padding: 10px 20px; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; transition: color .2s ease, border-color .2s ease; margin-bottom: -2px; }
        .tab:hover { color: var(--text); }
        .tab.active { color: var(--green); border-color: var(--green); background: transparent; }
        .tab .badge { background: #e5e7eb; color: #374151; border-radius: 999px; padding: 2px 8px; font-size: 12px; font-weight: 700; }
        .tab.active .badge { background: var(--green); color: #fff; }
        .panel { margin-top: 18px; background: #fff; border: 1px solid var(--line); border-radius: 18px; overflow: hidden; box-shadow: 0 1px 2px rgba(15,23,42,0.05); }
        .panel-head { padding: 18px 20px; border-bottom: 1px solid #e5e7eb; }
        .panel-title { font-size: 1.25rem; font-weight: 700; margin: 0; }
        .form { padding: 18px 20px; display: grid; grid-template-columns: 1.2fr 1.2fr 1fr 1fr; gap: 12px; align-items: end; }
        .label { font-size: 0.875rem; font-weight: 700; color: #374151; display: block; margin-bottom: 6px; }
        .req { color: #ef4444; }
        .input { width: 100%; height: 38px; border: 1px solid #cfd6dd; border-radius: 12px; padding: 0 13px; font-size: 0.8125rem; background: #fff; color: #111827; }
        .split { display: grid; grid-template-columns: 1fr 64px; gap: 8px; }
        .unit { height: 38px; border-radius: 12px; background: #f3f4f6; color: #6b7280; display: grid; place-items: center; font-size: 0.8125rem; font-weight: 700; border: 1px solid #e5e7eb; }
        .actions { grid-column: 1 / -1; display: flex; justify-content: flex-end; margin-top: 8px; }
        .search-btn { height: 38px; padding: 0 18px; border: none; border-radius: 12px; background: var(--green); color: #fff; font-size: 0.875rem; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; gap: 8px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 18px; border-bottom: 1px solid #e5e7eb; font-size: 0.9375rem; text-align: left; }
        th { background: #f9fafb; color: #6b7280; font-weight: 700; }
        .ask { background: #2563eb; color: #fff; border: none; border-radius: 10px; padding: 8px 12px; font-size: 0.8125rem; font-weight: 700; cursor: pointer; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .no-result { padding: 40px 20px; text-align: center; color: var(--muted); }
        #map { height: 320px; }
    </style>
    <%@ include file="/branch/common/layout/layout_head.jsp" %>
</head>
<body>
<div class="zl-app">
    <%@ include file="/branch/common/layout/sidebar.jsp" %>
    <div class="zl-content">
        <%@ include file="/branch/common/layout/topbar.jsp" %>
        <div class="wrap p-6">
            <div class="page-header">
                <header class="head">
                    <h1 class="title">재고 교환/요청</h1>
                    <p class="sub">지점 간 재고를 교환하고 요청을 관리하세요</p>
                </header>
                <section class="stats">
                    <article class="stat"><div class="stat-ico s1" aria-hidden="true"><i class="fa-solid fa-paper-plane"></i></div><div class="stat-text"><span class="n">1건</span><div class="l">보낸 요청</div></div></article>
                    <article class="stat"><div class="stat-ico s2" aria-hidden="true"><i class="fa-solid fa-inbox"></i></div><div class="stat-text"><span class="n">2건</span><div class="l">받은 요청</div></div></article>
                    <article class="stat"><div class="stat-ico s3" aria-hidden="true"><i class="fa-solid fa-clock-rotate-left"></i></div><div class="stat-text"><span class="n">3건</span><div class="l">교환 내역</div></div></article>
                    <article class="stat"><div class="stat-ico s4" aria-hidden="true"><i class="fa-solid fa-map-marker-alt"></i></div><div class="stat-text"><span class="n">5개</span><div class="l">주변 지점</div></div></article>
                </section>
            </div>

            <nav class="tabs" aria-label="재고교환 탭">
                <a class="tab active" data-tab="check_stock"><i class="fa-solid fa-search"></i> 재고 조회 및 요청</a>
                <a class="tab" data-tab="send_request"><i class="fa-solid fa-paper-plane"></i> 보낸 요청 <span class="badge">1</span></a>
                <a class="tab" data-tab="received_request"><i class="fa-solid fa-inbox"></i> 받은 요청 <span class="badge">2</span></a>
                <a class="tab" data-tab="swap_history"><i class="fa-solid fa-history"></i> 교환 내역</a>
            </nav>

            <div id="tab-content-check_stock" class="tab-content active">
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">주변 지점 재고 조회</h2></div>
                    <form class="form" id="searchForm">
                        <div>
                            <label class="label" for="materialGroup">재료 그룹 <span class="req">*</span></label>
                            <select class="input" id="materialGroup" name="materialGroup" required>
                                <option value="">그룹 선택</option>
                            </select>
                        </div>
                        <div>
                            <label class="label" for="item">필요한 품목 <span class="req">*</span></label>
                            <select class="input" id="item" name="item" required disabled>
                                <option value="">재료 그룹을 먼저 선택하세요</option>
                            </select>
                        </div>
                        <div>
                            <label class="label" for="qty">필요 수량 <span class="req">*</span></label>
                            <div class="split">
                                <input class="input" id="qty" name="qty" type="number" min="1" placeholder="수량" required>
                                <div class="unit">개</div>
                            </div>
                        </div>

                        <!-- 🟢 누락되었던 최대 거리 입력 박스 복구! -->
                        <div>
                            <label class="label" for="dist">최대 거리 (km)</label>
                            <input class="input" id="dist" name="dist" type="number" min="1" value="10">
                        </div>

                        <div class="actions">
                            <button class="search-btn" type="submit"><i class="fa-solid fa-search"></i> 재고 조회</button>
                        </div>
                    </form>
                </section>
                <div id="check_stock_result" style="display:none;">
                    <section class="map-box"><div class="map-head" id="map-head"></div><div id="map"></div></section>
                    <section class="table-box"><div class="tb-head" id="table-head"></div><table id="result-table"><thead><tr><th>지점명</th><th>주소</th><th>거리(km)</th><th>보유수량</th><th style="text-align:center;">액션</th></tr></thead><tbody></tbody></table></section>
                </div>
            </div>
            <!-- 다른 탭 콘텐츠 생략 -->
        </div>
    </div>
</div>
<script>
    // 🟢 1. 최상단에 컨텍스트 경로를 안전하게 자바스크립트 변수로 선언!
    const CTX = "<%= request.getContextPath() %>";

    document.addEventListener('DOMContentLoaded', function () {
        const materialGroupSelect = document.getElementById('materialGroup');
        const itemSelect = document.getElementById('item');
        const searchForm = document.getElementById('searchForm');
        const checkStockResult = document.getElementById('check_stock_result');
        const resultTableBody = document.querySelector('#result-table tbody');
        const mapHead = document.getElementById('map-head');
        const tableHead = document.getElementById('table-head');
        let map;
        let markers = [];

        // 재료 그룹 불러오기
        function loadMaterialGroups() {
            fetch(CTX + "/branch/swap?action=getMaterialGroups")
                .then(response => response.json())
                .then(data => {
                    materialGroupSelect.innerHTML = '<option value="">그룹 선택</option>';
                    data.forEach(group => {
                        const option = document.createElement('option');
                        option.value = group.materialGroupId;
                        option.textContent = group.groupName;
                        materialGroupSelect.appendChild(option);
                    });
                })
                .catch(error => console.error('재료 그룹 로딩 실패:', error));
        }

        // 재료 그룹 선택 시 품목(item) 불러오기
        materialGroupSelect.addEventListener('change', function() {
            const groupId = this.value;
            itemSelect.innerHTML = '<option value="">재료 선택</option>';
            itemSelect.disabled = true;

            if (!groupId) return;

            fetch(CTX + "/branch/swap?action=getMaterialsByGroup&materialGroupId=" + groupId)
                .then(response => response.json())
                .then(data => {
                    if (data.length > 0) {
                        itemSelect.disabled = false;
                        data.forEach(material => {
                            const option = document.createElement('option');
                            option.value = material.materialCode;
                            option.textContent = material.materialName;
                            itemSelect.appendChild(option);
                        });
                    } else {
                        itemSelect.innerHTML = '<option value="">해당 그룹에 재료가 없습니다</option>';
                    }
                })
                .catch(error => console.error('재료 로딩 실패:', error));
        });

        // 재고 조회 (검색)
        searchForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const item = itemSelect.value;
            const qty = document.getElementById('qty').value;
            const dist = document.getElementById('dist').value;

            if (!item || !qty) {
                alert('재료, 수량을 모두 입력해주세요.');
                return;
            }

            const url = CTX + "/branch/swap?action=search&item=" + item + "&qty=" + qty + "&dist=" + dist;

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    checkStockResult.style.display = 'block';
                    renderResults(data);
                })
                .catch(error => {
                    console.error('재고 조회 중 오류 발생:', error);
                    alert('데이터를 불러오는 데 실패했습니다.');
                });
        });

        function renderResults(data) {
            if (typeof kakao === 'undefined' || !kakao.maps) {
                alert('카카오맵 API를 불러오지 못했습니다. 새로고침 후 다시 시도해주세요.');
                return;
            }

            resultTableBody.innerHTML = '';
            mapHead.innerHTML = `주변 지점 지도 <small>(\${data.length}개 지점 발견)</small>`;
            tableHead.innerHTML = `상세 지점 정보 <small>(\${data.length}개)</small>`;

            markers.forEach(marker => marker.setMap(null));
            markers = [];

            if (data.length === 0) {
                resultTableBody.innerHTML = '<tr><td colspan="5" class="no-result">검색 조건에 맞는 지점이 없습니다.</td></tr>';
                const mapContainer = document.getElementById('map');
                if (mapContainer) mapContainer.innerHTML = '';
                map = null;
                return;
            }

            const mapContainer = document.getElementById('map');
            mapContainer.innerHTML = ''; // 중복 지도 방지

            const options = { center: new kakao.maps.LatLng(data[0].lat, data[0].lng), level: 8 };
            map = new kakao.maps.Map(mapContainer, options);
            const bounds = new kakao.maps.LatLngBounds();

            data.forEach(branch => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>\${branch.branchName}</td>
                    <td>\${branch.address}</td>
                    <td>\${branch.distance.toFixed(2)}</td>
                    <td style="text-align:center">\${Math.floor(branch.currentQty)}</td>
                    <td style="text-align:center;"><button class="ask" onclick="requestStock('\${branch.branchCode}')">요청하기</button></td>
                `;
                resultTableBody.appendChild(row);

                const position = new kakao.maps.LatLng(branch.lat, branch.lng);
                const marker = new kakao.maps.Marker({ map: map, position: position });
                const infowindow = new kakao.maps.InfoWindow({ content: `<div style="padding:5px;font-size:12px;"><b>\${branch.branchName}</b><br>재고: \${Math.floor(branch.currentQty)}개</div>` });

                kakao.maps.event.addListener(marker, 'mouseover', () => infowindow.open(map, marker));
                kakao.maps.event.addListener(marker, 'mouseout', () => infowindow.close());

                markers.push(marker);
                bounds.extend(position);
            });

            map.setBounds(bounds);
        }

        window.requestStock = function(branchCode) {
            alert(`지점 코드 \${branchCode}에 재고 교환 요청을 보냅니다. (구현 필요)`);
        };

        // 탭 기능
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');
        function showTab(tabName) {
            tabs.forEach(tab => tab.classList.toggle('active', tab.dataset.tab === tabName));
            tabContents.forEach(content => content.classList.toggle('active', content.id === 'tab-content-' + tabName));
            window.history.pushState({tab: tabName}, '', '?tab=' + tabName);
        }
        tabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                e.preventDefault();
                showTab(e.currentTarget.dataset.tab);
            });
        });
        const initialTab = new URLSearchParams(window.location.search).get('tab') || 'check_stock';
        showTab(initialTab);

        // 초기 재료 그룹 로딩 실행
        loadMaterialGroups();
    });
</script>
</body>
</html>
