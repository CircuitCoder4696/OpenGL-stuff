import bindbc.glfw;
import bindbc.opengl;
import client.ogl.Graphics;
import client.shaders.Shader;
import common.io.Logger;
import core.stdc.stdlib;
import std.format;
import std.stdio;

extern(C) {
    void framebuffer_size_callback(GLFWwindow* window, int width, int height) nothrow {
        glViewport(0,0, width,height);
    };
    void processInput(GLFWwindow* window) {
        if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
            glfwSetWindowShouldClose(window,true);
        };
    };
};

public class App {
    public static void main(string[] av) {
        Logger log= new Logger("./dev.log");
        GLFWSupport glfw= loadGLFW();
        if(!glfwInit()) {
            log.error("Failed to initialize GLFW.  ");
            exit(-1);
        };
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR,3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR,3);
        GLFWwindow* window= glfwCreateWindow(800,600, "OpenGL quad and texture", null,null);
        if(!window) {
            log.error("Failed to create GLFW window.  ");
            exit(-1);
        };
        glfwMakeContextCurrent(window);
        auto gl= loadOpenGL();
        writeln("loadOpenGL ",gl);
        if(gl != GLSupport.gl33) {
            writeln(gl);
            writeln("Failed to initialize `open-gl`.  ");
            exit(-1);
        };
        glViewport(0,0,800,600);
        glfwSetFramebufferSizeCallback(window, &framebuffer_size_callback);
        Shader shader= new Shader("./src/client/shaders/vertex.glsl", "./src/client/shaders/fragment.glsl");
        float[] vertices= [
            -0.5,-0.5,0.0, 0f,0f,0f, 0f,0f,
            -0.5,0.5,0.0,  0f,1f,0f, 0f,1f,
            0.5,0.5,0.0,   1f,1f,0f, 1f,0f,
            0.5,-0.5,0.0,  1f,0f,0f, 1f,1f,
        ];
        uint[] indices= [ 0,1,2, 2,3,0 ];
        uint result;
        glGenVertexArrays(1, &result);
        glBindVertexArray(result);
        uint result;
        glGenBuffers(1, &result);
        glBindBuffer(GL_ARRAY_BUFFER, result);
        uint result;
        glGenBuffers(1, &result);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, result);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)(0 * float.sizeof)); // Positions
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)(3 * float.sizeof)); // Colors
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * float.sizeof, cast(void*)(6 * float.sizeof)); // Texture coordinates
        glEnableVertexAttribArray(2);
        uint result;
        glGenTextures(1, &result);
        glBindTexture(GL_TEXTURE_2D, result);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        TextureImage image= Graphics.readDataFromPNG_rgba("E:/Data/random-images/00000000/00000001-0000.png");
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, image.getWidth(), image.getHeight(), 0, GL_RGB, GL_UNSIGNED_BYTE, (image.getData!ubyte).ptr);
        glGenerateMipmap(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, 0);
        glDeleteTextures(1, [texture].ptr);
        ulong frameCount;
        GLenum error;
        while(!glfwWindowShouldClose(window)) {
            //Input:
            processInput(window);
            error= glGetError(); if(error != GL_NO_ERROR)log.error("OpenGL error: %s".format(error));
            //Textures:
            // glBindTexture(GL_TEXTURE_2D, texture);
            //Rendering:
            glClearColor(0.2f,0.5f,0.8f,1f);
            glClear(GL_COLOR_BUFFER_BIT);
            error= glGetError(); if(error != GL_NO_ERROR)log.error("OpenGL error: %s".format(error));
            //Rendering:
            shader.use();
            error= glGetError(); if(error != GL_NO_ERROR)log.error("OpenGL error: %s".format(error));
            //Rendering:
            glBindVertexArray(vao);
            glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, cast(void*) 0);
            glBindVertexArray(0);
            error= glGetError(); if(error != GL_NO_ERROR)log.error("OpenGL error: %s".format(error));
            //Events:
            glfwSwapBuffers(window);
            glfwPollEvents();
            frameCount++;
            error= glGetError(); if(error != GL_NO_ERROR)log.error("OpenGL error: %s".format(error));
        };
        log.info("%s frames generated.  ".format(frameCount));
    };
};

void main(string[] argV) {
    App.main(ArgV);
};
