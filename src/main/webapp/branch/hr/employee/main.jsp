<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>직원 정보 조회</title>
  <style>
    body { margin: 0; font-family: "Malgun Gothic", sans-serif; background: #f3f4f6; color: #111827; }
    .wrap {
    width: 100%; max-width: none; margin: 0; }
    .head { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; padding: 8px 0 14px; }
    .title { margin: 0; font-size: 34px; letter-spacing: -0.03em; }
    .sub { margin: 8px 0 0; font-size: 17px; color: #6b7280; }
    .add-btn { height: 44px; padding: 0 18px; border: 0; border-radius: 12px; background: #00853d; color: #fff; display: inline-flex; align-items: center; gap: 8px; font-size: 15px; font-weight: 700; cursor: pointer; text-decoration: none; }
    .ico-18 { width: 18px; height: 18px; display: block; }

    .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 16px; }
    .card { background: #fff; border: 1px solid #d1d5db; border-radius: 14px; padding: 16px; display: flex; align-items: center; gap: 12px; }
    .icon-box { width: 52px; height: 52px; border-radius: 12px; display: grid; place-items: center; }
    .b1 { background: #dcfce7; color: #16a34a; }
    .b2 { background: #dbeafe; color: #2563eb; }
    .b3 { background: #fef3c7; color: #ca8a04; }
    .k { font-size: 14px; color: #6b7280; }
    .v { margin-top: 2px; font-size: 30px; font-weight: 800; }

    .filters { background: #fff; border: 1px solid #d1d5db; border-radius: 14px; padding: 14px; margin-bottom: 14px; }
    .search-row { position: relative; margin-bottom: 12px; }
    .search-row .ico { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); width: 18px; height: 18px; color: #9ca3af; }
    .search-input { width: 100%; height: 44px; box-sizing: border-box; border: 1px solid #cbd5e1; border-radius: 12px; padding: 0 14px 0 44px; font-size: 15px; }
    .chip-row { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; color: #374151; font-size: 15px; }
    .chip-row strong { font-weight: 700; }
    .chip { height: 34px; border: 0; border-radius: 10px; padding: 0 12px; font-size: 13px; background: #e5e7eb; color: #374151; }
    .chip.active { background: #0a8b43; color: #fff; }
    .chip:focus-visible { outline: 2px solid #0a8b43; outline-offset: 1px; }

    .table-wrap { background: #fff; border: 1px solid #d1d5db; border-radius: 14px; overflow: hidden; }
    .table { width: 100%; border-collapse: collapse; }
    .table thead { background: #f8fafc; }
    .table th { text-align: left; padding: 14px 16px; color: #6b7280; font-size: 14px; font-weight: 700; border-bottom: 1px solid #e5e7eb; }
    .table td { padding: 16px; font-size: 14px; color: #111827; border-bottom: 1px solid #eef2f7; }
    .empty { height: 220px; text-align: center; color: #9ca3af; font-size: 14px; }

    .modal-overlay { position: fixed; inset: 0; background: transparent; display: none; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box; z-index: 2000; }
    .modal-overlay.open { display: flex; }
    .modal-frame { width: min(820px, 100%); height: min(92vh, 920px); border: 0; border-radius: 16px; background: transparent; box-shadow: 0 24px 60px rgba(0, 0, 0, 0.22); }
    .modal-close { position: absolute; top: 18px; right: 18px; width: 36px; height: 36px; border: 0; border-radius: 999px; background: #fff; color: #374151; font-size: 22px; line-height: 36px; cursor: pointer; z-index: 2001; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12); }
	.modal-hidden { display: none !important;}

    @media (max-width: 1200px) {
      .title { font-size: 30px; }
      .sub { font-size: 18px; }
      .add-btn { height: 44px; font-size: 16px; }
      .k { font-size: 14px; }
      .v { font-size: 28px; }
      .search-input, .chip-row, .table th, .table td { font-size: 15px; }
      .chip { font-size: 13px; }
    }
    @media (max-width: 760px) {
      .title { font-size: 28px; }
      .sub { font-size: 14px; }
      .stats { grid-template-columns: 1fr; }
      .table-wrap { overflow-x: auto; }
      .table { min-width: 720px; }
    }
  </style>
  <%@ include file="/branch/common/layout/layout_head.jsp" %>
</head>
<body class="bg-gray-50">
<div class="zl-app">
  <%@ include file="/branch/common/layout/sidebar.jsp" %>

  <div class="zl-content">

    <main class="p-6">
      <div class="space-y-6">

        <!-- 페이지 헤더 -->
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-3xl font-bold text-gray-900">직원 정보 조회</h2>
            <p class="text-gray-500 mt-1">전체 직원 정보를 통합하여 관리하세요</p>
          </div>

          <button
            id="openAddEmployeeModal"
            type="button"
            class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2.5 rounded-lg hover:bg-[#006B2F] transition-colors">
            <i class="fas fa-user-plus w-5 h-5"></i>
            <span>신규 알바생 등록</span>
          </button>
        </div>

        <!-- 통계 카드 -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">

          <div class="bg-white rounded-lg border border-gray-200 p-4">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <i class="fas fa-users w-6 h-6 text-green-600"></i>
              </div>
              <div>
                <p class="text-sm text-gray-500">총 직원</p>
                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalEmp">${totalEmp}</p>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-lg border border-gray-200 p-4">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <i class="fas fa-building w-6 h-6 text-blue-600"></i>
              </div>
              <div>
                <p class="text-sm text-gray-500">본사 직원</p>
                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalHqEmp">${totalHqEmp}</p>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-lg border border-gray-200 p-4">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 bg-yellow-100 rounded-lg flex items-center justify-center">
                <i class="fas fa-user-plus w-6 h-6 text-yellow-600"></i>
              </div>
              <div>
                <p class="text-sm text-gray-500">알바생</p>
                <p class="text-2xl font-bold text-gray-900 mt-1" id="ptmEmp">${ptmEmp}</p>
              </div>
            </div>
          </div>

        </div>

        <!-- 필터 -->
        <div class="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
          <div class="flex flex-col gap-4">

            <div class="flex items-center justify-between gap-4">

              <div>
                <h3 class="text-sm font-semibold text-gray-800">직원 검색</h3>
                <p class="text-xs text-gray-500 mt-1">사번, 이름, 역할 기준으로 검색할 수 있습니다.</p>
              </div>

              <div class="flex items-center gap-2">
                <div class="relative w-80">
                  <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 text-sm"></i>

                  <input
                    type="text"
                    id="searchInput" 
                    onkeydown="if(event.key === 'Enter') applyFilters();"
                    placeholder="검색어를 입력하세요"
                    class="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#00853D]/30 focus:border-[#00853D] outline-none transition-all">
                </div>

                <button
                  type="button"
                  onclick="applyFilters()"
                  class="px-5 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium hover:bg-[#006B31] transition-colors">
                  조회
                </button>

                <button
                  type="button"
                  onclick="resetFilters()"
                  class="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg text-sm font-medium hover:bg-gray-200 transition-colors">
                  초기화
                </button>
              </div>

            </div>
          </div>
        </div>

        <!-- 직원 테이블 -->
        <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">

          <div class="overflow-x-auto">
            <table class="w-full">

              <thead class="bg-gray-50 border-b border-gray-200">
                <tr>
                  <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">이름</th>
                  <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">역할</th>
                  <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">연락처</th>
                  <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">상태</th>
                  <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
                </tr>
              </thead>

              <tbody id="employeeTableBody" class="bg-white divide-y divide-gray-200">
              </tbody>

            </table>
          </div>

          <div id="pagination" class="flex justify-center items-center gap-2 p-4"></div>
        </div>

      </div>
    </main>
  </div>
</div>

<%@ include file="/branch/hr/employee/add_employee.jsp" %>
<%@ include file="/branch/hr/employee/modify_employee.jsp" %>
<!-- main: 목록 조회 / 검색 / 페이징 / 공통 메뉴 -->
<script>
    var selectedEmployee = null;
    var currentPage = 1;
    var pageSize = 10;

    var employees = [
        <c:forEach var="emp" items="${employeeList}" varStatus="st">
        {
            empNo: "${emp.empNo}",
            name: "${emp.name}",
            branchCode: "${emp.branchCode}",
            branchName: "${emp.branchName}",
            dept: "${emp.dept}",
            gradeCode: "${emp.gradeCode}",
            gradeName: "${emp.gradeName}",
            positionCode: "${emp.positionCode}",
            positionName: "${emp.positionName}",
            phone: "${emp.phone}",
            email: "${emp.email}",
            hireDate: "${emp.hireDate}",
            status: "${emp.status}"
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    window.addEventListener("DOMContentLoaded", function() {
        clearEmployeeTable();
        setupSidebarToggle();
        
        var addBtn = document.getElementById("openAddEmployeeModal");
        if (addBtn) {
            addBtn.addEventListener("click", showAddModal);
        }
    });
    
    function applyFilters() {
    	currentPage=1;
    	renderEmployees();
    }
    
    function resetFilters() {
    	document.getElementById("searchInput").value="";
    	currentPage = 1;
    	clearEmployeeTable();
    	document.getElementById("pagination").innerHTML = "";
    }
    
    function normalizeKeyword(value) {
        return String(value || "")
            .normalize("NFKC")
            .trim()
            .toLowerCase();
    }
    
    function renderEmployees() {
    	var searchTerm = normalizeKeyword(document.getElementById("searchInput").value);
        
        var filtered = employees.filter(function(employee) {
            return (
                String(employee.name || "").toLowerCase().includes(searchTerm) ||
                String(employee.empNo || "").toLowerCase().includes(searchTerm) ||
                String(employee.dept || "").toLowerCase().includes(searchTerm) ||
                String(employee.branchName || "").toLowerCase().includes(searchTerm) ||
                String(employee.positionName || "").toLowerCase().includes(searchTerm)
            );
        });

        var tbody = document.getElementById('employeeTableBody');

        if (filtered.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-8 text-center text-gray-500">검색 결과가 없습니다.</td></tr>';
            document.getElementById("pagination").innerHTML = "";
            return;
        }

        var totalPages = Math.ceil(filtered.length / pageSize);

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        var start = (currentPage - 1) * pageSize;
        var end = start + pageSize;
        var pageList = filtered.slice(start, end);

        tbody.innerHTML = pageList.map(function(emp) {
            var statusText = '';
            var statusClass = '';

            if (emp.status === 'ACTIVE') {
                statusText = '재직';
                statusClass = 'bg-green-100 text-green-700';
            } else if (emp.status === 'LEAVE') {
                statusText = '휴직';
                statusClass = 'bg-yellow-100 text-yellow-700';
            } else if (emp.status === 'RESIGNED') {
                statusText = '퇴사';
                statusClass = 'bg-red-100 text-red-700';
            } else {
                statusText = emp.status || '-';
                statusClass = 'bg-gray-100 text-gray-700';
            }

            return '<tr class="hover:bg-gray-50">' +
                '<td class="px-4 py-3 whitespace-nowrap">' +
                    '<div class="flex items-center gap-3">' +
                        '<div class="w-8 h-8 rounded-full bg-[#00853D] flex items-center justify-center text-white font-semibold text-xs">' +
                            (emp.name ? emp.name.charAt(0) : '-') +
                        '</div>' +
                        '<div>' +
                            '<div class="font-medium text-gray-900 text-sm">' + (emp.name || '-') + '</div>' +
                            '<div class="text-xs text-gray-500">사번: ' + (emp.empNo || '-') + '</div>' +
                        '</div>' +
                    '</div>' +
                '</td>' +

                '<td class="px-4 py-3 whitespace-nowrap">' +
                    '<div class="text-sm text-gray-900">' + (emp.positionName || '-') + '</div>' +
                '</td>' +

                '<td class="px-4 py-3 whitespace-nowrap">' +
                    '<div class="text-sm text-gray-900">' + (emp.phone || '-') + '</div>' +
                    '<div class="text-xs text-gray-500">' + (emp.email || '-') + '</div>' +
                '</td>' +

                '<td class="px-4 py-3 whitespace-nowrap">' +
                    '<span class="inline-flex px-2 py-0.5 text-xs font-medium rounded-full ' + statusClass + '">' +
                        statusText +
                    '</span>' +
                '</td>' +

                '<td class="px-4 py-3 whitespace-nowrap">' +
                    '<button onclick="openEmployeeModal(\'' + emp.empNo + '\')" class="text-blue-600 hover:text-blue-700 text-sm font-medium">' +
                        '상세보기' +
                    '</button>' +
                '</td>' +
            '</tr>';
        }).join('');

        renderPagination(totalPages);
    }

    function clearEmployeeTable() {
        var tbody = document.getElementById('employeeTableBody');
        tbody.innerHTML = '<tr><td colspan="5" class="px-6 py-8 text-center text-gray-500">조회 버튼을 눌러 직원을 검색하세요.</td></tr>';
    }

    function renderPagination(totalPages) {
        var pagination = document.getElementById("pagination");
        var html = "";

        var maxVisiblePages = 5;

        var startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
        var endPage = startPage + maxVisiblePages - 1;

        if (endPage > totalPages) {
            endPage = totalPages;
            startPage = Math.max(1, endPage - maxVisiblePages + 1);
        }

        // 이전 버튼
        html += '<button type="button" onclick="changePage(' + (currentPage - 1) + ')" ' +
                (currentPage === 1 ? 'disabled' : '') +
                ' class="w-9 h-9 border border-gray-300 rounded-lg flex items-center justify-center text-gray-600 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed transition-colors">' +
                    '<i class="fas fa-chevron-left text-xs"></i>' +
                '</button>';

        // 페이지 번호 버튼
        for (var i = startPage; i <= endPage; i++) {
            html += '<button type="button" onclick="changePage(' + i + ')" ' +
                    'class="w-9 h-9 border rounded-lg text-sm font-medium transition-colors ' +
                    (i === currentPage
                        ? 'bg-[#00853D] text-white border-[#00853D]'
                        : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50') +
                    '">' + i + '</button>';
        }

        // 다음 버튼
        html += '<button type="button" onclick="changePage(' + (currentPage + 1) + ')" ' +
                (currentPage === totalPages ? 'disabled' : '') +
                ' class="w-9 h-9 border border-gray-300 rounded-lg flex items-center justify-center text-gray-600 hover:bg-gray-50 disabled:opacity-40 disabled:cursor-not-allowed transition-colors">' +
                    '<i class="fas fa-chevron-right text-xs"></i>' +
                '</button>';

        pagination.innerHTML = html;
    }

    function changePage(page) {
        if (page < 1) {
            return;
        }

        currentPage = page;
        renderEmployees();
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
        applyEditRestrictions();
    }

    function changePage(page) {
        if (page < 1) return;

        currentPage = page;
        renderEmployees();
    }
    
    function showAddModal() {
    	document.getElementById("addModal").classList.remove("modal-hidden");
    }
    
    function closeAddModal() {
    	document.getElementById("addModal").classList.add("modal-hidden");
    }
    
    function saveEmployee() {
        var params = new URLSearchParams();

        params.append("action", "add");
        params.append("empNo", getValue("empNo"));
        params.append("name", getValue("name"));
        params.append("branchCode", getValue("branchCode"));
        params.append("dept", getValue("dept"));
        params.append("positionCode", getValue("positionCode"));
        params.append("phone", getValue("phone"));
        params.append("email", getValue("email"));
        params.append("hireDate", getValue("hireDate"));
        params.append("status", getValue("status"));

        fetch("<%= request.getContextPath() %>/branch/hr/main", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                alert("직원이 등록되었습니다.");
                closeAddModal();
                location.reload();
            } else {
                alert(data.message || "직원 등록에 실패했습니다.");
            }
        })
        .catch(function(error) {
            console.error(error);
            alert("서버 오류가 발생했습니다.");
        });
    }

    function openEmployeeModal(empNo) {
        selectedEmployee = employees.find(function(emp) {
            return String(emp.empNo) === String(empNo);
        });

        resetEditMode();

        var editModeBtn = document.getElementById("editModeBtn");

        if (editModeBtn) {
            if (selectedEmployee.positionCode === "POS_MGR" || selectedEmployee.positionCode === "POS_SUP") {
                editModeBtn.classList.add("hidden");
            } else {
                editModeBtn.classList.remove("hidden");
            }
        }
        
        setValue("editEmpNo", selectedEmployee.empNo);
        setValue("editEmpNoView", selectedEmployee.empNo);
        setValue("editName", selectedEmployee.name);
        setValue("editBranchCode", selectedEmployee.branchCode);
        setValue("editDept", selectedEmployee.dept);
        setValue("editPositionCode", selectedEmployee.positionCode);
        setValue("editPhone", selectedEmployee.phone);
        setValue("editEmail", selectedEmployee.email);
        setValue("editHireDate", selectedEmployee.hireDate);
        setValue("editStatus", selectedEmployee.status || "ACTIVE");

        document.getElementById("editModal").classList.remove("modal-hidden");
    }

    function closeEditModal() {
        document.getElementById("editModal").classList.add("modal-hidden");
    }

    function changeToEditMode() {
        document.querySelector("#editModal h3").innerText = "직원 정보 수정";
        var editModeBtn = document.getElementById("editModeBtn");
        var saveBtn = document.getElementById("saveBtn");
        
        if (editModeBtn) {
            editModeBtn.classList.add("hidden");
        }
        if (saveBtn) {
            saveBtn.classList.remove("hidden");
        }

        document.querySelectorAll(".editable-field").forEach(function(field) {
            if (field.tagName === "SELECT") {
                field.disabled = false;
            } else {
                field.readOnly = false;
            }

            field.classList.remove("bg-gray-100", "text-gray-500", "cursor-not-allowed");
            field.classList.add("bg-white", "text-gray-900");
        });
    }

    function resetEditMode() {
        document.querySelector("#editModal h3").innerText = "직원 상세 조회";
        var editModeBtn = document.getElementById("editModeBtn");
        if (editModeBtn) {
            editModeBtn.classList.remove("hidden");
        }
        document.getElementById("saveBtn").classList.add("hidden");

        document.querySelectorAll(".editable-field").forEach(function(field) {
            if (field.tagName === "SELECT") {
                field.disabled = true;
            } else {
                field.readOnly = true;
            }

            field.classList.remove("bg-white", "text-gray-900");
            field.classList.add("bg-gray-100", "text-gray-500", "cursor-not-allowed");
        });
    }

    function updateEmployee() {
        if (!selectedEmployee) return;

        var params = new URLSearchParams();

        params.append("action", "update");
        params.append("empNo", selectedEmployee.empNo);
        params.append("branchCode", getValue("editBranchCode"));
        params.append("dept", getValue("editDept"));
        params.append("positionCode", getValue("editPositionCode"));
        params.append("phone", getValue("editPhone"));
        params.append("email", getValue("editEmail"));
        params.append("status", getValue("editStatus"));

        fetch("<%= request.getContextPath() %>/branch/hr/main", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: params.toString()
        })
        .then(function(response) {
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                alert("직원 정보가 수정되었습니다.");
                closeEditModal();
                location.reload();
            } else {
                alert(data.message || "직원 수정에 실패했습니다.");
            }
        })
        .catch(function(error) {
            console.error(error);
            alert("서버 오류가 발생했습니다.");
        });
    }

    function getValue(id) {
        var el = document.getElementById(id);
        return el ? el.value : "";
    }

    function setValue(id, value) {
        var el = document.getElementById(id);
        if (el) {
            el.value = value || "";
        }
    }

    function setupSidebarToggle() {
        var sidebarToggle = document.getElementById("mobileMenuBtn");
        var sidebar = document.getElementById("sidebar");
        var backdrop = document.getElementById("sidebarBackdrop");

        if (sidebarToggle) {
            sidebarToggle.addEventListener("click", toggleSidebar);
        }

        if (backdrop) {
            backdrop.addEventListener("click", function() {
                sidebar.classList.add("-translate-x-full");
                backdrop.classList.add("hidden");
            });
        }
    }

    function toggleSidebar() {
        var sidebar = document.getElementById("sidebar");
        var backdrop = document.getElementById("sidebarBackdrop");

        if (sidebar) sidebar.classList.toggle("-translate-x-full");
        if (backdrop) backdrop.classList.toggle("hidden");
    }
</script>
</body>
</html>
