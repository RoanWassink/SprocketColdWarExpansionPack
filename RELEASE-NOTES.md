# Cold War Expansion Pack 0.3.0 — Beta

This update adds in-game ammunition and material editing, placeable reactive armour, damage feedback, and new loading and sight options.

## Changes since 0.2.0

| New feature | What you can do |
|---|---|
| **In-game shell editor** | Add, duplicate and edit shared shells, then save and refresh without restarting. |
| **Modular ammunition** | Choose supported penetrator, payload, guidance and motor modules to build your own shell or missile. |
| **In-game material editor** | Create materials and choose a supported special behaviour, including NERA and ERA. Save refreshes the material and armour response data. |
| **Placeable ERA** | Fit Kontakt-1, Kontakt-5, Relikt, Nizh and Duplet modules with distinct protection presets. Activated sections become spent and their active visual disappears. |
| **Turret and hull ERA variants** | Use slimmer turret plates and an elongated, gently bowed Duplet hull variant with three independently consumed zones. ERA models use vehicle paint. |
| **On-screen damage feed** | Enable a Play-mode feed showing penetration, remaining penetration, ERA activation and detected crew/component damage. |
| **Wire-guided missile visuals** | Use a TOW-inspired example; detached cable falls and settles instead of hanging in the air. |
| **Chemical ammunition corrections** | HEAT and HESH keep their configured penetration budget across flight distance; impact angle and armour spacing still matter. |
| **TPD-K1 gunner's sight** | Fit the two-colour blue-green/amber optic with an integrated manual laser rangefinder. Updated sight/FCS models correct orientation and surface issues. |
| **Visible carousel ammunition** | The static Russian-style carousel model displays the native magazine's remaining stock. |
| **Assisted loader** | A crew-operated loading aid gives more help with heavy, long ammunition. Light ammunition can be faster to load by hand. A crew badge distinguishes its icon. |
| **Shared JSON editor framework** | Shell and material editors share a reusable UI; other mods can supply their own fields, validation and refresh logic. |

These are gameplay models, not manufacturer-certified armour or weapon specifications. The carousel model is static. ERA does not simulate sympathetic detonation or tandem-warhead defeat; the Duplet hull's three zones are a gameplay partition. Damage messages report detected events and may not describe every fragment or component hit.

## Updating

Close Sprocket and use the included installer. Keep your customized shell, material, armour-response, keybind and thermal catalogues. The JSON Editor is included once in the full pack; standalone Shell and Material installations also need it. Material Selector 0.5.0 requires the matching Shell Selector 0.13.x for armour responses and ERA.

Existing vehicle part GUIDs are retained. Existing one-zone Duplet hull parts remain compatible; place the new three-zone variant to use independent zones. Do not install duplicate copies of plugin DLLs or native part definitions. See the README for fresh installation, updates and rollback.

**Wolfosito** created the T72 gunner sight and FCS models.

<!-- sp-compat {"hamish.sprocket": "0.2.55.5", "bepinex.bepinex": "6.0.0-be.788"} -->

[Support my ChatGPT budget and help me reverse engineer Sprocket to make more mods.](https://www.paypal.com/donate/?hosted_button_id=7PE3SDBETXFQ6)
