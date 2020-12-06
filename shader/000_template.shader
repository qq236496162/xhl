/*

*/

Shader "XHL/000_template"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "Lighting.cginc"

            struct a2v
            {
                float4 vertex : POSITION;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                return fixed4(1.0,0.5,0.0,1.0);
            }
            ENDCG
        }
    }
}
