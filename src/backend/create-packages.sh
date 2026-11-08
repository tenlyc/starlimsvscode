#!/usr/bin/env bash
#
# Packages the SCM_API backend scripts into SCM_API.sdp.
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

set -euo pipefail

version_file="./SCM_API/version.txt"
version_script_file="./SCM_API/Server Scripts/SCM_API/Version.srvscr"

if [ ! -f "$version_file" ]; then
    echo "ERROR: $version_file not found. Create it with the SCM_API version (e.g. 1.8.34)." >&2
    exit 1
fi

# Read the backend version (trim whitespace / trailing newline).
new_version=$(tr -d '[:space:]' < "$version_file")

if ! [[ "$new_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: '$new_version' in $version_file is not a valid semver (expected X.Y.Z)." >&2
    exit 1
fi

# Patch the Version endpoint script so the server reports the same version.
printf "Patching Version.srvscr with SCM_API version %s (from %s)\n" "$new_version" "$version_file"
# macOS sed needs -i '', GNU sed needs -i without an argument. Detect once.
if sed --version >/dev/null 2>&1; then
    sed -i -r "s/(sVersion := \")([^\"]*)(\")/\1$new_version\3/" "$version_script_file"
else
    sed -i '' -E "s/(sVersion := \")([^\"]*)(\")/\1$new_version\3/" "$version_script_file"
fi

printf "Generating SCM_API.sdp\n"

# Package the backend scripts into a .sdp file (zip with a different extension).
[ -e SCM_API.zip ] && rm SCM_API.zip
cd SCM_API/
zip -r SCM_API.zip . -r
mv SCM_API.zip ../SCM_API.sdp
cd ..

echo "Done. SCM_API version: $new_version (package.json was NOT modified)."
