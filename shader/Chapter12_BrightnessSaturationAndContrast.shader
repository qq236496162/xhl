/*

*/

Shader "XHL/000_template"
{
    Properties
    {
        _MainTex("Base(RGB)",2D) = "white"{}
        _Brightness("Brightness",Float) = 1
        _Saturation("Saturation",Float) =1
        _Contrast("Contrast",Float) = 1
    }
    SubShader
    {

        Pass
        {
            ZTest Always Cull off ZWrite off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            sampler2D _MainTex;
            half _Brightness;
            half _Saturation;
            half _Contrast;



            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv: TEXCOORD0;
            };


            v2f vert (appdata_img v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                return o;
            }

            // 去饱和度
            fixed desaturation(in fixed3 image)
            {
                fixed outimage =  0.2125*image.r+0.7154*image.g+0.0721*image.b;
                return outimage;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 renderTex = tex2D(_MainTex,i.uv);
                // brightness
                fixed3 finalColor = renderTex.rgb * _Brightness;
                // saturation
                // fixed luminance = 0.2125*renderTex.r+0.7154*renderTex.g+0.0721*renderTex.b;
                fixed luminance = desaturation(renderTex);
                
                fixed3 luminanceColor = fixed3(luminance,luminance,luminance);
                finalColor = lerp(luminanceColor,finalColor,_Saturation);
                
                // Contrast
                fixed3 avgColor = fixed3(0.5,0.5,0.5);
                finalColor = lerp(avgColor,finalColor,_Contrast);

                return fixed4(finalColor,renderTex.a);
            }
            ENDCG
        }
    }

    Fallback off
}
