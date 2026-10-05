$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
$repoRoot = (Resolve-Path "$PSScriptRoot\..").Path
$buildRoot = 'C:\ScottyBuild'
New-Item -ItemType Directory -Force $buildRoot | Out-Null
# Keep Flutter's symlinks and generated paths short, outside AppData.
$sourceRoot = "$buildRoot\source"
$PSNativeCommandUseErrorActionPreference = $false
& robocopy $repoRoot $sourceRoot /E /XD .git target build .dart_tool .plugin_symlinks ephemeral /NFL /NDL /NJH /NJS
if ($LASTEXITCODE -gt 7) { throw 'Source copy failed' }
$global:LASTEXITCODE = 0
$PSNativeCommandUseErrorActionPreference = $true
Set-Location $sourceRoot
python scotty/apply-branding.py
$env:PUB_CACHE = "$buildRoot\pub"
$env:VCPKG_ROOT = "$buildRoot\vcpkg"
$env:LIBCLANG_PATH = 'C:\Program Files\LLVM\bin'
$env:RUST_LOG = 'info'
rustup toolchain install 1.75.0 --profile minimal --component rustfmt
rustup toolchain install 1.99.0 --profile minimal
rustup override set 1.75.0
cargo +1.75.0 install cargo-expand --version 1.0.95 --locked
cargo +1.75.0 install flutter_rust_bridge_codegen --version 1.80.1 --locked
python -m pip install brotli==1.2.0
git clone https://github.com/microsoft/vcpkg.git $env:VCPKG_ROOT
git -C $env:VCPKG_ROOT checkout 9e593bb18ea69cc5095e012465dcd675a822ed0d
& "$env:VCPKG_ROOT\bootstrap-vcpkg.bat" -disableMetrics
& "$env:VCPKG_ROOT\vcpkg.exe" install libvpx:x64-windows-static libyuv:x64-windows-static opus:x64-windows-static aom:x64-windows-static --classic
git clone --depth 1 --branch 3.24.5 https://github.com/flutter/flutter.git "$buildRoot\flutter"
$env:PATH = "$buildRoot\flutter\bin;$env:PATH"
flutter config --no-analytics
flutter precache --windows
git -C "$buildRoot\flutter" apply "$sourceRoot\.github\patches\flutter_3.24.4_dropdown_menu_enableFilter.diff"
Invoke-WebRequest 'https://github.com/rustdesk/engine/releases/download/main/windows-x64-release.zip' -OutFile "$buildRoot\engine.zip"
if ((Get-FileHash "$buildRoot\engine.zip" -Algorithm SHA256).Hash -ne 'EC8CABF36EE4FF24C8D98DE25B00E70781EB03876265AEE84D0FE554A110036E') { throw 'Flutter engine hash mismatch' }
Expand-Archive "$buildRoot\engine.zip" "$buildRoot\engine"
Copy-Item "$buildRoot\engine\*" "$buildRoot\flutter\bin\cache\artifacts\engine\windows-x64-release\" -Recurse -Force
Push-Location flutter
flutter pub get
Pop-Location
flutter_rust_bridge_codegen --rust-input src/flutter_ffi.rs --dart-output flutter/lib/generated_bridge.dart --c-output flutter/macos/Runner/bridge_generated.h
cargo +1.75.0 build --locked --features flutter --lib --release
cargo +1.75.0 build --locked -p dylib_virtual_display --release
Push-Location flutter
flutter build windows --release
Pop-Location
$releaseRoot = "$sourceRoot\flutter\build\windows\x64\runner\Release"
Copy-Item 'target\release\dylib_virtual_display.dll' $releaseRoot
Rename-Item "$releaseRoot\rustdesk.exe" 'scotty can fix it.exe'
Copy-Item LICENSE $releaseRoot
Copy-Item 'scotty\CUSTOMER-README.txt' "$releaseRoot\READ-ME.txt"
# Independent packaging avoids incompatible toolchains in the upstream workspace.
$packRoot = "$buildRoot\portable-packager"
New-Item -ItemType Directory -Force "$packRoot\brand" | Out-Null
Copy-Item 'libs\portable\src' $packRoot -Recurse
Copy-Item 'libs\portable\Cargo.toml' $packRoot
Copy-Item 'scotty\portable-Cargo.lock' "$packRoot\Cargo.lock"
$packBuild = (Get-Content 'libs\portable\build.rs' -Raw).Replace('../../res/', 'brand/')
Set-Content "$packRoot\build.rs" $packBuild -Encoding utf8
Copy-Item 'res\icon.ico','res\manifest.xml' "$packRoot\brand"
python libs/portable/generate.py -f $releaseRoot -e 'scotty can fix it.exe' --package "$packRoot\data.bin" -l 6
Set-Content "$packRoot\app_metadata.toml" "timestamp = $([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds())" -Encoding utf8
Push-Location $packRoot
cargo +1.99.0 build --release --locked
Pop-Location
$outRoot = "$repoRoot\scotty-dist"
New-Item -ItemType Directory -Force $outRoot | Out-Null
Copy-Item "$packRoot\target\release\rustdesk-portable-packer.exe" "$outRoot\Scotty-Can-Fix-It-Remote-Support.exe"
Copy-Item 'scotty\CUSTOMER-README.txt' "$outRoot\READ-ME.txt"
$exe = Get-Item "$outRoot\Scotty-Can-Fix-It-Remote-Support.exe"
if ($exe.VersionInfo.ProductName -ne 'Scotty Can Fix It') { throw 'Brand metadata mismatch' }
if ((Get-AuthenticodeSignature $exe.FullName).Status -ne 'NotSigned') { throw 'Unexpected signing status' }
python scotty/package-source.py $sourceRoot $packRoot $outRoot
@{
  project='Scotty Can Fix It'; version='1.5.0'; signing_status='unsigned';
  source_commit=$env:GITHUB_SHA; repository=$env:GITHUB_REPOSITORY; run_id=$env:GITHUB_RUN_ID;
  upstream_commit='fada664df7a294d1d1a9ca3e7cd3637069122f17';
  id_and_relay_server='remote.scottycanfixit.com'; shared_password=$null;
  features='flutter (software codecs)'; virtual_printer_driver='not bundled';
  remote_session_test='not performed by CI'
} | ConvertTo-Json | Set-Content "$outRoot\BUILD-MANIFEST.json" -Encoding utf8
Get-ChildItem $outRoot -File | Where-Object Name -ne SHA256SUMS.txt | ForEach-Object {
  "$((Get-FileHash $_.FullName -Algorithm SHA256).Hash.ToLower())  $($_.Name)"
} | Set-Content "$outRoot\SHA256SUMS.txt" -Encoding utf8
