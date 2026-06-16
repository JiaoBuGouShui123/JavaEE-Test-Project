package com.example.service.impl;

import com.example.dao.RoleMapper;
import com.example.dao.UserMapper;
import com.example.dao.UserRoleMapper;
import com.example.entity.Role;
import com.example.entity.User;
import com.example.entity.UserRole;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private UserRoleMapper userRoleMapper;

    @Override
    public User login(String username, String password) {
        User user = userMapper.selectByUsername(username);
        if (user == null) {
            return null;
        }
        // 校验密码（明文比较，生产环境应使用 BCrypt）
        if (!password.equals(user.getPassword())) {
            return null;
        }
        // 校验账号状态
        if (user.getStatus() == null || user.getStatus() != 1) {
            return null;
        }
        // 清除密码，避免泄漏到前端
        user.setPassword(null);
        return user;
    }

    @Override
    public List<User> listAll() {
        List<User> users = userMapper.selectAll();
        for (User user : users) {
            user.setPassword(null);
        }
        return users;
    }

    @Override
    public User getById(Long userId) {
        User user = userMapper.selectById(userId);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public boolean create(User user) {
        user.setCreateTime(new Date());
        if (user.getStatus() == null) {
            user.setStatus(1); // 默认启用
        }
        return userMapper.insert(user) > 0;
    }

    @Override
    public boolean update(User user) {
        return userMapper.update(user) > 0;
    }

    @Override
    public boolean delete(Long userId) {
        return userMapper.deleteById(userId) > 0;
    }

    @Override
    public boolean updateStatus(Long userId, Integer status) {
        return userMapper.updateStatus(userId, status) > 0;
    }

    @Override
    public boolean isAdmin(Long userId) {
        List<Role> roles = roleMapper.selectByUserId(userId);
        for (Role role : roles) {
            if ("admin".equals(role.getRoleName())) {
                return true;
            }
        }
        return false;
    }

    @Override
    public List<Role> getUserRoles(Long userId) {
        return roleMapper.selectByUserId(userId);
    }

    @Override
    @Transactional
    public void assignRolesToUser(Long userId, List<Long> roleIds) {
        // 先删除用户所有角色，再批量插入
        userRoleMapper.deleteByUserId(userId);
        for (Long roleId : roleIds) {
            userRoleMapper.insert(new UserRole(userId, roleId));
        }
    }

    @Override
    public void removeRoleFromUser(Long userId, Long roleId) {
        userRoleMapper.delete(userId, roleId);
    }
}
