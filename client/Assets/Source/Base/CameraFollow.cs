using UnityEngine;
using System.Collections;

public class CameraFollow : MonoBehaviour {

    public GameObject obj;
    
    public Vector3 off = new Vector3(15,15,15);

    // Use this for initialization
    void Start () {
	
	}

    // Update is called once per frame
    void Update() {
        if (obj != null)
        { 
            transform.position = obj.transform.position + off;
            transform.forward = -off;
        }
    }
}
