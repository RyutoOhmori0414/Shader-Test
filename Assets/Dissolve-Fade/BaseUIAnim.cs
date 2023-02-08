using System;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

[ExecuteAlways]
[RequireComponent(typeof(Graphic))]
public class BaseUIAnim : MonoBehaviour, IMaterialModifier
{
    // RawImage�̊��N���X��Texture��Material�̏��
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

    // SetMaterialDirty���Ă΂ꂽ��s��
    public Material GetModifiedMaterial(Material baseMaterial)
    {
        if (!isActiveAndEnabled || !_animGraphic)
        {
            return baseMaterial;
        }

        Debug.Log("GetModifiedMaterial(Material baseMaterial)���Ă΂�܂���");
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
        Debug.Log("OnDidApplyAnimationProperties()���Ă΂�܂���");
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
            // Editor���s���͑����ɔj�󂵂�������
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
