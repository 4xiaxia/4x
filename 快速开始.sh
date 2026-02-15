#!/bin/bash

# 快速开始脚本 - 一键启动并打开傻瓜版界面

echo "========================================="
echo "  🚀 AI Client 2 API - 快速开始"
echo "========================================="
echo ""

# 进入项目目录
cd "$(dirname "$0")"

# 1. 检查 Node.js
echo "📋 检查 Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ 未安装 Node.js，请先安装 Node.js"
    exit 1
fi
echo "✅ Node.js 版本: $(node -v)"
echo ""

# 2. 检查依赖
echo "📦 检查依赖..."
if [ ! -d "node_modules" ]; then
    echo "正在安装依赖..."
    npm install --silent
    echo "✅ 依赖安装完成"
else
    echo "✅ 依赖已存在"
fi
echo ""

# 3. 停止旧服务
echo "🛑 清理旧服务..."
PID=$(lsof -ti:3000 2>/dev/null || echo "")
if [ -n "$PID" ]; then
    kill -9 $PID 2>/dev/null
    sleep 1
    echo "✅ 已停止旧服务"
else
    echo "✅ 无需清理"
fi
echo ""

# 4. 启动服务
echo "▶️  启动服务..."
nohup npm start > /tmp/aiclient.log 2>&1 &
SERVICE_PID=$!
echo "✅ 服务已启动 (PID: $SERVICE_PID)"
echo ""

# 5. 等待服务就绪
echo "⏳ 等待服务启动..."
for i in {1..20}; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo ""
        echo "========================================="
        echo "  ✅ 启动成功！"
        echo "========================================="
        echo ""
        echo "🌐 傻瓜版界面："
        echo "   http://localhost:3000/simple.html"
        echo ""
        echo "🔐 高级版界面："
        echo "   http://localhost:3000"
        echo ""
        echo "🔑 默认密码："
        echo "   admin123"
        echo ""
        echo "📋 查看日志："
        echo "   tail -f /tmp/aiclient.log"
        echo ""
        echo "⏹️  停止服务："
        echo "   kill $SERVICE_PID"
        echo ""
        echo "💡 小贴士："
        echo "   1. 打开傻瓜版界面"
        echo "   2. 选择一个 AI（推荐 Gemini）"
        echo "   3. 点击一键授权"
        echo "   4. 在浏览器中登录"
        echo "   5. 完成！"
        echo ""
        echo "========================================="

        # 尝试自动打开浏览器
        if command -v xdg-open &> /dev/null; then
            xdg-open http://localhost:3000/simple.html 2>/dev/null &
        elif command -v open &> /dev/null; then
            open http://localhost:3000/simple.html 2>/dev/null &
        fi

        exit 0
    fi
    sleep 1
done

echo ""
echo "❌ 启动超时，请查看日志："
tail -20 /tmp/aiclient.log
exit 1
