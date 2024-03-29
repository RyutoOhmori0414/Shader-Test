Shader "Custom/BlendTest"
{
    Properties
    {
        [ParRendererData] _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
        }
        
        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_BlendOp]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
};

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _TextureSampleAdd;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float4 col = i.color * tex2D(_MainTex, i.uv + _TextureSampleAdd);
                
                return col * col.a;
            }
            ENDCG
        }
    }
}
