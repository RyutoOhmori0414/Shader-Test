Shader "Original/Property"
{
    Properties
    {
        // インスペクターでマテリアルを編集できるようにするためには、Propertiesの中に書く
        // ShaderLabという言語のため「;」がなかったりする
        _MainColor("Color", Color) = (1, 1, 1, 1)
        _Alpha("ColorAlpha", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100 // Level of Detail 簡単に言うと実行されてる環境によって処理を変えることができる

        Pass
        {
            CGPROGRAM
            // vertexシェーダとfragmentシェーダを行う関数名を指定
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // vertexシェーダで受け取る構造体
            struct appdata
            {
                float4 vertex : POSITION; // セマンティクス,この変数にはこのデータを入れるみたいなこと
            };
            
            // fragmentシェーダで受け取る構造体
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            fixed4 _MainColor;
            float _Alpha;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = fixed4(_MainColor.r, _MainColor.g, _MainColor.b, 0);
                return col;
            }
            ENDCG
        }
    }
}
