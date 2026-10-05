# Scotty Can Fix It Remote Support

An open-source Windows remote-support client branded for **Scotty Can Fix It**, based on [RustDesk](https://github.com/rustdesk/rustdesk) 1.5.0. This is an independent maintained fork, not an official RustDesk release.

The client uses `remote.scottycanfixit.com` for rendezvous and relay and includes the server's public key. No shared access password is embedded. Customers open the app, give their ID to their technician, and approve the connection. Only accept support sessions you requested.

## Downloads

[Release downloads](https://github.com/lunat1k5150/scotty-can-fix-it-remote-support/releases). Initial builds are **unsigned**. Windows may display an unrecognized publisher warning. A signing application is being prepared; acceptance and a signed release are not yet available.

Portable execution extracts application files under your local AppData folder and stores settings under your roaming AppData folder. Installation and unattended access are optional RustDesk features; normal attended support does not require a permanent password. To remove an installed copy, use Windows Settings → Apps; close a portable copy and remove its extracted files/settings if no longer needed.

## Source and builds

Licensed under **AGPL-3.0**, preserving upstream notices. Source changes and build scripts are public. The `scotty-support` branch starts at upstream commit `fada664df7a294d1d1a9ca3e7cd3637069122f17` (1.5.0). Branding is applied by `scotty/apply-branding.py`, including to the pinned `hbb_common` submodule.

The manual **Scotty Windows build** workflow builds on GitHub-hosted Windows runners and uploads the executable, corresponding modified source, hashes and build manifest. It requires no signing secrets. The workflow must succeed before its artifacts can be considered verified cloud builds.

## Code signing policy

See [Code signing policy](scotty/CODE-SIGNING-POLICY.md) and [Privacy policy](scotty/PRIVACY.md). SignPath Foundation approval is pending, and no release currently claims a SignPath signature.

Support: [support@scottycanfixit.com](mailto:support@scottycanfixit.com) · [Scotty Can Fix It](https://scottycanfixit.com)
