#!/bin/bash

# 健康检查脚本

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 AIClient-2-API 健康检查"
echo ""

# 检查端口
PORT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null || echo "000")
if [ "$PORT_STATUS" = "200" ]; then
    echo -e "${GREEN}✓${NC} Web UI 服务正常 (HTTP 200)"
else
    echo -e "${RED}✗${NC} Web UI 服务异常 (HTTP $PORT_STATUS)"
fi

# 检查进程
PID=$(lsof -ti:3000 2>/dev/null || echo "")
if [ ! -z "$PID" ]; then
    echo -e "${GREEN}✓${NC} 进程运行中 (PID: $PID)"
else
    echo -e "${RED}✗${NC} 进程未运行"
fi

# 检查配置文件
if [ -f "configs/config.json" ]; then
    echo -e "${GREEN}✓${NC} config.json 存在"
else
    echo -e "${YELLOW}⚠${NC} config.json 缺失"
fi

if [ -f "configs/provider_pools.json" ]; then
    echo -e "${GREEN}✓${NC} provider_pools.json 存在"
else
    echo -e "${YELLOW}⚠${NC} provider_pools.json 缺失"
fi

# 检查依赖
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} 依赖已安装"
else
    echo -e "${RED}✗${NC} 依赖未安装"
fi

echo ""
echo "📊 服务信息:"
if [ ! -z "$PID" ]; then
    echo "  进程: $PID"
    echo "  端口: 3000"
    echo "  地址: http://localhost:3000"
fi
