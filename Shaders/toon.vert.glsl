#version 450

in vec3 pos;
in vec3 nor;

out vec3 Normal;
out vec3 Pos;

uniform mat4 P;
uniform mat4 V;
uniform mat4 W;

void main(){
	Normal = mat3(W) * nor;
	Pos = mat3(W) * pos;
	gl_Position = P * V * W * vec4(pos.xyz, 1.0);
}