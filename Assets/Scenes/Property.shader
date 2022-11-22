Shader "Original/Property"
{
    Properties
    {
        // �C���X�y�N�^�[�Ń}�e���A����ҏW�ł���悤�ɂ��邽�߂ɂ́AProperties�̒��ɏ���
        // ShaderLab�Ƃ�������̂��߁u;�v���Ȃ������肷��
        _MainColor("Color", Color) = (1, 1, 1, 1)
        _Alpha("ColorAlpha", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100 // Level of Detail �ȒP�Ɍ����Ǝ��s����Ă���ɂ���ď�����ς��邱�Ƃ��ł���

        Pass
        {
            CGPROGRAM
            // vertex�V�F�[�_��fragment�V�F�[�_���s���֐������w��
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // vertex�V�F�[�_�Ŏ󂯎��\����
            struct appdata
            {
                float4 vertex : POSITION; // �Z�}���e�B�N�X,���̕ϐ��ɂ͂��̃f�[�^������݂����Ȃ���
            };
            
            // fragment�V�F�[�_�Ŏ󂯎��\����
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
