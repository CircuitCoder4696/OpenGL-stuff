module client.ogl.Graphics;
import arsd.png;
import bindbc.glfw;
import bindbc.opengl;
import core.stdc.stdlib;
import client.shaders.VertexAttribPointerManager;
import io.Logger;
import std.format;

public class TextureImage {
    package uint colorMode;
    package int width,height;
    package void[] data;
    public this(int width, int height, void[] data) {
        this.width= width;
        this.height= height;
        this.data= data;
    };
    public this() {};
    public int getWidth() => this.width;
    public int getHeight() => this.height;
    public T[] getData(T)() => cast(T[]) this.data;
};

public class Graphics {
    private static int[2] versionNumbers= [-1,-1];
    public static void applyData(float[] vertices) {
        Logger log= new Logger("./dev.log");
        log.error("The method `apply:uint(verticies:float[])` is unavailable for the time being.  ");
    };
    public static void applyData(float[] vertices, uint[] indices) {
        glBufferData(GL_ARRAY_BUFFER, vertices.length * typeof(vertices[0]).sizeof, vertices.ptr, GL_STATIC_DRAW);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.length * typeof(indices[0]).sizeof, indices.ptr, GL_STATIC_DRAW);
    };
    public static void applyTextures(TextureImage image) {
        Logger log= new Logger("./dev.log");
        int width,height,nrChannels;
        if(image.data) {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, image.width, image.height, 0, GL_RGBA8, GL_UNSIGNED_BYTE, cast(void*) image.data);
            glGenerateMipmap(GL_TEXTURE_2D);
        } else {
            log.error("Failed to load texture.  ");
        };
    };
    public static void applyTextures(string filePath) {
        Logger log= new Logger("./dev.log");
        TextureImage image= Graphics.readDataFromPNG_rgba(filePath);
        applyTextures(image);
    };
    public static void drawElements(uint vao, uint mode, uint indiceCount, uint indiceType, uint vectorOffset) {
        glBindVertexArray(vao);
        glDrawElements(mode, indiceCount, indiceType, cast(void*) vectorOffset);
        glBindVertexArray(0);
    };
    public static uint genEBO() {
        uint result;
        glGenBuffers(1, &result);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, result);
        return result;
    };
    public static uint genTextures() {
        uint result;
        glGenTextures(1, &result);
        glBindTexture(GL_TEXTURE_2D, result);
        return result;
    };
    public static uint genVAO() {
        uint result;
        glGenVertexArrays(1, &result);
        glBindVertexArray(result);
        return result;
    };
    public static uint genVBO() {
        uint result;
        glGenBuffers(1, &result);
        glBindBuffer(GL_ARRAY_BUFFER, result);
        return result;
    };
    public static void loadGLContext() {
        Logger log= new Logger("./dev.log");
        auto gl= loadOpenGL();
        if(versionNumbers[0] == -1 || versionNumbers[1] == -1) {
            log.critical("You forgot to choose an `open-gl`-version, or the version is not available!  ");
        };
        if(gl != GLSupport.gl33) {
            exit(-1);
        };
    };
    private static ubyte[4][] readDataFromPNG_rgba_internal(MemoryImage d00) {
        ubyte[4][] result;
        int w,h;
        w= d00.width();
        h= d00.height();
        foreach(y; 0 .. h)foreach(x; 0 .. w) {
            result ~= [d00.getPixel(x, h - (y +1)).components];
        };
        return result;
    };
    public static TextureImage readDataFromPNG_rgba(string filePath) {
        Logger log= new Logger("./dev.log");
        TextureImage result= new TextureImage();
        MemoryImage d00= readPng(filePath);
        ubyte[4][] d01= readDataFromPNG_rgba_internal(d00);
        foreach(v; d01) {
            result.data ~= v[0 .. 4];
        };
        if(result.data.length == 0)log.error("No data loaded.  ");
        result.width= d00.width();
        if(result.width == 0)log.error("No width.  ");
        result.height= d00.height();
        if(result.height == 0)log.error("No height.  ");
        return result;
    };
    public static void setTextureWrappingOptions(uint textureType, uint[2][] textureParameteri...) {
        foreach(uint[2] v; textureParameteri) {
            glTexParameteri(textureType, v[0], v[1]);
        };
    };
    public static void setVersion(int versionMajor, int versionMinor) {
        Logger log= new Logger("./dev.log");
        log.info("Setting up `open-gl`-version %s.%s.  ".format(versionMajor, versionMinor));
        versionNumbers[0]= versionMajor;
        versionNumbers[1]= versionMinor;
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR,versionMajor);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR,versionMinor);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    };
};
