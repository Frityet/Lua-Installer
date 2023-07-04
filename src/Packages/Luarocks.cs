using System.Formats.Tar;
using System.IO.Compression;
using LuaInstaller;

namespace LuaInstaller.Packages;

using static Log;

public class Luarocks : Package
{
    public override string Name => "Luarocks";
    public const string BASE_URL = "https://luarocks.org/releases/luarocks-{0}.{1}.{2}.tar.gz";

    public Luarocks((int major, int minor, int patch) version)
        : base(new Version(Major: version.major, Minor: version.minor, Patch: version.patch,
                           URLFormat: BASE_URL)) { }

    public override async Task Install(Path installDir, params string[]? additionalSearchPaths)
    {
        Info($"Extracting Luarocks to {installDir}...");
        installDir.CreateDirectory();
        await using Stream stream = await Download;
        await using var archive = new GZipStream(stream: stream, mode: CompressionMode.Decompress);
        await TarFile.ExtractToDirectoryAsync(source: archive, destinationDirectoryName: installDir, overwriteFiles: true);
    }
}
