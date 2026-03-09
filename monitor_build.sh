#!/bin/bash

# GitHub Actions 构建监控脚本
REPO="1462274097a-code/aa"
API_BASE="https://api.github.com/repos/${REPO}/actions/runs"

echo "🚀 开始监控 GitHub Actions 构建状态..."
echo "仓库: ${REPO}"
echo "标签: v0.1.7"
echo "----------------------------------------"

# 初始等待时间（秒）
WAIT_TIME=30
MAX_WAIT=3600  # 最长等待 1 小时
ELAPSED=0

while [ $ELAPSED -lt $MAX_WAIT ]; do
    # 获取最新的工作流运行状态
    RESPONSE=$(curl -s "${API_BASE}?per_page=1" 2>/dev/null)

    # 解析状态
    STATUS=$(echo "$RESPONSE" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
    CONCLUSION=$(echo "$RESPONSE" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)
    RUN_URL=$(echo "$RESPONSE" | grep -o '"html_url":"[^"]*"' | head -1 | cut -d'"' -f4 | sed 's/\\u002F/\//g')

    echo "[$(date +'%H:%M:%S')] 状态: ${STATUS} | 结论: ${CONCLUSION}"

    # 检查是否完成
    if [ "$STATUS" = "completed" ]; then
        echo "----------------------------------------"
        echo "✅ 构建完成！"
        echo "结论: ${CONCLUSION}"
        echo "详情: ${RUN_URL}"

        if [ "$CONCLUSION" = "success" ]; then
            echo ""
            echo "📦 构建产物："
            echo "  - Windows 安装程序 (.exe)"
            echo "  - macOS 安装程序 (.dmg)"
            echo ""
            echo "下载链接："
            echo "  https://github.com/${REPO}/actions/workflows/build.yml"
            echo ""
            echo "或在 GitHub Releases 页面下载："
            echo "  https://github.com/${REPO}/releases/tag/v0.1.7"
        fi

        exit 0
    fi

    # 等待一段时间再检查
    sleep $WAIT_TIME
    ELAPSED=$((ELAPSED + WAIT_TIME))

    # 每 5 分钟输出一次进度
    if [ $((ELAPSED % 300)) -eq 0 ]; then
        echo "⏳ 已等待 $((ELAPSED / 60)) 分钟..."
    fi
done

echo "❌ 构建超时（超过 $((MAX_WAIT / 60)) 分钟）"
echo "请手动检查构建状态："
echo "  ${RUN_URL}"
exit 1
