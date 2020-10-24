// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Basic"
{
	Properties
	{
		_A_Main("A_Main", 2D) = "white" {}
		_N_Main("N_Main", 2D) = "bump" {}
		_AO_Main("AO_Main", 2D) = "white" {}
		_R_Main("R_Main", 2D) = "white" {}
		_MainMetallic("MainMetallic", Float) = 0
		_H_Main("H_Main", 2D) = "white" {}
		_Displacement("Displacement", Range( 0 , 1)) = 0
		_Lava_E("Lava_E", 2D) = "white" {}
		_EmissionIntensity("EmissionIntensity", Float) = 0
		_RedTint("RedTint", Color) = (0.9622642,0,0,0)
		_YellowTint("YellowTint", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _H_Main;
		uniform float4 _H_Main_ST;
		uniform float _Displacement;
		uniform sampler2D _N_Main;
		uniform float4 _N_Main_ST;
		uniform sampler2D _A_Main;
		uniform float4 _A_Main_ST;
		uniform sampler2D _Lava_E;
		SamplerState sampler_Lava_E;
		uniform float4 _Lava_E_ST;
		uniform float4 _RedTint;
		uniform float4 _YellowTint;
		uniform float _EmissionIntensity;
		uniform float _MainMetallic;
		uniform sampler2D _R_Main;
		uniform float4 _R_Main_ST;
		uniform sampler2D _AO_Main;
		uniform float4 _AO_Main_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_H_Main = v.texcoord * _H_Main_ST.xy + _H_Main_ST.zw;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( tex2Dlod( _H_Main, float4( uv_H_Main, 0, 0.0) ) * float4( ase_vertexNormal , 0.0 ) ) * _Displacement ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_N_Main = i.uv_texcoord * _N_Main_ST.xy + _N_Main_ST.zw;
			o.Normal = UnpackNormal( tex2D( _N_Main, uv_N_Main ) );
			float2 uv_A_Main = i.uv_texcoord * _A_Main_ST.xy + _A_Main_ST.zw;
			o.Albedo = tex2D( _A_Main, uv_A_Main ).rgb;
			float2 uv_Lava_E = i.uv_texcoord * _Lava_E_ST.xy + _Lava_E_ST.zw;
			float temp_output_21_0 = saturate( ( tex2D( _Lava_E, uv_Lava_E ).r - 0.15 ) );
			float4 lerpResult23 = lerp( _RedTint , _YellowTint , temp_output_21_0);
			o.Emission = ( ( temp_output_21_0 * lerpResult23 ) * _EmissionIntensity ).rgb;
			o.Metallic = _MainMetallic;
			float2 uv_R_Main = i.uv_texcoord * _R_Main_ST.xy + _R_Main_ST.zw;
			o.Smoothness = ( 1.0 - tex2D( _R_Main, uv_R_Main ) ).r;
			float2 uv_AO_Main = i.uv_texcoord * _AO_Main_ST.xy + _AO_Main_ST.zw;
			o.Occlusion = tex2D( _AO_Main, uv_AO_Main ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
371;294;532;403;1652.533;162.8718;3.498734;False;False
Node;AmplifyShaderEditor.SamplerNode;13;-1767.423,-156.8119;Inherit;True;Property;_Lava_E;Lava_E;7;0;Create;True;0;0;False;0;False;-1;None;55e6254930d447344b89529e0bc563a6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;-1449.677,-91.21126;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-1216.595,-2.01897;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-1458.606,182.8884;Inherit;False;Property;_RedTint;RedTint;9;0;Create;True;0;0;False;0;False;0.9622642,0,0,0;0.6132076,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;22;-1234.609,289.9645;Inherit;False;Property;_YellowTint;YellowTint;10;0;Create;True;0;0;False;0;False;0,0,0,0;1,0.8558037,0.240566,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;9;-669.0394,1101.193;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-801.4161,138.9937;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;-768.418,869.268;Inherit;True;Property;_H_Main;H_Main;5;0;Create;True;0;0;False;0;False;-1;None;b680a6cb1fa1a1b48abc200fd91ef09d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-429.0394,986.1928;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-426.6856,137.3818;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;8;0;Create;True;0;0;False;0;False;0;750;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-652.4254,443.668;Inherit;True;Property;_R_Main;R_Main;3;0;Create;True;0;0;False;0;False;-1;None;b2ddb95cee51e09489d5c548bc34184d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-634.9016,31.72234;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-255.9214,1070.072;Inherit;False;Property;_Displacement;Displacement;6;0;Create;True;0;0;False;0;False;0;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-79.44617,804.3427;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-237.0141,24.51765;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-585.1852,-416.8143;Inherit;True;Property;_A_Main;A_Main;0;0;Create;True;0;0;False;0;False;-1;None;23fd61c4d299d294b93f5d3a70665ec5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-585.1852,-208.8144;Inherit;True;Property;_N_Main;N_Main;1;0;Create;True;0;0;False;0;False;-1;None;c6d1b784f8267674d97727870ccb5012;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-652.9343,648.0143;Inherit;True;Property;_AO_Main;AO_Main;2;0;Create;True;0;0;False;0;False;-1;None;ec9a9aeec8dfaab41b14611d0d5b2579;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-525.1475,355.1702;Inherit;False;Property;_MainMetallic;MainMetallic;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-310.9199,371.9285;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Basic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;13;1
WireConnection;21;0;20;0
WireConnection;23;0;16;0
WireConnection;23;1;22;0
WireConnection;23;2;21;0
WireConnection;10;0;7;0
WireConnection;10;1;9;0
WireConnection;17;0;21;0
WireConnection;17;1;23;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;14;0;17;0
WireConnection;14;1;15;0
WireConnection;6;0;5;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;14;0
WireConnection;0;3;3;0
WireConnection;0;4;6;0
WireConnection;0;5;4;0
WireConnection;0;11;11;0
ASEEND*/
//CHKSM=330DADE9CAD8BC0F1E8CC9029E0F70CB09F9DD1C