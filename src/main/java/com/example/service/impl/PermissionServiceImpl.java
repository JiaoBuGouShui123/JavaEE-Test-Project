package com.example.service.impl;

import com.example.dao.PermissionMapper;
import com.example.entity.Permission;
import com.example.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class PermissionServiceImpl implements PermissionService {

    @Autowired
    private PermissionMapper permissionMapper;

    @Override
    public List<Permission> listAll() {
        return permissionMapper.selectAll();
    }

    @Override
    public List<Permission> listByUserId(Long userId) {
        return permissionMapper.selectByUserId(userId);
    }

    @Override
    public Permission getById(Long permId) {
        return permissionMapper.selectById(permId);
    }

    @Override
    public boolean create(Permission permission) {
        permission.setCreateTime(new Date());
        return permissionMapper.insert(permission) > 0;
    }

    @Override
    public boolean update(Permission permission) {
        return permissionMapper.update(permission) > 0;
    }

    @Override
    public boolean delete(Long permId) {
        return permissionMapper.deleteById(permId) > 0;
    }
}
