# T-Rex Vibe Coder - One-Line Installer
# Usage: irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$APP_NAME    = "t-rex"
$INSTALL_DIR = "$env:LOCALAPPDATA\TRex"
$EXE_NAME    = "t-rex.exe"

# ── Replace this with your actual raw GitHub URL after uploading the EXE ──
$DOWNLOAD_URL = "https://github.com/NirupanM/t-rex-vibe-1/releases/latest/download/t-rex.exe"
# ──────────────────────────────────────────────────────────────────────────

function Write-Header {
    Write-Host ""
    Write-Host "  ████████╗      ██████╗ ███████╗██╗  ██╗" -ForegroundColor Green
    Write-Host "     ██╔══╝     ██╔══██╗██╔════╝╚██╗██╔╝" -ForegroundColor Green
    Write-Host "     ██║  ───   ██████╔╝█████╗   ╚███╔╝ " -ForegroundColor Green
    Write-Host "     ██║        ██╔══██╗██╔══╝   ██╔██╗ " -ForegroundColor Green
    Write-Host "     ██║        ██║  ██║███████╗██╔╝ ██╗" -ForegroundColor Green
    Write-Host "     ╚═╝        ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "        🦖  T-Rex Vibe Coder Installer" -ForegroundColor Cyan
    Write-Host "  ──────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host ""
}

function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Add-ToUserPath {
    param([string]$Dir)
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ([string]::IsNullOrWhiteSpace($currentPath)) {
        [Environment]::SetEnvironmentVariable("PATH", $Dir, "User")
        Write-Host "  ✅ Added to PATH" -ForegroundColor Green
    } elseif ($currentPath -notlike "*$Dir*") {
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$Dir", "User")
        Write-Host "  ✅ Added to PATH" -ForegroundColor Green
    } else {
        Write-Host "  ✅ Already in PATH" -ForegroundColor DarkGray
    }
}

function Install-TRex {
    Write-Header

    # Step 1 — Create install directory
    Write-Host "  📁 Installing to: $INSTALL_DIR" -ForegroundColor Cyan
    if (-not (Test-Path $INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
    }

    # Step 2 — Download EXE
    $dest = Join-Path $INSTALL_DIR $EXE_NAME
    Write-Host "  ⬇️  Downloading t-rex.exe..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $dest -UseBasicParsing
        Write-Host "  ✅ Downloaded successfully" -ForegroundColor Green
    } catch {
        Write-Host ""
        Write-Host "  ❌ Download failed: $_" -ForegroundColor Red
        Write-Host "  👉 Check your DOWNLOAD_URL in install.ps1" -ForegroundColor Yellow
        exit 1
    }

    # Step 3 — Add to PATH
    Write-Host "  🔧 Updating PATH..." -ForegroundColor Cyan
    Add-ToUserPath -Dir $INSTALL_DIR

    # Step 4 — Refresh current session PATH so it works immediately
    $userPath    = [Environment]::GetEnvironmentVariable("PATH", "User")
    $machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    $env:PATH    = "$userPath;$machinePath"

    # Step 5 — Ask for API keys and save .env
    Write-Host ""
    Write-Host "  🔑 API Key Setup" -ForegroundColor Cyan
    Write-Host "  ──────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  Anthropic: https://console.anthropic.com" -ForegroundColor DarkGray
    Write-Host "  OpenAI:    https://platform.openai.com/api-keys" -ForegroundColor DarkGray
    Write-Host ""

    $anthropicKey = Read-Host "  Enter your Anthropic API key (or press Enter to skip)"
    $openaiKey    = Read-Host "  Enter your OpenAI API key (or press Enter to skip)"

    $envFile = Join-Path $INSTALL_DIR ".env"
    $envLines = @()

    if (-not [string]::IsNullOrWhiteSpace($anthropicKey)) {
        $envLines += "ANTHROPIC_API_KEY=$anthropicKey"
        $env:ANTHROPIC_API_KEY = $anthropicKey
        Write-Host "  ✅ Anthropic key saved" -ForegroundColor Green
    }

    if (-not [string]::IsNullOrWhiteSpace($openaiKey)) {
        $envLines += "OPENAI_API_KEY=$openaiKey"
        $env:OPENAI_API_KEY = $openaiKey
        Write-Host "  ✅ OpenAI key saved" -ForegroundColor Green
    }

    if ($envLines.Count -gt 0) {
        Set-Content -Path $envFile -Value $envLines
    } else {
        Write-Host "  ⚠️  No keys entered. You can add them later in $INSTALL_DIR\.env" -ForegroundColor Yellow
    }

    # Done!
    Write-Host ""
    Write-Host "  ──────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  🦖  T-Rex Vibe Coder installed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "  HOW TO USE:" -ForegroundColor White
    Write-Host "  ► Open a NEW terminal window" -ForegroundColor White
    Write-Host "  ► Type:  t-rex" -ForegroundColor Cyan
    Write-Host "  ► Start vibe coding! 🚀" -ForegroundColor White
    Write-Host ""
    Write-Host "  To uninstall:" -ForegroundColor DarkGray
    Write-Host "  irm https://raw.githubusercontent.com/NirupanM/t-rex-vibe-1/main/uninstall.ps1 | iex" -ForegroundColor DarkGray
    Write-Host ""
}

Install-TRex
