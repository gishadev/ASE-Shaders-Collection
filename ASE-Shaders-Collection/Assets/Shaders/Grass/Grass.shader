// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/Grass"
{
	Properties
	{
		_MainTint("MainTint", Color) = (0,0,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_WindStrength("WindStrength", Float) = 0
		_WindSpeed("WindSpeed", Float) = 0
		_HeightMask("HeightMask", Float) = 0
		_WindWaveScale("WindWaveScale", Float) = 1
		_NoiseScale("NoiseScale", Float) = 0
		_UVScrollSpeed("UVScrollSpeed", Float) = 0
		_PlayerPosition("PlayerPosition", Vector) = (0,0,0,0)
		_PlayerRadius("PlayerRadius", Float) = 0
		_PlayerPushStrength("PlayerPushStrength", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _WindSpeed;
		uniform float _WindWaveScale;
		uniform float _WindStrength;
		uniform float _HeightMask;
		uniform float _UVScrollSpeed;
		uniform float _NoiseScale;
		uniform float _PlayerPushStrength;
		uniform float3 _PlayerPosition;
		uniform float _PlayerRadius;
		uniform float4 _MainTint;
		uniform float _Metallic;
		uniform float _Smoothness;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime6 = _Time.y * _WindSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 appendResult9 = (float3(sin( ( mulTime6 + ( _WindWaveScale * ase_worldPos.x ) ) ) , 0.0 , 0.0));
			float temp_output_16_0 = saturate( ( ase_worldPos.y * _HeightMask ) );
			float temp_output_17_0 = ( temp_output_16_0 * temp_output_16_0 );
			float2 appendResult32 = (float2(_UVScrollSpeed , 0.0));
			float2 appendResult28 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner30 = ( _Time.y * appendResult32 + appendResult28);
			float simpleNoise21 = SimpleNoise( panner30*_NoiseScale );
			float temp_output_42_0 = ( 1.0 - saturate( ( distance( ase_worldPos , _PlayerPosition ) / _PlayerRadius ) ) );
			float3 lerpResult47 = lerp( ( appendResult9 * _WindStrength * temp_output_17_0 * (-1.0 + (simpleNoise21 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) , ( ( _PlayerPushStrength * ( ase_worldPos - _PlayerPosition ) ) * temp_output_42_0 * float3(1,0,1) * temp_output_17_0 ) , temp_output_42_0);
			v.vertex.xyz += lerpResult47;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _MainTint.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			float3 ase_worldPos = i.worldPos;
			float temp_output_16_0 = saturate( ( ase_worldPos.y * _HeightMask ) );
			float temp_output_17_0 = ( temp_output_16_0 * temp_output_16_0 );
			o.Occlusion = temp_output_17_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18600
231;295;755;402;1277.929;36.72553;2.127257;False;False
Node;AmplifyShaderEditor.WorldPosInputsNode;35;-1536,1200;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-1542.527,296.1914;Inherit;False;Property;_WindSpeed;WindSpeed;4;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1610.515,406.1723;Inherit;False;Property;_WindWaveScale;WindWaveScale;6;0;Create;True;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;34;-1536,1424;Inherit;False;Property;_PlayerPosition;PlayerPosition;9;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;31;-1561.373,949.9344;Inherit;False;Property;_UVScrollSpeed;UVScrollSpeed;8;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-1555.639,788.524;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-1594.891,520.2592;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;37;-1280,1392;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1296.782,1566.931;Inherit;False;Property;_PlayerRadius;PlayerRadius;10;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1590.93,670.2421;Inherit;False;Property;_HeightMask;HeightMask;5;0;Create;True;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1310.55,879.4921;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1289.568,763.9533;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1394.645,404.3152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-1317.55,980.4921;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1366.444,299.9313;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1104.385,979.4466;Inherit;False;Property;_NoiseScale;NoiseScale;7;0;Create;True;0;0;False;0;False;0;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1217.78,404.337;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;40;-1120.188,1471.407;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1418.278,565.0519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;30;-1129.842,725.0899;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-1292.114,1207.347;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;16;-1088.037,573.3217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1291.306,1110.546;Inherit;False;Property;_PlayerPushStrength;PlayerPushStrength;11;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;21;-926.0696,843.4242;Inherit;False;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;41;-965.007,1429.525;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;5;-1075.289,308.7076;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-892.4272,302.5913;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;29;-718.5641,687.3315;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-999.9047,1203.139;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;42;-793.8611,1363.387;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1043.571,478.0287;Inherit;False;Property;_WindStrength;WindStrength;3;0;Create;True;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-876.88,554.9521;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;44;-772.5023,1458.572;Inherit;False;Constant;_Vector1;Vector 1;11;0;Create;True;0;0;False;0;False;1,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-580.7007,1215.823;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-641.188,318.2273;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;47;-133.4252,1048.334;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1;-332.1049,-119.8814;Inherit;False;Property;_MainTint;MainTint;0;0;Create;True;0;0;False;0;False;0,0,0,0;0.1072001,0.6886792,0.1796543,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-381.8356,118.0564;Inherit;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-381.8357,204.1756;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MyShaders/Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;35;0
WireConnection;37;1;34;0
WireConnection;32;0;31;0
WireConnection;28;0;27;1
WireConnection;28;1;27;3
WireConnection;20;0;19;0
WireConnection;20;1;12;1
WireConnection;6;0;10;0
WireConnection;18;0;6;0
WireConnection;18;1;20;0
WireConnection;40;0;37;0
WireConnection;40;1;39;0
WireConnection;13;0;12;2
WireConnection;13;1;14;0
WireConnection;30;0;28;0
WireConnection;30;2;32;0
WireConnection;30;1;33;0
WireConnection;36;0;35;0
WireConnection;36;1;34;0
WireConnection;16;0;13;0
WireConnection;21;0;30;0
WireConnection;21;1;24;0
WireConnection;41;0;40;0
WireConnection;5;0;18;0
WireConnection;9;0;5;0
WireConnection;29;0;21;0
WireConnection;45;0;46;0
WireConnection;45;1;36;0
WireConnection;42;0;41;0
WireConnection;17;0;16;0
WireConnection;17;1;16;0
WireConnection;43;0;45;0
WireConnection;43;1;42;0
WireConnection;43;2;44;0
WireConnection;43;3;17;0
WireConnection;7;0;9;0
WireConnection;7;1;8;0
WireConnection;7;2;17;0
WireConnection;7;3;29;0
WireConnection;47;0;7;0
WireConnection;47;1;43;0
WireConnection;47;2;42;0
WireConnection;0;0;1;0
WireConnection;0;3;2;0
WireConnection;0;4;3;0
WireConnection;0;5;17;0
WireConnection;0;11;47;0
ASEEND*/
//CHKSM=1296733B2BD4B6F22AF0A1800AD2CA937E5641E3