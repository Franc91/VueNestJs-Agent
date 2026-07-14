param(
    [string]$TargetPath = ""
)

$Root = Split-Path $PSScriptRoot -Parent

if ($TargetPath) {
    return (Resolve-Path -LiteralPath $TargetPath).Path
}

$configPath = Join-Path $Root "install.config.json"
if (-not (Test-Path $configPath)) {
    throw "Missing install.config.json. Copy install.config.example.json and set codeWorkspace."
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json
if (-not $config.codeWorkspace) {
    throw "install.config.json must contain codeWorkspace."
}

return $config.codeWorkspace
