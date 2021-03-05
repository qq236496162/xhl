﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chapter12_EdgeDetaction : Chapter12_PostEffectsBase
{
    public Shader eDShader;
    private Material eDMaterial = null;
    public Material material
    {
        get
        {
            eDMaterial = CheckShaderAndCreateMaterial(eDShader, eDMaterial);
            return eDMaterial;
        }
    }

    [Range(0.0f, 1.0f)]
    public float edgesOnly = 0.0f;
    public Color edgeColor = Color.black;
    public Color backgroundColor = Color.white;

    void OnRenderImage(RenderTexture src,RenderTexture dest)
    {
        if(material != null)
        {
            material.SetFloat("_EdgeOnly", edgesOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BackgroundColor", backgroundColor);

            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
