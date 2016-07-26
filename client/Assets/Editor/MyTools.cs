using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Xml;
using UnityEngine.UI;

static public class MyTools {

    [MenuItem("MyTools/GetPath", false, 1)]
    static public void Create()
    {
        foreach (GameObject o in Selection.gameObjects)
        {
            string str = o.name;
            Transform t = o.transform.parent;
            while(t.parent!=null)
            {
                str = t.name + "/" + str;
                t = t.parent;
            }

            Debug.Log(str);
        }
        
    }
}
