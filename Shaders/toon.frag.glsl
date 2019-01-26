#version 450

in vec3 Normal;
in vec3 Pos;

out vec4 FragColor;
uniform vec3 lightPos;
uniform vec3 lightCol;
uniform vec3 lightDir;
uniform vec3 cameraPos;

uniform int levels;
uniform vec3 diffusec;
uniform vec3 ao;

float scaleFactor = 1.0 / levels;

vec3 toonShade(){
	vec3 s = normalize(lightPos - Pos);
	float cosine = max(0.0, dot(s, Normal));
	vec3 diffuse = diffusec * ceil(cosine * levels) * scaleFactor;
	return lightCol * (ao + diffuse);
}

void main(){
	FragColor = vec4(toonShade(), 1.0);
}