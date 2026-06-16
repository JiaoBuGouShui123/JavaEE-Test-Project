<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 根据是否已登录跳转到对应页面
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/home");
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>