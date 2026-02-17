# 核心业务逻辑梳理 (Business Logic Flow)

## 1. 核心链路：内容生成 (`/v1/chat/completions`)

用户请求 -> 路由分发 -> 认证/中间件 -> 提供商选择 -> 请求转换 -> 模型调用 -> 响应处理

### 1.1 路由分发 (`src/handlers/request-handler.js`)
- `createRequestHandler(config, providerPoolManager)` 创建主处理函数。
- **CORS**: 检查 `process.env.ALLOWED_ORIGINS`，设置 Access-Control Headers。
- **静态资源**: 拦截 `/static/`, `/index.html` 等请求，由 `serveStaticFiles` 处理。
- **插件系统**: 调用 `pluginManager.executeAuth` (认证) 和 `executeMiddleware` (中间件)。
- **Ollama**: 特殊处理 `/ollama/` 路径或 `ollama` 协议前缀。
- **API 请求**: 调用 `handleAPIRequests`。

### 1.2 API 请求处理 (`src/services/api-manager.js`)
- **入口**: `handleAPIRequests`。
- **分发**: 根据 `endpointType` (如 `OPENAI_CHAT`, `CLAUDE_MESSAGE`) 调用 `handleContentGenerationRequest` 或 `handleModelListRequest`。

### 1.3 提供商选择与 Fallback (`src/services/service-manager.js`)
- **核心函数**: `getApiServiceWithFallback`。
- **逻辑**:
  1. 检查 `providerPoolManager` 是否存在。
  2. 调用 `providerPoolManager.selectProviderWithFallback`。
  3. 如果主 Provider 不健康，根据 `providerFallbackChain` (config.json) 查找备用 Provider。
  4. 支持跨协议模型映射 (`modelFallbackMapping`)。
  5. 返回选中的 `service` 实例和 `config`。

### 1.4 请求/响应转换 (`src/utils/common.js` & `src/converters/`)
- **请求转换**: `convertData(originalRequestBody, 'request', fromProvider, toProvider)`.
  - 使用 `ConverterFactory` 获取对应策略 (`GeminiStrategy`, `OpenAIStrategy` 等)。
- **系统提示词**: `_applySystemPromptFromFile` 从文件注入 System Prompt。
- **日志**: 记录 Input Prompt (`logConversation`).

### 1.5 模型调用与流式处理 (`src/utils/common.js`)
- **流式 (`handleStreamRequest`)**:
  - 调用 `service.generateContentStream`。
  - 监听原生流事件，转换 Chunk 格式。
  - 发送 SSE (Server-Sent Events) 给客户端。
  - **异常处理**: 捕获错误，标记 Provider 不健康 (`markProviderUnhealthy`)，触发重试 (Credential Switch)。
- **非流式 (`handleUnaryRequest`)**:
  - 调用 `service.generateContent`。
  - 转换响应格式。
  - 发送 JSON 响应。

## 2. 辅助链路

### 2.1 认证逻辑 (`src/ui-modules/auth.js` & `plugin-manager.js`)
- **Web UI**: `/api/login` 验证密码，颁发 Token。
- **API 调用**: `request-handler.js` 中通过 `pluginManager.executeAuth` 验证 Bearer Token 或 API Key。

### 2.2 配置管理 (`src/core/config-manager.js`)
- **加载**: 启动时加载 `config.json`。
- **热更新**: 监听文件变化，重新加载配置。

### 2.3 插件系统 (`src/core/plugin-manager.js`)
- **发现**: 扫描 `src/plugins/` 目录。
- **钩子**: 提供 `onStreamChunk`, `onUnaryResponse`, `executeAuth`, `executeMiddleware` 等钩子点。

## 3. 核心关联函数清单 (Key Functions)

| 模块 | 函数 | 功能 |
| :--- | :--- | :--- |
| `request-handler.js` | `requestHandler` | 主入口，路由分发 |
| `service-manager.js` | `getApiServiceWithFallback` | 智能选择 Provider (含 Fallback) |
| `provider-pool-manager.js` | `selectProviderWithFallback` | 从池中选取健康节点 |
| `common.js` | `handleContentGenerationRequest` | 编排请求转换、调用、日志 |
| `common.js` | `handleStreamRequest` | 处理流式响应、重试、错误标记 |
| `ConverterFactory.js` | `getConverter` | 获取协议转换策略 |
