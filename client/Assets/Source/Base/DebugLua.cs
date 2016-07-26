using UnityEngine;
using System.Collections;

public class DebugLua : MonoBehaviour {

    public string[] datas;
	
	void OnGUI()
    {
        for (int i = 0; i < datas.Length; i++)
        {
            object[] objs = LuaClient.CallFunRet("GetValueInfo", datas[i]);

            if (objs.Length > 0)
            {
                string value = objs[0] as string;
                GUI.Label(new Rect(0,i*20,800, 100), value);
            }            
        }
    }

}
