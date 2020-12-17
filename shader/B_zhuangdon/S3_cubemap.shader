Shader "XHL/M01"
{

    Properties{
        
        _FresnelInt("Fresnel",range(0,1)) = 1
        _FresnelPow("FresnelPow" ,range(1,10)) = 1
        _NormalMap("NormalMap",2D) = "bump"{}
        _Cubemap("Matcap",Cube) = "_skybox"{}
        _CubemapMip("CubemapMip",range(0,7)) = 0
    }
    SubShader
    {
        pass{

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

        float _FresnelInt ;
        float _FresnelPow ;
        float _CubemapMip ;
        sampler2D _NormalMap ;
        samplerCUBE _Cubemap ;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;

            };

            struct v2f
            {
                float4 posCS : SV_POSITION;
                float4 posWS : TEXCOORD0;
                float2 uv0 : TEXCOORD1;
                float3 nDirWS : TEXCOORD2;
                float3 tDirWS : TEXCOORD3;
                float3 bDirWS : TEXCOORD4;
            };


            v2f vert (a2v v)
            {   
                v2f o;  // Create a struct o

                o.uv0 = v.uv0;  // Get UV0
                o.posCS = UnityObjectToClipPos(v.vertex);       // GET vertex CS
                o.posWS = mul(unity_ObjectToWorld,v.vertex);    //  GET vertex WS
                o.nDirWS = UnityObjectToWorldNormal(v.normal);  //  GET nDir WS
                o.tDirWS = normalize( mul(unity_ObjectToWorld, float4(v.tangent.xyz,0.0)).xyz);  // GET tangent Dir WS
                o.bDirWS = normalize(  cross( o.nDirWS , o.tDirWS ) * v.tangent.w  );   // GET bitangent Dir WS

                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                float3 nDirTS = UnpackNormal(tex2D(_NormalMap,i.uv0)).rgb;  // Get Normalmap
                float3x3 TBN = float3x3(i.tDirWS,i.bDirWS,i.nDirWS);    // 用于 转换normal贴图 TS -> WS
                float3 nDirWS = normalize(  mul(nDirTS,TBN)  );             // Transform NormalMap TS -> WS                
                float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);  // Compute vDir WS
                float3 vrDirWS = reflect( -vDirWS,nDirWS ); // Compute vrDir WS

                
                float ndotv = max(0,dot(nDirWS,vDirWS));   // Compute fresnel

                float3 cubemap = texCUBElod(_Cubemap,float4(vrDirWS,_CubemapMip));
                float fresnel = pow( 1.0-ndotv, _FresnelPow);

                float3 final = cubemap * nDirTS.z*(fresnel+_FresnelInt);
                return fixed4(final,1.0);
                
            }
            ENDCG
        }

    }

}
