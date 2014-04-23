using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Uno.Scenes.Batching;
using Uno.Designer;

namespace Glowbatch
{
	public class GlowBatch : Entity
	{
	    private Batch SingleBatch;

		public float AnimTime { get; set; }

		[Range(0, 1)]
		public float Freq { get; set; }
		[Range(10, 50)]
		public float Amp { get; set; }
		public float RandSeed { get; set; }

		[Color]
		public float3 GlowColor { get; set; }

		[Color]
		public float3 NoColor { get; set; }

		public float CubeScale { get; set; }

		[Range(0,50)]
		public float Const1 { get; set; }
		[Range(1,50)]
		public float Const2 { get; set; }
		[Range(1,50)]
		public float Const3 { get; set; }
		[Range(0,100)]
		public float Const4 { get; set; }

		int cubeCount;
	    public GlowBatch()
	    {
	        const int maxVertices = 65535;

	        var cube = Uno.Content.Models.MeshGenerator.CreateCube(float3(0), 1);

	        cubeCount = maxVertices / cube.VertexCount;
	        int verticeCount = cubeCount * cube.VertexCount;
	        int indiceCount = cubeCount * cube.IndexCount;

	        SingleBatch = new Batch(verticeCount, indiceCount, true);

			int offsetVal = 0;
			var random = new Random(10);

	        int i, j;
	        int indexAdd = 0;
	        for(i = 0; i < cubeCount; i++)
	        {
				float3 color = random.NextFloat3();
	            for(j = 0; j < cube.VertexCount; j++)
	            {
	                SingleBatch.Positions.Write(cube.Positions.GetFloat4(j).XYZ);
	                SingleBatch.Normals.Write(cube.Normals.GetFloat4(j).XYZ);
	                SingleBatch.TexCoord0s.Write(cube.TexCoords.GetFloat4(j).XY);
					SingleBatch.Attrib0Buffer.Write(float4(i,i,i, random.NextInt(0, 10)));
					SingleBatch.Attrib1Buffer.Write(float4(color, 1));
	            }

	            for(j = 0; j < cube.IndexCount; j++)
	            {
	                SingleBatch.Indices.Write((ushort)(cube.Indices.GetInt(j) + indexAdd));
	            }
	            indexAdd += cube.VertexCount;
	        }

	    }

	    override protected void OnDraw()
	    {
			var rand = new Random((int)RandSeed);
			int rr = rand.NextInt(0, 10);
			draw DefaultShading, SingleBatch
	        {
				float3 dc: {
					if (rr == (int)Attrib0.W)
					{
						return NoColor;
					} else {
						return GlowColor;
					}
				};
	            DiffuseColor : dc;

				float r: Const1 + Math.Sin(2 * (Attrib0.X / 10)) * Const4;
				float xfloatsie: r * Math.Cos(Attrib0.X / Const2);
				float yfloatsie: r * Math.Sin(Attrib0.X / 30);
				float zfloatsie: r * Math.Sin(Attrib0.X / Const3);

				VertexPosition: prev + Vector.Transform(prev * CubeScale,
				Quaternion.RotationAxis(Vector.Normalize(Attrib0.XXX), (float)Application.Current.FrameTime+Attrib0.X))
				+ float3(Math.Sin(Attrib0.X) * Amp, Attrib0.X * Freq, Math.Cos(Attrib0.X) * Amp)
				+ float3(xfloatsie, yfloatsie, zfloatsie);
	        };
	    }
	}
}