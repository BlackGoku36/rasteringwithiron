Texture2D<float4> normalMap;
SamplerState _normalMap_sampler;
Texture2D<float4> albedoMap;
SamplerState _albedoMap_sampler;
uniform float3 lightPos;
uniform float3 lightCol;
uniform float3 cameraPos;
Texture2D<float4> metallicMap;
SamplerState _metallicMap_sampler;
uniform float3 cameraDir;

static float2 TexCoords;
static float3 WorldPos;
static float3 Normal;
static float4 FragColor;

struct SPIRV_Cross_Input
{
    float3 Normal : TEXCOORD0;
    float2 TexCoords : TEXCOORD1;
    float3 WorldPos : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 FragColor : SV_Target0;
};

float3 getNormalFromMap()
{
    float3 tangentNormal = (normalMap.Sample(_normalMap_sampler, TexCoords).xyz * 2.0f) - 1.0f.xxx;
    float3 Q1 = ddx(WorldPos);
    float3 Q2 = ddy(WorldPos);
    float2 st1 = ddx(TexCoords);
    float2 st2 = ddy(TexCoords);
    float3 N = normalize(Normal);
    float3 T = normalize((Q1 * st2.y) - (Q2 * st1.y));
    float3 B = -normalize(cross(N, T));
    float3x3 TBN = float3x3(float3(T), float3(B), float3(N));
    return normalize(mul(tangentNormal, TBN));
}

void frag_main()
{
    float3 ambient = 0.20000000298023223876953125f.xxx * albedoMap.Sample(_albedoMap_sampler, TexCoords).xyz;
    float3 N = getNormalFromMap();
    float3 lightDir = normalize(lightPos - WorldPos);
    float diff = max(dot(N, lightDir), 0.0f);
    float3 diffuse = (lightCol * diff) * albedoMap.Sample(_albedoMap_sampler, TexCoords).xyz;
    float3 viewDir = normalize(cameraPos - WorldPos);
    float3 reflectDir = reflect(-lightDir, N);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0f), 0.300000011920928955078125f);
    float3 specular = (1.0f.xxx * spec) * metallicMap.Sample(_metallicMap_sampler, TexCoords).xyz;
    float3 result = (ambient + diffuse) + specular;
    FragColor = float4(result, 1.0f);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TexCoords = stage_input.TexCoords;
    WorldPos = stage_input.WorldPos;
    Normal = stage_input.Normal;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.FragColor = FragColor;
    return stage_output;
}
