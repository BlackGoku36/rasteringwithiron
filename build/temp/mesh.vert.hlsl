uniform float4x4 W;
uniform float4x4 P;
uniform float4x4 V;

static float4 gl_Position;
static float2 texcoords;
static float2 tex;
static float3 FragPos;
static float4 pos;
static float3 wnormal;
static float3 nor;

struct SPIRV_Cross_Input
{
    float3 nor : TEXCOORD0;
    float4 pos : TEXCOORD1;
    float2 tex : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float3 FragPos : TEXCOORD0;
    float2 texcoords : TEXCOORD1;
    float3 wnormal : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    texcoords = tex;
    FragPos = float3(mul(float4(pos.xyz, 1.0f), W).xyz);
    wnormal = mul(nor, float3x3(float3(W[0].x, W[0].y, W[0].z), float3(W[1].x, W[1].y, W[1].z), float3(W[2].x, W[2].y, W[2].z)));
    gl_Position = mul(float4(FragPos, 1.0f), mul(V, P));
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    tex = stage_input.tex;
    pos = stage_input.pos;
    nor = stage_input.nor;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.texcoords = texcoords;
    stage_output.FragPos = FragPos;
    stage_output.wnormal = wnormal;
    return stage_output;
}
