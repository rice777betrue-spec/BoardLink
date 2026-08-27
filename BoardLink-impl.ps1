param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Command,

    [Parameter(Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

# Configure these before using BoardLink:
#   $env:BOARDLINK_USER = "root"
#   $env:BOARDLINK_HOST = "192.168.1.179"
$BoardUser = $env:BOARDLINK_USER
$BoardHost = $env:BOARDLINK_HOST

if ([string]::IsNullOrWhiteSpace($BoardUser) -or [string]::IsNullOrWhiteSpace($BoardHost)) {
    Write-Host 'BoardLink is not configured.' -ForegroundColor Yellow
    Write-Host 'Set BOARDLINK_USER and BOARDLINK_HOST in PowerShell first.' -ForegroundColor Yellow
    exit 2
}

$Target = "$BoardUser@$BoardHost"

# Upload a local file to the board:
# boardlink upload "C:\path\file.txt" "/root/file.txt"
if ($Command -eq "upload") {
    if ($Arguments.Count -ne 2) {
        Write-Host 'Usage: boardlink upload "local-file" "board-path"' -ForegroundColor Yellow
        exit 2
    }

    $LocalFile = $Arguments[0]
    $BoardPath = $Arguments[1]

    if (-not (Test-Path -LiteralPath $LocalFile -PathType Leaf)) {
        Write-Host "Local file not found: $LocalFile" -ForegroundColor Red
        exit 1
    }

    Write-Host "Uploading to $Target`:$BoardPath ..." -ForegroundColor Cyan
    & scp $LocalFile "${Target}:$BoardPath"

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Upload failed. Exit code: $LASTEXITCODE" -ForegroundColor Red
        exit $LASTEXITCODE
    }

    Write-Host "Upload completed." -ForegroundColor Green
    exit 0
}

Write-Host "Connecting to $Target ..." -ForegroundColor Cyan
& ssh $Target $Command

if ($LASTEXITCODE -ne 0) {
    Write-Host "Command failed. Exit code: $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Command completed." -ForegroundColor Green
