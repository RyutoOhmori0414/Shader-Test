Shader "Custom/Outline"
{
    Properties
    {
        [ParRendererData]_MainTex ("Texture", 2D) = "white" {}
        [HDR]_Color ("Color", Color) = (1, 1, 1, 1)
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

            // vertex�V�F�[�_(���_�V�F�[�_)�ɓ��͂Ƃ��ė^���炦��\����
            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            // vertex�V�F�[�_�̏o�͂�fragment�V�F�[�_�̓��͂Ŏg���\����
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

            // ���_�V�F�[�_���s���֐�
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color * _Color;
                return o;
            }

            // �F���P�x�ɕϊ�����֐�
            half luminance(float4 color)
            {
                return (color.r * 0.298912 + color.g * 0.586611 + color.b * 0.114478) * color.a;
            }

            // fragment�V�F�[�_���s���֐�
            fixed4 frag (v2f i) : SV_Target
            {
                // �e�N�X�`���� 1/width
                float dx = _MainTex_TexelSize.x;
                // �e�N�X�`���� 1/height
                float dy = _MainTex_TexelSize.y;
    
                // 1. �摜��\��������
                // fixed4 color = tex2D(_MainTex, i.uv);

                // 2. �A�E�g���C���ɕϊ�����
                half4 c00 = tex2D(_MainTex, i.uv + half2(-dx, -dy));
                half4 c01 = tex2D(_MainTex, i.uv + half2(-dx, 0.0));
                half4 c02 = tex2D(_MainTex, i.uv + half2(-dx, dy));
    
                half4 c10 = tex2D(_MainTex, i.uv + half2(0.0, -dy));
                half4 c12 = tex2D(_MainTex, i.uv + half2(0.0, dy));
    
                half4 c20 = tex2D(_MainTex, i.uv + half2(dx, -dy));
                half4 c21 = tex2D(_MainTex, i.uv + half2(dx, 0.0));
                half4 c22 = tex2D(_MainTex, i.uv + half2(dx, dy));
    
                half l00 = luminance(c00);
                half l01 = luminance(c01);
                half l02 = luminance(c02);
    
                half l10 = luminance(c10);
                half l12 = luminance(c12);
    
                half l20 = luminance(c20);
                half l21 = luminance(c21);
                half l22 = luminance(c22);
    
                // ���߂��F�ƃJ�[�l������ݍ��݉��Z����
                half xLumi = l00 * -1.0 + l10 * -2.0 + l20 * -1.0 + l02 * 1.0 + l12 * 2.0 + l22 * 1.0;
                half yLumi = l00 * -1.0 + l01 * -2.0 + l02 * -1.0 + l20 * 1.0 + l21 * 2.0 + l22 * 1.0;

                // ���l��Alpha�����߂�
                half xAlpha = c00.a * -1.0 + c10.a * -2.0 + c20.a * -1.0 + c02.a * 1.0 + c12.a * 2.0 + c22.a * 1.0;
                half yAlpha = c00.a * -1.0 + c01.a * -2.0 + c02.a * -1.0 + c20.a * 1.0 + c21.a * 2.0 + c22.a * 1.0;
                
                half outlinePow = sqrt(xLumi * xLumi + yLumi * yLumi);
                half outlineAlpha = sqrt(xAlpha * xAlpha + yAlpha * yAlpha);
                half outline = max(outlinePow, outlineAlpha);
                outline = saturate(outline);
                half4 color = half4(i.color.rgb, outline * i.color.a);
                return color;
            }
            ENDCG
        }
    }
}
