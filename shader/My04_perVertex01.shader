Shader "XHL/per_vertex"
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
                float4 vertex : SV_POSITION;
                fixed3 color : COLOR;
            };



            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);  // Transform vertex

                fixed3 normalDir = UnityObjectToWorldNormal(v.normal);  //Get NormalDir
                fixed3 lightDir = _WorldSpaceLightPos0.xyz; //Get LightDir

                fixed3 lambert = max(0.0,dot(lightDir,normalDir));  //Compute Lambert
                fixed3 halfLambert = dot(lightDir,normalDir)*.5+.5; //Compute HalfLambert
                o.color = lambert;
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
