param(
  [ValidateSet("light", "dark")]
  [string]$Mode = "dark",
  [string]$RimeDir = "$env:APPDATA\Rime",
  [string]$WeaselDeployer = "C:\Program Files\Rime\weasel-0.17.4\WeaselDeployer.exe",
  [switch]$SkipRedeploy
)

$ErrorActionPreference = "Stop"
$config = Join-Path $RimeDir "weasel.custom.yaml"
if (-not (Test-Path -LiteralPath $config)) {
  throw "Theme config not found: $config"
}

$content = Get-Content -LiteralPath $config -Raw
$target = if ($Mode -eq "dark") { 'macos_dark' } else { 'macos_light' }
$content = [Regex]::Replace($content, '"style/color_scheme":\s*\w+', '"style/color_scheme": ' + $target)
Set-Content -LiteralPath $config -Value $content -Encoding UTF8

Write-Host "Switched Weasel theme to $target"

if (-not $SkipRedeploy) {
  $redeploy = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "redeploy-rime.ps1"
  & $redeploy -RimeDir $RimeDir -WeaselDeployer $WeaselDeployer
}
