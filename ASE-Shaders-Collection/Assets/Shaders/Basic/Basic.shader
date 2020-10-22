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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _N_Main;
		uniform float4 _N_Main_ST;
		uniform sampler2D _A_Main;
		uniform float4 _A_Main_ST;
		uniform float _MainMetallic;
		uniform sampler2D _R_Main;
		uniform float4 _R_Main_ST;
		uniform sampler2D _AO_Main;
		uniform float4 _AO_Main_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_N_Main = i.uv_texcoord * _N_Main_ST.xy + _N_Main_ST.zw;
			o.Normal = UnpackNormal( tex2D( _N_Main, uv_N_Main ) );
			float2 uv_A_Main = i.uv_texcoord * _A_Main_ST.xy + _A_Main_ST.zw;
			o.Albedo = tex2D( _A_Main, uv_A_Main ).rgb;
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
231;294;630;403;816.6252;-544.0741;1;False;False
Node;AmplifyShaderEditor.SamplerNode;5;-664.2695,298.5777;Inherit;True;Property;_R_Main;R_Main;3;0;Create;True;0;0;False;0;False;-1;None;b2ddb95cee51e09489d5c548bc34184d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-302.764,245.8382;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-664.7783,502.9242;Inherit;True;Property;_AO_Main;AO_Main;2;0;Create;True;0;0;False;0;False;-1;None;ec9a9aeec8dfaab41b14611d0d5b2579;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-536.9916,210.0799;Inherit;False;Property;_MainMetallic;MainMetallic;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-666.6002,20.19997;Inherit;True;Property;_N_Main;N_Main;1;0;Create;True;0;0;False;0;False;-1;None;c6d1b784f8267674d97727870ccb5012;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-666.6002,-187.7999;Inherit;True;Property;_A_Main;A_Main;0;0;Create;True;0;0;False;0;False;-1;None;23fd61c4d299d294b93f5d3a70665ec5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-666,706;Inherit;True;Property;_H_Main;H_Main;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Basic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;3;3;0
WireConnection;0;4;6;0
WireConnection;0;5;4;0
ASEEND*/
//CHKSM=052E5FFA770B865A2309C13A2270B07C2EF85999