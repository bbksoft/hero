using UnityEngine;
using System.Collections;

public class Shake : MonoBehaviour {

    public float power;
    public float time;

    Vector3 pos;

	// Use this for initialization
	void Start () {
        pos = transform.position;
    }

    // Update is called once per frame
    void Update() {
        if ((Time.deltaTime > 0)&&(time>0))
        {
            float x = Random.Range(-power, power);
            float y = Random.Range(-power, power);
            float z = Random.Range(-power, power);

            time -= Time.deltaTime;

            transform.position = pos + new Vector3(x, y, z);
        }    
	}
}
