#!/bin/bash

# AIClient-2-API 环境检测脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🔍 AIClient-2-API 环境检测"
echo "=========================================="
echo ""

# 检测结果
NODEJS_INSTALLED=false
NODEJS_VERSION=""
NPM_INSTALLED=false
DOCKER_INSTALLED=false
DOCKER_VERSION=""
DOCKER_RUNNING=false

# 1. 检测 Node.js
echo -n "检测 Node.js... "
if command -v node &> /dev/null; then
    NODEJS_INSTALLED=true
    NODEJS_VERSION=$(node --version)
    echo -e "${GREEN}✓${NC} 已安装 (版本: $NODEJS_VERSION)"

    # 检查版本是否满足要求（需要 >= 20.0.0）
    NODE_MAJOR=$(echo $NODEJS_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
    if [ $NODE_MAJOR -ge 20 ]; then
        echo -e "  ${GREEN}✓${NC} 版本满足要求 (>= 20.0.0)"
    else
        echo -e "  ${RED}✗${NC} 版本过低，需要 >= 20.0.0"
    fi
else
    echo -e "${RED}✗${NC} 未安装"
fi
echo ""

# 2. 检测 npm
echo -n "检测 npm... "
if command -v npm &> /dev/null; then
    NPM_INSTALLED=true
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✓${NC} 已安装 (版本: $NPM_VERSION)"
else
    echo -e "${RED}✗${NC} 未安装"
fi
echo ""

# 3. 检测 Docker
echo -n "检测 Docker... "
if command -v docker &> /dev/null; then
    DOCKER_INSTALLED=true
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓${NC} 已安装 ($DOCKER_VERSION)"

    # 检测 Docker 是否正常运行
    if docker info &> /dev/null; then
        DOCKER_RUNNING=true
        echo -e "  ${GREEN}✓${NC} Docker 守护进程运行中"
    else
        echo -e "  ${YELLOW}⚠${NC} Docker 守护进程未运行"
    fi
else
    echo -e "${YELLOW}✗${NC} 未安装（可选）"
fi
echo ""

# 4. 检测端口占用
echo -n "检测端口 3000... "
PORT_OCCUPIED=$(lsof -ti:3000 2>/dev/null || echo "")
if [ ! -z "$PORT_OCCUPIED" ]; then
    echo -e "${YELLOW}⚠${NC} 端口已被占用 (PID: $PORT_OCCUPIED)"
    echo "  可以使用以下命令停止占用进程:"
    echo "  kill -9 $PORT_OCCUPIED"
else
    echo -e "${GREEN}✓${NC} 端口可用"
fi
echo ""

# 5. 检测项目文件
echo -n "检测项目文件... "
if [ -f "package.json" ]; then
    echo -e "${GREEN}✓${NC} package.json 存在"
else
    echo -e "${RED}✗${NC} package.json 不存在"
fi
echo ""

# 6. 检测依赖
echo -n "检测依赖安装... "
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} 依赖已安装"
else
    echo -e "${YELLOW}⚠${NC} 依赖未安装（首次部署将自动安装）"
fi
echo ""

# 7. 检测配置文件
echo -n "检测配置文件... "
CONFIG_OK=true
if [ ! -f "configs/config.json" ]; then
    echo -e "${YELLOW}⚠${NC} config.json 不存在（将自动创建）"
    CONFIG_OK=false
else
    echo -e "${GREEN}✓${NC} config.json 存在"
fi
echo ""

# 总结
echo "=========================================="
echo "📊 检测总结"
echo "=========================================="
echo ""

# 判断可用的部署方案
AVAILABLE_PLANS=()

if [ "$NODEJS_INSTALLED" = true ] && [ "$NPM_INSTALLED" = true ]; then
    AVAILABLE_PLANS+=("本地直接运行（推荐）")
fi

if [ "$DOCKER_INSTALLED" = true ] && [ "$DOCKER_RUNNING" = true ]; then
    AVAILABLE_PLANS+=("Docker 容器部署")
fi

if [ ${#AVAILABLE_PLANS[@]} -eq 0 ]; then
    echo -e "${RED}✗${NC} 当前环境不满足最低要求"
    echo ""
    echo "需要安装:"
    echo "  1. Node.js (版本 >= 20.0.0)"
    echo "  2. npm"
    echo ""
    echo "下载地址: https://nodejs.org/"
    exit 1
fi

echo "✅ 可用的部署方案:"
for plan in "${AVAILABLE_PLANS[@]}"; do
    echo "   - $plan"
done
echo ""

# 推荐方案
if [ ${#AVAILABLE_PLANS[@]} -eq 2 ]; then
    echo -e "${BLUE}💡 推荐: 本地直接运行${NC}"
    echo "   原因: 启动更快、调试更方便、资源占用更少"
    echo ""
    echo "   快速开始:"
    echo "   bash 一键部署.sh"
    echo ""
else
    echo -e "${BLUE}💡 推荐: ${AVAILABLE_PLANS[0]}${NC}"
    echo ""
    echo "   快速开始:"
    echo "   bash 一键部署.sh"
    echo ""
fi

# Docker 信息
if [ "$DOCKER_INSTALLED" = true ] && [ "$DOCKER_RUNNING" = true ]; then
    echo "   也可使用 Docker:"
    echo "   cd docker && docker compose up -d"
    echo ""
fi

echo "=========================================="
echo "下一步操作:"
echo "=========================================="
echo ""
echo "1. 一键部署（本地运行）:"
echo "   bash 一键部署.sh"
echo ""
echo "2. 完整部署（带检查）:"
echo "   bash deploy.sh"
echo ""
echo "3. 健康检查:"
echo "   bash health-check.sh"
echo ""
