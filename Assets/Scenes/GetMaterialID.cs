using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetMaterialID : MonoBehaviour
{
    [SerializeField, Tooltip("���̃I�u�W�F�N�g�̃}�e���A��")]
    int _materialID;
    [SerializeField, Tooltip("���̃I�u�W�F�N�g�̃����_���[")]
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
