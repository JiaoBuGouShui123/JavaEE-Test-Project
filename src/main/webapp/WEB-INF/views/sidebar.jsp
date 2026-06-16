<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.entity.User" %>
<%
    User loginUser = (User) session.getAttribute("user");
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "home";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>简易权限管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="logo">RBAC 权限系统</div>
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/home" class="<%= "home".equals(currentPage) ? "active" : "" %>">
                <i>📊</i> 系统首页
            </a>
            <a href="${pageContext.request.contextPath}/users" class="<%= "user".equals(currentPage) ? "active" : "" %>">
                <i>👤</i> 用户管理
            </a>
            <a href="${pageContext.request.contextPath}/roles" class="<%= "role".equals(currentPage) ? "active" : "" %>">
                <i>🔑</i> 角色管理
            </a>
            <a href="${pageContext.request.contextPath}/permissions" class="<%= "perm".equals(currentPage) ? "active" : "" %>">
                <i>🔒</i> 权限管理
            </a>
        </nav>
        <div class="user-info">
            <div class="name"><%= loginUser.getUsername() %></div>
            <span class="role-tag" id="roleTag">加载中...</span>
        </div>
        <a class="btn-logout" href="javascript:void(0)" onclick="doLogout()">退出登录</a>
    </aside>
    <div class="main-content">
        <div class="top-bar">
            <span class="breadcrumb">
                <%= "home".equals(currentPage) ? "📊 系统首页" : "" %>
                <%= "user".equals(currentPage) ? "👤 用户管理" : "" %>
                <%= "role".equals(currentPage) ? "🔑 角色管理" : "" %>
                <%= "perm".equals(currentPage) ? "🔒 权限管理" : "" %>
            </span>
            <span class="welcome">欢迎您，<%= loginUser.getUsername() %></span>
        </div>
        <div class="content">