# Sprocket Cold War Expansion Pack 0.3.1 — beta

Changes since the public 0.3.0 release:

- **Stronger full-calibre recoil:** HE, APHE and other non-rocket full-bore profiles now retain at least the native recoil of the same cannon and propellant charge. Penetration and damage balance are unchanged. APFSDS and ATGM recoil remain unchanged.
- **Cleaner damage feed:** crew and component messages report direct projectile and spall damage. Repeated messages from ongoing fires are excluded, and repeated hits on the same component within one shot are combined. Penetration and ERA activation remain visible.

The full pack includes **Shell Selector 0.13.2**. All other included modules retain their 0.3.0 versions, including **Material Selector 0.5.0**, **JSON Editor 0.1.0** and **Stabilization 0.1.0**. The separate core-only download remains **0.2.0**.

## Requirements and update

For Sprocket **0.2.55.5**, Windows x64 and **BepInEx 6 IL2CPP 6.0.0-be.788**. Install the [Sprocket Mod Loader](https://github.com/Hans21223/Sprocket-Mod-Loader) separately.

Close the game and run the included Install-Pack.ps1 as described in the README. The installer verifies the package, creates backups and preserves existing settings and custom catalogues. A manual update from 0.3.0 only needs the new SprocketShellSelector.dll; keep the existing Material Selector and JSON Editor DLLs. Existing shell IDs and vehicle selections remain compatible. No configuration changes are required.

[Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods.](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6)

<!-- sp-compat {"hamish.sprocket": "0.2.55.5", "bepinex.bepinex": "6.0.0-be.788"} -->
