<!-- sp-compat {"hamish.sprocket": "0.2.55.5", "bepinex.bepinex": "6.0.0-be.788"} -->

## Which ZIP should I download?

**Choose ONE ZIP, not both. Most users should download the full Expansion Pack.**

- **SprocketColdWarExpansionPack-v0.1.0.zip — FULL PACK (recommended):** includes the Cold War Core, Keybinds API and all seven gameplay plugins. You do not need the separate Core ZIP or a separate API download.
- **SprocketColdWarCore-v0.1.3.zip — CORE ONLY:** enables the Cold War era and provides its cannon/engine Technology definitions. It does not include Shell Selector, Material Selector, smoke, sights, suspension, autoloaders or the Keybinds API. Choose this only if you want to install individual plugins yourself, following their dependency requirements.

The pack version is 0.1.0; its included Core module has its own version, 0.1.3. These are separate version numbers, not competing downloads. **Neither ZIP includes the mod loader.**



**Required dependency: [Sprocket Keybinds API 0.1.5](https://github.com/RoanWassink/SprocketKeybinds/releases/tag/v0.1.5). Hydropneumatic, Telescopic Mast, Thermal Sight and Smoke Launchers will not load without it. The full pack includes it: keep its DLL installed. For separate plugin downloads, install the API ZIP once, merging its BepInEx folder into your game folder.**

Take your designs into Cold War! This **v0.1.0 beta** brings the tested combination of advanced shells, reactive/composite armour, thermal sights, telescopic masts, hydropneumatic suspension, carousel/bustle autoloaders and smoke launchers into one download.

## What’s included

- **Advanced ammunition:** select Cold War to access APFSDS and guided missiles, alongside ammunition suited to earlier eras.
- **Composite and reactive armour:** build with NERA, light ERA or heavier Kontakt-5-inspired ERA. NERA offers reusable protection against HEAT; ERA has one-use cells, with heavy ERA also offering angle-dependent protection against APFSDS. Weight, cost and passive protection still matter after an ERA cell is spent.
- **Smoke launchers:** deploy three grenades per bank to form a smoke screen, complete with launch and individual ignition sounds. Each bank has one salvo per Play session; starting a new session reloads it. Smoke is visual only: it does not block AI or thermal vision.
- **Hydropneumatic suspension:** raise or lower your hull and lean forward or backward while driving, with optional independent front/rear controls.
- **Telescopic masts:** raise and lower attached sights or equipment on an extendable mast.
- **Thermal sights:** choose a monochrome profile for each sight and save it with your vehicle. Thermal sights are available in Cold War.
- **Carousel and bustle autoloaders:** fit an automatic loading system with finite ammunition, capacity determined by your design, and mechanical loading audio.
- **Shared keybinds:** configure suspension, mast, thermal and smoke controls in one Mod keybinds menu, grouped by author or pack. The required keybind API is included.

**This is a beta.** Back up your vehicle saves before experimenting. Armour protection is a gameplay approximation, not a promise of exact historical performance. The pack makes its advanced equipment available throughout Cold War rather than reproducing each item’s historical introduction date.

## Install/update

Requires **Sprocket 0.2.55.5, Windows x64 and an already-working Sprocket Mod Loader / BepInEx 6 IL2CPP 6.0.0-be.788 setup**. **Loader not included. Quality of Life not required.**

Close the game, back up saves, and merge the folders **inside Payload** into the directory containing Sprocket.exe. Preserve existing configs, thermal-models.json and WAV overrides. Updating an existing armour catalogue additionally requires the supplied **Merge-HeavyEra.ps1 -Apply** after installing the matching DLLs; it adds only the new entry and preserves custom data. See README for manual alternatives and rollback.

The separate core-only ZIP is for users who want Cold War availability without the full pack. Individual plugin releases use the same DLL files as this pack; dependencies still apply. There is no automatic updater in this release.

[Installation, controls, examples, FAQ and individual download links](https://github.com/RoanWassink/SprocketColdWarExpansionPack#readme).

[Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6).
[Separate loader installation](https://github.com/Hans21223/Sprocket-Mod-Loader).

