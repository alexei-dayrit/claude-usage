# Claude Code settings sync setup for Windows
# Run this once from within the cloned repo directory:
#   cd C:\Users\<you>\Documents\claude-usage
#   PowerShell -ExecutionPolicy Bypass -File setup-windows.ps1

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SettingsDir = Join-Path $RepoRoot "settings"
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

# Ensure ~/.claude exists
if (-not (Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Path $ClaudeDir | Out-Null
    Write-Host "Created $ClaudeDir"
}

function Create-Symlink {
    param(
        [string]$LinkPath,
        [string]$TargetPath
    )

    if (Test-Path $LinkPath) {
        $item = Get-Item $LinkPath -Force
        if ($item.LinkType -eq "SymbolicLink") {
            Write-Host "  Already linked: $LinkPath"
            return
        }
        # Back up the existing file
        $backup = "$LinkPath.bak"
        Move-Item $LinkPath $backup
        Write-Host "  Backed up existing file to $backup"
    }

    New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath | Out-Null
    Write-Host "  Linked: $LinkPath -> $TargetPath"
}

Write-Host ""
Write-Host "Linking Claude Code settings to repo..."
Create-Symlink -LinkPath (Join-Path $ClaudeDir "settings.json")    -TargetPath (Join-Path $SettingsDir "settings.json")
Create-Symlink -LinkPath (Join-Path $ClaudeDir "keybindings.json") -TargetPath (Join-Path $SettingsDir "keybindings.json")
Create-Symlink -LinkPath (Join-Path $ClaudeDir "CLAUDE.md")        -TargetPath (Join-Path $SettingsDir "CLAUDE.md")

Write-Host ""
Write-Host "Done. Settings are now synced from:"
Write-Host "  $SettingsDir"
Write-Host ""
Write-Host "To keep settings in sync:"
Write-Host "  git pull   (get changes from other machines)"
Write-Host "  git add settings/ && git commit && git push   (push your changes)"
