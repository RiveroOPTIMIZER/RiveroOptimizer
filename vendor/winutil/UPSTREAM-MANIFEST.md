# WinUtil upstream integration manifest

Rivero Optimizer is an independent adaptation and is not an official Chris Titus Tech release.

## Pinned upstream source

- Project: https://github.com/ChrisTitusTech/winutil
- Snapshot commit: [70c23c80641d7370532af2f619b2842658600842](https://github.com/ChrisTitusTech/winutil/commit/70c23c80641d7370532af2f619b2842658600842)
- License: MIT
- Copyright: Copyright (c) 2022 CT Tech Group LLC
- Original license is retained at `vendor/winutil/upstream/LICENSE` and in `THIRD-PARTY-NOTICES.md`.

## Vendored source snapshot

The following original upstream files have been copied without Rivero branding edits so they can be reviewed and adapted against a fixed source revision:

| Local path | Upstream path | Purpose |
|---|---|---|
| `vendor/winutil/upstream/scripts/start.ps1` | `scripts/start.ps1` | Startup and parameter handling |
| `vendor/winutil/upstream/scripts/main.ps1` | `scripts/main.ps1` | Main orchestration |
| `vendor/winutil/upstream/xaml/inputXML.xaml` | `xaml/inputXML.xaml` | Original WPF interface |
| `vendor/winutil/upstream/LICENSE` | `LICENSE` | Upstream MIT license |

These files are a source snapshot only. The runtime is **not yet complete or runnable**: WinUtil also depends on its configuration files, function libraries, assets, and other resources. Do not launch the vendored scripts directly from this partial snapshot.

## Rivero product decisions

- Product name: **Rivero Optimizer**.
- Visual identity: black and green.
- Interface language: Spanish.
- Device scope: **desktop PC only**. Do not add a laptop selector, laptop profile, or laptop-specific options.
- Main section: Rivero Optimizer, adapted from the WinUtil Tweaks workflow.
- Separate section: Sophia Script, maintained as an independently credited component.
- Information section: retain TikTok `davii.cf` and Discord `desgastarte`.
- Do not add wallpaper browsing until the core optimizer is working.

## Adaptation and safety rules

1. Preserve the recognizable WinUtil WPF layout and interaction model while applying Rivero branding and Spanish labels.
2. Keep upstream identifiers and internal JSON keys stable unless every dependent reference is updated.
3. Review every imported action before making it available. Do not enable destructive or security-reducing actions by default.
4. Never disable Microsoft Defender, Firewall, UAC, BitLocker, Secure Boot, or Windows Update as an optimization.
5. Do not force high-performance power plans or alter OEM thermal protections.
6. Never label a change reversible unless its restore path is implemented and tested.
7. Preserve the MIT copyright and permission notices with copied substantial portions. Clearly distinguish Rivero-authored modifications from upstream code.
8. Do not publish a runnable build until dependency review, PowerShell tests, and Windows PowerShell 5.1/WPF smoke tests pass.

## Dependency audit

A source/build dependency audit is recorded in [DEPENDENCY-AUDIT.md](DEPENDENCY-AUDIT.md). It confirms that upstream WinUtil compiles a single script from the launcher, all function files, eight JSON configuration files, 239 app icons, the full XAML, an unattended-setup XML resource, and the main orchestration script. The complete upstream runtime is broader than Rivero's agreed tweaks-only scope, so it must not be copied and activated wholesale. In particular, the upstream launcher can download and execute the latest release script as a fallback; Rivero must not use that path.

## Current status

- [x] Pin a specific upstream commit.
- [x] Vendor the original launcher, main orchestration script, WPF XAML, and MIT license as a reviewable source snapshot.
- [x] Keep Sophia Script and Information as separate UI sections in the Rivero preview.
- [x] Audit the pinned upstream build model and runtime dependency inventory; document exclusions for Rivero's narrower scope.
- [ ] Selectively vendor/adapt only the Tweaks UI dependencies needed by Rivero.
- [ ] Extract and adapt the upstream Tweaks page XAML to Rivero's black/green theme and Spanish labels.
- [ ] Connect only reviewed PC-safe actions to the UI.
- [ ] Integrate Sophia Script separately with its own dependency and action review.
- [ ] Run automated tests and Windows PowerShell 5.1/WPF smoke tests.

The existing `RiveroOptimizer-WPF-Preview.ps1` remains a development preview. The vendored upstream snapshot is not wired into it yet.
