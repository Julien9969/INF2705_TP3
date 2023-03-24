#version 410

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;
// uniform mat3 matrNormale;

/////////////////////////////////////////////////////////////////

layout(location=0) in vec4 Vertex;
layout(location=3) in vec4 Color;
layout(location=8) in vec4 TexCoord;


out Attribs {
	vec2 texCoord;
} AttribsOut;

void main( void )
{
	gl_Position = Vertex;

	AttribsOut.texCoord = TexCoord.st;
}
