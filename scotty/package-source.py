from pathlib import Path
import sys, zipfile
source, pack, out = map(Path, sys.argv[1:])
excluded = {'.git', 'target', 'build', '.dart_tool', '.plugin_symlinks', 'ephemeral', '__pycache__', 'scotty-dist'}
with zipfile.ZipFile(out / 'Scotty-Can-Fix-It-Remote-Support-Source.zip', 'w', zipfile.ZIP_DEFLATED) as z:
    for root, label in [(source, 'rustdesk'), (pack, 'portable-packager')]:
        for p in root.rglob('*'):
            rel = p.relative_to(root)
            if p.is_symlink() or excluded.intersection(rel.parts) or p.name == 'data.bin':
                continue
            if p.is_file():
                z.write(p, str(Path(label) / rel))
