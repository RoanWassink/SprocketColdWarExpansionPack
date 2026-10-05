using SprocketColdWarExpansionPack;
var count = 0;
void Check(bool result, string description) { count++; if (!result) throw new Exception(description); }
var floor = new DateTime(1945, 9, 3);
var horizon = new DateTime(1991, 12, 31);
var vanilla = new[] { new DateTime(1900,1,1), new DateTime(1918,1,1), new DateTime(1939,9,1), floor };
Check(ColdWarRules.ConfirmLastModernEra(vanilla) == 3, "vanilla final era");
Check(ColdWarRules.ConfirmLastModernEra(Array.Empty<DateTime>()) == -1, "empty metadata");
foreach (var invalid in new[] {
    new[] { floor, floor }, new[] { floor, new DateTime(1900,1,1) },
    new[] { floor, DateTime.MaxValue }, new[] { DateTime.MaxValue },
    new[] { floor.AddDays(-1) }, new[] { new DateTime(1900,1,1), new DateTime(1939,9,1) } })
{
    Check(ColdWarRules.ConfirmLastModernEra(invalid) == -1, "invalid/early timeline rejected");
    Check(ColdWarRules.ResolveTechnologyDate(DateTime.MaxValue, invalid) == DateTime.MaxValue.Date, "invalid/early sentinel unchanged");
}
foreach (var last in new[] { floor, floor.AddDays(1), horizon, new DateTime(1992,1,1), new DateTime(2100,1,1), new DateTime(3000,1,1), new DateTime(9999,12,30) })
{
    var starts = new[] { new DateTime(1900,1,1), last };
    Check(ColdWarRules.ConfirmLastModernEra(starts) == 1, "modern arbitrary final start confirmed");
    Check(ColdWarRules.ResolveTechnologyDate(DateTime.MaxValue, starts) == (last > horizon ? last : horizon), "future final start preserved");
    Check(ColdWarRules.RecognizeLastEraSentinel(true, true, 1, ColdWarRules.ConfirmLastModernEra(starts)), "last sentinel classified");
    Check(!ColdWarRules.RecognizeLastEraSentinel(true, true, 0, 1), "earlier index unchanged");
}
Check(!ColdWarRules.RecognizeLastEraSentinel(false, true, 3, 3), "disabled");
Check(!ColdWarRules.RecognizeLastEraSentinel(true, false, 3, 3), "finite date predicate unchanged");
Check(!ColdWarRules.RecognizeLastEraSentinel(true, true, -1, -1), "unconfirmed");
foreach (var date in new[] { new DateTime(1900,1,1), new DateTime(1939,9,1), floor.AddDays(-1), floor, new DateTime(1960,1,1), horizon.AddDays(-1), horizon, new DateTime(2100,1,1), new DateTime(3000,1,1) })
{
    var expected = date >= floor && date < horizon ? horizon : date;
    Check(ColdWarRules.ResolveTechnologyDate(date, vanilla) == expected, "finite technology behavior retained");
    Check(ColdWarRules.ResolveTechnologyDate(date, Array.Empty<DateTime>()) == expected, "finite date independent of sentinel validation");
}
Check(ColdWarRules.ReferenceMaxRpm(3, 2.25) == 4500, "accepted modern RPM calibration");
Check(ColdWarRules.ReferenceMaxRpm(3, 1) == 3400, "native comparator RPM");
Check(ColdWarRules.EnginePrice(100, 2.25f, 1.15f) == 160, "modern cost retained");
Check(ColdWarRules.EnginePrice(100, 1, 1) == 100, "earlier engine price unchanged");
Check(ColdWarRules.EnginePrice(-1, 2.25f, 1.15f) == -1, "invalid cost unchanged");
Check(!ColdWarRules.IsColdWarEngine(float.NaN, 1.15f), "nonfinite calibration rejected");
Console.WriteLine($"PASS {count} core date and calibration checks");
