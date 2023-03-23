/// NUANCEUR SOMMET 
#version 410

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;
uniform mat3 matrNormale;

/////////////////////////////////////////////////////////////////

layout(location=0) in vec4 Vertex;
layout(location=2) in vec3 Normal;
layout(location=3) in vec4 Color;
layout(location=8) in vec4 TexCoord;

out Attribs {
    vec4 vertex;
    vec4 couleur;
    vec3 normale;
    vec2 texCoord;
} AttribsOut;

uniform sampler2D heightMapTex;


void main( void )
{



    // float normalizedHeight =  texture( heightMapTex, TexCoord.st ).r;
    // float height = 5 * normalizedHeight;
    gl_Position = matrProj * matrVisu * matrModel * Vertex;
    
    // gl_Position = vec4(0, height, 0, 1);

    // transformation standard du sommet

    AttribsOut.vertex = Vertex;
    AttribsOut.normale = matrNormale * Normal;
    AttribsOut.couleur = Color;
    AttribsOut.texCoord = TexCoord.st;
}
