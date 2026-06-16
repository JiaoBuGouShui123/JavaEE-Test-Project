<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="sidebar.jsp" %>

<%-- ===== 角色管理 ===== --%>
<div class="card">
    <div class="card-header">
        <div>
            <h3>角色列表</h3>
            <span class="subtitle">管理系统角色及权限分配</span>
        </div>
        <button class="btn btn-primary" onclick="openCreateModal()">+ 新增角色</button>
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>角色名称</th><th>描述</th><th>创建时间</th><th>操作</th>
                </tr>
            </thead>
            <tbody id="roleTableBody"></tbody>
        </table>
    </div>
</div>

<%-- 新增/编辑角色模态框 --%>
<div class="modal-overlay" id="modalRole">
    <div class="modal">
        <div class="modal-header">
            <h4 id="modalRoleTitle">新增角色</h4>
            <button class="modal-close" onclick="closeModal('modalRole')">&times;</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editRoleId">
            <div class="form-group">
                <label>角色名称 <span style="color:red">*</span></label>
                <input type="text" id="fRoleName" placeholder="请输入角色名称">
            </div>
            <div class="form-group">
                <label>描述</label>
                <textarea id="fRoleDesc" placeholder="请输入角色描述"></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-default" onclick="closeModal('modalRole')">取消</button>
            <button class="btn btn-primary" onclick="saveRole()">保存</button>
        </div>
    </div>
</div>

<%-- 权限分配模态框 --%>
<div class="modal-overlay" id="modalRolePerm">
    <div class="modal small">
        <div class="modal-header">
            <h4>分配权限</h4>
            <button class="modal-close" onclick="closeModal('modalRolePerm')">&times;</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="assignRoleId">
            <div class="checkbox-list" id="permCheckboxes"></div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-default" onclick="closeModal('modalRolePerm')">取消</button>
            <button class="btn btn-primary" onclick="saveRolePerms()">保存</button>
        </div>
    </div>
</div>

<script>
var allRoles = [];
function loadRoles() {
    apiGet(ctx + '/api/roles').then(function(res) {
        allRoles = res.data || [];
        renderRoles(allRoles);
    });
}
function renderRoles(list) {
    var html = '';
    list.forEach(function(r) {
        html += '<tr>';
        html += '<td>' + r.roleId + '</td>';
        html += '<td><strong>' + r.roleName + '</strong></td>';
        html += '<td>' + (r.description||'-') + '</td>';
        html += '<td>' + (r.createTime||'') + '</td>';
        html += '<td class="actions">';
        html += '<button class="btn btn-default btn-xs" onclick="openEditModal(' + r.roleId + ')">编辑</button>';
        html += '<button class="btn btn-default btn-xs" onclick="openPermModal(' + r.roleId + ')">权限</button>';
        html += '<button class="btn btn-danger btn-xs" onclick="deleteRole(' + r.roleId + ')">删除</button>';
        html += '</td></tr>';
    });
    document.getElementById('roleTableBody').innerHTML = html || '<tr><td colspan="5" style="text-align:center;color:#999;">暂无数据</td></tr>';
}
function openCreateModal() {
    document.getElementById('modalRoleTitle').textContent = '新增角色';
    document.getElementById('editRoleId').value = '';
    document.getElementById('fRoleName').value = '';
    document.getElementById('fRoleDesc').value = '';
    openModal('modalRole');
}
function openEditModal(id) {
    var r = allRoles.find(function(item){return item.roleId===id;});
    if(!r) return;
    document.getElementById('modalRoleTitle').textContent = '编辑角色';
    document.getElementById('editRoleId').value = r.roleId;
    document.getElementById('fRoleName').value = r.roleName||'';
    document.getElementById('fRoleDesc').value = r.description||'';
    openModal('modalRole');
}
function saveRole() {
    var id = document.getElementById('editRoleId').value;
    var data = {
        roleName: document.getElementById('fRoleName').value.trim(),
        description: document.getElementById('fRoleDesc').value.trim()
    };
    if (!data.roleName) { showToast('请输入角色名称','error'); return; }
    var promise = id ? apiPut(ctx+'/api/roles/'+id, data) : apiPost(ctx+'/api/roles', data);
    promise.then(function() {
        closeModal('modalRole');
        showToast(id?'角色更新成功':'角色创建成功');
        loadRoles();
    });
}
function deleteRole(id) {
    if (!confirm('确定要删除该角色吗？')) return;
    apiDelete(ctx + '/api/roles/' + id).then(function() {
        showToast('角色已删除');
        loadRoles();
    });
}
function openPermModal(roleId) {
    document.getElementById('assignRoleId').value = roleId;
    Promise.all([
        apiGet(ctx + '/api/permissions'),
        apiGet(ctx + '/api/roles/' + roleId + '/permissions')
    ]).then(function(results) {
        var allPerms = results[0].data || [];
        var rolePerms = results[1].data || [];
        var rolePermIds = rolePerms.map(function(p){return p.permId;});
        var html = '';
        allPerms.forEach(function(p) {
            var checked = rolePermIds.indexOf(p.permId) >= 0 ? ' checked' : '';
            html += '<label><input type="checkbox" value="' + p.permId + '"' + checked + '><span>' + p.permName + '</span><small style="color:#999"> - ' + (p.description||p.permCode) + '</small></label>';
        });
        document.getElementById('permCheckboxes').innerHTML = html || '<span style="color:#999;">暂无权限数据</span>';
        openModal('modalRolePerm');
    });
}
function saveRolePerms() {
    var roleId = document.getElementById('assignRoleId').value;
    var checks = document.querySelectorAll('#permCheckboxes input[type=checkbox]:checked');
    var permIds = [];
    checks.forEach(function(cb) { permIds.push(parseInt(cb.value)); });
    apiPost(ctx + '/api/roles/' + roleId + '/permissions', {permIds: permIds}).then(function() {
        closeModal('modalRolePerm');
        showToast('权限分配成功');
        loadRoles();
    });
}
loadRoles();
</script>

<%@ include file="footer.jsp" %>