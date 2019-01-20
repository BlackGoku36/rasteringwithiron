#version 450

in vec3 Normal;
in vec3 Pos;

out vec4 FragColor;
uniform vec3 lightPos;
uniform vec3 cameraPos;
//uniform vec3 cameraDir;
uniform vec3 lightDir;
uniform vec3 lightCol;

void main()
{

	float intensity;
	vec3 color;
	vec3 n = normalize(Normal);
	intensity = dot(vec3(lightPos),n);
	float distance = length(lightPos - Pos);
	vec3 R = (-lightDir) - 2.0 * dot(n, (-lightDir)) * n;
	float cosTheta = clamp(dot(n, lightDir), 0.0, 1.0);
	vec3 ambient = vec3(0.1, 0.1, 0.1);
	vec3 viewDir = normalize(cameraPos-Pos);
	vec3 reflectDir = reflect(-lightDir, n);
	float spec = pow(clamp(dot(viewDir, R), 0.0, 1.0), 32.0);
	vec3 specular = vec3(0.2) * lightCol * spec;

	if (intensity > 1.0)
		color = vec3(0.2,0.2,1.0);
	//else if (intensity > 0.1)
		//color = vec3(0.0,0.0,0.7);
	//else if (intensity > 0.25)
		//color = vec3(0.0,0.0,0.6);
	else
		color = vec3(0.0,0.0,0.5);

	vec3 result = color+specular+ambient;
	FragColor = vec4(result, 1.0);

}