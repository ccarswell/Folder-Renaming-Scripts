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

    # Step 1: Group folders by base artist name
    $grouped = $artistFolders | Group-Object {
        ($_.Name -replace '\s\(\d+\s(release|releases)\)', '')}


 foreach ($group in $grouped) {
        $baseName = $group.Name
        $folders = $group.Group

        # Step 2: Pick the first folder as the target
        $targetFolder = $folders | Select-Object -First 1
        $otherFolders = $folders | Where-Object { $_.FullName -ne $targetFolder.FullName }

        # Step 3: Move releases from duplicates into target
        foreach ($dup in $otherFolders) {
            $subfolders = Get-ChildItem -Path $dup.FullName -Directory
            foreach ($sub in $subfolders) {
                $dest = Join-Path -Path $targetFolder.FullName -ChildPath $sub.Name
                if (-not (Test-Path $dest)) {
                    Move-Item -Path $sub.FullName -Destination $targetFolder.FullName
                } else {
                    # optional: handle naming conflicts
                    $timestamp = (Get-Date).ToString("yyyyMMddHHmmss")
                    Move-Item -Path $sub.FullName -Destination (Join-Path $targetFolder.FullName "$($sub.Name)_dup_$timestamp")
                }
            }
            # Remove empty duplicate folder
            Remove-Item -Path $dup.FullName -Force
        }

        # Step 4: Count total releases in the consolidated target
        $releaseCount = (Get-ChildItem -Path $targetFolder.FullName -Directory | Measure-Object).Count

        # Step 5: Rename target folder
        $newFolderName = if ($releaseCount -eq 1) {
            "$baseName ($releaseCount release)"
        } else {
            "$baseName ($releaseCount releases)"
        }

        $newFolderPath = Join-Path -Path $targetFolder.Parent.FullName -ChildPath $newFolderName
        if ($targetFolder.FullName -ne $newFolderPath) {
            Rename-Item -Path $targetFolder.FullName -NewName $newFolderName
            $count.Value++
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
