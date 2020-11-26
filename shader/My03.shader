/*
通过 导入 UnityCG.cginc
获取模型信息： 法线，切线， 副法线，UV ， 顶点颜色
*/

Shader "XHL/C03"{

    SubShader{
        pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f{
                float4 pos:SV_POSITION;
                fixed4 color:COLOR0;
            };

            v2f vert(appdata_full v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);// 点变换　到Clip空间
                o.color = fixed4(v.normal*0.5+fixed3(0.5,0.5,0.5),1.0); //法线
                o.color = fixed4(v.tangent*0.5+fixed3(0.5,0.5,0.5),1.0); //切线

                fixed3 binormal = cross(v.normal,v.tangent.xyz)*v.tangent.w;//法线X切线 * 切线w ???
                o.color = fixed4(binormal*0.5+fixed3(0.5,0.5,0.5),1.0); //副切线

                o.color = fixed4(v.texcoord.xy,0.0,1.0);    // UV1
                o.color = fixed4(v.texcoord1.xy,0.0,1.0);    // UV2

                o.color = frac(v.texcoord);     // UV1的小数部分
                if(any (saturate(v.texcoord) - v.texcoord)){
                    o.color.b = 0.5;
                }
                o.color.a = 1.0;

                // o.color = v.color;  //顶点颜色

                return o;

            }

            fixed4 frag(v2f i):SV_TARGET{
                return i.color;
            }

            ENDCG
        }
    }

}