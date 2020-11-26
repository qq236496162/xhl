Shader "XHL/C02"{
    // 参数集
    Properties{
        _Color("颜色1",Color) = (1.0,1.0,1.0,1.0)
    }

    SubShader{
        pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            // 定义变量
            fixed4 _Color;  

            //顶点输入
            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 texcoord:TEXCOORD0;
            };

            // 顶点输出
            struct v2f{
                float4 pos:SV_POSITION;
                fixed3 color:COLOR0;
            };

            // v2f vert(a2v v) {
            //     v2f o;
            //     o.pos = UnityObjectToClipPos(v.vertex);
            //     o.color = v.normal*0.5+fixed3(0.5,0.5,0.5);
            //     return o;
            // }
            void vert(in a2v v,out v2f o){
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.normal*0.5+fixed3(0.5,0.5,0.5);

            }

            fixed4 frag(v2f i) : SV_TARGET{
                fixed3 c = i.color;
                c *= _Color.rgb;
                return fixed4(c,1.0);
            }
            ENDCG
        }
    }

}