namespace SprocketColdWarExpansionPack;

public static class ColdWarRules
{
    // Native TechDate supports year zero. System.DateTime does not.
    public static int CalendarKey(int year, int month, int day)
    {
        if (year < 0 || year > 9999 || month < 1 || month > 12 || day < 1 ||
            day > DateTime.DaysInMonth(year == 0 ? 400 : year, month)) return -1;
        return year * 10000 + month * 100 + day;
    }
    public static int ConfirmLastEra(ReadOnlySpan<int> starts)
    {
        if (starts.IsEmpty) return -1;
        for (var i = 0; i < starts.Length; i++)
            if (starts[i] < 0 || starts[i] >= 99991231 ||
                (i > 0 && starts[i] <= starts[i - 1])) return -1;
        return starts.Length - 1;
    }
    public static bool RecognizeLastEraSentinel(bool enabled, bool isExactMaximumDate,
        int requestedIndex, ReadOnlySpan<int> starts)
    {
        var last = ConfirmLastEra(starts);
        return enabled && isExactMaximumDate && last >= 0 && requestedIndex == last;
    }
    public static int ConfirmLastEra(ReadOnlySpan<DateTime> starts)
    {
        if (starts.IsEmpty) return -1;
        for (var i = 0; i < starts.Length; i++)
            if (starts[i].Date == DateTime.MaxValue.Date ||
                (i > 0 && starts[i].Date <= starts[i - 1].Date)) return -1;
        return starts.Length - 1;
    }
    public static bool RecognizeLastEraSentinel(bool enabled, bool isExactMaximumDate,
        int requestedIndex, ReadOnlySpan<DateTime> starts)
    {
        var last = ConfirmLastEra(starts);
        return enabled && isExactMaximumDate && last >= 0 && requestedIndex == last;
    }
}
