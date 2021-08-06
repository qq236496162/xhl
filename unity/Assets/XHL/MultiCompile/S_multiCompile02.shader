 Shader "XHL/S_multiCompile02"
{
    Properties
    {
        
		_Main_Tex("Base Map", 2D) = "white"{}
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _GroundHeight("GroundHeight",Float) = 0
        _aaa("aaa",Float) = 1
        // [KeywordEnum(None,aa,bb)] _XHL("XHL", Int) = 0
        // [Toggle(_XHL_AA)]_AA("开启AA？",int) = 0
        // [Toggle(_XHL_BB)]_BB("开启BB？",int) = 0
        
    }
    SubShader
    {
        // Tags { "RenderPipeline" = "UniversalRenderPipeline" }
        Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

 
        Pass
        {
// -------------------------- PassCommands(Start) ------------------------------------ //       
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha    
            ZWrite Off
            HLSLPROGRAM
            // #pragma shader_feature __ _XHL_AA _XHL_BB
            #pragma multi_compile __ _XHL_AA _XHL_BB
            #pragma vertex vs
            #pragma fragment ps      
// -------------------------- PassCommands(End) -------------------------------------- //

// -------------------------- Include(Start) ------------------------------------ //
            // #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            // #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
// -------------------------- Include(End) -------------------------------------- //

// -------------------------- Data（Start） ------------------------------------ //
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
                float3 posWS  : TEXCOORD1;
                float3 lDir  : TEXCOORD2;
                float3 ccc : COLOR;
            };

// -------------------------- Data（End） -------------------------------------- //

// -------------------------- Variables（Start） ------------------------------------ //          


            // 纹理与采样器的分离定义:
            TEXTURE2D(_Main_Tex); 

            #define smp Linear_ClampV   // 自定义 采样设置
            SAMPLER(sampler_Main_Tex); // 读取贴图内的采样设置
            SAMPLER(smp); 

            //如果想要Shader和SRP Batcher兼容,需要将所有属性(texture 除外)定义在 UnityPerMaterial的CBUFFER块中。
			CBUFFER_START(UnityPerMaterial) 
                float4 _Main_Tex_ST;
                float4 _BaseColor;
                float _GroundHeight;
                float _aaa;
			CBUFFER_END
            
              
// -------------------------- Variables（End） -------------------------------------- //    

// -------------------------- Function（Start）  ----------------------------------
            float f01(){
                return 0;
            }
// -------------------------- Function（END）  ----------------------------------
           
// -------------------------- VS(Start) ---------------------------------------- //
            v2f vs (a2v v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip( v.vertex.xyz);  

                o.lDir = normalize(GetMainLight().direction);
                o.posWS = mul(unity_ObjectToWorld,v.vertex).xyz;    
                o.uv = v.uv;
                o.ccc = float3(1,.5,0);
                return o;
            }
// -------------------------- VS(End) ---------------------------------------- //

// -------------------------- PS(Start) ---------------------------------------- //
            half4 ps (v2f i) : SV_Target
            {
                float2 uv = i.uv * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
                half4 t01Tex=SAMPLE_TEXTURE2D(_Main_Tex,smp,uv);

                float3 final = i.ccc;
                #if defined _XHL_AA
                    return half4(0,1,0,1);
                #endif

                #if  defined _XHL_BB
                    return half4(0,1,1,1);
                #endif

                return half4(1,0.5,0,1);
                
            }
// -------------------------- PS(End) ---------------------------------------- //

            ENDHLSL
        }
    }
}