# 页面梳理与分类清单 (Page & Component Scan List)

## 1. 页面清单 (Pages)

### 1.1 `static/index.html` (核心入口)
- **类型**: SPA 容器 / 核心功能页
- **布局**:
  - `header`: 顶部导航栏 (组件: `header.html`)
  - `sidebar`: 左侧导航栏 (组件: `sidebar.html`)
  - `main-content`: 右侧内容区 (动态加载 `section-*.html`)
- **静态资源**:
  - `app/base.css`, `app/mobile.css` (本地)
  - `app/fontawesome/css/all.min.css` (已本地化)
  - `app/*.js` (本地模块)
- **视觉优化需求**:
  - 需确认移动端适配细节。
  - 主题切换 (Dark/Light) 需验证。

### 1.2 `static/login.html` (登录页)
- **类型**: 独立页面 / 核心功能页
- **布局**: 单卡片居中布局。
- **静态资源**:
  - `app/base.css` (本地)
  - `app/fontawesome/css/all.min.css` (已本地化)
- **视觉优化需求**:
  - 登录表单样式微调。

### 1.3 `static/potluck.html` & `static/potluck-user.html`
- **类型**: 独立功能页 (推测为 API Potluck 插件相关)
- **状态**: 需进一步确认是否通过 `component-loader` 加载或独立访问。目前看是独立入口。
- **资源引用**: 需检查是否包含未本地化的资源。

## 2. 组件清单 (Components)

所有组件位于 `static/components/`，由 `static/app/component-loader.js` 动态加载。

| 组件文件 | 功能描述 | 资源依赖 | 状态 |
| :--- | :--- | :--- | :--- |
| `header.html` | 顶部导航，包含状态指示、主题切换、GitHub 链接 | FontAwesome (本地) | ✅ 正常 |
| `sidebar.html` | 左侧菜单，包含路由导航 | FontAwesome (本地) | ✅ 正常 |
| `section-dashboard.html` | 仪表盘，展示系统信息、路由示例 | 无外部依赖 | ✅ 正常 |
| `section-config.html` | 配置表单，API Key/Provider 设置 | 无外部依赖 | ✅ 正常 |
| `section-providers.html` | 账号池管理，OAuth 授权入口 | 无外部依赖 | ✅ 正常 |
| `section-logs.html` | 实时日志显示 | 无外部依赖 | ✅ 正常 |
| `section-usage.html` | 用量统计图表 | FontAwesome (本地) | ✅ 正常 |
| `section-upload-config.html` | 配置文件上传管理 | 无外部依赖 | ✅ 正常 |
| `section-plugins.html` | 插件管理列表 | 无外部依赖 | ✅ 正常 |
| `section-guide.html` | 使用指南文档 | 无外部依赖 | ✅ 正常 |
| `section-tutorial.html` | 配置教程文档 | 无外部依赖 | ✅ 正常 |

## 3. 潜在风险检查 (Risk Check)

- **外部链接**: 代码中包含 GitHub、支付链接、OAuth 授权链接，均为用户点击触发，非自动加载，符合规范。
- **示例代码**: 代码片段中包含 `http://localhost:3000` 和各类 API Base URL，仅作展示，无风险。
- **Potluck 页面**: `potluck.html` 和 `potluck-user.html` 尚未深度扫描，需在后续步骤确认。

## 4. 结论
- 主入口 (`index.html`, `login.html`) 的静态资源已完成本地化。
- 组件内部无隐蔽的 CDN 引用。
- 下一步需验证 `potluck*.html` 文件。
