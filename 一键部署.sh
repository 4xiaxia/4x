#!/bin/bash

# 一键部署脚本 - 最简化版本

echo "🚀 AIClient-2-API 一键部署"
echo ""

# 进入项目目录
cd /workspace/AIClient-2-API

# 1. 创建配置文件（如果不存在）
echo "📝 检查配置文件..."
[ ! -f "configs/config.json" ] && cp configs/config.json.example configs/config.json
[ ! -f "configs/provider_pools.json" ] && cp configs/provider_pools.json.example configs/provider_pools.json
echo "✅ 配置文件就绪"

# 2. 安装依赖（如果需要）
if [ ! -d "node_modules" ]; then
    echo "📦 安装依赖..."
    npm install --silent
    echo "✅ 依赖安装完成"
else
    echo "✅ 依赖已存在"
fi

# 3. 停止旧服务
echo "🛑 清理旧服务..."
PID=$(lsof -ti:3000 2>/dev/null || echo "")
if [ -n "$PID" ]; then
    kill -9 $PID
    sleep 1
fi

# 4. 启动新服务
echo "▶️  启动服务..."
nohup npm start > /tmp/aiclient.log 2>&1 &

# 5. 等待服务就绪
echo "⏳ 等待服务启动..."
for i in {1..20}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo ""
        echo "========================================="
        echo "✅ 部署成功！"
        echo "========================================="
        echo ""
        echo "🌐 访问地址: http://localhost:3000"
        echo "🔑 默认密码: admin123"
        echo "📋 查看日志: tail -f /tmp/aiclient.log"
        echo ""
        exit 0
    fi
    sleep 1
done

echo ""
echo "❌ 启动超时，请查看日志:"
tail -20 /tmp/aiclient.log
exit 1
