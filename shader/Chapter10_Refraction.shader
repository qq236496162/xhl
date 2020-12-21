Shader "Unlit/Chapter10_Refraction "
{
    Properties
    {
        _ColorD("ColorDTint",Color) = (1,1,1,1)
        _ColorR("ColorRTint",Color) = (1,1,1,1)
        _Cubemap("Cubemap",Cube) = "_Skybox"{}
        _RefractAmount("RefractAmount",range(0,1)) = 1
        _RefractRatio("RefractRatio",range(0.1,1)) = 0.5
        _CubemapMip("Mipmap",range(0,9)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            samplerCUBE _Cubemap;
            float4 _ColorD;
            float4 _ColorR;
            float _CubemapMip;
            float _RefractRatio;
            float _RefractAmount;
                

            struct a2v
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;

            };

            struct v2f
            {
                float4 posCS : SV_POSITION;
                float4 posWS : TEXCOORD0;
                float3 nDirWS : TEXCOORD1;                
                float3 vDirWS : TEXCOORD2;
                float3 refrWS : TEXCOORD3;

            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.posCS = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld,v.vertex);    //  GET vertex WS
                o.nDirWS = UnityObjectToWorldNormal(v.normal);  //  GET nDir WS
                o.vDirWS = UnityWorldSpaceViewDir(o.posWS);
                o.refrWS = refract(-normalize(o.vDirWS), normalize(o.nDirWS),_RefractRatio);


                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.nDirWS);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.posWS));
                float3 vDir = normalize(i.vDirWS);
                // float3 vrDir = reflect( -vDir,nDir ); // Compute vrDir WS
                

                float3 refraction = texCUBElod(_Cubemap,float4(i.refrWS,_CubemapMip)).rgb;
                float3 lambert =  max(0,dot(nDir,lDir));

                float3 colorR = lerp(1,_ColorD*2,_RefractAmount);
                float3 final = lerp(lambert*_ColorD, refraction*2*_ColorR ,_RefractAmount);
                
                return fixed4(final,1.0);
                
            }
            ENDCG
        }
    }
}
