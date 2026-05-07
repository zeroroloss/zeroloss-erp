package controller.branch.inbound;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/branch/inbound/history")
public class InboundHistoryController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LocalDate today = LocalDate.now();
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");

		if (startDate == null || startDate.isBlank()) {
			startDate = today.withDayOfMonth(1).format(DATE_FORMATTER);
		}
		if (endDate == null || endDate.isBlank()) {
			endDate = today.withDayOfMonth(today.lengthOfMonth()).format(DATE_FORMATTER);
		}

		request.setAttribute("startDate", startDate);
		request.setAttribute("endDate", endDate);
		request.getRequestDispatcher("/branch/inbound/history.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}