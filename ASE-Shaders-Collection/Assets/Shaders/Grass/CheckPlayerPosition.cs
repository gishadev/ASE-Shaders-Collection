using UnityEngine;

public class CheckPlayerPosition : MonoBehaviour
{
    public Transform playerTrans;

    Renderer _renderer;

    void Awake()
    {
        _renderer = GetComponent<Renderer>();
    }

    void Update()
    {
        _renderer.material.SetVector("_PlayerPosition", playerTrans.position);
    }
}
