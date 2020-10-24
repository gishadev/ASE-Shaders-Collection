// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Snow"
{
	Properties
	{
		_Cobblestone_A("Cobblestone_A", 2D) = "white" {}
		_Snow_A("Snow_A", 2D) = "white" {}
		_Cobblestone_N("Cobblestone_N", 2D) = "bump" {}
		_Snow_N("Snow_N", 2D) = "bump" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0.16339
		_SnowControl("SnowControl", Range( 0 , 3)) = 0
		_SnowHeight("SnowHeight", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _SnowHeight;
		uniform float _SnowControl;
		uniform sampler2D _Cobblestone_N;
		uniform float4 _Cobblestone_N_ST;
		uniform sampler2D _Snow_N;
		uniform float4 _Snow_N_ST;
		uniform sampler2D _Cobblestone_A;
		uniform float4 _Cobblestone_A_ST;
		uniform sampler2D _Snow_A;
		uniform float4 _Snow_A_ST;
		uniform float _Metallic;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_Cobblestone_N = v.texcoord * _Cobblestone_N_ST.xy + _Cobblestone_N_ST.zw;
			float2 uv_Snow_N = v.texcoord * _Snow_N_ST.xy + _Snow_N_ST.zw;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 lerpResult7 = lerp( UnpackNormal( tex2Dlod( _Cobblestone_N, float4( uv_Cobblestone_N, 0, 0.0) ) ) , UnpackNormal( tex2Dlod( _Snow_N, float4( uv_Snow_N, 0, 0.0) ) ) , saturate( ( ase_worldNormal.y * _SnowControl ) ));
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal13 = lerpResult7;
			float3 modWorldNormal13 = (tangentToWorld[0] * tangentNormal13.x + tangentToWorld[1] * tangentNormal13.y + tangentToWorld[2] * tangentNormal13.z);
			float temp_output_16_0 = ( _SnowControl * modWorldNormal13.y );
			float3 lerpResult21 = lerp( float3( 0,0,0 ) , ( ase_vertexNormal * _SnowHeight ) , saturate( (0.0 + (temp_output_16_0 - 0.0) * (1.0 - 0.0) / (3.0 - 0.0)) ));
			v.vertex.xyz += lerpResult21;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Cobblestone_N = i.uv_texcoord * _Cobblestone_N_ST.xy + _Cobblestone_N_ST.zw;
			float2 uv_Snow_N = i.uv_texcoord * _Snow_N_ST.xy + _Snow_N_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 lerpResult7 = lerp( UnpackNormal( tex2D( _Cobblestone_N, uv_Cobblestone_N ) ) , UnpackNormal( tex2D( _Snow_N, uv_Snow_N ) ) , saturate( ( ase_worldNormal.y * _SnowControl ) ));
			o.Normal = lerpResult7;
			float2 uv_Cobblestone_A = i.uv_texcoord * _Cobblestone_A_ST.xy + _Cobblestone_A_ST.zw;
			float2 uv_Snow_A = i.uv_texcoord * _Snow_A_ST.xy + _Snow_A_ST.zw;
			float temp_output_16_0 = ( _SnowControl * (WorldNormalVector( i , lerpResult7 )).y );
			float4 lerpResult6 = lerp( tex2D( _Cobblestone_A, uv_Cobblestone_A ) , tex2D( _Snow_A, uv_Snow_A ) , saturate( temp_output_16_0 ));
			o.Albedo = lerpResult6.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
231;313;755;384;1438.902;-17.70624;1.596829;False;False
Node;AmplifyShaderEditor.WorldNormalVector;10;-894.5506,51.66869;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;14;-1062.757,205.1701;Inherit;False;Property;_SnowControl;SnowControl;6;0;Create;True;0;0;False;0;False;0;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-730.0474,189.548;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1202.56,302.2844;Inherit;True;Property;_Cobblestone_N;Cobblestone_N;2;0;Create;True;0;0;False;0;False;-1;None;db0ce7a9d825dfe4e883c9c3d4653058;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1202.625,509.7458;Inherit;True;Property;_Snow_N;Snow_N;3;0;Create;True;0;0;False;0;False;-1;None;88cf60b38e2751247a4d6d1a1b4f1443;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;-581.6623,283.5813;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-563.0919,500.2821;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;13;-380.3294,704.3403;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-182.6555,642.6722;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;22;-42.73306,712.5496;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;20;-586.1677,904.9195;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-574.4839,1058.973;Inherit;False;Property;_SnowHeight;SnowHeight;7;0;Create;True;0;0;False;0;False;0;0.025;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-909.5818,-515.333;Inherit;True;Property;_Cobblestone_A;Cobblestone_A;0;0;Create;True;0;0;False;0;False;-1;None;a03960106412a844baa1d1b0a0890593;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;23;134.7017,893.288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;-38.89856,571.2977;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-903.3768,-308.0631;Inherit;True;Property;_Snow_A;Snow_A;1;0;Create;True;0;0;False;0;False;-1;None;dc841fa5e8bdf6c46b0aa4d70442f788;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-277.842,976.3254;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-289.7597,163.9727;Inherit;False;Property;_Metallic;Metallic;5;0;Create;True;0;0;False;0;False;0.16339;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-565.9133,-346.4047;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-288.9625,261.6878;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;False;0;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;307.8791,925.2646;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;285.0858,92.44514;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Snow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;10;2
WireConnection;15;1;14;0
WireConnection;11;0;15;0
WireConnection;7;0;3;0
WireConnection;7;1;4;0
WireConnection;7;2;11;0
WireConnection;13;0;7;0
WireConnection;16;0;14;0
WireConnection;16;1;13;2
WireConnection;22;0;16;0
WireConnection;23;0;22;0
WireConnection;12;0;16;0
WireConnection;19;0;20;0
WireConnection;19;1;18;0
WireConnection;6;0;1;0
WireConnection;6;1;2;0
WireConnection;6;2;12;0
WireConnection;21;1;19;0
WireConnection;21;2;23;0
WireConnection;0;0;6;0
WireConnection;0;1;7;0
WireConnection;0;3;8;0
WireConnection;0;4;9;0
WireConnection;0;11;21;0
ASEEND*/
//CHKSM=68C4372F680BFFEF492551940706A93196E39847