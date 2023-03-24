// NUANCEUR DE FRAGMENT
#version 410

/////////////////////////////////////////////////////////////////


in Attribs {
    float heigtTex;
} AttribsIn;

uniform sampler2D heightMapTex;

out vec4 FragColor;

void main( void )
{
    FragColor = vec4(AttribsIn.heigtTex / 5); 

    float y = 0.229 * FragColor.r + 0.587 * FragColor.g + 0.114 * FragColor.b;
        
    FragColor.r = y; 
    FragColor.g = y;
    FragColor.b = y; 
}