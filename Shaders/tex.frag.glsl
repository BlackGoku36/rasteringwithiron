#version 450

in vec3 wnormal;
in vec3 FragPos;

in vec2 texcoords;

out vec4 fragColor;

uniform vec3 lightColor;
uniform vec3 lightDir;
//uniform vec3 lightPos;
//uniform vec3 cameraPos;

uniform sampler2D albedoMap;
uniform sampler2D aoMap;

void main() {

	vec3 tex = texture(albedoMap, texcoords).rgb;
	float tex2 = texture(aoMap, texcoords).r;
	vec3 n = normalize(wnormal);

	float dotNL = max(0.0, dot(n, lightDir));

	vec3 diffuse = tex * max(0.0, dotNL) * lightColor;

	vec3 ambient = vec3(0.03) * tex * tex2;


	fragColor = vec4(diffuse + ambient, 1.0);

}