/*
最简单的 shader1
*/

Shader "XHL/C00a"{

    SubShader{
 
        pass{
            // Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag            
            #include "UnityCG.cginc"
            
            // 输入 结构体
            struct a2v{
                float4 vertex:POSITION;
            };
            // 输出 结构体
            struct v2f{
                float4 pos:SV_POSITION;
            };

            //顶点着色器
            v2f vert(a2v v){

                // 新建一个 输出 结构体
                v2f o = (v2f)0;

                //　把顶点　变换到　ClipPos
                o.pos = UnityObjectToClipPos(v.vertex);
                
                return o;
            }

            //像素着色器
            fixed4 frag(v2f i):SV_TARGET{
                // 用一个 颜色 填充
                return fixed4(1.0,0.5,0.0,1.0);

            }
            ENDCG
        }
    }

}