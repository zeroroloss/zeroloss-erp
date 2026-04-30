<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>발주서 전송 확인</title>
    <style>
        body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: transparent; }
        .overlay { min-height: 100vh; background: transparent; display: flex; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box; }
        .modal { width: min(620px, 100%); background: #fff; border: 1px solid #e5e7eb; border-radius: 16px; box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22); padding: 20px; }

        .head { display: flex; align-items: center; gap: 12px; margin-bottom: 14px; }
        .icon { width: 46px; height: 46px; border-radius: 50%; background: #dbeafe; color: #2563eb; display: grid; place-items: center; font-size: 24px; font-weight: 800; }
        .title { margin: 0; font-size: 24px; font-weight: 800; color: #111827; letter-spacing: -0.02em; }
        .sub { margin: 4px 0 0; font-size: 14px; color: #6b7280; }

        .meta { background: #eef4ff; border: 1px solid #bfdbfe; border-radius: 12px; padding: 14px 16px; margin-top: 6px; }
        .meta-row { display: flex; justify-content: space-between; gap: 8px; padding: 4px 0; font-size: 14px; }
        .meta-row .k { color: #2563eb; font-weight: 700; }
        .meta-row .v { color: #1e3a8a; font-weight: 900; }
        .meta-row .v.red { color: #ef4444; }

        .notice { margin-top: 14px; background: #fff8db; border: 1px solid #f3d36a; border-radius: 12px; padding: 12px 14px; color: #a16207; font-size: 13px; line-height: 1.35; }

        .actions { margin-top: 14px; display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .btn { height: 40px; border-radius: 10px; font-size: 15px; font-weight: 700; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
        .btn-cancel { border: 1px solid #d1d5db; background: #f9fafb; color: #374151; }
        .btn-send { border: 0; background: #2563eb; color: #fff; }
        .btn-send:hover { background: #1d4ed8; }

        @media (max-width: 900px) {
            .title { font-size: 22px; }
            .meta-row { font-size: 13px; }
            .notice { font-size: 14px; }
            .btn { font-size: 14px; height: 40px; }
        }
        @media (max-width: 560px) {
            .modal { padding: 16px; }
            .head { align-items: flex-start; }
            .title { font-size: 19px; }
            .sub { font-size: 13px; }
            .meta-row { font-size: 12px; }
            .actions { grid-template-columns: 1fr; }
            .btn { font-size: 14px; height: 38px; }
            .notice { font-size: 12px; }
        }
    </style>
</head>
<body>
<div class="overlay">
    <section class="modal" role="dialog" aria-modal="true" aria-label="발주서 전송 확인">
        <div class="head">
            <div class="icon">✈</div>
            <div>
                <h1 class="title">발주서 전송 확인</h1>
                <p class="sub">본사로 발주서를 전송합니다</p>
            </div>
        </div>

        <div class="meta">
            <div class="meta-row">
                <span class="k">발주 품목 수</span>
                <span class="v" id="itemCount">0개</span>
            </div>
            <div class="meta-row">
                <span class="k">재고 부족 품목</span>
                <span class="v red" id="lowStockCount">0개</span>
            </div>

            <div class="meta-row">
                <span class="k">수동 추가 품목</span>
                <span class="v" id="manualCount">0개</span>
            </div>
        </div>

        <div class="notice"><strong>안내:</strong> 전송 시 해당 발주서는 발주 내역의 전송 탭에서 확인 가능하며, 본사에 의해 승인/반려 처리됩니다.</div>

        <div class="actions">
			<a class="btn btn-cancel" href="#" onclick="closePopup()">취소</a>
            <a class="btn btn-send" href="#" onclick="sendAndClose()">전송</a>
        </div>
    </div>
</div>

<script>
function closePopup() {
    window.parent.postMessage({ type: 'close-place-popup' }, '*');
}

function sendAndClose() {
    // TODO: 실제 전송 API 호출 넣기

    alert('전송되었습니다.');

    window.parent.postMessage({ type: 'close-place-popup' }, '*');

    // 페이지 리로드 이동
    window.parent.location.href = '<%= request.getContextPath() %>/branch/place_order/create';
}
</script>
</body>
</html>
