# Latch Homebrew tap

Install Latch on macOS:

```sh
brew install vishnusenthil-16/tap/latch-secrets
```

Install Bitwarden CLI 2026.8.0 separately, then configure Latch:

```sh
latch configure --server https://vault.example.com --bw /absolute/path/to/bw
latch login
latch doctor --json
```

For upgrades, run `brew upgrade latch-secrets`, then rerun `latch configure`
while the existing desktop helper remains running to transfer its Keychain session.

Source and documentation: https://github.com/vishnusenthil-16/latch-secrets
