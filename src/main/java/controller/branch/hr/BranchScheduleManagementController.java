package controller.branch.hr;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.AccountDTO;
import dto.branch.hr.BranchScheduleDTO;
import dto.branch.hr.EmployeeDTO;
import service.branch.BranchScheduleService;
import service.branch.BranchScheduleServiceImpl;

@WebServlet("/branch/hr/branchschedule")
public class BranchScheduleManagementController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BranchScheduleService scheduleService = new BranchScheduleServiceImpl();
       
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");
		
		try {
			int branchCode = loginUser.getBranchCode();
			BranchScheduleDTO schedule = new BranchScheduleDTO();
			schedule.setBranchCode(branchCode);
			List<BranchScheduleDTO> scdList = scheduleService.searchBranchScheduleList(schedule);
			List<EmployeeDTO> branchEmpList = scheduleService.selectBranchEmployee(branchCode);
			
			request.setAttribute("scheduleList", scdList);
			request.setAttribute("branchEmployeeList", branchEmpList);
			request.getRequestDispatcher("/branch/hr/schedule/main.jsp").forward(request, response);
 		} catch(Exception e) {
 			e.printStackTrace();
 			
 			if(!response.isCommitted()) {
 				request.setAttribute("errorMsg", e.getMessage());
				request.setAttribute("errorUrl", request.getRequestURI());
				request.getRequestDispatcher("/common/500.jsp").forward(request, response);
 			}
 		}
	}

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");		
		response.setContentType("application/json; charset=UTF-8");
		String action = request.getParameter("action");
		
		try {
			if ("add".equals(action)) {
				addSchedule(request, response);
	    	} else if ("modify".equals(action)) {
	    		modifySchedule(request, response);
	    	} else if ("delete".equals(action)) {
	    		deleteSchedule(request, response);
	    	} else {
	    		response.getWriter().write("{\"success\":false,\"message\":\"잘못된 요청입니다.\"}");
	    	}
		} catch(Exception e) {
	        e.printStackTrace();

	        String message = e.getMessage();

	        if (message == null || message.trim().equals("")) {
	            message = "일정 처리 중 오류가 발생했습니다.";
	        }

	        message = message
	                .replace("\\", "\\\\")
	                .replace("\"", "\\\"")
	                .replace("\r", "")
	                .replace("\n", "\\n");

	        response.getWriter().write("{\"success\":false,\"message\":\"" + message + "\"}");
	    }
	}
	
	private void addSchedule(HttpServletRequest request, HttpServletResponse response)
	        throws Exception {

	    HttpSession session = request.getSession(false);

	    if (session == null) {
	        response.getWriter().write("{\"success\":false,\"message\":\"로그인 정보가 없습니다.\"}");
	        return;
	    }

	    AccountDTO loginUser = (AccountDTO) session.getAttribute("loginUser");

	    if (loginUser == null) {
	        response.getWriter().write("{\"success\":false,\"message\":\"로그인 정보가 없습니다.\"}");
	        return;
	    }

	    String empNoParam = request.getParameter("empNo");
	    String empName = request.getParameter("empName");
	    String workType = request.getParameter("workType");
	    String startDateStr = request.getParameter("startDate");
	    String endDateStr = request.getParameter("endDate");
	    String startTimeStr = request.getParameter("startTime");
	    String endTimeStr = request.getParameter("endTime");
	    String isRepeatParam = request.getParameter("isRepeat");
	    String memo = request.getParameter("memo");
	    String[] weekdayRepeat = request.getParameterValues("weekdayRepeat");

	    if (empNoParam == null || empNoParam.equals("")) {
	        response.getWriter().write("{\"success\":false,\"message\":\"직원을 선택해주세요.\"}");
	        return;
	    }

	    if (startDateStr == null || startDateStr.equals("") ||
	        endDateStr == null || endDateStr.equals("")) {
	        response.getWriter().write("{\"success\":false,\"message\":\"기간을 선택해주세요.\"}");
	        return;
	    }

	    if (startTimeStr == null || startTimeStr.equals("") ||
	        endTimeStr == null || endTimeStr.equals("")) {
	        response.getWriter().write("{\"success\":false,\"message\":\"근무 시간을 입력해주세요.\"}");
	        return;
	    }

	    if (isRepeatParam == null || isRepeatParam.equals("")) {
	        response.getWriter().write("{\"success\":false,\"message\":\"반복 여부를 선택해주세요.\"}");
	        return;
	    }

	    int empNo = Integer.parseInt(empNoParam);
	    int branchCode = loginUser.getBranchCode();
	    int isRepeat = Integer.parseInt(isRepeatParam);

	    if (isRepeat == 2 && (weekdayRepeat == null || weekdayRepeat.length == 0)) {
	        response.getWriter().write("{\"success\":false,\"message\":\"반복 요일을 선택해주세요.\"}");
	        return;
	    }

	    LocalDate startDate = LocalDate.parse(startDateStr);
	    LocalDate endDate = LocalDate.parse(endDateStr);

	    BranchScheduleDTO schedule = new BranchScheduleDTO();

	    schedule.setEmpNo(empNo);
	    schedule.setEmpName(empName);
	    schedule.setBranchCode(branchCode);
	    schedule.setStartDate(Date.valueOf(startDate));
	    schedule.setEndDate(Date.valueOf(endDate));
	    schedule.setStartTime(Time.valueOf(startTimeStr + ":00"));
	    schedule.setEndTime(Time.valueOf(endTimeStr + ":00"));
	    schedule.setIsRepeat(isRepeat);
	    schedule.setMemo(memo);
	    schedule.setWorkType(workType);
	    schedule.setWeekdayRepeat(weekdayRepeat);

	    scheduleService.addBranchSchedule(schedule);

	    response.getWriter().write("{\"success\":true,\"message\":\"일정이 추가되었습니다.\"}");
	}

	private void modifySchedule(HttpServletRequest request, HttpServletResponse response)
	        throws Exception {

	    String repeatGroupId = request.getParameter("repeatGroupId");
	    Integer isRepeat = Integer.parseInt(request.getParameter("isRepeat"));

	    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

	    String workType = request.getParameter("workType");
	    String workDateStr = request.getParameter("workDate");
	    String startTimeStr = request.getParameter("startTime");
	    String endTimeStr = request.getParameter("endTime");
	    String memo = request.getParameter("memo");

	    if (startTimeStr.length() == 5) {
	        startTimeStr = startTimeStr + ":00";
	    }

	    if (endTimeStr.length() == 5) {
	        endTimeStr = endTimeStr + ":00";
	    }

	    BranchScheduleDTO schedule = new BranchScheduleDTO();

	    schedule.setScheduleId(scheduleId);
	    schedule.setIsRepeat(isRepeat);
	    schedule.setRepeatGroupId(repeatGroupId);
	    schedule.setWorkType(workType);
	    schedule.setWorkDate(Date.valueOf(workDateStr));
	    schedule.setStartTime(Time.valueOf(startTimeStr));
	    schedule.setEndTime(Time.valueOf(endTimeStr));
	    schedule.setMemo(memo);

	    scheduleService.modifySchedule(schedule);

	    response.getWriter().write("{\"success\":true,\"message\":\"일정이 수정되었습니다.\"}");
	}

	private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
	        throws Exception {

	    String scope = request.getParameter("scope");
	    String repeatGroupId = request.getParameter("repeatGroupId");

	    if ("ALL".equals(scope)) {
	        if (repeatGroupId == null || repeatGroupId.trim().equals("")) {
	            response.getWriter().write("{\"success\":false,\"message\":\"반복 그룹 정보를 찾을 수 없습니다.\"}");
	            return;
	        }

	        scheduleService.removeRepeatSchedule(repeatGroupId);

	        response.getWriter().write("{\"success\":true,\"message\":\"반복 일정 전체가 삭제되었습니다.\"}");
	        return;
	    }

	    int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
	    scheduleService.removeSchedule(scheduleId);

	    response.getWriter().write("{\"success\":true,\"message\":\"일정이 삭제되었습니다.\"}");
	}
}
