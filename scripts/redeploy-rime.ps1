param(
  [string]$RimeDir = "$env:APPDATA\Rime",
  [string]$WeaselDeployer = "C:\Program Files\Rime\weasel-0.17.4\WeaselDeployer.exe"
)

$ErrorActionPreference = "Stop"

function Assert-File {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Required file not found: $Path"
  }
}

Assert-File $RimeDir
Assert-File (Join-Path $RimeDir "rime_ice.custom.yaml")
Assert-File (Join-Path $RimeDir "rime_ice.dict.yaml")
Assert-File (Join-Path $RimeDir "weasel.custom.yaml")
Assert-File (Join-Path $RimeDir "custom_phrase.txt")
Assert-File (Join-Path $RimeDir "cn_dicts\mydict.dict.yaml")
Assert-File $WeaselDeployer

Write-Host "Deploying Rime config..."
& $WeaselDeployer /deploy | Write-Host

$schema = Join-Path $RimeDir "build\rime_ice.schema.yaml"
$table = Join-Path $RimeDir "build\rime_ice.table.bin"
$weasel = Join-Path $RimeDir "build\weasel.yaml"

Assert-File $schema
Assert-File $table
Assert-File $weasel

$schemaText = Get-Content -LiteralPath $schema -Raw
$weaselText = Get-Content -LiteralPath $weasel -Raw

$checks = [ordered]@{
  "wanxiang grammar" = $schemaText.Contains('language: "wanxiang-lts-zh-hans"') -or $schemaText.Contains("language: wanxiang-lts-zh-hans")
  "context suggestions" = $schemaText.Contains("contextual_suggestions: true")
  "user learning" = $schemaText.Contains("enable_user_dict: true") -and $schemaText.Contains("enable_encoder: true")
  "commit history learning" = $schemaText.Contains("encode_commit_history: true")
  "personal dict entry" = (Get-Content -LiteralPath (Join-Path $RimeDir "rime_ice.dict.yaml") -Raw).Contains("cn_dicts/mydict")
  "macos theme" = $weaselText.Contains("color_scheme: macos_dark") -or $weaselText.Contains("color_scheme: macos_light")
}

$failed = @()
foreach ($item in $checks.GetEnumerator()) {
  if ($item.Value) {
    Write-Host "[OK] $($item.Key)"
  } else {
    Write-Host "[FAIL] $($item.Key)"
    $failed += $item.Key
  }
}

Write-Host "Schema: $schema"
Write-Host "Table : $table"
Write-Host "Theme : $weasel"

if ($failed.Count -gt 0) {
  throw "Rime deploy finished but checks failed: $($failed -join ', ')"
}

Write-Host "Rime deploy checks passed."
