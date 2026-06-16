        </div><!-- .content -->
    </div><!-- .main-content -->
</div><!-- .layout -->

<script>
var ctx = '${pageContext.request.contextPath}';

// Toast 提示
var _toastTimer = null;
function showToast(msg, type) {
    type = type || 'success';
    var old = document.querySelector('.toast');
    if (old) old.remove();
    if (_toastTimer) clearTimeout(_toastTimer);
    var div = document.createElement('div');
    div.className = 'toast toast-' + type;
    div.textContent = msg;
    document.body.appendChild(div);
    _toastTimer = setTimeout(function() { div.remove(); }, 2500);
}

// AJAX
function apiGet(url) {
    return fetch(url, {credentials:'same-origin'}).then(handleResp);
}
function apiPost(url, data) {
    return fetch(url, {method:'POST', headers:{'Content-Type':'application/json'}, credentials:'same-origin', body:JSON.stringify(data)}).then(handleResp);
}
function apiPut(url, data) {
    return fetch(url, {method:'PUT', headers:{'Content-Type':'application/json'}, credentials:'same-origin', body:JSON.stringify(data)}).then(handleResp);
}
function apiDelete(url) {
    return fetch(url, {method:'DELETE', credentials:'same-origin'}).then(handleResp);
}
function handleResp(res) {
    return res.json().then(function(json) {
        if (json.code === 401) { window.location.href = ctx + '/login'; return Promise.reject(json); }
        if (json.code !== 200) { showToast(json.message||'操作失败','error'); return Promise.reject(json); }
        return json;
    });
}

// 模态框
function openModal(id) { document.getElementById(id).classList.add('active'); }
function closeModal(id) { document.getElementById(id).classList.remove('active'); }

// 退出
function doLogout() {
    apiPost(ctx + '/api/logout', {}).then(function() {
        window.location.href = ctx + '/login';
    }).catch(function() {
        window.location.href = ctx + '/login';
    });
}

// 加载角色标签
fetch(ctx + '/api/roles').then(function(res) { return res.json(); }).then(function(json) {
    if (json.code === 200) { document.getElementById('roleTag').textContent = '管理员'; }
}).catch(function() { document.getElementById('roleTag').textContent = '普通用户'; });
</script>
</body>
</html>