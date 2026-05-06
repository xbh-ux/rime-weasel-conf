param(
  [string]$RimeDir = "$env:APPDATA\Rime",
  [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $RimeDir)) {
  throw "Rime directory not found: $RimeDir"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
if ([string]::IsNullOrWhiteSpace($OutputDir)) {
  $OutputDir = Join-Path $RimeDir "manual-backup-$stamp"
}

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$paths = @(
  "default.custom.yaml",
  "rime_ice.custom.yaml",
  "rime_ice.dict.yaml",
  "weasel.custom.yaml",
  "custom_phrase.txt",
  "cn_dicts",
  "user.yaml",
  "build"
)

foreach ($relative in $paths) {
  $source = Join-Path $RimeDir $relative
  if (Test-Path -LiteralPath $source) {
    $target = Join-Path $OutputDir $relative
    $targetParent = Split-Path -Parent $target
    if ($targetParent) {
      New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    }
    Copy-Item -LiteralPath $source -Destination $target -Recurse -Force
  }
}

Get-ChildItem -Path $RimeDir -Directory -Filter "*.userdb" -ErrorAction SilentlyContinue | ForEach-Object {
  Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $OutputDir $_.Name) -Recurse -Force
}

Write-Host "Backup created at $OutputDir"
