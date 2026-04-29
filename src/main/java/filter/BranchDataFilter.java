package filter;

import dto.BranchDTO;
import service.BranchService;
import service.BranchServiceImpl;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

// 본사와 직영점 문의사항 페이지 모두에 필터를 적용
@WebFilter({"/hq/support/headquarters-inquiries.jsp", "/branch/support/branch-inquiries.jsp"})
public class BranchDataFilter implements Filter {

    private final BranchService branchService = new BranchServiceImpl();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;

        if (req.getAttribute("branches") == null) {
            try {
                List<BranchDTO> branches = branchService.getAllBranches();
                req.setAttribute("branches", branches);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Not needed
    }

    @Override
    public void destroy() {
        // Not needed
    }
}
