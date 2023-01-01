using UnityEngine;

public class CameraEffect : MonoBehaviour
{
    [Tooltip("エフェクトに使うマテリアル"), SerializeField]
    Material _material;

    private void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, _material);
    }
}
