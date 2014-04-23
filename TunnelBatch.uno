using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Uno.Scenes.Batching;
using Uno.Designer;

namespace Untitled
{
	public class TunnelBatch : Entity
	{
	    private Batch SingleBatch;

		public float AnimTime { get; set; }

		[Range(0, 1)]
		public float Freq { get; set; }
		[Range(10, 50)]
		public float Amp { get; set; }
		public float CubeScale { get; set; }

		[Range(1.0f, 10.0f)]
		public float cubeScale { get; set; }

		[Range(0.5f, 5.0f)]
		public float scaleRandomScale { get; set; }

		[Range(0.1f,10.0f)]
		public float cubeSpacing { get; set; }

		[Range(0.1f, 5.0f)]
		public float positionRandomScale { get; set; }

		[Range(1f, 200f)]
		public float circleSize { get; set; }

		[Range(0.5f, 10.0f)]
		public float cubeLength { get; set; }

		[Range(0,50)]
		public float Const1 { get; set; }
		[Range(1,50)]
		public float Const2 { get; set; }
		[Range(1,50)]
		public float Const3 { get; set; }
		[Range(0,100)]
		public float Const4 { get; set; }

		int cubeCount;
	    public TunnelBatch()
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
	            for(j = 0; j < cube.VertexCount; j++)
	            {
	                SingleBatch.Positions.Write(cube.Positions.GetFloat4(j).XYZ);
	                SingleBatch.Normals.Write(cube.Normals.GetFloat4(j).XYZ);
	                SingleBatch.TexCoord0s.Write(cube.TexCoords.GetFloat4(j).XY);
					SingleBatch.Attrib0Buffer.Write(float4(i,i,i, random.NextFloat()));
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
			float offset = (float)cubeCount/cubeLength;
	        draw DefaultShading, SingleBatch
			{
				PixelColor: float4(1,0,1,1);

				float r: Const1 + Math.Sin(2 * (Attrib0.X / 10)) * Const4;
				float xfloatsie: r * Math.Cos(Attrib0.X / Const2);
				float yfloatsie: r * Math.Sin(Attrib0.X / 30);
				float zfloatsie: r * Math.Sin(Attrib0.X / Const3);

				VertexPosition: prev + Vector.Transform(prev * CubeScale,
				Quaternion.RotationAxis(Vector.Normalize(Attrib0.XXX), (float)Application.Current.FrameTime+Attrib0.X))
				+ float3(Math.Sin(Attrib0.X) * Amp, Attrib0.X * Freq, Math.Cos(Attrib0.X) * Amp)
				+ float3(xfloatsie, yfloatsie, zfloatsie);

				apply virtual Context.Pass;
			};
	    }
	}
}