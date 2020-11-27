/*
逐顶点 计算 漫反射照明
通过导入 Light.cginc
获得 灯光方向，颜色，环境光颜色
*/

Shader "XHL/C04"{
    properties{
        _Diffuse("Diffuse",Color)=(1,1,1,1)
    }

    SubShader{
        pass{
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            // 声明 参数
            fixed4 _Diffuse;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
            };

            // 顶点着色器
            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // Transform vertex  object -> projection space;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;  //Get ambient term

                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));  //transform the normal  abject -> world space;
                
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);    //Get LightDirection (world space)

                fixed3 diffuse = _LightColor0.rgb* _Diffuse.rgb * saturate(dot(worldNormal,worldLight));    //compute diffuse term

                o.color = ambient + diffuse;

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET{
                return fixed4(i.color,1.0);
            }


            ENDCG
        }
    }

}