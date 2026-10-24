#!/usr/bin/env bash
# Source zip for submission: committed files only (this repo and all submodules), so keys/, .env,
# logs/, bin/ and obj/ are never included. Usage: bash make-zip.sh
set -euo pipefail
cd "$(dirname "$0")"

git submodule update --init
NAME=MCSC6002_SecureInventory
FILES=$(git ls-files --recurse-submodules)

# Guard: nothing secret-looking may be committed.
if echo "$FILES" | grep -E '(^|/)(keys/|\.env$)|\.(pem|pfx|key)$'; then
  echo "refusing: secret-looking files above are committed"; exit 1
fi

echo "$FILES" | python -c "
import sys, zipfile
with zipfile.ZipFile('$NAME.zip', 'w', zipfile.ZIP_DEFLATED) as z:
    for path in sys.stdin.read().splitlines():
        z.write(path, '$NAME/' + path)
"
echo "$NAME.zip: $(echo "$FILES" | wc -l) files, $(du -h "$NAME.zip" | cut -f1)"
