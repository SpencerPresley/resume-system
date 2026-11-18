#!/usr/bin/env bash
# Render resume markdown to HTML, PDF, and DOCX next to the source, then check the page count.
#
#   ./render.sh me/versions/resume.md                 # must fit on 1 page
#   ./render.sh --max-pages 2 me/versions/master.md   # allow 2
#   ./render.sh me/versions/*.md                      # several at once
#   ./render.sh --force me/versions/resume.md         # re-render even if unchanged
#
# If the new HTML (markdown + CSS + title) matches the existing one, the PDF and DOCX
# are left untouched: Chrome and pandoc stamp a creation time into them, so
# re-rendering identical content would otherwise show up as a git change.
#
# The PDF <title> is the file's "# " heading. Set TITLE="..." to override it
# (e.g. a redacted copy whose heading is a placeholder).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STYLE="$ROOT/.render/style.html"
max_pages=1
force=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-pages) max_pages="$2"; shift 2 ;;
    --force) force=1; shift ;;
    *) break ;;
  esac
done
if [[ $# -eq 0 ]]; then
  sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
fi

find_chrome() {
  if [[ -n "${CHROME:-}" ]]; then echo "$CHROME"; return; fi
  local c
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    google-chrome google-chrome-stable chromium chromium-browser; do
    if [[ -x "$c" ]] || command -v "$c" >/dev/null 2>&1; then echo "$c"; return; fi
  done
  echo "render.sh: Chrome/Chromium not found; set CHROME=/path/to/chrome" >&2
  exit 1
}
CHROME_BIN="$(find_chrome)"

status=0
for md in "$@"; do
  if [[ ! -f "$md" ]]; then echo "render.sh: no such file: $md" >&2; status=1; continue; fi
  dir="$(cd "$(dirname "$md")" && pwd)"
  base="$dir/$(basename "$md" .md)"
  title="${TITLE:-$(grep -m1 '^# ' "$md" | sed 's/^# //')}"

  new_html="$(mktemp)"
  pandoc "$md" -s --include-in-header="$STYLE" --metadata title="$title" -t html -o "$new_html"
  if (( ! force )) && [[ -f "$base.pdf" && -f "$base.docx" ]] && cmp -s "$new_html" "$base.html"; then
    rm -f "$new_html"
    note="unchanged, "
  else
    mv "$new_html" "$base.html"
    "$CHROME_BIN" --headless --no-pdf-header-footer --print-to-pdf="$base.pdf" "file://$base.html" 2>/dev/null
    pandoc "$md" -o "$base.docx"
    note=""
  fi

  pages="$(pdfinfo "$base.pdf" | awk '/^Pages:/ {print $2}')"
  type3="$(pdffonts "$base.pdf" | grep -c 'Type 3' || true)"
  verdict="${note}ok"
  if (( pages > max_pages )); then verdict="OVER (max $max_pages)"; status=1; fi
  if (( type3 > 0 )); then verdict="$verdict, $type3 Type 3 font(s): ATS will misread text"; status=1; fi
  printf '%-60s %s page(s)  %s\n' "${md}" "$pages" "$verdict"
done
exit $status
