uniform float3x3 N;
uniform float4x4 M;
uniform float4x4 WVP;

static float4 gl_Position;
static float3 wnormal;
static float3 nor;
static float2 texcoords;
static float2 tex;
static float3 FragPos;
static float4 pos;

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
    wnormal = normalize(mul(nor, N));
    texcoords = tex;
    FragPos = float3(mul(float4(pos.xyz, 1.0f), M).xyz);
    gl_Position = mul(float4(pos.xyz, 1.0f), WVP);
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    nor = stage_input.nor;
    tex = stage_input.tex;
    pos = stage_input.pos;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.wnormal = wnormal;
    stage_output.texcoords = texcoords;
    stage_output.FragPos = FragPos;
    return stage_output;
}
