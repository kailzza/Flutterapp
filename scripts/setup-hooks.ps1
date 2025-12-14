param()

Write-Host "Installing git hooks from .githooks/ to .git/hooks/"
$gitDir = git rev-parse --git-dir 2>$null
if (-not $?) {
    Write-Host "Not a git repository. Run this from the repository root." -ForegroundColor Yellow
    exit 1
}

$hooksSource = Join-Path -Path (Get-Location) -ChildPath '.githooks'
$hooksTarget = Join-Path -Path (Get-Location) -ChildPath '.git/hooks'

Get-ChildItem -Path $hooksSource -File | ForEach-Object {
    $dst = Join-Path $hooksTarget $_.Name
    Copy-Item -Path $_.FullName -Destination $dst -Force
    Write-Host "Installed hook: " $_.Name
}

Write-Host "Make sure .githooks/pre-commit is executable on non-Windows systems: 'chmod +x .githooks/pre-commit'"
Write-Host "Done."
