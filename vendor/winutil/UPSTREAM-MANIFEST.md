# WinUtil upstream integration manifest

This project adapts the upstream WinUtil interface and workflows. It is not an official Chris Titus Tech release.

## Upstream source

- Project: https://github.com/ChrisTitusTech/winutil
- Reviewed release: 26.11.13 (2026-11-13)
- License: MIT
- Upstream copyright notice: Copyright (c) 2022 CT Tech Group LLC
- Upstream license text: https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/LICENSE

Keep the upstream copyright and MIT permission notice with every copied substantial portion. Rivero-specific code must be identified separately. Do not imply endorsement by the upstream authors.

## Required upstream areas

The upstream repository currently contains approximately 378 tracked paths under the main runtime areas. A complete port cannot be made by copying only the launcher and XAML.

| Area | Upstream path | Purpose |
|---|---|---|
| Launcher and startup | `scripts/start.ps1` | Parameter handling, elevation, shared state and startup |
| Main orchestration | `scripts/main.ps1` | UI thread, runspaces, headless operation and shutdown |
| WPF interface | `xaml/inputXML.xaml` | Window, tabs, controls, styles and event wiring |
| Core settings | `config/*.json` | Applications, tweaks, presets, features, DNS and themes |
| Runtime functions | `functions/private/`, `functions/public/` | UI handlers, package actions, configuration and system operations |
| App assets | `config/icons/` | Application catalog imagery |

## Rivero adaptation rules

1. Preserve upstream WPF layout and behavior rather than replacing it with a newly invented WinForms interface.
2. Apply Rivero's black/green palette through the upstream WPF resource keys.
3. Translate user-facing labels, descriptions, tooltips and status messages into Spanish. Keep PowerShell identifiers, JSON keys and internal IDs stable unless every reference is updated together.
4. Add a visible PC/LAPTOP selector. Auto-detection is a suggestion only; the user can override it.
5. Keep a shared category structure while filtering each tweak by explicit device applicability.
6. Review each tweak before enabling it. Do not import destructive or security-reducing actions as defaults.
7. Preserve Windows Defender, Firewall, UAC, BitLocker, Secure Boot, Windows Update and OEM thermal controls.
8. On laptops, preserve sleep, hibernation, battery saver and OEM power/thermal management. Do not force High Performance or disable wireless power saving.
9. Never label a tweak reversible unless its undo path has been implemented and tested.
10. Do not publish a runnable build until Windows PowerShell 5.1/WPF smoke tests and the PowerShell test suite pass.

## Current integration status

The repository currently contains Rivero-specific theme metadata, a laptop safety profile, a device-profile module and Pester tests. The original WinForms prototype is not the final interface and its placeholder buttons must not be represented as working system tweaks.

The upstream runtime has not yet been vendored or wired into Rivero. The release is therefore not ready for end-user testing.
