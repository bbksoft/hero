Shader "aoe/baseAdd"
{

	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Light("Light", Float) = 1.5
		_RimColor("_RimColor", Color) = (0.17,0.36,0.81,0.0)
		_RimWidth("_RimWidth", Range(0.0,5.0)) = 1

	}
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		Cull Off

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;		
		fixed  _Light;
		fixed4  _RimColor;
		fixed  _RimWidth;

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Light;
			o.Alpha = c.a;

			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimWidth);
		}
		ENDCG
	}
	FallBack "Diffuse"	
}


