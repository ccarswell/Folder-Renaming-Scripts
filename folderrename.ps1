# Specify the path where your artist folders are located
$basePath = "J:\All Music\_Sorted\Electronic\Psy-Trance"
$codecFolders = Get-ChildItem -Path $basePath -Directory
foreach ($codec in $codecFolders) {
    # Get all artist folders in the base path
    $artistFolders = Get-ChildItem -Path $codec -Directory
    Write-Output $artistFolders
    # break
    foreach ($folder in $artistFolders) {
        # Count all files, including those in nested subfolders
        $albumCount = (Get-ChildItem -Path $folder.FullName -Directory | Measure-Object).Count
        
        # Clean the folders before processing again
        $cleanFolderName = $folder.Name -replace '\s\(\d+\salbums\)', ''
        $cleanFolderPath = Join-Path -Path $folder.Parent.FullName -ChildPath $cleanFolderName

        Rename-Item -Path $folder.FullName -NewName $cleanFolderPath

        # Create the new folder name by appending the file count
        $newFolderName = "$cleanFolderName ($albumCount albums)"

        # Build the full path for the renamed folder
        $newFolderPath = Join-Path -Path $folder.Parent.FullName -ChildPath $newFolderName
        
        # Rename the folder if the new name is different
        if ($cleanFolderPath -ne $newFolderPath) {
            Rename-Item -Path $cleanFolderPath -NewName $newFolderPath
            Write-Output "Renamed '$($folder.FullName)' to '$newFolderPath'"
        }
    }
}

Write-Output "Folders renamed to include file counts."

