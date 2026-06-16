package com.example.dao;

import com.example.entity.UserRole;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户-角色关联 Mapper 接口
 */
public interface UserRoleMapper {

    int insert(UserRole userRole);

    int delete(@Param("userId") Long userId, @Param("roleId") Long roleId);

    int deleteByUserId(Long userId);

    List<Long> selectRoleIdsByUserId(Long userId);
}
