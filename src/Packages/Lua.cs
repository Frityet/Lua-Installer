using System.Diagnostics;
using System.Formats.Tar;
using System.IO.Compression;
using System.Runtime.InteropServices;

namespace LuaInstaller.Packages;

using static Log;

public class Lua : Package
{
    public override string Name => "Lua";
    public const string BASE_URL = "https://www.lua.org/ftp/lua-{0}.{1}.{2}.tar.gz";

    public Lua((int major, int minor, int patch) version)
        : base(new Version(Major: version.major, Minor: version.minor, Patch: version.patch,
                           URLFormat: BASE_URL)) { }

    public override async Task Install(Path installDir, params string[]? path)
    {
        Info($"Extracting Lua to {installDir}...");
        installDir.CreateDirectory();
        await using (Stream stream = await Download)
        await using (var archive = new GZipStream(stream: stream, mode: CompressionMode.Decompress))
            await TarFile.ExtractToDirectoryAsync(source: archive, destinationDirectoryName: installDir, overwriteFiles: true);
        
        //Should extract to a dir called lua-5.4.3 or something, so rename to lua
        installDir = (installDir/$"lua-{CurrentVersion}").Move(to: installDir/"lua");

        //Make, by checking `additonalSearchPaths` for make.exe, then PATH for make.exe
        Path make = Utilities.FindExecutable(name: "make", additionalSearchPaths: path);
        var proc = new Process()
        {
            StartInfo = new ProcessStartInfo()
            {
                FileName = make,
                WorkingDirectory = installDir,
                // ArgumentList =
                // {
                //     "all", 
                //     "PLAT=mingw", 
                //     $"CC='{Utilities.FindExecutable(name: "gcc", useEnvPath: false,          additionalSearchPaths: path)}' -std=c99",
                //     $"AR='{Utilities.FindExecutable(name: "ar", useEnvPath: false,           additionalSearchPaths: path)}' rcu",
                //     $"RANLIB='{Utilities.FindExecutable(name: "ranlib", useEnvPath: false,   additionalSearchPaths: path)}'",
                // },
                // RedirectStandardOutput = true,
                // RedirectStandardError = true,
                UseShellExecute = false
            }
        };

        string[] procArgs =
        {
            "all",
            "PLAT=mingw",
            $"CC='{Utilities.FindExecutable(name: "x86_64-w64-mingw32-gcc", useEnvPath: false, additionalSearchPaths: path)}' -std=c99",
            $"AR='{Utilities.FindExecutable(name: "x86_64-w64-mingw32-gcc-ar", useEnvPath: false, additionalSearchPaths: path)}' rcu",
            $"RANLIB='{Utilities.FindExecutable(name: "x86_64-w64-mingw32-gcc-ranlib", useEnvPath: false, additionalSearchPaths: path)}'",
        };

        Info($"Running {proc.StartInfo.FileName} {proc.StartInfo.Arguments} in {proc.StartInfo.WorkingDirectory}...");
        if (!proc.Start())
            throw new Exception($"Failed to start {proc.StartInfo.FileName} {proc.StartInfo.Arguments} in {proc.StartInfo.WorkingDirectory}!");
        
        await proc.WaitForExitAsync();
        if (proc.ExitCode != 0)
            throw new Exception($"{proc.StartInfo.FileName} {proc.StartInfo.Arguments} in {proc.StartInfo.WorkingDirectory} exited with code {proc.ExitCode}!");

        string? pathEnv = Environment.GetEnvironmentVariable("PATH") ?? Environment.GetEnvironmentVariable("Path") ?? null;
        if (pathEnv == null) return;
        
        //Move lua.exe, luac.exe, and *.dll to installDir
        foreach (Path file in installDir/"src")
        {
            if (file.Extension is ".exe" or ".dll")
                file.Move(to: installDir);
        }
        
        //Add lua to PATH permanetnly on windows
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            string luaPath = installDir/"lua";
            if (!pathEnv.Contains(luaPath))
                Environment.SetEnvironmentVariable(variable: pathEnv, 
                                                   value: $"{Environment.GetEnvironmentVariable(pathEnv)}{Path.PathEnvironmentVariableSeparator}{luaPath}", 
                                                   target: RuntimeInformation.IsOSPlatform(OSPlatform.Windows) ? EnvironmentVariableTarget.User : EnvironmentVariableTarget.Process);
        }
    }

}
