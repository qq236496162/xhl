Shader "XHL/S_CCC"
{
    Properties
    {
		_BaseMap("Base Map", 2D) = "white"
         _BaseColor("c01",Color) = (1,.5,0,1)
    }
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipeline"}
 
        Pass
        {           
            HLSLPROGRAM
            #pragma vertex vs
            #pragma fragment ps      
// -------------------------- Include(Start) -------------------------------------- //
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
// -------------------------- Include(End) -------------------------------------- //
                
// -------------------------- Data（Start） -------------------------------------- //
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv     : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv     : TEXCOORD0;
            };
// -------------------------- Data（End） -------------------------------------- //
            
// -------------------------- Variables（Start） -------------------------------------- //          
            //如果想要Shader和SRP Batcher兼容,需要将所有属性(texture 除外)定义在 UnityPerMaterial的CBUFFER块中。
			CBUFFER_START(UnityPerMaterial) 
				half4 _BaseColor; 
           		 float4 _BaseMap_ST;
			CBUFFER_END
            // 采样Texture 
            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);                
// -------------------------- Variables（End） -------------------------------------- //                
// ------------------------ VS(Start) ---------------------------------------- //
            v2f vs (a2v v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip( v.vertex.xyz);     
                o.uv = v.uv;
                return o;
            }
// ------------------------ VS(End) ---------------------------------------- //
            
// ------------------------ PS(Start) ---------------------------------------- //
            half4 ps (v2f i) : SV_Target
            {
                half4 tex = SAMPLE_TEXTURE2D(_BaseMap,sampler_BaseMap,i.uv);
                //return half4(1,.5,0,1);
                return tex;
            }
// ------------------------ PS(End) ---------------------------------------- //
            ENDHLSL
        }
    }
}