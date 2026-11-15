#!/usr/bin/env bash

# Compiles every translate/*.po file into a .mo catalog under
# package/contents/locale/<lang>/LC_MESSAGES/, from where it is shipped
# inside the .plasmoid package.
#
# Usage: ./build.sh
# Requires: gettext, jq

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
plasmoidName="$(jq -r '.KPlugin.Id' "$DIR/../package/metadata.json")"
projectName="plasma_applet_${plasmoidName}"

for po in "$DIR"/*.po; do
	[ -e "$po" ] || continue
	lang="$(basename "$po" .po)"
	dest="$DIR/../package/contents/locale/$lang/LC_MESSAGES"
	mkdir -p "$dest"
	echo "Compiling $po -> $dest/${projectName}.mo"
	msgfmt --check --statistics -o "$dest/${projectName}.mo" "$po"
done
