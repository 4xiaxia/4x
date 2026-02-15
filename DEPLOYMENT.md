# AIClient-2-API CloudStudio 部署指南

## 📋 快速部署

### 方式 1: 自动化部署（推荐）

适用于首次部署或完整重装：

```bash
cd /workspace/AIClient-2-API
bash deploy.sh
```

**功能包括：**
- ✅ 自动检查运行环境（Node.js、npm）
- ✅ 自动初始化配置文件（config.json、provider_pools.json）
- ✅ 自动安装项目依赖
- ✅ 自动停止旧服务
- ✅ 启动新服务并验证
- ✅ 提供详细的日志和状态信息

---

### 方式 2: 快速启动

适用于依赖已安装，只需重启服务：

```bash
cd /workspace/AIClient-2-API
bash quick-start.sh
```

---

### 方式 3: 健康检查

检查服务运行状态：

```bash
cd /workspace/AIClient-2-API
bash health-check.sh
```

---

## 🚀 部署流程说明

### 1. 环境检查
自动检测 Node.js 和 npm 是否安装，版本是否满足要求。

### 2. 项目文件检查
验证 package.json 和源代码文件是否存在。

### 3. 配置文件初始化
自动创建以下配置文件（如果不存在）：
- `configs/config.json` - 主配置文件
- `configs/provider_pools.json` - 服务提供商池配置
- `configs/logs/` - 日志目录
- `configs/plugins/` - 插件目录

### 4. 依赖安装
自动运行 `npm install` 安装项目依赖（仅首次）。

### 5. 源代码检查
验证 `src/core/master.js` 和 `src/services/api-server.js` 是否存在。

### 6. 服务管理
- 自动检测端口 3000 是否被占用
- 如果被占用，自动停止旧服务
- 在后台启动新服务

### 7. 服务验证
- 等待服务启动（最多 30 秒）
- 验证 HTTP 响应是否正常
- 显示服务状态和访问信息

---

## 🔧 常用命令

### 查看服务日志
```bash
tail -f /tmp/aiclient.log
```

### 停止服务
```bash
lsof -ti:3000 | xargs kill -9
```

### 重启服务
```bash
bash quick-start.sh
```

### 完整重装
```bash
cd /workspace/AIClient-2-API
rm -rf node_modules
bash deploy.sh
```

---

## 📊 部署后检查

部署完成后，访问以下地址验证服务：

- **Web UI**: http://localhost:3000
- **默认密码**: admin123

使用健康检查脚本验证所有组件：

```bash
bash health-check.sh
```

预期输出：
```
✓ Web UI 服务正常 (HTTP 200)
✓ 进程运行中 (PID: 12345)
✓ config.json 存在
✓ provider_pools.json 存在
✓ 依赖已安装
```

---

## ⚠️ 常见问题

### 1. 端口被占用
**现象**: `EADDRINUSE: address already in use :::3000`

**解决**:
```bash
# 查找占用进程
lsof -ti:3000

# 停止进程
kill -9 <PID>

# 或直接运行部署脚本，会自动处理
bash deploy.sh
```

### 2. 依赖安装失败
**现象**: npm install 报错

**解决**:
```bash
# 清理缓存
npm cache clean --force

# 重新安装
cd /workspace/AIClient-2-API
rm -rf node_modules package-lock.json
npm install
```

### 3. 配置文件缺失
**现象**: 启动时报错找不到配置文件

**解决**:
```bash
# 自动创建配置文件
cd /workspace/AIClient-2-API/configs
cp config.json.example config.json
cp provider_pools.json.example provider_pools.json
```

### 4. 服务启动超时
**现象**: 部署脚本等待超时

**解决**:
```bash
# 查看详细日志
tail -100 /tmp/aiclient.log

# 手动启动查看错误
npm start
```

---

## 📁 项目结构

```
AIClient-2-API/
├── deploy.sh              # 自动化部署脚本（推荐）
├── quick-start.sh         # 快速启动脚本
├── health-check.sh        # 健康检查脚本
├── install-and-run.sh     # 原始安装脚本
├── package.json           # 项目依赖配置
├── src/
│   ├── core/master.js     # 主进程
│   └── services/api-server.js  # API 服务
├── configs/
│   ├── config.json        # 主配置（自动创建）
│   ├── provider_pools.json  # 服务提供商池（自动创建）
│   ├── logs/              # 日志目录
│   └── plugins/           # 插件目录
└── static/                # 静态文件（Web UI）
```

---

## 🎯 下一步

部署成功后，可以：

1. **访问 Web UI**: http://localhost:3000
2. **登录系统**: 使用密码 `admin123`
3. **配置服务提供商**:
   - 在 "Configuration" 页面配置 API Key
   - 或在 "Provider Pools" 页面生成 OAuth 授权
4. **测试 API**: 使用 `/v1/chat/completions` 端点测试

---

## 📝 注意事项

- 脚本需要在项目根目录运行
- 确保 Node.js 版本 ≥ 20.0.0
- 配置文件会被自动创建，无需手动操作
- 服务默认运行在 3000 端口
- 日志文件位于 `/tmp/aiclient.log`
