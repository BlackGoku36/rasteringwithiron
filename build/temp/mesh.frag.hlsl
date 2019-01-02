Texture2D<float4> image;
SamplerState _image_sampler;
uniform float3 lightColor;
uniform float3 lightDir;
uniform float3 cameraPos;

static float2 texcoords;
static float4 fragColor;
static float3 wnormal;
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
    float4 color = image.Sample(_image_sampler, texcoords);
    fragColor = float4(color.xyz, 1.0f);
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
