-- =============================================
-- 简易权限管理系统 - 数据库初始化脚本
-- 数据库名: permission_db
-- 字符集: utf8mb4
-- =============================================

CREATE DATABASE IF NOT EXISTS permission_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
USE permission_db;

-- =============================================
-- 1. 用户表
-- =============================================
DROP TABLE IF EXISTS user_role;
DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS permission;

CREATE TABLE user (
    user_id     BIGINT       AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(100) NOT NULL,
    email       VARCHAR(100),
    phone       VARCHAR(20),
    status      TINYINT      DEFAULT 1 COMMENT '1=启用, 0=禁用',
    create_time DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- =============================================
-- 2. 角色表
-- =============================================
CREATE TABLE role (
    role_id     BIGINT       AUTO_INCREMENT PRIMARY KEY,
    role_name   VARCHAR(50)  NOT NULL UNIQUE,
    description VARCHAR(200),
    create_time DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- =============================================
-- 3. 权限表
-- =============================================
CREATE TABLE permission (
    perm_id     BIGINT       AUTO_INCREMENT PRIMARY KEY,
    perm_name   VARCHAR(100) NOT NULL COMMENT '权限名称',
    perm_code   VARCHAR(100) NOT NULL UNIQUE COMMENT '权限标识，如 user:create',
    url         VARCHAR(200) COMMENT '对应资源路径',
    description VARCHAR(200) COMMENT '权限说明',
    create_time DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限/资源表';

-- =============================================
-- 4. 用户-角色关联表
-- =============================================
CREATE TABLE user_role (
    id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    UNIQUE KEY uk_user_role (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES role(role_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- =============================================
-- 5. 角色-权限关联表
-- =============================================
CREATE TABLE role_permission (
    id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT NOT NULL,
    perm_id BIGINT NOT NULL,
    UNIQUE KEY uk_role_perm (role_id, perm_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id) ON DELETE CASCADE,
    FOREIGN KEY (perm_id) REFERENCES permission(perm_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- =============================================
-- 6. 初始数据
-- =============================================

-- 初始用户：王一、李二、张三（密码均为 123456）
INSERT INTO user (username, password, email, phone, status) VALUES
('王一', '123456', 'wangyi@school.edu',  '13800000001', 1),
('李二', '123456', 'lier@school.edu',    '13800000002', 1),
('张三', '123456', 'zhangsan@school.edu', '13800000003', 1);

-- 初始角色：admin（管理员）、user（普通用户）
INSERT INTO role (role_name, description) VALUES
('admin', '系统管理员，拥有全部权限'),
('user',  '普通用户，拥有受限权限');

-- 初始权限
INSERT INTO permission (perm_name, perm_code, url, description) VALUES
('用户管理',          'user:manage',     '/users',         '用户增删改查'),
('角色管理',          'role:manage',     '/roles',         '角色增删改查'),
('权限管理',          'perm:manage',     '/permissions',   '权限增删改查');

-- 王一 = 管理员（user_id=1 → role_id=1）
INSERT INTO user_role (user_id, role_id) VALUES (1, 1);

-- 李二、张三 = 普通用户（user_id=2,3 → role_id=2）
INSERT INTO user_role (user_id, role_id) VALUES (2, 2);
INSERT INTO user_role (user_id, role_id) VALUES (3, 2);

-- 管理员角色拥有全部权限
INSERT INTO role_permission (role_id, perm_id) VALUES (1, 1);
INSERT INTO role_permission (role_id, perm_id) VALUES (1, 2);
INSERT INTO role_permission (role_id, perm_id) VALUES (1, 3);

-- 普通用户角色拥有部分权限（仅查看用户和权限 - 此处按文档要求授权）
INSERT INTO role_permission (role_id, perm_id) VALUES (2, 1);
INSERT INTO role_permission (role_id, perm_id) VALUES (2, 3);
