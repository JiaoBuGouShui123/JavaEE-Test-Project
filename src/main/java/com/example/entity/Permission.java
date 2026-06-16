package com.example.entity;

import java.util.Date;

/**
 * 权限/资源实体类
 */
public class Permission {
    private Long permId;
    private String permName;
    private String permCode;    // 权限标识，如 user:create
    private String url;         // 对应的资源路径
    private String description;
    private Date createTime;

    public Long getPermId() { return permId; }
    public void setPermId(Long permId) { this.permId = permId; }

    public String getPermName() { return permName; }
    public void setPermName(String permName) { this.permName = permName; }

    public String getPermCode() { return permCode; }
    public void setPermCode(String permCode) { this.permCode = permCode; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}
