Shader"Custom/Dissolve"
{
    Properties
    {
        [HDR]_Color ("Color", Color) = (1,1,1,1)
        [HDR]_DissolveColor ("DissolveColor", Color) =(1, 1, 1, 1)
        [ParRendererData]_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DisolveTex ("DisolveTex", 2D) = "white" {}
        _DissolveAmount ("DissolveAmount", Range(0, 1)) = 0.5
        _DissolveRange("DissolveRange", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        blend
        SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DissolveTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _DissolveColor;
            float _DissolveAmount;
            float _DissolveRange;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color * _Color;
                return o;
            }

            float remap(float value, float inMin, float inMax, float outMin, float outMax)
            {
                return (value - inMin) * ((outMax - outMin) / (inMax - inMin)) + outMin;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 color = tex2D(_MainTex, i.uv);
    
                float DissolveAlpha = tex2D(_DissolveTex, i.uv).r;
                DissolveAlpha -= 0.001;
                _DissolveAmount = remap(_DissolveAmount, 0, 1, -_DissolveRange, 1);
                if (DissolveAlpha < _DissolveAmount + _DissolveRange)
                {
                    color.rgb = _DissolveColor.rgb;
                }
    
                if (DissolveAlpha < _DissolveAmount)
                {
                    color.a = 0;
                }
                
                color.rgb *= color.a;
                return color;
            }
            ENDCG
        }
    }
}