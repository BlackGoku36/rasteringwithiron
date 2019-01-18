uniform float3 cameraPos;
uniform float3 albedo;
uniform float metallic;
uniform float3 lightPos;
uniform float3 lightCol;
uniform float roughness;
uniform float ao;
uniform float3 lightDir;
uniform float3 cameraDir;

static float3 Normal;
static float3 WorldPos;
static float4 FragColor;

struct SPIRV_Cross_Input
{
    float3 Normal : TEXCOORD0;
    float3 WorldPos : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 FragColor : SV_Target0;
};

float DistributionGGX(float3 N, float3 H, float roughness_1)
{
    float a = roughness_1 * roughness_1;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0f);
    float NdotH2 = NdotH * NdotH;
    float nom = a2;
    float denom = (NdotH2 * (a2 - 1.0f)) + 1.0f;
    denom = (3.1415927410125732421875f * denom) * denom;
    return nom / max(denom, 0.001000000047497451305389404296875f);
}

float GeometrySchlickGGX(float NdotV, float roughness_1)
{
    float r = roughness_1 + 1.0f;
    float k = (r * r) / 8.0f;
    float nom = NdotV;
    float denom = (NdotV * (1.0f - k)) + k;
    return nom / denom;
}

float GeometrySmith(float3 N, float3 V, float3 L, float roughness_1)
{
    float NdotV = max(dot(N, V), 0.0f);
    float NdotL = max(dot(N, L), 0.0f);
    float param = NdotV;
    float param_1 = roughness_1;
    float ggx2 = GeometrySchlickGGX(param, param_1);
    float param_2 = NdotL;
    float param_3 = roughness_1;
    float ggx1 = GeometrySchlickGGX(param_2, param_3);
    return ggx1 * ggx2;
}

float3 fresnelSchlick(float cosTheta, float3 F0)
{
    return F0 + ((1.0f.xxx - F0) * pow(1.0f - cosTheta, 5.0f));
}

void frag_main()
{
    float3 N = normalize(Normal);
    float3 V = normalize(cameraPos - WorldPos);
    float3 F0 = 0.039999999105930328369140625f.xxx;
    F0 = lerp(F0, albedo, metallic.xxx);
    float3 Lo = 0.0f.xxx;
    float3 L = normalize(lightPos - WorldPos);
    float3 H = normalize(V + L);
    float _distance = length(lightPos - WorldPos);
    float attenuation = 1.0f / (_distance * _distance);
    float3 radiance = lightCol * attenuation;
    float3 param = N;
    float3 param_1 = H;
    float param_2 = roughness;
    float NDF = DistributionGGX(param, param_1, param_2);
    float3 param_3 = N;
    float3 param_4 = V;
    float3 param_5 = L;
    float param_6 = roughness;
    float G = GeometrySmith(param_3, param_4, param_5, param_6);
    float param_7 = clamp(dot(H, V), 0.0f, 1.0f);
    float3 param_8 = F0;
    float3 F = fresnelSchlick(param_7, param_8);
    float3 nominator = F * (NDF * G);
    float denominator = ((4.0f * max(dot(N, V), 0.0f)) * max(dot(N, L), 0.0f)) + 0.001000000047497451305389404296875f;
    float3 specular = nominator / max(denominator, 0.001000000047497451305389404296875f).xxx;
    float3 kS = F;
    float3 kD = 1.0f.xxx - kS;
    kD *= (1.0f - metallic);
    float NdotL = max(dot(N, L), 0.0f);
    Lo += (((((kD * albedo) / 3.1415927410125732421875f.xxx) + specular) * radiance) * NdotL);
    float3 ambient = (0.02999999932944774627685546875f.xxx * albedo) * ao;
    float3 color = ambient + Lo;
    color /= (color + 1.0f.xxx);
    color = pow(color, 0.4545454680919647216796875f.xxx);
    FragColor = float4(color, 1.0f);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    Normal = stage_input.Normal;
    WorldPos = stage_input.WorldPos;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.FragColor = FragColor;
    return stage_output;
}
