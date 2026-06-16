package com.example.controller;

import com.example.dto.LoginDTO;
import com.example.dto.Result;
import com.example.entity.Role;
import com.example.entity.User;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class AuthController {

    @Autowired
    private UserService userService;

    /**
     * 登录接口
     * POST /api/login
     * 请求体：{ "username": "王一", "password": "123456" }
     */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody LoginDTO loginDTO, HttpSession session) {
        // 参数校验
        if (loginDTO.getUsername() == null || loginDTO.getUsername().trim().isEmpty()) {
            return Result.error(400, "用户名不能为空");
        }
        if (loginDTO.getPassword() == null || loginDTO.getPassword().trim().isEmpty()) {
            return Result.error(400, "密码不能为空");
        }

        User user = userService.login(loginDTO.getUsername().trim(), loginDTO.getPassword().trim());
        if (user == null) {
            // 可能是用户名不存在、密码错误或账号被禁用
            return Result.error(401, "账号或密码错误");
        }

        // 将用户信息存入 Session
        session.setAttribute("user", user);

        // 获取用户角色列表
        List<Role> roles = userService.getUserRoles(user.getUserId());

        // 构造返回数据
        Map<String, Object> resultData = new HashMap<>();
        resultData.put("user", user);
        resultData.put("roles", roles);

        return Result.success("登录成功", resultData);
    }

    /**
     * 退出登录接口
     * POST /api/logout
     */
    @PostMapping("/logout")
    public Result<Void> logout(HttpSession session) {
        session.invalidate();
        return Result.success("已退出登录", null);
    }
}
