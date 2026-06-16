package com.example.dao;

import com.example.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户 Mapper 接口
 */
public interface UserMapper {

    User selectById(Long userId);

    User selectByUsername(String username);

    List<User> selectAll();

    int insert(User user);

    int update(User user);

    int deleteById(Long userId);

    int updateStatus(@Param("userId") Long userId, @Param("status") Integer status);
}
