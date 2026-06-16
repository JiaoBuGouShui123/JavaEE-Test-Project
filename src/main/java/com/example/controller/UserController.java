package com.example.controller;

import com.example.dto.Result;
import com.example.entity.Role;
import com.example.entity.User;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 获取当前登录用户（供 admin 检查使用）
     * 返回 null 表示未登录
     */
    private User getCurrentUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    /** 管理员权限检查，通过返回 null，失败返回错误 Result */
    @SuppressWarnings("unchecked")
    private <T> Result<T> requireAdmin(HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return (Result<T>) Result.error(401, "未登录");
        }
        if (!userService.isAdmin(currentUser.getUserId())) {
            return (Result<T>) Result.error(403, "需要管理员权限");
        }
        return null;
    }

    /**
     * GET /api/users — 获取用户列表（管理员）
     */
    @GetMapping
    public Result<List<User>> listAll(HttpSession session) {
        Result<List<User>> check = requireAdmin(session);
        if (check != null) return check;
        return Result.success(userService.listAll());
    }

    /**
     * GET /api/users/{id} — 获取用户详情（管理员）
     */
    @GetMapping("/{id}")
    public Result<User> getById(@PathVariable Long id, HttpSession session) {
        Result<User> check = requireAdmin(session);
        if (check != null) return check;
        User user = userService.getById(id);
        if (user == null) {
            return Result.error(404, "用户不存在");
        }
        return Result.success(user);
    }

    /**
     * POST /api/users — 创建用户（管理员）
     */
    @PostMapping
    public Result<Void> create(@RequestBody User user, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
            return Result.error(400, "用户名不能为空");
        }
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            return Result.error(400, "密码不能为空");
        }

        userService.create(user);
        return Result.success("用户创建成功", null);
    }

    /**
     * PUT /api/users/{id} — 更新用户（管理员）
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody User user, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        user.setUserId(id);
        userService.update(user);
        return Result.success("用户更新成功", null);
    }

    /**
     * DELETE /api/users/{id} — 删除用户（管理员）
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        // 不能删除自己
        User currentUser = getCurrentUser(session);
        if (currentUser.getUserId().equals(id)) {
            return Result.error(400, "不能删除自己的账号");
        }

        userService.delete(id);
        return Result.success("用户删除成功", null);
    }

    /**
     * PUT /api/users/{id}/status — 启用/禁用用户（管理员）
     */
    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id,
                                     @RequestBody Map<String, Integer> body,
                                     HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        Integer status = body.get("status");
        if (status == null || (status != 0 && status != 1)) {
            return Result.error(400, "status 必须为 0（禁用）或 1（启用）");
        }

        // 不能禁用自己
        User currentUser = getCurrentUser(session);
        if (currentUser.getUserId().equals(id)) {
            return Result.error(400, "不能禁用自己的账号");
        }

        userService.updateStatus(id, status);
        return Result.success(status == 1 ? "用户已启用" : "用户已禁用", null);
    }

    // ==================== 授权管理：用户角色 ====================

    /**
     * GET /api/users/{userId}/roles — 获取用户的角色列表
     */
    @GetMapping("/{userId}/roles")
    public Result<List<Role>> getUserRoles(@PathVariable Long userId, HttpSession session) {
        Result<List<Role>> check = requireAdmin(session);
        if (check != null) return check;
        return Result.success(userService.getUserRoles(userId));
    }

    /**
     * POST /api/users/{userId}/roles — 为用户分配角色
     * 请求体：{ "roleIds": [1, 2] }
     */
    @PostMapping("/{userId}/roles")
    public Result<Void> assignRoles(@PathVariable Long userId,
                                    @RequestBody Map<String, List<Long>> body,
                                    HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        List<Long> roleIds = body.get("roleIds");
        if (roleIds == null || roleIds.isEmpty()) {
            return Result.error(400, "roleIds 不能为空");
        }

        userService.assignRolesToUser(userId, roleIds);
        return Result.success("角色分配成功", null);
    }

    /**
     * DELETE /api/users/{userId}/roles/{roleId} — 移除用户的某个角色
     */
    @DeleteMapping("/{userId}/roles/{roleId}")
    public Result<Void> removeRole(@PathVariable Long userId,
                                   @PathVariable Long roleId,
                                   HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        userService.removeRoleFromUser(userId, roleId);
        return Result.success("角色移除成功", null);
    }
}
