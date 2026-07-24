#!/usr/bin/env bash
# Build codebase-size: embed HTML templates, mint canonical .mfl, compile to native.
set -euo pipefail
cd "$(dirname "$0")"

MACHIN="${MACHIN:-machin}"
command -v "$MACHIN" >/dev/null 2>&1 || { echo "error: '$MACHIN' not found (set MACHIN=/path/to/machin)"; exit 1; }

# Embed report.html and compare.html as MFL string constants.
python3 - <<'PY'
import json
for name in ['report', 'compare']:
    html = open(f'{name}.html').read()
    with open(f'src/{name}_template.src', 'w') as f:
        f.write(f'func {name}_template() (s) {{ s = ' + json.dumps(html) + ' }')
PY

"$MACHIN" encode codebase-size.src src/*.src > codebase-size.mfl
"$MACHIN" build codebase-size.mfl -o codebase-size

echo "built ./codebase-size"
