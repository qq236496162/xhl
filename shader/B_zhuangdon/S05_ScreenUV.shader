Shader "Chayan_Vinayak/S01_samplest"
{
    Properties
    {
        _MainTex("MainTex",2D) = "gray"{}
        _Opacity("Opacity",range(0,1)) = 0.5
        _ScreenTex("ScreenTex",2D) = "white"{}
    }

    SubShader
    {

        Pass
        {

            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform half4 _MainTex;   // 声明 公共变量 
            uniform half _Opacity;
            uniform sampler2D _ScreenTex; uniform float4 _ScreenTex_ST;
            
            // 顶点信息 输入
            struct vertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            // 顶点信息 输出
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 screenUV : TEXCOORD1;
            };

            // vertex-Shader
            vertexOutput vert (vertexInput v)
            {
                vertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex); // Transform vertexPos obj -> Clip
                o.uv = v.uv;

                float3 posVS = UnityObjectToViewPos(v.vertex).xyz;  // Transform vertexPos obj -> view
                o.screenUV = posVS.xy / posVS.z;    // VS 畸变矫正

                float originDist = UnityObjectToViewPos(float3(0.0,0.0,0.0)).z; // Transform origin obj -> view(物体的轴心)
                o.screenUV *= originDist; // 锁定纹理大小

                // o.screenUV = TRANSFORM_TEX(o.screenUV,_ScreenTex);  // 支持纹理的Tilling(默认方式)
                o.screenUV = o.screenUV * _ScreenTex_ST.xy+frac(_Time.x * _ScreenTex_ST.zw); // 手动些Tilling

                

                
                return o;
            }

            // fragment-Shader
            half4 frag (vertexOutput i) : COLOR
            {
                half3 var_ScreenTex = tex2D(_ScreenTex,i.screenUV);
                half3 final = var_ScreenTex;
                return half4 (final,1);
            }
            ENDCG
        }
    }
}
