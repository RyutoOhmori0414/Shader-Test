#ifndef LIBRARY_INCLUDED
#define LIBRARY_INCLUDED

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
    float3 normal = normalize(i.normal);
    float3 light = normalize(_WorldSpaceLightPos0.xyz);

    float diffuse = saturate(dot(normal, light));

    float3 ambient = ShadeSH9(half4(normal, 1));

    fixed4 color = diffuse * _Color * _LightColor0;
    color.rgb += ambient * _Color;

    return color;
}
#endif