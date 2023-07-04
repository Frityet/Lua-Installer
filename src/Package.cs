namespace LuaInstaller;

public abstract class Package
{
    public record struct Version(int Major, int Minor, int Patch, string URLFormat)
    {
        public Uri FullURL = new Uri(String.Format(format: URLFormat, Major, Minor, Patch));
        public readonly (int, int, int) AsTuple = (Major, Minor, Patch);
        public override string ToString() => $"{Major}.{Minor}.{Patch}";
    }

    public abstract string Name { get; }
    public Version CurrentVersion { get; }
    public Task<Stream> Download { get; }
    public bool Complete => Download.IsCompletedSuccessfully;

    private HttpClient _client;

    public Package(Version version)
    {
        CurrentVersion = version;
        _client = new HttpClient();
        Download = _client.GetStreamAsync(CurrentVersion.FullURL);
    }

    public abstract Task Install(Path installDir, params string[]? additionalSearchPaths);

    public override string ToString() => $"{Name} v{CurrentVersion} ({CurrentVersion.FullURL})";
}
