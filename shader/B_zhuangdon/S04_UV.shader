/*
UV move and disturb
*/

Shader "XHL/000_template"
{
    Properties
    {
        _Mask("Mask",2D) = "white"{}
        _Noise("Noise",2d) = "white"{}
        _Noise1Params("Noise1Params",vector) = (1.0,1.0,1.0,1.0)    // R :uv　　，G : spheed , B : Bright
        _Noise2Params("Noise2Params",vector) = (1.0,1.0,1.0,1.0)
        _Color1("C1",Color) = (1,1,0,1)
        _Color2("C2",Color) = (0,1,0,1)
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" 
        		"RenderType" = "TransparentCutout"
                "ForceNoShadowCasting" = "True"
                "IgnoreProjector" = "True"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            
            // 定义变量
            sampler2D _Mask;
            sampler2D _Noise;
            float3 _Noise1Params;
            float3 _Noise2Params;
            float3 _Color1;
            float3 _Color2;
            
            //输入结构
            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

            };
            // 输出结构
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0; // 给 mask 的uv
                float2 uv1 : TEXCOORD1; // 给 Noise1 的uv
                float2 uv2 : TEXCOORD2; // 给 Noise2 的uv
            };

            // 输入结构(a2v)　>> 顶点Shader (vert) >> 输出结构(v2f)
            // 把a2v 的信息拿来，加工，　输出给o　(v2f )
            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv0 = v.uv;
                o.uv1 = v.uv * _Noise1Params.x - float2(0.0,frac(_Time.x * _Noise1Params.y));
                o.uv2 = v.uv * _Noise2Params.x - float2(0.0,frac(_Time.x * _Noise2Params.y));


                return o;
            }
            
            // 输出结构　>> 像素
            //　把v2f 的信息 拿来，　加工　，　输出到屏幕
            fixed4 frag (v2f i) : SV_Target
            {
                fixed noise1 = tex2D(_Noise,i.uv1).r;
                fixed noise2 = tex2D(_Noise,i.uv2).g;
                fixed noise = noise1 * _Noise1Params.z + noise2 * _Noise2Params.z;
                float2 warpuv = i.uv0+ float2(0.0,noise);
                fixed3 mask = tex2D(_Mask,warpuv);

                fixed3 color = _Color1*mask.r+_Color2*mask.g;
                fixed3 final = color;
                fixed opacity = mask.b;
                clip(-opacity);
                return fixed4(final,opacity);
            }
            ENDCG
        }
    }
}
