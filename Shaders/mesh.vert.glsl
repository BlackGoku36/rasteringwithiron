#version 450

in vec4 pos;
in vec3 nor;
in vec2 tex;

out vec3 wnormal;

out vec3 FragPos;

out vec2 texcoords;

uniform mat3 N;
uniform mat4 WVP;
uniform mat4 M;

//layout (location = 0) in vec4 pos;
//layout (location = 1) in vec3 nor;

void main() {
	wnormal = normalize(N * nor);
	texcoords = tex;
	FragPos = vec3(M * vec4(pos.xyz, 1.0));
	gl_Position = WVP * vec4(pos.xyz, 1.0);
}
