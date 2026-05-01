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
        .ask { background: var(--green); color: #fff; border: none; border-radius: 10px; padding: 8px 12px; font-size: 0.8125rem; font-weight: 700; cursor: pointer; }
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
                    <section class="table-box"><div class="tb-head" id="table-head"></div><table id="result-table"><thead><tr><th>지점명</th><th>주소</th><th>거리(km)</th><th>보유수량</th><th style="text-align:center;">요청하기</th></tr></thead><tbody></tbody></table></section>
                </div>
            </div>

            <!-- 보낸 요청 탭 -->
            <div id="tab-content-send_request" class="tab-content">
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">보낸 요청 목록</h2></div>
                    <div id="send_request_content" style="padding: 20px;">
                        <table id="sent-table" style="display: none; width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="background: #f9fafb;">
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">날짜</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">받는 지점</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">품목</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">수량</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">상태</th>
                                    <th style="padding: 14px 18px; text-align: center; border-bottom: 1px solid #e5e7eb;">액션</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <div id="sent-empty" style="text-align: center; padding: 40px; color: #6b7280;">
                            <p>보낸 요청이 없습니다.</p>
                        </div>
                    </div>
                </section>
            </div>

            <!-- 받은 요청 탭 -->
            <div id="tab-content-received_request" class="tab-content">
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">받은 요청 목록</h2></div>
                    <div id="received_request_content" style="padding: 20px;">
                        <table id="received-table" style="display: none; width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="background: #f9fafb;">
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">날짜</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">보내는 지점</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">품목</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">수량</th>
                                    <th style="padding: 14px 18px; text-align: center; border-bottom: 1px solid #e5e7eb;">액션</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <div id="received-empty" style="text-align: center; padding: 40px; color: #6b7280;">
                            <p>받은 요청이 없습니다.</p>
                        </div>
                    </div>
                </section>
            </div>

            <!-- 교환 내역 탭 -->
            <div id="tab-content-swap_history" class="tab-content">
                <section class="panel">
                    <div class="panel-head"><h2 class="panel-title">교환 내역</h2></div>
                    <div id="swap_history_content" style="padding: 20px;">
                        <table id="history-table" style="display: none; width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="background: #f9fafb;">
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">날짜</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">상대방 지점</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">품목</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">수량</th>
                                    <th style="padding: 14px 18px; text-align: left; border-bottom: 1px solid #e5e7eb;">상태</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <div id="history-empty" style="text-align: center; padding: 40px; color: #6b7280;">
                            <p>교환 내역이 없습니다.</p>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>

<!-- 재고 요청 모달 -->
<div id="requestModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
    <div style="background: white; border-radius: 12px; padding: 24px; max-width: 500px; width: 90%; max-height: 80vh; overflow-y: auto; box-shadow: 0 20px 25px rgba(0,0,0,0.15);">
        <h3 style="margin-top: 0; font-size: 1.25rem; font-weight: 700; margin-bottom: 20px;">재고 교환 요청</h3>

        <div style="display: grid; gap: 16px; margin-bottom: 24px;">
            <div>
                <label style="display: block; font-size: 0.875rem; font-weight: 700; color: #374151; margin-bottom: 6px;">받는 지점</label>
                <div id="modalBranchName" style="padding: 10px 13px; border: 1px solid #cfd6dd; border-radius: 12px; background: #f3f4f6;">-</div>
            </div>
            <div>
                <label style="display: block; font-size: 0.875rem; font-weight: 700; color: #374151; margin-bottom: 6px;">품목</label>
                <div id="modalMaterialName" style="padding: 10px 13px; border: 1px solid #cfd6dd; border-radius: 12px; background: #f3f4f6;">-</div>
            </div>
            <div>
                <label style="display: block; font-size: 0.875rem; font-weight: 700; color: #374151; margin-bottom: 6px;">요청 수량</label>
                <div id="modalQty" style="padding: 10px 13px; border: 1px solid #cfd6dd; border-radius: 12px; background: #f3f4f6;">-</div>
            </div>
        </div>

        <div style="display: flex; gap: 12px;">
            <button id="modalCancelBtn" style="flex: 1; height: 38px; border: 1px solid #d1d5db; border-radius: 12px; background: white; color: #111827; font-weight: 700; cursor: pointer;">취소</button>
            <button id="modalRequestBtn" style="flex: 1; height: 38px; border: none; border-radius: 12px; background: var(--green); color: white; font-weight: 700; cursor: pointer;">요청하기</button>
        </div>
    </div>
</div>

<!-- 수락 확인 모달 -->
<div id="confirmModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1001; align-items: center; justify-content: center;">
    <div style="background: white; border-radius: 12px; padding: 24px; max-width: 450px; width: 90%; box-shadow: 0 20px 25px rgba(0,0,0,0.15);">
        <h3 style="margin-top: 0; font-size: 1.25rem; font-weight: 700; margin-bottom: 16px; color: #111827;">재고 교환 수락</h3>
        <p id="confirmMessage" style="margin: 0 0 24px 0; color: #6b7280; font-size: 0.95rem; line-height: 1.6;"></p>

        <div style="display: flex; gap: 12px;">
            <button id="confirmCancelBtn" style="flex: 1; height: 38px; border: 1px solid #d1d5db; border-radius: 12px; background: white; color: #111827; font-weight: 700; cursor: pointer;">취소</button>
            <button id="confirmApproveBtn" style="flex: 1; height: 38px; border: none; border-radius: 12px; background: var(--green); color: white; font-weight: 700; cursor: pointer;">수락 하기</button>
        </div>
    </div>
</div>
    </div>
</div>
<script>
    // 🟢 1. 최상단에 컨텍스트 경로를 안전하게 자바스크립트 변수로 선언!
    const CTX = "<%= request.getContextPath() %>";

    // 모달 관련 변수
    let currentSwapData = null;
    let currentConfirmSwapId = null;

    document.addEventListener('DOMContentLoaded', function () {
        const materialGroupSelect = document.getElementById('materialGroup');
        const itemSelect = document.getElementById('item');
        const searchForm = document.getElementById('searchForm');
        const checkStockResult = document.getElementById('check_stock_result');
        const resultTableBody = document.querySelector('#result-table tbody');
        const mapHead = document.getElementById('map-head');
        const tableHead = document.getElementById('table-head');
        const requestModal = document.getElementById('requestModal');
        const confirmModal = document.getElementById('confirmModal');
        let map;
        let markers = [];

        // 모달 관련 요소
        const modalBranchName = document.getElementById('modalBranchName');
        const modalMaterialName = document.getElementById('modalMaterialName');
        const modalQty = document.getElementById('modalQty');
        const modalCancelBtn = document.getElementById('modalCancelBtn');
        const modalRequestBtn = document.getElementById('modalRequestBtn');
        const confirmCancelBtn = document.getElementById('confirmCancelBtn');
        const confirmApproveBtn = document.getElementById('confirmApproveBtn');
        const confirmMessage = document.getElementById('confirmMessage');

        // 이벤트 위임: '보낸 요청' 탭의 취소 버튼 처리를 위한 이벤트 리스너
        const sendRequestContent = document.getElementById('send_request_content');
        sendRequestContent.addEventListener('click', function(event) {
            const target = event.target;
            // 클릭된 요소가 'cancel-btn' 클래스를 가지고 있는지 확인
            if (target.classList.contains('cancel-btn')) {
                const swapId = target.dataset.swapId; // data-swap-id 속성 값 가져오기
                if (swapId) {
                    cancelSwapRequest(swapId);
                }
            }
        });

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

            const qtyValue = document.getElementById('qty').value;
            const materialCode = itemSelect.value;
            const materialName = itemSelect.options[itemSelect.selectedIndex].text;

            resultTableBody.innerHTML = '';
            // 변경된 부분: 백틱을 일반 문자열과 변수 결합으로 수정
            mapHead.innerHTML = '주변 지점 지도 <small>(' + data.length + '개 지점 발견)</small>';
            tableHead.innerHTML = '상세 지점 정보 <small>(' + data.length + '개)</small>';

            markers.forEach(marker => marker.setMap(null));
            markers = [];

            if (data.length === 0) {
                alert('설정한 거리와 재고 조건에 맞는 지점이 없습니다.');
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
                // 변경된 부분: 백틱을 일반 따옴표와 + 기호 결합으로 수정
                row.innerHTML =
                    '<td>' + branch.branchName + '</td>' +
                    '<td>' + branch.address + '</td>' +
                    '<td>' + branch.distance.toFixed(2) + '</td>' +
                    '<td style="text-align:center">' + Math.floor(branch.currentQty) + '</td>' +
                    '<td style="text-align:center;"><button class="ask" onclick="openRequestModal(\'' + branch.branchCode + '\', \'' + branch.branchName + '\', \'' + materialCode + '\', \'' + materialName + '\', \'' + qtyValue + '\')">요청하기</button></td>';

                resultTableBody.appendChild(row);

                const position = new kakao.maps.LatLng(branch.lat, branch.lng);
                const marker = new kakao.maps.Marker({ map: map, position: position });
                // 변경된 부분: InfoWindow 내용 수정
                const infowindow = new kakao.maps.InfoWindow({ content: '<div style="padding:5px;font-size:12px;"><b>' + branch.branchName + '</b><br>재고: ' + Math.floor(branch.currentQty) + '개</div>' });

                kakao.maps.event.addListener(marker, 'mouseover', () => infowindow.open(map, marker));
                kakao.maps.event.addListener(marker, 'mouseout', () => infowindow.close());

                // 마커 클릭 시 모달 띄우기 (클로저를 통해 각 마커의 정보를 캡처)
                kakao.maps.event.addListener(marker, 'click', (() => {
                    const branchCode = branch.branchCode;
                    const branchName = branch.branchName;
                    const code = materialCode;
                    const name = materialName;
                    const qty = qtyValue;
                    return function() {
                        openRequestModal(branchCode, branchName, code, name, qty);
                    };
                })());

                markers.push(marker);
                bounds.extend(position);
            });

            map.setBounds(bounds);
        }

        // 모달 열기
        window.openRequestModal = function(branchCode, branchName, materialCode, materialName, qty) {
            currentSwapData = {
                resBranchCode: branchCode,
                branchName: branchName,
                materialCode: materialCode,
                materialName: materialName,
                qty: qty
            };

            modalBranchName.textContent = branchName;
            modalMaterialName.textContent = materialName;
            modalQty.textContent = qty + '개';
            requestModal.style.display = 'flex';
        };

        // 모달 취소
        modalCancelBtn.addEventListener('click', function() {
            requestModal.style.display = 'none';
            currentSwapData = null;
        });

        // 모달 요청하기
        modalRequestBtn.addEventListener('click', function() {
            if (!currentSwapData) return;

            const params = new URLSearchParams();
            params.append('action', 'createSwapRequest');
            params.append('resBranchCode', currentSwapData.resBranchCode);
            params.append('materialCode', currentSwapData.materialCode);
            params.append('qty', currentSwapData.qty);

            fetch(CTX + '/branch/swap', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('재고 요청이 생성되었습니다!');
                    requestModal.style.display = 'none';
                    currentSwapData = null;
                } else {
                    alert(data.message || '요청 생성에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('요청 생성 오류:', error);
                alert('요청 생성 중 오류가 발생했습니다.');
            });
        });

        // 확인 모달 취소
        confirmCancelBtn.addEventListener('click', function() {
            confirmModal.style.display = 'none';
            currentConfirmSwapId = null;
        });

        // 확인 모달 수락
        confirmApproveBtn.addEventListener('click', function() {
            if (currentConfirmSwapId === null) return;

            const params = new URLSearchParams();
            params.append('action', 'approveSwapRequest');
            params.append('swapId', currentConfirmSwapId);

            fetch(CTX + '/branch/swap', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('재고 요청을 수락했습니다!');
                    confirmModal.style.display = 'none';
                    currentConfirmSwapId = null;
                    loadReceivedRequests(); // 목록 새로고침
                } else {
                    alert(data.message || '수락에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('수락 오류:', error);
                alert('수락 중 오류가 발생했습니다.');
            });
        });

        // 탭 기능
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');
        function showTab(tabName) {
            tabs.forEach(tab => tab.classList.toggle('active', tab.dataset.tab === tabName));
            tabContents.forEach(content => content.classList.toggle('active', content.id === 'tab-content-' + tabName));
            window.history.pushState({tab: tabName}, '', '?tab=' + tabName);

            // 탭 전환 시 해당 데이터 로드
            if (tabName === 'send_request') {
                loadSentRequests();
            } else if (tabName === 'received_request') {
                loadReceivedRequests();
            } else if (tabName === 'swap_history') {
                loadSwapHistory();
            }
        }
        tabs.forEach(tab => {
            tab.addEventListener('click', (e) => {
                e.preventDefault();
                showTab(e.currentTarget.dataset.tab);
            });
        });
        const initialTab = new URLSearchParams(window.location.search).get('tab') || 'check_stock';
        showTab(initialTab);

        // 보낸 요청 로드
        function loadSentRequests() {
            fetch(CTX + '/branch/swap?action=getSentRequests')
                .then(response => response.json())
                .then(data => {
                    const table = document.getElementById('sent-table');
                    const tbody = table.querySelector('tbody');
                    const empty = document.getElementById('sent-empty');

                    tbody.innerHTML = '';

                    if (data.length === 0) {
                        table.style.display = 'none';
                        empty.style.display = 'block';
                    } else {
                        empty.style.display = 'none';
                        table.style.display = 'table';

                        data.forEach(req => {
                            const statusText = getStatusText(req.status);
                            const row = document.createElement('tr');
                            // 변경된 부분: 백틱 제거 후 + 기호 결합으로 수정
                            row.innerHTML =
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.reqDate + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.resBranchName + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.materialName + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + Math.floor(req.qty) + '개</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' +
                                '<span style="display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 0.8125rem; font-weight: 700; ' + getStatusStyle(req.status) + '">' + statusText + '</span>' +
                                '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb; text-align: center;">' +
                                (req.status === 'PENDING' ? '<button class="cancel-btn" data-swap-id="' + req.swapId + '" style="background: #ef4444; color: white; border: none; padding: 6px 12px; border-radius: 8px; cursor: pointer; font-size: 0.8125rem;">취소</button>' : '-') +
                                '</td>';
                            tbody.appendChild(row);
                        });
                    }
                    // 배지 업데이트
                    updateBadges();
                })
                .catch(error => console.error('보낸 요청 로드 오류:', error));
        }

        // 받은 요청 로드
        function loadReceivedRequests() {
            fetch(CTX + '/branch/swap?action=getReceivedRequests')
                .then(response => response.json())
                .then(data => {
                    const table = document.getElementById('received-table');
                    const tbody = table.querySelector('tbody');
                    const empty = document.getElementById('received-empty');

                    tbody.innerHTML = '';

                    if (data.length === 0) {
                        table.style.display = 'none';
                        empty.style.display = 'block';
                    } else {
                        empty.style.display = 'none';
                        table.style.display = 'table';

                        data.forEach(req => {
                            const row = document.createElement('tr');
                            // 변경된 부분: 따옴표 에스케이프(\')와 일반 텍스트 결합 활용
                            row.innerHTML =
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.reqDate + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.reqBranchName + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.materialName + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + Math.floor(req.qty) + '개</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb; text-align: center;">' +
                                '<button onclick="openConfirmModal(' + req.swapId + ', \'' + req.reqBranchName + '\', \'' + req.materialName + '\', \'' + req.qty + '\')" style="background: var(--green); color: white; border: none; padding: 6px 12px; border-radius: 8px; cursor: pointer; font-size: 0.8125rem; margin-right: 6px;">수락</button>' +
                                '<button onclick="rejectSwapRequest(' + req.swapId + ')" style="background: #ef4444; color: white; border: none; padding: 6px 12px; border-radius: 8px; cursor: pointer; font-size: 0.8125rem;">거절</button>' +
                                '</td>';
                            tbody.appendChild(row);
                        });
                    }
                    // 배지 업데이트
                    updateBadges();
                })
                .catch(error => console.error('받은 요청 로드 오류:', error));
        }

        // 교환 내역 로드
        function loadSwapHistory() {
            fetch(CTX + '/branch/swap?action=getSwapHistory')
                .then(response => response.json())
                .then(data => {
                    const table = document.getElementById('history-table');
                    const tbody = table.querySelector('tbody');
                    const empty = document.getElementById('history-empty');

                    tbody.innerHTML = '';

                    if (data.length === 0) {
                        table.style.display = 'none';
                        empty.style.display = 'block';
                    } else {
                        empty.style.display = 'none';
                        table.style.display = 'table';

                        data.forEach(req => {
                            const statusText = getStatusText(req.status);
                            const row = document.createElement('tr');
                            // 삼항 연산자를 괄호로 묶고 문자열 결합 처리
                            row.innerHTML =
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.reqDate + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + (req.reqBranchName === '' ? req.resBranchName : req.reqBranchName) + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + req.materialName + '</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' + Math.floor(req.qty) + '개</td>' +
                                '<td style="padding: 14px 18px; border-bottom: 1px solid #e5e7eb;">' +
                                '<span style="display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 0.8125rem; font-weight: 700; ' + getStatusStyle(req.status) + '">' + statusText + '</span>' +
                                '</td>';
                            tbody.appendChild(row);
                        });
                    }
                })
                .catch(error => console.error('교환 내역 로드 오류:', error));
        }

        // 상태 텍스트 변환
        function getStatusText(status) {
            const statusMap = {
                'PENDING': '대기 중',
                'APPROVED': '수락됨',
                'COMPLETED': '완료',
                'REJECTED': '거절됨'
            };
            return statusMap[status] || status;
        }

        // 상태 스타일 반환
        function getStatusStyle(status) {
            switch(status) {
                case 'PENDING':
                    return 'background: #fef3c7; color: #92400e;';
                case 'APPROVED':
                    return 'background: #dcfce7; color: #166534;';
                case 'COMPLETED':
                    return 'background: #dcfce7; color: #166534;';
                case 'REJECTED':
                    return 'background: #fee2e2; color: #991b1b;';
                default:
                    return 'background: #e5e7eb; color: #374151;';
            }
        }

        // 배지 업데이트
        function updateBadges() {
            // 보낸 요청 배지 업데이트
            fetch(CTX + '/branch/swap?action=getSentRequests')
                .then(response => response.json())
                .then(data => {
                    document.querySelectorAll('.tab[data-tab="send_request"] .badge').forEach(badge => {
                        badge.textContent = data.length;
                    });
                })
                .catch(error => console.error('보낸 요청 배지 업데이트 오류:', error));

            // 받은 요청 배지 업데이트
            fetch(CTX + '/branch/swap?action=getReceivedRequests')
                .then(response => response.json())
                .then(data => {
                    document.querySelectorAll('.tab[data-tab="received_request"] .badge').forEach(badge => {
                        badge.textContent = data.length;
                    });
                })
                .catch(error => console.error('받은 요청 배지 업데이트 오류:', error));
        }

        // 전역 함수들
        window.openConfirmModal = function(swapId, branchName, materialName, qty) {
            currentConfirmSwapId = swapId;
            confirmMessage.textContent = branchName + '에서 ' + materialName + ' ' + Math.floor(qty) + '개 교환 요청을 수락하시겠습니까?';
            confirmModal.style.display = 'flex';
        };

        window.rejectSwapRequest = function(swapId) {
            if (!confirm('이 요청을 거절하시겠습니까?')) return;

            const params = new URLSearchParams();
            params.append('action', 'rejectSwapRequest');
            params.append('swapId', swapId);

            fetch(CTX + '/branch/swap', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('요청이 거절되었습니다.');
                    loadReceivedRequests();
                } else {
                    alert(data.message || '거절에 실패했습니다.');
                }
            })
            .catch(error => console.error('거절 오류:', error));
        };

        window.cancelSwapRequest = function(swapId) {
            if (!confirm('이 요청을 취소하시겠습니까?')) return;

            const params = new URLSearchParams();
            params.append('action', 'cancelSwapRequest');
            params.append('swapId', swapId);

            fetch(CTX + '/branch/swap', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('요청이 취소되었습니다.');
                    loadSentRequests();
                } else {
                    alert(data.message || '취소에 실패했습니다.');
                }
            })
            .catch(error => console.error('취소 오류:', error));
        };

        // 초기 재료 그룹 로딩 실행
        loadMaterialGroups();
        // 페이지 로드 시 배지 즉시 업데이트
        updateBadges();
        // 약간의 딜레이 후 다시 업데이트 (확실하게)
        setTimeout(updateBadges, 500);
    });
</script>
</body>
</html>
