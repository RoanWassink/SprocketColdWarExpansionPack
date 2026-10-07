namespace SprocketColdWarExpansionPack;

internal static class CoreConfigMigration
{
    internal const string CurrentName = "sprocket.coldwarexpansionpack.cfg";
    internal const string LegacyName = "nl.roan.sprocket.coldwarexpansionpack.cfg";

    internal static bool TryMigrate(string directory)
    {
        var source = Path.Combine(directory, LegacyName);
        var destination = Path.Combine(directory, CurrentName);
        if (!File.Exists(source)) return false;
        if (File.Exists(destination)) return false;
        var bytes = File.ReadAllBytes(source);
        var temporary = destination + ".migration-" + Guid.NewGuid().ToString("N");
        try
        {
            File.WriteAllBytes(temporary, bytes);
            // Keep the original legacy file intact as the recovery copy.
            return TryCommit(temporary, destination);
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
    }

    internal static bool TryCommit(string temporary, string destination)
    {
        try { File.Move(temporary, destination); return true; }
        catch (IOException) when (File.Exists(destination)) { return false; }
    }
}
