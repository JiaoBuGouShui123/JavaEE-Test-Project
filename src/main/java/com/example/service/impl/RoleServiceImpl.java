package com.example.service.impl;

import com.example.dao.PermissionMapper;
import com.example.dao.RoleMapper;
import com.example.dao.RolePermissionMapper;
import com.example.entity.Permission;
import com.example.entity.Role;
import com.example.entity.RolePermission;
import com.example.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private PermissionMapper permissionMapper;

    @Autowired
    private RolePermissionMapper rolePermissionMapper;

    @Override
    public List<Role> listAll() {
        return roleMapper.selectAll();
    }

    @Override
    public Role getById(Long roleId) {
        return roleMapper.selectById(roleId);
    }

    @Override
    public boolean create(Role role) {
        role.setCreateTime(new Date());
        return roleMapper.insert(role) > 0;
    }

    @Override
    public boolean update(Role role) {
        return roleMapper.update(role) > 0;
    }

    @Override
    public boolean delete(Long roleId) {
        return roleMapper.deleteById(roleId) > 0;
    }

    @Override
    public List<Permission> getRolePermissions(Long roleId) {
        return permissionMapper.selectByRoleId(roleId);
    }

    @Override
    @Transactional
    public void assignPermissionsToRole(Long roleId, List<Long> permIds) {
        // 先删除角色所有权限，再批量插入
        rolePermissionMapper.deleteByRoleId(roleId);
        for (Long permId : permIds) {
            rolePermissionMapper.insert(new RolePermission(roleId, permId));
        }
    }

    @Override
    public void removePermissionFromRole(Long roleId, Long permId) {
        rolePermissionMapper.delete(roleId, permId);
    }
}
