#version 450

in vec3 pos;
in vec3 nor;
in vec2 tex;

out vec2 TexCoords;
out vec3 WorldPos;
out vec3 Normal;

uniform mat4 P;
uniform mat4 V;
uniform mat4 W;
uniform mat3 N;

void main()
{
    TexCoords = tex;
    WorldPos = vec3(N * pos);
    Normal = mat3(N) * nor;
    gl_Position = P * V * W*  vec4(WorldPos, 1.0);
}