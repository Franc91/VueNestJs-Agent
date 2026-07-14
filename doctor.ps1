param(
    [string]$TargetPath = ""
)

$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$code = & (Join-Path $Root "scripts\Get-InstallTarget.ps1") -TargetPath $TargetPath

Write-Host "Agent bundle: $Root"
Write-Host "Code workspace: $code"
Write-Host ""

$ok = $true

function Test-Check([string]$Label, [bool]$Pass, [string]$Hint = "") {
    if ($Pass) {
        Write-Host "[OK]   $Label" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $Label" -ForegroundColor Red
        if ($Hint) { Write-Host "       $Hint" -ForegroundColor Yellow }
        $script:ok = $false
    }
}

Test-Check "install.config.json exists" (Test-Path (Join-Path $Root "install.config.json")) "Copy install.config.example.json"
Test-Check "code workspace exists" (Test-Path $code) "Fix codeWorkspace in install.config.json"
Test-Check "AGENTS.md installed" (Test-Path (Join-Path $code "AGENTS.md")) "Run .\install.ps1"
Test-Check ".cursor/ installed" (Test-Path (Join-Path $code ".cursor\rules\general.mdc")) "Run .\install.ps1"
Test-Check "decision.md present" (Test-Path (Join-Path $code ".cursor\specialists\decision.md")) "Run .\install.ps1"
Test-Check "skills-lock.json installed" (Test-Path (Join-Path $code "skills-lock.json")) "Run .\install.ps1"

$agentsDir = Join-Path $code ".agents\skills"
$hasSupplementary = $false
if (Test-Path $agentsDir) {
    $hasSupplementary = Get-ChildItem $agentsDir -Directory -ErrorAction SilentlyContinue |
        Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } |
        Select-Object -First 1
}
Test-Check "supplementary skills installed" ([bool]$hasSupplementary) "Run .\install.ps1 -InstallSupplementary"

$legacy = Join-Path $env:USERPROFILE "Desktop\dealer-platform-docker\dealer-platform-cursor"
if (Test-Path $legacy) {
    Write-Host "[WARN] Legacy bundle still exists: $legacy" -ForegroundColor Yellow
    Write-Host "       Run .\cleanup-legacy.ps1 to remove (optional)." -ForegroundColor Yellow
}

Write-Host ""
Push-Location $code
node .cursor/scripts/validate-agent-links.mjs
$validateOk = $LASTEXITCODE -eq 0
Pop-Location
Test-Check "link validator" $validateOk "Fix broken links in bundle repo, then reinstall"

Write-Host ""
if ($ok -and $validateOk) {
    Write-Host "All checks passed." -ForegroundColor Green
    exit 0
}

Write-Host "Some checks failed." -ForegroundColor Red
exit 1
