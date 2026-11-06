#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
template_dir="$repo_root/.cache/data/godot/export_templates/4.6.3.stable"
if python - "$repo_root" "$template_dir" <<'PY'
from pathlib import Path
import hashlib,json,sys
root,target=map(Path,sys.argv[1:])
spec=json.loads((root/'config/web-template-checksums.json').read_text())
valid=all((target/name).is_file() and hashlib.sha256((target/name).read_bytes()).hexdigest()==value for name,value in spec['templates_sha256'].items())
sys.exit(0 if valid else 1)
PY
then
    printf 'Verified web templates already available.\n'
    exit 0
fi
mkdir -p "$repo_root/.cache/downloads" "$template_dir"
archive_path="$repo_root/.cache/downloads/export_templates-4.6.3.tpz"
curl --location --fail --silent --show-error --connect-timeout 10 --max-time 300 \
    --output "$archive_path" 'https://github.com/godotengine/godot-builds/releases/download/4.6.3-stable/Godot_v4.6.3-stable_export_templates.tpz'
python - "$repo_root" "$template_dir" "$archive_path" <<'PY'
from pathlib import Path
import hashlib,json,sys,zipfile
root,target,archive_path=map(Path,sys.argv[1:])
spec=json.loads((root/'config/web-template-checksums.json').read_text())
with archive_path.open('rb') as source:
    assert hashlib.file_digest(source,'sha512').hexdigest()==spec['archive_sha512'],'Official archive checksum mismatch'
with zipfile.ZipFile(archive_path) as archive:
    for name,digest in spec['templates_sha256'].items():
        data=archive.read('templates/'+name)
        assert hashlib.sha256(data).hexdigest()==digest,'Template checksum mismatch'
        (target/name).write_bytes(data)
print('Official web templates verified and installed.')
PY
