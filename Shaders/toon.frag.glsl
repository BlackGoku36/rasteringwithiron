#version 450

in vec3 Normal;
in vec3 Pos;

out vec4 FragColor;
uniform vec3 lightPos;
uniform vec3 lightCol;
uniform vec3 lightDir;
uniform vec3 cameraPos;

const int levels = 2;
const float scaleFactor = 1.0 / levels;
vec3 kD = vec3(1.0, 1.0, 1.0);//1.0, 0.4, 0.1 for orange //0.45, 0.65, 1.0 ugly blue
vec3 kA = vec3(0.1, 0.1, 0.2);

vec3 toonShade(){
	vec3 n = normalize(Normal);
	vec3 s = normalize(vec3(lightPos) - Pos);
	float cosine = max(0.0, dot(s, Normal));
	vec3 diffuse = kD * floor(cosine * levels) * scaleFactor;
	return lightCol * (kA + diffuse);
}

void main(){
	FragColor = vec4(toonShade(), 1.0);
}