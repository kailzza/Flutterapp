param(
    [switch]$RunTests
)

Write-Host "Project checks for Flutter (PowerShell)"

Write-Host "Running flutter doctor..."

function Get-FlutterExePath {
    if (Get-Command flutter -ErrorAction SilentlyContinue) { return 'flutter' }
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $projectRoot = Split-Path -Parent $scriptDir
    $local = Join-Path $projectRoot 'flutter\bin\flutter.bat'
    if (Test-Path $local) { return $local }
    throw 'Flutter command not found; install Flutter SDK or add to PATH.'
}

$flutter = Get-FlutterExePath

& $flutter doctor -v

Write-Host "Running flutter pub get..."
& $flutter pub get

Write-Host "Running flutter analyze..."
& $flutter analyze

Write-Host "Checking formatting..."
& $flutter format --set-exit-if-changed .

if ($RunTests) {
    Write-Host "Running flutter test..."
    & $flutter test
}

Write-Host "Listing devices..."
& $flutter devices

Write-Host "All checks completed."
