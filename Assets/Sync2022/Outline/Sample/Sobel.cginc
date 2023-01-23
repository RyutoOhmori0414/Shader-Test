#ifndef LIBRARY_SOBEL
#define LIBRARY_SOBEL

#include "UnityCG.cginc"

half luminance(float4 color)
{
    return (color.r * 0.298912 + color.g * 0.586611 + color.b * 0.114478) * color.a;
}

half sobel(sampler2D tex, float4 texTexelSize, float2 uv)
{
    float dx = texTexelSize.x;
    float dy = texTexelSize.y;
    
    half4 c00 = tex2D(tex, uv + half2(-dx, -dy));
    half4 c01 = tex2D(tex, uv + half2(-dx, 0.0));
    half4 c02 = tex2D(tex, uv + half2(-dx, dy));
    
    half4 c10 = tex2D(tex, uv + half2(0.0, -dy));
    half4 c12 = tex2D(tex, uv + half2(0.0, dy));
    
    half4 c20 = tex2D(tex, uv + half2(dx, -dy));
    half4 c21 = tex2D(tex, uv + half2(dx, 0.0));
    half4 c22 = tex2D(tex, uv + half2(dx, dy));

    half l00 = luminance(c00);
    half l01 = luminance(c01);
    half l02 = luminance(c02);
    
    half l10 = luminance(c10);
    half l12 = luminance(c12);
    
    half l20 = luminance(c20);
    half l21 = luminance(c21);
    half l22 = luminance(c22);

    half xLumi = l00 * -1.0 + l10 * -2.0 + l20 * -1.0 + l02 * 1.0 + l12 * 2.0 + l22 * 1.0;
    half yLumi = l00 * -1.0 + l01 * -2.0 + l02 * -1.0 + l20 * 1.0 + l21 * 2.0 + l22 * 1.0;
    
    half xAlpha = c00.a * -1.0 + c10.a * -2.0 + c20.a * -1.0 + c02.a * 1.0 + c12.a * 2.0 + c22.a * 1.0;
    half yAlpha = c00.a * -1.0 + c01.a * -2.0 + c02.a * -1.0 + c20.a * 1.0 + c21.a * 2.0 + c22.a * 1.0;
    
    half outlinePow = sqrt(xLumi * xLumi + yLumi * yLumi);
    half outlineAlpha = sqrt(xAlpha * xAlpha + yAlpha * yAlpha);
    
    return saturate(max(outlinePow, outlineAlpha));
}

#endif
