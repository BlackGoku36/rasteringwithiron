#version 450

in vec2 TexCoords;
in vec3 WorldPos;
in vec3 Normal;

out vec4 FragColor;

uniform vec3 cameraPos;
uniform vec3 lightPos;
//uniform vec3 lightDir;
uniform vec3 cameraDir;
uniform vec3 lightCol;

uniform sampler2D albedoMap;
uniform sampler2D metallicMap;
uniform sampler2D normalMap;

vec3 getNormalFromMap()
{
    vec3 tangentNormal = texture(normalMap, TexCoords).xyz * 2.0 - 1.0;

    vec3 Q1  = dFdx(WorldPos);
    vec3 Q2  = dFdy(WorldPos);
    vec2 st1 = dFdx(TexCoords);
    vec2 st2 = dFdy(TexCoords);

    vec3 N   = normalize(Normal);
    vec3 T  = normalize(Q1*st2.t - Q2*st1.t);
    vec3 B  = -normalize(cross(N, T));
    mat3 TBN = mat3(T, B, N);

    return normalize(TBN * tangentNormal);
}

void main(){
	vec3 ambient = vec3(0.2) * texture(albedoMap, TexCoords).rgb;

	vec3 N = getNormalFromMap();
	vec3 lightDir = normalize(lightPos - WorldPos);
	float diff = max(dot(N, lightDir), 0.0);
	vec3 diffuse = lightCol * diff*texture(albedoMap, TexCoords).rgb;

	vec3 viewDir = normalize(cameraPos - WorldPos);
	vec3 reflectDir = reflect(-lightDir, N);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 0.3);
	vec3 specular = vec3(1.0) * spec * texture(metallicMap, TexCoords).rgb;

	vec3 result = ambient + diffuse + specular;
	FragColor = vec4(result, 1.0);
}