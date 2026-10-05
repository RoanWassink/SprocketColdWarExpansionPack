# Sprocket Cold War Expansion Pack

**[Download the FULL PACK — v0.1.1 beta](https://github.com/RoanWassink/SprocketColdWarExpansionPack/releases/download/v0.1.1/SprocketColdWarExpansionPack-v0.1.1.zip)** · [Release page and all files](https://github.com/RoanWassink/SprocketColdWarExpansionPack/releases/tag/v0.1.1)

Includes Core, Keybinds API and all gameplay plugins. **Download this one ZIP for the complete pack.** Install the mod loader separately first. Use the release ZIP rather than GitHub’s Code > Download ZIP, which contains source code.



## Which ZIP should I download?

**Choose ONE ZIP, not both. Most users should download the full Expansion Pack.**

- **SprocketColdWarExpansionPack-v0.1.1.zip — FULL PACK (recommended):** includes the Cold War Core, Keybinds API and all seven gameplay plugins. You do not need the separate Core ZIP or a separate API download.
- **SprocketColdWarCore-v0.1.4.zip — CORE ONLY:** enables the Cold War era and provides its cannon/engine Technology definitions. It does not include Shell Selector, Material Selector, smoke, sights, suspension, autoloaders or the Keybinds API. Choose this only if you want to install individual plugins yourself, following their dependency requirements.

The pack version is 0.1.1; its included Core module has its own version, 0.1.4. These are separate version numbers, not competing downloads. **Neither ZIP includes the mod loader.**


**Required dependency: [Sprocket Keybinds API 0.1.5](https://github.com/RoanWassink/SprocketKeybinds/releases/tag/v0.1.5). Hydropneumatic, Telescopic Mast, Thermal Sight and Smoke Launchers will not load without it. The full pack includes it: keep its DLL installed. For separate plugin downloads, install the API ZIP once, merging its BepInEx folder into your game folder.**

Build beyond WWII with **guided missiles, APFSDS, reactive/composite armour, thermal sights, telescopic masts, adjustable suspension, autoloaders and tri-smoke launchers** in one coordinated download.

**v0.1.1 beta.** Repairs active armour responses in Sample and Play, including Heavy ERA cell consumption/reset. Modern shell, armour and thermal availability follows valid design dates from **3 September 1945**, including custom era names. The core also repairs the final custom era classification. The creator confirmed Heavy ERA/HEAT behavior; native custom-era testing remains pending. Loader installed separately.

## Requirements — loader not included

- Sprocket **0.2.55.5**, Windows x64, Unity 6000.3.21f1.
- An already-working **Sprocket Mod Loader / BepInEx 6 IL2CPP 6.0.0-be.788** setup with its runtime and generated interop. Run the loader once and close the game before installing mods. Stock BepInEx alone is not claimed equivalent to the Sprocket-specific setup used for testing.
- No loader, MelonLoader bridge, game DLLs, generated interop/cache or third-party mod manager is included. Install your loader separately before using this download. The creator's supplied Python ModManager zip is being kept for later bootstrap research, not redistributed as part of this release.
- Quality of Life is **not required and not included**.

## Install

1. Back up your vehicle saves. Close Sprocket.
2. Download **SprocketColdWarExpansionPack-v0.1.1.zip** from [v0.1.1](https://github.com/RoanWassink/SprocketColdWarExpansionPack/releases/tag/v0.1.1).
3. In Steam, right-click Sprocket > Manage > Browse local files. The target is the folder containing Sprocket.exe.
4. Open the ZIP's **Payload** folder. Copy its **BepInEx** and **Sprocket_Data** folders into the game folder and merge them. Copy the folders inside Payload, not the outer ZIP/pack folder.
5. Keep one copy of each plugin. If updating, replace the matching DLLs/assets, but **preserve existing configs, thermal-models.json and WAV overrides**. Back up native part/Technology edits before replacing matching files.
6. For an existing armour catalogue, update Material and Shell together, then run **Merge-HeavyEra.ps1 -Apply** from the extracted pack with the game closed. It verifies the exact paired DLLs, backs up the catalogue, adds only the heavy ERA entry and refuses conflicting custom heavy entries. Fresh installs already contain that recipe. Optional armour responses remain disabled if your existing root enabled setting is false; the script does not change it. See [armour setup](ARMOUR-RESPONSES.md).
7. Start Sprocket. Select **Cold War** in the vehicle editor. Open Settings > Controls/keybinds > Mod keybinds > Open to configure actions.

For a scripted install, use **Install-Pack.ps1 -Apply**, then **Merge-HeavyEra.ps1 -Apply**. The installer first verifies the game/payload, requires the game closed, backs up matching files and preserves existing configs. Its foreign/duplicate-plugin check can reject an installation containing other mods; use the manual procedure and inspect compatibility rather than deleting other mods to satisfy it. Never use -UsePackDefaults unless you intend to back up and replace personalized configuration. No PowerShell is required for a clean manual installation.

## What you can do

- **Cold War designs:** advanced profiles and materials are available in their intended era. The pack makes its complete Cold War repertoire available from the era start; individual dates are not claims about historical service entry. The core recognizes the game's last-era maximum-date selection without rewriting the saved vehicle date.
- **Shells and armour:** choose shell profiles on cannons and materials on plates. WWII retains AP/HE and era-eligible APHE/HEAT; HESH, APFSDS and ATGM require a valid postwar design date from 3 September 1945. Stock WWII HEAT is recalibrated; custom profiles are retained. NERA, light ERA, heavy ERA and composite/textolite have distinct threat/angle interactions and passive weight/cost tradeoffs.
- **Heavy ERA:** a Kontakt-5-inspired recipe against HEAT and APFSDS. Start with 70 mm normal thickness and 45-degree impacts. Its valid range is 60–80 mm; HEAT and APFSDS share a one-use 25 cm cell. Once spent, that cell supplies passive protection only. The effect is not tandem-charge, real rod fracture or flying-plate simulation.
- **Smoke:** attach the tri-smoke launcher and use Fire smoke salvo (default G). Three grenades per bank form a visual screen; each new Play session reloads the bank. Launch and ignition sounds are distinct. **Smoke does not block AI vision or thermal sights.** The stock part icon is used. Find it inside crew > equipment at the end.
- **Thermal:** right-click the configurable sight to select a saved profile. Toggle/Reload are factory N/F8 and configurable. Thermal is Cold War-only; imported earlier-era sights keep their identity and physical mass/cost but use ordinary view. Five monochrome defaults; optional personal palettes.
- **Mast:** assemble Telescope Base + Telescope Part, attach equipment to the moving part and use Mast Raise/Lower (Insert/Delete).
- **Hydropneumatic:** adjust ride height/pitch with Raise/Lower, Tilt and Neutral; optional independent front/rear mode. Actual motion depends on geometry, weight and terrain.
- **Autoloaders:** fit a carousel to a basket or use a bustle loader. Magazines are finite and ammo-fit/crew replenishment rules still apply. Bustle loading uses the updated Howden recording supplied by Cheeki. 

## Pinned modules and separate downloads

| Module | Version | Individual release |
|---|---|---|
| Cold War core | 0.1.4 | Core-only ZIP on [this pack release](https://github.com/RoanWassink/SprocketColdWarExpansionPack/releases/tag/v0.1.1) |
| Keybinds | 0.1.5 | [Download](https://github.com/RoanWassink/SprocketKeybinds/releases/tag/v0.1.5) |
| Shell Selector | 0.12.4 | [Download](https://github.com/RoanWassink/SprocketShellSelector/releases/tag/v0.12.4) |
| Material Selector | 0.4.5 | [Download](https://github.com/RoanWassink/SprocketMaterialSelector/releases/tag/v0.4.5) |
| Smoke Launchers | 0.2.4 | [Download](https://github.com/RoanWassink/SprocketSmokeLaunchers/releases/tag/v0.2.4) |
| Hydropneumatic | 0.4.2 | [Download](https://github.com/RoanWassink/SprocketHydropneumatic/releases/tag/v0.4.2) |
| Telescopic Mast | 0.3.8 (postwar assets) | [Download](https://github.com/RoanWassink/SprocketTelescopicMast/releases/tag/v0.3.8-postwar.1) |
| Thermal Sight | 0.2.5 | [Download](https://github.com/RoanWassink/SprocketThermalSight/releases/tag/v0.2.5) |
| Carousel Autoloader | 0.2.11 | [Download](https://github.com/RoanWassink/SprocketCarouselAutoloader/releases/tag/v0.2.11) |

The pack uses the **same DLL bytes** as those releases. Shared Keybinds is installed once, not privately bundled into every mod. Hydro, Mast, Thermal and Smoke will not load without a compatible Keybinds API. Shell, Material and Autoloader do not require it. The core can run without Keybinds; its optional pack-group display integration then has no shared panel to use.

The **core-only ZIP** enables the Cold War era and supplies the pack's cannon/engine Technology definitions. It contains no other gameplay plugin or API. Advanced standalone mods still need their own dependencies. Install its BepInEx/Sprocket_Data folders into the game root with the game closed; preserve an existing core CFG.

## Adding shells, materials or sight profiles

Use [armour configuration/examples](ARMOUR-RESPONSES.md), [Shell custom profiles](https://github.com/RoanWassink/SprocketShellSelector/blob/main/CUSTOM-SHELLS.md) and [Thermal custom profiles](https://github.com/RoanWassink/SprocketThermalSight/blob/main/CUSTOMIZATION.md). Use unique IDs, retain IDs referenced by saves, and edit with backups. Unknown fields, invalid JSON or incompatible older consumers can disable an optional module. Catalogue changes require a full restart; only the thermal profile reload action supports its documented live reload. The pack does not automatically merge every new future recipe into custom files.

## Updates, rollback and uninstall

Individual updates are possible, but follow each release's dependency requirements. In particular, update heavy ERA's Material/Shell pair together. The manifest pins this release combination; mixing future versions is not a promise of compatibility. There is no automatic updater or GitHub-watching installer in v0.1.1.

For rollback restore backed-up DLLs/native assets **and** the pre-merge armour catalogue together. Keep personalized bindings/catalogues/WAV files unless intentionally restoring their backup. Before uninstalling, change vehicles to stock suspension/sights/materials, remove custom mast/smoke/bustle parts, disable carousel features, and save copies. Earlier-era imported parts are not automatically removed from saved designs. Preserve backups of vehicles using the pack.

## Troubleshooting and limits

- Game remains vanilla/no mod menu: verify loader startup in BepInEx/LogOutput.log; this ZIP cannot install or repair the loader.
- Hydro/Mast/Thermal/Smoke absent: check the single shared Keybinds DLL and dependency errors. A DLL alone cannot replace missing part/Technology definitions.
- Advanced shells/materials absent: choose a valid era from 3 September 1945, install the updated core, keep matching part/Technology files and check the log's availability messages. Unsupported earlier-era profiles fall back to allowed behavior rather than granting modern shells.
- Material selectable but no reactive protection: check matching Shell/Material versions, catalogue enabled, IDs/passive properties, thickness and angle. A spent cell gives no further reactive benefit. A material-only install gives passive properties.
- No smoke sound: Audio/LaunchVolume controls both sounds; 0 mutes them. Smoke audio failure should not disable the launcher itself.
- For a crash, preserve BepInEx/LogOutput.log and Unity Player.log before another launch, and include game/mod versions and the action that triggered it in a GitHub issue.

Native protection/layer-order, cell lifecycle and visual behavior are gameplay approximations with unresolved edge cases. General gameplay testing does not establish exhaustive historical armour performance, equal-mass superiority in every geometry, or compatibility with every third-party mod. Back up your saves.

## Credits and support

Made with AI assistance. Own mod code/assets are MIT licensed. Native Sprocket mesh/icon resources are accessed from your installation; game binaries and generated caches are not distributed. No War Thunder audio/assets are used. [Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6).
## Where to get the separate loader

Use [Hans21223's Sprocket Mod Loader](https://github.com/Hans21223/Sprocket-Mod-Loader) and follow its [manual installation guide](https://github.com/Hans21223/Sprocket-Mod-Loader/blob/main/package/MANUAL-INSTALL.md) or its documented manager installation. That upstream project targets the tested Sprocket version and supplies the Sprocket-specific patch. These mod downloads do not install the loader. Follow one upstream loader method and its update/backup instructions; the creator's supplied ModManager archive is not redistributed here.

## Date-based availability in 0.1.1

Modern availability starts on **3 September 1945**, inclusive. Valid registered custom eras can use their own names and later dates, without a finite future cutoff. Earlier designs retain supported earlier-era features. The last-era date sentinel is resolved from the actual final era start; saved dates and era names are preserved. Invalid or unordered timelines fail closed. Native Technology requirements still apply. This shared availability policy is not a historical service-entry date for every part.

**Updating an existing pack:** close Sprocket, replace the matching DLLs and part files from Payload, and preserve your existing configs, thermal-models.json and WAV overrides. Update Shell and Material together. Existing response settings/recipes do not need new coefficients. Keep one Keybinds API DLL installed. Full pack contains the API; the core-only ZIP does not.

The impact lookup repair is shared by the armour recipes. Heavy ERA/HEAT Sample and live first-hit/spent-cell/new-Play behavior is confirmed; individual NERA, composite, textolite and APFSDS responses have not received equivalent native validation. Balance coefficients are unchanged. Custom-era date paths passed automatic checks; native custom-era placement/switching/save-load remains pending.

Mast part dates now use the same 1945 cutoff; its DLL stays 0.3.8. Smoke already used that date. Hydropneumatic 0.4.2, Carousel 0.2.11 and Keybinds 0.1.5 have no era-name gate blocking later designs; their accepted DLLs remain unchanged. This update does not introduce new earlier-era restrictions for those modules.
