# Translations

The widget is translated with gettext. The compiled catalogs are shipped inside
the widget package under `package/contents/locale/<lang>/LC_MESSAGES/`, so they
must be committed together with the `.po` files.

## Current translations

| Locale | Language |
| ------ | -------- |
| `zh_CN` | Chinese (Simplified) |

## Adding a new translation

Requirements: `gettext` and `jq`.

1. Run `./merge.sh` to (re)generate `template.pot` from the sources.
2. Create your translation file from the template, e.g. `cp template.pot de.po`
   (use a locale code like `de`, `pt_BR`, `zh_TW`), translate the `msgstr`
   strings with an editor such as [Lokalize](https://apps.kde.org/lokalize/)
   or [Poedit](https://poedit.net/), and fill in the header fields
   (`Last-Translator`, `Language`, `Plural-Forms`).
3. Run `./build.sh` to compile every `.po` file into a `.mo` catalog under
   `package/contents/locale/`.
4. Test the result, e.g. with
   `plasmoidviewer -a com.github.antroids.application-title-bar`.
5. Commit the `.po` file together with the compiled `.mo` catalog and open a
   pull request.

## Updating translations after source changes

Run `./merge.sh`. It re-extracts the messages into `template.pot` and merges
them into every `.po` file: new strings show up untranslated, changed strings
are marked `fuzzy`.

## Notes

- Strings that are translated dynamically at runtime (e.g. `i18n(aVariable)`)
  cannot be found by `xgettext`. They are maintained manually in `dynamic.pot`
  and appended to the template by `merge.sh`. Keep them in sync with the plain
  string literals in the QML sources (e.g. `AddWidgetElement.qml`,
  `WindowControlButton.qml`).
- `xgettext` cannot parse the multiline string literals in
  `ConfigAppearance.qml`; the truncated extraction is filtered out by
  `merge.sh` and the full strings are maintained in `dynamic.pot` as well.
