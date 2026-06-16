package com.example.controller;

import com.example.dto.Result;
import com.example.entity.Permission;
import com.example.entity.Role;
import com.example.entity.User;
import com.example.service.RoleService;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/roles")
public class RoleController {

    @Autowired
    private RoleService roleService;

    @Autowired
    private UserService userService;

    private Result<Void> requireAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        if (!userService.isAdmin(currentUser.getUserId())) {
            return Result.error(403, "需要管理员权限");
        }
        return null;
    }

    /**
     * GET /api/roles — 获取角色列表（管理员）
     */
    @GetMapping
    public Result<List<Role>> listAll(HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;
        return Result.success(roleService.listAll());
    }

    /**
     * GET /api/roles/{id} — 获取角色详情（管理员）
     */
    @GetMapping("/{id}")
    public Result<Role> getById(@PathVariable Long id, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;
        Role role = roleService.getById(id);
        if (role == null) {
            return Result.error(404, "角色不存在");
        }
        return Result.success(role);
    }

    /**
     * POST /api/roles — 创建角色（管理员）
     */
    @PostMapping
    public Result<Void> create(@RequestBody Role role, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        if (role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            return Result.error(400, "角色名称不能为空");
        }

        roleService.create(role);
        return Result.success("角色创建成功", null);
    }

    /**
     * PUT /api/roles/{id} — 更新角色（管理员）
     */
    @PutMapping("/{id}")
    public Result<Void> update(@PathVariable Long id, @RequestBody Role role, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        role.setRoleId(id);
        roleService.update(role);
        return Result.success("角色更新成功", null);
    }

    /**
     * DELETE /api/roles/{id} — 删除角色（管理员）
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        roleService.delete(id);
        return Result.success("角色删除成功", null);
    }

    // ==================== 授权管理：角色权限 ====================

    /**
     * GET /api/roles/{roleId}/permissions — 获取角色的权限列表
     */
    @GetMapping("/{roleId}/permissions")
    public Result<List<Permission>> getPermissions(@PathVariable Long roleId, HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;
        return Result.success(roleService.getRolePermissions(roleId));
    }

    /**
     * POST /api/roles/{roleId}/permissions — 为角色分配权限
     * 请求体：{ "permIds": [1, 2, 3] }
     */
    @PostMapping("/{roleId}/permissions")
    public Result<Void> assignPermissions(@PathVariable Long roleId,
                                          @RequestBody Map<String, List<Long>> body,
                                          HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        List<Long> permIds = body.get("permIds");
        if (permIds == null || permIds.isEmpty()) {
            return Result.error(400, "permIds 不能为空");
        }

        roleService.assignPermissionsToRole(roleId, permIds);
        return Result.success("权限分配成功", null);
    }

    /**
     * DELETE /api/roles/{roleId}/permissions/{permId} — 移除角色的某个权限
     */
    @DeleteMapping("/{roleId}/permissions/{permId}")
    public Result<Void> removePermission(@PathVariable Long roleId,
                                         @PathVariable Long permId,
                                         HttpSession session) {
        Result<Void> check = requireAdmin(session);
        if (check != null) return check;

        roleService.removePermissionFromRole(roleId, permId);
        return Result.success("权限移除成功", null);
    }
}
