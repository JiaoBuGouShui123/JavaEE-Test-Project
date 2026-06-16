<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="sidebar.jsp" %>

<%-- ===== 仪表盘内容 ===== --%>
<div style="display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:24px;">
    <div class="card" style="text-align:center;">
        <div style="font-size:42px;color:#667eea;" id="statUser">--</div>
        <div style="color:#999;margin-top:8px;">用户总数</div>
    </div>
    <div class="card" style="text-align:center;">
        <div style="font-size:42px;color:#27ae60;" id="statRole">--</div>
        <div style="color:#999;margin-top:8px;">角色总数</div>
    </div>
    <div class="card" style="text-align:center;">
        <div style="font-size:42px;color:#f39c12;" id="statPerm">--</div>
        <div style="color:#999;margin-top:8px;">权限总数</div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h3>系统信息</h3>
    </div>
    <table>
        <tr><td style="width:150px;font-weight:600;">技术框架</td><td>Spring 5.3.24 + SpringMVC + MyBatis 3.5.13</td></tr>
        <tr><td>数据库</td><td>MySQL 8.0.33 + Druid 连接池</td></tr>
        <tr><td>前端</td><td>JSP + JSTL + HTML5 + CSS3 + JavaScript</td></tr>
        <tr><td>权限模型</td><td>RBAC（基于角色的访问控制）</td></tr>
        <tr><td>当前用户</td><td><%= ((com.example.entity.User)session.getAttribute("user")).getUsername() %></td></tr>
    </table>
</div>

<script>
// 加载统计数据
apiGet(ctx + '/api/users').then(function(res) {
    document.getElementById('statUser').textContent = res.data ? res.data.length : 0;
}).catch(function(){ document.getElementById('statUser').textContent = '-'; });
apiGet(ctx + '/api/roles').then(function(res) {
    document.getElementById('statRole').textContent = res.data ? res.data.length : 0;
}).catch(function(){ document.getElementById('statRole').textContent = '-'; });
apiGet(ctx + '/api/permissions').then(function(res) {
    document.getElementById('statPerm').textContent = res.data ? res.data.length : 0;
}).catch(function(){ document.getElementById('statPerm').textContent = '-'; });
</script>

<%@ include file="footer.jsp" %>