uniform float3 lightDir;
uniform float3 color;
uniform float3 lightCol;
Texture2D<float4> image;
SamplerState _image_sampler;

static float3 wnormal;
static float4 fragColor;

struct SPIRV_Cross_Input
{
    float3 wnormal : TEXCOORD0;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

void frag_main()
{
    float3 n = normalize(wnormal);
    float dotNL = max(0.0f, dot(n, lightDir));
    float3 direct = (color * max(0.0f, dotNL)) * lightCol;
    float3 indirect = 0.100000001490116119384765625f.xxx * color;
    fragColor = float4(direct + indirect, 1.0f);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    wnormal = stage_input.wnormal;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
