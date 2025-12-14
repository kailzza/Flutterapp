param(
    [string]$DeviceId = ""
)

Write-Host "Preparing to run the Flutter app..."
function Get-FlutterExePath {
  if (Get-Command flutter -ErrorAction SilentlyContinue) { return 'flutter' }
  $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
  $projectRoot = Split-Path -Parent $scriptDir
  $local = Join-Path $projectRoot 'flutter\bin\flutter.bat'
  if (Test-Path $local) { return $local }
  throw 'Flutter command not found; install Flutter SDK or add to PATH.'
}

$flutter = Get-FlutterExePath
& $flutter pub get

if ($DeviceId -ne "") {
    & $flutter run -d $DeviceId
} else {
    & $flutter run
}
