Shader "Custom/Wobble"
{
    Properties
    {
        // [PerRendererData]��Renderer��MaterialPropertyBlock���Q�Ƃ���
        // ����̏ꍇ��Image��SourceImage��_MainTex�Ƃ��Ĉ���
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)

        // �X�e���V���̒l�ɂ��ăv���p�e�B�Őݒ肵�Ă���
        // �}�X�N���ł��邻���ł��B���ꂩ��׋�����
        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255

        // �J���[�}�X�N��ݒ�ł���
        // RGBA�����ꂼ��8, 4, 2, 1�r�b�g�ڂ�\���r�b�g�}�X�N���w�肷��
        // 15 = 1111�Ȃ̂�RGBA���ׂĂɏ������߂�
        _ColorMask("Color Mask", Float) = 15

        // 01�œ����ȕ�����؂蔲�����ǂ��������Ă�����
        // [Toggle(UNITY_UI_ALPHCLIP)]�Ń`�F�b�N�{�b�N�X��01�����߂�
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0

            // �e���_���ǂ��܂œ�������
            _MovePosition00("Move Position 00", Vector) = (0, 0, 0, 0)
            _MovePosition01("Move Position 01", Vector) = (0, 0, 0, 0)
            _MovePosition10("Move Position 10", Vector) = (0, 0, 0, 0)
            _MovePosition11("Move Position 11", Vector) = (0, 0, 0, 0)
            _Scale("Scale", Float) = 10
            _CycleSec("Cycle Sec", Float) = 1
    }

        SubShader
        {
            Tags
            {
                "Queue" = "Transparent"
                "IgnoreProjector" = "True"
                "RenderType" = "Transparent"
                "PreviewType" = "Plane"
                "CanUseSpriteAtlas" = "True"
            }


            // �����Ńv���p�e�B�Ŏw�肳�ꂽ�X�e���V���̐ݒ�l�ɐݒ肷��
            Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
                ReadMask[_StencilReadMask]
                WriteMask[_StencilWriteMask]
            }

            Cull Off
            Lighting Off
            ZWrite Off
            ZTest[unity_GUIZTestMode]
            Blend SrcAlpha OneMinusSrcAlpha
            // �J���[�}�X�N�̃R�}���h
            ColorMask[_ColorMask]

            Pass
            {
                Name "Default"
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0

                #include "UnityCG.cginc"
                #include "UnityUI.cginc"

                #pragma multi_compile __ UNITY_UI_CLIP_RECT

                // �����ȕ�����؂蔲�����ǂ���
                #pragma multi_compile __ UNITY_UI_ALPHACLIP

                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float4 color    : COLOR;
                    float2 texcoord : TEXCOORD0;
                    // �C���X�^���V���O���s���ꍇ�ɁA
                    // uint instanceID : SV_InstanceID;
                    // �Ƃ�����`���s����
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct v2f
                {
                    float4 vertex   : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 texcoord  : TEXCOORD0;
                    float4 worldPosition : TEXCOORD1;
                    // �ȒP�Ɍ����ƁAVR�Ȃǂŏ���d�͂��y���ł���
                    UNITY_VERTEX_OUTPUT_STEREO
                };

                sampler2D _MainTex;
                fixed4 _Color;
                fixed4 _TextureSampleAdd;
                float4 _ClipRect;
                float4 _MainTex_ST;

                // properties���󂯂�ϐ�
                fixed4 _MovePosition00;
                fixed4 _MovePosition01;
                fixed4 _MovePosition10;
                fixed4 _MovePosition11;
                half _Scale;
                // ���b�����ŕω����N�����̂�
                half _CycleSec;

                v2f vert(appdata_t v)
                {
                    v2f OUT;
                    // �C���X�^���V���O�������ۂɁAunity_ObjectToWorld��
                    // UnityObjectToClipPos()���C���X�^���X���Ƃ̂��̂Ɏ����I�ɏ�����������
                    UNITY_SETUP_INSTANCE_ID(v);
                    // �����_�����O��ƂȂ�e�N�X�`���z���GPU�ɓ`����
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                    // texcoord��Time����c��܂���ʒu������
                    // _CycleSec�Ō��߂�ꂽ�b���ŕω����N�����A
                    // ����̐�Βl�����߂Ă���
                    half cycle = abs(sin(((_Time / _CycleSec) / _CycleSec) * 360));
                    // saturate = 01Clamp
                    // ���_�̈ʒu��UV�Ŕ��f����xy�ɂǂ̒��x�ω��������邩���v�Z���Ă���
                    float4 target =
                      (_MovePosition00 * (saturate(1 - v.texcoord.x) * saturate(1 - v.texcoord.y))) +
                      (_MovePosition01 * (saturate(1 - v.texcoord.x) * saturate(v.texcoord.y))) +
                      (_MovePosition10 * (saturate(v.texcoord.x) * saturate(1 - v.texcoord.y))) +
                      (_MovePosition11 * (saturate(v.texcoord.x) * saturate(v.texcoord.y)));
                    // �A�j���[�V�������������_��_Scale�������Ĕ��f�����Ă���
                    v.vertex.xy = v.vertex.xy + (target * cycle * _Scale).xy;
                    // ���_�����W�Ԋ�
                    OUT.worldPosition = v.vertex;
                    OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
                    // �e�N�X�`���X�P�[���ƃI�t�Z�b�g���������K�p����
                    OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                    // �v���p�e�B�̃J���[����Z����
                    OUT.color = v.color * _Color;
                    return OUT;
                }

                fixed4 frag(v2f IN) : SV_Target
                {
                    // �e�N�X�`���𒣂�t����
                    half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;

                    #ifdef UNITY_UI_CLIP_RECT
                    color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                    #endif

                    #ifdef UNITY_UI_ALPHACLIP
                    clip(color.a - 0.001);
                    #endif

                    return color;
                }
            ENDCG
            }
        }
}