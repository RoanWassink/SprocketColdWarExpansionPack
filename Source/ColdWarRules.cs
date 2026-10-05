namespace SprocketColdWarExpansionPack;

public static class ColdWarRules
{
    public const string NativeEraStart = "1945.09.03";
    public const string TechnologyHorizon = "1991.12.31";
    public const float EngineTechnologyFactor = 2.25f;
    public const float EngineTorqueCoefficient = 1.15f;
    public const float EngineCostMultiplier = 1.60f;
    public static readonly DateTime ModernStart = new(1945, 9, 3);
    public static readonly DateTime Horizon = new(1991, 12, 31);
    public static int ConfirmLastModernEra(ReadOnlySpan<DateTime> starts)
    {
        if (starts.IsEmpty) return -1;
        for (var i = 0; i < starts.Length; i++)
            if (starts[i].Date == DateTime.MaxValue.Date || (i > 0 && starts[i].Date <= starts[i - 1].Date)) return -1;
        return starts[^1].Date >= ModernStart ? starts.Length - 1 : -1;
    }
    public static DateTime ResolveTechnologyDate(DateTime date, ReadOnlySpan<DateTime> starts)
    {
        date = date.Date;
        if (date == DateTime.MaxValue.Date)
        {
            var last = ConfirmLastModernEra(starts);
            return last < 0 ? date : (starts[last].Date > Horizon ? starts[last].Date : Horizon);
        }
        return date >= ModernStart && date < Horizon ? Horizon : date;
    }
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
