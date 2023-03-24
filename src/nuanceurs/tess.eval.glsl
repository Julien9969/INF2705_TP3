#version 410

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;
uniform mat3 matrNormale;
uniform sampler2D heightMapTex;

/////////////////////////////////////////////////////////////////

in Attribs {
	vec2 texCoord;
} AttribsIn[];

out float heigt;

layout(quads) in;

float interpole( float v0, float v1, float v2, float v3 )
{
	float v01 = mix( v0, v1, gl_TessCoord.x );
	float v32 = mix( v3, v2, gl_TessCoord.x );
	return mix( v01, v32, gl_TessCoord.y );
}

vec2 interpole( vec2 v0, vec2 v1, vec2 v2, vec2 v3 )
{
	vec2 v01 = mix( v0, v1, gl_TessCoord.x );
	vec2 v32 = mix( v3, v2, gl_TessCoord.x );
	return mix( v01, v32, gl_TessCoord.y );
}

vec3 interpole( vec3 v0, vec3 v1, vec3 v2, vec3 v3 )
{
	vec3 v01 = mix( v0, v1, gl_TessCoord.x );
	vec3 v32 = mix( v3, v2, gl_TessCoord.x );
	return mix( v01, v32, gl_TessCoord.y );
}

vec4 interpole( vec4 v0, vec4 v1, vec4 v2, vec4 v3 )
{
	vec4 v01 = mix( v0, v1, gl_TessCoord.x );
	vec4 v32 = mix( v3, v2, gl_TessCoord.x );
	return mix( v01, v32, gl_TessCoord.y );
}

void main( void )
{

	vec2 texCoordI = interpole( AttribsIn[0].texCoord, AttribsIn[1].texCoord, AttribsIn[3].texCoord, AttribsIn[2].texCoord );
	heigt = texture(heightMapTex, texCoordI).y * 5;
 
	vec4 pos = interpole( gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[3].gl_Position, gl_in[2].gl_Position );
	
	pos += vec4(0.0, 1.0, 0.0, 0.0) * heigt;

	gl_Position = matrProj * matrVisu * matrModel * pos;
}