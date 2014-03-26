using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;
using Uno.Tweening;
using Uno.Scenes.Batching;

namespace Everythingspawner
{
	public class CubeSpline : Node
	{
		//float3[] points = new float3[]{float3(0), float3(1,1,1), float3(10,5,-2),float3(5,7,-5)};
		float3[] startPoints = new float3[]{float3(74, 44, 15), float3(65, 35, 18), float3(60, 30, 17), float3(52, 32, 18), float3(45, 35, 18.5f), float3(47, 40, 19f), float3(53, 47, 19f), float3(57, 53, 21f), float3(47, 53, 18.5f), float3(40, 52, 20f), float3(30, 51, 20), float3(40, 47, 19), float3(41, 45, 25)};
		//float3[] beizerPoints = new float3[]{float3(24, 0, 2), float3(15, 6, 3), float3(13, 9, 6), float3(11, 15, 2.5f),
		//									 float3(11, 15, 2.5f)};
		float3[] beizerPoints;
		float3[] points = new float3[]{};

		float[] lenLookup;
		Batch[] batches;

		int sampleRate = 15;
		float totalLen = 0f;

		public float stepSize { get; set; }

		public float animationtime { get; set; }

		[Range(0,1)]
		public float CubeSize { get; set; }

		[Range(0,100)]
		public float ColorSeed { get; set; }

		[Color]
		public float3 OffsetColor { get; set; }

		[Range(0,1)]
		public float OffsetOpacity { get; set; }

		[Range(0,0.5f)]
		public float RandMin { get; set; }
		[Range(0.5f,1)]
		public float RandMax { get; set; }


		float3[] colorScheme = new [] {float3(0.33f ,0.59f ,0.80f),float3(0.33f ,0.57f ,0.76f),float3(0.27f ,0.54f ,0.75f),float3(0.39f ,0.64f ,0.84f),float3(0.43f ,0.66f ,0.84f),float3(1)};

		protected override void OnInitialize()
		{
			debug_log "initializing";
			base.OnInitialize();
			//Create bezier array
			int curves = ((startPoints.Length-1)/3);
			int nodes = curves*4;
			beizerPoints = new float3[nodes];
			for(int i = 0; i < curves; i++)
			{
				beizerPoints[(i*4)+0] = startPoints[(i*3)+0];
				beizerPoints[(i*4)+1] = startPoints[(i*3)+1];
				beizerPoints[(i*4)+2] = startPoints[(i*3)+2];
				beizerPoints[(i*4)+3] = startPoints[(i*3)+3];
			}

			int beizerCurves = beizerPoints.Length/4;
			points = new float3[beizerCurves*sampleRate];

			int pointIndexAt = 0;
			lenLookup = new float[beizerCurves];

			for(int i = 0; i < beizerCurves; i++)
			{
				lenLookup[i] = 0;
				for(int x = 0; x < sampleRate; x++)
				{
					points[(i*sampleRate)+x] = CalculateBezierPoint((float)x/(float)sampleRate, beizerPoints[(i*4)+0], beizerPoints[(i*4)+1], beizerPoints[(i*4)+2], beizerPoints[(i*4)+3]);
					if(x<sampleRate-1)
					{
						lenLookup[i] += dist(points[(i*sampleRate)+x], points[(i*sampleRate)+x+1]);
					}
				}
			}
			initCubeBatch();
		}

		public float3 CalculateBezierPoint(float t, float3 p0, float3 p1, float3 p2, float3 p3)
		{
			float pos = 1f - t;
			float tt = t*t;
			float uu = pos*pos;
			float uuu = uu * pos;
			float ttt = tt * t;

			float3 p = uuu * p0; //first term
			p += 3 * uu * t * p1; //second term
			p += 3 * pos * tt * p2; //third term
			p += ttt * p3; //fourth term

			return p;
			//return float3(0);
		}
		public float dist (float3 s, float3 e)
		{
			return Math.Sqrt(((e.X-s.X)*(e.X-s.X)) +
			((e.Y-s.Y)*(e.Y-s.Y)) +
			((e.Z-s.Z)*(e.Z-s.Z))
			);
		}
		public void initCubeBatch()
		{
			int totalCubes = 100;
			int maxVertices = 65535;
			var cube = Uno.Content.Models.MeshGenerator.CreateCube(float3(0,0,0), .5f);
			var rand = new Random(1123);

			//Set up batches
			int numCubesPerBatch = maxVertices/cube.Positions.Count;
			int numBatches = (totalCubes/numCubesPerBatch)+1;
			int verticeCount = numCubesPerBatch * cube.Positions.Count;
        	int indiceCount = numCubesPerBatch * cube.Indices.Count;
			batches = new Batch[numBatches];
			//debug_log numBatches;
			debug_log numCubesPerBatch;

			for(int i = 0; i < numBatches; i++)
			{
				if(i<numBatches-1)
				{
					batches[i] = new Batch(numCubesPerBatch*cube.Positions.Count, numCubesPerBatch*cube.Indices.Count, true);
				}
				else
				{
					int cubesAllreadyDone = i*numCubesPerBatch;
					int cubesLeft = totalCubes-cubesAllreadyDone;
					batches[i] = new Batch(cubesLeft*cube.Positions.Count, cubesLeft*cube.Indices.Count, true);
				}
			}
			//debug_log "hi";
			//"Install" cubes
			for(int i = 0; i < totalCubes; i++)
			{
				//debug_log "yo";
				int batchId = i/numCubesPerBatch;
				int offsetInBatch = i%numCubesPerBatch;
				//debug_log batchId;
				//debug_log offsetInBatch;
				float4 attrib0 = float4(rand.NextFloat(), rand.NextFloat(), rand.NextFloat(),(float)i/10.0f);
				float4 attrib1 = float4(rand.NextFloat()-0.5f, rand.NextFloat()-0.5f, rand.NextFloat()-0.5f,rand.NextFloat());
				float4 attrib2 = float4(rand.NextInt(colorScheme.Length), 0, 0, 0);
				//debug_log "yo";
				for(int a = 0; a < cube.Positions.Count; a++)
				{
					batches[batchId].Positions.Write(cube.Positions.GetFloat4(a).XYZ);
					batches[batchId].Normals.Write(cube.Normals.GetFloat4(a).XYZ);
					batches[batchId].TexCoord0s.Write(cube.TexCoords.GetFloat4(a).XY);
					batches[batchId].Attrib0Buffer.Write(attrib0);
					batches[batchId].Attrib1Buffer.Write(attrib1);
					batches[batchId].Attrib2Buffer.Write(attrib2);
				}
				//debug_log "yo";
				for(int a = 0; a < cube.Indices.Count; a++)
				{
					batches[batchId].Indices.Write((ushort)(cube.Indices.GetInt(a) + cube.Positions.Count*offsetInBatch));
				}
			}
		}
		/*
		public override void DesignerDraw(Uno.Scenes.DrawContext c)
		{
			base.DesignerDraw(c);

			for(int i = 0; i < points.Length; i++)
			{
				draw DefaultShading, c, Uno.Scenes.Primitives.Cube
				{
					VertexPosition: (prev*.1f) + points[i];
					DiffuseColor: float3(.3f,.3f,1f);
				};
			}
			for(int i = 0; i < beizerPoints.Length; i++)
			{
				draw DefaultShading, c, Uno.Scenes.Primitives.Cube
				{
					VertexPosition: (prev*.5f) + beizerPoints[i];
					DiffuseColor: float3(1f,.3f,1f);
				};
			}
			for(int i = 0; i < points.Length-1; i++)
			{
				float3[] positions = new []{points[i], points[i+1]};
				draw DefaultShading, c
				{
					PrimitiveType: PrimitiveType.Lines;
					VertexPosition: vertex_attrib(positions)*10f;
					DiffuseColor: float3(.3f,.3f,1f);
				};
			}
			//Draw interpolated lines or something idunno yolo
			for(int i = 0; i < beizerPoints.Length-1; i++)
			{
				float3[] arrayThing = new []{beizerPoints[i], beizerPoints[i+1]};
				draw DefaultShading, c
				{
					PrimitiveType: PrimitiveType.Lines;
					VertexPosition: vertex_attrib(arrayThing)*10f;
					DiffuseColor: float3(1f,0f,0f);
				};
			}
			//debug_log "START";
			/*
			for(int i = 0; i < points.Length; i++)
			{
				for(int a = 0; a < (int)(lenLookup[i]*sampleRate); a++)
				{
					float dist = (1f/(lenLookup[i]*sampleRate))*(float)a;
					float3 p = pointOnLine(points[i], points[i+1], dist);
					//debug_log dist + ";" + p.X + ";" + p.Y + ";" + p.Z;
					draw DefaultShading, c, Uno.Scenes.Primitives.Cube
					{
						VertexPosition: (prev*.1f) + p*1f;
						DiffuseColor: float3(1f,.3f,1f);
					};
				}
			}

		}
		*/
		float a = 0f; //Step
		protected override void OnDraw()
		{
			base.OnDraw();
			//a += 0.300f*stepSize*(float)Uno.Application.FrameInterval; //Fix timing.
			a = stepSize * animationtime;
			var rand = new Random(1337);
			float t = a;
			for(int i = 0; i < 500; i++)
			{
				float pos = getPos(t/10f, (float)i/180f);
				float randVal1 = rand.NextFloat();
				float3 randVal2 = rand.NextFloat3();
				float3 randVal3 = rand.NextFloat3();
				float3 color = rand.NextFloat3();

				int seed = (int)Math.Floor((i+1 / 501) * 1000 + ColorSeed);
				rand.SetSeed(seed);
				float3 c = colorScheme[rand.NextInt(colorScheme.Length)] * (OffsetColor + OffsetOpacity);

				if(pos<0.01f) continue;
				if(pos>(beizerPoints.Length)/4)
				{
					continue;
				}
				int beizer = getBeizer(pos);
				//debug_log beizer;
				draw DefaultShading, Uno.Scenes.Primitives.Cube, {
					float3 VertexPosition: Vector.Transform(prev*CubeSize, Quaternion.RotationAxis(Vector.Normalize(randVal2), t+(randVal1*4f)))+
					CalculateBezierPoint(getBeizerOffset(pos), beizerPoints[(beizer*4)+0],beizerPoints[(beizer*4)+1], beizerPoints[(beizer*4)+2], beizerPoints[(beizer*4)+3])
					+((randVal3-float3(0.5f))*0.2f);

					//float3 r: colorScheme[(int)Math.Mod((int)Attrib2.X * (int)ColorSeed, (int)colorScheme.Length)] * OffsetColor;
					float3 DiffuseColor: c;
				}, virtual Context.Pass;
			}
			/*
			for(int i = 0; i < batches.Length; i++)
			{
				draw DefaultShading, c, batches[i], {
					float pos: req(Attrib1 as float4, Attrib0 as float4)getPos(t,Attrib0.W);
					int beizer: getBeizer(pos);
					float3 VertexPosition:
						req(Attrib1 as float4, Attrib0 as float4)Vector.Transform(
							(prev*5.0f),
							Quaternion.RotationAxis(Vector.Normalize(Attrib1.XYZ), ((float)t*(Attrib1.W+0.5f))+Attrib1.W))
						+ CalculateBezierPoint(0f, beizerPoints[(beizer*4)+0], beizerPoints[(beizer*4)+1], beizerPoints[(beizer*4)+2], beizerPoints[(beizer*4)+3])
						+ ((Attrib0.XYZ-0.5f)*3f);
				}, virtual c.Pass;
			}*/
		}
		private float getPos(float time, float offset)
		{
			return Math.Max(time-offset, 0);
		}
		private int getBeizer(float pos)
		{
			return Math.Min((int)Math.Floor(pos), (beizerPoints.Length-1)/4);
		}
		private float getBeizerOffset(float pos)
		{
			return pos-Math.Floor(pos);
		}
	}
}