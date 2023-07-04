using System.Diagnostics;
using System.Runtime.InteropServices;

namespace LuaInstaller.Packages;

using static Log;

public class MinGW : Package
{
    public override string Name => "MinGW";
    public const string BASE_URL = "https://github.com/niXman/mingw-builds-binaries/releases/download/{0}.{1}.{2}-rt_v11-rev1/x86_64-{0}.{1}.{2}-release-posix-seh-msvcrt-rt_v11-rev1.7z";

    //https://github.com/niXman/mingw-builds-binaries/releases/download/13.1.0-rt_v11-rev1/x86_64-13.1.0-release-posix-seh-msvcrt-rt_v11-rev1.7z
    public MinGW((int major, int minor, int patch) version, bool useMSVCRT)
        : base(new Version(Major: version.major, Minor: version.minor, Patch: version.patch,
                           URLFormat: $"https://github.com/niXman/mingw-builds-binaries/releases/download/{{0}}.{{1}}.{{2}}-rt_v11-rev1/x86_64-{{0}}.{{1}}.{{2}}-release-posix-seh-{(useMSVCRT ? "msvcrt" : "ucrt")}-rt_v11-rev1.7z"))
    {}

    public override async Task Install(Path installDir, params string[]? _)
    {
        installDir.CreateDirectory();

        Stream dl = await Download;
        
        //Write the archive to disk
        Path outF = installDir/"mingw.7z";
        await using (var fs = new FileStream(path: outF, mode: FileMode.Create, access: FileAccess.Write))
            await dl.CopyToAsync(fs);
        
        Path sevenZipExe = Path.CurrentDirectory/"7zr.exe";
        if (!sevenZipExe.Exists)
            throw new FileNotFoundException("7zr.exe not found in current directory");

        //Just use 7zr.exe to extract the archive
        var sevenZip = new Process()
        {
            StartInfo =
            {
                UseShellExecute = false,
                RedirectStandardOutput = false,
                RedirectStandardError = true,
                CreateNoWindow = true,
            }
        };
        
        if (!RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            sevenZip.StartInfo.FileName = RuntimeInformation.IsOSPlatform(OSPlatform.OSX) ? "wine64" : "wine";
            sevenZip.StartInfo.Arguments = $"{sevenZipExe} x -o\"{installDir}\" \"{outF}\"";
        }
        else
        {
            sevenZip.StartInfo.FileName = sevenZipExe;
            sevenZip.StartInfo.Arguments = $"x -o\"{installDir}\" \"{outF}\"";
        }
        
        
        Info($"Starting 7zr.exe with arguments: {sevenZip.StartInfo.Arguments}");
        if (!sevenZip.Start())
            throw new Exception("Failed to start 7zr.exe");
        
        Info($"Extracting MinGW to {installDir}...");
        await sevenZip.WaitForExitAsync();
        
        if (sevenZip.ExitCode != 0)
            throw new Exception($@"""7zr.exe failed with exit code {sevenZip.ExitCode},
                                            Error: {await sevenZip.StandardError.ReadToEndAsync()}""");
        
        new FileInfo(outF).Delete();
    }
}
