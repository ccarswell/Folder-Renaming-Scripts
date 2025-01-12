Write-Host ""
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Output "Renaming Artist folders to include release numbers"
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
$count = 0


# Specify the path where your artist folders are located
$foldersToRename = @(
    [pscustomobject]@{
        folderPath  = 'J:\All Music\_Sorted\Electronic\Progressive Trance'
    },
    [pscustomobject]@{
        folderPath  = 'J:\All Music\_Sorted\Electronic\Psy-Trance' 
    }
)

function renameArtistFolders {
    param (
        [array]$artistFolders
        )
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
foreach ($tem in $foldersToRename){
    
    $style = $foldersToRename.folderPath
    $codecFolders = Get-ChildItem -Path $style -Directory
    foreach ($codec in $codecFolders) {
        # Get all artist folders in the base path
        $artistFolders = Get-ChildItem -Path $codec -Directory
        renameArtistFolders $artistFolders
        
    }
}

# Newline for clean output after processing
Write-Host ""
Write-Host ""
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Output "$count folders renamed to include release counts."
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Host ""
