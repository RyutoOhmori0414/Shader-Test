Shader "Unlit/WorldSpaceNormals"
{
    SubShader
    {
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // UnityObjectToWorldNormal ヘルパー関数を含むファイルを含みます
            #include "UnityCG.cginc"

            struct v2f
            {
                // 標準の("texcoord")補完としてワールド座標を出力する
                half3 worldNormal : TEXCOORD0;
                float4 pos : SV_POSITION;
            };
            
            // 頂点シェーダー：入力としてオブジェクト空間法線も取ります
            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex); // 頂点をオブジェクト空間から画面へ変換するユーティリティ関数
                // UnityCG.cgincファイルは、法線をオブジェクトから
                // ワールド空間に変換する関数を含みます
                o.worldNormal = UnityObjectToWorldNormal(normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = 0;
                // 法線は、xyz成分を持つ3Dベクトル;範囲は-1～1
                // カラーとして表示するには、範囲は0～1にし、
                // 赤、緑、青の成分にします
                c.rgb = i.worldNormal * 0.5 + 0.5;
                return c;
            }
            ENDCG
        }
    }
}
