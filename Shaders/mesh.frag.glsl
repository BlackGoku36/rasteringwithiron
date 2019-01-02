#version 450

in vec3 wnormal;
in vec3 FragPos;

in vec2 texcoords;

out vec4 fragColor;

uniform vec3 lightColor;
uniform vec3 lightDir;
uniform vec3 cameraPos;
//uniform vec3 color;

uniform sampler2D image;


//layout(location = 0) out vec4 fragColor;
//layout(location = 1) out vec4 normals;

void main() {
	vec4 color = texture(image, texcoords);
	//vec3 n = normalize(wnormal);
	//float specularStrength = 0.5;
/*
	float dotNL = max(0.0, dot(n, lightDir));
	vec3 direct = color * max(0.0, dotNL) * lightColor;
	vec3 indirect = vec3(0.4, 0.4, 0.4);

	//vec3 cameraDir = normalize(cameraPos) 

	fragColor = vec4(direct + indirect, 1.0);

	float ambientStrength = 0.1;
    vec3 ambient = ambientStrength * lightColor;
	
	float diff = max(dot(n, lightDir), 0.0);
	//vec3 diffuse = diff * lightColor;

	vec3 viewDir = normalize(cameraPos - FragPos);
	vec3 reflectDir = reflect(-lightDir, n);

	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
	vec3 specular = specularStrength * spec * lightColor;  

	//vec3 result = texture((ambient + diffuse + specular) * color);

	vec3 diffuse = lightColor * diff * vec3(color);
	vec3 amb = ambient * vec3(color);

	vec3 result = amb + diffuse * color);
	*/

	fragColor = vec4(color.rgb, 1.0);
}
