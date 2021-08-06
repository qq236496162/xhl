Shader "FX/S_FX_CardEadge_add"
{
// ----------------------------------- Properties(Start) ----------------------------------- //
	Properties
	{
		_AppearPos("AppearPos", Range( -1 , 2)) = -1
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
// ----------------------------------- Pass Commands(Sstart) ----------------------------------- //
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One One, One OneMinusSrcAlpha
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
			struct a2f
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 clipPos : SV_POSITION;
				float4 uv3 : TEXCOORD3;

			};
// ----------------------------------- Data(End)   ----------------------------------- //

// ----------------------------------- Variable(Start) ----------------------------------- //
			CBUFFER_START(UnityPerMaterial)
				float4 _MainCol;
				float4 _NoiseUv;
				float _InvertDirection;
				float _AppearPos;
				float _NoiseSpeed;
				float _DistortionInt;
				float _EdgeWidth;
				float _EdgeFlowoff;
			CBUFFER_END
			sampler2D _MainTex;
			sampler2D _NoiseTex;
// ----------------------------------- Variable(End)   ----------------------------------- //

// ----------------------------------- VS(Start) ----------------------------------- //						
			v2f vs ( a2f v  )
			{
				v2f o = (v2f)0;
				o.uv3.xy = v.uv.xy;			
				o.uv3.zw = 0;
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

				float2 uv = IN.uv3.xy;
				float smoothstepResult68 = smoothstep( ( _AppearPos - 0.2 ) , _AppearPos , uv.x);
				float2 texCoord52 = uv * _NoiseUv.xy + _NoiseUv.zw;
				float3 Color = ( _MainCol * ( (( _InvertDirection )?( ( 1.0 - smoothstepResult68 ) ):( smoothstepResult68 )) * saturate( ( pow( saturate( tex2D( _MainTex, ( uv + ( tex2D( _NoiseTex, ( texCoord52 + ( _TimeParameters.x * _NoiseSpeed ) ) ).r * _DistortionInt ) ) ).r ) , _EdgeWidth ) * _EdgeFlowoff ) ) ) ).rgb;
				return half4( Color, 1 );
			}
// ----------------------------------- PS(End)   ----------------------------------- //
			ENDHLSL
		}	
	}	
}