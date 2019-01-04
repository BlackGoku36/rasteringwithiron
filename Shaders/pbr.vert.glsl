#version 450

in vec3 pos;
in vec3 nor;
in vec2 tex;

out vec2 TexCoords;
out vec3 WorldPos;
out vec3 Normal;

uniform mat4 N;
uniform mat4 WVP;
uniform mat4 P;
uniform mat4 V;
uniform mat4 M;

void main()
{
    TexCoords = tex;
    WorldPos = vec3(N * vec4(pos.xyz, 1.0));
    Normal = mat3(N) * nor;   
    gl_Position = P * V * vec4(WorldPos.xyz, 1.0);
}