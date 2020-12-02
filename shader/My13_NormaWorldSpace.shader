/*
世界空间 计算光照 基于法线贴图
使用了 ObjSpaceLightDir、ObjSpaceViewDir 计算LightDir , ViewDir

*/

Shader "Unlit/My13_NormaWorldSpace"
{
    Properties
    {
        _Color("Color_Tint",Color) = (1,1,1,1)
        _DiffuseTex("DiffuseMap",2D) = "white"{}
        _NormalTex("NormalMap",2D) = "bump"{}
        _NormalScale("NormalScale",Float) = 1.0
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(1.0,256)) = 20
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

            fixed4 _Color;
            sampler2D _DiffuseTex;
            float4 _DiffuseTex_ST;
            sampler2D _NormalTex;
            float4 _NormalTex_ST;
            float _NormalScale;
            fixed4 _Specular;
            float _Gloss;



            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                float4 TtoW0 : TEXCOORD1;
                float4 TtoW1 : TEXCOORD2;
                float4 TtoW2 : TEXCOORD3;
            };

            // 顶点着色器
            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);     //Transform Vertex (obj -> Clip)

                o.uv.xy = v.texcoord.xy * _DiffuseTex_ST.xy + _DiffuseTex_ST.zw;    // Diffuse's uv
                o.uv.zw = v.texcoord.xy * _NormalTex_ST.xy + _NormalTex_ST.zw;      // Normal's uv

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;             // Transform vertex( obj -> world )
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal,worldTangent) * v.tangent.w;

                o.TtoW0 = float4(worldTangent.x , worldBinormal.x , worldNormal.x , worldPos.x);
                o.TtoW1 = float4(worldTangent.y , worldBinormal.y , worldNormal.y , worldPos.y);
                o.TtoW2 = float4(worldTangent.z , worldBinormal.z , worldNormal.z , worldPos.z);
                

                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {          
                
                fixed3 normalTex = UnpackNormal(tex2D(_NormalTex,i.uv.zw)) ;   // Get Normal Map
                normalTex.xy *= _NormalScale;   
                normalTex.z = sqrt(1.0 - saturate(dot(normalTex.xy,normalTex.xy))); //Compute TangentNormal.z
                normalTex = normalize(half3( dot(i.TtoW0.xyz,normalTex) , dot(i.TtoW1.xyz,normalTex) , dot(i.TtoW1.xyz,normalTex )));

                fixed3 diffuseTex = tex2D(_DiffuseTex,i.uv).rgb * _Color.rgb;  // Get Diffuse Map

                float3 worldPos = float3(i.TtoW0.w,i.TtoW1.w,i.TtoW2.w);
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));   // Get LightDir(Tangent)
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos)); // Get ViewDir(Tangent)
                fixed3 halfDir = normalize(lightDir + viewDir); //Get halfDir(Tangent)



                

                fixed3 lambert = dot(normalTex,lightDir);   // Compute Lambert
                fixed3 specular = _Specular.rgb * pow(max(0,dot(normalTex,halfDir)),_Gloss);    // Compute Specular

                fixed3 color = lambert * diffuseTex + specular;
                
                return fixed4(halfDir,1.0);
            }
            ENDCG
        }
    }
}
