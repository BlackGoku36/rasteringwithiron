uniform float3x3 N;
uniform float4x4 P;
uniform float4x4 V;
uniform float4x4 W;

static float4 gl_Position;
static float2 TexCoords;
static float2 tex;
static float3 WorldPos;
static float3 pos;
static float3 Normal;
static float3 nor;

struct SPIRV_Cross_Input
{
    float3 nor : TEXCOORD0;
    float3 pos : TEXCOORD1;
    float2 tex : TEXCOORD2;
};

struct SPIRV_Cross_Output
{
    float3 Normal : TEXCOORD0;
    float2 TexCoords : TEXCOORD1;
    float3 WorldPos : TEXCOORD2;
    float4 gl_Position : SV_Position;
};

void vert_main()
{
    TexCoords = tex;
    WorldPos = float3(mul(pos, N));
    Normal = mul(nor, float3x3(float3(N[0].x, N[0].y, N[0].z), float3(N[1].x, N[1].y, N[1].z), float3(N[2].x, N[2].y, N[2].z)));
    gl_Position = mul(float4(WorldPos, 1.0f), mul(W, mul(V, P)));
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
    stage_output.TexCoords = TexCoords;
    stage_output.WorldPos = WorldPos;
    stage_output.Normal = Normal;
    return stage_output;
}
