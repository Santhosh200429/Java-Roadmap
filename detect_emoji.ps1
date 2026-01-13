$files = Get-ChildItem -Path .\01-Getting-Started -Filter '04-BasicSyntax.md'
foreach ($file in $files) {
    $content = [IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $regex = [regex]'[^\x00-\x7F]'
    $matches = $regex.Matches($content)
    $unique = @{}
    foreach ($match in $matches) {
        if (-not $unique.ContainsKey($match.Value)) {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($match.Value)
            $hexBytes = $bytes | ForEach-Object { $_.ToString('X2') }
            Write-Host "Char code: $(([int][char]$match.Value).ToString('D')) Hex bytes: $($hexBytes -join ' ')"
            $unique[$match.Value] = $true
        }
    }
}
