package com.example.dao;

import com.example.entity.Role;

import java.util.List;

/**
 * 角色 Mapper 接口
 */
public interface RoleMapper {

    Role selectById(Long roleId);

    List<Role> selectAll();

    int insert(Role role);

    int update(Role role);

    int deleteById(Long roleId);

    List<Role> selectByUserId(Long userId);
}
