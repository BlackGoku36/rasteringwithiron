#version 450

in vec3 pos;
in vec3 nor;

out vec3 Normal;
out vec3 Pos;

uniform mat4 P;
uniform mat4 V;
uniform mat4 W;
uniform mat3 N;

void main(){
	Normal = normalize(N * nor);
	Pos = vec3(W * vec4(pos, 1.0));
	gl_Position = P * V * W * vec4(pos, 1.0);
}