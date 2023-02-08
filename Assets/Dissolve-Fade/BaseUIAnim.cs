using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

[ExecuteAlways]
[RequireComponent(typeof(Graphic))]
public class BaseUIAnim : MonoBehaviour, IMaterialModifier
{
    // RawImageの基底クラスでTextureやMaterialの情報が
    [NonSerialized] Graphic _animGraphic;
    protected Material material;

    public Graphic AnimGraphic
    {
        get
        {
            if (_animGraphic == null)
            {
                _animGraphic = GetComponent<Graphic>();
            }

            return _animGraphic;
        }
    }

    // SetMaterialDirtyが呼ばれたら行う
    public Material GetModifiedMaterial(Material baseMaterial)
    {
        if (!isActiveAndEnabled || !_animGraphic)
        {
            return baseMaterial;
        }

        Debug.Log("GetModifiedMaterial(Material baseMaterial)が呼ばれました");
        UpdateMaterial(baseMaterial);
        return material;
    }

    private void OnDidApplyAnimationProperties()
    {
        if (!isActiveAndEnabled || !_animGraphic)
        {
            return;
        }

        _animGraphic.SetMaterialDirty();
        Debug.Log("OnDidApplyAnimationProperties()が呼ばれました");
    }

    protected virtual void UpdateMaterial(Material baseMaterial)
    {
    }

    protected void OnEnable()
    {
        if (!AnimGraphic)
        {
            return;
        }

        _animGraphic.SetMaterialDirty();
    }

    protected void OnDisable()
    {
        if (!material)
        {
            DestroyMaterial();
        }

        if (!AnimGraphic)
        {
            _animGraphic.SetMaterialDirty();
        }
    }

    public void DestroyMaterial()
    {
#if UNITY_EDITOR
        if (!EditorApplication.isPlaying)
        {
            // Editor実行時は即座に破壊したいため
            DestroyImmediate(material);
            material = null;
            return;
        }
#endif
        Destroy(material);
        material = null;
    }

    private void OnValidate()
    {
        if (!isActiveAndEnabled || AnimGraphic == null)
        {
            return;
        }

        AnimGraphic.SetMaterialDirty();
    }
}
