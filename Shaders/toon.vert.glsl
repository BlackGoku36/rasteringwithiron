#version 450

in vec3 pos;
in vec3 nor;

out vec3 Normal;
out vec3 Pos;

uniform mat4 WVP;
uniform mat4 V;
uniform mat4 W;
uniform mat4 P;
uniform mat3 N;

void main(){
	Normal = normalize(vec3(W) * nor);
	Pos = vec3(W * vec4(pos.xyz, 1.0));
	gl_Position = P * V *vec4(Pos.xyz, 1.0);
}