Shader "Custom/Oren-Nayar"
{
    // 表面の粗さを考慮した反射モデル
    // 勾配を標準偏差(σ)で定義する
    // p / PI (A + B C sinα tanβ) PI L(N・L)
    // A = 1 - 0.5 * σ^2 / (σ^2 + 0.33)
    // B = 0.45 * σ^2 / (σ^2 + 0.09)
    // C = max((V - N(N・V))・(L - N(N・L)), 0)
    // α = max(acos(N・L), acos(N・V))
    // β = min(acos(N・L), acos(N・V))

    Properties
    {
        _Albedo ("Albedo", Color) = (1, 1, 1, 1)
        _Roughness ("Roughness", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_Position;
                float3 normal : NORMAL;
                float4 vertexW : TEXCOORD0;
            };

            uniform fixed4 _LightColor0;
            uniform fixed4 _Albedo;
            uniform half _Roughness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.vertexW = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
    half3 normal = normalize(i.normal);
    half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
    half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.vertexW.xyz);
    
    half NdotL = saturate(dot(normal, lightDir));
    half NdotV = saturate(dot(normal, viewDir));
    
    half roughness = _Roughness * _Roughness;
    half roughnessSqr = roughness * roughness;
    
    // A = 1 - 0.5 * σ^2 / (σ^2 + 0.33)
    half A = 1.0 - 0.5 * roughnessSqr / (roughnessSqr + 0.33);
    // B = 0.45 * σ^2 / (σ^2 + 0.09)
    half B = 0.45 * roughnessSqr / (roughnessSqr + 0.09);
    // C = max((V - N(N・V))・(L - N(N・L)), 0)
    half C = saturate(dot(normalize(viewDir - normal * NdotV), normalize(lightDir - normal * NdotL)));
    
    half angleL = acos(NdotL);
    half angleV = acos(NdotV);
    // α = max(acos(N・L), acos(N・V))
    half alpha = max(angleL, angleV);
    // β = min(acos(N・L), acos(N・V))
    half beta = min(angleL, angleV);
    
    fixed3 diffuse = _Albedo.rgb * (A + B * C * sin(alpha) * tan(beta)) * _LightColor0.rgb * NdotL;
    
    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _Albedo.rgb;
    
    fixed4 color = fixed4(ambient + diffuse, 1.0);
    
    return color;
}
            ENDCG
        }
    }
}
