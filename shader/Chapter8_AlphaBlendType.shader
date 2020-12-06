/*
AlphaBlend 渲染 ，列出了所有 混合的方式
去除了 Lambert 照明


*/

Shader "XHL/AlphaBlend"
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
            Zwrite off
            Blend SrcAlpha OneMinusSrcAlpha // 透明度
            // Blend OneMinusDstColor One // 滤色 screen
            // Blend OneMinusDstColor One // 柔和相加 soft additive
            // Blend One One   // 线性减淡 Linear Dodge
            // Blend DstColor Zero     //正片叠底 Multiply
            // Blend Dstcolor SrcColor //两倍相乘 2x Multiply

            // BlendOp Max //变亮 Lighten
            // Blend One One

            // BlendOp min //变暗   Darken
            // Blend One One 

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


                return fixed4(texColor.rgb,texColor.a*_Transparent);
            }
            ENDCG
        }
    }
}
