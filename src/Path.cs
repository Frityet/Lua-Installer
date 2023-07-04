using System.Collections;

namespace LuaInstaller;

using SysPath = System.IO.Path;

public readonly struct Path : IEquatable<Path>, IEnumerable<Path>
{
    public static Path CurrentDirectory => new Path(Environment.CurrentDirectory);
    public static Path TemporaryDirectory => new Path(SysPath.GetTempPath());
    public static char PathSeparator => System.IO.Path.DirectorySeparatorChar;
    public static char PathEnvironmentVariableSeparator => System.IO.Path.PathSeparator;

    public string[] Parts { get; }
    public FileSystemInfo? Info { get; }
    public bool Exists => Info != null;
    public bool IsFile => Info is FileInfo;
    public bool IsDirectory => Info is DirectoryInfo;
    public FileSystemInfo? FileSystemInfo => this[^1];
    
    public string? Extension => IsFile ? SysPath.GetExtension(ToString()) : null;

    public FileSystemInfo? this[int index]
    {
        get
        {
            //Merge all the parts up to the index into a string
            string path = String.Join(separator: PathSeparator, value: Parts.Take(index).ToArray());
            //If it exists then we can get the info
            if (Directory.Exists(path)) return new DirectoryInfo(path);
            else if (File.Exists(path)) return new FileInfo(path);
            else return null;
        }
    }
    
    public FileSystemInfo? this[Index index] => this[index.GetOffset(Parts.Length)];
    public FileSystemInfo?[] this[Range range] => Parts[range].Select(part => new Path(part).Info).ToArray();
    
    public Path(params string[] parts)
    {
        parts = parts.Length switch
        {
            0 => Environment.CurrentDirectory.Split(PathSeparator),
            1 => parts[0].Split(PathSeparator),
            _ => parts
        };
        if (parts[0] == "") parts = parts[1..];

        Parts = parts;
        //If it exists then we can get the info
        if (Directory.Exists(ToString()))
            Info = new DirectoryInfo(ToString());
        else if (File.Exists(ToString()))
            Info = new FileInfo(ToString());
        else
            Info = null;
    }

    public bool Equals(Path other) => Parts.Length == other.Parts.Length && !Parts.Where((t, i) => t != other.Parts[i]).Any();
    public override bool Equals(object? obj) => obj is not null and Path p && Equals(p);
    public override int GetHashCode() => HashCode.Combine(Parts);

    public IEnumerator<Path> GetEnumerator()
    {
        if (!IsDirectory) yield return this;
        //Enumerate every file in `this` dir
        foreach (FileSystemInfo file in ((DirectoryInfo) Info!).EnumerateFileSystemInfos())
            yield return new Path(file.FullName);
    }
    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();

    public override string ToString() => 
        SysPath.GetFullPath(PathSeparator + String.Join(separator: PathSeparator, value: Parts));
    
    public static implicit operator string(Path path) => path.ToString();

    public Path Append(params string[] parts) => new Path(Parts.Concat(parts).ToArray());
    public Path Append(Path other) => Append(other.Parts);

    public Path CreateDirectory()
    {
        if (IsFile)
            throw new InvalidOperationException("Cannot create a directory where a file already exists!");
        
        Directory.CreateDirectory(ToString());
        return new Path(); // the .Info property will be set to exist as a dir by the constructor
    }

    public Path CreateFile()
    {
        if (IsDirectory)
            throw new InvalidOperationException("Cannot create a file where a directory already exists!");
        
        File.Create(ToString());
        return new Path();
    }

    public Path Move(Path to)
    {
        if (to.Exists)
            to.Delete();
        
        if (IsFile)
            File.Move(sourceFileName: ToString(), destFileName: to.ToString());
        else if (IsDirectory)
            Directory.Move(sourceDirName: ToString(), destDirName: to.ToString());
        else
            throw new InvalidOperationException("Cannot move a non-existent file or directory!");

        return to;
    }

    public Path Delete()
    {
        if (IsFile)
            File.Delete(ToString());
        else if (IsDirectory)
            Directory.Delete(path: ToString(), recursive: true);
        else
            throw new InvalidOperationException("Cannot delete a non-existent file or directory!");

        return new Path();
    }
    
    public Path WithExtension(string extension) => new Path(ToString() + extension);
    
    public static Path operator/(Path self, Path other) => self.Append(other);
    public static Path operator/(Path self, string other) => self.Append(other);
}
