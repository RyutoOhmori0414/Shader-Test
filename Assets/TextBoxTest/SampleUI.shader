Shader "Custom/Wobble"
{
    Properties
    {
        // [PerRendererData]はRendererのMaterialPropertyBlockを参照する
        // 今回の場合はImageのSourceImageを_MainTexとして扱う
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)

        // ステンシルの値についてプロパティで設定している
        // マスクをできるそうです。これから勉強する
        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255

        // カラーマスクを設定できる
        // RGBAがそれぞれ8, 4, 2, 1ビット目を表すビットマスクを指定する
        // 15 = 1111なのでRGBAすべてに書き込める
        _ColorMask("Color Mask", Float) = 15

        // 01で透明な部分を切り抜くかどうかをしていする
        // [Toggle(UNITY_UI_ALPHCLIP)]でチェックボックスで01を決める
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0

            // 各頂点をどこまで動かすか
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


            // ここでプロパティで指定されたステンシルの設定値に設定する
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
            // カラーマスクのコマンド
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

                // 透明な部分を切り抜くかどうか
                #pragma multi_compile __ UNITY_UI_ALPHACLIP

                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float4 color    : COLOR;
                    float2 texcoord : TEXCOORD0;
                    // インスタンシングを行う場合に、
                    // uint instanceID : SV_InstanceID;
                    // という定義が行われる
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct v2f
                {
                    float4 vertex   : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 texcoord  : TEXCOORD0;
                    float4 worldPosition : TEXCOORD1;
                    // 簡単に言うと、VRなどで消費電力を軽減できる
                    UNITY_VERTEX_OUTPUT_STEREO
                };

                sampler2D _MainTex;
                fixed4 _Color;
                fixed4 _TextureSampleAdd;
                float4 _ClipRect;
                float4 _MainTex_ST;

                // propertiesを受ける変数
                fixed4 _MovePosition00;
                fixed4 _MovePosition01;
                fixed4 _MovePosition10;
                fixed4 _MovePosition11;
                half _Scale;
                // 何秒周期で変化を起こすのか
                half _CycleSec;

                v2f vert(appdata_t v)
                {
                    v2f OUT;
                    // インスタンシングをした際に、unity_ObjectToWorldや
                    // UnityObjectToClipPos()がインスタンスごとのものに自動的に書き換えられる
                    UNITY_SETUP_INSTANCE_ID(v);
                    // レンダリング先となるテクスチャ配列をGPUに伝える
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                    // texcoordとTimeから膨らませる位置を決定
                    // _CycleSecで決められた秒数で変化を起こし、
                    // それの絶対値を求めている
                    half cycle = abs(sin(((_Time / _CycleSec) / _CycleSec) * 360));
                    // saturate = 01Clamp
                    // 頂点の位置をUVで判断してxyにどの程度変化を加えるかを計算している
                    float4 target =
                      (_MovePosition00 * (saturate(1 - v.texcoord.x) * saturate(1 - v.texcoord.y))) +
                      (_MovePosition01 * (saturate(1 - v.texcoord.x) * saturate(v.texcoord.y))) +
                      (_MovePosition10 * (saturate(v.texcoord.x) * saturate(1 - v.texcoord.y))) +
                      (_MovePosition11 * (saturate(v.texcoord.x) * saturate(v.texcoord.y)));
                    // アニメーションさせた頂点に_Scaleをかけて反映させている
                    v.vertex.xy = v.vertex.xy + (target * cycle * _Scale).xy;
                    // 頂点を座標返還
                    OUT.worldPosition = v.vertex;
                    OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
                    // テクスチャスケールとオフセットが正しく適用する
                    OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                    // プロパティのカラーを乗算する
                    OUT.color = v.color * _Color;
                    return OUT;
                }

                fixed4 frag(v2f IN) : SV_Target
                {
                    // テクスチャを張り付ける
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