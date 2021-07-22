
attribute vec4 Position;    // position of vertex
attribute vec4 SourceColor; // color of vertex

varying vec4 DestinationColor;

void main(void) {
    
    DestinationColor = SourceColor;
    
    // gl_Position is built-in pass-out variable. Must config for in vertex shader
    gl_Position = Position;
}
