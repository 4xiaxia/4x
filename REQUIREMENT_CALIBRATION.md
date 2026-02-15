# 需求校准表 (Requirement Calibration)

## 1. 文档需求 vs 代码实现

| 需求维度 | 文档描述 (Project Info) | 代码实现 (Code Scan) | 差异点 | 状态 |
| :--- | :--- | :--- | :--- | :--- |
| **多协议支持** | 支持 OpenAI, Claude, Gemini, Ollama, iFlow 等。 | `src/providers/` 下有对应目录，`ConverterFactory` 支持策略切换。 | 一致。 | ✅ |
| **本地化改造** | 需解决大陆访问屏蔽问题 (CDN)。 | `index.html` 仍引用 `cdnjs` 的 Font Awesome。 | **代码未实现本地化**。 | 🔴 待修复 |
| **账号池管理** | 支持轮询、故障转移。 | `provider-pool-manager.js` 实现了 `selectProviderWithFallback`。 | 一致。 | ✅ |
| **接口对接** | 核心接口 `/api/spots` (手册提及)。 | 代码中无 `/api/spots`，核心是 `/v1/chat/completions`。 | **手册描述可能为示例**，实际核心是 `/v1/chat/completions`。 | ⚠️ 需确认 |
| **部署方式** | 支持 Docker 和本地运行。 | 存在 `deploy.sh`, `Dockerfile`, `src/core/master.js`。 | 一致。 | ✅ |

## 2. 潜在需求挖掘

- **前端压缩**: 虽然未明确提及，但考虑到服务器在海外，前端资源压缩 (Gzip) 能显著提升国内访问速度。
- **日志审计**: 当前日志记录在文件，缺乏可视化检索界面（仅有简单的实时日志流），可能需要增强。

## 3. 处理建议

1.  **修正手册/文档**: 确认 `/api/spots` 是否为笔误或特定业务接口，若不存在则以 `/v1/chat/completions` 为准。
2.  **执行本地化**: 优先级最高，下载 Font Awesome 及其他可能的 CDN 资源。
3.  **保持现状**: 核心逻辑 (Provider, Converter) 无需大改，重点在前端和配置优化。
