Texture2D<float4> albedoMap;
SamplerState _albedoMap_sampler;
Texture2D<float4> aoMap;
SamplerState _aoMap_sampler;
uniform float3 lightDir;
uniform float3 lightCol;

static float2 texcoords;
static float3 wnormal;
static float4 fragColor;
static float3 FragPos;

struct SPIRV_Cross_Input
{
    float3 FragPos : TEXCOORD0;
    float2 texcoords : TEXCOORD1;
    float3 wnormal : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

void frag_main()
{
    float3 tex = albedoMap.Sample(_albedoMap_sampler, texcoords).xyz;
    float tex2 = aoMap.Sample(_aoMap_sampler, texcoords).x;
    float3 n = normalize(wnormal);
    float dotNL = max(0.0f, dot(n, lightDir));
    float3 diffuse = (tex * max(0.0f, dotNL)) * lightCol;
    float3 ambient = (0.02999999932944774627685546875f.xxx * tex) * tex2;
    fragColor = float4(diffuse + ambient, 1.0f);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texcoords = stage_input.texcoords;
    wnormal = stage_input.wnormal;
    FragPos = stage_input.FragPos;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
