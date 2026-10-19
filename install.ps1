param(
    [string]$TargetPath = "",
    [switch]$InstallSupplementary
)

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

$TargetPath = & (Join-Path $Root "scripts\Get-InstallTarget.ps1") -TargetPath $TargetPath

if (-not (Test-Path $TargetPath)) {
    Write-Error "Target path not found: $TargetPath"
}

node (Join-Path $Root "scripts\sync-cursor.mjs") --target $TargetPath
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

if ($InstallSupplementary) {
    & (Join-Path $Root "install-supplementary.ps1") -TargetPath $TargetPath
}

Push-Location $TargetPath
node .cursor/scripts/validate-agent-links.mjs
$exit = $LASTEXITCODE
Pop-Location

if ($exit -eq 0) {
    Write-Host ""
    Write-Host "Done. Open code/ in Cursor -> AGENTS.md or .cursor/specialists/routing.md"
} else {
    Write-Host "Install finished with validation errors." -ForegroundColor Red
}

exit $exit
