#!/usr/bin/env bash
# Build codebase-size: embed report.html, mint canonical .mfl, compile to native.
set -euo pipefail
cd "$(dirname "$0")"

MACHIN="${MACHIN:-machin}"
command -v "$MACHIN" >/dev/null 2>&1 || { echo "error: '$MACHIN' not found (set MACHIN=/path/to/machin)"; exit 1; }

# Embed report.html as an MFL string constant in src/template.src.
python3 - <<'PY' > src/template.src
import json
html = open('report.html').read()
print('func report_template() (s) { s = ' + json.dumps(html) + ' }')
PY

"$MACHIN" encode codebase-size.src src/template.src > codebase-size.mfl
"$MACHIN" build codebase-size.mfl -o codebase-size

echo "built ./codebase-size"
