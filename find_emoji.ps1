$files = Get-ChildItem -Path . -Filter '*.md' -Recurse
$emojiPattern = '[^\x00-\x7F]'
$emojiMap = @{}
foreach ($file in $files) {
  $content = [IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
  $matches = [regex]::Matches($content, $emojiPattern)
  foreach ($match in $matches) {
    if (-not $emojiMap.ContainsKey($match.Value)) {
      $emojiMap[$match.Value] = 1
    }
  }
}
$emojiMap.GetEnumerator() | Sort-Object -Property Name | ForEach-Object { 
  Write-Host "Emoji: '$($_.Key)'"
}
