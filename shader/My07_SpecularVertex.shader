/*
逐顶点 高光反射效果 
*/

Shader "XHL/C07"{
    // 可调　参数
    Properties{
        _Diffuse("Diffuse",Color) = (1,1,1,1)
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",range(8.0,256)) = 20
    }

    SubShader{
        
        pass{
            Tags{"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag 
            #include "Lighting.cginc" 

            //声明　参数　
            fixed4  _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            
            //顶点输入
            struct a2v{
                float4 vertex:POSITION;
                float4 normal:NORMAL;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
            };
            
            // 顶点着色器   
            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); // obj -> Clip

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;  // Get ambient light

                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject)); // Transform normal obj->world
                
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz); // Get Light direction(world)

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLightDir)); //Compute diffuse term

                fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal)); //Get reflect direction

                fixed viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld,v.vertex).xyz); //Get view direction

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir,viewDir)),_Gloss); //Compute specular term

                o.color = ambient + diffuse + specular;
                return o;

            }

            fixed4 frag(v2f i ):SV_TARGET{
                return fixed4(i.color,1.0);
            }

            ENDCG
        }
    }

}