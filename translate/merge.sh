#!/usr/bin/env bash

# Extracts translatable messages from the widget sources into template.pot
# and merges the updated template into every translate/*.po file.
#
# Usage: ./merge.sh
# Requires: gettext, jq

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
packageRoot="$DIR/../package"

plasmoidName="$(jq -r '.KPlugin.Id' "$packageRoot/metadata.json")"
plasmoidVersion="$(jq -r '.KPlugin.Version' "$packageRoot/metadata.json")"
website="$(jq -r '.KPlugin.Website' "$packageRoot/metadata.json")"
projectName="plasma_applet_${plasmoidName}"

echo "Extracting messages for ${projectName} ${plasmoidVersion}"

cd "$DIR"
trap 'rm -f infiles template.pot.new' EXIT

find "$packageRoot" \( -name '*.qml' -o -name '*.js' \) -printf '%P\n' | sort > infiles

xgettext \
	--from-code=UTF-8 \
	--language=JavaScript \
	-ki18n:1 \
	-ki18nc:1c,2 \
	-ki18np:1,2 \
	-ki18ncp:1c,2,3 \
	-kI18N_NOOP:1 \
	-kI18N_NOOP2:1c,2 \
	--package-name="$projectName" \
	--package-version="$plasmoidVersion" \
	--msgid-bugs-address="$website/issues" \
	--files-from=infiles \
	-D "$packageRoot" \
	-o template.pot.new

sed -i \
	-e 's/charset=CHARSET/charset=UTF-8/' \
	-e '1s/.*/# Translation template for the Application Title Bar widget./' \
	-e '2s/.*/# Copyright (C) 2024 Anton Kharuzhy <publicantroids@gmail.com>/' \
	-e '4s/.*/# Anton Kharuzhy <publicantroids@gmail.com>, 2024./' \
	template.pot.new

# xgettext cannot parse multiline string literals in QML
# (see ConfigAppearance.qml) and extracts them truncated.
# Drop the truncated entries; the full strings are maintained in dynamic.pot.
msggrep -K -v -e '^Some window decorations themes' template.pot.new > template.pot.fixed
mv template.pot.fixed template.pot.new

# Some strings are translated dynamically at runtime (e.g. i18n(aVariable))
# and cannot be found by xgettext. They are maintained manually in dynamic.pot.
cat dynamic.pot >> template.pot.new

if [ -f template.pot ] && cmp -s template.pot template.pot.new; then
	echo "template.pot is already up to date."
else
	mv template.pot.new template.pot
	echo "template.pot updated."
fi

for po in *.po; do
	[ -e "$po" ] || continue
	echo "Merging template into $po"
	msgmerge --backup=none --update "$po" template.pot
done
