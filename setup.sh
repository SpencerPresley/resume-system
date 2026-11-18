#!/usr/bin/env bash
# One-time setup.
#
#   ./setup.sh                    # first time: start me/ from the example and git init it
#   ./setup.sh <private-repo-url> # another machine: clone your existing private repo into me/
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

missing=0
check() {
  if command -v "$1" >/dev/null 2>&1; then
    printf '  ok       %s\n' "$1"
  else
    printf '  MISSING  %s  (%s)\n' "$1" "$2"
    missing=1
  fi
}

echo "Dependencies:"
check pandoc  "brew install pandoc  |  apt install pandoc"
check pdfinfo "brew install poppler |  apt install poppler-utils"
check pdffonts "brew install poppler |  apt install poppler-utils"
chrome=""
for c in "${CHROME:-}" \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium" \
  google-chrome google-chrome-stable chromium chromium-browser; do
  [[ -z "$c" ]] && continue
  if [[ -x "$c" ]] || command -v "$c" >/dev/null 2>&1; then chrome="$c"; break; fi
done
if [[ -n "$chrome" ]]; then
  printf '  ok       chrome (%s)\n' "$chrome"
else
  printf '  MISSING  chrome  (install Google Chrome or Chromium, or set CHROME=/path/to/chrome)\n'
  missing=1
fi

echo
if [[ -e me ]]; then
  echo "me/ already exists; leaving it alone."
elif [[ $# -ge 1 ]]; then
  git clone "$1" me
else
  cp -R example/me me
  git -C me init -q
  printf '.DS_Store\n' > me/.gitignore
  echo "Created me/ from the example and ran git init in it."
  echo "Next: edit me/CLAUDE.md and me/versions/resume.md, then create a PRIVATE"
  echo "repo for it and push (e.g. gh repo create <name> --private --source me --push)."
fi

echo
if [[ $missing -eq 1 ]]; then
  echo "Install the missing dependencies above, then render with:"
else
  echo "Render with:"
fi
if [[ -f me/versions/resume.md ]]; then
  echo "  ./render.sh me/versions/resume.md"
else
  echo "  ./render.sh me/versions/<file>.md"
fi
