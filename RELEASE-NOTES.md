<!-- sp-compat {"hamish.sprocket": "0.2.55.5", "bepinex.bepinex": "6.0.0-be.788"} -->

## Important armour and custom-era update

**Beta v0.1.1.** Heavy ERA now applies its reaction correctly in both the armour simulator and live combat. A hit spends its 25 cm cell; starting Play again gives the new vehicle fresh cells. The shared impact lookup also serves the other supported armour recipes. Protection coefficients have not been increased.

Modern shells, armour and thermal sights now use valid design dates from **3 September 1945**, rather than requiring an era named Coldwar. Custom postwar/future eras are supported. The updated core repairs native classification of the final custom era. Saved dates, profile IDs and personalized settings are preserved.

Heavy ERA/HEAT simulator and live first-hit/spent-cell/Play-reset tests passed. Other armour reactions and native custom-era scenarios still need individual live validation; automatic date-policy checks passed.

## Which ZIP do I need?

- **SprocketColdWarExpansionPack-v0.1.1.zip:** the full pack, including core and the mandatory shared Keybinds API. Most users should choose this. **You do not need both ZIPs.**
- **SprocketColdWarCore-v0.1.4.zip:** only the era/core and its native Technology files, for users managing individual plugins themselves. No other gameplay plugin or Keybinds API is included.

Requires Sprocket 0.2.55.5 on Windows x64 and an already-working Sprocket Mod Loader / BepInEx 6 IL2CPP 6.0.0-be.788. **Loader not included. Quality of Life not required.**

## Fresh install or update

Close Sprocket and back up saves and mod files. From the full ZIP's **Payload** folder, merge **BepInEx** and **Sprocket_Data** into the folder containing Sprocket.exe. Replace matching DLLs/part files and keep one copy of each plugin. **Preserve existing configs, custom material/Technology edits, thermal-models.json and WAV overrides.** Never replace the entire BepInEx folder.

Already using individual plugins? The full ZIP supplies the coordinated versions and API; replace matching files and remove duplicate older DLL copies. Alternatively update Shell 0.12.4, Material 0.4.5, Thermal 0.2.5 and core 0.1.4 individually. Existing armour recipes need no coefficient changes; preserve whether your catalogue is enabled. Hydro, Mast, Thermal and Smoke require Keybinds; keep its DLL installed.

See the [README](https://github.com/RoanWassink/SprocketColdWarExpansionPack#readme) for controls, customization, troubleshooting and rollback.

[Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6).