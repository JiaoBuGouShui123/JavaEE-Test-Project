        </div><!-- .content -->
    </div><!-- .main-content -->
</div><!-- .layout -->

<script>
// 加载侧边栏角色标签
fetch(ctx + '/api/me', { credentials: 'same-origin' }).then(function(res) {
    return res.json();
}).then(function(json) {
    if (json.code === 200 && json.data && json.data.roles && json.data.roles.length > 0) {
        var roleNames = json.data.roles.map(function(r) { return r.roleName; }).join('、');
        document.getElementById('roleTag').textContent = roleNames;
    } else {
        document.getElementById('roleTag').textContent = '普通用户';
    }
}).catch(function() {
    document.getElementById('roleTag').textContent = '未知';
});
</script>
</body>
</html>