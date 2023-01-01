Shader "Custom/MultiLighting"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
    }
        SubShader
    {
        Tags
        {
            "LightMode" = "ForwardBase"
        }

        CGPROGRAM

        #progma vertex vert
        #progma fragment frag

        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float3 normal : TEXCOORD1;
        };

        float4 _Color;
        
        v2f vert(appdata_base v)
        {
            v2f o;

            o.vertex = UnityObjectToClipPos(v.vertex);
            o.normal = UnityObjectToWorldNormal(v.normal);

            return o;
        }

        fixed4 frag(v2f i) : SV_Target
        {

        }
        ENDCG
    }
}
