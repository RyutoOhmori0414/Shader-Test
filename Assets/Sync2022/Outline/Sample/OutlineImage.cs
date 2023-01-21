using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteAlways]
public class OutlineImage : MonoBehaviour
{
    [SerializeField]
    Material _mat;

    Image _image;

    public Image Image
    {
        get 
        { 
            if (_image == null)
            {
                _image = GetComponent<Image>();
            } 

            return _image;
        }
    }

    private void OnValidate()
    {
        if (TryGetComponent(out RawImage rawImage))
        {
            Texture tex = Image.mainTexture;
            float w = (transform as RectTransform).rect.width;
            float h = (transform as RectTransform).rect.height;

            RenderTexture rt = new RenderTexture((int)w, (int)h, 0, RenderTextureFormat.ARGBHalf);
            Graphics.Blit(tex, rt, _mat);
            rawImage.texture = rt;

            Destroy(_mat);
            _mat = null;
        }
    }
}
