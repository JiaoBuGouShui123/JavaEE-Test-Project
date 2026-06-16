<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="sidebar.jsp" %>

<%-- ===== 用户管理 ===== --%>
<div class="card">
    <div class="card-header">
        <div>
            <h3>用户列表</h3>
            <span class="subtitle">管理系统用户账号及角色授权</span>
        </div>
        <button class="btn btn-primary" onclick="openCreateModal()">+ 新增用户</button>
    </div>

    <div class="search-bar">
        <input type="text" id="searchUser" placeholder="🔍 搜索用户名或邮箱..." oninput="filterUsers()">
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>用户名</th><th>角色</th><th>邮箱</th><th>电话</th><th>状态</th><th>创建时间</th><th>操作</th>
                </tr>
            </thead>
            <tbody id="userTableBody"></tbody>
        </table>
    </div>
</div>

<%-- 新增/编辑用户模态框 --%>
<div class="modal-overlay" id="modalUser">
    <div class="modal">
        <div class="modal-header">
            <h4 id="modalUserTitle">新增用户</h4>
            <button class="modal-close" onclick="closeModal('modalUser')">&times;</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editUserId">
            <div class="form-group">
                <label>用户名 <span style="color:red">*</span></label>
                <input type="text" id="fUsername" placeholder="请输入用户名">
            </div>
            <div class="form-group" id="pwdGroup">
                <label>密码 <span style="color:red">*</span></label>
                <input type="password" id="fPassword" placeholder="请输入密码">
            </div>
            <div class="form-group">
                <label>邮箱</label>
                <input type="text" id="fEmail" placeholder="请输入邮箱">
            </div>
            <div class="form-group">
                <label>电话</label>
                <input type="text" id="fPhone" placeholder="请输入电话">
            </div>
            <div class="form-group">
                <label>状态</label>
                <select id="fStatus">
                    <option value="1">启用</option>
                    <option value="0">禁用</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-default" onclick="closeModal('modalUser')">取消</button>
            <button class="btn btn-primary" onclick="saveUser()">保存</button>
        </div>
    </div>
</div>

<%-- 角色分配模态框 --%>
<div class="modal-overlay" id="modalUserRole">
    <div class="modal small">
        <div class="modal-header">
            <h4>分配角色</h4>
            <button class="modal-close" onclick="closeModal('modalUserRole')">&times;</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="assignUserId">
            <div class="checkbox-list" id="roleCheckboxes"></div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-default" onclick="closeModal('modalUserRole')">取消</button>
            <button class="btn btn-primary" onclick="saveUserRoles()">保存</button>
        </div>
    </div>
</div>

<script>
var allUsers = [];
function loadUsers() {
    apiGet(ctx + '/api/users').then(function(res) {
        allUsers = res.data || [];
        renderUsers(allUsers);
    });
}
function renderUsers(list) {
    var html = '';
    list.forEach(function(u) {
        html += '<tr>';
        html += '<td>' + u.userId + '</td>';
        html += '<td>' + u.username + '</td>';
        // 角色列：显示用户拥有的角色名称
        var rolesHtml = '';
        if (u.roles && u.roles.length > 0) {
            u.roles.forEach(function(r) {
                var isAdmin = r.roleName === 'admin';
                rolesHtml += '<span class="badge ' + (isAdmin ? 'badge-warning' : 'badge-info') + '" style="margin-right:4px;">' + r.roleName + '</span>';
            });
        } else {
            rolesHtml = '<span style="color:#999;">无角色</span>';
        }
        html += '<td>' + rolesHtml + '</td>';
        html += '<td>' + (u.email||'-') + '</td>';
        html += '<td>' + (u.phone||'-') + '</td>';
        html += '<td><span class="badge ' + (u.status===1?'badge-success':'badge-danger') + '">' + (u.status===1?'启用':'禁用') + '</span></td>';
        html += '<td>' + (u.createTime||'') + '</td>';
        html += '<td class="actions">';
        html += '<button class="btn btn-default btn-xs" onclick="openEditModal(' + u.userId + ')">编辑</button>';
        html += '<button class="btn btn-warning btn-xs" onclick="toggleStatus(' + u.userId + ',' + u.status + ')">' + (u.status===1?'禁用':'启用') + '</button>';
        html += '<button class="btn btn-default btn-xs" onclick="openRoleModal(' + u.userId + ')">角色</button>';
        html += '<button class="btn btn-danger btn-xs" onclick="deleteUser(' + u.userId + ')">删除</button>';
        html += '</td></tr>';
    });
    document.getElementById('userTableBody').innerHTML = html || '<tr><td colspan="8" style="text-align:center;color:#999;">暂无数据</td></tr>';
}
function filterUsers() {
    var kw = document.getElementById('searchUser').value.toLowerCase();
    var filtered = allUsers.filter(function(u) {
        return u.username.toLowerCase().indexOf(kw)>=0 || (u.email||'').toLowerCase().indexOf(kw)>=0;
    });
    renderUsers(filtered);
}
function openCreateModal() {
    document.getElementById('modalUserTitle').textContent = '新增用户';
    document.getElementById('editUserId').value = '';
    document.getElementById('fUsername').value = '';
    document.getElementById('fPassword').value = '';
    document.getElementById('fEmail').value = '';
    document.getElementById('fPhone').value = '';
    document.getElementById('fStatus').value = '1';
    document.getElementById('pwdGroup').style.display = '';
    openModal('modalUser');
}
function openEditModal(id) {
    var u = allUsers.find(function(item){return item.userId===id;});
    if(!u) return;
    document.getElementById('modalUserTitle').textContent = '编辑用户';
    document.getElementById('editUserId').value = u.userId;
    document.getElementById('fUsername').value = u.username||'';
    document.getElementById('fPassword').value = '';
    document.getElementById('fEmail').value = u.email||'';
    document.getElementById('fPhone').value = u.phone||'';
    document.getElementById('fStatus').value = u.status;
    document.getElementById('pwdGroup').style.display = 'none';
    openModal('modalUser');
}
function saveUser() {
    var id = document.getElementById('editUserId').value;
    var data = {
        username: document.getElementById('fUsername').value.trim(),
        password: document.getElementById('fPassword').value.trim(),
        email: document.getElementById('fEmail').value.trim(),
        phone: document.getElementById('fPhone').value.trim(),
        status: parseInt(document.getElementById('fStatus').value)
    };
    if (!data.username) { showToast('请输入用户名','error'); return; }
    if (!id && !data.password) { showToast('请输入密码','error'); return; }

    var promise = id ? apiPut(ctx+'/api/users/'+id, data) : apiPost(ctx+'/api/users', data);
    promise.then(function() {
        closeModal('modalUser');
        showToast(id?'用户更新成功':'用户创建成功');
        loadUsers();
    });
}
function deleteUser(id) {
    if (!confirm('确定要删除该用户吗？此操作不可恢复！')) return;
    apiDelete(ctx + '/api/users/' + id).then(function() {
        showToast('用户已删除');
        loadUsers();
    });
}
function toggleStatus(id, curStatus) {
    var newStatus = curStatus === 1 ? 0 : 1;
    var action = newStatus === 1 ? '启用' : '禁用';
    if (!confirm('确定要' + action + '该用户吗？')) return;
    apiPut(ctx + '/api/users/' + id + '/status', {status: newStatus}).then(function() {
        showToast('用户已' + action);
        loadUsers();
    });
}
function openRoleModal(userId) {
    document.getElementById('assignUserId').value = userId;
    // 加载所有角色和用户当前角色
    Promise.all([
        apiGet(ctx + '/api/roles'),
        apiGet(ctx + '/api/users/' + userId + '/roles')
    ]).then(function(results) {
        var allRoles = results[0].data || [];
        var userRoles = results[1].data || [];
        var userRoleIds = userRoles.map(function(r){return r.roleId;});
        var html = '';
        allRoles.forEach(function(r) {
            var checked = userRoleIds.indexOf(r.roleId) >= 0 ? ' checked' : '';
            html += '<label><input type="checkbox" value="' + r.roleId + '"' + checked + '><span>' + r.roleName + '</span><small style="color:#999"> - ' + (r.description||'') + '</small></label>';
        });
        document.getElementById('roleCheckboxes').innerHTML = html || '<span style="color:#999;">暂无角色数据</span>';
        openModal('modalUserRole');
    });
}
function saveUserRoles() {
    var userId = document.getElementById('assignUserId').value;
    var checks = document.querySelectorAll('#roleCheckboxes input[type=checkbox]:checked');
    var roleIds = [];
    checks.forEach(function(cb) { roleIds.push(parseInt(cb.value)); });
    apiPost(ctx + '/api/users/' + userId + '/roles', {roleIds: roleIds}).then(function() {
        closeModal('modalUserRole');
        showToast('角色分配成功');
        loadUsers();
    });
}
loadUsers();
</script>

<%@ include file="footer.jsp" %>