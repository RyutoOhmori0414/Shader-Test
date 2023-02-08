using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Cinemachine;

public class DissolveFadeController : MonoBehaviour
{
    [Tooltip("パネル"), SerializeField]
    Image _fadePanel;
    [Tooltip("scene1 virtualCam"), SerializeField]
    CinemachineVirtualCamera _vc1;
    [Tooltip("scene2 virtualCam"), SerializeField]
    CinemachineVirtualCamera _vc2;
    [Tooltip("Anim"), SerializeField]
    Animator _animator;

    public void Fade()
    {
        StartCoroutine(ScreenShot());
    }

    IEnumerator ScreenShot()
    {
        yield return new WaitForEndOfFrame();

        // 画面をテクスチャに書き出す
        var tex = new Texture2D(Screen.width, Screen.height);
        tex.ReadPixels(new Rect(0, 0, Screen.width, Screen.height), 0, 0);
        tex.Apply();

        _fadePanel.enabled = true;
        _fadePanel.sprite = Sprite.Create(tex, new Rect(0, 0, tex.width, tex.height), Vector2.zero);
        _animator.Play("DissolveAnim");
        (_vc1.Priority, _vc2.Priority) = (_vc2.Priority, _vc1.Priority);
    }
}
