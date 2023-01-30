Shader"Custom/Toon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineCol ("OutlineColer", Color) = (1, 1, 1, 1)
        _OutlineWid ("OutlineWidth", Range(0.01, 0.1)) = 0.05
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _ShadeColor ("ShadeColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        // Outline
        Pass
        {
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            uniform fixed4 _OutlineCol;
            uniform half _OutlineWid;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            float4 vert (appdata v) : SV_Position
            {
                // 法線ベクトルの方向に加算することで頂点の位置を外側にずらすことができる
                v.vertex.xyz += v.normal * _OutlineWid;
                return UnityObjectToClipPos(v.vertex);
            }

            fixed4 frag () : SV_Target
            {
                return _OutlineCol;
            }
            ENDCG
        }

        // Cel
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

            uniform float4 _MainColor;
            uniform float4 _ShadeColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = normalize(mul(v.normal, unity_WorldToObject).xyz);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half3 normal = normalize(i.normal);
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
    
                half NdotL = saturate(dot(normal, lightDir));
    
                float4 color = _MainColor;
                color = NdotL > 0 ? color : color * _ShadeColor;
                return color;
            }
            ENDCG
        }
    }
}
