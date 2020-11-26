/*
最简单的 shader
*/

Shader "XHL/C02"{
    // 可调　参数
    Properties{
        xxx("Color_01",Color) = (1.0,0.5,0.0,1.0)
    }
    SubShader{
 
        pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag            
            //声明　参数　
            fixed4  xxx;
            
            //顶点输入
            struct a2v{
                float4 vertex:POSITION;
            };

            //顶点着色器
            float4 vert(a2v v):SV_POSITION{
                //　把顶点　变换到　ClipPos
                return UnityObjectToClipPos(v.vertex);
            }
            //像素着色器

            fixed4 frag():SV_TARGET{
                // 给Frag 一个固定颜色　
                // return fixed4(1.0,.5,0.0,1.0);
                //使用　参数　
                return xxx;

            }
            ENDCG
        }
    }

}