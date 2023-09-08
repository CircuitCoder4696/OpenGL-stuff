module io.FileIO;

public class FileIO {   //   I tend to prefer keeping all the IO stuff in one place.
    import std.file:_a=append,_e=exists,_r=read,_w=write;
    public static void append(string filePath, void[] data) {
        _a(filePath, data);
    };
    public static bool exists(string filePath) {
        return _e(filePath);
    };
    public static void[] read(string filePath) {
        return _r(filePath);
    };
    public static void write(string filePath, void[] data) {
        _w(filePath, data);
    };
};
