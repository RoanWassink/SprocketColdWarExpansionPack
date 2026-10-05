using BepInEx;
using BepInEx.Logging;
using BepInEx.Unity.IL2CPP;
using HarmonyLib;
using Il2CppInterop.Runtime.InteropTypes.Arrays;
using Sprocket.TechTrees;
using Sprocket.Vehicles;
using Sprocket.Vehicles.Engines;

namespace SprocketColdWarExpansionPack;

[BepInPlugin("nl.roan.sprocket.coldwarexpansionpack", "Sprocket Cold War Expansion Pack", "0.1.3")]
[BepInDependency("nl.roan.sprocket.keybinds", BepInDependency.DependencyFlags.SoftDependency)]
[BepInDependency("nl.roan.sprocket.shellselector", BepInDependency.DependencyFlags.SoftDependency)]
[BepInDependency("nl.roan.sprocket.materialselector", BepInDependency.DependencyFlags.SoftDependency)]
[BepInDependency("nl.roan.sprocket.carousel", BepInDependency.DependencyFlags.SoftDependency)]
[BepInDependency("nl.roan.sprocket.hydropneumatic", BepInDependency.DependencyFlags.SoftDependency)]
[BepInDependency("nl.roan.sprocket.telescopicmast", BepInDependency.DependencyFlags.SoftDependency)]
public sealed class Plugin : BasePlugin
{
    internal static ManualLogSource ModLog = null!;
    internal static bool Enabled;
    private Harmony? core;
    public override void Load()
    {
        ColdWarHooks.Reset();
        ModLog = Log;
        RegisterPackMetadata();
        Enabled = Config.Bind("General", "Enabled", true, "Enable Cold War era access, the full-period technology frame and the modern engine price adjustment. Bundled addons have their own settings.").Value;
        if (!Enabled) { Log.LogInfo("Expansion core disabled; addon modules remain independent."); return; }
        core = new Harmony("nl.roan.sprocket.coldwarexpansionpack");
        try { core.PatchAll(typeof(ColdWarHooks)); }
        catch { core.UnpatchSelf(); Enabled = false; throw; }
        Log.LogInfo("Review core 0.1.3 loaded: Coldwar playable with native era-array writeback and exact last-era date sentinel repair, technology horizon 1991-12-31; modern engine factor 2.25, torque 1.15, price x1.60. Native game validation required.");
    }
    public override bool Unload() { Enabled = false; ColdWarHooks.Reset(); core?.UnpatchSelf(); return true; }

    private void RegisterPackMetadata()
    {
        try
        {
            var api = AppDomain.CurrentDomain.GetAssemblies()
                .Select(a => a.GetType("SprocketKeybinds.Keybinds", false)).FirstOrDefault(t => t != null);
            var register = api?.GetMethod("RegisterPackMembership", new[] { typeof(string), typeof(string), typeof(string) });
            if (register == null) { Log.LogWarning("Keybinds pack metadata unavailable; author grouping remains available."); return; }
            foreach (var owner in new[] { "nl.roan.sprocket.hydropneumatic", "nl.roan.sprocket.telescopicmast", "nl.roan.sprocket.thermalsight", "sprocket.smokelaunchers" })
                register.Invoke(null, new object[] { owner, "sprocket.coldwarexpansionpack", "Cold War Expansion Pack" });
            Log.LogInfo("Explicit Cold War Expansion Pack keybind membership registered.");
        }
        catch (Exception ex) { Log.LogWarning("Optional keybind pack metadata failed: " + ex.GetType().Name); }
    }
}

internal static class ColdWarHooks
{
    private static bool dateLogged;
    private static bool sentinelLogged;
    private static bool sentinelFrameLogged;
    private static int confirmedLastColdWarIndex = -1;
    internal static void Reset() { confirmedLastColdWarIndex = -1; dateLogged = sentinelLogged = sentinelFrameLogged = false; }
    [HarmonyPostfix, HarmonyPatch(typeof(VehiclesMain), nameof(VehiclesMain.LoadEras), new[] { typeof(string) })]
    private static void MakePlayable(Il2CppReferenceArray<EraDefinition> __result)
    {
        confirmedLastColdWarIndex = -1;
        if (!Plugin.Enabled || __result == null) return;
        var found = false;
        for (var index = 0; index < __result.Length; index++)
        {
            var era = __result[index];
            if (era != null && string.Equals(era.Name, "Coldwar", StringComparison.OrdinalIgnoreCase))
            {
                // EraDefinition wraps an IL2CPP value type: mutate the boxed copy, then store it back.
                era.Playable = true;
                __result[index] = era;
                found = __result[index].Playable;
                if (found && index == __result.Length - 1 && string.Equals(__result[index].Name, "Coldwar", StringComparison.OrdinalIgnoreCase))
                    confirmedLastColdWarIndex = index;
                if (found) Plugin.ModLog.LogInfo("[CWEP] Native Coldwar era enabled; array writeback/readback verified; era boundary preserved.");
                else Plugin.ModLog.LogError("[CWEP] Coldwar era writeback failed; vehicle-editor availability is not verified.");
            }
        }
        if (!found) Plugin.ModLog.LogError("[CWEP] Native Coldwar era missing; restore the vanilla Eras files.");
    }
    // The native editor assigns GetEraEndDate(last) == MaxValue. Native IsInEra
    // excludes its end date, making that exact saved sentinel match no era.
    // Patch the shared native predicate so GetEra and GetEraIndex agree.
    [HarmonyPrefix, HarmonyPatch(typeof(VehicleClassifications), "IsInEra", new[] { typeof(TechDate), typeof(int) })]
    private static bool LastEraSentinel(TechDate __0, int __1, ref bool __result)
    {
        if (!Plugin.Enabled || confirmedLastColdWarIndex < 0) return true;
        if (!ColdWarRules.RecognizeLastEraSentinel(Plugin.Enabled, TechDate.Compare(__0, TechDate.MaxValue) == 0, __1, confirmedLastColdWarIndex)) return true;
        __result = true;
        if (!sentinelLogged) { sentinelLogged = true; Plugin.ModLog.LogInfo("[CWEP] Native last-era MaxValue sentinel recognized as Coldwar; saved vehicle date preserved."); }
        return false;
    }
    [HarmonyPrefix, HarmonyPatch(typeof(TechTreeLoader), nameof(TechTreeLoader.GetTechFrameAtDate), new[] { typeof(TechDate) })]
    private static void FullPeriodTechnology(ref TechDate __0)
    {
        if (!Plugin.Enabled) return;
        // Vehicle-local argument; no global player-era state and no mutation of saved blueprints.
        var first = TechDate.Parse(ColdWarRules.NativeEraStart);
        var last = TechDate.Parse(ColdWarRules.TechnologyHorizon);
        if (confirmedLastColdWarIndex >= 0 && TechDate.Compare(__0, TechDate.MaxValue) == 0)
        {
            __0 = last;
            if (!sentinelFrameLogged) { sentinelFrameLogged = true; Plugin.ModLog.LogInfo("[CWEP] MaxValue technology request normalized to 1991-12-31; saved vehicle date preserved."); }
            return;
        }
        if (TechDate.Compare(__0, first) < 0 || TechDate.Compare(__0, last) >= 0) return;
        __0 = last;
        if (!dateLogged) { dateLogged = true; Plugin.ModLog.LogInfo("[CWEP] Cold War tech frame expanded to 1991-12-31; earlier eras use native dates."); }
    }
    [HarmonyPostfix, HarmonyPatch(typeof(EngineBlueprint), "get_MaterialCost")]
    private static void ModernMaterialPrice(EngineBlueprint __instance, ref float __result) =>
        __result = ColdWarRules.EnginePrice(__result, __instance.TechnologyFactor, __instance.TorqueCoefficient);
    [HarmonyPostfix, HarmonyPatch(typeof(EngineBlueprint), "get_AssemblyCost")]
    private static void ModernAssemblyPrice(EngineBlueprint __instance, ref float __result) =>
        __result = ColdWarRules.EnginePrice(__result, __instance.TechnologyFactor, __instance.TorqueCoefficient);
}
