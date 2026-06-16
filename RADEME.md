# 简易权限管理系统 (RBAC)

这是一个学校实训项目，基于 SSM 框架的 RBAC 权限管理系统。

## 技术栈

| 层次 | 技术 |
|------|------|
| 框架 | Spring 5.3.24 + SpringMVC + MyBatis 3.5.13 |
| 数据库 | MySQL 8.0.33 + Druid 1.2.18 |
| 前端 | JSP + JSTL + HTML5 + CSS3 + JavaScript |
| 构建 | Maven (war) |
| Java | 1.8 |

## 功能模块

- **用户认证** — 登录/登出，Session 管理
- **用户管理** — 用户 CRUD、状态启用/禁用、角色分配
- **角色管理** — 角色 CRUD、权限分配
- **权限管理** — 权限 CRUD
- **权限拦截** — LoginInterceptor 拦截未登录请求

## 数据库

运行 `src/main/resources/sql/init.sql` 初始化数据库。

- 数据库名: `permission_db`
- 默认用户: 王一/123456（管理员）、李二/123456（普通用户）、张三/123456（普通用户）

## 启动

1. 执行 `init.sql` 初始化数据库
2. 修改 `jdbc.properties` 中的数据库连接信息
3. `mvn tomcat7:run` 或部署到 Tomcat
4. 访问 `http://localhost:8080/TeachProject`
