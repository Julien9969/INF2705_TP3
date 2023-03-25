#version 410

/////////////////////////////////////////////////////////////////

in Attribs {
	vec2 texCoord;
	float heigt;
} AttribsIn;


out vec4 FragColor;

void main( void )
{
    FragColor = vec4(1 * AttribsIn.heigt/5, 1 * AttribsIn.heigt/5, 1 * AttribsIn.heigt/5, 1.0);
}