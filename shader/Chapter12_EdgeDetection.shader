﻿/*

*/

Shader "XHL/EdgeDetation"
{
    Properties
    {
        _MainTex("Base(RGB)",2D) = "white"{}
        _EdgeOnly("EdgeOnly",Float) = 1
        _EdgeColor("EdgeColor",Color) =(0,0,0,1)
        _BackgroundColor("BackgroundColor",Color) = (1,1,1,1)
    }
    SubShader
    {

        Pass
        {
            ZTest Always Cull off ZWrite off  // 后处理 标配
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            sampler2D _MainTex;
            half4 _MainTex_TexelSize; // 用于访问 纹理像素大小  如512 的texel = 1/512 = 0.01953
            fixed _EdgeOnly;
            fixed4 _EdgeColor;
            fixed4 _BackgroundColor;



            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv[9]: TEXCOORD0; // 9个相邻像素
            };


            v2f vert (appdata_img v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                half2 uv = v.texcoord;

                o.uv[0] = uv + _MainTex_TexelSize.xy*half2(-1,-1);
                o.uv[1] = uv + _MainTex_TexelSize.xy*half2(0,-1);
                o.uv[2] = uv + _MainTex_TexelSize.xy*half2(1,-1);
                o.uv[3] = uv + _MainTex_TexelSize.xy*half2(-1,0);
                o.uv[4] = uv + _MainTex_TexelSize.xy*half2(0,0);
                o.uv[5] = uv + _MainTex_TexelSize.xy*half2(1,0);
                o.uv[6] = uv + _MainTex_TexelSize.xy*half2(-1,1);
                o.uv[7] = uv + _MainTex_TexelSize.xy*half2(0,1);
                o.uv[8] = uv + _MainTex_TexelSize.xy*half2(1,1);


                return o;
            }

              // 去饱和度
            fixed desaturation(fixed4 image)
            {
                return 0.2125*image.r+0.7154*image.g+0.0721*image.b;
            }

            half Sobel(v2f i)
            {
                const half Gx[9] = {-1,-2,-1,
                                    0,0,0,
                                    1,2,1   };
                const half Gy[9] = {-1,0,1,
                                    -2,0,2,
                                    -1,0,1  };

                half texColor;
                half edgeX = 0;
                half edgeY = 0;
                for (int it = 0;it<9;it++){
                    texColor = desaturation(tex2D(_MainTex,i.uv[it]));
                    edgeX += texColor * Gx[it];
                    edgeY += texColor * Gy[it];
                }
                half edge = 1 - abs(edgeX) - abs(edgeY);

                return edge;
            }          

            fixed4 frag (v2f i) : SV_Target
            {
                half edge = Sobel(i);

                fixed4 withEdgeColor = lerp(_EdgeColor,tex2D(_MainTex,i.uv[4]),edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor,_BackgroundColor,edge);
                
                

                return lerp(withEdgeColor,onlyEdgeColor,_EdgeOnly);
            }
            

            ENDCG
        }
    }

    Fallback off
}
