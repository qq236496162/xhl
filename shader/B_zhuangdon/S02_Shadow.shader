/*
阴影
*/

Shader "XHL/S02"
{

    SubShader
    {


        Pass
        {
            Tags { "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "AutoLight.cginc"  // 阴影需要的库
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows   // 阴影需要的声明


            struct a2v
            {
                float4 vertex : POSITION;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                LIGHTING_COORDS(0,1)    
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                TRANSFER_VERTEX_TO_FRAGMENT(o)

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 shadow = LIGHT_ATTENUATION(i);
                return fixed4(shadow,1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
