<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>직원 정보 수정</title>
  <style>
    body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #03050a; }
    .overlay { min-height: 100vh; background: rgba(0, 0, 0, 0.84); display: grid; place-items: center; padding: 16px; box-sizing: border-box; }
    .modal { width: min(760px, 100%); background: #fff; border-radius: 12px; overflow: hidden; border: 1px solid #d1d5db; }
    .head { height: 70px; display: flex; align-items: center; justify-content: space-between; padding: 0 18px; border-bottom: 1px solid #e5e7eb; }
    .head h1 { margin: 0; font-size: 24px; font-weight: 900; letter-spacing: -0.03em; color: #111827; }
    .close { width: 34px; height: 34px; border: 0; background: transparent; cursor: pointer; padding: 0; }
    .close img { width: 19px; height: 19px; display: block; margin: 0 auto; opacity: 0.65; }
    .body { padding: 18px 22px 20px; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px 14px; }
    .field label { display: block; font-size: 15px; font-weight: 700; color: #374151; margin-bottom: 7px; }
    .input, .select { width: 100%; height: 48px; box-sizing: border-box; border: 1px solid #cbd5e1; border-radius: 12px; padding: 0 12px; font-size: 14px; color: #111827; background: #fff; }
    .foot { border-top: 1px solid #e5e7eb; padding: 14px 22px; display: flex; justify-content: flex-end; gap: 10px; }
    .btn { height: 46px; min-width: 84px; border-radius: 12px; padding: 0 18px; font-size: 14px; font-weight: 700; cursor: pointer; }
    .btn-cancel { border: 1px solid #cbd5e1; background: #fff; color: #374151; }
    .btn-save { border: 1px solid #0a8b43; background: #0a8b43; color: #fff; }
    .input::placeholder { color: #9ca3af; }

    @media (max-width: 980px) {
      .head h1 { font-size: 26px; }
      .input, .select { font-size: 14px; }
      .btn { font-size: 14px; }
    }
    @media (max-width: 760px) {
      .grid { grid-template-columns: 1fr; }
      .head h1 { font-size: 24px; }
      .input, .select { height: 44px; font-size: 14px; border-radius: 10px; }
      .btn { height: 42px; font-size: 14px; border-radius: 10px; padding: 0 18px; }
    }
  </style>
</head>
<body>
<!-- Edit Employee Modal -->
<div id="editModal"
     class="modal-hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
     onclick="if(event.target === this) closeEditModal()">

    <div class="bg-white rounded-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto shadow-xl"
         onclick="event.stopPropagation()">

        <!-- 헤더 -->
        <div class="border-b border-gray-200 px-6 py-4 flex items-center justify-between sticky top-0 bg-white z-10">
            <h3 class="text-lg font-bold text-gray-900">직원 상세 조회</h3>

            <div class="flex items-center gap-3">
                <button type="button"
                        id="editModeBtn"
                        onclick="changeToEditMode()"
                        class="px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B2F] transition-colors">
                    수정
                </button>

                <button type="button"
                        onclick="closeEditModal()"
                        class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times w-5 h-5"></i>
                </button>
            </div>
        </div>

        <!-- 본문 -->
        <div class="p-6">
            <input type="hidden" id="editEmpNo" name="editEmpNo">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이름</label>
                    <input type="text"
                           id="editName"
                           readonly
                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">사번</label>
                    <input type="text"
                           id="editEmpNoView"
                           readonly
                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">역할</label>
                    <select id="editPositionCode"
                            name="editPositionCode"
                            disabled
                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                        <option value="">선택 안 함</option>
                        <option value="POS_MGR">점장</option>
                        <option value="POS_SUP">매니저</option>
                        <option value="POS_STF">직원</option>
                        <option value="POS_PTM">알바</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">연락처</label>
                    <input type="text"
                           id="editPhone"
                           name="editPhone"
                           readonly
                           class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
                    <input type="email"
                           id="editEmail"
                           name="editEmail"
                           readonly
                           class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">입사일</label>
                    <input type="text"
                           id="editHireDate"
                           readonly
                           class="view-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">상태</label>
                    <select id="editStatus"
                            name="editStatus"
                            disabled
                            class="editable-field w-full px-3 py-2 border border-gray-300 rounded-lg text-sm bg-gray-100 text-gray-500 cursor-not-allowed">
                        <option value="ACTIVE">재직</option>
                        <option value="LEAVE">휴직</option>
                        <option value="RESIGNED">퇴사</option>
                    </select>
                </div>

            </div>
        </div>

        <!-- 하단 버튼 -->
        <div class="border-t border-gray-200 px-6 py-4 flex justify-end gap-3 sticky bottom-0 bg-white">
            <button type="button"
                    onclick="closeEditModal()"
                    class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 text-sm hover:bg-gray-50 transition-colors">
                닫기
            </button>

            <button type="button"
                    id="saveBtn"
                    onclick="updateEmployee()"
                    class="hidden px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B2F] transition-colors">
                저장
            </button>
        </div>

    </div>
</div>

<!-- edit: 상세 조회 / 수정 모드 / 저장 -->
<script>
    function openEmployeeModal(empNo) {
        selectedEmployee = employees.find(function(emp) {
            return String(emp.empNo) === String(empNo);
        });

        if (!selectedEmployee) {
            alert("직원 정보를 찾을 수 없습니다.");
            return;
        }

        resetEditMode();

        document.getElementById("editEmpNo").value = selectedEmployee.empNo;
        document.getElementById("editEmpNoView").value = selectedEmployee.empNo;
        document.getElementById("editName").value = selectedEmployee.name || "";
        document.getElementById("editBranchCode").value = selectedEmployee.branchCode || "";
        document.getElementById("editDept").value = selectedEmployee.dept || "";
        document.getElementById("editGradeCode").value = selectedEmployee.gradeCode || "";
        document.getElementById("editPositionCode").value = selectedEmployee.positionCode || "";
        document.getElementById("editPhone").value = selectedEmployee.phone || "";
        document.getElementById("editEmail").value = selectedEmployee.email || "";
        document.getElementById("editHireDate").value = selectedEmployee.hireDate || "";
        document.getElementById("editStatus").value = selectedEmployee.status || "ACTIVE";

        document.getElementById("editModal").classList.remove("modal-hidden");
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.add('modal-hidden');
    }

    function changeToEditMode() {
        document.querySelector("#editModal h3").innerText = "직원 정보 수정";
        document.getElementById("editModeBtn").classList.add("hidden");
        document.getElementById("saveBtn").classList.remove("hidden");

        document.querySelectorAll(".editable-field").forEach(function(field) {
            if (field.tagName === "SELECT") {
                field.disabled = false;
            } else {
                field.readOnly = false;
            }

            field.classList.remove("bg-gray-100", "text-gray-500", "cursor-not-allowed");
            field.classList.add("bg-white", "text-gray-900", "focus:ring-2", "focus:ring-[#00853D]", "focus:border-transparent");
        });
    }

    function resetEditMode() {
        document.querySelector("#editModal h3").innerText = "직원 상세 조회";
        document.getElementById("editModeBtn").classList.remove("hidden");
        document.getElementById("saveBtn").classList.add("hidden");

        document.querySelectorAll(".editable-field").forEach(function(field) {
            if (field.tagName === "SELECT") {
                field.disabled = true;
            } else {
                field.readOnly = true;
            }

            field.classList.remove("bg-white", "text-gray-900", "focus:ring-2", "focus:ring-[#00853D]", "focus:border-transparent");
            field.classList.add("bg-gray-100", "text-gray-500", "cursor-not-allowed");
        });
    }

    function updateEmployee() {
        if (!selectedEmployee) return;

        const params = new URLSearchParams();

        params.append("action", "update");
        params.append("empNo", selectedEmployee.empNo);
        params.append("branchCode", document.getElementById("editBranchCode").value);
        params.append("dept", document.getElementById("editDept").value);
        params.append("gradeCode", document.getElementById("editGradeCode").value);
        params.append("positionCode", document.getElementById("editPositionCode").value);
        params.append("phone", document.getElementById("editPhone").value);
        params.append("email", document.getElementById("editEmail").value);
        params.append("status", document.getElementById("editStatus").value);

        fetch("<%= request.getContextPath() %>/hq/hr/employee", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert("직원 정보가 수정되었습니다.");
                closeEditModal();
                location.reload();
            } else {
                alert(data.message || "직원 수정에 실패했습니다.");
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
