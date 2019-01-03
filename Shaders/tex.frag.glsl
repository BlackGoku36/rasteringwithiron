#version 450

in vec3 wnormal;

in vec2 texcoords;

out vec4 fragColor;

uniform vec3 lightColor;
uniform vec3 lightDir;

uniform sampler2D image;

void main() {
	vec4 color = texture(image, texcoords);
	vec3 n = normalize(wnormal);

	float dotNL = max(0.0, dot(n, lightDir));
	vec3 direct = color.rgb * max(0.0, dotNL) * lightColor;
	vec3 indirect = vec3(0.1, 0.1, 0.1);

	fragColor = vec4(direct + indirect, 1.0);
}