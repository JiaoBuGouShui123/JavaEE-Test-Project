package com.example.dao;

import com.example.entity.Permission;

import java.util.List;

/**
 * 权限 Mapper 接口
 */
public interface PermissionMapper {

    Permission selectById(Long permId);

    List<Permission> selectAll();

    int insert(Permission permission);

    int update(Permission permission);

    int deleteById(Long permId);

    /** 根据用户ID查询已授权权限（通过 用户→用户角色→角色权限→权限 关联链） */
    List<Permission> selectByUserId(Long userId);

    /** 根据角色ID查询权限 */
    List<Permission> selectByRoleId(Long roleId);
}
