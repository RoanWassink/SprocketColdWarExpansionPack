namespace SprocketColdWarExpansionPack;

public static class ColdWarRules
{
    public const string NativeEraStart = "1945.09.03";
    public const string TechnologyHorizon = "1991.12.31";
    public const float EngineTechnologyFactor = 2.25f;
    public const float EngineTorqueCoefficient = 1.15f;
    public const float EngineCostMultiplier = 1.60f;
    public static bool RecognizeLastEraSentinel(bool enabled, bool isExactMaximumDate, int requestedIndex, int confirmedLastColdWarIndex) =>
        enabled && isExactMaximumDate && confirmedLastColdWarIndex >= 0 && requestedIndex == confirmedLastColdWarIndex;
    public static bool IsColdWarEngine(float factor, float torque) =>
        float.IsFinite(factor) && float.IsFinite(torque) &&
        Math.Abs(factor - EngineTechnologyFactor) < .0001f && Math.Abs(torque - EngineTorqueCoefficient) < .0001f;
    public static float EnginePrice(float vanillaPrice, float factor, float torque) =>
        IsColdWarEngine(factor, torque) && float.IsFinite(vanillaPrice) && vanillaPrice >= 0
            ? vanillaPrice * EngineCostMultiplier : vanillaPrice;
    // Reference calculation from the verified native binary, not a replacement hook.
    // Cylinder volume is litres; the game truncates the result to UInt16.
    public static ushort ReferenceMaxRpm(double cylinderLitres, double technologyFactor)
    {
        if (!double.IsFinite(cylinderLitres) || cylinderLitres <= 0 || !double.IsFinite(technologyFactor) || technologyFactor < 0)
            throw new ArgumentOutOfRangeException(nameof(cylinderLitres));
        var rpm = (1200 + 2200 * Math.Sqrt(technologyFactor)) / Math.Pow(cylinderLitres / 3, .3);
        if (!double.IsFinite(rpm) || rpm > ushort.MaxValue) throw new ArgumentOutOfRangeException(nameof(cylinderLitres));
        return (ushort)rpm;
    }
}
