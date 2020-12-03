Shader "Unlit/My15_MaskTexture"
{
    Properties
    {
        _MainTex ("MainTex",2D) = "white"{}
        _NormalTex ("NormalTex",2D) = "bump"{}
        _NormalScale("NormalScale",float) = 1.0
        _Gloss("Gloss",range(1.0,256)) =20
        _SpecularMask("SpecularMask",2D) = "white"{}
        _Specular("Specualr",range(0,10)) = 1.0
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


            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NormalTex;
            sampler2D _SpecularMask;
            float _NormalScale;            
            fixed _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;      // Set uv Tilling and offset
                float3 binormal = cross( v.normal,v.tangent.xyz) * v.tangent.w;     //Get binormal (v.tanget.w = face direction)
                float3x3 rotation = float3x3(v.tangent.xyz,binormal,v.normal);   // Rotation Matrix (obj - tangent)
                                         
                o.lightDir = mul(rotation,normalize(ObjSpaceLightDir(v.vertex).xyz)) ;// Get LightDir(Tangent)    (ObjeSpaceLightDir need normalize)
                o.viewDir = mul(rotation,normalize(ObjSpaceViewDir(v.vertex).xyz));// Get ViewDir(Tangent)  (ObjSpaceViewDir need normalize)

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 tangentLightDir = i.lightDir;    // Get LightDir(tangent)
                fixed3 tangentViewDir = i.viewDir;  //Get ViewDir(tangent)
                fixed3 halfDir = normalize(tangentLightDir+tangentViewDir); // Compute HalfDir

                fixed3 mainTex = tex2D(_MainTex,i.uv).rgb;  //Get MainTexture
                fixed specularMask = tex2D(_SpecularMask,i.uv).r * _Specular;   //Get SpecularMask Texture
                fixed3 tangentNormal = UnpackNormal(tex2D(_NormalTex,i.uv));    // Get Normal Texture
                tangentNormal.xy *= _NormalScale;   // Set Normal Scale
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy))); // Compute Normal.z;

                fixed3 lambert = max(0,dot(tangentNormal,tangentLightDir)); // Compute  Lambert
                fixed3 halfLambert = lambert*.5+0.5;    // Compute HalfLambert
                fixed3 specular = max(0,dot(tangentNormal,halfDir));    // Compute Specualr
                specular = pow(specular,_Gloss)*_Specular*specularMask; // Set Gloss  and * SpecularMask

                fixed3 color = (lambert+0.3)*mainTex+specular;


                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
