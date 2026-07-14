param(
    [string]$TargetPath = (Join-Path (Split-Path $PSScriptRoot -Parent) "code")
)

$ErrorActionPreference = "Stop"

Push-Location $TargetPath

$commands = @(
    @("hyf0/vue-skills", "vue-best-practices"),
    @("hyf0/vue-skills", "vue-pinia-best-practices"),
    @("hyf0/vue-skills", "vue-router-best-practices"),
    @("antfu/skills", "vue"),
    @("jeffallan/claude-skills", "vue-expert"),
    @("kadajett/agent-nestjs-skills", "nestjs-best-practices"),
    @("jeffallan/claude-skills", "nestjs-expert"),
    @("wshobson/agents", "typescript-advanced-types"),
    @("sickn33/antigravity-awesome-skills", "typescript-expert")
)

foreach ($pair in $commands) {
    $repo = $pair[0]
    $skill = $pair[1]
    Write-Host ">> npx skills add $repo -s $skill"
    npx skills add $repo -s $skill -a cursor -y
    if ($LASTEXITCODE -ne 0) {
        Pop-Location
        throw "Failed installing $skill"
    }
}

Pop-Location
Write-Host "Supplementary skills installed under $TargetPath/.agents/skills/"
