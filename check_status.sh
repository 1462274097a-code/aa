#!/bin/bash

# 快速检查构建状态脚本
echo "🔍 检查 Storyboard Copilot v0.1.7 构建状态..."
echo ""

# 获取最新状态
RESPONSE=$(curl -s "https://api.github.com/repos/1462274097a-code/aa/actions/runs?per_page=1")

# 提取关键信息
STATUS=$(echo "$RESPONSE" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
CONCLUSION=$(echo "$RESPONSE" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "📊 当前状态："
echo "   状态: $STATUS"
echo "   结论: $CONCLUSION"
echo ""

if [ "$STATUS" = "completed" ]; then
    if [ "$CONCLUSION" = "success" ]; then
        echo "✅ 构建成��！"
        echo ""
        echo "📦 下载链接："
        echo "   Windows: https://github.com/1462274097a-code/aa/releases/download/v0.1.7/Storyboard-Copilot_0.1.7_x64-setup.exe"
        echo "   macOS: https://github.com/1462274097a-code/aa/releases/download/v0.1.7/Storyboard-Copilot_0.1.7_universal.dmg"
        echo ""
        echo "🌐 发布页面："
        echo "   https://github.com/1462274097a-code/aa/releases/tag/v0.1.7"
    else
        echo "❌ 构建失败：$CONCLUSION"
        echo "🔗 查看详情：https://github.com/1462274097a-code/aa/actions"
    fi
else
    echo "⏳ 构建进行中..."
    echo "   预计还需 20-40 分钟"
    echo ""
    echo "🔗 实时监控："
    echo "   https://github.com/1462274097a-code/aa/actions"
fi
