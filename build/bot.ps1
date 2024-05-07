
param(
    [string]$BotUrl,
    [string]$Msg
)

$currentDate = (Get-Date)
$currentDateStr = $currentDate.ToString('yyyy-MM-dd HH:mm:ss')

$rootPath = Split-Path -Parent (Get-Location).Path

# 读取当前项目配置
$ciConfigPath = Join-Path $rootPath "src" "ci-config.json"
$ciConfig = (Get-Content -Path $ciConfigPath -Encoding UTF8) | ConvertFrom-Json

$branchOrTagKey = 'branch'
if ($ciConfig.mode -eq 'tag') {
    $branchOrTagKey = 'tag'
}
$branchOrTag = $ciConfig.branch
$commit = $ciConfig.commit

# 环境变量参数
$repository = $env:repository
$repositoryUrl = $env:repositoryUrl
$action_repository = $env:action_repository
$run_id = $env:run_id
$run_number = $env:run_number

$noticeMsg = @"
----------- ${currentDateStr} -----------
${Msg}

----------- build info -----------
${branchOrTagKey}: ${branchOrTag}
commit: ${commit}
repository: ${repository}
repositoryUrl: ${repositoryUrl}
action_repository: ${action_repository}
run_id: ${run_id}
run_number: ${run_number}
"@


# ----------------- 发送通知 -----------------
$body = @{
    msg_type = 'text'
    content  = @{
        text = $noticeMsg
    }
}

$bodyJson = ConvertTo-Json $body

Invoke-RestMethod `
    -Method 'Post' `
    -ContentType 'application/json' `
    -Uri $botUrl `
    -Body $bodyJson