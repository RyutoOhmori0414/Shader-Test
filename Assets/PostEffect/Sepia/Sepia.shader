Shader "ImageEffect/Sepia"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SepiaColer ("SepiaColer", Color) = (0.19, -0.05, -0.22)
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            uniform float4 _SepiaColer;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // ‹P“x•ÏŠ·‚·‚é
                half l = dot(col.rgb, half3(0.30, 0.59, 0.11));
                col.rgb = saturate(l + _SepiaColer.rgb);
                return col;
            }
            ENDCG
        }
    }
}
