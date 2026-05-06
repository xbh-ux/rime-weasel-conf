param(
  [string]$RimeDir = "$env:APPDATA\Rime",
  [string]$WeaselDeployer = "C:\Program Files\Rime\weasel-0.17.4\WeaselDeployer.exe"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = Join-Path $RimeDir "backup-from-github-$Stamp"

function Copy-ConfigFile {
  param(
    [string]$RelativePath
  )

  $source = Join-Path $RepoRoot $RelativePath
  $target = Join-Path $RimeDir $RelativePath
  if (-not (Test-Path -LiteralPath $source)) {
    throw "Missing source file: $source"
  }

  $targetParent = Split-Path -Parent $target
  New-Item -ItemType Directory -Path $targetParent -Force | Out-Null

  if (Test-Path -LiteralPath $target) {
    $backupTarget = Join-Path $BackupDir $RelativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $backupTarget) -Force | Out-Null
    Copy-Item -LiteralPath $target -Destination $backupTarget -Force
  }

  Copy-Item -LiteralPath $source -Destination $target -Force
}

New-Item -ItemType Directory -Path $RimeDir -Force | Out-Null
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

$files = @(
  "default.custom.yaml",
  "rime_ice.custom.yaml",
  "rime_ice.dict.yaml",
  "weasel.custom.yaml",
  "custom_phrase.txt"
)

foreach ($file in $files) {
  Copy-ConfigFile -RelativePath $file
}

Get-ChildItem -Path (Join-Path $RepoRoot "cn_dicts") -Filter "*.dict.yaml" -File | ForEach-Object {
  Copy-ConfigFile -RelativePath ("cn_dicts\" + $_.Name)
}

Write-Host "Installed Rime config to $RimeDir"
Write-Host "Backup saved to $BackupDir"

$redeploy = Join-Path $RepoRoot "scripts\redeploy-rime.ps1"
& $redeploy -RimeDir $RimeDir -WeaselDeployer $WeaselDeployer
