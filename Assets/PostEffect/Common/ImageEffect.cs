using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways, RequireComponent(typeof(Camera))]
public class ImageEffect : MonoBehaviour
{
    [SerializeField]
    Material _material;

    /// <summary>
    /// ポストエフェクトを行うために、描画が終わった後に呼ばれる
    /// </summary>
    /// <param name="source">処理する前の元のRenderTexture</param>
    /// <param name="destination">処理を行った後のRenderTexture</param>
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // _materialの_MainTexプロパティにsourceを入力し、その出力をdestinationに描画します
        Graphics.Blit(source, destination, _material);
    }
}
