# GitHub Actions 配置指南

## 📋 已配置的工作流

### 1. CI/CD Pipeline (`.github/workflows/ci-cd.yml`)

**触发条件**：
- 推送到 `main` 或 `develop` 分支
- 针对 `main` 或 `develop` 的 Pull Request

**包含任务**：
- ✅ 代码检查（ESLint）
- ✅ 多版本 Node.js 测试（18.x, 20.x）
- ✅ 安全扫描（Trivy）
- ✅ Docker 镜像构建
- ✅ 部署通知

### 2. Deploy (`.github/workflows/deploy.yml`)

**触发条件**：
- 推送到 `main` 分支（排除文档文件变更）

**功能**：
- 环境检查
- 部署摘要生成

### 3. Docker Publish (`.github/workflows/docker-publish.yml`)

**触发条件**：
- `VERSION` 文件变更时触发

**功能**：
- 自动创建 Git Tag
- 构建并推送 Docker 镜像到 Docker Hub

---

## 🔧 必需的 GitHub Secrets 配置

### Docker Hub 配置（可选，用于发布镜像）

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 创建账号并获取用户名和访问令牌
3. 在 GitHub 仓库中配置 Secrets：

#### 步骤 1: 访问仓库设置
```
https://github.com/4xiaxia/4x/settings/secrets/actions
```

#### 步骤 2: 添加以下 Secrets

| Secret 名称 | 说明 | 示例值 |
|------------|------|--------|
| `DOCKERHUB_USERNAME` | Docker Hub 用户名 | `your-dockerhub-username` |
| `DOCKERHUB_TOKEN` | Docker Hub 访问令牌 | `dckr_pat_xxxxx...` |

#### 步骤 3: 生成 Docker Hub Token
1. 访问：https://hub.docker.com/settings/security
2. 点击 "New Access Token"
3. 输入描述（如：GitHub Actions）
4. 选择权限：Read, Write, Delete
5. 复制生成的 Token

---

## 🚀 使用指南

### 查看工作流运行状态

访问 GitHub Actions 页面：
```
https://github.com/4xiaxia/4x/actions
```

### 手动触发工作流

**方法 1: 推送代码**
```bash
git add .
git commit -m "Update code"
git push
```

**方法 2: 创建 Pull Request**
```bash
git checkout -b feature-branch
git push origin feature-branch
# 然后在 GitHub 上创建 Pull Request
```

**方法 3: 更新 VERSION 文件（触发 Docker 发布）**
```bash
echo "1.0.1" > VERSION
git add VERSION
git commit -m "Release v1.0.1"
git push
```

---

## 📊 工作流说明

### CI/CD Pipeline 工作流流程

```
推送代码/PR
    ↓
[代码检查和测试] (Node.js 18.x, 20.x)
    ↓
[安全扫描] (Trivy 漏洞扫描)
    ↓
[构建 Docker 镜像] (amd64, arm64)
    ↓
[部署通知]
```

### Deploy 工作流流程

```
推送到 main 分支
    ↓
[检出代码]
    ↓
[安装依赖]
    ↓
[运行健康检查]
    ↓
[生成部署摘要]
```

### Docker Publish 工作流流程

```
VERSION 文件变更
    ↓
[读取版本号]
    ↓
[检查并创建 Git Tag]
    ↓
[构建 Docker 镜像]
    ↓
[推送到 Docker Hub]
```

---

## 🛠️ 自定义配置

### 修改 Node.js 版本

编辑 `.github/workflows/ci-cd.yml`：

```yaml
strategy:
  matrix:
    node-version: [18.x, 20.x, 22.x]  # 添加或修改版本
```

### 修改 Docker 镜像名称

编辑 `.github/workflows/ci-cd.yml`：

```yaml
with:
  images: ${{ secrets.DOCKERHUB_USERNAME }}/your-custom-name
```

### 修改触发分支

编辑 `.github/workflows/ci-cd.yml`：

```yaml
on:
  push:
    branches: [main, develop, staging]  # 添加其他分支
```

---

## 🔒 安全建议

### 1. 定期更新 Actions
```yaml
- uses: actions/checkout@v4  # 使用最新版本
- uses: actions/setup-node@v4
```

### 2. 限制 Secrets 权限
- 只授予必要的权限
- 定期轮换敏感令牌

### 3. 启用分支保护
```
Settings → Branches → Branch protection rules
```
- 要求 Pull Request 审查
- 要求状态检查通过
- 限制直接推送

---

## 📝 故障排查

### 工作流失败

**查看日志**：
```
GitHub → Actions → 选择工作流运行 → 查看失败步骤的日志
```

### Docker 构建失败

**常见原因**：
1. `DOCKERHUB_TOKEN` 未配置或过期
2. Dockerfile 存在语法错误
3. 依赖项下载失败

**解决方案**：
- 检查 Secrets 配置
- 本地测试 Docker 构建：`docker build -t test .`
- 检查网络连接

### 测试失败

**常见原因**：
1. 依赖项版本冲突
2. 环境变量缺失
3. 代码语法错误

**解决方案**：
- 运行 `npm ci` 清理并重新安装依赖
- 检查 `.env.example` 文件
- 本地运行测试：`npm test`

---

## 📚 参考资源

- [GitHub Actions 官方文档](https://docs.github.com/en/actions)
- [Docker Hub 文档](https://docs.docker.com/)
- [Trivy 安全扫描](https://github.com/aquasecurity/trivy)
- [GitHub Secrets 管理](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

## ✅ 快速检查清单

- [ ] 已添加 `DOCKERHUB_USERNAME` Secret
- [ ] 已添加 `DOCKERHUB_TOKEN` Secret
- [ ] 已启用 GitHub Actions
- [ ] 已测试工作流运行
- [ ] 已查看 Actions 日志
- [ ] 已配置分支保护（可选）

---

**更新日期**: 2026-02-15
**维护者**: 4xiaxia
