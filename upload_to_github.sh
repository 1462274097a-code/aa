#!/bin/bash
cd "F:/agents/Storyboard-Copilot-0.1.6" || exit 1

# 尝试删除 .git 目录
if [ -d .git ]; then
    chmod -R +w .git 2>/dev/null
    rm -rf .git 2>/dev/null
fi

# 重新初始化
git init
git config core.autocrlf false
git config core.filemode false
git config user.name "GitHub Actions"
git config user.email "actions@github.com"

# 添加所有文件
git add -A

# 提交
git commit -m "Initial commit: Storyboard Copilot v0.1.7"

# 添加远程仓库
git remote add origin https://github.com/1462274097a-code/aa.git

# 推送到 main 分支
git branch -M main
git push -u origin main --force

echo "上传完成！"
EOF
chmod +x upload_to_github.sh
