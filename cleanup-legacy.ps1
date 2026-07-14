# Optional: remove old bundle copy from inside dealer-platform-docker (if you migrated to Desktop).

$legacy = Join-Path $env:USERPROFILE "Desktop\dealer-platform-docker\dealer-platform-cursor"
if (-not (Test-Path $legacy)) {
    Write-Host "No legacy folder at: $legacy"
    exit 0
}

Write-Host "Will remove: $legacy"
$confirm = Read-Host "Type yes to confirm"
if ($confirm -ne "yes") {
    Write-Host "Cancelled."
    exit 0
}

Remove-Item -Recurse -Force $legacy
Write-Host "Removed."
