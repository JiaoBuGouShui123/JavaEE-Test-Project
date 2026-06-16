package com.example.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 登录拦截器：检查 /api/** 路径的请求是否已登录
 * 放行 /api/login 和 /api/logout
 */
public class LoginInterceptor implements HandlerInterceptor {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {
        String requestURI = request.getRequestURI();

        // 放行登录和退出接口
        if (requestURI.contains("/api/login") || requestURI.contains("/api/logout")) {
            return true;
        }

        // 只拦截 /api/ 路径
        if (!requestURI.startsWith(request.getContextPath() + "/api/") &&
            !requestURI.contains("/api/")) {
            return true;
        }

        // 检查 Session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> result = new HashMap<>();
            result.put("code", 401);
            result.put("message", "未登录，请先登录");
            result.put("data", null);
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return false;
        }

        return true;
    }
}
