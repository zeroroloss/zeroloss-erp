<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>확인</title>
<style>
    html, body { height: 100%; margin: 0; }
    body {
        font-family: "Malgun Gothic", sans-serif;
        background: #f3f4f6;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .popup {
        width: min(380px, calc(100vw - 32px));
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
        padding: 24px;
        box-sizing: border-box;
    }
    .title {
        margin: 0 0 12px;
        font-size: 18px;
        font-weight: 700;
        color: #111827;
    }
    .message {
        margin: 0 0 20px;
        font-size: 14px;
        line-height: 1.5;
        color: #374151;
        white-space: pre-wrap;
        word-break: break-word;
    }
    .actions {
        display: flex;
        justify-content: flex-end;
        gap: 8px;
    }
    .btn {
        min-width: 72px;
        height: 38px;
        border: 0;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
    }
    .btn-cancel {
        background: #e5e7eb;
        color: #111827;
    }
    .btn-ok {
        background: #2563eb;
        color: #fff;
    }
</style>
</head>
<body>
<div class="popup">
    <h1 class="title"><%= request.getParameter("title") != null ? request.getParameter("title") : "확인" %></h1>
    <p class="message"><%= request.getParameter("message") != null ? request.getParameter("message") : "진행하시겠습니까?" %></p>
    <div class="actions">
        <button type="button" class="btn btn-cancel" onclick="cancelAction()">취소</button>
        <button type="button" class="btn btn-ok" onclick="confirmAction()">확인</button>
    </div>
</div>

<script>
    function confirmAction() {
        var okUrl = '<%= request.getParameter("okUrl") != null ? request.getParameter("okUrl") : "" %>';
        if (okUrl) {
            window.location.href = okUrl;
            return;
        }
        if (window.opener) {
            window.close();
            return;
        }
        history.back();
    }

    function cancelAction() {
        var cancelUrl = '<%= request.getParameter("cancelUrl") != null ? request.getParameter("cancelUrl") : "" %>';
        if (cancelUrl) {
            window.location.href = cancelUrl;
            return;
        }
        if (window.opener) {
            window.close();
            return;
        }
        history.back();
    }
</script>
</body>
</html>