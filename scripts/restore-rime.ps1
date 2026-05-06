param(
  [Parameter(Mandatory = $true)]
  [string]$BackupDir,
  [string]$RimeDir = "$env:APPDATA\Rime"
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path -LiteralPath $BackupDir)) {
  throw "Backup directory not found: $BackupDir"
}

New-Item -ItemType Directory -Path $RimeDir -Force | Out-Null

Get-ChildItem -LiteralPath $BackupDir -Force | ForEach-Object {
  $target = Join-Path $RimeDir $_.Name
  Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
}

Write-Host "Backup restored from $BackupDir"
