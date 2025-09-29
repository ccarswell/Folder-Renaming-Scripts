# Load config (adjust path if needed)
. "$PSScriptRoot\folderrename.config.ps1"

Write-Host ""
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Output "Renaming Artist folders to include release numbers"
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
$count = 0

function renameArtistFolders {
    param (
        [array]$artistFolders,
        [ref]$count
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
        if ($folder.FullName -ne $newFolderPath) {
            Rename-Item -Path $folder.FullName -NewName $newFolderName
            $count.Value++

            # Display a processing indicator with a continuous '+'
            Write-Host -NoNewline "+"
        }
    }
}
foreach ($tem in $foldersToRename) {
    $style = $tem.folderPath   # use the current item, not the whole array
    $codecFolders = Get-ChildItem -Path $style -Directory
    foreach ($codec in $codecFolders) {
        # Get all artist folders in the base path
        $artistFolders = Get-ChildItem -Path $codec.FullName -Directory |
            Where-Object { $Exclusions -notcontains $_.Name }
        
        # Write-Output "Codec folder: $($codec.FullName)"
        # Write-Output "Artist folders found: $($artistFolders.FullName)"
        
        # Call the function if you want it to actually rename
        renameArtistFolders -artistFolders $artistFolders -count ([ref]$count)
    }
}


# Newline for clean output after processing
Write-Host ""
Write-Host ""
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Output "$count folders renamed to include release counts."
Write-Output "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Host ""
