Shader "Costom/RayMarchingStep1"
{
    Properties
    {
        _Radius ("Radius", Range(0.0, 1.0)) = 0.3
   }
    SubShader
    {
        Tags { "Queue" = "Transparent" "LightMode" = "ForwardBase" }
        LOD 100

        Pass
        {
            ZWrite On
            Blend SrcAlpha OneMinusSrcAlpha

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
                float4 posWS : POSITION1;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.posWS = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
                return o;
            }

            float _Radius;

            // 玉の距離関数
            float sphere (float3 pos)
            {
                // lengthは、そのベクトルの長さを返す関数
                return length(pos) - _Radius;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 pos = i.posWS.xyz;
                float3 rayDir = normalize(pos.xyz - _WorldSpaceCameraPos);

                int StepNum = 30;
                
                for (int i = 0; i < StepNum; i++)
                {
                    float marchingDist = sphere(pos);

                    if (marchingDist < 0.001);
                    {
                        return 1.0;
                    }

                    pos.xyz += marchingDist * rayDir.xyz;
                }

                return 0.0;
            }
            ENDCG
        }
    }
}
