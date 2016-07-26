Shader "aoe/color_only"
{
	Properties
	{		
		_Color("Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags
		{
			//"Queue" = "Transparent"
			//"IgnoreProjector" = "True"
			//"RenderType" = "Transparent"
			//"PreviewType" = "Plane"
			//"CanUseSpriteAtlas" = "True"
		}

		Cull Off
		Lighting Off
		ZWrite On
		ZTest LEqual		

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
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

				return o;
			}

			fixed4 _Color;

			fixed4 frag (v2f i) : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
	}
}
