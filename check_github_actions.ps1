# GitHub Actions 构建状态检查脚本
$Repo = "1462274097a-code/aa"
$ApiUrl = "https://api.github.com/repos/${Repo}/actions/runs?per_page=1"

Write-Host "🔍 检查 GitHub Actions 构建状态..." -ForegroundColor Cyan

try {
    $Response = Invoke-RestMethod -Uri $ApiUrl -Method Get
    $Run = $Response.workflow_runs[0]

    Write-Host "----------------------------------------"
    Write-Host "📊 构建信息：" -ForegroundColor Yellow
    Write-Host "  工作流: $($Run.name)"
    Write-Host "  状态: $($Run.status)" -ForegroundColor $(if ($Run.status -eq "in_progress") { "Green" } elseif ($Run.status -eq "completed") { "Cyan" } else { "Red" })
    Write-Host "  结论: $($Run.conclusion)" -ForegroundColor $(if ($Run.conclusion -eq "success") { "Green" } elseif ($Run.conclusion -eq "failure") { "Red" } else { "Yellow" })
    Write-Host "  触发方式: $($Run.event)"
    Write-Host "  分支: $($Run.head_branch)"
    Write-Host "  提交: $($Run.head_sha.Substring(0, 7))"
    Write-Host "----------------------------------------"

    if ($Run.status -eq "completed") {
        Write-Host "✅ ��建完成！" -ForegroundColor Green
        Write-Host ""
        Write-Host "🔗 查看详情：" -ForegroundColor Cyan
        Write-Host "  $($Run.html_url)"
        Write-Host ""
        Write-Host "📦 构建产物下载：" -ForegroundColor Cyan
        Write-Host "  https://github.com/${Repo}/releases/tag/v0.1.7"
    } else {
        Write-Host "⏳ 构建进行中..." -ForegroundColor Yellow
        Write-Host "  预计完成时间：30-60 分钟"
        Write-Host ""
        Write-Host "🔗 实时监控：" -ForegroundColor Cyan
        Write-Host "  $($Run.html_url)"
    }

} catch {
    Write-Host "❌ 检查失败：$_" -ForegroundColor Red
    Write-Host "请手动访问：https://github.com/${Repo}/actions"
}
