# 简易权限管理系统 (RBAC)

基于 SSM 框架的 RBAC 权限管理系统，学校 JavaEE 课程设计实训项目。

## 技术栈

| 层次 | 技术 |
|------|------|
| 框架 | Spring 5.3.24 + SpringMVC + MyBatis 3.5.13 |
| 数据库 | MySQL 8.0.33，连接池 Druid 1.2.18 |
| 前端 | JSP + JSTL + HTML5 + CSS3 + JavaScript (Fetch API) |
| 构建 | Maven (war)，Tomcat7 Maven Plugin |
| Java | 1.8 |

## 功能

- **用户认证**：登录/登出，Session 管理，LoginInterceptor 拦截未登录请求
- **用户管理**：CRUD、状态启用/禁用、角色分配（admin 专属）
- **角色管理**：CRUD、权限分配（admin 专属）
- **权限管理**：CRUD，普通用户仅看到已授权权限

## 项目结构

```
src/main/java/com/example/
├── controller/     AuthController, UserController, RoleController, PermissionController, PageController
├── service/        UserService, RoleService, PermissionService (impl/)
├── dao/            UserMapper, RoleMapper, PermissionMapper, UserRoleMapper, RolePermissionMapper
├── entity/         User, Role, Permission, UserRole, RolePermission
├── dto/            LoginDTO, Result
└── interceptor/    LoginInterceptor
src/main/resources/
├── mapper/         *Mapper.xml (5)
├── sql/            init.sql
├── applicationContext.xml, spring-mvc.xml, jdbc.properties
src/main/webapp/
└── WEB-INF/views/  login.jsp, home.jsp, user.jsp, role.jsp, perm.jsp, sidebar.jsp, footer.jsp
```

## 快速启动

```bash
# 1. 初始化数据库
mysql -u root -p < src/main/resources/sql/init.sql

# 2. 修改数据库连接（如需要）
# src/main/resources/jdbc.properties

# 3. 启动
mvn clean compile tomcat7:run

# 4. 访问
# http://localhost:8080/TeachProject
```

## 默认账号

| 用户名 | 密码 | 角色 |
|--------|------|------|
| 王一 | 123456 | admin（管理员） |
| 李二 | 123456 | user（普通用户） |
| 张三 | 123456 | user（普通用户） |

## 数据库

- 数据库名：`permission_db`
- 字符集：utf8mb4
- 5 张表：`user`, `role`, `permission`, `user_role`, `role_permission`
