/*
逐像素 计算 漫反射照明
*/
Shader "XHL/C05"{
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
                fixed3 worldNormal : TEXCOORD0;
                
            };

            // 顶点着色器
            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // Transform vertex  object -> projection space;
                
                o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);  //transform the normal  abject -> world space;
                
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET{
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;  // Get Ambient Light
                fixed3 worldNormal = normalize(i.worldNormal); // Get normal (world space)
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // Get Light Direction(world space)

                fixed3 diffuse  = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLightDir));   // Compute diffuse term
                fixed3 color = ambient + diffuse;

                return fixed4(color,1.0);

            }


            ENDCG
        }
    }

}