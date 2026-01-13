$files = Get-ChildItem -Path . -Filter '*.md' -Recurse
$count = 0
foreach ($file in $files) {
  $content = [IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
  $newContent = $content -replace '✅ ', ''
  if ($content -ne $newContent) {
    [IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
    $count++
    Write-Host "Updated: $($file.Name)"
  }
}
Write-Host "Total updated: $count files"
