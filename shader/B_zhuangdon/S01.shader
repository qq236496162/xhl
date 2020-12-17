Shader "XHL/M01"
{

    Properties{
        _Gloss("GLOSS" ,range(1,255)) = 20
    }
    SubShader
    {
        pass{

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _Gloss;

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
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.posCS = UnityObjectToClipPos(v.vertex);       // vertex CS
                o.posWS = mul(unity_ObjectToWorld,v.vertex);    //  vertex WS
                o.nDirWS = UnityObjectToWorldNormal(v.normal);  //  nDir WS

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = i.nDirWS;                         // Get nDir WS
                float3 lDir = _WorldSpaceLightPos0.xyz;         // Get lDir WS
                float3 vDir = normalize(_WorldSpaceCameraPos.xyz - i.posWS);    // Get vDir WS
                float3 rDir = reflect(-lDir,nDir);              // Get rDir
                float3 hDir = normalize(vDir + lDir);           // Get hDir 

                float nDotl = dot(nDir,lDir);                   // Compute lambert
                float nDoth = dot(nDir, hDir);                  // Compute Specular (blinn phong)
                float vDotr = dot(vDir,rDir);                   // Compute Specular (phong)
                float vrDotl = dot(reflect(vDir,nDir),lDir);    // Compute Specular (phong another way)

                float lambert = max(0,nDotl);
                float specular = pow(max(0,vDotr),_Gloss);                 

                fixed3 finalRGB = lambert + specular;
                return fixed4(finalRGB,1.0);
            }
            ENDCG
        }

    }

}
