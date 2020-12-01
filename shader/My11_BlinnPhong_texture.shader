/*
BlinnPhong 高光 (pixel)
使用 Texture
*/


Shader "Unlit/My11_BlinnPhong_texture"
{
    Properties{
        _Color("ColorTint",Color) = (1,1,1,1)
        _Tex("DiffuseTex",2D) = "white"{}
        _Gloos("Gloos",range(1.0,256)) = 20

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
            float _Gloos;
            sampler2D _Tex;
            float4 _Tex_ST;  // 变量名必须为 纹理变量名+_ST 用于控制 UV Tiling & offset

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0; 
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };



            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);  // Transform vertex ( clip )                
                o.normalDir = UnityObjectToWorldNormal(v.normal); // Transform normal (obj -> world)
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; // Transform vertex ( obj -> world )
                o.uv = v.texcoord.xy * _Tex_ST.xy + _Tex_ST.zw; // 添加UV的 Tiling 和 offset
                // o.uv = TRANSFORM_TEX(v.texcoord,_Tex);    // 与上面等价

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Get
                fixed3 normalDir = i.normalDir; // Get NormalDir
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));   //Get LightDir                                
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos)); // Get ViewDir
                fixed3 reflectionDir = reflect(-lightDir,normalDir);    // Get ReflectionDir
                fixed3 albedo = tex2D(_Tex,i.uv).rgb * _Color.rgb;  // Get Texture

                // Cmpute
                fixed3 specular = saturate(dot(viewDir,reflectionDir)); //Compute Specular
                fixed3 lambert = dot(normalDir,lightDir);   // Compute Lambert
                fixed3 halfLambert = lambert*0.5+0.5;   // Compute HalfLambert

                // Output
                fixed3 color = halfLambert*albedo+pow(specular,_Gloos);
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
