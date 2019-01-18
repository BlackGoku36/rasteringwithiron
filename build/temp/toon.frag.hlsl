uniform float3 lightPos;
uniform float3 lightDir;
uniform float3 cameraPos;
uniform float3 lightCol;
uniform float3 cameraDir;

static float3 Normal;
static float3 Pos;
static float4 FragColor;

struct SPIRV_Cross_Input
{
    float3 Normal : TEXCOORD0;
    float3 Pos : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 FragColor : SV_Target0;
};

void frag_main()
{
    float3 n = normalize(Normal);
    float intensity = dot(float3(lightPos), n);
    float _distance = length(lightPos - Pos);
    float3 R = (-lightDir) - (n * (2.0f * dot(n, -lightDir)));
    float cosTheta = clamp(dot(n, lightDir), 0.0f, 1.0f);
    float3 ambient = 0.100000001490116119384765625f.xxx;
    float3 viewDir = normalize(cameraPos - Pos);
    float3 reflectDir = reflect(-lightDir, n);
    float spec = pow(clamp(dot(viewDir, R), 0.0f, 1.0f), 32.0f);
    float3 specular = (0.20000000298023223876953125f.xxx * lightCol) * spec;
    float3 color;
    if (intensity > 1.0f)
    {
        color = float3(0.20000000298023223876953125f, 0.20000000298023223876953125f, 1.0f);
    }
    else
    {
        color = float3(0.0f, 0.0f, 0.5f);
    }
    float3 result = (color + specular) + ambient;
    FragColor = float4(result, 1.0f);
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    Normal = stage_input.Normal;
    Pos = stage_input.Pos;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.FragColor = FragColor;
    return stage_output;
}
