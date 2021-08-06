using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CleanLightmap : MonoBehaviour {

    private MeshRenderer currentRenderer;

    
    private void OnEnable()
    {
        Awake();
    }

    private void Awake()
    {
        currentRenderer = gameObject.GetComponent<MeshRenderer>();
        RendererInfoTransfer();
    }

#if UNITY_EDITOR
    void OnBecameVisible()
    {
        RendererInfoTransfer();
    }
#endif

    void RendererInfoTransfer()
    {


        currentRenderer.lightmapIndex = -1;
        currentRenderer.lightmapScaleOffset =  new Vector4(1,1,0,0);
        currentRenderer.realtimeLightmapIndex = -1;
        currentRenderer.realtimeLightmapScaleOffset =  new Vector4(1,1,0,0);
        // currentRenderer.lightProbeUsage = lightmappedObject.lightProbeUsage;
    }
}
