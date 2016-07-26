using UnityEngine;
using UnityEngine.EventSystems;
using LuaInterface;
using UnityEngine.UI;

public class UIDragFun : MonoBehaviour, IBeginDragHandler, 
    IDragHandler, IEndDragHandler, IPointerDownHandler, IPointerUpHandler
{
    public LuaFunction fun;
    public RectTransform cancel;
    

    void Start()
    {
        
    }

    public void OnBeginDrag(PointerEventData data)
    {
        Vector3 pos = GetWorldPos(data);
        fun.Call("begin",pos);
    }

    public void OnDrag(PointerEventData data)
    {
        Vector3 pos = GetWorldPos(data);
        fun.Call("move",pos);
    }

    public void OnEndDrag(PointerEventData data)
    {
        Vector3 pos = GetWorldPos(data);
        fun.Call("end",pos);
    }

    public Vector3 GetWorldPos(PointerEventData data)
    {
        Ray r = Camera.main.ScreenPointToRay(data.position);
        Vector3 pos = r.origin - r.direction * r.origin.y / r.direction.y;

        return pos;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        fun.Call("down");
        if (cancel != null)
        {
            cancel.gameObject.SetActive(true);
        }            
    }

    public void OnPointerUp(PointerEventData eventData)
    {        if (cancel != null)
        {
            cancel.gameObject.SetActive(false);
            Vector2 localPos;
            if (RectTransformUtility.ScreenPointToLocalPointInRectangle(
                cancel, eventData.position, eventData.pressEventCamera, out localPos))
            {
                if (cancel.rect.Contains(localPos))
                {
                    fun.Call("cancel");
                    return;
                }
            }
        }      
        

        fun.Call("up");
    }
}
