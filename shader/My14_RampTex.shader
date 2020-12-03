Shader "Unlit/000_template"
{
    Properties
    {
        _RampTex("RampTex",2D) = "white"{}
        _Gloss("Gloss",range(1.0,256)) = 20

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
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(worldLightDir+viewDir);
                
                fixed3 specular =max(0,dot(worldNormal,halfDir));
                specular = pow(specular,_Gloss);

                fixed3 lambert = dot(worldNormal,worldLightDir);
                fixed3 halfLambert = lambert*0.5+0.5;

                fixed2 uv = (halfLambert,halfLambert);
                fixed3 rampTex = tex2D(_RampTex,uv).rgb;

                fixed3 color = rampTex + specular;

                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
