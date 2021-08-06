Shader "FX/S_FX_CardEadge_Alpha"
{
// ----------------------------------- Properties(Start) ----------------------------------- //
	Properties
	{
		_AppearRange("AppearRange", Range( -1 , 2)) = -1
		[Toggle]_InvertDirection("InvertDirection", Float) = 1
		[HDR]_MainCol("MainCol", Color) = (0,0.9882353,4,0)
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		[NoScaleOffset]_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseUv("NoiseUv", Vector) = (5,1,0,0)
		_NoiseSpeed("NoiseSpeed", Float) = 0.3
		_EdgeWidth("EdgeWidth", Float) = 12
		_EdgeFlowoff("EdgeFlowoff", Float) = 0.25
		_DistortionInt("DistortionInt", Float) = 0.1
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
			ZTest LEqual
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
			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
				
			};

			struct v2f
			{
				float4 clipPos : SV_POSITION;				
				float4 uv : TEXCOORD3;
			};
// ----------------------------------- Data(End)   ----------------------------------- //

// ----------------------------------- Variable(Start) ----------------------------------- //
			CBUFFER_START(UnityPerMaterial)
				float4 _MainCol;
				float4 _NoiseUv;
				float _InvertDirection;
				float _AppearRange;
				float _NoiseSpeed;
				float _DistortionInt;
				float _EdgeWidth;
				float _EdgeFlowoff;
			CBUFFER_END

			sampler2D _MainTex;
			sampler2D _NoiseTex;
// ----------------------------------- Variable(End)   ----------------------------------- //

// ----------------------------------- VS(Start) ----------------------------------- //
			v2f vs ( a2v v  )
			{
				v2f o = (v2f)0;

				o.uv.xy = v.uv.xy;
				
				o.uv.zw = 0;
				
				v.normal = v.normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				o.clipPos = positionCS;
				return o;
			}
// ----------------------------------- VS(End)   ----------------------------------- //
			
// ----------------------------------- PS(Start) ----------------------------------- //
			half4 ps ( v2f IN  ) : SV_Target
			{

				float2 uv = IN.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult68 = smoothstep( ( _AppearRange - 0.2 ) , _AppearRange , uv.x);
				float2 noise_uv = IN.uv.xy * _NoiseUv.xy + _NoiseUv.zw;
				

				float3 Color = _MainCol.rgb;
				float Alpha = ( (( _InvertDirection )?( ( 1.0 - smoothstepResult68 ) ):( smoothstepResult68 )) * saturate( ( pow( saturate( tex2D( _MainTex, ( uv + ( tex2D( _NoiseTex, ( noise_uv + ( _TimeParameters.x * _NoiseSpeed ) ) ).r * _DistortionInt ) ) ).r ) , _EdgeWidth ) * _EdgeFlowoff ) ) );
				

				return half4( Color, Alpha );
				
			}
// ----------------------------------- PS(End)   ----------------------------------- //
			ENDHLSL
		}	
	}
	// Fallback "Hidden/InternalErrorShader"	
}