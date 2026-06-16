package com.example.service;

import com.example.entity.Permission;
import com.example.entity.Role;

import java.util.List;

/**
 * 角色业务接口
 */
public interface RoleService {

    List<Role> listAll();

    Role getById(Long roleId);

    boolean create(Role role);

    boolean update(Role role);

    boolean delete(Long roleId);

    List<Permission> getRolePermissions(Long roleId);

    /** 为角色分配权限（先删后插，事务控制） */
    void assignPermissionsToRole(Long roleId, List<Long> permIds);

    /** 移除角色的某个权限 */
    void removePermissionFromRole(Long roleId, Long permId);
}
