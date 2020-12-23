Shader "XHL/ScreenWarp"
{
    Properties{
        _MainTex("MainTex",2d) = "gray"{}
        _Tex02("Tex02",2d) = "gray"{}
        _Color ("Color",Color) = (1,1,1,1)
        _Color2 ("Color2",Color) = (1,1,1,1)
        _Displacement("Displacement",range(0,1)) = 0
        _FresnelPow("FresnelPow",range(0.1,15)) = 2
    }

    SubShader
    {
        Tags{
        "Queue" = "Transparent"
		"RenderType" = "Transparent"
		"ForceNoShadowCasting" = "True"
		"IgnoreProjector" = "True"
	    }

        pass{
            Name "FORWARD_AB"

            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;            
            uniform fixed4 _Color;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;

            };

            struct v2f
            {
                float4 posCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.posCS = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // float2 uv = TRANSFORM_TEX(i.uv,_MainTex);  // 支持纹理的Tilling(默认方式)
                float2 uv = i.uv * _MainTex_ST.xy + _MainTex_ST.zw; // 手动些 Tilling
                fixed4 mainTex = tex2D(_MainTex,uv);
                // fixed3 final = mainTex;
                // return fixed4(final,_Color.a);
                return fixed4(mainTex.rgb*_Color.rgb,mainTex.a*_Color.a);
            }
            ENDCG
        }

        pass{
            Name "FORWARD_AB"

            Blend SrcColor One 

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _Tex02; uniform float4 _Tex02_ST;            
            uniform fixed4 _Color;
            uniform fixed4 _Color2;
            uniform fixed _Displacement;
            uniform fixed _FresnelPow;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 normal : NORMAL;
                float4 tangent : TANGENT;

            };

            struct v2f
            {
                float4 posCS : SV_POSITION;
                float4 posWS :  TEXCOORD0;
                float2 uv : TEXCOORD1;
                float3 nDirWS : TEXCOORD2;
                float3 tDirWS : TEXCOORD3;
                float3 bDirWS : TEXCOORD4;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                v.vertex.xyz +=v.normal*_Displacement;
                o.posCS = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld,v.vertex);    //  GET vertex WS
                o.uv = v.uv;

                o.nDirWS = UnityObjectToWorldNormal(v.normal);  //  GET nDir WS
                o.tDirWS = normalize( mul(unity_ObjectToWorld, float4(v.tangent.xyz,0.0)).xyz);  // GET tangent Dir WS
                o.bDirWS = normalize(  cross( o.nDirWS , o.tDirWS ) * v.tangent.w  );   // GET bitangent Dir WS

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // float2 uv = TRANSFORM_TEX(i.uv,_MainTex);  // 支持纹理的Tilling(默认方式)
                float2 uv = i.uv * _Tex02_ST.xy + _Tex02_ST.zw; // 手动些 Tilling
                fixed4 tex02 = tex2D(_Tex02,uv);

                
                
                float3 nDirWS = normalize(i.nDirWS);             // Transform NormalMap TS -> WS                
                float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);  // Compute vDir WS
                float3 vrDirWS = reflect( -vDirWS,nDirWS ); // Compute vrDir WS
                float ndotv = max(0,dot(nDirWS,vDirWS));   // Compute fresnel
                float3 fresnel = pow( 1.0-ndotv, _FresnelPow);

                fixed3 final = fresnel*50*_Color2;
                return fixed4(final,1);
                // return fixed4(tex02.rgb*_Color2.rgb,tex02.a*_Color2.a);
            }
            ENDCG
        }

    }

}
