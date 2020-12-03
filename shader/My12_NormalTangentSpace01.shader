/*
切线空间 计算光照 基于法线贴图
使用了 ObjSpaceLightDir、ObjSpaceViewDir 计算LightDir , ViewDir
使用 UnpackNormal 来做法线映射(0-1) -> (-1,1)    normalmap*2 -1  

*/

Shader "Unlit/My12_NormalTangentSpace"
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
                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            // 顶点着色器
            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);     //Transform Vertex (obj -> Clip)

                o.uv.xy = v.texcoord.xy * _DiffuseTex_ST.xy + _DiffuseTex_ST.zw;    // Diffuse's uv
                o.uv.zw = v.texcoord.xy * _NormalTex_ST.xy + _NormalTex_ST.zw;      // Normal's uv

                float3 binormal = cross( v.normal,v.tangent.xyz) * v.tangent.w;     //Get binormal (v.tanget.w = face direction)
                float3x3 rotation = float3x3(v.tangent.xyz,binormal,v.normal);   // Rotation Matrix (obj - tangent)

                o.lightDir = mul(rotation,normalize( ObjSpaceLightDir(v.vertex).xyz)).xyz;      // Get LightDir(Tangent)    (ObjeSpaceLightDir need normalize)
                o.viewDir = mul(rotation,normalize(ObjSpaceViewDir(v.vertex))).xyz;        // Get ViewDir(Tangent)  (ObjSpaceViewDir need normalize)
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 normalTex = UnpackNormal(tex2D(_NormalTex,i.uv.zw));   // Get Normal Map
                fixed3 diffuseTex = tex2D(_DiffuseTex,i.uv).rgb * _Color.rgb;  // Get Diffuse Map

                fixed3 lightDir = i.lightDir;   // Get LightDir(Tangent)
                fixed3 viewDir = i.viewDir; // Get ViewDir(Tangent)
                fixed3 halfDir = normalize(lightDir + viewDir); //Get halfDir(Tangent)

                fixed3 tangentNormal;   // Compute TantentNormal
                tangentNormal.xy = normalTex.xy * _NormalScale;    // Set normalmap Scale
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy))); //Compute TangentNormal.z                

                fixed3 lambert = dot(tangentNormal,lightDir);   // Compute Lambert
                fixed3 specular = _Specular.rgb * pow(max(0,dot(tangentNormal,halfDir)),_Gloss);    // Compute Specular

                fixed3 color = lambert * diffuseTex + specular;
                
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
