Shader "Paradox/Light/StandardLightModel/Lambert/HalfLambert"
{
	Properties
	{
		_Diffuse("漫反射光照颜色", Color) = (1, 1, 1, 1)
	}

		SubShader
	{
		Tags{
		"LightMode" = "ForwardBase"
		"RenderType" = "Opaque"
	}


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.normal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
			fixed3 worldNormal = normalize(i.normal);
			fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
			fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight) * 0.5 + 0.5);
			return fixed4(ambient + diffuse, 1.0);
			}



			ENDCG
		}
	}
		FallBack "Diffuse"
}
