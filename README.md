# Sprocket Cold War Expansion Pack

**[Download the full pack 0.3.1](https://github.com/RoanWassink/SprocketColdWarExpansionPack/releases/tag/v0.3.1)** — beta for Sprocket 0.2.55.5, Windows x64 and BepInEx 6 IL2CPP 6.0.0-be.788.

Build and test Cold War vehicles with eleven coordinated modules. The full pack includes the core and shared APIs. The separate **core-only download remains 0.2.0** and does not contain these new gameplay features. Install the [Sprocket Mod Loader](https://github.com/Hans21223/Sprocket-Mod-Loader) separately. GitHub Code > Download ZIP is source code.

## New in 0.3.1

- **Stronger full-calibre recoil:** HE, APHE and other non-rocket full-bore profiles now retain at least the native recoil of the same cannon and propellant charge. Penetration and damage balance are unchanged. APFSDS and ATGM recoil remain unchanged.
- **Cleaner damage feed:** crew and component messages report direct projectile and spall damage. Repeated messages from ongoing fires are excluded, and repeated hits on the same component within one shot are combined. Penetration and ERA activation remain visible.

## Features — create, protect and test

| New feature | What you can do |
|---|---|
| **In-game shell editor** | Add, duplicate and edit shared shells, then save and refresh without restarting. |
| **Modular ammunition** | Choose supported penetrator, payload, guidance and motor modules to build your own shell or missile. |
| **In-game material editor** | Create materials and choose a supported special behaviour, including NERA and ERA. Save refreshes the material and armour response data. |
| **Placeable ERA** | Fit Kontakt-1, Kontakt-5, Relikt, Nizh and Duplet modules with distinct protection presets. Activated sections become spent and their active visual disappears. |
| **Turret and hull ERA variants** | Use slimmer turret plates and an elongated, gently bowed Duplet hull variant with three independently consumed zones. ERA models use vehicle paint. |
| **On-screen damage feed** | Enable a Play-mode feed showing penetration, remaining penetration, ERA activation and direct crew/component damage. |
| **Wire-guided missile visuals** | Use a TOW-inspired example; detached cable falls and settles instead of hanging in the air. |
| **Chemical ammunition corrections** | HEAT and HESH keep their configured penetration budget across flight distance; impact angle and armour spacing still matter. |
| **TPD-K1 gunner's sight** | Fit the two-colour blue-green/amber optic with an integrated manual laser rangefinder. Updated sight/FCS models correct orientation and surface issues. |
| **Visible carousel ammunition** | The static Russian-style carousel model displays the native magazine's remaining stock. |
| **Assisted loader** | A crew-operated loading aid gives more help with heavy, long ammunition. Light ammunition can be faster to load by hand. A crew badge distinguishes its icon. |
| **Shared JSON editor framework** | Shell and material editors share a reusable UI; other mods can supply their own fields, validation and refresh logic. |

These are gameplay models, not manufacturer-certified armour or weapon specifications. The carousel model is static. ERA does not simulate sympathetic detonation or tandem-warhead defeat; the Duplet hull's three zones are a gameplay partition. Damage messages report detected events and may not describe every fragment or component hit.

## Included modules

| Module | Version |
|---|---|
| Cold War Core | 0.2.0 |
| JSON Editor | 0.1.0 |
| Shell Selector | 0.13.2 |
| Material Selector | 0.5.0 |
| Thermal Sight | 0.2.7 |
| Carousel Autoloader | 0.2.14 |
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
4. For a manual install, merge **Payload/BepInEx** and **Payload/Sprocket_Data** into the folder containing Sprocket.exe. Replace matching DLLs/assets and retain one copy of each plugin. Never replace the entire BepInEx folder. Preserve existing config/catalogue files and customized native data. Copy missing defaults only. When updating manually, merge missing response recipes and ERA binding routes as described in Material Selector’s guide; do not replace your custom catalogue.
5. Copy the new `sprocketBustleAutoloaderPart.json`, then back up/remove the exact older `roanBustleAutoloaderPart.json` from Parts. The part's GUID is unchanged; do not load both definitions. The installer handles the known original file.
6. Start Sprocket. Review the updated module settings and your customized technology dates.

Existing settings take precedence. The updated modules copy their previous CFG only when the neutral CFG is absent, retaining the original for rollback. Thermal controls require the included API 0.1.6. Do not install private API copies alongside it. Existing keybind choices, profile IDs and material IDs are retained. Back up vehicles: new saves use neutral keys that older plugins may not read.

Fresh pack defaults enable armour responses and automatic ATGM-box feeding. The installer appends missing armour recipes and ERA binding routes while preserving existing settings and recipes. Conflicting bindings stop the preflight before writes. For an update from 0.1.1, enable `AutomaticAmmoBox = true` in `[ATGM Launcher Tests]` in `BepInEx/config/sprocket.shellselector.cfg` if you want the box to load automatically; restart. `InitialReadyMissile` controls the first missile and `OpticalSightDirection` controls the optional dedicated-launcher sight initialization. A gunner and a matching SACLOS/MCLOS profile remain necessary; Vanilla ammunition is not a ready guided missile.

## Using the additions

**ATGM:** place a launcher, select SACLOS or MCLOS, assign its gunner and choose a fire group. It begins each new Play session with one finite missile. Put a compatible ammo box within its approximately 2 m feed reach for reserve loading, with matching ammunition/calibre. Empty reserves do not refill magically. Launcher clearance and optical alignment still follow limitations described in Shell Selector's README.

**FCS and thermal:** place the FCS near the gunner and link external sights in the inspector. One FCS can serve several sights with no sight-to-FCS distance limit. The gunner's normal operating reach still applies at the FCS. Select the thermal profile on the sight itself. Configure Thermal / Toggle, Reload profiles and Measure range through Settings/keybinds; measure starts unbound. A fitted rangefinder serves any active sight on the vehicle. The automatic laser uses shell ballistics to set range.

**Stabilization:** select an elevation drive and open Stabilization drive setup. Strength uses a compact display scale; turret Torque and Ratio use native drive controls. More torque improves acceleration and holding strength, while a lower ratio increases top speed. Balance, crew, native mass/cost and gearing still matter. This tunes native tracking; it does not guarantee perfect aim over every bump. Default availability starts on 3 September 1945.

**Armour:** hover Protection for concise strengths, reaction/thickness limits and tradeoffs. Passive armour and reactive recipes differ. Extra reactions require the enabled shared catalogue and paired Shell/Material modules. The new placeable presets have distinct protection recipes; see the material editor and tooltips for their conditions.

## Customize and troubleshoot

Keep `BepInEx/config/sprocket.shellselector.shells.json`, `sprocket.armour.responses.json`, `sprocket.keybinds.json`, and `BepInEx/plugins/SprocketThermalSight/thermal-models.json`. See module docs for valid examples, ranges and reload controls. Edit native Era/Technology JSON with the game closed and restart. Availability follows the actual vehicle technology/date context; custom dates do not require a fixed era name. The core-only download has editable engine/cannon/era templates with installation instructions.

If a module is absent, inspect BepInEx/LogOutput.log for missing dependencies or duplicate DLLs. Blank icons/models indicate missing asset/native-part files. If the installer preserves a customized native definition, review that file before changing its date/properties. The pack does not install or update the loader. Smoke is visual smoke; it does not promise AI or thermal occlusion. Thermal imagery and armour responses are gameplay approximations.

## Rollback or remove

The installer writes a backup journal. Use `./Restore-Pack.ps1 -BackupDir 'C:/path/to/backup' -GameDir 'C:/path/to/Sprocket'` to preview rollback, then add `-Apply`. Restore pre-update vehicle copies when reverting saved-key changes. Untouched settings and saves are not rolled back. Catalogue files merged by this update are included in the backup journal; rollback restores their original content. Before uninstalling custom parts/materials, remove them from vehicles you intend to keep using. Remove only owned files and leave shared dependencies needed by other mods intact.

## Credits and support

**Wolfosito** created the T72 gunner sight and FCS models.

Sprocket is created by Hamish. BepInEx, Harmony and Il2CppInterop provide the framework. Mod work uses AI assistance. Module licenses and asset credits are included in Docs; no game binaries, loader, generated interop/cache or private saves/logs are bundled. The automatic rangefinder housing/icon are original assets.

[Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods.](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6)
Updated addon identifiers use the neutral naming convention. The shared API, Hydropneumatic and Mast retain legacy compatibility IDs in this coordinated stage; namespace migration is not yet complete.
