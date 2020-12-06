Shader "XHL/AlphaTest"
{
    Properties
    {

        _MainTex("MainTex",2D) = "white"{}
        _Cutoff("AlphaScale",range(0,1)) = 1
    }
    SubShader
    {
        Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}    
            cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Cutoff;

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

                fixed4 texColor = tex2D(_MainTex,i.uv);

                clip (texColor.w - _Cutoff);
                if ((texColor.w - _Cutoff) < 0.0){
                    discard;
                }

                fixed3 lambert = max(0,dot(worldNormal,worldLightDir));

                fixed3 outColor = lambert*texColor.rgb;


                return fixed4(outColor,1.0);
            }
            ENDCG
        }
    }
}

