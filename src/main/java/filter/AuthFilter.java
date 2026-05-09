package filter;

import java.io.IOException;
import dto.AccountDTO;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();
        String path = uri.substring(ctx.length());

        // 예외 경로 (로그인, 에러, 정적자원, 공개 페이지 등)
        if (isExemptPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("accountId") != null;

        if (!loggedIn) {
            sendLoginRequired(resp, ctx, path);
            return;
        }

        AccountDTO loginUser = null;
        Object loginUserObject = session.getAttribute("loginUser");
        if (loginUserObject instanceof AccountDTO) {
            loginUser = (AccountDTO) loginUserObject;
        }

        boolean isHqUser = loginUser != null && loginUser.getHqId() != null;
        boolean isBranchUser = loginUser != null && loginUser.getHqId() == null && loginUser.getBranchCode() != null;

        // 본사 계정으로 지점페이지 X
        if (isHqPath(path) && !isHqUser) {
            sendForbidden(resp, ctx, path, isBranchUser ? "/branch/main/home" : "/login");
            return;
        }
        // 지점 계정으로 본사페이지 X
        if (isBranchPath(path) && !isBranchUser) {
            sendForbidden(resp, ctx, path, isHqUser ? "/hq/main/home" : "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    /**
     * 필터 예외 경로 확인
     */
    private boolean isExemptPath(String path) {
        // 로그인 엔드포인트
        if (path.equals("/login") || path.equals("/common/login") || path.equals("/common/login.jsp")) {
            return true;
        }
        // 에러 페이지
        if (path.startsWith("/common/")) {
            return true;
        }
        // 정적 자원
        if (path.startsWith("/upload/") || path.startsWith("/css/") || path.startsWith("/js/") 
            || path.startsWith("/images/") || path.startsWith("/lib/") || path.startsWith("/icons/")
            || path.startsWith("/static/") || path.startsWith("/META-INF/")) {
            return true;
        }
        // 파일 확장자로 정적 자원 판별 (css, js, png, jpg, gif, ico, woff 등)
        if (path.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$")) {
            return true;
        }
        return false;
    }

    private boolean isApiPath(String path) {
        return path.startsWith("/api/");
    }

    private boolean isHqPath(String path) {
        return path.startsWith("/hq/") || path.startsWith("/api/hq/");
    }

    private boolean isBranchPath(String path) {
        return path.startsWith("/branch/") || path.startsWith("/api/branch/");
    }

    private void sendLoginRequired(HttpServletResponse resp, String ctx, String path) throws IOException {
        if (isApiPath(path)) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"로그인이 필요합니다.\"}");
            return;
        }

        resp.sendRedirect(ctx + "/login");
    }

    private void sendForbidden(HttpServletResponse resp, String ctx, String path, String redirectPath) throws IOException {
        if (isApiPath(path)) {
            resp.setContentType("application/json; charset=UTF-8");
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"권한이 없습니다.\"}");
            return;
        }

        resp.sendRedirect(ctx + redirectPath);
    }

    @Override
    public void destroy() {
    }
}
