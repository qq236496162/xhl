Shader "FX/S_FX_Distort"
{
// ----------------------------------- Properties(Start) ----------------------------------- //
	Properties
	{
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		[NoScaleOffset]_NoiseTex("NoiseTex", 2D) = "white" {}
		[HDR]_MainCol("MainCol", Color) = (1,1,1,0)
		_NoiseUv("NoiseUv", Vector) = (5,1,0,0)
		_NoiseSpeed("NoiseSpeed", Float) = 0.3
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
				float4 _NoiseUv;
				float _NoiseSpeed;
				float _DistortionInt;
				float4 _MainCol;
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

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				o.clipPos = positionCS;
				return o;
			}
// ----------------------------------- VS(End)   ----------------------------------- //
		
// ----------------------------------- PS(Start) ----------------------------------- //
			half4 ps ( v2f IN  ) : SV_Target
			{

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float2 uv = IN.uv.xy ;
				float2 texCoord52 = IN.uv.xy * _NoiseUv.xy + _NoiseUv.zw;
				float4 tex2DNode27 = tex2D( _MainTex, ( uv + ( tex2D( _NoiseTex, ( texCoord52 + ( _TimeParameters.x * _NoiseSpeed ) ) ).r * _DistortionInt ) ) );
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = tex2DNode27.rgb*_MainCol.rgb;
				float Alpha = tex2DNode27.a;


				return half4( Color, Alpha );
			}
// ----------------------------------- PS(End)   ----------------------------------- //
			ENDHLSL
		}


	
	}

	
}