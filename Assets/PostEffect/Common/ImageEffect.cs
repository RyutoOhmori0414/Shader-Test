using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways, RequireComponent(typeof(Camera))]
public class ImageEffect : MonoBehaviour
{
    [SerializeField]
    Material _material;

    /// <summary>
    /// �|�X�g�G�t�F�N�g���s�����߂ɁA�`�悪�I�������ɌĂ΂��
    /// </summary>
    /// <param name="source">��������O�̌���RenderTexture</param>
    /// <param name="destination">�������s�������RenderTexture</param>
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // _material��_MainTex�v���p�e�B��source����͂��A���̏o�͂�destination�ɕ`�悵�܂�
        Graphics.Blit(source, destination, _material);
    }
}
