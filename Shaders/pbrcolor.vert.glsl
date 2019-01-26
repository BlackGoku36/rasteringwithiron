#version 450

in vec4 pos;
in vec3 nor;
in vec2 tex;

out vec2 TexCoords;
out vec3 FragPos;
out vec3 Normal;

uniform mat4 P;
uniform mat4 V;
uniform mat4 W;
uniform float posUnpack;

void main(){
    FragPos = vec3(W*vec4(pos.xyz * posUnpack, 1.0));
    Normal = mat3(W) * vec3(nor.xy, pos.w);
    gl_Position = P*V*vec4(FragPos, 1.0);
}