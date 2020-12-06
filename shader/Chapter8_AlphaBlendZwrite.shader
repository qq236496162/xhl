Shader "XHL/Chapter8_AlphaBlendZwrite"
{
    Properties
    {
        _Color("MainTint",Color) = (1,1,1,1)
        _MainTex("MainTex",2D) = "white"{}
        _AlphaScale("AlphaScale",range(0,1)) = 1
        _Gloss("Gloss",range(1,256)) =20
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

        pass{
            ZWrite On
            ColorMask 0
        }

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            Zwrite off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _AlphaScale;
            fixed _Gloss;
            
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
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

                fixed3 halfDir = normalize(worldLightDir+viewDir);

                fixed4 texColor = tex2D(_MainTex,i.uv);
                fixed3 lambert = max(0,dot(worldNormal,worldLightDir));
                fixed3 specular =max(0,dot(worldNormal,halfDir));   // Compute Specular
                specular = pow(specular,_Gloss);

                fixed3 outColor = lambert*texColor.rgb+specular;


                return fixed4(outColor,texColor.a*_AlphaScale);
                
            }
            ENDCG
        }
    }
}
