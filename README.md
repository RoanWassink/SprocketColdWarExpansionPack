# Sprocket Cold War Expansion Pack

**[Download the full pack 0.2.0](https://github.com/RoanWassink/SprocketColdWarExpansionPack/releases/tag/v0.2.0)** — beta for Sprocket 0.2.55.5, Windows x64, BepInEx 6 IL2CPP 6.0.0-be.788.

The full pack includes the core and ten coordinated modules in total. **Choose the full pack or the core-only ZIP; you do not need both.** The [Sprocket Mod Loader](https://github.com/Hans21223/Sprocket-Mod-Loader) is a separate prerequisite. GitHub's Code > Download ZIP contains source, not an installed mod pack.

## What's new since 0.1.1

- Dedicated square ATGM launcher, one initial missile per launcher, and a nearby finite ATGM ammo box.
- Optical and laser rangefinders, automatic ballistic ranging including APFSDS, internal FCS linked to external sights, horizontal/vertical thermal heads, T72 style sight, scalable glass panes and updated icons.
- Both-axis drive tuning at the elevation drive, with stronger postwar turret motors.
- Mirror feed-arm option for the bustle autoloader.
- Short armour tooltips explaining protection benefits and useful thicknesses.
- Native dated Era/Technology data controls availability and engine pricing, replacing hidden overrides.
- Compatible settings/vehicle migration to neutral addon identifiers for the updated modules.

## Included modules

| Module | Version |
|---|---|
| Cold War Core | 0.2.0 |
| Shell Selector | 0.12.5 |
| Material Selector | 0.4.8 |
| Thermal Sight | 0.2.6 |
| Carousel Autoloader | 0.2.12 |
| Stabilization | 0.1.0 |
| Keybinds API | 0.1.6 |
| Hydropneumatic | 0.4.2 |
| Telescopic Mast | 0.3.8-postwar.1 |
| Smoke Launchers | 0.2.5 |

Hydropneumatic, Mast and Smoke retain their existing public gameplay builds. Each plugin's README is included under Docs. The source for separately maintained plugins is available in its corresponding GitHub repository.

## Install or update

1. Install the separate loader and start/close Sprocket once. Close the game before every mod update.
2. Back up vehicle saves and the mod files you intend to replace.
3. Recommended: run `./Install-Pack.ps1 -GameDir 'C:/path/to/Sprocket'` in PowerShell to preview the plan, then repeat with `-Apply`. The installer verifies hashes, backs up changed files and preserves existing configs, profile catalogues, custom Technology/Era data and audio overrides.
4. For a manual install, merge **Payload/BepInEx** and **Payload/Sprocket_Data** into the folder containing Sprocket.exe. Replace matching DLLs/assets and retain one copy of each plugin. Never replace the entire BepInEx folder. Preserve existing config/catalogue files and customized native data. Copy missing defaults only.
5. Copy the new `sprocketBustleAutoloaderPart.json`, then back up/remove the exact older `roanBustleAutoloaderPart.json` from Parts. The part's GUID is unchanged; do not load both definitions. The installer handles the known original file.
6. Start Sprocket. Review the updated module settings and your customized technology dates.

Existing settings take precedence. The updated modules copy their previous CFG only when the neutral CFG is absent, retaining the original for rollback. Thermal controls require the included API 0.1.6. Do not install private API copies alongside it. Existing keybind choices, profile IDs and material IDs are retained. Back up vehicles: new saves use neutral keys that older plugins may not read.

Fresh pack defaults enable armour responses and automatic ATGM-box feeding. Existing catalogues/configs are preserved. For an update from 0.1.1, enable `AutomaticAmmoBox = true` in `[ATGM Launcher Tests]` in `BepInEx/config/sprocket.shellselector.cfg` if you want the box to load automatically; restart. `InitialReadyMissile` controls the first missile and `OpticalSightDirection` controls the optional dedicated-launcher sight initialization. A gunner and a matching SACLOS/MCLOS profile remain necessary; Vanilla ammunition is not a ready guided missile.

## Using the additions

**ATGM:** place a launcher, select SACLOS or MCLOS, assign its gunner and choose a fire group. It begins each new Play session with one finite missile. Put a compatible ammo box within its approximately 2 m feed reach for reserve loading, with matching ammunition/calibre. Empty reserves do not refill magically. Launcher clearance and optical alignment still follow limitations described in Shell Selector's README.

**FCS and thermal:** place the FCS near the gunner and link external sights in the inspector. One FCS can serve several sights with no sight-to-FCS distance limit. The gunner's normal operating reach still applies at the FCS. Select the thermal profile on the sight itself. Configure Thermal / Toggle, Reload profiles and Measure range through Settings/keybinds; measure starts unbound. A fitted rangefinder serves any active sight on the vehicle. The automatic laser uses shell ballistics to set range.

**Stabilization:** select an elevation drive and open Stabilization drive setup. Strength uses a compact display scale; turret Torque and Ratio use native drive controls. More torque improves acceleration and holding strength, while a lower ratio increases top speed. Balance, crew, native mass/cost and gearing still matter. This tunes native tracking; it does not guarantee perfect aim over every bump. Default availability starts on 3 September 1945.

**Armour:** hover Protection for concise strengths, reaction/thickness limits and tradeoffs. Passive armour and reactive recipes differ. Extra reactions require the enabled shared catalogue and paired Shell/Material modules. Existing protection coefficients are unchanged.

## Customize and troubleshoot

Keep `BepInEx/config/sprocket.shellselector.shells.json`, `sprocket.armour.responses.json`, `sprocket.keybinds.json`, and `BepInEx/plugins/SprocketThermalSight/thermal-models.json`. See module docs for valid examples, ranges and reload controls. Edit native Era/Technology JSON with the game closed and restart. Availability follows the actual vehicle technology/date context; custom dates do not require a fixed era name. The core-only download has editable engine/cannon/era templates with installation instructions.

If a module is absent, inspect BepInEx/LogOutput.log for missing dependencies or duplicate DLLs. Blank icons/models indicate missing asset/native-part files. If the installer preserves a customized native definition, review that file before changing its date/properties. The pack does not install or update the loader. Smoke is visual smoke; it does not promise AI or thermal occlusion. Thermal imagery and armour responses are gameplay approximations.

## Rollback or remove

The installer writes a backup journal. Use `./Restore-Pack.ps1 -BackupDir 'C:/path/to/backup' -GameDir 'C:/path/to/Sprocket'` to preview rollback, then add `-Apply`. Restore pre-update vehicle copies when reverting saved-key changes. Existing configs and saves that the installer preserved are not rolled back. Before uninstalling custom parts/materials, remove them from vehicles you intend to keep using. Remove only owned files and leave shared dependencies needed by other mods intact.

## Credits and support

**Wolfosito** created the T72 gunner sight and FCS models.

Sprocket is created by Hamish. BepInEx, Harmony and Il2CppInterop provide the framework. Mod work uses AI assistance. Module licenses and asset credits are included in Docs; no game binaries, loader, generated interop/cache or private saves/logs are bundled. The automatic rangefinder housing/icon are original assets.

[Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods.](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6)
Updated addon identifiers use the neutral naming convention. The shared API, Hydropneumatic and Mast retain legacy compatibility IDs in this coordinated stage; namespace migration is not yet complete.
