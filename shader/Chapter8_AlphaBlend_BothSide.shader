/*
AlphaBlend 渲染 + 双面渲染
去除了 Lambert 照明


*/

Shader "XHL/AlphaBlend_BothSide"
{
    Properties
    {
        
        _MainTex("MainTex",2D) = "white"{}
        _Transparent("Transparent",range(0,1)) = 1
        
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            // Cull Front
            Cull Front
            Zwrite off
            Blend SrcAlpha OneMinusSrcAlpha // 透明度


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Transparent;
            

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD2;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 texColor = tex2D(_MainTex,i.uv);

                return fixed4(1,0,0,texColor.a*_Transparent);
            }
            ENDCG
        }

                Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            // Cull Front
            Cull Back
            Zwrite off
            Blend SrcAlpha OneMinusSrcAlpha // 透明度


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Transparent;
            

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD2;
            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 texColor = tex2D(_MainTex,i.uv);

                return fixed4(0,1,0,texColor.a*_Transparent);
            }
            ENDCG
        }
    }
}
