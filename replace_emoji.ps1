$files = Get-ChildItem -Path . -Filter '*.md' -Recurse
$count = 0

foreach ($file in $files) {
    $content = [IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $newContent = $content
    
    # Handle emoji that may be encoded as UTF-8 multi-byte sequences
    $newContent = $newContent -replace '❌', '[WRONG]'
    $newContent = $newContent -replace '✅', '[CORRECT]'
    $newContent = $newContent -replace '✓', '[CORRECT]'
    $newContent = $newContent -replace '✗', '[WRONG]'
    $newContent = $newContent -replace '⭐', '[STAR]'
    $newContent = $newContent -replace '→', '->'
    $newContent = $newContent -replace '←', '<-'
    
    # Replace corrupted characters and dashes
    $newContent = $newContent -replace '—', '-'
    $newContent = $newContent -replace '–', '-'
    $newContent = $newContent -replace '…', '...'
    $newContent = $newContent -replace '"', '"'
    $newContent = $newContent -replace '"', '"'
    $newContent = $newContent -replace "'", "'"
    $newContent = $newContent -replace "'", "'"
    
    # Replace "oe" which is likely a corrupted character
    $newContent = $newContent -replace 'oe ', '[WRONG] '
    
    # Replace any other remaining non-ASCII characters
    $newContent = $newContent -replace '[^\x00-\x7F]', ''
    
    if ($content -ne $newContent) {
        [IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        $count++
        Write-Host "Updated: $($file.Name)"
    }
}
Write-Host ""
Write-Host "Total files updated: $count"
