$files = Get-ChildItem -Path . -Filter "*.md" -Recurse
$count = 0

foreach ($file in $files) {
    $content = [IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $newContent = $content
    
    # Replace "oe " with "[WRONG] " since it's a corrupted emoji
    $newContent = $newContent -replace "oe ", "[WRONG] "
    # Replace standalone "oe" at end of line
    $newContent = $newContent -replace "oe$", "[WRONG]"
    
    if ($content -ne $newContent) {
        [IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
        $count++
        Write-Host "Updated: $($file.Name)"
    }
}
Write-Host "Total files updated: $count"
