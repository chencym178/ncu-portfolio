# =====================================================================
#  setup.ps1 · 有 Git 的同学走这条路：本地 git init + 首个 Commit + 推送
#  ---------------------------------------------------------------------
#  用法（在仓库根目录打开 PowerShell）：
#      .\setup.ps1
#  或指定参数：
#      .\setup.ps1 -UserName "chencym178" -UserEmail "你的邮箱@example.com"
#
#  前置条件：已安装 Git for Windows（https://git-scm.com/download/win）
#  本地没装 Git？请改用同目录下的 auto-upload.ps1（零安装，走 GitHub API）。
# =====================================================================

[CmdletBinding()]
param(
    [string]$RepoUrl    = 'https://github.com/chencym178/ncu-portfolio.git',
    [string]$UserName   = 'chencym178',
    [string]$UserEmail  = '',
    [string]$Branch     = 'main',
    [string]$WorkDir    = '',
    [string]$CommitMsg  = 'chore: init NCU portfolio repo with 16-week skeleton'
)

# 注意：Windows PowerShell 5.1 在参数绑定阶段 $PSScriptRoot 仍为空，
# 所以不能在 param 默认值里直接用它，必须在脚本体内兜底。
if (-not $WorkDir) { $WorkDir = $PSScriptRoot }
if (-not $WorkDir) { $WorkDir = (Get-Location).Path }

$ErrorActionPreference = 'Stop'

function Info ($m) { Write-Host $m -ForegroundColor Cyan }
function Ok   ($m) { Write-Host $m -ForegroundColor Green }
function Warn ($m) { Write-Host $m -ForegroundColor Yellow }

# ---------- 0. 工作目录 ----------
if (-not (Test-Path $WorkDir)) {
    Write-Host "❌ 工作目录不存在：$WorkDir" -ForegroundColor Red
    exit 1
}
Set-Location -Path $WorkDir
Ok ">>> 工作目录：$WorkDir"

# ---------- 1. 检查 Git ----------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host '❌ 未检测到 git。' -ForegroundColor Red
    Write-Host '   方案 A：安装 Git for Windows → https://git-scm.com/download/win' -ForegroundColor Yellow
    Write-Host '   方案 B：不装 Git，直接运行 .\auto-upload.ps1（走 GitHub API）' -ForegroundColor Yellow
    exit 1
}
Ok ">>> Git 版本：$(git --version)"

# ---------- 2. 配置提交身份（缺一不可，否则 commit 会失败）----------
$currentName  = (git config --global user.name)  2>$null
$currentEmail = (git config --global user.email) 2>$null

if (-not $currentName -or -not $currentEmail) {
    if (-not $UserEmail) {
        Warn '⚠  尚未配置 Git 提交身份，且未传入 -UserEmail。'
        Write-Host '   提交时必须写明"谁提交的"，请先执行：' -ForegroundColor Yellow
        Write-Host '     git config --global user.name  "你的GitHub用户名"' -ForegroundColor Yellow
        Write-Host '     git config --global user.email "你的注册邮箱@example.com"' -ForegroundColor Yellow
        exit 1
    }
    git config --global user.name  $UserName
    git config --global user.email $UserEmail
    Ok ">>> 已写入全局提交身份：$UserName <$UserEmail>"
} else {
    Ok ">>> 提交身份已存在：$currentName <$currentEmail>"
}

# ---------- 3. git init ----------
if (Test-Path (Join-Path $WorkDir '.git')) {
    Warn '⚠  当前目录已经是 git 仓库（.git 已存在），跳过 git init。'
} else {
    git init | Out-Null
    Ok '>>> 已执行 git init（生成本地版本库 .git/）'
}

# 统一主分支名为 main
git symbolic-ref HEAD "refs/heads/$Branch" 2>$null | Out-Null
git checkout -b $Branch 2>$null | Out-Null
Ok ">>> 当前分支：$Branch"

# ---------- 4. 安全检查：确认机密不会被提交 ----------
$trackedSecrets = git status --porcelain --untracked-files=all |
    Where-Object { $_ -match '\.secrets|gh_token|\.env$|credentials\.json' }
if ($trackedSecrets) {
    Write-Host '❌ 检测到敏感文件将被提交，已中止：' -ForegroundColor Red
    $trackedSecrets | ForEach-Object { Write-Host "   $_" -ForegroundColor Red }
    Write-Host '   请先确认 .gitignore 中包含 .secrets/ 与 *.token' -ForegroundColor Yellow
    exit 1
}
Ok '>>> 机密文件安全检查通过（.secrets/ 不会被提交）'

# ---------- 5. 暂存 + 首个 Commit ----------
git add -A
$staged = git diff --cached --name-only
if (-not $staged) {
    Warn '⚠  没有检测到任何改动，跳过提交。'
} else {
    git commit -m $CommitMsg | Out-Null
    $count = ($staged | Measure-Object).Count
    Ok ">>> 已完成首个 Commit，共 $count 个文件入库"
}

# ---------- 6. 关联远程仓库 ----------
$existingRemote = (git remote get-url origin) 2>$null
if ($existingRemote) {
    git remote set-url origin $RepoUrl
    Ok ">>> 已更新远程地址：$RepoUrl"
} else {
    git remote add origin $RepoUrl
    Ok ">>> 已关联远程仓库：$RepoUrl"
}

# ---------- 7. 推送 ----------
Info '>>> 正在推送到 GitHub ...'
Info '    （若弹出登录窗口，请选择 "Sign in with browser" 用浏览器完成授权）'
git push -u origin $Branch

if ($LASTEXITCODE -eq 0) {
    $web = $RepoUrl -replace '\.git$', ''
    Write-Host ''
    Ok '🎉 推送成功！'
    Ok "   仓库地址：$web"
} else {
    Write-Host ''
    Write-Host '❌ 推送失败，常见原因：' -ForegroundColor Red
    Write-Host '   1) 远程仓库还没创建 → 先去 https://github.com/new 建一个空仓库（名字 ncu-portfolio，勾 Public，不要勾 README）' -ForegroundColor Yellow
    Write-Host '   2) 没有登录凭据 → 使用 Git Credential Manager 浏览器登录' -ForegroundColor Yellow
    Write-Host '   3) 远程已有内容 → 先执行 git pull --rebase origin main' -ForegroundColor Yellow
    exit 1
}
