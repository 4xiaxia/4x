#!/bin/bash

# AIClient-2-API 改进版自动部署脚本
# 支持自动初始化配置、环境检查、依赖安装、服务启动

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 项目根目录
PROJECT_ROOT="/workspace/AIClient-2-API"
cd "$PROJECT_ROOT" || exit 1

log_info "========================================="
log_info "  AIClient-2-API 自动部署脚本"
log_info "========================================="
log_info ""

# 1. 环境检查
log_info "步骤 1/7: 检查运行环境..."

# 检查 Node.js
if ! command -v node &> /dev/null; then
    log_error "未检测到 Node.js，请先安装 Node.js"
    exit 1
fi
NODE_VERSION=$(node --version)
log_success "Node.js 版本: $NODE_VERSION"

# 检查 npm
if ! command -v npm &> /dev/null; then
    log_error "npm 不可用"
    exit 1
fi
log_success "npm 可用"

# 2. 项目文件检查
log_info "步骤 2/7: 检查项目文件..."

if [ ! -f "package.json" ]; then
    log_error "未找到 package.json"
    exit 1
fi
log_success "package.json 存在"

# 3. 初始化配置文件
log_info "步骤 3/7: 初始化配置文件..."

CONFIGS_DIR="configs"
mkdir -p "$CONFIGS_DIR"

# 检查并创建 config.json
if [ ! -f "$CONFIGS_DIR/config.json" ]; then
    if [ -f "$CONFIGS_DIR/config.json.example" ]; then
        cp "$CONFIGS_DIR/config.json.example" "$CONFIGS_DIR/config.json"
        log_success "已创建 config.json"
    else
        log_error "未找到 config.json.example"
        exit 1
    fi
else
    log_success "config.json 已存在"
fi

# 检查并创建 provider_pools.json
if [ ! -f "$CONFIGS_DIR/provider_pools.json" ]; then
    if [ -f "$CONFIGS_DIR/provider_pools.json.example" ]; then
        cp "$CONFIGS_DIR/provider_pools.json.example" "$CONFIGS_DIR/provider_pools.json"
        log_success "已创建 provider_pools.json"
    else
        log_warning "未找到 provider_pools.json.example"
    fi
else
    log_success "provider_pools.json 已存在"
fi

# 检查并创建必要的目录
mkdir -p "$CONFIGS_DIR/logs"
mkdir -p "$CONFIGS_DIR/plugins"
log_success "配置目录已就绪"

# 4. 安装依赖
log_info "步骤 4/7: 安装项目依赖..."

# 检查 node_modules 是否存在
if [ -d "node_modules" ]; then
    log_warning "node_modules 已存在，跳过安装"
    log_info "如需重新安装，请先删除 node_modules 目录"
else
    log_info "正在安装依赖（可能需要几分钟）..."
    if npm install; then
        log_success "依赖安装完成"
    else
        log_error "依赖安装失败"
        exit 1
    fi
fi

# 5. 检查源代码
log_info "步骤 5/7: 检查源代码文件..."

if [ ! -f "src/core/master.js" ]; then
    log_error "未找到 src/core/master.js"
    exit 1
fi

if [ ! -f "src/services/api-server.js" ]; then
    log_error "未找到 src/services/api-server.js"
    exit 1
fi
log_success "源代码文件检查通过"

# 6. 停止现有服务
log_info "步骤 6/7: 检查并停止现有服务..."

# 查找并停止现有进程
EXISTING_PID=$(lsof -ti:3000 2>/dev/null || echo "")
if [ ! -z "$EXISTING_PID" ]; then
    log_warning "端口 3000 已被占用 (PID: $EXISTING_PID)"
    log_info "正在停止现有服务..."
    kill -9 $EXISTING_PID 2>/dev/null || true
    sleep 2
    log_success "现有服务已停止"
else
    log_success "端口 3000 可用"
fi

# 7. 启动服务
log_info "步骤 7/7: 启动服务..."

# 后台启动服务
nohup npm start > /tmp/aiclient.log 2>&1 &
NEW_PID=$!

# 等待服务启动
log_info "等待服务启动（最多 30 秒）..."
for i in {1..30}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        log_success "服务启动成功！"
        break
    fi
    if [ $i -eq 30 ]; then
        log_error "服务启动超时"
        log_info "查看日志: tail -f /tmp/aiclient.log"
        exit 1
    fi
    sleep 1
done

# 最终状态检查
sleep 2
log_info ""
log_info "========================================="
log_info "  部署完成！"
log_info "========================================="
log_info ""
log_success "服务状态: 运行中"
log_success "服务地址: http://localhost:3000"
log_success "默认密码: admin123"
log_success "日志文件: /tmp/aiclient.log"
log_info ""
log_info "常用命令:"
log_info "  查看日志: tail -f /tmp/aiclient.log"
log_info "  停止服务: lsof -ti:3000 | xargs kill -9"
log_info "  重启服务: bash deploy.sh"
log_info ""
log_info "提示: 可以在 CloudStudio 预览中访问 http://localhost:3000"
log_info ""
