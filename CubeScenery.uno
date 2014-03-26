using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Uno.Scenes.Batching;

namespace Everythingspawner
{
	public class CubeScenery : Node
	{
		public texture2D cubeTex { get; set; }
		
		//								  X, Y, Z, R, G, B, SCALE
		public float[] data = new float[]{0f,0f,0f,1f,0f,0f,1f};
		
		Batch[] batches;
		
		protected override void OnInitialize()
		{
			base.OnInitialize();
			
			int totalCubes = data.Length/7;
			int maxVertices = 65535;
			var cube = Uno.Content.Models.MeshGenerator.CreateCube(float3(0,0,0), .5f);
			
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
			for(int i = 0; i < data.Length/7; i++)
			{
				//debug_log "yo";
				int batchId = i/numCubesPerBatch;
				int offsetInBatch = i%numCubesPerBatch;
				//debug_log batchId;
				//debug_log offsetInBatch;
				float4 attrib0 = float4(data[(i*7)+0], data[(i*7)+1], data[(i*7)+2],0);
				float4 attrib1 = float4(data[(i*7)+3], data[(i*7)+4], data[(i*7)+5],0);
				//debug_log "yo";
				for(int a = 0; a < cube.Positions.Count; a++)
				{
					batches[batchId].Positions.Write(cube.Positions.GetFloat4(a).XYZ*data[(i*7)+6]);
					batches[batchId].Normals.Write(cube.Normals.GetFloat4(a).XYZ);
					batches[batchId].TexCoord0s.Write(cube.TexCoords.GetFloat4(a).XY);
					batches[batchId].Attrib0Buffer.Write(attrib0);
					batches[batchId].Attrib1Buffer.Write(attrib1);
				}
				//debug_log "yo";
				for(int a = 0; a < cube.Indices.Count; a++)
				{
					batches[batchId].Indices.Write((ushort)(cube.Indices.GetInt(a) + cube.Positions.Count*offsetInBatch));
				}
			}
		}
		
		protected override void OnDraw()
		{
			base.OnDraw();
			for(int i = 0; i < batches.Length; i++)
			{
				draw DefaultShading, batches[i]
				{
					DiffuseMap: cubeTex;
					VertexPosition: prev + Attrib0.XYZ;
					DiffuseColor: Attrib1.XYZ;
				};
			}
		}
	}
}