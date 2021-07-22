
attribute vec4 Position;    // position of vertex
attribute vec4 SourceColor; // color of vertex

uniform highp mat4 u_Projection;
uniform highp mat4 u_ModelView;

varying vec4 DestinationColor;

void main(void) {
    
    DestinationColor = SourceColor;
    
    // gl_Position is built-in pass-out variable. Must config for in vertex shader
    gl_Position = u_Projection * u_ModelView * Position;
}
