#!/usr/bin/env bash
# Source zip for submission: the committed files of this repo and every submodule (git archive), so keys/, .env,
# logs/, bin/ and obj/ are never included and text files keep LF line endings (scripts run on macOS and Linux too).
# Usage: bash make-zip.sh
set -euo pipefail
cd "$(dirname "$0")"

git submodule update --init
NAME=MCSC6002_SecureInventory

# Guard: nothing secret-looking may be committed.
if git ls-files --recurse-submodules | grep -E '(^|/)(keys/|\.env$)|\.(pem|pfx|key)$'; then
  echo "refusing: secret-looking files above are committed"; exit 1
fi

{ echo .; git submodule --quiet foreach 'echo $sm_path'; } | python -c "
import io, subprocess, sys, tarfile, zipfile
count = 0
with zipfile.ZipFile('$NAME.zip', 'w', zipfile.ZIP_DEFLATED) as z:
    for repo in sys.stdin.read().split():
        tar = tarfile.open(fileobj=io.BytesIO(subprocess.run(['git', '-c', 'core.autocrlf=false', '-C', repo, 'archive', '--format=tar', 'HEAD'], capture_output=True, check=True).stdout))
        for member in tar.getmembers():
            if member.isfile():
                z.writestr('$NAME/' + ('' if repo == '.' else repo + '/') + member.name, tar.extractfile(member).read())
                count += 1
print(f'$NAME.zip: {count} files')
"
