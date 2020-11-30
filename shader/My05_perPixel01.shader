Shader "XHL/per_pixel"
{

    SubShader
    {

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"


            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;

            };



            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);  // Transform vertex

                o.normalDir = UnityObjectToWorldNormal(v.normal);   // Transform normal(obj->world)

                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 normalDir = i.normalDir;
                fixed3 lightDir = _WorldSpaceLightPos0.xyz;

                fixed3 lambert = dot(normalDir,lightDir);
                
                return fixed4(lambert,1.0);
            }
            ENDCG
        }
    }
}
