# 项目可复用资源初筛清单 (Reusable Resources Screening List)

## 1. 后端资源 (Backend Resources)

### 1.1 工具库 (Utilities)
| 文件路径 | 核心功能 | 复用场景 |
| :--- | :--- | :--- |
| `src/utils/common.js` | 网络错误重试 (`isRetryableNetworkError`)<br>日志格式化 (`formatLog`)<br>请求解析 (`getRequestBody`)<br>鉴权校验 (`isAuthorized`)<br>统一响应处理 (`handleUnifiedResponse`)<br>错误响应生成 (`handleError`) | 所有 API 接口开发、日志记录、错误处理 |
| `src/utils/logger.js` | 标准化日志输出 (Info/Warn/Error) | 全局日志记录 |
| `src/converters/ConverterFactory.js` | 转换器工厂模式 (`ConverterFactory`) | 新增协议转换逻辑时复用 |

### 1.2 核心逻辑 (Core Logic)
| 文件路径 | 核心功能 | 复用场景 |
| :--- | :--- | :--- |
| `src/handlers/request-handler.js` | 主请求分发逻辑 | 参考用于新增路由处理 |
| `src/core/config-manager.js` | 配置加载与管理 | 读取/更新系统配置 |

## 2. 前端资源 (Frontend Resources)

### 2.1 核心模块 (Core Modules)
| 文件路径 | 核心功能 | 复用场景 |
| :--- | :--- | :--- |
| `static/app/auth.js` | **AuthManager**: Token 管理 (Get/Set/Clear)<br>**ApiClient**: 统一 API 请求封装 (自动携带 Token, 处理 401)<br>`login`/`logout`: 登录登出逻辑 | 所有前端页面 API 调用、权限控制 |
| `static/app/i18n.js` | **t**: 多语言翻译函数<br>`setLanguage`: 切换语言<br>`initI18n`: 初始化翻译系统 | 所有前端页面的文本展示 |
| `static/app/component-loader.js` | `loadComponent`/`insertComponent`: 动态加载 HTML 片段 | 页面组件化开发、动态内容加载 |
| `static/app/utils.js` | `showToast`: 全局提示消息<br>`escapeHtml`: XSS 防护<br>`formatUptime`: 时间格式化 | 页面交互反馈、数据展示 |

### 2.2 UI 组件 (UI Components)
> 位于 `static/components/` 目录下的 HTML 片段，通过 `component-loader.js` 加载。

| 组件文件 | 功能描述 | 复用建议 |
| :--- | :--- | :--- |
| `header.html` | 顶部导航栏 (含菜单切换、主题切换、状态指示) | 页面头部统一复用 |
| `sidebar.html` | 侧边导航栏 | 页面左侧导航统一复用 |
| `section-*.html` | 各功能模块 (Dashboard, Config, Logs, etc.) | 参考其结构开发新功能模块 |

## 3. 静态资源 (Static Assets)
| 资源路径 | 说明 | 注意事项 |
| :--- | :--- | :--- |
| `static/app/base.css` | 基础样式库 (Variables, Reset, Utility classes) | 新页面应优先复用此类名 |
| `static/app/mobile.css` | 移动端适配样式 | 保证移动端兼容性 |

## 4. 待解决资源问题
- **Font Awesome CDN**: `static/index.html` 和 `static/login.html` 引用了海外 CDN，需本地化。
