// NUANCEUR DE FRAGMENT
#version 410

/////////////////////////////////////////////////////////////////

in float heigt;

uniform sampler2D heightMapTex;

out vec4 FragColor;

void main( void )
{
    FragColor = vec4(1 / (heigt / 5));
}