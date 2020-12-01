/*
BlinnPhong 高光 (Vertex)
使用了内置函数计算LightDir  ViewDir( 注意需要 normalize)
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
                fixed3 color : COLOR;
            };



            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);  // Transform vertex ( obj -> clip )
                fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;   // Transform vertex( obj -> world )

                fixed3 normalDir = UnityObjectToWorldNormal(v.normal); // Transform normal (obj -> world)
                fixed3 lightDir =normalize( UnityWorldSpaceLightDir(worldPos)); //Get LightDir
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos)); //Get ViewDir
                fixed3 halfDir = normalize(lightDir+viewDir);   //Get HalfDir

                fixed3 lightColor = _LightColor0.rgb;   //Get LightColor
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;  //Get Ambient Color
                
                fixed3 lambert = dot(normalDir,lightDir);   // Compute Lambert
                fixed3 halfLambert = lambert*0.5+0.5;   // Compute HalfLambert
                fixed3 specular = _Specular.rgb * pow(saturate(dot(normalDir,halfDir)),_Gloss); // Compute Specular

                
                o.color = lightColor*lambert+ambient+specular;
                o.color = specular;
 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                return fixed4(i.color,1.0);
            }
            ENDCG
        }
    }
}
