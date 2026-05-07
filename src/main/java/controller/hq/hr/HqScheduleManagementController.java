package controller.hq.hr;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.branch.hr.BranchScheduleDTO;
import dto.hq.hr.BranchOptionDTO;
import dto.hq.hr.EmployeeDTO;
import dto.hq.hr.HqScheduleDTO;
import service.BranchService;
import service.BranchServiceImpl;
import service.branch.BranchScheduleService;
import service.branch.BranchScheduleServiceImpl;
import service.hq.HqScheduleService;
import service.hq.HqScheduleServiceImpl;

@WebServlet("/hq/hr/hqschedule")
public class HqScheduleManagementController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private HqScheduleService scheduleService = new HqScheduleServiceImpl();
	private BranchScheduleService branchScheduleService = new BranchScheduleServiceImpl();
	private BranchService branchService = new BranchServiceImpl();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HqScheduleDTO schedule = new HqScheduleDTO();
			BranchScheduleDTO branchSchedule = new BranchScheduleDTO();
			List<BranchOptionDTO> branchNameList = branchService.searchBranchName();
			List<HqScheduleDTO> scdList = scheduleService.searchScheduleList(schedule);
			List<BranchScheduleDTO> branchscdList = branchScheduleService.searchBranchScheduleList(branchSchedule);
			List<EmployeeDTO> hqEmpList = scheduleService.selectHqEmployee();
			
			request.setAttribute("branchNameList", branchNameList);
			request.setAttribute("scheduleList", scdList);
			request.setAttribute("hqEmployeeList", hqEmpList);
			request.setAttribute("branchScheduleList", branchscdList);
			request.getRequestDispatcher("/hq/hr/employee-schedule-management.jsp").forward(request, response);
			return;
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
			if("add".equals(action)) {
				addSchedule(request,response);
			} else if("update".equals(action)) {
				updateSchedule(request,response);
			} else if("delete".equals(action)) {
				deleteSchedule(request,response);
			} else {
				response.getWriter().write("{\"success\":false,\"message\":\"잘못된 요청입니다.\"}");
			}
		} catch(Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().write("{\"success\":false,\"message\":\"서버 오류\"}");
		}
	}
	
	private void addSchedule(HttpServletRequest request, HttpServletResponse response)
	        throws Exception {

	    HqScheduleDTO schedule = new HqScheduleDTO();

	    schedule.setEmpNo(Integer.parseInt(request.getParameter("empNo")));
	    schedule.setBranchCode(Integer.parseInt(request.getParameter("branchCode")));
	    schedule.setStartDay(java.sql.Date.valueOf(request.getParameter("startDay")));
	    schedule.setEndDay(java.sql.Date.valueOf(request.getParameter("endDay")));
	    schedule.setMemo(request.getParameter("memo"));
	    schedule.setWorkType(request.getParameter("workType"));

	    scheduleService.addSchedule(schedule);

	    response.getWriter().write("{\"success\":true,\"message\":\"일정이 등록되었습니다.\"}");
	}

	private void updateSchedule(HttpServletRequest request, HttpServletResponse response)
	        throws Exception {
		String scheduleIdStr = request.getParameter("scheduleId");
	    String startDayStr = request.getParameter("startDay");
	    String endDayStr = request.getParameter("endDay");
	    String workType = request.getParameter("workType");

	    if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
	        response.getWriter().write("{\"success\":false,\"message\":\"일정 번호가 없습니다.\"}");
	        return;
	    }

	    if (startDayStr == null || startDayStr.isEmpty() || endDayStr == null || endDayStr.isEmpty()) {
	        response.getWriter().write("{\"success\":false,\"message\":\"시작 날짜와 종료 날짜를 입력해주세요.\"}");
	        return;
	    }

	    if (workType == null || workType.isEmpty()) {
	        response.getWriter().write("{\"success\":false,\"message\":\"근무 유형을 선택해주세요.\"}");
	        return;
	    }

	    HqScheduleDTO schedule = new HqScheduleDTO();

	    schedule.setScheduleId(Integer.parseInt(request.getParameter("scheduleId")));
	    schedule.setStartDay(java.sql.Date.valueOf(request.getParameter("startDay")));
	    schedule.setEndDay(java.sql.Date.valueOf(request.getParameter("endDay")));
	    schedule.setMemo(request.getParameter("memo"));
	    schedule.setWorkType(request.getParameter("workType"));

	    scheduleService.modifySchedule(schedule);

	    response.getWriter().write("{\"success\":true,\"message\":\"일정이 수정되었습니다.\"}");
	}
	
	private void deleteSchedule(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		Integer scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

		scheduleService.removeSchedule(scheduleId);

		response.getWriter().write("{\"success\":true,\"message\":\"일정이 삭제되었습니다.\"}");
	}
}
