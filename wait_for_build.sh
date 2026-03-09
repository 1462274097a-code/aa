#!/bin/bash

# GitHub Actions 构建完成等待脚本
echo "⏳ 等待 GitHub Actions 构建完成..."
echo "   仓库: 1462274097a-code/aa"
echo "   标签: v0.1.7"
echo ""

# 检查间隔（秒）
CHECK_INTERVAL=120  # 每 2 分钟检查一次
MAX_WAIT=3600       # 最长等待 1 小时
ELAPSED=0

while [ $ELAPSED -lt $MAX_WAIT ]; do
    # 检查构建状态
    RESPONSE=$(curl -s "https://api.github.com/repos/1462274097a-code/aa/actions/runs?per_page=1")

    # 使用更可靠的方法解析 JSON
    STATUS=$(echo "$RESPONSE" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
    CONCLUSION=$(echo "$RESPONSE" | grep -o '"conclusion":"[^"]*"' | head -1 | cut -d'"' -f4)

    echo "[$(date +'%H:%M:%S')] 状态: ${STATUS} | 结论: ${CONCLUSION}"

    # 检查是否完成
    if [ "$STATUS" = "completed" ]; then
        echo ""
        echo "=========================================="
        echo "🎉 构建完成！"
        echo "=========================================="
        echo "结论: ${CONCLUSION}"
        echo ""

        if [ "$CONCLUSION" = "success" ]; then
            echo "✅ 构建成功！"
            echo ""
            echo "📦 便携式 exe 已准备好下载！"
            echo ""
            echo "下载方式："
            echo "  1. 访问 GitHub Releases 页面："
            echo "     https://github.com/1462274097a-code/aa/releases/tag/v0.1.7"
            echo ""
            echo "  2. 下载 Windows 安装程序："
            echo "     Storyboard-Copilot_0.1.7_x64-setup.exe"
            echo ""
            echo "  3. 直接下载链接（构建完成后可用）："
            echo "     https://github.com/1462274097a-code/aa/releases/download/v0.1.7/Storyboard-Copilot_0.1.7_x64-setup.exe"
            echo ""
            echo "🎊 恭喜！你的分镜助手便携式 exe 已经准备好了！"
        else
            echo "❌ 构建失败（${CONCLUSION}）"
            echo ""
            echo "请检查构建日志："
            echo "  https://github.com/1462274097a-code/aa/actions"
        fi

        echo "=========================================="
        exit 0
    fi

    # 等待下次检查
    if [ $ELAPSED -lt $((MAX_WAIT - CHECK_INTERVAL)) ]; then
        sleep $CHECK_INTERVAL
        ELAPSED=$((ELAPSED + CHECK_INTERVAL))
    else
        break
    fi
done

echo ""
echo "⏰ 等待超时"
echo "请手动检查构建状态："
echo "  https://github.com/1462274097a-code/aa/actions"
exit 1
