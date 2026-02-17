# Development Standards & Conventions

## 1. Directory Structure

- **`src/`**: Backend source code (Node.js ES Modules).
  - **`core/`**: Core logic (Startup, Config, Plugin Manager).
  - **`services/`**: Business logic services (API Manager, UI Manager).
  - **`handlers/`**: HTTP Request handlers (Router logic).
  - **`providers/`**: LLM Provider logic and adapters.
  - **`utils/`**: Utility functions (Logger, Common helpers).
  - **`ui-modules/`**: Backend logic supporting specific UI features.

- **`static/`**: Frontend source code (Vanilla JS SPA).
  - **`app/`**: Frontend application logic.
  - **`components/`**: HTML fragments loaded dynamically.
  - **`css/`** (or root/app): Stylesheets.

- **`configs/`**: Configuration files (`config.json`, `provider_pools.json`).

## 2. Coding Conventions

### Backend (Node.js)
- **Module System**: ES Modules (`import`/`export`).
- **HTTP Framework**: Native `http` module (avoid Express/Koa unless necessary).
- **Async/Await**: Prefer `async/await` over Promises/Callbacks.
- **Error Handling**: Use `try/catch` blocks and centralized error handling where possible.
- **Logging**: Use `src/utils/logger.js` for all logging. Do not use `console.log` directly in production code.

### Frontend (Browser)
- **Framework**: Vanilla JavaScript. No build step (Webpack/Vite) required for core functionality.
- **Component System**: Use `component-loader.js` to load HTML fragments from `static/components/`.
- **Localization**:
  - **Text**: Use `data-i18n` attributes for HTML elements.
  - **Resources**: **Strictly Forbidden** to use external CDNs (e.g., `cdnjs`, `esm.sh`, `unpkg`). All assets (CSS, JS, Fonts, Images) must be served locally from `static/`.

## 3. API Design
- **Format**: JSON.
- **Response Structure**:
  ```json
  {
    "success": true, // or false
    "data": { ... }, // Payload on success
    "error": {       // Payload on error
      "message": "Error description",
      "code": "ERROR_CODE"
    }
  }
  ```
- **Authentication**: Bearer Token or API Key.

## 4. Anti-Risk & Stability
- **Rate Limiting**: Use `src/utils/rate-limiter.js` for all public-facing endpoints.
- **Cool Down**: Providers returning 429/403 must be placed in a "Cool Down" state (default 5 mins) rather than permanently disabled.
- **Caching**: Static assets must be served with appropriate `Cache-Control` headers (max-age=3600 for immutable assets).

## 5. Deployment
- **Modes**: Support both `Standalone` and `Worker` (Cluster) modes.
- **Environment**: Configuration via `configs/config.json` or Environment Variables.
