uniform float4x4 W;
uniform float4x4 P;
uniform float4x4 V;

static float4 gl_Position;
static float3 Normal;
static float3 nor;
static float3 Pos;
static float3 pos;

struct SPIRV_Cross_Input
{
    float3 nor : TEXCOORD0;
    float3 pos : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float3 Normal : TEXCOORD0;
    float3 Pos : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    Normal = mul(nor, float3x3(float3(W[0].x, W[0].y, W[0].z), float3(W[1].x, W[1].y, W[1].z), float3(W[2].x, W[2].y, W[2].z)));
    Pos = mul(pos, float3x3(float3(W[0].x, W[0].y, W[0].z), float3(W[1].x, W[1].y, W[1].z), float3(W[2].x, W[2].y, W[2].z)));
    gl_Position = mul(float4(pos, 1.0f), mul(W, mul(V, P)));
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    nor = stage_input.nor;
    pos = stage_input.pos;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.Normal = Normal;
    stage_output.Pos = Pos;
    return stage_output;
}
