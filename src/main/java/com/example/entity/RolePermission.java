package com.example.entity;

/**
 * 角色-权限关联实体
 */
public class RolePermission {
    private Long id;
    private Long roleId;
    private Long permId;

    public RolePermission() {}

    public RolePermission(Long roleId, Long permId) {
        this.roleId = roleId;
        this.permId = permId;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getRoleId() { return roleId; }
    public void setRoleId(Long roleId) { this.roleId = roleId; }

    public Long getPermId() { return permId; }
    public void setPermId(Long permId) { this.permId = permId; }
}
