Shader "aoe/out"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_Light("Light", Float) = 1.5

		_OColor("Main Color",color) = (1,1,1,1)
		_Outline("Thick of Outline",range(0,0.1)) = 0.02
		_Factor("Factor",range(0,1)) = 0.5
	}
	SubShader
	{
		pass {
			Cull Front
			Lighting Off
			ZWrite Off
			ZTest LEqual

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			float  _Outline;
			float  _Factor;
			float4 _OColor;
			struct v2f {
				float4 pos:SV_POSITION;
			};

			v2f vert(appdata_full v) {
				v2f o;
				float3 dir = normalize(v.vertex.xyz);
				float3 dir2 = v.normal;
				float D = dot(dir,dir2);
				dir = dir*sign(D);
				dir = dir*_Factor + dir2*(1 - _Factor);
				v.vertex.xyz += dir*_Outline;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				return o;
			}
			float4 frag(v2f i) : COLOR
			{
				float4 c = _OColor;
				return c;
			}
			ENDCG
		}

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Cull Off
		Lighting Off
		ZWrite On
		ZTest LEqual
		Blend One OneMinusSrcAlpha		

		Pass
		{
			CGPROGRAM
			// Upgrade NOTE: excluded shader from DX11 and Xbox360; 
			//has structs without semantics (struct v2f members normalDir)
			#pragma exclude_renderers d3d11 xbox360
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float3 normalDir : TEXCOORD2;	
			};
			
			fixed4 _Color;
			fixed  _Light;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;		
				
				o.normalDir = normalize(mul(float4(v.normal, 0.0), _World2Object).xyz);
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);		

				float3 lightDir = normalize(float3(0.0, 1.0, 0.0));

				float difLight = dot(i.normalDir, lightDir);

				col = col * _Color;
				col.rgb = col.rgb * _Light * (0.5 + pow(difLight, 1.5)) * _Color.a;

				return col;
			}
			ENDCG
		}			
	}
}
