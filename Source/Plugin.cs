using BepInEx;
using BepInEx.Logging;
using BepInEx.Unity.IL2CPP;
using HarmonyLib;
using Sprocket.TechTrees;
using Sprocket.Vehicles;

namespace SprocketColdWarExpansionPack;

[BepInPlugin("sprocket.coldwarexpansionpack", "Sprocket Cold War Expansion Pack", "0.2.0")]
[BepInDependency("nl.roan.sprocket.keybinds", BepInDependency.DependencyFlags.SoftDependency)]
public sealed class Plugin : BasePlugin
{
    internal static ManualLogSource ModLog = null!;
    internal static bool Enabled;
    private Harmony? core;
    public override void Load()
    {
        ModLog = Log;
        try
        {
            CoreConfigMigration.TryMigrate(Paths.ConfigPath);
            if (File.Exists(Config.ConfigFilePath)) Config.Reload();
        }
        catch (Exception ex)
        {
            // Do not accidentally enable a disabled installation after a failed migration.
            Log.LogError("Core configuration migration failed; boundary repair not started: " + ex.GetType().Name);
            return;
        }
        RegisterPackMetadata();
        Enabled = Config.Bind("General", "Enabled", true,
            "Enable the native final-era date boundary repair. Era access, technology, part dates and prices remain native data and calculations.").Value;
        if (!Enabled) { Log.LogInfo("Final-era boundary repair disabled; native data and addon modules remain independent."); return; }
        core = new Harmony("sprocket.coldwarexpansionpack");
        try { core.PatchAll(typeof(NativeEraBoundary)); }
        catch { core.UnpatchSelf(); Enabled = false; throw; }
        Log.LogInfo("Core 0.2.0: native Era/Technology/Part data authoritative; final-era MaxValue classification repair only. No era unlock, technology horizon or engine price override.");
    }
    public override bool Unload() { Enabled = false; core?.UnpatchSelf(); return true; }
    private void RegisterPackMetadata()
    {
        try
        {
            var api = AppDomain.CurrentDomain.GetAssemblies()
                .Select(a => a.GetType("SprocketKeybinds.Keybinds", false)).FirstOrDefault(t => t != null);
            var register = api?.GetMethod("RegisterPackMembership", new[] { typeof(string), typeof(string), typeof(string) });
            if (register == null) return;
            foreach (var owner in new[] { "nl.roan.sprocket.hydropneumatic", "nl.roan.sprocket.telescopicmast", "sprocket.thermalsight", "sprocket.smokelaunchers" })
                register.Invoke(null, new object[] { owner, "sprocket.coldwarexpansionpack", "Cold War Expansion Pack" });
        }
        catch (Exception ex) { Log.LogWarning("Optional keybind pack metadata failed: " + ex.GetType().Name); }
    }
}

internal static class NativeEraBoundary
{
    private static bool logged;
    [HarmonyPrefix, HarmonyPatch(typeof(VehicleClassifications), "IsInEra", new[] { typeof(TechDate), typeof(int) })]
    private static bool LastEraSentinel(TechDate __0, int __1, ref bool __result)
    {
        if (!Plugin.Enabled || TechDate.Compare(__0, TechDate.MaxValue) != 0) return true;
        try
        {
            // Read the registered timeline rather than cache a Coldwar name or fixed date.
            var eras = VehicleClassifications.eras;
            if (eras == null || eras.Length == 0 || __1 != eras.Length - 1) return true;
            var starts = new int[eras.Length];
            for (var i = 0; i < starts.Length; i++)
            {
                var era = eras[i];
                if (era == null) return true;
                var date = era.StartDate;
                starts[i] = ColdWarRules.CalendarKey(date.Year, date.Month, date.Day);
            }
            if (!ColdWarRules.RecognizeLastEraSentinel(Plugin.Enabled, true, __1, starts)) return true;
            __result = true;
            if (!logged) { logged = true; Plugin.ModLog.LogInfo("[CWEP] Exact MaxValue classified in the final native era; saved date and native technology request preserved."); }
            return false;
        }
        catch (Exception ex)
        {
            if (!logged) { logged = true; Plugin.ModLog.LogWarning("[CWEP] Native timeline unavailable; boundary repair skipped: " + ex.GetType().Name); }
            return true;
        }
    }
}
