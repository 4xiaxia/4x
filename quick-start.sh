#!/bin/bash

# 快速启动脚本 - 适用于已安装环境

set -e

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_ROOT="/workspace/AIClient-2-API"
cd "$PROJECT_ROOT"

echo "🚀 快速启动 AIClient-2-API..."

# 停止现有服务
EXISTING_PID=$(lsof -ti:3000 2>/dev/null || echo "")
if [ ! -z "$EXISTING_PID" ]; then
    echo "⏸️  停止现有服务..."
    kill -9 $EXISTING_PID 2>/dev/null || true
    sleep 2
fi

# 启动服务
echo "▶️  启动服务..."
nohup npm start > /tmp/aiclient.log 2>&1 &
echo "✅ 服务启动中..."

# 等待服务就绪
for i in {1..15}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo -e "${GREEN}✓ 服务启动成功！${NC}"
        echo ""
        echo "📱 访问地址: http://localhost:3000"
        echo "🔑 默认密码: admin123"
        echo "📋 查看日志: tail -f /tmp/aiclient.log"
        exit 0
    fi
    sleep 2
done

echo -e "${RED}✗ 服务启动超时，请查看日志${NC}"
tail -20 /tmp/aiclient.log
exit 1
