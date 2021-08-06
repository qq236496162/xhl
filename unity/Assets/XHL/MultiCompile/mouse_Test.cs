using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mouse_Test : MonoBehaviour
{
    Material mat;
    // Start is called before the first frame update
    void Start()
    {
        mat = GetComponent<Renderer> ().material;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    void OnMouseDown(){
        mat.EnableKeyword("_XHL_AA");
         Debug.Log("Hahahahahah!!");
    }
       

}
