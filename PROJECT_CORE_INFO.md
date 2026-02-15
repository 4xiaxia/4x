# 项目文档核心信息提炼表

## 1. 项目目标 (Project Goals)
- **核心目标**: 将仅限客户端使用的免费大模型 API（Gemini, Antigravity, Qwen Code, Kiro 等）转换为标准的 OpenAI 兼容接口，供第三方应用（Cherry-Studio, NextChat 等）调用。
- **关键价值**: 突破客户端限制，统一接口格式，支持多协议互转（OpenAI/Claude/Gemini），提供账号池管理和自动故障转移。

## 2. 已实现功能 (Implemented Features)
- **多模型支持**: Gemini, Antigravity, Qwen Code, Kiro, Claude, OpenAI, Ollama, iFlow, Codex。
- **协议转换**: 支持 OpenAI, Claude, Gemini 三大协议智能互转。
- **Web UI 管理**:
  - 仪表盘、配置管理、提供商池监控、日志查看。
  - 端口: 3000 (UI), 8085-8087 (OAuth), 1455 (Codex), 19876-19880 (Kiro)。
- **高级特性**:
  - **账号池管理**: 支持多账号轮询、健康检查。
  - **故障转移 (Fallback)**: 跨提供商类型的自动降级链。
  - **OAuth 管理**: 支持 Base64/文件/自动发现凭据。
  - **系统提示词**: 支持文件注入、实时同步。
- **部署支持**:
  - Docker / Docker Compose。
  - 本地直连（Shell 脚本自动化）。
  - CloudStudio 适配。

## 3. 待开发/优化需求 (Pending Requirements)
> *基于执行手册与文档分析*
- **前端视觉优化**: 用户明确提出的视觉改进（需后续梳理页面细节）。
- **本地化改造**: 解决大陆网络环境下的资源访问问题（esm.sh, importmap, React/GenAI CDN 屏蔽问题）。
- **模块解耦**: 严格落实模块间解耦，仅通过统一接口通信。
- **API 对接**: 完善前后端数据流打通（铺管线阶段）。
- **性能优化**: 针对高频请求和渲染的优化。

## 4. 已知问题与风险 (Known Issues & Risks)
- **安全风险**:
  - 曾存在硬编码密码 `admin123` 和 API Key `123456`（已于 2026-02-14 修复，需验证环境变量生效情况）。
  - CORS 曾过度开放（已修复，需验证 `ALLOWED_ORIGINS`）。
- **网络限制**:
  - 依赖海外 CDN 资源（如 `esm.sh`），在大陆环境可能无法加载。
  - API 调用（Google, Anthropic）需要海外网络环境或代理。
- **稳定性**: 进程崩溃曾导致无限重启（已添加 `maxRestartAttempts` 限制）。

## 5. 版本依赖 (Dependencies)
- **Runtime**: Node.js >= 20.0.0
- **Docker**: Optional (v20.10+ recommended)
- **Core Libraries**:
  - `axios` (^1.x), `undici` (^7.x): HTTP Requests
  - `ws` (^8.x): WebSocket
  - `google-auth-library`: OAuth
  - `dotenv`: Config
  - `http-proxy-agent` / `https-proxy-agent`: Proxy support
- **No Build Tools**: 项目无 Webpack/Vite 构建配置，前端疑似原生 ESM 或简单静态文件。

## 6. 核心 API 与路由 (Core APIs & Routes)
| 路由路径 | 方法 | 功能描述 | 兼容协议 |
| :--- | :--- | :--- | :--- |
| `/v1/chat/completions` | POST | 核心对话接口 | OpenAI |
| `/v1/models` | GET | 模型列表 | OpenAI |
| `/v1beta/models` | GET | 模型列表 | Gemini |
| `/v1beta/models/{model}:generateContent` | POST | 内容生成 | Gemini |
| `/v1/messages` | POST | 消息生成 | Claude |
| `/health` | GET | 服务健康检查 | System |
| `/ollama/api/chat` | POST | Ollama 兼容聊天 | Ollama |
| `/` | GET | Web UI 首页 | Web |
| `/api/login` | POST | Web UI 登录 | Web API |

## 待确认疑问点
1. **前端源码位置**: 项目根目录有 `static/`，但 `src/ui-modules` 也存在。需确认前端是纯静态 HTML 还是由 `src/ui-modules` 动态渲染/管理。
2. **本地化资源清单**: 需具体扫描前端代码中引用的 CDN 地址（esm.sh 等）。
3. **接口完整性**: 文档提及 `/api/spots` 为核心接口（执行手册步骤5），但当前 README 未明确列出此接口，需在代码扫描阶段确认是否存在或为通用指代。
