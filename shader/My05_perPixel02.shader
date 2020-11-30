Shader "XHL/per_pixel_xhl01"
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
                float3 lightDir : TEXCOORD1;
                fixed3 color : COLOR;
            };



            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);  // Transform vertex

                o.normalDir = UnityObjectToWorldNormal(v.normal);   // Transform normal(obj->world)
                o.lightDir = _WorldSpaceLightPos0.xyz;  //Get LightDir
                
                o.color = dot (o.normalDir,o.lightDir); //Compute Lambert
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color,1.0);
            }
            ENDCG
        }
    }
}
