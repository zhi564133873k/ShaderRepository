Shader "Paradox/Light/Texture/TextureBlinnPhone"
{
	Properties
	{
		_Color("物体漫反射颜色", Color) = (1, 1, 1, 1)
		_MainTex("物体纹理", 2D) = "white" {}
		_Specular("反射光照颜色", Color) = (1, 1, 1, 1)
		_Gloss("高光参数", Range(8, 256)) = 20
	}

		SubShader
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Specular;
			float _Gloss;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float3 worldPos :POSITION1;
				float2 uv : TEXCOORD2;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);		

				o.normal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				fixed3 worldNormal = normalize(i.normal);

				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuse = _LightColor0.rgb * albedo  * max(0, dot(worldNormal, worldLight));

				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);

				fixed3 halfDir = normalize(worldLight + viewDir);

				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1.0);
			}
			ENDCG
		}
	}
		FallBack "Diffuse"
}
