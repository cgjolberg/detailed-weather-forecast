param(
  [string]$Remote = "root@homeassistant.local",
  [string]$RemotePath = "/homeassistant/www/custom-cards/detailed-weather-forecast-dev/detailed-weather-forecast.js",
  [string]$LocalFile = "dist/detailed-weather-forecast.js",
  [string]$ResourceId = "5a50aab9c5304e4692b0e0aa78eb423e",
  [switch]$FullBuild,
  [switch]$SkipBuild,
  [switch]$NoBump,
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

  if ($NoBump) {
    Write-Host "Deploy complete. (-NoBump set; bump the Lovelace resource query string yourself.)"
  } else {
    if (-not $env:HA_TOKEN) { $env:HA_TOKEN = [Environment]::GetEnvironmentVariable('HA_TOKEN', 'User') }
    if (-not $env:NODE_EXTRA_CA_CERTS) { $env:NODE_EXTRA_CA_CERTS = [Environment]::GetEnvironmentVariable('NODE_EXTRA_CA_CERTS', 'User') }
    $env:HA_HOST = ($Remote -split '@')[-1]
    node (Join-Path $PSScriptRoot "bump-ha-resource.mjs") $ResourceId
    if ($LASTEXITCODE -ne 0) { throw "Resource bump failed with exit code $LASTEXITCODE" }
    Write-Host "Deploy complete. Lovelace resource bumped automatically."
  }
} finally {
  Pop-Location
}
