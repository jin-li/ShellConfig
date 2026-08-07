$ErrorActionPreference = 'Stop'

$RepoUrl = 'https://github.com/jin-li/ShellConfig.git'
$RepoDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'GitHub\ShellConfig'
$PoshDir = Join-Path $HOME '.config\oh-my-posh'
$ThemeLink = Join-Path $PoshDir 'jinli.omp.json'
$ThemeSource = Join-Path $RepoDir 'jinli.omp.json'
$ThemeMode = 'not installed'

function Refresh-UserPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

function Test-MesloFont {
    $fontRoots = @(
        (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'),
        (Join-Path $env:WINDIR 'Fonts')
    )
    foreach ($root in $fontRoots) {
        if (Test-Path $root) {
            if (Get-ChildItem -LiteralPath $root -Filter 'Meslo*' -File -ErrorAction SilentlyContinue) {
                return $true
            }
        }
    }
    return $false
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw 'WinGet is required. Install App Installer from the Microsoft Store and rerun this script.'
}

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host 'Oh My Posh is already installed; skipping installation.'
} else {
    winget install JanDeDobbeleer.OhMyPosh --source winget --accept-package-agreements --accept-source-agreements
    Refresh-UserPath
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    winget install Git.Git --source winget --accept-package-agreements --accept-source-agreements
    Refresh-UserPath
} else {
    Write-Host 'Git is already installed; skipping installation.'
}

New-Item -ItemType Directory -Force -Path (Split-Path $RepoDir), $PoshDir | Out-Null
if (Test-Path (Join-Path $RepoDir '.git')) {
    git -C $RepoDir pull --ff-only
} elseif (Test-Path $RepoDir) {
    throw "$RepoDir exists but is not a Git checkout. Move it and rerun."
} else {
    git clone $RepoUrl $RepoDir
}

if (-not (Test-Path $ThemeSource -PathType Leaf)) {
    throw "Theme file not found: $ThemeSource"
}

$ExistingTheme = Get-Item -LiteralPath $ThemeLink -Force -ErrorAction SilentlyContinue
if ($ExistingTheme) {
    $resolvedTarget = $ExistingTheme.Target
    if ($resolvedTarget -and ([IO.Path]::GetFullPath($resolvedTarget) -eq [IO.Path]::GetFullPath($ThemeSource))) {
        $ThemeMode = 'existing symbolic link'
    } else {
        $ThemeBackup = "$ThemeLink-pre-oh-my-posh-jinli"
        if (Test-Path $ThemeBackup) { $ThemeBackup += '-' + (Get-Date -Format 'yyyyMMdd-HHmmss') }
        Move-Item -LiteralPath $ThemeLink -Destination $ThemeBackup
        Write-Host "Existing theme moved to $ThemeBackup"
    }
}

if ($ThemeMode -eq 'not installed') {
    try {
        New-Item -ItemType SymbolicLink -Path $ThemeLink -Target $ThemeSource -ErrorAction Stop | Out-Null
        $ThemeMode = 'symbolic link'
    } catch [UnauthorizedAccessException] {
        Write-Warning 'Windows denied symbolic-link creation. Enable Developer Mode or run elevated for a link; using a user-writable theme copy instead.'
        Copy-Item -LiteralPath $ThemeSource -Destination $ThemeLink -Force
        $ThemeMode = 'copy (symbolic link unavailable)'
    }
}

$ProfileDir = Split-Path $PROFILE
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
$InitLine = 'oh-my-posh init pwsh --config "$HOME/.config/oh-my-posh/jinli.omp.json" | Invoke-Expression'
$Existing = if (Test-Path $PROFILE) { Get-Content $PROFILE -Raw } else { '' }
if ($Existing -notmatch [regex]::Escape($InitLine)) {
    if (Test-Path $PROFILE) {
        $Backup = "$PROFILE-pre-oh-my-posh-jinli"
        if (Test-Path $Backup) { $Backup += '-' + (Get-Date -Format 'yyyyMMdd-HHmmss') }
        Copy-Item $PROFILE $Backup
        Write-Host "Existing PowerShell profile copied to $Backup"
    }
    Add-Content -Path $PROFILE -Value "`n$InitLine"
} else {
    Write-Host 'Oh My Posh initialization already exists in the PowerShell profile; skipping.'
}

if (Test-MesloFont) {
    $FontMode = 'already available; skipped'
    Write-Host 'Meslo Nerd Font is already available; skipping installation.'
} else {
    $InstallFont = Read-Host 'Install the Meslo Nerd Font used by the Jinli theme? [y/N]'
    if ($InstallFont -match '^(y|yes)$') {
        oh-my-posh font install meslo
        $FontMode = 'installed'
        Write-Host 'Configure Windows Terminal to use "MesloLGM Nerd Font".'
    } else {
        $FontMode = 'skipped by user'
    }
}

Write-Host "`nConfiguration summary:"
Write-Host "  Repository:  $RepoDir"
Write-Host "  Theme:       $ThemeLink -> $ThemeSource ($ThemeMode)"
Write-Host "  PowerShell:  $PROFILE"
Write-Host "  Font:        MesloLGM Nerd Font ($FontMode)"
Write-Host "`nInstallation complete. Restart PowerShell or run: . `$PROFILE"
