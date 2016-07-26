using UnityEngine;
using System.Collections;
using UnityEngine.UI;


public class HPAnim : MonoBehaviour {

    public Slider back;
    public Slider hp;
    public float  speed = 0.3f;

    float value      = 1;
    float animValue  = 1;

    public void SetValue(float v)
    {
        value = v;
        hp.value = v;
        if (v > animValue)
        {
            animValue = v;
            back.value = v;
        }
    }

    public void SetValueAtOnce(float v)
    {
        value = v;
        hp.value = v;       
        animValue = v;
        back.value = v;        
    }
    

    // Update is called once per frame
    void Update () {
	    if (animValue > value)
        {
            float d = Time.deltaTime * speed;
            if (d>=(animValue-value))
            {
                animValue = value;
            }
            else
            {
                animValue -= d;
            }
            back.value = animValue;
        }
	}
}
