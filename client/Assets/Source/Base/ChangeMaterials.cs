using UnityEngine;
using System.Collections;

public class ChangeMaterials : MonoBehaviour {

    public Material m;

    // Use this for initialization
    void Start()
    {
        Transform t = transform.parent;
        Renderer[] renders = t.GetComponentsInChildren<Renderer>();

        for (int i = 0; i < renders.Length; i++)
        {
            if ("shadow" != renders[i].transform.name)
            {
                Material newM = new Material(m);
                newM.mainTexture = renders[i].material.mainTexture;
                renders[i].material = newM;
            }
        }
        Destroy(gameObject);
    }
}
