
Shader "FX/S_FX_LightFlow_ZTest_Always"
{
// ----------------------------------- Properties(Start) ----------------------------------- //
	Properties
	{
		[NoScaleOffset]_MaskTex("MaskTex", 2D) = "white" {}
		[HDR]_MainCol("MainCol", Color) = (1,1,1,0)
		_Uv("Uv", Vector) = (1,1,0,0)
	}
// ----------------------------------- Properties(End)   ----------------------------------- //
	SubShader
	{
// ----------------------------------- SubShader Commands(Start) ----------------------------------- //
		LOD 0		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }		
		Cull Back
		AlphaToMask Off
// ----------------------------------- SubShader Commands(End)   ----------------------------------- //		

		Pass
		{
// ----------------------------------- Pass Commands(Start) ----------------------------------- //					
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest Always
			Offset 0 , 0
			ColorMask RGBA
// ----------------------------------- Pass Commands(End)   ----------------------------------- //		

			HLSLPROGRAM
// ----------------------------------- Include(Start) ----------------------------------- //
			#pragma vertex vs
			#pragma fragment ps
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
// ----------------------------------- Include(End)   ----------------------------------- //
			
// ----------------------------------- Data(Start) ----------------------------------- //
			struct VertexInput
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;

			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 uv : TEXCOORD3;

			};
// ----------------------------------- Data(End)   ----------------------------------- //

// ----------------------------------- Variable(Start) ----------------------------------- //
			CBUFFER_START(UnityPerMaterial)
				float4 _MainCol;
				float4 _Uv;
			CBUFFER_END
			sampler2D _MaskTex;
// ----------------------------------- Variable(End)   ----------------------------------- //

// ---------------------------------- VS(Start) ----------------------------------- //						
			VertexOutput vs ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				o.uv.xy = v.uv.xy;				
				o.uv.zw = 0;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );
				o.clipPos = positionCS;
				return o;
			}
// ----------------------------------- VS(End)   ----------------------------------- //
			
// ----------------------------------- PS(Start) ----------------------------------- //
			half4 ps ( VertexOutput IN  ) : SV_Target
			{
				float2 uv = IN.uv.xy ;				

				float3 Color = _MainCol.rgb;
				float Alpha = tex2D( _MaskTex, ( ( uv * _Uv.xy ) + ( _Uv.zw * _TimeParameters.x ) ) ).r;


				return half4( Color, Alpha );
			}
// ----------------------------------- PS(End)   ----------------------------------- //
			ENDHLSL
		}
	}
}