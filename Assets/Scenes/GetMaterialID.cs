using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetMaterialID : MonoBehaviour
{
    [SerializeField, Tooltip("このオブジェクトのマテリアル")]
    int _materialID;
    [SerializeField, Tooltip("このオブジェクトのレンダラー")]
    Renderer _renderer;
    [SerializeField, Tooltip("")]

    private void Start()
    {
        _materialID = _renderer.sharedMaterial.GetInstanceID();
    }

    public void GetInstance()
    {
        _renderer.material.SetColor("_Color", Color.red);
        _materialID = _renderer.material.GetInstanceID();
    }
}
