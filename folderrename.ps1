# Specify the path where your artist folders are located
$basePath = "J:\All Music\_Sorted\Electronic\Progressive Trance"
$basePath = "J:\All Music\_Sorted\Electronic\Psy-Trance"
$codecFolders = Get-ChildItem -Path $basePath -Directory
$count = 0

Write-Host ""
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Output "Renaming Artist folders to include release numbers"
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
foreach ($codec in $codecFolders) {
    # Get all artist folders in the base path
    $artistFolders = Get-ChildItem -Path $codec -Directory
    foreach ($folder in $artistFolders) {
        # Count all files, including those in nested subfolders
        $releaseCount = (Get-ChildItem -Path $folder.FullName -Directory | Measure-Object).Count
        
        # Clean the folders before processing again
        $cleanFolderName = $folder.Name -replace '\s\(\d+\s(release|releases)\)', ''
        
        if ($releaseCount -eq 1){
            # Create the new folder name by appending the file count
            $newFolderName = "$cleanFolderName ($releaseCount release)"
        } else {
            # Create the new folder name by appending the file count
            $newFolderName = "$cleanFolderName ($releaseCount releases)"
        }

        # Build the full path for the renamed folder
        $newFolderPath = Join-Path -Path $folder.Parent.FullName -ChildPath $newFolderName
        # Rename the folder if the new name is different
        if ($folder -ne $newFolderPath) {
            Rename-Item -Path $folder -NewName $newFolderPath
            $count++

            # Display a processing indicator with a continuous '+'
            Write-Host -NoNewline "+"
        }
    }
}

# Newline for clean output after processing
Write-Host ""
Write-Host ""
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Output "$count folders renamed to include release counts."
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Host ""
