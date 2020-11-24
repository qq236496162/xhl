Shader "XHL/CCC01"{
    SubShader{
        Pass{
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            // 测试上传 Git 然而

            // 已经 push 成功  ， Hurray!!!
            float4 vert(float4 v: POSITION):SV_POSITION{
                return mul(UNITY_MATRIX_MVP,v);
            }

            fixed4 frag():SV_TARGET{
                return fixed4(1.0,1.0,1.0,1.0);
            }
            ENDCG
        }
    }
}

