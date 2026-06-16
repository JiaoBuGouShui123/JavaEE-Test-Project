<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 — 简易权限管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>
<div class="login-wrapper">
    <div class="login-box">
        <h2>简易权限管理系统</h2>
        <p class="subtitle">Spring + SpringMVC + MyBatis</p>
        <div class="form-group">
            <label>用户名</label>
            <input type="text" id="username" placeholder="请输入用户名" autocomplete="off">
        </div>
        <div class="form-group">
            <label>密码</label>
            <input type="password" id="password" placeholder="请输入密码">
        </div>
        <button class="btn-login" onclick="doLogin()">登 录</button>
        <div class="error-msg" id="errorMsg"></div>
        <p style="text-align:center;margin-top:20px;font-size:12px;color:#bbb;">
            默认账号：王一 / 123456（管理员）｜李二 / 123456（普通用户）
        </p>
    </div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';

function doLogin() {
    var username = document.getElementById('username').value.trim();
    var password = document.getElementById('password').value.trim();
    var errorEl = document.getElementById('errorMsg');

    if (!username) { errorEl.textContent = '请输入用户名'; return; }
    if (!password) { errorEl.textContent = '请输入密码'; return; }
    errorEl.textContent = '';

    fetch(ctx + '/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ username: username, password: password })
    })
    .then(function(res) { return res.json(); })
    .then(function(json) {
        if (json.code === 200) {
            window.location.href = ctx + '/home';
        } else {
            errorEl.textContent = json.message || '登录失败';
        }
    })
    .catch(function() {
        errorEl.textContent = '网络错误，请稍后重试';
    });
}

// 回车键登录
document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') doLogin();
});
</script>
</body>
</html>