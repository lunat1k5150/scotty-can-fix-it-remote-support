# Privacy policy — Scotty Can Fix It Remote Support

This client is an independent open-source RustDesk fork used for customer-authorized remote support. It is configured to contact `remote.scottycanfixit.com`, operated by Scotty Can Fix It, automatically while running to register its support ID and make connections possible. Opening the app therefore initiates network communication even before a remote session begins.

The rendezvous/relay service necessarily receives connection metadata such as client IP addresses, identifiers, timestamps and routing information. A relay may carry encrypted session traffic when a direct connection is unavailable. Do not treat the server public key as an access password; it identifies the configured server.

During an authorized session the technician can see your screen and, depending on the permissions you grant, control your computer, use clipboard sharing or transfer files. Close private information before accepting support. You may reject or end a session. Do not enable unattended access unless you understand and intend the persistent access it permits.

Local settings and diagnostic logs are stored on your computer. No custom advertising, analytics or shared password is added by this fork. This policy does not promise that upstream dependencies generate no diagnostic traffic. GitHub hosts source and downloads under [GitHub's privacy statement](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement). The upstream project is [RustDesk](https://github.com/rustdesk/rustdesk); upstream service policies may apply if you manually configure their services.

The application provides network settings to change the server configuration. Closing the application stops portable attended-support operation; an installed background service must also be stopped or uninstalled. Contact [support@scottycanfixit.com](mailto:support@scottycanfixit.com) for server-side privacy, logs or deletion questions. No unverified server log-retention period is asserted here.

Date: October 5, 2026.
