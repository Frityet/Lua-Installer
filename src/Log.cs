namespace LuaInstaller;

public static class Log
{
    public static void Success(string msg)
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.Write("[+] ");
        Console.ResetColor();
        Console.WriteLine(msg);
    }

    public static void Fail(string msg)
    {
        Console.ForegroundColor = ConsoleColor.Red;
        Console.Write("[-] ");
        Console.ResetColor();
        Console.WriteLine(msg);
    }

    public static void Warning(string msg)
    {
        Console.ForegroundColor = ConsoleColor.Yellow;
        Console.Write("[!] ");
        Console.ResetColor();
        Console.WriteLine(msg);
    }

    public static void Info(string msg)
    {
        Console.ForegroundColor = ConsoleColor.Blue;
        Console.Write("[i] ");
        Console.ResetColor();
        Console.WriteLine(msg);
    }


    public static void Debug(string msg)
    {
        Console.ForegroundColor = ConsoleColor.Gray;
        Console.Write("[d] ");
        Console.ResetColor();
        Console.WriteLine(msg);
    }
}
