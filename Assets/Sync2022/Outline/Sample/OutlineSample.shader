Shader "Custom/OutlineSample"
{
    Properties
    {
        [ParRendererData]_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
        blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Sobel.cginc"

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
            float4 _MainTex_ST;
            float4 _Color;
            float4 _MainTex_TexelSize;
            float4 _OutlineColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            //half luminance(float4 color)
            //{
            //    return (color.r * 0.298912 + color.g * 0.586611 + color.b * 0.114478) * color.a;
            //}

            fixed4 frag (v2f i) : SV_Target
            {
                //float dx = _MainTex_TexelSize.x;
                //float dy = _MainTex_TexelSize.y;

                //            // そのPixelの周りの輝度で判定するため、現在のPixelの周りの色を求める
                //half4 c00 = tex2D(_MainTex, i.uv + half2(-dx, -dy));
                //half4 c01 = tex2D(_MainTex, i.uv + half2(-dx, 0.0));
                //half4 c02 = tex2D(_MainTex, i.uv + half2(-dx, dy));
    
                //half4 c10 = tex2D(_MainTex, i.uv + half2(0.0, -dy));
                //half4 c12 = tex2D(_MainTex, i.uv + half2(0.0, dy));
    
                //half4 c20 = tex2D(_MainTex, i.uv + half2(dx, -dy));
                //half4 c21 = tex2D(_MainTex, i.uv + half2(dx, 0.0));
                //half4 c22 = tex2D(_MainTex, i.uv + half2(dx, dy));

                //            // その周りの色をすべて輝度に変換する
                //half l00 = luminance(c00);
                //half l01 = luminance(c01);
                //half l02 = luminance(c02);
    
                //half l10 = luminance(c10);
                //half l12 = luminance(c12);
    
                //half l20 = luminance(c20);
                //half l21 = luminance(c21);
                //half l22 = luminance(c22);

                //            // 求めた色とカーネルを畳み込み演算する
                //half xLumi = l00 * -1.0 + l10 * -2.0 + l20 * -1.0 + l02 * 1.0 + l12 * 2.0 + l22 * 1.0;
                //half yLumi = l00 * -1.0 + l01 * -2.0 + l02 * -1.0 + l20 * 1.0 + l21 * 2.0 + l22 * 1.0;

                //            // 同様にAlphaも求める
                //half xAlpha = c00.a * -1.0 + c10.a * -2.0 + c20.a * -1.0 + c02.a * 1.0 + c12.a * 2.0 + c22.a * 1.0;
                //half yAlpha = c00.a * -1.0 + c01.a * -2.0 + c02.a * -1.0 + c20.a * 1.0 + c21.a * 2.0 + c22.a * 1.0;
    
                //            // 二乗和平方根で縦と横の値を合成する
                //half outlinePow = sqrt(xLumi * xLumi + yLumi * yLumi);
                //half outlineAlpha = sqrt(xAlpha + xAlpha + yAlpha + yAlpha);
    
                //            // 値の大きい方を求め0~1でクランプする
                //half outline = max(outlinePow, outlineAlpha);
                //outline = saturate(outline);
                half outline = sobel(_MainTex, _MainTex_TexelSize, i.uv);
    
                half4 color = half4(i.color.rgb, outline * i.color.a);
                return color;
            }
            ENDCG
        }
    }
}
