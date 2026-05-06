param(
  [string]$RepoRoot = (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)),
  [string]$OutputFile = ""
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($OutputFile)) {
  $OutputFile = Join-Path $RepoRoot "custom_phrase.txt"
}

$phraseDir = Join-Path $RepoRoot "phrases"
if (-not (Test-Path -LiteralPath $phraseDir)) {
  throw "Phrase directory not found: $phraseDir"
}

$content = New-Object System.Collections.Generic.List[string]
Get-ChildItem -Path $phraseDir -Filter "*.txt" -File | Sort-Object Name | ForEach-Object {
  Get-Content -LiteralPath $_.FullName | ForEach-Object { $content.Add($_) }
}

Set-Content -LiteralPath $OutputFile -Value $content -Encoding UTF8
Write-Host "Generated custom phrases: $OutputFile"
