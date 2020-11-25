Shader "XHL/C01"{
    Properties{
        xxx ("颜色",Color) = (1.0,.5,0.0,1.0)
    }

    SubShader{
        pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            fixed4 xxx;

            struct a2v{
                float4 vertex:POSITION;
            };

            float4 vert(a2v v):SV_POSITION{
                return UnityObjectToClipPos (v.vertex);
            }

            fixed4 frag():SV_TARGET{
                // return fixed4(1.0,1.0,1.0,1.0);
                return xxx;
            }

            ENDCG
        }
    }
}