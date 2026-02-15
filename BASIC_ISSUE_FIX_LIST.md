# 基础问题修复清单 (Basic Issue Repair List)

## 1. 静态资源引用修复 (Static Resource Fixes)
- **问题**: `static/index.html` 和 `static/login.html` 引用了海外 CDN `https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css`。
- **影响**: 大陆用户访问受阻，违反本地化要求。
- **修复方案**:
  1. 下载 `all.min.css` 到 `static/app/fontawesome/css/all.min.css`。
  2. 下载关联的字体文件 (`webfonts/`) 到 `static/app/fontawesome/webfonts/`。
  3. 修改 HTML 文件中的引用路径为本地路径。
- **状态**: 待修复 (Pending).

## 2. 编码与语法检查 (Encoding & Syntax Check)
- **问题**: 无明显语法错误。
- **验证**:
  - `src/core/master.js`: Syntax OK.
  - `src/services/api-server.js`: Syntax OK.
  - `package.json`: Scripts Valid.
- **状态**: 已通过 (Passed).

## 3. 环境配置检查 (Environment Config)
- **问题**: 无。
- **验证**: `package.json` 包含必要的启动脚本 (`start`, `start:standalone`)。
- **状态**: 已通过 (Passed).

## 4. 路径引用检查 (Path Reference Check)
- **问题**: `static/app/component-loader.js` 使用相对路径 `components/` 加载 HTML 片段，路径正确。
- **状态**: 已通过 (Passed).
