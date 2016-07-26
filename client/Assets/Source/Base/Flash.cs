using UnityEngine;
using System.Collections;

public class Flash : MonoBehaviour {

    public Material m;
    public float inval = 0.1f;
    public string value = "_Light";

    Renderer[] renders;
    Material[] ms;

    bool  doing;
    float flashTime;

    // Use this for initialization
    void Start () {
        

        Transform t = transform.parent;
        renders = t.GetComponentsInChildren<Renderer>();
        ms = new Material[renders.Length];
        for (int i = 0; i < renders.Length; i++)
        {
            if ("shadow" != renders[i].transform.name)
            {
                ms[i] = new Material(m);
                ms[i].mainTexture = renders[i].material.mainTexture;


                if (renders[i].material.HasProperty(value) && ms[i].HasProperty(value))
                { 
                    float a = renders[i].material.GetFloat(value);
                    ms[i].SetFloat(value, a);
                }
            }            
        }
        gameObject.SetActive(false);
    }

    void OnEnable()
    {
        if (renders != null)
        {            
            if (doing == false)
            { 
                for (int i = 0; i < renders.Length; i++)
                {
                    if (ms[i] != null)
                    {
                        Material temp = ms[i];
                        ms[i] = renders[i].material;
                        renders[i].material = temp;
                    }
                }
                doing = true;
            }
            flashTime = inval + Time.unscaledDeltaTime;
        }    
    }

	// Update is called once per frame
	void Update () {
        if (flashTime > 0)
        {
            flashTime -= Time.unscaledDeltaTime;
        }
        else
        { 
            if (doing)
            {
                for (int i = 0; i < renders.Length; i++)
                {
                    if (ms[i] != null)
                    {
                        Material temp = ms[i];
                        ms[i] = renders[i].material;
                        renders[i].material = temp;
                    }
                }
                doing = false;
            }
            gameObject.SetActive(false);
        }
	}
}
