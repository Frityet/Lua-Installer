using System.Diagnostics.CodeAnalysis;
using System.Diagnostics.Contracts;
using System.Runtime.InteropServices;

namespace LuaInstaller;

using static Log;

public static class Utilities
{
    public static Path FindExecutable(string name, bool useEnvPath = true, params string[]? additionalSearchPaths)
    {
        additionalSearchPaths ??= Array.Empty<string>();

        var searchPaths = new List<Path>(additionalSearchPaths.Length + 1);
        searchPaths.AddRange(additionalSearchPaths.Select(p => new Path(p)));

        if (useEnvPath)
        {
            string path = Environment.GetEnvironmentVariable("PATH")
                          ?? Environment.GetEnvironmentVariable("Path")
                          ?? ".";

            searchPaths.AddRange(path.Split(Path.PathEnvironmentVariableSeparator).Select(p => new Path(p)));
        }

        foreach (Path exe in searchPaths.Select(searchPath => searchPath/name).Where(exe => exe.Exists || exe.WithExtension(".exe").Exists))
            return exe.Exists ? exe : exe.WithExtension(".exe");
        
        throw new FileNotFoundException($"Could not find executable {name} in any of the search paths: " +
                                        $"{String.Join(separator: ", ", values: searchPaths)}");
    }


    [Pure]
    public static Task<(string, (int, int, int))?>[] FindAllVersions(HttpClient http, [StringSyntax(StringSyntaxAttribute.CompositeFormat)] string urlFormat, 
                                                                     int majorMax, int minorMax, int buildMax,
                                                                     int majorMin = 0, int minorMin = 0, int buildMin = 0)
    {
        var reqs = new Task<(string, (int, int, int))?>[(majorMax - majorMin) * (minorMax - minorMin) * (buildMax - buildMin)];

        int i = reqs.Length - 1; //We go from bottom to top to avoid having to reverse the array later
        for (int major = majorMin; major < majorMax; major++)
        {
            for (int minor = minorMin; minor < minorMax; minor++)
            {
                for (int build = buildMin; build < buildMax; build++)
                {
                    Task<(string, (int, int, int))?> Fn(int major, int minor, int build) =>
                        Task.Run<(string, (int, int, int))?>(async () =>
                        {
                            string url = String.Format(format: urlFormat, major, minor, build);
                            HttpResponseMessage resp =
                                await http.GetAsync(requestUri: url,
                                                    completionOption: HttpCompletionOption.ResponseHeadersRead);

                            if (resp.IsSuccessStatusCode)
                                return (url, (major, minor, build));
                            else return null;
                        });
                    

                    //Copy it to the stack before running the thread to avoid errors
                    reqs[i--] = Fn(major, minor, build);
                }
            }
        }

        return reqs;
    }

    private static int s_loadingState;
    private static readonly string[] LOADING_STATES = { "|", "/", "-", "\\" };
    public static string LoadingBar() => LOADING_STATES[Interlocked.Increment(ref s_loadingState) % LOADING_STATES.Length];
}