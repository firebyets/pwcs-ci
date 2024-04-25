# 仓库地址
$RepoUrl = $env:GIT_REPO

# 顶级目录
$rootPath = Split-Path -Parent (Get-Location).Path

# 读取当前项目配置
$ciConfigPath = Join-Path $rootPath "src" "ci-config.json"
$ciConfig = (Get-Content -Path $ciConfigPath -Encoding UTF8) | ConvertFrom-Json


# 设置环境变量
[Environment]::SetEnvironmentVariable("TAG", $ciConfig.branch, "Machine")
[Environment]::SetEnvironmentVariable("TAG", $ciConfig.branch)
Write-Host "${env:TAG}"


# 克隆目标仓库代码
## git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}
if ($ciConfig.mode -eq 'commit') {
    git clone --depth 1 `
        -b $ciConfig.branch `
        $RepoUrl repo-code
    Set-Location ./repo-code
    git log
    git checkout $ciConfig.commit
    Set-Location ..
    # 切换到目标仓库代码
    Set-Location repo-code/build
}
if ($ciConfig.mode -eq 'tag') {
    git clone --depth 1 `
        --branch $ciConfig.branch `
        $RepoUrl repo-code
    Set-Location ./repo-code
    git log
    git checkout $ciConfig.commit
    Set-Location ..
    # 切换到目标仓库代码
    Set-Location repo-code/build
}










