package com.example.controller;

import com.example.entity.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 页面路由控制器 — 返回 JSP 视图
 */
@Controller
public class PageController {

    /**
     * 已登录则跳首页，否则去登录页
     */
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/home";
        }
        return "login";
    }

    /**
     * 首页 / 仪表盘
     */
    @GetMapping({"/", "/home"})
    public String homePage(HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        request.setAttribute("currentPage", "home");
        return "home";
    }

    /**
     * 用户管理页
     */
    @GetMapping("/users")
    public String usersPage(HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        request.setAttribute("currentPage", "user");
        return "user";
    }

    /**
     * 角色管理页
     */
    @GetMapping("/roles")
    public String rolesPage(HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        request.setAttribute("currentPage", "role");
        return "role";
    }

    /**
     * 权限管理页
     */
    @GetMapping("/permissions")
    public String permissionsPage(HttpSession session, HttpServletRequest request) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        request.setAttribute("currentPage", "perm");
        return "perm";
    }
}