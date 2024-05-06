
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

$noticeMsg = @"
----------- ${currentDateStr} -----------
${Msg}

----------- build info -----------
${branchOrTagKey}: ${branchOrTag}
commit: ${commit}
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