module io.Console;
import core.stdc.stdio;
import std.conv:to;
import std.stdio;

public class Console {
    private static void printSingle(char[] data) {
        printf("%.*s", data.length, data.ptr);
    };
    private static void printSingle(string data) {
        printf("%.*s", data.length, data[].ptr);
    };
    private static void printSingle(T)(T data) {
        string d= data.to!string;
        printf("%.*s", d.length, d[].ptr);
    };
    public static extern(C) void println(T...)(T data) {
        foreach(e; data)printSingle(e);
        printSingle("\n");
    };
};
