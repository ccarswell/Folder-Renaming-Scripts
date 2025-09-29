# Folder Rename Script
## Description
This PowerShell script renames artist folders within specified music library destinations so that each folder name includes the number of releases it contains.
For example:
- Ace Ventura → Ace Ventura (5 releases)
- Phaxe & Morten Granau → Phaxe & Morten Granau (1 release)

The script is configurable and can be pointed at different library roots, with exclusions for folders you don’t want touched (e.g. _Compilation Albums).

## How It Works
- Reads folder destinations and exclusion rules from a config file (folderrename.config.ps1).
- Iterates through each codec folder (e.g. FLAC, MP3) inside the configured base paths.
- Counts the number of immediate subfolders (treated as releases) inside each artist folder.
- Cleans up any existing (x release[s]) suffix from folder names.
- Renames the folder to append the correct count:
- - (1 release) if exactly one
- - (n releases) otherwise
- Skips folders if:
- - They already have the correct name.
- - A target folder with the desired name already exists.
- - They are listed in the exclusions array.
-  Merges folders if:
- - An existing folder name already exists (without the release number)
- - "Ace Ventura" and "Ace Ventura (4 releases)" will be merged into "Ace Ventura (5 releases)"

## Configuration
The script uses a separate config file: folderrename.config.ps1
- $FoldersToRename → a list of parent genre/style folders that contain codec folders (FLAC, MP3, etc.).
- $Exclusions → any folder names you don’t want processed.

## Usage

- Place folderrename.ps1 and folderrename.config.ps1 in the same directory.
- Open PowerShell and run:
- - .\folderrename.ps1
- The script will output progress as + for each folder renamed, and a summary count when complete.

## Notes

- The script only counts subfolders (not files) as releases.
- Existing suffixes (n release) or (n releases) are cleaned up before renaming.
- If a folder with the new name already exists, the rename is skipped.
- Run on a copy of your library first to confirm behaviour.

