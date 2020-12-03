/*
RampTex 
*/

Shader "Unlit/000_template"
{
    Properties
    {
        _RampTex("RampTex",2D) = "white"{}
        _Gloss("Gloss",range(1.0,256)) = 20
        _Specular("Specular",Color) = (1,1,1,1)

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

            
            sampler2D _RampTex;
            float4 _RampTex_ST;
            float _Gloss;
            fixed4 _Specular;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.texcoord,_RampTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);  //Get WorldPosition
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));  //Get LigtDir(world)
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos)); //Get ViewDir(world)
                fixed3 halfDir = normalize(worldLightDir+viewDir);  // Compute HalfDir
                
                fixed3 specular =max(0,dot(worldNormal,halfDir));   // Compute Specular
                specular = pow(specular,_Gloss)*_Specular;    // Set Gloss;

                fixed3 lambert = dot(worldNormal,worldLightDir);    // Compute Lambert
                fixed3 halfLambert = lambert*0.5+0.5;   // Compute HalfLambert

                fixed2 uv = (halfLambert,halfLambert);  // Set RampTexture as uv
                fixed3 rampTex = tex2D(_RampTex,uv).rgb;    // Get RampTesture

                fixed3 color = rampTex + specular;

                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
