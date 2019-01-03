#version 450

in vec3 wnormal;

out vec4 fragColor;

uniform vec3 lightColor;
uniform vec3 lightDir;
uniform vec3 color;

uniform sampler2D image;

void main() {
	vec3 n = normalize(wnormal);

	float dotNL = max(0.0, dot(n, lightDir));
	vec3 direct = color * max(0.0, dotNL) * lightColor;
	vec3 indirect = vec3(0.1, 0.1, 0.1)*color;
 

	fragColor = vec4(direct + indirect, 1.0);
}
