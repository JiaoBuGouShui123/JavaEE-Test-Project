/**
 * 简易权限管理系统 - 公共 JS 工具
 */

// ===== AJAX 封装 =====
function apiGet(url) {
    return fetch(url, { credentials: 'same-origin' }).then(handleResponse);
}
function apiPost(url, data) {
    return fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify(data)
    }).then(handleResponse);
}
function apiPut(url, data) {
    return fetch(url, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify(data)
    }).then(handleResponse);
}
function apiDelete(url) {
    return fetch(url, {
        method: 'DELETE',
        credentials: 'same-origin'
    }).then(handleResponse);
}

function handleResponse(res) {
    return res.json().then(function(json) {
        if (json.code === 401) {
            window.location.href = '/TeachProject/login';
            return Promise.reject(json);
        }
        if (json.code !== 200) {
            showToast(json.message || '操作失败', 'error');
            return Promise.reject(json);
        }
        return json;
    });
}

// ===== Toast 提示 =====
var toastTimer = null;
function showToast(msg, type) {
    type = type || 'success';
    var existing = document.querySelector('.toast');
    if (existing) existing.remove();
    if (toastTimer) clearTimeout(toastTimer);
    var div = document.createElement('div');
    div.className = 'toast toast-' + type;
    div.textContent = msg;
    document.body.appendChild(div);
    toastTimer = setTimeout(function() { div.remove(); }, 2500);
}

// ===== 模态框 =====
function openModal(id) {
    document.getElementById(id).classList.add('active');
}
function closeModal(id) {
    document.getElementById(id).classList.remove('active');
}
// 点击遮罩关闭
document.addEventListener('click', function(e) {
    if (e.target.classList.contains('modal-overlay') && e.target.classList.contains('active')) {
        e.target.classList.remove('active');
    }
});

// ===== 登出 =====
function doLogout() {
    apiPost('/TeachProject/api/logout').then(function() {
        window.location.href = '/TeachProject/login';
    }).catch(function() {
        window.location.href = '/TeachProject/login';
    });
}

// ===== 获取当前用户信息 =====
var currentUser = null;
var currentRoles = [];

function loadCurrentUser() {
    return apiGet('/TeachProject/api/users').then(function(res) {
        // 尝试获取当前用户：从侧边栏已有的信息推断
        // 实际上需要从 session 获取，这里通过 GET /api/permissions 验证登录状态
        return apiGet('/TeachProject/api/permissions');
    }).then(function(res) {
        return res; // 返回权限数据用于判断是否 admin
    }).catch(function(err) {
        if (err.code === 401) {
            window.location.href = '/TeachProject/login';
        }
    });
}