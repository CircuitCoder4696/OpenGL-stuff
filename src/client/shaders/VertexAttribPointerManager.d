module client.shaders.VertexAttribPointerManager;
import bindbc.opengl;
import io.Logger;

package class VertexAttribPointerHandler {
    package uint Id;
    package int dimensions;
    package uint elemType;
    package ubyte normalized= GL_FALSE;
    package uint len;
    package uint strideOffset;
    public this(uint dimensions, uint elemType, bool normalized, uint len) {
        this.dimensions= dimensions;
        this.elemType= elemType;
        if(normalized)
            this.normalized= GL_TRUE;
        this.len= len;
    };
};

public class VertexAttribPointerManager {
    public static VertexAttribPointerHandler[] attributes;
    private static uint glSizeOf(uint glType) {
        switch(glType) {
            case GL_FLOAT:return 4;
            case GL_DOUBLE:return 8;
            case GL_UNSIGNED_BYTE:return 1;
            case GL_UNSIGNED_SHORT:return 2;
            case GL_UNSIGNED_INT:
            case GL_INT:
                return 4;
            default:
        };
        return 0;
    };
    public static void appendAttrib(uint dimensions, uint elemType, uint length) {
        VertexAttribPointerHandler vaph= new VertexAttribPointerHandler(dimensions, elemType, false, length);
        vaph.Id= cast(uint) attributes.length;
        attributes ~= [vaph];
    };
    public static void enableAttribs() {
        uint totalStride= 0;
        foreach(i,v; this.attributes) {
            v.strideOffset= totalStride;
            totalStride += v.len * glSizeOf(v.elemType);
        };
        foreach(i,v; this.attributes) {
            glVertexAttribPointer(cast(uint) i, v.dimensions, v.elemType, v.normalized, totalStride, cast(void*) v.strideOffset);
            glEnableVertexAttribArray(cast(uint) i);
        };
    };
    public static void disableAttribs() {
        foreach(i,v; this.attributes) {
            glDisableVertexAttribArray(cast(uint) i);
        };
    };
};
