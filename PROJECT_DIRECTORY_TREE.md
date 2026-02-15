# 项目完整目录树 (Project Directory Tree)

## 根目录 (Root)
| 路径 | 说明 |
| :--- | :--- |
| `src/` | 后端核心源码 |
| `static/` | 前端静态资源 (Web UI) |
| `configs/` | 配置文件目录 |
| `docs/` | 文档目录 |
| `logs/` | 日志目录 |
| `tests/` | 测试用例 |
| `package.json` | 项目依赖与脚本 |
| `README*.md` | 项目说明文档 |

## 1. 后端源码 (`src/`)
| 目录/文件 | 类型 | 核心功能 |
| :--- | :--- | :--- |
| `core/` | **Core** | 系统核心模块 |
| ├── `master.js` | Entry | 主进程入口，负责进程管理和崩溃重启 |
| ├── `config-manager.js` | Logic | 配置加载、保存与热更新 |
| ├── `plugin-manager.js` | Logic | 插件系统管理 |
| `services/` | **Service** | 业务服务层 |
| ├── `api-server.js` | Server | HTTP服务器入口，路由分发起点 |
| ├── `service-manager.js` | Logic | 服务实例管理，Provider加载 |
| ├── `api-manager.js` | Logic | API相关管理逻辑 |
| ├── `ui-manager.js` | Logic | Web UI相关API管理 |
| ├── `usage-service.js` | Logic | 用量统计服务 |
| `handlers/` | **Handler** | 请求处理器 |
| ├── `request-handler.js` | Logic | **核心** HTTP请求处理，路由分发，CORS处理 |
| ├── `ollama-handler.js` | Logic | Ollama协议兼容处理 |
| `providers/` | **Provider** | 模型提供商适配器 |
| ├── `adapter.js` | Base | 适配器基类 |
| ├── `provider-pool-manager.js` | Logic | **核心** 账号池管理，轮询与健康检查 |
| ├── `gemini/` | Module | Gemini/Antigravity 适配实现 |
| ├── `openai/` | Module | OpenAI/Qwen/Codex/iFlow 适配实现 |
| ├── `claude/` | Module | Claude/Kiro 适配实现 |
| ├── `forward/` | Module | 通用转发适配 |
| `converters/` | **Converter** | 协议转换层 |
| ├── `ConverterFactory.js` | Factory | 转换器工厂 |
| ├── `strategies/` | Module | 具体协议转换策略 (OpenAI<->Gemini<->Claude) |
| `utils/` | **Utils** | 通用工具库 |
| ├── `common.js` | Utils | **核心** 通用函数 (日志、错误处理、流处理) |
| ├── `logger.js` | Utils | 日志系统 |
| ├── `provider-strategies.js` | Logic | Provider策略分发 |
| `ui-modules/` | **API** | Web UI 后端接口实现 |
| ├── `auth.js` | Logic | 认证逻辑 |
| ├── `*-api.js` | Logic | 各功能模块API实现 (Config, OAuth, Provider, etc.) |

## 2. 前端资源 (`static/`)
> 纯静态文件结构，无构建过程

| 目录/文件 | 类型 | 说明 |
| :--- | :--- | :--- |
| `index.html` | Page | Web UI 首页 (SPA容器) |
| `login.html` | Page | 登录页 |
| `app/` | **JS/CSS** | 前端核心逻辑 |
| ├── `app.js` | Entry | 前端入口 |
| ├── `component-loader.js` | Core | 组件加载器 (实现简单的组件化) |
| ├── `auth.js` | Core | 前端认证管理 |
| ├── `i18n.js` | Core | 多语言支持 |
| ├── `provider-manager.js` | Logic | 提供商管理页面逻辑 |
| ├── `base.css` | Style | 基础样式 |
| `components/` | **HTML** | UI 组件片段 (HTML片段) |
| ├── `header.html` | UI | 顶部导航 |
| ├── `sidebar.html` | UI | 侧边栏 |
| ├── `section-*.html` | UI | 各功能区块 (Dashboard, Config, Providers, etc.) |

## 3. 配置文件 (`configs/`)
| 文件 | 说明 |
| :--- | :--- |
| `config.json` | 主配置文件 (端口、API Key、默认Provider) |
| `provider_pools.json` | 账号池配置 (多账号、健康状态) |
| `pwd` | 管理后台密码存储 |

## 4. 关键依赖
- **Node.js**: HTTP Server (无 Express/Koa 框架，原生实现)
- **Frontend**: Vanilla JS + CSS (无 React/Vue/Webpack)
- **Protocol**: OpenAI, Claude, Gemini, Ollama
