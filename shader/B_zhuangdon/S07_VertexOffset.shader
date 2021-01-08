Shader "XHL/M01"
{
    Properties{
        _MoveRange("_MoveRange",range(0,1))=1
        _MoveSpeed("MoveSpeed",range(0,2)) = 0
    }

    SubShader
    {
        pass{

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform float _MoveRange;
            uniform float _MoveSpeed;
            struct a2v
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;

            };

            struct v2f
            {
                float4 posCS : SV_POSITION;
                float4 posWS : TEXCOORD0;
                float3 nDirWS : TEXCOORD1;
            };
            // 声明常量
            #define TWO_PI 2*3.1415926
            void Translation(inout float3 vertex){
                vertex.z += _MoveRange *sin( frac(_Time.z * _MoveSpeed)*TWO_PI);// frac 取时间的小数 0-0.9 *2*pi
            }
            void Scaling(inout float3 vertex){
                vertex *=1+ _MoveRange *sin( frac(_Time.z * _MoveSpeed)*TWO_PI);
            }
            void Rotation(inout float3 vertex){
                float angleY = _MoveRange *sin(frac(_Time.z * _MoveSpeed))*TWO_PI;

                float radY = radians(angleY); // 角度 -> 弧度
                // float sinY = sin(radY);  //分开写 
                // float cosY = cos(radY);
                float sinY,cosY =0;
                sincos(radY,sinY,cosY); // 合并写 性能好
                vertex.xz = float2 (
                    vertex.x * cosY - vertex.z *sinY, 
                    vertex.x * sinY + vertex.z * cosY
                );
            }

            // 输出 vert （输入）
            v2f vert (a2v v)
            {   
                v2f o;
                Rotation(v.vertex.xyz);
                o.posCS = UnityObjectToClipPos(v.vertex);       // vertex CS
                o.posWS = mul(unity_ObjectToWorld,v.vertex);    //  vertex WS
                o.nDirWS = UnityObjectToWorldNormal(v.normal);  //  nDir WS

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = i.nDirWS;                         // Get nDir WS
                float3 lDir = _WorldSpaceLightPos0.xyz;         // Get lDir WS
                float3 vDir = normalize(_WorldSpaceCameraPos.xyz - i.posWS);    // Get vDir WS
                float3 rDir = reflect(-lDir,nDir);              // Get rDir
                float3 hDir = normalize(vDir + lDir);           // Get hDir 

                float nDotl = dot(nDir,lDir);                   // Compute lambert
                float nDoth = dot(nDir, hDir);                  // Compute Specular (blinn phong)
                float vDotr = dot(vDir,rDir);                   // Compute Specular (phong)

                float lambert = max(0,nDotl);
                float specular = pow(max(0,vDotr),50);                 

                fixed3 finalRGB = lambert + specular;
                return fixed4(finalRGB,1.0);
            }
            ENDCG
        }

    }

}
