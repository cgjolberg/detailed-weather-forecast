param(
  [string]$Remote = "root@homeassistant.local",
  [string]$RemotePath = "/homeassistant/www/custom-cards/detailed-weather-forecast-dev/detailed-weather-forecast.js",
  [string]$LocalFile = "dist/detailed-weather-forecast.js",
  [switch]$FullBuild,
  [switch]$SkipBuild,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$localFilePath = Join-Path $repoRoot $LocalFile

Push-Location $repoRoot
try {
  if (-not $SkipBuild) {
    if ($FullBuild) {
      Write-Host "Building with yarn build..."
      corepack yarn build
    } else {
      Write-Host "Linting..."
      corepack yarn lint
      Write-Host "Building with yarn rollup..."
      corepack yarn rollup
    }
  }

  if (-not (Test-Path -LiteralPath $localFilePath)) {
    throw "Built file not found: $localFilePath"
  }

  $target = "${Remote}:${RemotePath}"
  Write-Host "Deploying $LocalFile to $target"

  if ($DryRun) {
    Write-Host "Dry run only. Skipping scp."
    exit 0
  }

  scp $localFilePath $target
  if ($LASTEXITCODE -ne 0) {
    throw "scp failed with exit code $LASTEXITCODE"
  }
  Write-Host "Deploy complete. Bump your Lovelace resource query string, for example ?v=dev5."
} finally {
  Pop-Location
}
