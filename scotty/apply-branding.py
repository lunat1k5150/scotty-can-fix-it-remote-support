"""Apply auditable branding to an upstream 1.5.0 checkout, including its submodule."""
from pathlib import Path
import shutil

root = Path(__file__).resolve().parents[1]

def replace(path, old, new):
    p = root / path
    s = p.read_text(encoding="utf-8")
    if new in s:
        return
    if old not in s:
        raise RuntimeError(f"Expected upstream text missing: {path}: {old}")
    p.write_text(s.replace(old, new), encoding="utf-8")

replace("libs/hbb_common/src/config.rs", 'RwLock::new("RustDesk".to_owned())', 'RwLock::new("Scotty Can Fix It".to_owned())')
replace("libs/hbb_common/src/config.rs", 'pub const RENDEZVOUS_SERVERS: &[&str] = &["rs-ny.rustdesk.com"];', 'pub const RENDEZVOUS_SERVERS: &[&str] = &["remote.scottycanfixit.com"];')
replace("libs/hbb_common/src/config.rs", 'pub const RS_PUB_KEY: &str = "OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=";', 'pub const RS_PUB_KEY: &str = "gBTkUg5wNVSyQdJeFM4tRxO+KO9K9gjeqhkwgHstaQY=";')
for field, old, new in [("ProductName", "RustDesk", "Scotty Can Fix It"), ("FileDescription", "RustDesk Remote Desktop", "Scotty Can Fix It Remote Support")]:
    replace("flutter/windows/runner/Runner.rc", f'VALUE "{field}", "{old}"', f'VALUE "{field}", "{new}"')
    replace("libs/portable/Cargo.toml", f'{field} = "RustDesk Remote Desktop"' if field == "FileDescription" else f'{field} = "RustDesk"', f'{field} = "{new}"')
for destination in ["res/icon.ico", "flutter/windows/runner/resources/app_icon.ico"]:
    shutil.copyfile(root / "scotty/branding/icon.ico", root / destination)
for source, destination in [("logo.png", "logo.png"), ("icon.png", "icon.png")]:
    shutil.copyfile(root / "scotty/branding" / source, root / "flutter/assets" / destination)
print("Scotty branding and public server defaults applied; no password embedded.")
