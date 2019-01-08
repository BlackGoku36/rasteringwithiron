#version 450

in vec4 pos;
in vec3 nor;
in vec2 tex;

out vec3 wnormal;

out vec3 FragPos;

out vec2 texcoords;

//uniform mat3 N;
uniform mat4 P;
uniform mat4 V;
uniform mat4 W;

void main() {
    texcoords = tex;
    FragPos = vec3(W * vec4(pos.xyz, 1.0));
    wnormal = mat3(W) * nor;   
    gl_Position = P * V * vec4(FragPos.xyz, 1.0);
}
