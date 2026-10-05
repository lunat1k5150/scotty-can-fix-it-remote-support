# Code signing policy

## Current status

Unsigned. An application to SignPath Foundation is being prepared. No certificate or service has been granted and this project does not claim to be signed by SignPath.

If approved, the required credit will be published on the home and release pages: “Free code signing provided by [SignPath.io](https://signpath.io), certificate by [SignPath Foundation](https://signpath.org).” The certificate publisher would be SignPath Foundation; the application branding remains Scotty Can Fix It.

## Responsibilities

Repository owner [lunat1k5150](https://github.com/lunat1k5150) is the maintainer, reviewer and proposed release/signing approver. External contributions, upstream updates, build scripts and branding changes require maintainer review before signing. Every signing request will require manual approval. All team members must use MFA on GitHub and SignPath before signing is activated; this document states the requirement, not a verification that account settings already comply.

## Build and release controls

Only artifacts built from this public fork on GitHub-hosted runners will be submitted. Locally built files cannot be substituted into a trusted signing request. Build tools and native libraries are pinned; the custom Flutter engine download is checked against SHA-256. Signing configuration must enforce Scotty Can Fix It product metadata and consistent 1.5.0 product versions for project-owned binaries. Third-party components retain their original licensing and are not represented as authored by Scotty Can Fix It.

SignPath project configuration, credentials and approval rules will be added only after acceptance. No signing API token or private certificate is stored in this repository.

## Privacy

See [Privacy policy](PRIVACY.md), including automatic rendezvous registration and relay use.
