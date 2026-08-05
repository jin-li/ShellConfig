$ErrorActionPreference = 'Stop'

$RepoUrl = 'https://github.com/jin-li/ShellConfig.git'
$RepoDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'GitHub\ShellConfig'
$PoshDir = Join-Path $HOME '.config\oh-my-posh'
$ThemeLink = Join-Path $PoshDir 'jinli.omp.json'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'WinGet is required. Install App Installer from the Microsoft Store and rerun this script.'
}

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    winget upgrade JanDeDobbeleer.OhMyPosh --source winget --accept-source-agreements
} else {
    winget install JanDeDobbeleer.OhMyPosh --source winget --accept-package-agreements --accept-source-agreements
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    winget install Git.Git --source winget --accept-package-agreements --accept-source-agreements
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
}

New-Item -ItemType Directory -Force -Path (Split-Path $RepoDir), $PoshDir | Out-Null
if (Test-Path (Join-Path $RepoDir '.git')) {
    git -C $RepoDir pull --ff-only
} elseif (Test-Path $RepoDir) {
    throw "$RepoDir exists but is not a Git checkout. Move it and rerun."
} else {
    git clone $RepoUrl $RepoDir
}

if (Test-Path $ThemeLink) { Remove-Item $ThemeLink -Force }
New-Item -ItemType SymbolicLink -Path $ThemeLink -Target (Join-Path $RepoDir 'jinli.omp.json') | Out-Null

$ProfileDir = Split-Path $PROFILE
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
if (Test-Path $PROFILE) {
    $Backup = "$PROFILE-pre-oh-my-posh-jinli"
    if (Test-Path $Backup) { $Backup += '-' + (Get-Date -Format 'yyyyMMdd-HHmmss') }
    Copy-Item $PROFILE $Backup
}

$InitLine = 'oh-my-posh init pwsh --config "$HOME/.config/oh-my-posh/jinli.omp.json" | Invoke-Expression'
$Existing = if (Test-Path $PROFILE) { Get-Content $PROFILE -Raw } else { '' }
if ($Existing -notmatch [regex]::Escape($InitLine)) { Add-Content -Path $PROFILE -Value "`n$InitLine" }

$InstallFont = Read-Host 'Install the Meslo Nerd Font used by the Jinli theme? [y/N]'
if ($InstallFont -match '^(y|yes)$') {
    oh-my-posh font install meslo
    Write-Host 'Configure Windows Terminal to use "MesloLGM Nerd Font".'
}

Write-Host "Installation complete. Restart PowerShell or run: . `$PROFILE"
