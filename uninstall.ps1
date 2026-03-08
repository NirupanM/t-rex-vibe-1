# T-Rex Vibe Coder - Uninstaller
# Usage: irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/uninstall.ps1 | iex

$INSTALL_DIR = "$env:LOCALAPPDATA\TRex"

Write-Host ""
Write-Host "  🦖  T-Rex Vibe Coder Uninstaller" -ForegroundColor Cyan
Write-Host "  ──────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# Remove from PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$newPath = ($currentPath.Split(";") | Where-Object { $_ -ne $INSTALL_DIR }) -join ";"
[Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
Write-Host "  ✅ Removed from PATH" -ForegroundColor Green

# Delete install folder
if (Test-Path $INSTALL_DIR) {
    Remove-Item -Recurse -Force $INSTALL_DIR
    Write-Host "  ✅ Deleted $INSTALL_DIR" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  Install folder not found (already removed?)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  ✅ T-Rex uninstalled. Open a new terminal to confirm." -ForegroundColor Green
Write-Host ""
