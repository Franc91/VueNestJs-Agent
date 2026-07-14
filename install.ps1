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

Write-Host "Installing agent setup to: $TargetPath"

$mcpTarget = Join-Path $TargetPath ".cursor\mcp.json"
$mcpBackup = $null
if (Test-Path $mcpTarget) {
    $mcpBackup = Get-Content $mcpTarget -Raw -Encoding UTF8
    Write-Host "Preserving existing .cursor/mcp.json"
}

$targetCursor = Join-Path $TargetPath ".cursor"
if (Test-Path $targetCursor) {
    Remove-Item -Recurse -Force $targetCursor
}

Copy-Item -Recurse -Force (Join-Path $Root ".cursor") $targetCursor
Copy-Item -Force (Join-Path $Root "AGENTS.md") (Join-Path $TargetPath "AGENTS.md")
Copy-Item -Force (Join-Path $Root "skills-lock.json") (Join-Path $TargetPath "skills-lock.json")

if ($mcpBackup) {
    Set-Content -Path $mcpTarget -Value $mcpBackup -Encoding UTF8 -NoNewline
} elseif (Test-Path (Join-Path $Root "mcp.example.json")) {
    Copy-Item (Join-Path $Root "mcp.example.json") $mcpTarget
    Write-Host "Created .cursor/mcp.json from mcp.example.json (configure if needed)."
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
    Write-Host "Done. Open code/ in Cursor -> AGENTS.md or .cursor/specialists/decision.md"
} else {
    Write-Host "Install finished with validation errors." -ForegroundColor Red
}

exit $exit
