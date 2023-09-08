module io.Logger;
import std.format;
import io.Console;
import io.FileIO;
import std.array;

public class Logger {
    private string filePath;
    private string modulePath;
    public this(string filePath, string modulePath= __MODULE__) {
        this.filePath= filePath;
        this.modulePath= modulePath;
    };
    private void write(string messageType, string message, uint lineNumber) {
        string result= "[%s] %s @%s:   %s".format(messageType, this.modulePath, lineNumber, message).replace("\n", "\n            ");
        FileIO.append(this.filePath, cast(void[]) result[]);
        FileIO.append(this.filePath, cast(void[]) ['\n']);
        Console.println(result);
    };
    public void critical(string message, uint lineNumber= __LINE__) { write("CRITICAL", message, lineNumber); };
    public void dbg(string message, uint lineNumber= __LINE__) { write("DEBUG", message, lineNumber); };
    public void error(string message, uint lineNumber= __LINE__) { write("ERROR", message, lineNumber); };
    public void info(string message, uint lineNumber= __LINE__) { write("INFO", message, lineNumber); };
    public void warn(string message, uint lineNumber= __LINE__) { write("CRITICAL", message, lineNumber); };
    private void quietWrite(string messageType, string message, uint lineNumber) {
        string result= "[%s] %s @%s:   %s".format(messageType, this.modulePath, lineNumber, message).replace("\n", "\n            ");
        FileIO.append(this.filePath, cast(void[]) result[]);
        FileIO.append(this.filePath, cast(void[]) ['\n']);
    };
    public void quietQritical(string message, uint lineNumber= __LINE__) { write("CRITICAL", message, lineNumber); };
    public void quietDBG(string message, uint lineNumber= __LINE__) { write("DEBUG", message, lineNumber); };
    public void quietError(string message, uint lineNumber= __LINE__) { write("ERROR", message, lineNumber); };
    public void quietInfo(string message, uint lineNumber= __LINE__) { write("INFO", message, lineNumber); };
    public void quietWarn(string message, uint lineNumber= __LINE__) { write("CRITICAL", message, lineNumber); };
};
