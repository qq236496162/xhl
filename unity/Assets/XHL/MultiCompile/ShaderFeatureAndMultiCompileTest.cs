using UnityEngine;
using UnityEngine.UI;

public class ShaderFeatureAndMultiCompileTest : MonoBehaviour
{

    // public Material _mat01; 
    // public Shader Shader;
    //  Material mat;
    //     void Start()
    // {
    //   mat = GetComponent<Renderer> ().material;
    //   Debug.Log("哈哈哈哈！！"); 

    // }


    private void OnGUI()
    {
        if (GUI.Button(new Rect(100, 100, 100, 80), "Enable_AA"))
        {
            Debug.Log("Enabling Keyword \"_XHL_AA\"");
            Shader.EnableKeyword("_XHL_AA");
            Shader.DisableKeyword("_XHL_BB");
            
            
        }
        if (GUI.Button(new Rect(250, 100, 100, 80), "Enable_BB"))
        {
            Debug.Log("Enabling Keyword \"_XHL_BB\"");
            Shader.EnableKeyword("_XHL_BB");
            Shader.DisableKeyword("_XHL_AA");
            
        }

        if (GUI.Button(new Rect(400, 100, 100, 80), "None"))
        {
            Debug.Log("Disable ALL Keyword ");
            Shader.DisableKeyword("_XHL_BB");
            Shader.DisableKeyword("_XHL_AA");
            
        }
    }
}