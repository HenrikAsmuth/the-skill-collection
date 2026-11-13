# Usage: install-skills.ps1 [-Claude]
#
# Without options, creates a junction from %USERPROFILE%\.copilot\skills to this
# repository's .github\skills.
#
# -Claude (or --claude) installs for Claude Code instead: creates one junction per
# skill in %USERPROFILE%\.claude\skills\<skill-name>, because Claude Code only
# discovers skills one level deep. Set $env:CLAUDE_DIR to another .claude folder,
# e.g. C:\path\to\project\.claude, to install for one project.
param(
    [switch]$Claude,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$RemainingArgs
)

$ErrorActionPreference = 'Stop'

foreach ($arg in $RemainingArgs) {
    if ($arg -eq '--claude') {
        $Claude = $true
    } else {
        Write-Error "Unknown option: $arg. Usage: install-skills.ps1 [-Claude]"
        exit 1
    }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsPath = Join-Path $repoRoot '.github\skills'

if (-not (Test-Path -LiteralPath $skillsPath -PathType Container)) {
    Write-Error "Skills directory not found: $skillsPath"
    exit 1
}

if (-not $Claude) {
    $copilotPath = Join-Path $env:USERPROFILE '.copilot'
    $linkPath = Join-Path $copilotPath 'skills'

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
    exit 0
}

# Claude Code looks for <skills-dir>\<name>\SKILL.md, so the category folders
# (engineering\, productivity\, ...) are flattened into one junction per skill.
$claudePath = if ($env:CLAUDE_DIR) { $env:CLAUDE_DIR } else { Join-Path $env:USERPROFILE '.claude' }
$destPath = Join-Path $claudePath 'skills'
New-Item -ItemType Directory -Path $destPath -Force | Out-Null

$linked = 0
$present = 0
$conflicts = 0
$seen = @{}

$skillsRoot = (Get-Item -LiteralPath $skillsPath).FullName
$skillDirs = Get-ChildItem -LiteralPath $skillsPath -Recurse -File -Filter 'SKILL.md' |
    Where-Object { $_.Directory.FullName -ne $skillsRoot } |
    ForEach-Object { $_.Directory } |
    Sort-Object FullName

foreach ($skillDir in $skillDirs) {
    $name = $skillDir.Name
    $linkPath = Join-Path $destPath $name

    if ($seen.ContainsKey($name)) {
        Write-Warning "Conflict: skill name '$name' is used by both $($seen[$name]) and $($skillDir.FullName)"
        $conflicts++
        continue
    }
    $seen[$name] = $skillDir.FullName

    $existing = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue
    if ($null -ne $existing) {
        $existingTarget = @($existing.Target)[0]
        if ($existing.LinkType -and $existingTarget -and
            ((Resolve-Path -LiteralPath $existingTarget).Path -eq $skillDir.FullName)) {
            $present++
            continue
        }
        Write-Warning "Conflict: destination already exists: $linkPath"
        $conflicts++
        continue
    }

    try {
        New-Item -ItemType Junction -Path $linkPath -Target $skillDir.FullName | Out-Null
    } catch {
        Write-Error "Could not create skill junction at '$linkPath': $_"
        exit 1
    }
    Write-Host "Linked skill: $linkPath -> $($skillDir.FullName)"
    $linked++
}

Write-Host "Claude skills in ${destPath}: $linked linked, $present already linked, $conflicts conflicts."

if ($conflicts -gt 0) {
    Write-Error 'Move, rename or merge the conflicting entries yourself, then run this script again.'
    exit 1
}
