using UnityEngine;
using System.Collections;
using UnityEngine.UI;


public class HPAnim : MonoBehaviour {

    public Slider back;
    public Slider hp;
    public float  speed = 0.1f;
    public float  max_speed = 2f;

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
            float s = (animValue - value) * max_speed;

            if (s <= speed)
            {
                s = speed;
            }

            float d = Time.deltaTime * s;
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
