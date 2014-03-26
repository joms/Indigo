using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;
using Uno.Scenes.Batching;

namespace Everythingspawner
{
	public class TerrainPart : Node
	{
		//Variabler
		int mapSize = 500;

		List<Batch> batches = new List<Batch>();
		int maxVertices = 65535;
		int maxIndices = (65535/4)*6;

		int numVertsCur = 0;
		int numIndicesCur = 0;

		//Noise thingies

		Perlin perlin = new Perlin(1337L, 20);
		Perlin perlin2 = new Perlin(69L, 250);
		Perlin perlin3 = new Perlin(133769L, 30);

		//Stats
		int vertsPushed = 0;
		int trianglesPushed = 0;

		//Colors
		[Range(0,100)]
		public float ColorSeed { get; set; }

		[Color]
		public float3 OffsetGroundColor { get; set; }
		[Range(0,1)]
		public float OffsetOpacity { get; set; }
		[Range(0,1)]
		public float DarkestColor { get; set; }

		[Color]
		public float3 VikingskipetColor { get; set; }

		float3 currentColor = float3(1,0,0);

		//float3[] colorScheme = new[] {float3(0.36f ,0.88f ,0.00f),float3(0.37f ,0.66f ,0.16f),float3(0.24f ,0.57f ,0.00f),float3(0.53f ,0.94f ,0.24f),float3(0.64f ,0.94f ,0.42f),float3(0.06f ,0.31f ,0.66f),float3(0.16f ,0.30f ,0.49f),float3(0.02f ,0.19f ,0.43f),float3(0.26f ,0.50f ,0.83f),float3(0.41f ,0.59f ,0.83f),float3(1.00f ,0.62f ,0.00f),float3(0.75f ,0.54f ,0.19f),float3(0.65f ,0.41f ,0.00f),float3(1.00f ,0.72f ,0.25f),float3(1.00f ,0.79f ,0.45f),float3(0.91f ,0.00f ,0.24f),float3(0.68f ,0.17f ,0.31f),float3(0.59f ,0.00f ,0.16f),float3(0.95f ,0.24f ,0.43f),float3(0.95f ,0.43f ,0.57f)};
		float3[] colorScheme = new [] {float3(0.33f ,0.59f ,0.80f),float3(0.33f ,0.57f ,0.76f),float3(0.27f ,0.54f ,0.75f),float3(0.39f ,0.64f ,0.84f),float3(0.43f ,0.66f ,0.84f)};


		/*
			//TOP SECRET DONT STEAL PLEASE
			Step 1: Generate heightmap
			Step 2: March 3d grid. If a side's height is less then current height, add a side
			Step 3: Batch system is dynamic.
		*/

		public TerrainPart()
		{
			generateTerrain();
		}

		protected override void OnInitialize()
		{
			base.OnInitialize();
		}
		/*
		public float3 genRandomColor(float seed)
		{
			var rand = new Random((int)seed * (int)ColorSeed);
			return colorScheme[rand.NextInt(colorScheme.Length)];
		}
*/
		public void generateTerrain()
		{
			//-1, -1
			//1, -1
			//1, 1
			//-1, 1
			var TopVertices = new [] {float3(-1,-1,1),float3(1,-1,1),float3(1,1,1),float3(-1,1,1)};
			var TopTexCoords = new[] {float2(0,0), float2(0,1), float2(1,1), float2(1,0)};
			//-1, -1
			//1, -1
			//1, 1
			//-1, 1
			var FrontVertices = new [] {float3(-1,1,-1),float3(1,1,-1),float3(1,1,1),float3(-1,1,1)};
			var FrontTexCoords = new[] {float2(0,0), float2(0,1), float2(1,1), float2(1,0)};
			//-1, -1
			//1, -1
			//1, 1
			//-1, 1
			var BackVertices = new [] {float3(-1,-1,-1),float3(1,-1,-1),float3(1,-1,1),float3(-1,-1,1)};
			var BackTexCoords = new[] {float2(0,0), float2(0,1), float2(1,1), float2(1,0)};
			//-1, -1
			//1, -1
			//1, 1
			//-1, 1
			var LeftVertices = new [] {float3(1,-1,-1),float3(1,1,-1),float3(1,1,1),float3(1,-1,1)};
			var LeftTexCoords = new[] {float2(0,0), float2(0,1), float2(1,1), float2(1,0)};
			//-1, -1
			//1, -1
			//1, 1
			//-1, 1
			var RightVertices = new [] {float3(-1,-1,-1),float3(-1,1,-1),float3(-1,1,1),float3(-1,-1,1)};
			var RightTexCoords = new[] {float2(0,0), float2(0,1), float2(1,1), float2(1,0)};

			var QuadIndices = new int[] { 0,1,2,2,3,0 };
			var QuadReverseIndices = new int[] { 2,1,0,0,3,2 };

			int numSidesPerBatch = maxVertices/6;

			int sideCount = maxVertices/TopVertices.Length;
			int verticeCount = sideCount * TopVertices.Length;
			int indiceCount = sideCount * QuadIndices.Length;

			var rand = new Random(133769);

			float lowestPerlin = 0f;
			float highestPerlin = 0f;

			batches.Add(new Batch(maxVertices, maxIndices, true));

			for(int x = 0; x < mapSize; x++)
			{
				for(int y = 0; y < mapSize; y++)
				{
					float h = getPerlin(x, y);
					if(h<lowestPerlin)
					{
						lowestPerlin = h;
					}
					if(h>highestPerlin)
					{
						highestPerlin = h;
					}

					//Add top layer
					pushVertices(TopVertices, TopTexCoords, QuadIndices, float4((float)x, (float)y, (float)h, rand.NextInt(colorScheme.Length)), float3(0,0,1));

					//Get neighbour perlin heights
					int frontHeight = (int)getPerlin(x, y+1);
					int backHeight = (int)getPerlin(x, y-1);
					int leftHeight = (int)getPerlin(x+1, y);
					int rightHeight = (int)getPerlin(x-1, y);

					//Iterate through layers under H
					//debug_log "iterating from 0 to " + (int)Math.Round(h) + ". Front height: " + frontHeight + ", back: " + backHeight + ", left: " + leftHeight + ", right: " + rightHeight;
					for(int z = 0; z <= (int)Math.Round(h); z++)
					{
						if(z>frontHeight)
						{
							//If terrain in front of us is lower, add face
							pushVertices(FrontVertices, FrontTexCoords, QuadReverseIndices, float4((float)x, (float)y, (float)z, 0f), float3(0,1,0));
						}
						if(z>backHeight)
						{
							//If terrain in front of us is lower, add face
							pushVertices(BackVertices, BackTexCoords, QuadIndices, float4((float)x, (float)y, (float)z, 0f), float3(0,-1,0));
						}
						if(z>leftHeight)
						{
							//If terrain in front of us is lower, add face
							pushVertices(LeftVertices, LeftTexCoords, QuadIndices, float4((float)x, (float)y, (float)z, 0f), float3(1,0,0));
						}
						if(z>rightHeight)
						{
							//If terrain in front of us is lower, add face
							pushVertices(RightVertices, RightTexCoords, QuadReverseIndices, float4((float)x, (float)y, (float)z, 0f), float3(-1,0,0));
						}
						//debug_log s;
					}
				}
			}
			debug_log "Done!";
			//debug_log "Lowest perlin was " + lowestPerlin;
			//debug_log "Highest perlin was " + highestPerlin;
			/*
			//Actually generate. Yolo.
			for(int cx = 0; cx < numChunks; cx++)
			{
				for(int cy = 0; cy < numChunks; cy++)
				{
					//New chunk
					int indiceOffset = 0;
					for(int x = 0; x < chunkSize; x++)
					{
						for(int y = 0; y < chunkSize; y++)
						{
							//Add a cube

							//Simple layer based terrain generation
							//This is how perlin maps are born <3

							float perlin1f = (float)perlin.getNoiseLevelAtPosition((cx*chunkSize)+x, (cy*chunkSize)+y)*7.0f;
							float perlin2f = (float)perlin2.getNoiseLevelAtPosition((cx*chunkSize)+x, (cy*chunkSize)+y)*10.0f;
							float perlin3f = (float)perlin3.getNoiseLevelAtPosition((cx*chunkSize)+x, (cy*chunkSize)+y)*5.0f;

							float perlinHeight = (float)Math.Round((perlin1f+perlin2f+perlin3f)*1.0f);
							float4 attrib0 = float4((cx*chunkSize)+x, (cy*chunkSize)+y, perlinHeight, 0);
							for(int j = 0; j < cube.Positions.Length; j++)
							{
								batches[cx+(cy*numChunks)].Positions.Write(cube.Positions.GetFloat4(j).XYZ);
								batches[cx+(cy*numChunks)].Normals.Write(cube.Normals.GetFloat4(j).XYZ);
								batches[cx+(cy*numChunks)].TexCoord0s.Write(cube.TexCoords.GetFloat4(j).XY);
								batches[cx+(cy*numChunks)].Attrib0Buffer.Write(attrib0);
							}

							for(int j = 0; j < cube.Indices.Length; j++)
							{
								batches[cx+(cy*numChunks)].Indices.Write((ushort)(cube.Indices.GetInt(j) + indiceOffset));
							}

							indiceOffset += cube.Positions.Length;
						}
					}
				}
			}
			*/
		}
		public float getPerlin(int x, int y)
		{
			float perlin1f = (float)perlin.getNoiseLevelAtPosition(x, y)*7.0f;
			float perlin2f = (float)perlin2.getNoiseLevelAtPosition(x, y)*200.0f;
			//float perlin2f = (float)perlin2.getNoiseLevelAtPosition(x, y)*10.0f;
			float perlin3f = (float)perlin3.getNoiseLevelAtPosition(x, y)*15.0f;

			return (float)Math.Round((perlin1f+perlin2f+perlin3f)*1.0f);
		}
		public void pushVertices(float3[] verts, float2[] texCoords, int[] indices, float4 attrib, float3 normal)
		{
			if(verts.Length+numVertsCur>maxVertices||indices.Length+numIndicesCur>maxIndices)
			{
				debug_log "Making new batch. We have now pushed " + vertsPushed + " vertices, and " + trianglesPushed + "triangles.";
				batches.Add(new Batch(maxVertices, maxIndices, true));
				numIndicesCur = 0;
				numVertsCur = 0;
			}
			//Push verts and attrib
			for(int i = 0; i < verts.Length; i++)
			{
				batches[batches.Count-1].Positions.Write(verts[i]);
				batches[batches.Count-1].Normals.Write(normal);
				batches[batches.Count-1].Attrib0Buffer.Write(attrib);
			}
			//Push tex coords
			for(int i = 0; i < texCoords.Length; i++)
			{
				batches[batches.Count-1].TexCoord0s.Write(texCoords[i]);
			}
			//Push indices
			for(int i = 0; i < indices.Length; i++)
			{
				batches[batches.Count-1].Indices.Write((ushort)(indices[i]+numVertsCur));
			}
			vertsPushed += verts.Length;
			trianglesPushed += indices.Length/3;
			numIndicesCur += indices.Length;
			numVertsCur += verts.Length;
		}

		static int randomfoo(int length, int id, int seed)
		{
			Random rand = new Random(seed * id);

			return rand.NextInt(length);
		}

		Texture2D p = import Texture2D("Assets/Perlin.png");
		protected override void OnDraw()
		{
			base.OnDraw();
			for(int i = 0; i < batches.Count; i++)
			{
				//if(batches[i]==null) continue;
				draw DefaultShading, batches[i]
				{

					float3 r: colorScheme[(int)Math.Mod((int)Attrib0.W * (int)ColorSeed, (int)colorScheme.Length)] * OffsetGroundColor;

					//DiffuseColor: r * OffsetGroundColor;

					//float c: sample(p, float2(Math.Sin(Attrib0.W * ColorSeed), Math.Cos(Attrib0.W * ColorSeed))).X;
					float c: sample(p, float2((1 - (Attrib0.X / 500)) , (1 - (Attrib0.Y / 500)))).X;
					float3 color: {
						if (c < DarkestColor )
						{
							return float3(c + DarkestColor);
						}/*
						else if (c < DarkestColor + 0.01f)
						{
							return float3(c + 0.01f);
						}
						else if (c < DarkestColor + 0.02f)
						{
							return float3(c + 0.02f);
						}*/else {
							return float3(c - 0.25f, c + 0.25f, c - 0.25f) - 0.5f;
						}
					};
					DiffuseColor: (color * OffsetOpacity) + r;
					VertexPosition: ((prev*0.5f) + (float3(Attrib0.X, Attrib0.Y, Attrib0.Z)*1f))*2f;
					apply virtual Context.Pass;
				};
			}
		}
	}
}