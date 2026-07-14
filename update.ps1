param(
    [string]$TargetPath = "",
    [switch]$InstallSupplementary
)

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

Write-Host "Updating VueNestJs Agent..."
if (Test-Path (Join-Path $Root ".git")) {
    git -C $Root pull --ff-only
    if ($LASTEXITCODE -ne 0) {
        Write-Error "git pull failed. Resolve manually, then rerun .\update.ps1"
    }
} else {
    Write-Host "Not a git repo — skipping pull."
}

& (Join-Path $Root "install.ps1") -TargetPath $TargetPath -InstallSupplementary:$InstallSupplementary
exit $LASTEXITCODE
