using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Unity.Rendering;
using UnityEngine.Rendering;

[ExecuteAlways]
public class BlendController : MonoBehaviour
{
    Material _material;
    [SerializeField]
    BlendMode _srcFactor = BlendMode.One;
    [SerializeField]
    BlendMode _dstFactor = BlendMode.One;
    [SerializeField]
    BlendOp _blendOp = BlendOp.Add;

    public Material Material
    {
        get { 
                if (!_material)
                {
                    _material = GetComponent<Graphic>().material;
                }

                return _material;
            }
    }

    // Update is called once per frame
    void OnValidate()
    {
        this.Material?.SetInt("_SrcFactor", (int)_srcFactor);
        this.Material?.SetInt("_DstFactor", (int)_dstFactor);
        this.Material?.SetInt("_BlendOp", (int)_blendOp);
    }
}
