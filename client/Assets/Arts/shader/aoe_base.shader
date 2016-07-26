Shader "aoe/base"
{
	Properties {
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _Light("Light", Float) = 1.5
        }
        SubShader {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            Cull Off
            
            CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _MainTex;
            fixed  _Light;

            struct Input {
                float2 uv_MainTex;
            };

            void surf (Input IN, inout SurfaceOutput o) {
                half4 c = tex2D (_MainTex, IN.uv_MainTex);
                o.Albedo = c.rgb * _Light;
                o.Alpha = c.a;
            }
            ENDCG
        }
        FallBack "Diffuse"
}
