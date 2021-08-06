
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            float _spec;

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: NORMAL;

            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:TEXCOORD1;
                float3 wPos : TEXCOORD2;
                LIGHTING_COORDS(3,4) // 多灯光

            };


            v2f vert (a2v v)
            {   
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul( unity_ObjectToWorld,v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o); // 多灯光
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // float3 lDir = _WorldSpaceLightPos0.xyz;
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));   // 多灯光
                float attenuation = LIGHT_ATTENUATION(i);       // 点光 衰减


                float3 lCol = _LightColor0.xyz; // 获取灯光颜色
                float3 vDir = normalize(_WorldSpaceCameraPos-i.wPos);
                float3 hDir = normalize(lDir+vDir);                
                float3 nDir = normalize(i.normal);

                float3 spec =pow( max(0 , dot(hDir,nDir)),_spec*50) * _spec * attenuation;
                float3 lambert = max(0,dot(lDir,nDir))*lCol * attenuation + spec;

                return fixed4(lambert,1.0);
            }