# Type: PowerShell Script
# Description: Creates the SCM_API.sdp file for the backend
#
# The SCM_API version is intentionally DECOUPLED from the extension version in
# package.json. Bumping the extension version must NOT redeploy the backend on
# every developer machine that shares a STARLIMS server. The backend version
# lives in SCM_API/version.txt and is only bumped by hand when the backend
# scripts under SCM_API/ actually change.
#
# To release a new backend:
#   1. Edit SCM_API/version.txt (e.g. 1.8.34 -> 1.8.35).
#   2. Run this script. It patches Version.srvscr with that version and rezips
#      the package. package.json is left untouched.
#
# All file IO goes through .NET with an explicit UTF-8 encoding (no BOM).
# Get-Content/Set-Content without -Encoding use the ANSI codepage for BOM-less
# files in Windows PowerShell 5.1, and every write then double-encodes the
# non-ASCII bytes (the author name "Dollinger" with an umlaut) until files grow
# to hundreds of megabytes of mojibake.
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$versionFilePath = (Resolve-Path "SCM_API\version.txt").Path
$versionScriptPath = (Resolve-Path "SCM_API\Server Scripts\SCM_API\Version.srvscr").Path

# Read the backend version from the dedicated version file (NOT package.json).
$new_version = ([System.IO.File]::ReadAllText($versionFilePath, $utf8NoBom)).Trim()
if ($new_version -notmatch '^\d+\.\d+\.\d+$') {
    throw "Invalid SCM_API version '$new_version' in SCM_API\version.txt (expected X.Y.Z)."
}

# Patch the version endpoint script so the server reports the same version.
Write-Host "Patching Version.srvscr with SCM_API version $new_version (from SCM_API\version.txt) ..."
$content = [System.IO.File]::ReadAllText($versionScriptPath, $utf8NoBom)
$content = $content -replace '(sVersion := ")[^"]*(")', "`${1}$new_version`$2"
[System.IO.File]::WriteAllText($versionScriptPath, $content, $utf8NoBom)

Write-Host "Generating .sdp file ..."
# create the .sdp package, if exists, overwrite the old zip file
Compress-Archive -Force -Path .\SCM_API\* -DestinationPath .\SCM_API.zip

# if exists, delete the old sdp file
if (Test-Path .\SCM_API.sdp) {
    Remove-Item .\SCM_API.sdp
}

# rename the zip file to sdp
Rename-Item .\SCM_API.zip SCM_API.sdp
Write-Host "Done. SCM_API version: $new_version (package.json was NOT modified)."
