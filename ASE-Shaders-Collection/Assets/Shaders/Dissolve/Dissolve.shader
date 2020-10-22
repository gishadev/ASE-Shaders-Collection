// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Dissolve"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Main_A("Main_A", 2D) = "white" {}
		_Main_N("Main_N", 2D) = "bump" {}
		_Roughness("Roughness", 2D) = "white" {}
		_Main_AO("Main_AO", 2D) = "white" {}
		_BurnRamp("BurnRamp", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_EmissionIntensity("EmissionIntensity", Float) = 0
		_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_NoiseScale("NoiseScale", Float) = 1
		_UVScale("UVScale", Float) = 3
		_UVLerp("UVLerp", Range( 0 , 1)) = 0
		_UVMoveDirection("UVMoveDirection", Vector) = (1,1,0,0)
		_OpacityMask("OpacityMask", Range( -0.65 , 0.5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Main_N;
		uniform float4 _Main_N_ST;
		uniform sampler2D _Main_A;
		uniform float4 _Main_A_ST;
		uniform sampler2D _BurnRamp;
		uniform sampler2D _NoiseTexture;
		uniform float _NoiseScale;
		uniform float2 _UVMoveDirection;
		uniform float _UVLerp;
		uniform float _OpacityMask;
		uniform float _UVScale;
		uniform float _EmissionIntensity;
		uniform float _Metallic;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform sampler2D _Main_AO;
		uniform float4 _Main_AO_ST;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Main_N = i.uv_texcoord * _Main_N_ST.xy + _Main_N_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Main_N, uv_Main_N ) );
			float2 uv_Main_A = i.uv_texcoord * _Main_A_ST.xy + _Main_A_ST.zw;
			o.Albedo = tex2D( _Main_A, uv_Main_A ).rgb;
			float2 uv_TexCoord12 = i.uv_texcoord * ( float2( 1,1 ) * _NoiseScale );
			float2 panner37 = ( _Time.y * _UVMoveDirection + uv_TexCoord12);
			float2 temp_cast_1 = (tex2D( _NoiseTexture, panner37 ).r).xx;
			float2 lerpResult31 = lerp( uv_TexCoord12 , temp_cast_1 , _UVLerp);
			float temp_output_17_0 = ( tex2D( _NoiseTexture, lerpResult31 ).r - _OpacityMask );
			float2 temp_cast_2 = (( 1.0 - saturate( (( -1.0 * _UVScale ) + (temp_output_17_0 - 0.0) * (_UVScale - ( -1.0 * _UVScale )) / (1.0 - 0.0)) ) )).xx;
			o.Emission = ( tex2D( _BurnRamp, temp_cast_2 ) * _EmissionIntensity ).rgb;
			o.Metallic = _Metallic;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			o.Smoothness = ( 1.0 - tex2D( _Roughness, uv_Roughness ) ).r;
			float2 uv_Main_AO = i.uv_texcoord * _Main_AO_ST.xy + _Main_AO_ST.zw;
			o.Occlusion = tex2D( _Main_AO, uv_Main_AO ).r;
			o.Alpha = 1;
			clip( temp_output_17_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
371;294;615;403;2573.729;-782.7959;1.688785;True;False
Node;AmplifyShaderEditor.Vector2Node;13;-2715.323,1357.728;Inherit;False;Constant;_Tiling;Tiling;7;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;14;-2729.074,1548.949;Inherit;False;Property;_NoiseScale;NoiseScale;9;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2562.429,1422.229;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2379.692,1360.936;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;36;-2604.009,1919.184;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;34;-2727.738,1750.754;Inherit;False;Property;_UVMoveDirection;UVMoveDirection;12;0;Create;True;0;0;False;0;False;1,1;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;30;-2289.188,948.5308;Inherit;True;Property;_NoiseTexture;NoiseTexture;8;0;Create;True;0;0;False;0;False;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;37;-2366.551,1709.753;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;32;-2106.094,1609.178;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1744.906,1769.5;Inherit;False;Property;_UVLerp;UVLerp;11;0;Create;True;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;-1474.117,1629.022;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1188.962,762.626;Inherit;False;Property;_UVScale;UVScale;10;0;Create;True;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-965.0782,1196.398;Inherit;False;Property;_OpacityMask;OpacityMask;13;0;Create;True;0;0;False;0;False;0;-0.2378405;-0.65;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-1238.086,1363.034;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;False;0;False;-1;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-980.836,697.4023;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-697.229,1082.164;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;22;-765.9523,690.0245;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;-601.6029,689.3956;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;27;-473.2263,690.1297;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-22.29657,658.3513;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;7;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-306.3398,578.319;Inherit;True;Property;_BurnRamp;BurnRamp;5;0;Create;True;0;0;False;0;False;-1;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-781.1371,234.3305;Inherit;True;Property;_Roughness;Roughness;3;0;Create;True;0;0;False;0;False;-1;None;b2ddb95cee51e09489d5c548bc34184d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-720.035,-176.0028;Inherit;True;Property;_Main_A;Main_A;1;0;Create;True;0;0;False;0;False;-1;None;eac3f6659efccf740bbcf7c599b9c368;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-405.4666,121.996;Inherit;False;Property;_Metallic;Metallic;6;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;163.3652,536.5511;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;5;-411.0159,244.533;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-781.6699,34.43999;Inherit;True;Property;_Main_N;Main_N;2;0;Create;True;0;0;False;0;False;-1;None;b5b730dca208baf4f9cafe18f1da403f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-787.1825,437.7016;Inherit;True;Property;_Main_AO;Main_AO;4;0;Create;True;0;0;False;0;False;-1;None;d605f81cb90189c4fa885d2ea5685a01;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;326.6215,160.4459;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;13;0
WireConnection;29;1;14;0
WireConnection;12;0;29;0
WireConnection;37;0;12;0
WireConnection;37;2;34;0
WireConnection;37;1;36;0
WireConnection;32;0;30;0
WireConnection;32;1;37;0
WireConnection;31;0;12;0
WireConnection;31;1;32;1
WireConnection;31;2;33;0
WireConnection;28;0;30;0
WireConnection;28;1;31;0
WireConnection;24;1;23;0
WireConnection;17;0;28;1
WireConnection;17;1;7;0
WireConnection;22;0;17;0
WireConnection;22;3;24;0
WireConnection;22;4;23;0
WireConnection;26;0;22;0
WireConnection;27;0;26;0
WireConnection;18;1;27;0
WireConnection;21;0;18;0
WireConnection;21;1;20;0
WireConnection;5;0;4;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;21;0
WireConnection;0;3;3;0
WireConnection;0;4;5;0
WireConnection;0;5;6;0
WireConnection;0;10;17;0
ASEEND*/
//CHKSM=2161C894C1E865C07F752BB8687120B6F0C32DFE