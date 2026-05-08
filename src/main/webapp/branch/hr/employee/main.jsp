<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <script src="<%=request.getContextPath()%>/common/js/modal.js"></script>
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
        /* Custom date picker (sales style) */
        .custom-date-picker {
                position: fixed;
                width: 340px;
                background: #fff;
                border: 1px solid #d1d5db;
                border-radius: 0.75rem;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
                z-index: 9999;
                padding: 12px;
        }
        .custom-date-picker.hidden { display: none; }
        .custom-date-picker-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
        .custom-date-picker select { height: 30px; min-width: auto; width: auto; border-radius: 0.5rem; padding: 0 8px; font-size: 12px; font-weight: 600; background: #fff; }
        .custom-date-nav-btn { width: 30px; height: 30px; border-radius: 0.5rem; border: 1px solid #e5e7eb; color: #4b5563; background: #fff; cursor: pointer; }
        .custom-date-nav-btn:hover { background: #f3f4f6; }
        .custom-date-weekdays, .custom-date-days { display: grid; grid-template-columns: repeat(7, 1fr); gap: 4px; }
        .custom-date-weekdays div { text-align: center; font-size: 11px; font-weight: 700; color: #6b7280; padding: 4px 0; }
        .custom-date-day { height: 32px; border-radius: 0.5rem; border: none; background: #fff; font-size: 12px; cursor: pointer; color: #111827; }
        .custom-date-day:hover { background: #ecfdf3; color: #00853D; font-weight: 700; }
        .custom-date-day.other-month { color: #c4c4c4; }
        .custom-date-day.today { border: 1px solid #00853D; color: #00853D; font-weight: 700; }
        .custom-date-day.selected { background: #00853D; color: #fff; font-weight: 700; }
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
<!-- main: 직원 목록 조회 / 검색 / 페이징 / 등록 / 수정 / 공통 메뉴 -->
<script>
    /************************************************************
     * 1. 전역 변수
     ************************************************************/

    // 현재 상세 조회 또는 수정 중인 직원 정보
    var selectedEmployee = null;

    // 현재 페이지 번호
    var currentPage = 1;

    // 한 페이지에 보여줄 직원 수
    var pageSize = 10;


    /************************************************************
     * 2. 서버에서 전달받은 직원 데이터
     ************************************************************/

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


    /************************************************************
     * 3. 초기 실행
     ************************************************************/

    window.addEventListener("DOMContentLoaded", function () {
        // 처음 화면에서는 바로 목록을 보여주지 않고 안내 문구만 표시
        clearEmployeeTable();

        // 모바일 사이드바 이벤트 연결
        setupSidebarToggle();

        // 신규 알바생 등록 버튼 이벤트 연결
        var addBtn = document.getElementById("openAddEmployeeModal");

        if (addBtn) {
            addBtn.addEventListener("click", showAddModal);
        }
    });


    /************************************************************
     * 4. 검색 / 직원 목록 렌더링
     ************************************************************/

    // 조회 버튼 클릭 또는 Enter 입력 시 실행
    function applyFilters() {
        currentPage = 1;
        renderEmployees();
    }

    // 검색 조건 초기화
    function resetFilters() {
        document.getElementById("searchInput").value = "";

        currentPage = 1;

        clearEmployeeTable();
        clearPagination();
    }

    // 검색어 정규화
    // 전각 숫자/영문이 들어와도 반각으로 바꿔서 검색되도록 처리
    function normalizeKeyword(value) {
        return String(value || "")
            .normalize("NFKC")
            .trim()
            .toLowerCase();
    }

    // 현재 검색 조건에 맞는 직원 목록 반환
    function getFilteredEmployees() {
        var searchTerm = normalizeKeyword(document.getElementById("searchInput").value);

        return employees.filter(function (employee) {
            var name = normalizeKeyword(employee.name);
            var empNo = normalizeKeyword(employee.empNo);
            var dept = normalizeKeyword(employee.dept);
            var branchName = normalizeKeyword(employee.branchName);
            var positionName = normalizeKeyword(employee.positionName);

            // 검색어가 비어 있으면 전체 직원 조회
            if (searchTerm === "") {
                return true;
            }

            return name.includes(searchTerm) ||
                empNo.includes(searchTerm) ||
                dept.includes(searchTerm) ||
                branchName.includes(searchTerm) ||
                positionName.includes(searchTerm);
        });
    }

    // 직원 테이블 렌더링
    function renderEmployees() {
        var filtered = getFilteredEmployees();
        var tbody = document.getElementById("employeeTableBody");

        if (filtered.length === 0) {
            tbody.innerHTML =
                '<tr>' +
                    '<td colspan="5" class="px-6 py-8 text-center text-gray-500">' +
                        '검색 결과가 없습니다.' +
                    '</td>' +
                '</tr>';

            clearPagination();
            return;
        }

        var totalPages = Math.ceil(filtered.length / pageSize);

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        var start = (currentPage - 1) * pageSize;
        var end = start + pageSize;
        var pageList = filtered.slice(start, end);

        tbody.innerHTML = pageList.map(function (emp) {
            return makeEmployeeRow(emp);
        }).join("");

        renderPagination(totalPages);
    }

    // 직원 테이블 한 줄 HTML 생성
    function makeEmployeeRow(emp) {
        var statusInfo = getStatusInfo(emp.status);

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
                '<span class="inline-flex px-2 py-0.5 text-xs font-medium rounded-full ' + statusInfo.className + '">' +
                    statusInfo.text +
                '</span>' +
            '</td>' +

            '<td class="px-4 py-3 whitespace-nowrap">' +
                '<button onclick="openEmployeeModal(\'' + emp.empNo + '\')" class="text-blue-600 hover:text-blue-700 text-sm font-medium">' +
                    '상세보기' +
                '</button>' +
            '</td>' +
        '</tr>';
    }

    // 직원 상태값에 따른 표시명과 색상 반환
    function getStatusInfo(status) {
        if (status === "ACTIVE") {
            return {
                text: "재직",
                className: "bg-green-100 text-green-700"
            };
        }

        if (status === "LEAVE") {
            return {
                text: "휴직",
                className: "bg-yellow-100 text-yellow-700"
            };
        }

        if (status === "RESIGNED") {
            return {
                text: "퇴사",
                className: "bg-red-100 text-red-700"
            };
        }

        return {
            text: status || "-",
            className: "bg-gray-100 text-gray-700"
        };
    }

    // 최초 진입 또는 초기화 시 안내 문구 표시
    function clearEmployeeTable() {
        var tbody = document.getElementById("employeeTableBody");

        tbody.innerHTML =
            '<tr>' +
                '<td colspan="5" class="px-6 py-8 text-center text-gray-500">' +
                    '조회 버튼을 눌러 직원을 검색하세요.' +
                '</td>' +
            '</tr>';
    }


    /************************************************************
     * 5. 페이지네이션
     ************************************************************/

    // 페이지네이션 렌더링
    function renderPagination(totalPages) {
        var pagination = document.getElementById("pagination");
        var html = "";

        totalPages = parseInt(totalPages || 1);

        if (totalPages <= 1) {
            pagination.innerHTML = "";
            return;
        }

        var PAGE_SIZE = 5;

        var blockStart = Math.floor((currentPage - 1) / PAGE_SIZE) * PAGE_SIZE + 1;
        var blockEnd = Math.min(blockStart + PAGE_SIZE - 1, totalPages);

        var prevBlockPage = Math.max(1, blockStart - PAGE_SIZE);
        var nextBlockPage = Math.min(totalPages, blockEnd + 1);

        var base = "min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700";
        var active = "min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium bg-[#00853D] text-white";
        var arrow = "min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium border border-gray-300 hover:bg-gray-50 text-gray-700 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-white";

        // 맨 첫 페이지 버튼
        html += '<button type="button" class="' + arrow + '" onclick="changePage(1)" ' + (currentPage === 1 ? "disabled" : "") + '>';
        html += '<i class="fas fa-angles-left text-xs"></i>';
        html += '</button>';

        // 이전 페이지 블록 버튼
        html += '<button type="button" class="' + arrow + '" onclick="changePage(' + prevBlockPage + ')" ' + (blockStart === 1 ? "disabled" : "") + '>';
        html += '<i class="fas fa-chevron-left text-xs"></i>';
        html += '</button>';

        // 숫자 페이지 버튼
        for (var i = blockStart; i <= blockEnd; i++) {
            html += '<button type="button" class="' + (i === currentPage ? active : base) + '" onclick="changePage(' + i + ')">';
            html += i;
            html += '</button>';
        }

        // 다음 페이지 블록 버튼
        html += '<button type="button" class="' + arrow + '" onclick="changePage(' + nextBlockPage + ')" ' + (blockEnd === totalPages ? "disabled" : "") + '>';
        html += '<i class="fas fa-chevron-right text-xs"></i>';
        html += '</button>';

        // 맨 마지막 페이지 버튼
        html += '<button type="button" class="' + arrow + '" onclick="changePage(' + totalPages + ')" ' + (currentPage === totalPages ? "disabled" : "") + '>';
        html += '<i class="fas fa-angles-right text-xs"></i>';
        html += '</button>';

        pagination.innerHTML = html;
    }

    // 페이지 이동
    function changePage(page) {
        var filtered = getFilteredEmployees();
        var totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));

        page = parseInt(page || 1);

        if (page < 1) {
            page = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        currentPage = page;
        renderEmployees();
    }

    // 페이지네이션 영역 초기화
    function clearPagination() {
        var pagination = document.getElementById("pagination");

        if (pagination) {
            pagination.innerHTML = "";
        }
    }


    /************************************************************
     * 6. 신규 알바생 등록
     ************************************************************/

    // 신규 등록 모달 열기
    function showAddModal() {
        document.getElementById("addModal").classList.remove("modal-hidden");
    }

    // 신규 등록 모달 닫기
    function closeAddModal() {
        document.getElementById("addModal").classList.add("modal-hidden");
    }

    // 신규 직원 저장
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
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (data.success) {
                commonShowAlert("알림", "직원이 등록되었습니다.");
                closeAddModal();
                location.reload();
            } else {
                commonShowAlert("알림", data.message || "직원 등록에 실패했습니다.");
            }
        })
        .catch(function (error) {
            console.error(error);
            commonShowAlert("알림", "서버 오류가 발생했습니다.");
        });
    }


    /************************************************************
     * 7. 직원 상세 조회 / 수정
     ************************************************************/

    // 직원 상세 모달 열기
    function openEmployeeModal(empNo) {
        selectedEmployee = employees.find(function (emp) {
            return String(emp.empNo) === String(empNo);
        });

        if (!selectedEmployee) {
            commonShowAlert("알림", "직원 정보를 찾을 수 없습니다.");
            return;
        }

        resetEditMode();
        toggleEditButtonByPosition();
        setEmployeeDetailValues(selectedEmployee);

        document.getElementById("editModal").classList.remove("modal-hidden");
    }

    // 점장 / 매니저는 수정 버튼 숨김 처리
    function toggleEditButtonByPosition() {
        var editModeBtn = document.getElementById("editModeBtn");

        if (!editModeBtn || !selectedEmployee) {
            return;
        }

        if (
            selectedEmployee.positionCode === "POS_MGR" ||
            selectedEmployee.positionCode === "POS_SUP"
        ) {
            editModeBtn.classList.add("hidden");
        } else {
            editModeBtn.classList.remove("hidden");
        }
    }

    // 상세 모달에 직원 데이터 세팅
    function setEmployeeDetailValues(employee) {
        setValue("editEmpNo", employee.empNo);
        setValue("editEmpNoView", employee.empNo);
        setValue("editName", employee.name);
        setValue("editBranchCode", employee.branchCode);
        setValue("editDept", employee.dept);
        setValue("editPositionCode", employee.positionCode);
        setValue("editPhone", employee.phone);
        setValue("editEmail", employee.email);
        setValue("editHireDate", employee.hireDate);
        setValue("editStatus", employee.status || "ACTIVE");
    }

    // 상세 모달 닫기
    function closeEditModal() {
        document.getElementById("editModal").classList.add("modal-hidden");
    }

    // 상세 조회 모드에서 수정 모드로 변경
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

        document.querySelectorAll(".editable-field").forEach(function (field) {
            if (field.tagName === "SELECT") {
                field.disabled = false;
            } else {
                field.readOnly = false;
            }

            field.classList.remove("bg-gray-100", "text-gray-500", "cursor-not-allowed");
            field.classList.add("bg-white", "text-gray-900");
        });
    }

    // 수정 모드를 다시 상세 조회 모드로 초기화
    function resetEditMode() {
        document.querySelector("#editModal h3").innerText = "직원 상세 조회";

        var editModeBtn = document.getElementById("editModeBtn");
        var saveBtn = document.getElementById("saveBtn");

        if (editModeBtn) {
            editModeBtn.classList.remove("hidden");
        }

        if (saveBtn) {
            saveBtn.classList.add("hidden");
        }

        document.querySelectorAll(".editable-field").forEach(function (field) {
            if (field.tagName === "SELECT") {
                field.disabled = true;
            } else {
                field.readOnly = true;
            }

            field.classList.remove("bg-white", "text-gray-900");
            field.classList.add("bg-gray-100", "text-gray-500", "cursor-not-allowed");
        });
    }

    // 직원 수정 저장
    function updateEmployee() {
        if (!selectedEmployee) {
            return;
        }

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
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (data.success) {
                commonShowAlert("알림", "직원 정보가 수정되었습니다.");
                closeEditModal();
                location.reload();
            } else {
                commonShowAlert("알림", data.message || "직원 수정에 실패했습니다.");
            }
        })
        .catch(function (error) {
            console.error(error);
            commonShowAlert("알림", "서버 오류가 발생했습니다.");
        });
    }


    /************************************************************
     * 8. 공통 유틸 함수
     ************************************************************/

    // input/select 값 가져오기
    function getValue(id) {
        var el = document.getElementById(id);

        return el ? el.value : "";
    }

    // input/select 값 세팅하기
    function setValue(id, value) {
        var el = document.getElementById(id);

        if (el) {
            el.value = value || "";
        }
    }


    /************************************************************
     * 9. 사이드바
     ************************************************************/

    // 모바일 사이드바 토글 이벤트 연결
    function setupSidebarToggle() {
        var sidebarToggle = document.getElementById("mobileMenuBtn");
        var sidebar = document.getElementById("sidebar");
        var backdrop = document.getElementById("sidebarBackdrop");

        if (sidebarToggle) {
            sidebarToggle.addEventListener("click", toggleSidebar);
        }

        if (backdrop) {
            backdrop.addEventListener("click", function () {
                if (sidebar) {
                    sidebar.classList.add("-translate-x-full");
                }

                backdrop.classList.add("hidden");
            });
        }
    }

    // 모바일 사이드바 열기 / 닫기
    function toggleSidebar() {
        var sidebar = document.getElementById("sidebar");
        var backdrop = document.getElementById("sidebarBackdrop");

        if (sidebar) {
            sidebar.classList.toggle("-translate-x-full");
        }

        if (backdrop) {
            backdrop.classList.toggle("hidden");
        }
    }
</script>
<!-- custom date picker element -->
<div id="customDatePicker" class="custom-date-picker hidden" onclick="event.stopPropagation()">
    <div class="custom-date-picker-header">
        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(-1)">
            <i class="fas fa-chevron-left text-xs"></i>
        </button>

        <div style="display:flex;align-items:center;gap:8px;">
            <select id="customDatePickerYear" onchange="changeCustomPickerYearMonth()" class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold outline-none"></select>
            <select id="customDatePickerMonth" onchange="changeCustomPickerYearMonth()" class="px-2 py-1 border border-gray-300 rounded-lg text-xs font-semibold outline-none"></select>
        </div>

        <button type="button" class="custom-date-nav-btn" onclick="changeCustomPickerMonth(1)">
            <i class="fas fa-chevron-right text-xs"></i>
        </button>
    </div>

    <div class="custom-date-weekdays">
        <div>일</div>
        <div>월</div>
        <div>화</div>
        <div>수</div>
        <div>목</div>
        <div>금</div>
        <div>토</div>
    </div>

    <div id="customDatePickerDays" class="custom-date-days"></div>
</div>

<script>
// Custom date picker (shared for this page's modals)
(function(){
    function pad(n){ return String(n).padStart(2,'0'); }
    function parseDateLocal(dateStr) { if (!dateStr) return null; var parts = String(dateStr).split('-'); if (parts.length !== 3) return null; return new Date(Number(parts[0]), Number(parts[1]) - 1, Number(parts[2])); }
    function formatDateLocal(date) { return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate()); }

    var customDateTargetId = null;
    var customPickerDate = new Date();

    window.openCustomDatePicker = function(inputId, event) {
        if (event) event.stopPropagation();
        var input = document.getElementById(inputId); if (!input) return;
        // if not allowed to open while readonly, and input is readonly, skip
        if (input.readOnly && !input.hasAttribute('data-open-when-readonly') && !input.classList.contains('editable-field')) return;
        customDateTargetId = inputId; var selected = parseDateLocal(input.value); customPickerDate = selected || new Date(); renderCustomDatePicker(); positionCustomDatePicker(input);
        document.getElementById('customDatePicker').classList.remove('hidden');
    };

    window.changeCustomPickerMonth = function(amount) { customPickerDate.setMonth(customPickerDate.getMonth() + amount); renderCustomDatePicker(); };
    window.changeCustomPickerYearMonth = function() { var ys = document.getElementById('customDatePickerYear'); var ms = document.getElementById('customDatePickerMonth'); customPickerDate = new Date(Number(ys.value), Number(ms.value), 1); renderCustomDatePicker(); };

    function renderCustomPickerYearMonthSelect(year, month) {
        var yearSelect = document.getElementById('customDatePickerYear'); var monthSelect = document.getElementById('customDatePickerMonth'); var htmlY='';
        for (var y = year - 10; y <= year + 10; y++) htmlY += '<option value="'+y+'"' + (y===year? ' selected': '') + '>' + y + '년</option>';
        var htmlM=''; for (var m=0;m<12;m++) htmlM += '<option value="'+m+'"' + (m===month? ' selected': '') + '>' + (m+1) + '월</option>';
        yearSelect.innerHTML = htmlY; monthSelect.innerHTML = htmlM;
    }

    function renderCustomDatePicker() {
        var year = customPickerDate.getFullYear(); var month = customPickerDate.getMonth(); renderCustomPickerYearMonthSelect(year, month);
        var firstDay = new Date(year, month, 1); var lastDay = new Date(year, month+1, 0); var prevLast = new Date(year, month, 0);
        var startDay = firstDay.getDay(); var days = [];
        for (var i = startDay - 1; i >= 0; i--) days.push({ date: new Date(year, month - 1, prevLast.getDate() - i), currentMonth: false });
        for (var d = 1; d <= lastDay.getDate(); d++) days.push({ date: new Date(year, month, d), currentMonth: true });
        var nextDay = 1; while (days.length < 42) { days.push({ date: new Date(year, month+1, nextDay), currentMonth: false }); nextDay++; }
        var targetInput = customDateTargetId ? document.getElementById(customDateTargetId) : null; var selectedValue = targetInput ? targetInput.value : ''; var todayValue = formatDateLocal(new Date());
        var html=''; for (var j=0;j<days.length;j++){ var dateValue = formatDateLocal(days[j].date); var className='custom-date-day'; if (!days[j].currentMonth) className += ' other-month'; if (dateValue === todayValue) className += ' today'; if (dateValue === selectedValue) className += ' selected'; html += '<button type="button" class="' + className + '" onclick="selectCustomDate(\'' + dateValue + '\')">' + days[j].date.getDate() + '</button>'; }
        document.getElementById('customDatePickerDays').innerHTML = html;
    }

    window.selectCustomDate = function(dateValue) {
        if (!customDateTargetId) return; document.getElementById(customDateTargetId).value = dateValue;
        // keep simple: no cross-field constraints on this modal page
        closeCustomDatePicker();
    };

    function positionCustomDatePicker(input) {
        var picker = document.getElementById('customDatePicker'); var rect = input.getBoundingClientRect(); var pickerWidth = 340; var pickerHeight = 320;
        var top = rect.bottom + 6; var left = rect.left; picker.style.width = pickerWidth + 'px';
        if (left + pickerWidth > window.innerWidth) left = window.innerWidth - pickerWidth - 12;
        if (top + pickerHeight > window.innerHeight) top = rect.top - pickerHeight - 6;
        picker.style.top = top + 'px'; picker.style.left = left + 'px';
    }

    function closeCustomDatePicker() { var p = document.getElementById('customDatePicker'); if (p) p.classList.add('hidden'); customDateTargetId = null; }
    document.addEventListener('mousedown', function(event){ var picker = document.getElementById('customDatePicker'); if (!picker || picker.classList.contains('hidden')) return; if (picker.contains(event.target)) return; if (customDateTargetId && document.getElementById(customDateTargetId) && document.getElementById(customDateTargetId).contains(event.target)) return; closeCustomDatePicker(); });

    // make functions available for debugging if needed
    window.renderCustomDatePicker = renderCustomDatePicker;
})();
</script>
</body>
</html>
