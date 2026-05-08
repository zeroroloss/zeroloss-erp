<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>알림</title>
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
        width: min(360px, calc(100vw - 32px));
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
    }
    .btn {
        min-width: 72px;
        height: 38px;
        border: 0;
        border-radius: 8px;
        background: #2563eb;
        color: #fff;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
    }
</style>
</head>
<body>
<div class="popup">
    <h1 class="title"><%= request.getParameter("title") != null ? request.getParameter("title") : "알림" %></h1>
    <p class="message"><%= request.getParameter("message") != null ? request.getParameter("message") : "메시지가 없습니다." %></p>
    <div class="actions">
        <button type="button" class="btn" onclick="closePopup()">확인</button>
    </div>
</div>

<script>
    function closePopup() {
        if (window.opener) {
            window.close();
            return;
        }
        history.back();
    }
</script>
</body>
</html>