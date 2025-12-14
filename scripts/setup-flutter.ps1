Param(
  [switch]$Persist
)

# script: setup-flutter.ps1
# Purpose: Add the bundled Flutter SDK (if present) to PATH for current shell and optionally persist in user environment

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$flutterBin = Join-Path $projectRoot 'flutter\bin'

if (-not (Test-Path $flutterBin)) {
  Write-Host "No Flutter SDK found at $flutterBin" -ForegroundColor Yellow
  Write-Host "If you want to use a global Flutter install, make sure 'flutter' is on your PATH or install Flutter: https://docs.flutter.dev/get-started/install"
  exit 1
}

Write-Host "Detected local Flutter at: $flutterBin"

# Add to PATH for current session
$env:Path += ";$flutterBin"
Write-Host "Added to PATH for current session. You can run: flutter --version"

if ($Persist) {
  Write-Host "Persisting to user PATH (requires reopening shells to take effect)" -ForegroundColor Green
  $current = [Environment]::GetEnvironmentVariable('Path', 'User')
  if ($current -notlike "*$flutterBin*") {
    [Environment]::SetEnvironmentVariable('Path', "$current;$flutterBin", 'User')
    Write-Host "Added $flutterBin to User PATH. Restart PowerShell/Terminal to see the effect." -ForegroundColor Green
  } else {
    Write-Host "User PATH already contains $flutterBin" -ForegroundColor Yellow
  }
}

Write-Host "Run 'flutter doctor' to verify the environment." -ForegroundColor Cyan
