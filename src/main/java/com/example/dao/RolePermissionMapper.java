package com.example.dao;

import com.example.entity.RolePermission;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 角色-权限关联 Mapper 接口
 */
public interface RolePermissionMapper {

    int insert(RolePermission rolePermission);

    int delete(@Param("roleId") Long roleId, @Param("permId") Long permId);

    int deleteByRoleId(Long roleId);

    List<Long> selectPermIdsByRoleId(Long roleId);
}
