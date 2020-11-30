/*
BlinnPhong 高光 (pixel)
使用了内置函数计算LightDir  ViewDir
*/


Shader "Unlit/My09_BlinnPhongSpecular_vertex01"
{
    Properties{
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",range(1.0,256)) = 20
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

            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };



            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);  // Transform vertex ( clip )                
                o.normalDir = UnityObjectToWorldNormal(v.normal); // Transform normal (obj -> world)
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; // Transform vertex ( obj -> world )

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 normalDir = i.normalDir; // Get NormalDir

                // fixed3 lightDir = _WorldSpaceLightPos0.xyz; //Get LightDir
                // fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos); //Get ViewDir

                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));   //Get LightDir
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos)); //Get ViewDir
                fixed3 halfDir = normalize(lightDir+viewDir);                
                

                fixed3 lightColor = _LightColor0.rgb;   //Get LightColor
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;  //Get Ambient Color
                
                fixed3 lambert = dot(normalDir,lightDir);   // Compute Lambert
                fixed3 halfLambert = lambert*0.5+0.5;   // Compute HalfLambert
                fixed3 specular = _Specular.rgb * pow(saturate(dot(halfDir,normalDir)),_Gloss); // Compute Specular

                
                // fixed3 color = lightColor*lambert+ambient+specular;
                
                fixed3 color = specular;
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
