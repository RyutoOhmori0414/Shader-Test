Shader "Custom/fog"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FogColor ("FogColor", Color) = (1, 1, 1, 1)
        _FogStartValue ("FogStart", Range(0, 1)) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _CameraDepthTexture;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            fixed4 _FogColor;
            float _FogStartValue;

            fixed4 frag(v2f i) : SV_Target
            {
                half depth = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
                fixed4 color = tex2D(_MainTex, i.uv);
                color = lerp(color, _FogColor, (1 - depth) * (1 - depth));

                return color;
            }
            ENDCG
        }
    }
}
