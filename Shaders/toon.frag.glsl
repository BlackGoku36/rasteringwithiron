#version 450

in vec3 Normal;
in vec3 Pos;

out vec4 FragColor;
uniform vec3 lightPos;
uniform vec3 cameraDir;

void main()
{

	float intensity;
	vec4 color;
	vec3 n = normalize(Normal);
	intensity = dot(vec3(lightPos),n);
	vec3 ambient = vec3(0.1, 0.1, 0.1);

	if (intensity > 1.0)
		color = vec4(vec3(0.2,0.2,1.0)+ambient,1.0);
	//else if (intensity > 0.5)
		//color = vec4(0.6,0.3,0.3,1.0);
	//else if (intensity > 0.25)
		//color = vec4(0.4,0.2,0.2,1.0);
	else
		color = vec4(vec3(0.0,0.0,0.5)+ambient,1.0);
	FragColor = color;

}