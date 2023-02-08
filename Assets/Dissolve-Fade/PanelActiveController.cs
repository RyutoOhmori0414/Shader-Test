using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PanelActiveController : MonoBehaviour
{
    Image _image;

    private void Awake()
    {
        _image = GetComponent<Image>();
    }

    public void ImageFalse()
    {
        _image.enabled = false;
    }
}
