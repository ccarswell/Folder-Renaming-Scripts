# --- CONFIG FILE FOR folderrename.ps1 ---

# Base folders to process
$FoldersToRename = @(
    [pscustomobject]@{ folderPath = 'F:\All Music\_Sorted\Electronic\Progressive Trance' },
    [pscustomobject]@{ folderPath = 'F:\All Music\_Sorted\Electronic\Psy-Trance' }
)

# Exclusions (folder names to skip, case-insensitive)
$Exclusions = @(
    ''
)
