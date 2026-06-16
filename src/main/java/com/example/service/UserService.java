package com.example.service;

import com.example.entity.Role;
import com.example.entity.User;

import java.util.List;

/**
 * 用户业务接口
 */
public interface UserService {

    /** 登录验证，成功返回用户（不含密码），失败返回 null */
    User login(String username, String password);

    List<User> listAll();

    User getById(Long userId);

    boolean create(User user);

    boolean update(User user);

    boolean delete(Long userId);

    boolean updateStatus(Long userId, Integer status);

    /** 判断用户是否拥有管理员角色 */
    boolean isAdmin(Long userId);

    List<Role> getUserRoles(Long userId);

    /** 为用户分配角色（先删后插，事务控制） */
    void assignRolesToUser(Long userId, List<Long> roleIds);

    /** 移除用户的某个角色 */
    void removeRoleFromUser(Long userId, Long roleId);
}
