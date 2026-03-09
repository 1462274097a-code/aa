#!/bin/bash

REPO="1462274097a-code/aa"
echo "🔍 检查 GitHub Actions 构建状态..."
echo "仓库: $REPO"
echo "标签: v0.1.7"
echo ""

# 检查最新的工作流运行状态
curl -s "https://api.github.com/repos/$REPO/actions/runs?per_page=1" | \
  grep -E '"status"|"conclusion"|"name"|"head_sha"' | head -20

echo ""
echo "📊 详细状态请访问:"
echo "https://github.com/$REPO/actions"
