$files = Get-ChildItem -Path . -Filter "*.md" -Recurse
$count = 0

foreach ($file in $files) {
    $content = [IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $newContent = $content
    
    # Replace emoji and special characters with text equivalents
    $newContent = $newContent -replace [char]10060, "[WRONG]"
    $newContent = $newContent -replace [char]9989, "[CORRECT]"
    $newContent = $newContent -replace [char]10003, "[CORRECT]"
    $newContent = $newContent -replace [char]10007, "[WRONG]"
    $newContent = $newContent -replace [char]11088, "[STAR]"
    
    # Remove any remaining non-ASCII characters
    $newContent = $newContent -replace "[^\x00-\x7F]", ""
    
    if ($content -ne $newContent) {
        [IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        $count++
        Write-Host "Updated: $($file.Name)"
    }
}
Write-Host "Total files updated: $count"
