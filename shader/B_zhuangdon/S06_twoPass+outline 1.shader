Shader "XHL/ScreenWarp"
{
    Properties{
        _MainTex("MainTex",2d) = "gray"{}
        _Tex02("Tex02",2d) = "gray"{}
        _Color ("Color",Color) = (1,1,1,1)
        _Color2 ("Color2",Color) = (1,1,1,1)
        _Displacement("Displacement",range(0,1)) = 0
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

            Blend Zero Zero 
            Cull Front
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _Tex02; uniform float4 _Tex02_ST;            
            uniform fixed4 _Color;
            uniform fixed4 _Color2;
            uniform fixed _Displacement;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 normal : NORMAL;

            };

            struct v2f
            {
                float4 posCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                v.vertex.xyz +=v.normal*_Displacement;
                o.posCS = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // float2 uv = TRANSFORM_TEX(i.uv,_MainTex);  // 支持纹理的Tilling(默认方式)
                float2 uv = i.uv * _Tex02_ST.xy + _Tex02_ST.zw; // 手动些 Tilling
                fixed4 tex02 = tex2D(_Tex02,uv);
                // fixed3 final = mainTex;
                // return fixed4(final,_Color.a);
                return fixed4(tex02.rgb*_Color2.rgb,tex02.a*_Color2.a);
            }
            ENDCG
        }

    }

}
