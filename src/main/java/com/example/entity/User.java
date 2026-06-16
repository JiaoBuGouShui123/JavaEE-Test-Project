package com.example.entity;

import java.util.Date;
import java.util.List;

/**
 * 用户实体类
 */
public class User {
    private Long userId;
    private String username;
    private String password;
    private String email;
    private String phone;
    private Integer status;      // 1=启用, 0=禁用
    private Date createTime;
    private List<Role> roles;    // 用户拥有的角色（仅用于展示，不持久化）

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public List<Role> getRoles() { return roles; }
    public void setRoles(List<Role> roles) { this.roles = roles; }
}
