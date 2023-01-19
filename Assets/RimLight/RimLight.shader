Shader "Custom/RimLight"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            
            struct v2f
            {
                float4 vertex : SV_Position;
                float3 vertexW : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            float4 _MainColor;
            float _RimPower;

            v2f vert(appdata_base v)
            {
                v2f o;
    
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertexW = mul(unity_ObjectToWorld, v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW)
    
                float3 normal = normalize(i.normal);
                float3 light = normalize(_WorldSpaceLightPos0.w == 0 ? _WorldSpaceLightPos0.xyz : _WorldSpaceLightPos0.xyz - i.vertexW);
                float3 view = normalize(_WorldSpaceCameraPos - i.vertexW);
    
                float diffuse = saturate(dot(light, normal));
                float Rim = 1 - saturate(dot(light, normal));
                Rim *= 1 - saturate(dot(view, normal));
                Rim *= _RimPower;
                float3 ambient = ShadeSH9(half4(normal, 1));
    
                fixed4 color = diffuse * _MainColor * _LightColor0 * attenuation
                               + Rim * _MainColor * _LightColor0;
                color.rgb += ambient * _MainColor;
    
                return color;
            }
            ENDCG
        }
    }
}
