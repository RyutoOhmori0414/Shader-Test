using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteAlways]
public class OutlineImage : MonoBehaviour
{
    [SerializeField]
    Material _mat;
    [SerializeField]
    bool _isStatic = false;

    RawImage _rawImage;

    public RawImage RawImage
    {
        get 
        { 
            if (_rawImage == null)
            {
                _rawImage = GetComponent<RawImage>();
            } 

            return _rawImage;
        }
    }

    private void Awake()
    {
        if (!Application.isPlaying)
        {
            return;
        }

        if (_isStatic)
        {
            Capture();
        }
    }

    public void Capture()
    {
        if (TryGetComponent(out RawImage rawImage))
        {
            // TextureのサイズをもとにShaderを反映させたTextureを新たに生成している
            Texture tex = RawImage.mainTexture;
            float w = tex.width;
            float h = tex.height;

            RenderTexture rt = new RenderTexture((int)w, (int)h, 0, RenderTextureFormat.ARGBHalf);

            Graphics.Blit(tex, rt, _mat);
            rawImage.texture = rt;

            _mat = null;
            RawImage.material = null;
        }
    }

    private void OnValidate()
    {
        RawImage.material = _mat;
    }
}
