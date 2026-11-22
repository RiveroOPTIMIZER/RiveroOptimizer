# WinUtil dependency audit

## Source identity

- Repository: https://github.com/ChrisTitusTech/winutil
- Pinned revision: `70c23c80641d7370532af2f619b2842658600842`
- Audited source tree: Git tree API at that exact revision; 755 paths total, not truncated.
- License: MIT; preserve the upstream license and copyright notices.

## Build model discovered

WinUtil's `Compile.ps1` generates a single `winutil.ps1` from source files. It:

1. Starts with `scripts/start.ps1` and substitutes build markers.
2. Concatenates every PowerShell file recursively under `functions/`.
3. Reads every top-level `config/*.json` file and embeds the parsed configuration.
4. Reads every PNG under `config/icons/` and embeds the images as base64 configuration data.
5. Embeds `xaml/inputXML.xaml`.
6. Embeds `tools/autounattend.xml`.
7. Appends `scripts/main.ps1`.

This means the previously copied launcher, main script, and XAML are not an independently runnable application. The original source build expects the function library, configuration, icons, and unattend XML too.

## Dependency inventory at the pinned revision

| Area | Count | Notes |
|---|---:|---|
| `functions/private/` | 90 PowerShell files | Internal UI, runspace, registry, package, install, removal, tweak and helper logic |
| `functions/public/` | 35 PowerShell files | Public UI actions including app installs/removals, fixes, updates, features and tweaks |
| Top-level `config/*.json` | 8 JSON files | Applications, navigation, AppX, DNS, features, presets, themes and tweaks |
| `config/icons/*.png` | 239 PNG files | App catalog artwork; not needed for a tweaks-only Rivero build |
| `scripts/` | 2 PowerShell files | Launcher and main orchestration |
| `xaml/` | 1 XAML file | Original full WinUtil WPF window |
| `tools/autounattend.xml` | 1 XML file | Windows unattended setup content; outside Rivero's current scope |
| `pester/` | 67 paths | Upstream tests; useful as references, but not a runtime dependency |

Other `tools/` paths support development, documentation, or title-screen asset generation. They are not required for the current Rivero tweaks-only preview.

## Scope and safety decision

Do **not** blindly copy and activate the full 125-function runtime or all 8 configuration files. The upstream function library contains workflows for application installation/removal, AppX removal, Windows updates, optional features, networking, unattended setup, and system tweaks. Those workflows exceed Rivero's currently agreed scope and need individual review.

For Rivero's current PC-only product:
- Retain the WinUtil WPF layout as a visual and interaction reference.
- Adapt only the Tweaks-oriented UI, excluding Install, Updates, and Create Windows workflows.
- Build Rivero-owned action handlers around the existing reviewed catalog.
- Do not execute upstream `start.ps1` unchanged: its launcher includes an elevation path and a fallback that downloads the latest upstream release script. Rivero must use its own pinned, reviewed local code path and must not silently fetch or execute moving remote code.
- Do not embed the upstream unattended setup XML or app-install icon catalog in the current build.
- Keep Defender, Firewall, UAC, BitLocker, Secure Boot, and Windows Update protections intact.
- Require an implemented restore path and Windows verification before labeling a tweak reversible.

## Next implementation steps

1. Extract the Tweaks page structure from the pinned upstream XAML into a Rivero-owned XAML view.
2. Map only visible Rivero controls to explicit catalog IDs; remove or disable placeholder controls.
3. Keep diagnostic and manual guidance actions separate from settings-changing actions.
4. Add tests for catalog validation, UI-to-action mapping, and restore behavior.
5. Run PowerShell 5.1 parsing and WPF smoke tests on Windows before calling the preview functional.

## Verification limits

This audit inspected the pinned source tree and build script. It did not execute WinUtil, compile Rivero, run Pester, or perform Windows WPF smoke tests. No runtime readiness is claimed.

## Tweaks page UI finding

The pinned upstream XAML's Tweaks tab provides the familiar recommended-selection toolbar, a dynamic `tweakspanel` placeholder, an explanatory note, and a bottom action bar with Run Tweaks / Undo Selected Tweaks. The tweak checkboxes are not hard-coded into that XAML region: the main orchestration layer builds and inserts them from `config/tweaks.json`. Therefore, copying only the XAML region would reproduce the layout shell but not a working tweak catalog or its event wiring.

Rivero's preview has now been clarified independently: the header displays Rivero branding, the redundant nonfunctional header buttons were removed, unfinished profile controls are visibly disabled with tooltips, and the out-of-scope AppX removal button was removed. This is a preview-only UI cleanup; it does not constitute adaptation of the upstream XAML or a completed runtime integration.
