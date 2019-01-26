#version 450

in vec4 pos;
in vec3 nor;

out vec3 Normal;
out vec3 Pos;

uniform mat4 WVP;
uniform mat4 V;
uniform mat4 W;
uniform mat4 P;
uniform mat3 N;
uniform float posUnpack;

void main(){
	Pos = vec3(W*vec4(pos.xyz * posUnpack, 1.0));
	Normal = mat3(W) * vec3(nor.xy, pos.w);
	gl_Position = P * V *vec4(Pos.xyz, 1.0);
}