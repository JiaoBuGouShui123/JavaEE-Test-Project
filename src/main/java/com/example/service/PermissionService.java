package com.example.service;

import com.example.entity.Permission;

import java.util.List;

/**
 * 权限业务接口
 */
public interface PermissionService {

    /** 管理员查看全部权限 */
    List<Permission> listAll();

    /** 普通用户查看已授权的权限 */
    List<Permission> listByUserId(Long userId);

    Permission getById(Long permId);

    boolean create(Permission permission);

    boolean update(Permission permission);

    boolean delete(Long permId);
}
