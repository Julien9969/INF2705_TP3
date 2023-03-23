// NUANCEUR DE FRAGMENT
#version 410

/////////////////////////////////////////////////////////////////

in Attribs {
    vec4 vertex;
    vec4 couleur;
    vec3 normale;
    vec2 texCoord;
} AttribsIn;

uniform sampler2D heightMapTex;

out vec4 FragColor;

void main( void )
{
    vec4 coulTex = texture( heightMapTex, AttribsIn.texCoord );
    FragColor = coulTex;


    // vec4 coulTex = texture(heightMapTex, AttribsIn.texCoord);
    // float height = coulTex.r * coulTex.g * coulTex.b;
    // height = height * 5.0;
    // FragColor = vec4(AttribsIn.vertex.xyz + AttribsIn.normale * height, 1.0);
}