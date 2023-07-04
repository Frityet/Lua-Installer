using System.Runtime.InteropServices;
using Spectre.Console;

namespace LuaInstaller;

using static Log;

public class Program
{
    public static async Task<int> Main()
    {
        using var http = new HttpClient();
        var verTasks = new
        {
            Lua = Utilities.FindAllVersions(http: http,
                                            urlFormat: Packages.Lua.BASE_URL,
                                            majorMin: 5, majorMax: 6,
                                            minorMin: 0, minorMax: 10,
                                            buildMin: 0, buildMax: 10),

            Luarocks = Utilities.FindAllVersions(http: http,
                                                 urlFormat: Packages.Luarocks.BASE_URL,
                                                 majorMin: 1, majorMax: 4,
                                                 minorMin: 0, minorMax: 10,
                                                 buildMin: 0, buildMax: 10),

            MinGW = Utilities.FindAllVersions(http: http,
                                              urlFormat: Packages.MinGW.BASE_URL,
                                              majorMin: 10, majorMax: 14,
                                              minorMin: 0, minorMax: 10,
                                              buildMin: 0, buildMax: 10)
        };

        Info("Fetching Lua versions...");
        var luaVersions = new List<(int, int, int)>();
        foreach (Task<(string, (int, int, int))?> task in verTasks.Lua)
        {
            (string URL, (int, int, int) Version)? ver = await task;
            if (ver != null)
                luaVersions.Add(ver.Value.Version);
        }

        if (luaVersions.Count == 0)
        {
            Fail("No Lua versions found");
            return 1;
        }

        string luaVer = AnsiConsole.Prompt(new SelectionPrompt<string>()
                                           .Title("Select Lua version")
                                           .PageSize(10)
                                           .AddChoices(luaVersions.Select(ver => ver.ToString()).ToArray()));

        var lua = new Packages.Lua(version: luaVersions.Find(ver => ver.ToString() == luaVer));
        Info($"Downloading {lua}...");

        Info("Fetching luarocks versions...");
        var luarocksVersions = new List<(int, int, int)>();
        foreach (Task<(string, (int, int, int))?> task in verTasks.Luarocks)
        {
            (string URL, (int, int, int) Version)? ver = await task;
            if (ver != null)
                luarocksVersions.Add(ver.Value.Version);
        }
        
        if (luarocksVersions.Count == 0)
        {
            Fail("No Luarocks versions found");
            return 1;
        }

        string luarocksVer = AnsiConsole.Prompt(new SelectionPrompt<string>()
                                                .Title("Select luarocks version")
                                                .PageSize(10)
                                                .AddChoices(luarocksVersions.Select(ver => ver.ToString()).ToArray()));

        var luarocks = new Packages.Luarocks(version: luarocksVersions.Find(ver => ver.ToString() == luarocksVer));
        Info($"Downloading {luarocks}...");

        Info("Fetching MinGW versions...");
        var mingwVersions = new List<(int, int, int)>();
        foreach (Task<(string, (int, int, int))?> task in verTasks.MinGW)
        {
            (string URL, (int, int, int) Version)? ver = await task;
            if (ver != null)
                mingwVersions.Add(ver.Value.Version);
        }
        
        if (mingwVersions.Count == 0)
        {
            Fail("No MinGW versions found");
            return 1;
        }

        string mingwVer = AnsiConsole.Prompt(new SelectionPrompt<string>()
                                             .Title("Select MinGW version")
                                             .PageSize(10)
                                             .AddChoices(mingwVersions.Select(ver => ver.ToString()).ToArray()));
        bool useMSVCRT = AnsiConsole.Confirm(prompt: "Use MSVCRT instead of UCRT?", defaultValue: false);
        var mingw = new Packages.MinGW(version: mingwVersions.Find(ver => ver.ToString() == mingwVer), useMSVCRT: useMSVCRT);
        Info($"Downloading {mingw}...");

        Path baseDir;
        //If not windows (or debug) then use Path.CurrentDirectory, else we gotta use Program Files
#if DEBUG
        const bool DEBUG = true;
#else
        const bool DEBUG = false;
#endif
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows) && !DEBUG)
            baseDir = new Path(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86));
        else baseDir = Path.CurrentDirectory;
        
        Info("Installing MinGW");
        await mingw.Install(baseDir);
        Info("Installing Lua");
        await lua.Install(installDir: baseDir, baseDir/"mingw64"/"bin");
        Info("Installing Luarocks");
        await luarocks.Install(installDir: baseDir, baseDir/"mingw64"/"bin", baseDir/"lua"/"bin");
        Success("Done!");

        return 0;
    }
}
