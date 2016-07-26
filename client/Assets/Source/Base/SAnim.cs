using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class SAnim : MonoBehaviour {

    public enum Type
    {
        pos,
        scale,
        rotate,
        Color,
        Alpha,
    }

    public Type    type = Type.pos;
    public Vector3  param = Vector3.one;
    public AnimationCurve curve;

    private float time = 0;
    private Vector3 oldCurverValue;
    
	// Use this for initialization
	void Start () {
        oldCurverValue = Vector3.zero;               
    }
	
	// Update is called once per frame
	void Update () {
        time += Time.deltaTime;       

        float v = 0;
        if (curve==null)
        {
            v = time;
        }
        else
        {
            v = curve.Evaluate(time);
        }

        Vector3 value = param * v;


        switch ( type )
        {
            case Type.pos:
                {
                    
                    transform.localPosition += value - oldCurverValue;
                }
                break;
            case Type.scale:
                {
                    transform.localScale += value - oldCurverValue;
                }
                break;
            case Type.rotate:
                {
                    transform.Rotate(value - oldCurverValue);
                }
                break;
            case Type.Color:
                {
                    MaskableGraphic t = GetComponent<MaskableGraphic>();

                    if (oldCurverValue == Vector3.zero)
                    {
                        oldCurverValue = new Vector3(t.color.r,t.color.g,t.color.b);
                    }
                   
                    value = value + oldCurverValue * (1-v);
                    t.color = new Color(value.x , value.y, value.z);

                    value = oldCurverValue;
                }
                break;
            case Type.Alpha:
                {
                    MaskableGraphic t = GetComponent<MaskableGraphic>();
                    t.CrossFadeAlpha(v, 0, false);
                }
                break;
        }
        oldCurverValue = value;
    }
}
