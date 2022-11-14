
param ($file_location, $destination, $threads)
$copiedFilesCount = 0
$copiedBytes = 0

robocopy $file_location $destination /e /r:0 /w:0 /COPY:DAT /DCOPY:DAT /mt:$threads /LOG+:C:/robocopy.log /TEE /ndl /bytes | ForEach-Object {
    $data = $_.Split([char]9)

    if ($data.Length -ge 4) { # check if message is from a file copy-process
        $copiedBytes += $data[3]
        $copiedFilesCount++
        
        Write-Progress -Activity "Robocopy" -Status "Copied $($copiedFilesCount.ToString("N0")) files ($(($copiedBytes / 1MB).ToString("N2")) MB)" -CurrentOperation $data[4]
    }
    elseif ($data -notmatch "\d+%") {
        Write-Output $_
    }
}

Write-Progress -Activity "Robocopy" -Completed

exit 0
