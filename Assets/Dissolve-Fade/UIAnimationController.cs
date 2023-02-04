using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class UIAnimationController : BaseUIAnim
{
    [SerializeField]
    Texture2D _dissolveTex;
    [SerializeField, Range(0, 1)]
    float _dissolveAmount = 0;
    [SerializeField, Range(0, 1)]
    float _dissolveRange = 0;
    [SerializeField, ColorUsage(false, true)]
    Color _glowColor;
    [SerializeField]
    Shader _shader;

    int _dissolveTexId = Shader.PropertyToID("_DissolveTex");
    int _dissolveAmountId = Shader.PropertyToID("_DissolveAmount");
    int _dissolveRangeId = Shader.PropertyToID("_DissolveRange");
    int _glowColorId = Shader.PropertyToID("_DissolveColor");

    protected override void UpdateMaterial(Material baseMaterial)
    {
        if (material == null)
        {
            material = new Material(_shader);
            material.CopyPropertiesFromMaterial(baseMaterial);
            material.hideFlags = HideFlags.HideAndDontSave;
        }

        material.SetTexture(_dissolveTexId, _dissolveTex);
        material.SetFloat(_dissolveAmountId, _dissolveAmount);
        material.SetFloat(_dissolveRangeId, _dissolveRange);
        material.SetColor(_glowColorId, _glowColor);
    }
}
