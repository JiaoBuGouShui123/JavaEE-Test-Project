package com.example.controller;

import com.example.dto.Result;
import com.example.entity.Permission;
import com.example.entity.User;
import com.example.service.PermissionService;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
@RequestMapping("/api/permissions")
public class PermissionController {

    @Autowired
    private PermissionService permissionService;

    @Autowired
    private UserService userService;

    private User getCurrentUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    private Result<Void> requireAdmin(HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        if (!userService.isAdmin(currentUser.getUserId())) {
            return Result.error(403, "需要管理员权限");
        }
        return null;
    }

    /**
     * GET /api/permissions — 获取权限列表
     * 管理员：返回全部权限
     * 普通用户：返回已授权的权限
     */
    @GetMapping
    public Result<List<Permission>> listAll(HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        if (userService.isAdmin(currentUser.getUserId())) {
            // 管理员：查看全部权限
            return Result.success(permissionService.listAll());
        } else {
            // 普通用户：查看已授权的权限
            return Result.success(permissionService.listByUserId(currentUser.getUserId()));
        }
    }

    /**
     * GET /api/permissions/{id} — 获取权限详情
     */
    @GetMapping("/{id}")
    public Result<Permission> getById(@PathVariable Long id, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }

        Permission permission = permissionService.getById(id);
        if (permission == null) {
            return Result.error(404, "权限不存在");
        }
        return Result.success(permission);
    }

    /**
     * POST /api/permissions — 创建权限（管理员）
     */
    @PostMapping
    public Result<Void> create(@RequestBody Permission permission, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        if (permission.getPermName() == null || permission.getPermName().trim().isEmpty()) {
            return Result.error(400, "权限名称不能为空");
        }
        if (permission.getPermCode() == null || permission.getPermCode().trim().isEmpty()) {
            return Result.error(400, "权限编码不能为空");
        }

        permissionService.create(permission);
        return Result.success("权限创建成功", null);
    }

    /**
     * PUT /api/permissions/{id} — 更新权限（管理员）
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id,
                               @RequestBody Permission permission,
                               HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        permission.setPermId(id);
        permissionService.update(permission);
        return Result.success("权限更新成功", null);
    }

    /**
     * DELETE /api/permissions/{id} — 删除权限（管理员）
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        permissionService.delete(id);
        return Result.success("权限删除成功", null);
    }
}
