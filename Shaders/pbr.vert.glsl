#version 450

in vec3 pos;
in vec3 nor;
in vec2 tex;

out vec2 TexCoords;
out vec3 FragPos;
out vec3 Normal;

uniform mat4 P;
uniform mat4 V;
uniform mat4 W;

void main()
{
    TexCoords = tex;
    FragPos = vec3(W * vec4(pos, 1.0));
    Normal = mat3(W) * nor;
    gl_Position = P * V * vec4(FragPos, 1.0);
}