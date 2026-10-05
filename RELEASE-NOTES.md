<!-- sp-compat {"hamish.sprocket": "0.2.55.5", "bepinex.bepinex": "6.0.0-be.788"} -->

Take your designs into Cold War! This **v0.1.0 beta** brings the tested combination of advanced shells, reactive/composite armour, thermal sights, telescopic masts, hydropneumatic suspension, carousel/bustle autoloaders and smoke launchers into one download.

## What changes for you

- Select Cold War to access advanced shells/materials. WWII stock HEAT is recalibrated; custom profiles and saved bindings are preserved.
- Fit NERA, light ERA or heavier Kontakt-5-inspired ERA, with finite shared HEAT/APFSDS cells and clear weight/cost tradeoffs. Protection is a gameplay approximation, not exact historical performance.
- Fire three smoke grenades per bank, with louder launch and individual ignition sounds. A new Play session reloads the banks. Smoke is visual only: it does not block AI or thermal vision.
- Rebind Hydro, Mast, Thermal and Smoke in one author/pack-grouped Mod keybinds menu. The shared API is included once.
- Thermal is restricted to Cold War, retains per-sight profiles, and includes the rendering repair. Bustle loading uses the updated Howden recording.

## Install/update

Requires **Sprocket 0.2.55.5, Windows x64 and an already-working Sprocket Mod Loader / BepInEx 6 IL2CPP 6.0.0-be.788 setup**. **Loader not included. Quality of Life not required.**

Close the game, back up saves, and merge the folders **inside Payload** into the directory containing Sprocket.exe. Preserve existing configs, thermal-models.json and WAV overrides. Updating an existing armour catalogue additionally requires the supplied **Merge-HeavyEra.ps1 -Apply** after installing the matching DLLs; it adds only the new entry and preserves custom data. See README for manual alternatives and rollback.

The separate core-only ZIP is for users who want Cold War availability without the full pack. Individual plugin releases use the same DLL files as this pack; dependencies still apply. There is no automatic updater in this release.

[Installation, controls, examples, FAQ and individual download links](https://github.com/RoanWassink/SprocketColdWarExpansionPack#readme).

[Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6).
[Separate loader installation](https://github.com/Hans21223/Sprocket-Mod-Loader).

