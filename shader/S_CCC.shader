/*

*/

Shader "XHL/aaaaaaaaaaa"
{
    Properties
    {
        _spec("xxx",range(0.1,1.0)) = 0.5
    }
    SubShader
    {

        // Base Pass
        Pass {
            Tags{"LightMode" = "ForwardBase"}// 定义为基础pass
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "S_CCC_pass1.cginc"  // 导入打包的pass
            ENDCG
        }
        // Add Pass

        pass {
            Tags{ "LightMode" = "ForwardAdd"} // 定义为 add Pass
            Blend One One // 混合模式为 Add
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd // 需要定义这个

            #include "S_CCC_pass1.cginc" //  导入打包的pass

            ENDCG
        }
    }
}
