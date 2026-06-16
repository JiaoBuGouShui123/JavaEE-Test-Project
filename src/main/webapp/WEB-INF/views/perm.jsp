<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="sidebar.jsp" %>

<%-- ===== 权限管理 ===== --%>
<div class="card">
    <div class="card-header">
        <div>
            <h3>权限列表</h3>
            <span class="subtitle">管理系统资源权限</span>
        </div>
        <button class="btn btn-primary" onclick="openCreateModal()">+ 新增权限</button>
    </div>

    <div class="table-wrapper">
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>权限名称</th><th>权限编码</th><th>资源路径</th><th>描述</th><th>创建时间</th><th>操作</th>
                </tr>
            </thead>
            <tbody id="permTableBody"></tbody>
        </table>
    </div>
</div>

<%-- 新增/编辑权限模态框 --%>
<div class="modal-overlay" id="modalPerm">
    <div class="modal">
        <div class="modal-header">
            <h4 id="modalPermTitle">新增权限</h4>
            <button class="modal-close" onclick="closeModal('modalPerm')">&times;</button>
        </div>
        <div class="modal-body">
            <input type="hidden" id="editPermId">
            <div class="form-group">
                <label>权限名称 <span style="color:red">*</span></label>
                <input type="text" id="fPermName" placeholder="如：用户管理">
            </div>
            <div class="form-group">
                <label>权限编码 <span style="color:red">*</span></label>
                <input type="text" id="fPermCode" placeholder="如：user:manage">
            </div>
            <div class="form-group">
                <label>资源路径</label>
                <input type="text" id="fPermUrl" placeholder="如：/users">
            </div>
            <div class="form-group">
                <label>描述</label>
                <textarea id="fPermDesc" placeholder="请输入权限描述"></textarea>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-default" onclick="closeModal('modalPerm')">取消</button>
            <button class="btn btn-primary" onclick="savePerm()">保存</button>
        </div>
    </div>
</div>

<script>
var allPerms = [];
function loadPerms() {
    apiGet(ctx + '/api/permissions').then(function(res) {
        allPerms = res.data || [];
        renderPerms(allPerms);
    });
}
function renderPerms(list) {
    var html = '';
    list.forEach(function(p) {
        html += '<tr>';
        html += '<td>' + p.permId + '</td>';
        html += '<td><strong>' + p.permName + '</strong></td>';
        html += '<td><code style="background:#f5f5f5;padding:2px 6px;border-radius:3px;font-size:12px;">' + p.permCode + '</code></td>';
        html += '<td>' + (p.url||'-') + '</td>';
        html += '<td>' + (p.description||'-') + '</td>';
        html += '<td>' + (p.createTime||'') + '</td>';
        html += '<td class="actions">';
        html += '<button class="btn btn-default btn-xs" onclick="openEditModal(' + p.permId + ')">编辑</button>';
        html += '<button class="btn btn-danger btn-xs" onclick="deletePerm(' + p.permId + ')">删除</button>';
        html += '</td></tr>';
    });
    document.getElementById('permTableBody').innerHTML = html || '<tr><td colspan="7" style="text-align:center;color:#999;">暂无数据</td></tr>';
}
function openCreateModal() {
    document.getElementById('modalPermTitle').textContent = '新增权限';
    document.getElementById('editPermId').value = '';
    document.getElementById('fPermName').value = '';
    document.getElementById('fPermCode').value = '';
    document.getElementById('fPermUrl').value = '';
    document.getElementById('fPermDesc').value = '';
    openModal('modalPerm');
}
function openEditModal(id) {
    var p = allPerms.find(function(item){return item.permId===id;});
    if(!p) return;
    document.getElementById('modalPermTitle').textContent = '编辑权限';
    document.getElementById('editPermId').value = p.permId;
    document.getElementById('fPermName').value = p.permName||'';
    document.getElementById('fPermCode').value = p.permCode||'';
    document.getElementById('fPermUrl').value = p.url||'';
    document.getElementById('fPermDesc').value = p.description||'';
    openModal('modalPerm');
}
function savePerm() {
    var id = document.getElementById('editPermId').value;
    var data = {
        permName: document.getElementById('fPermName').value.trim(),
        permCode: document.getElementById('fPermCode').value.trim(),
        url: document.getElementById('fPermUrl').value.trim(),
        description: document.getElementById('fPermDesc').value.trim()
    };
    if (!data.permName) { showToast('请输入权限名称','error'); return; }
    if (!data.permCode) { showToast('请输入权限编码','error'); return; }
    var promise = id ? apiPut(ctx+'/api/permissions/'+id, data) : apiPost(ctx+'/api/permissions', data);
    promise.then(function() {
        closeModal('modalPerm');
        showToast(id?'权限更新成功':'权限创建成功');
        loadPerms();
    });
}
function deletePerm(id) {
    if (!confirm('确定要删除该权限吗？')) return;
    apiDelete(ctx + '/api/permissions/' + id).then(function() {
        showToast('权限已删除');
        loadPerms();
    });
}
loadPerms();
</script>

<%@ include file="footer.jsp" %>