<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>신규 직원 등록</title>
  <style>
    body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: transparent; color: #111827; }
    .overlay { min-height: 100vh; background: transparent; display: grid; place-items: center; padding: 16px; box-sizing: border-box; }
    .modal { width: min(760px, 100%); background: #fff; border: 1px solid #e5e7eb; border-radius: 16px; overflow: hidden; box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22); }
    .head { height: 70px; padding: 0 18px; border-bottom: 1px solid #e5e7eb; display: flex; align-items: center; justify-content: space-between; }
    .title { margin: 0; font-size: 24px; font-weight: 900; letter-spacing: -0.03em; color: #111827; }
    .close-btn { width: 34px; height: 34px; border: 0; border-radius: 999px; background: transparent; cursor: pointer; }
    .close-btn img { width: 19px; height: 19px; display: block; margin: 0 auto; opacity: 0.65; }

    .body { padding: 18px 22px 20px; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 14px; }
    .field label { display: block; margin-bottom: 7px; font-size: 15px; font-weight: 700; color: #374151; }
    .field label .req { color: #ef4444; }
    .input,
    .select { width: 100%; height: 48px; box-sizing: border-box; border: 1px solid #cbd5e1; border-radius: 12px; padding: 0 12px; font-size: 14px; color: #111827; background: #fff; }
    .input::placeholder { color: #9ca3af; }

    .foot { border-top: 1px solid #e5e7eb; padding: 14px 22px; display: flex; justify-content: flex-end; gap: 10px; }
    .btn { height: 46px; min-width: 84px; padding: 0 18px; border-radius: 12px; border: 1px solid #d1d5db; background: #f9fafb; color: #374151; font-size: 14px; font-weight: 700; cursor: pointer; }
    .btn.primary { border-color: #0a8b43; background: #0a8b43; color: #fff; }

    @media (max-width: 980px) {
      .title { font-size: 26px; }
      .input, .select { font-size: 14px; }
      .btn { font-size: 14px; }
    }
    @media (max-width: 760px) {
      .grid { grid-template-columns: 1fr; }
      .title { font-size: 24px; }
      .input, .select { height: 44px; font-size: 16px; border-radius: 10px; }
      .btn { height: 42px; font-size: 16px; border-radius: 10px; }
    }
  </style>
</head>
<body>
  <!-- 신규 직원 등록 모달 -->
<div id="addModal"
     class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
     onclick="if(event.target === this) closeAddModal()">

    <div class="bg-white rounded-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-xl"
         onclick="event.stopPropagation()">

        <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between sticky top-0 bg-white z-10">
            <h3 class="text-lg font-bold text-gray-900">신규 직원 등록</h3>
            <button type="button" onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times w-5 h-5"></i>
            </button>
        </div>

        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이름</label>
                    <input type="text" id="name" name="name" placeholder="홍길동"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">사번</label>
                    <input type="text" id="empNo" name="empNo" placeholder="21"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">역할</label>
                    <select id="positionCode" name="positionCode"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900 focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                        <option value="">선택 안 함</option>
                        <option value="POS_MGR">점장</option>
                        <option value="POS_SUP">매니저</option>
                        <option value="POS_STF">직원</option>
                        <option value="POS_PTM">알바</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">연락처</label>
                    <input type="tel" id="phone" name="phone" placeholder="010-0000-0000"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
                    <input type="email" id="email" name="email" placeholder="user@zeroloss.com"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">입사일</label>
                    <input type="date" id="hireDate" name="hireDate"
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
                    <select id="status" name="status"
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-white text-gray-900 focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none">
                        <option value="ACTIVE">재직</option>
                        <option value="LEAVE">휴직</option>
                        <option value="RESIGNED">퇴사</option>
                    </select>
                </div>

            </div>
        </div>

        <div class="border-t border-gray-200 px-6 py-4 flex justify-end gap-3 sticky bottom-0 bg-white">
            <button type="button" onclick="closeAddModal()"
                    class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 text-sm">
                취소
            </button>
            <button type="button" onclick="saveEmployee()"
                    class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F] text-sm">
                추가
            </button>
        </div>
    </div>
</div>

<!-- add: 신규 직원 등록 모달 / 저장 -->
<script>
    function showAddModal() {
        document.getElementById("addModal").classList.remove("modal-hidden");
    }

    function closeAddModal() {
        document.getElementById("addModal").classList.add("modal-hidden");
    }

    function saveEmployee() {
        const params = new URLSearchParams();

        params.append("action", "add");
        params.append("empNo", document.getElementById("empNo").value);
        params.append("name", document.getElementById("name").value);
        params.append("branchCode", document.getElementById("branchCode").value);
        params.append("dept", document.getElementById("dept").value);
        params.append("gradeCode", document.getElementById("gradeCode").value);
        params.append("positionCode", document.getElementById("positionCode").value);
        params.append("phone", document.getElementById("phone").value);
        params.append("email", document.getElementById("email").value);
        params.append("hireDate", document.getElementById("hireDate").value);
        params.append("status", document.getElementById("status").value);

        fetch("<%= request.getContextPath() %>/hq/hr/employee", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(response => response.text())
        .then(text => {
            const data = JSON.parse(text);

            if (data.success) {
                alert("직원이 등록되었습니다.");
                closeAddModal();
                location.reload();
            } else {
                alert(data.message || "직원 등록에 실패했습니다.");
            }
        })
        .catch(error => {
            console.error(error);
            location.href = "<%= request.getContextPath() %>/common/500.jsp";
        });
    }
</script>
</body>
</html>
