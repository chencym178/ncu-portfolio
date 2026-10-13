# =====================================================================
#  auto-upload.ps1 · 零安装把作品集推上 GitHub（自动建仓 + 首个 Commit）
#  ---------------------------------------------------------------------
#  适用：本地没有 Git（或不想装 Git），但希望"一条命令完成建仓 + 首个 Commit"。
#
#  原理：调用 GitHub 官方 Git Data API
#        blob（文件内容） → tree（目录结构） → commit（快照） → ref（分支指针）
#        整个过程只产生 1 个 Commit，与 git init + git add . + git commit 等价。
#        同时会读取本地 .gitignore，被忽略的文件不会上传。
#
#  用法（三选一提供 Token）：
#    ① 写入文件（最安全，Token 不会出现在对话/命令历史里）
#       .\auto-upload.ps1
#       （会提示你把 Token 写到 .secrets\gh_token.txt）
#
#    ② 通过参数传入
#       .\auto-upload.ps1 -Token "github_pat_xxx"
#
#    ③ 通过环境变量
#       $env:GITHUB_TOKEN = "github_pat_xxx"
#       .\auto-upload.ps1
#
#  Token 生成地址（勾选 repo 权限即可）：https://github.com/settings/tokens
#  完成后请立即删除 Token。
# =====================================================================

[CmdletBinding()]
param(
    [string]$Token,
    [string]$Username    = 'chencym178',
    [string]$RepoName    = 'ncu-portfolio',
    [string]$RootPath    = '',
    [string]$CommitMsg   = 'chore: init NCU portfolio repo with 16-week skeleton',
    [string]$Description = '南昌大学 · 个人课程作品集',
    [string]$Branch      = 'main'
)

# 注意：Windows PowerShell 5.1 在参数绑定阶段 $PSScriptRoot 仍为空，
# 所以不能在 param 默认值里直接用它，必须在脚本体内兜底。
if (-not $RootPath) { $RootPath = $PSScriptRoot }
if (-not $RootPath) { $RootPath = (Get-Location).Path }

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Info  ($m) { Write-Host $m -ForegroundColor Cyan }
function Ok    ($m) { Write-Host $m -ForegroundColor Green }
function Warn  ($m) { Write-Host $m -ForegroundColor Yellow }

# ---------- 0. 准备 Token ----------
if (-not $Token) {
    if ($env:GITHUB_TOKEN) { $Token = $env:GITHUB_TOKEN }
    elseif (Test-Path (Join-Path $RootPath '.secrets\gh_token.txt')) {
        $Token = (Get-Content (Join-Path $RootPath '.secrets\gh_token.txt') -Raw)
    }
}

if ($Token) {
    # 清理 BOM / 零宽字符 / 换行 / 空格（记事本保存常引入，会导致认证莫名失败）
    $Token = $Token.Trim([char]0xFEFF).Trim([char]0x200B).Trim()
}

if (-not $Token -or $Token -like 'PASTE_*' -or $Token.Length -lt 20) {
    Write-Host '❌ Token 未就绪（未找到 / 仍是占位符 / 长度异常）。' -ForegroundColor Red
    Write-Host ''
    Write-Host '   请把真实 Token 写入这一行文件：' -ForegroundColor Yellow
    Write-Host "   $RootPath\.secrets\gh_token.txt" -ForegroundColor Yellow
    Write-Host '   生成地址（勾选 repo 权限）：https://github.com/settings/tokens/new' -ForegroundColor Yellow
    exit 1
}

$headers = @{
    Authorization          = "Bearer $Token"
    Accept                 = 'application/vnd.github+json'
    'X-GitHub-Api-Version' = '2022-11-28'
    'User-Agent'           = 'ncu-portfolio-setup'
}
$api = 'https://api.github.com'

function Invoke-Api {
    param([string]$Uri, [string]$Method = 'Get', $Body)
    $p = @{ Uri = $Uri; Headers = $headers; Method = $Method }
    if ($null -ne $Body) {
        $p.Body        = $Body
        $p.ContentType = 'application/json; charset=utf-8'
    }
    Invoke-RestMethod @p
}

# ---------- 1. 验证 Token ----------
Info '>>> 正在验证 Token ...'
try {
    $me = Invoke-Api -Uri "$api/user"
} catch {
    Write-Host "❌ Token 无效或已过期：$($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
Ok "✅ Token 有效，登录账号：$($me.login)"

if ($Username -eq 'chencym178' -and $me.login -ne $Username) {
    Warn "⚠  参数 Username=$Username 与 Token 实际账号 $($me.login) 不一致，已按实际账号继续。"
    $Username = $me.login
}

# ---------- 2. 创建公开仓库（已存在则复用）----------
$repoUrl = "https://github.com/$Username/$RepoName"
$repoExists = $false
try {
    $null = Invoke-Api -Uri "$api/repos/$Username/$RepoName"
    $repoExists = $true
} catch {
    if ($_.Exception.Response.StatusCode.value__ -ne 404) { throw }
}

if ($repoExists) {
    Warn "⚠  仓库已存在，跳过创建：$repoUrl"
} else {
    $body = @{
        name        = $RepoName
        description = $Description
        private     = $false
        auto_init   = $false
    } | ConvertTo-Json -Compress

    $null = Invoke-Api -Method Post -Uri "$api/user/repos" -Body $body
    Ok "✅ 已创建公开仓库：$repoUrl"
}

# ---------- 2.5 空仓库引导（GitHub 限制：零提交的仓库不接受 git/blobs 请求）----------
# 现象：全新空仓库调用 POST /git/blobs 会返回 409 "Git Repository is empty"。
# 解决：先用 Contents API 写入一个文件（自动产生仓库的首个提交），把仓库"激活"。
$parentSha     = $null
$branchExisted = $false
try {
    $ref = Invoke-Api -Uri "$api/repos/$Username/$RepoName/git/ref/heads/$Branch"
    $parentSha     = $ref.object.sha
    $branchExisted = $true
    Info ">>> 远程分支 $Branch 已存在，将基于 $($parentSha.Substring(0,7)) 追加提交"
} catch {
    Info ">>> 远程分支 $Branch 尚不存在（空仓库），准备引导 ..."
}

if (-not $parentSha) {
    $seedPath = Join-Path $RootPath '.gitignore'
    $seedMsg  = 'chore: init repository with .gitignore'
    if (-not (Test-Path $seedPath)) {
        # 极端兜底：本地没有 .gitignore 就用一个最小说明文件激活仓库
        $seedPath = Join-Path $env:TEMP 'ncu-seed-README.md'
        '# NCU Portfolio' | Set-Content -Path $seedPath -Encoding UTF8
        $seedMsg  = 'chore: init repository'
    }

    Info '>>> 正在引导空仓库（写入 .gitignore，产生仓库首个提交）...'
    $seedBody = @{
        message = $seedMsg
        content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($seedPath))
    } | ConvertTo-Json -Compress

    $seed = Invoke-Api -Method Put `
        -Uri "$api/repos/$Username/$RepoName/contents/.gitignore" -Body $seedBody

    $parentSha     = $seed.commit.sha
    $branchExisted = $true
    Ok "✅ 仓库已激活，引导提交：$($parentSha.Substring(0,7))"
}

# ---------- 3. 读取 .gitignore，筛选待上传文件 ----------
$ignoreRules = @()
$ignoreFile  = Join-Path $RootPath '.gitignore'
if (Test-Path $ignoreFile) {
    $ignoreRules = Get-Content $ignoreFile -Encoding UTF8 |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith('#') }
    Info ">>> 已读取 .gitignore，共 $($ignoreRules.Count) 条规则"
}

function Test-Ignored {
    param([string]$RelPath)
    $name = Split-Path $RelPath -Leaf
    foreach ($rule in $ignoreRules) {
        $r = $rule.TrimEnd('/')
        if ($rule.EndsWith('/')) {
            # 目录规则：路径中任意层级命中即忽略
            if ($RelPath -like "$r/*" -or $RelPath -like "*/$r/*") { return $true }
        } else {
            if ($RelPath -like $r -or $name -like $r) { return $true }
        }
    }
    return $false
}

$alwaysSkip = @('\.git\', '\.secrets\')

$files = Get-ChildItem -Path $RootPath -Recurse -File -Force | Where-Object {
    $full = $_.FullName
    $skip = $false
    foreach ($s in $alwaysSkip) { if ($full -match [regex]::Escape($s)) { $skip = $true } }
    if ($skip) { return $false }

    $rel = $full.Substring($RootPath.Length + 1).Replace('\', '/')
    if (Test-Ignored -RelPath $rel) {
        Warn "  [忽略] $rel"
        return $false
    }
    return $true
} | Sort-Object FullName

if (-not $files -or $files.Count -eq 0) {
    Write-Host '❌ 没有找到任何可上传的文件，请检查 RootPath 是否正确。' -ForegroundColor Red
    exit 1
}
Ok ">>> 共 $($files.Count) 个文件待上传（已按 .gitignore 过滤）"

# ---------- 4. 上传 blob（文件内容）----------
Info '>>> 正在上传文件内容（blob）...'
$treeEntries = @()
foreach ($f in $files) {
    $rel = $f.FullName.Substring($RootPath.Length + 1).Replace('\', '/')
    $contentB64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($f.FullName))
    $blobBody = @{ content = $contentB64; encoding = 'base64' } | ConvertTo-Json -Compress
    $blob = Invoke-Api -Method Post -Uri "$api/repos/$Username/$RepoName/git/blobs" -Body $blobBody

    $treeEntries += [ordered]@{
        path = $rel
        mode = '100644'
        type = 'blob'
        sha  = $blob.sha
    }
    Write-Host "  [blob] $rel" -ForegroundColor DarkGray
}

# ---------- 5. 生成 tree（目录结构）----------
Info '>>> 正在生成目录结构（tree）...'
# 注意：$treeEntries 需强制包成数组，否则只有 1 个文件时会被序列化成对象而非数组
$treeBody = @{ tree = @($treeEntries) } | ConvertTo-Json -Compress -Depth 6
$tree = Invoke-Api -Method Post -Uri "$api/repos/$Username/$RepoName/git/trees" -Body $treeBody
Ok "✅ tree: $($tree.sha)"

# ---------- 6. 生成 Commit（挂在父提交之后，形成完整历史链）----------
Info '>>> 正在生成 Commit ...'
$commitParams = @{ message = $CommitMsg; tree = $tree.sha }
if ($parentSha) { $commitParams.parents = @($parentSha) }
$commitBody = $commitParams | ConvertTo-Json -Compress -Depth 4
$commit = Invoke-Api -Method Post -Uri "$api/repos/$Username/$RepoName/git/commits" -Body $commitBody
Ok "✅ commit: $($commit.sha)"

# ---------- 7. 把分支指针指向该 Commit ----------
if ($branchExisted) {
    Info ">>> 正在更新分支 $Branch 的指针 ..."
    $refBody = @{ sha = $commit.sha; force = $true } | ConvertTo-Json -Compress
    $null = Invoke-Api -Method Patch -Uri "$api/repos/$Username/$RepoName/git/refs/heads/$Branch" -Body $refBody
} else {
    Info ">>> 正在创建分支 $Branch ..."
    $refBody = @{ ref = "refs/heads/$Branch"; sha = $commit.sha } | ConvertTo-Json -Compress
    $null = Invoke-Api -Method Post -Uri "$api/repos/$Username/$RepoName/git/refs" -Body $refBody
}
Ok "✅ 分支 $Branch 已就位"

# ---------- 8. 收尾 ----------
Write-Host ''
Write-Host '🎉 全部完成！' -ForegroundColor Green
Write-Host "   仓库地址：$repoUrl" -ForegroundColor Cyan
Write-Host "   本次 Commit：$($commit.sha.Substring(0,7))  «$CommitMsg»" -ForegroundColor Cyan
Write-Host ''
Warn '⚠  安全提醒：请立即删除本次使用的 Token'
Warn '   https://github.com/settings/tokens'
