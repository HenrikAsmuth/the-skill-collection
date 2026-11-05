$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsPath = Join-Path $repoRoot '.github\skills'
$copilotPath = Join-Path $env:USERPROFILE '.copilot'
$linkPath = Join-Path $copilotPath 'skills'

if (-not (Test-Path -LiteralPath $skillsPath -PathType Container)) {
    Write-Error "Skills directory not found: $skillsPath"
    exit 1
}

New-Item -ItemType Directory -Path $copilotPath -Force | Out-Null

$existingPath = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue
if ($null -ne $existingPath) {
    Write-Error "Cannot install skills: destination already exists: $linkPath. Move or merge it yourself, then run this script again."
    exit 1
}

try {
    New-Item -ItemType Junction -Path $linkPath -Target $skillsPath | Out-Null
} catch {
    Write-Error "Could not create skills junction at '$linkPath': $_"
    exit 1
}

Write-Host "Linked skills: $linkPath -> $skillsPath"