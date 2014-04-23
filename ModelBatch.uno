using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Uno.Scenes.Batching;
using Uno.Designer;

namespace ModelBatch
{
	public class ModelBatcher : Entity
	{
	    private Batch SingleBatch;

		public float offsetX { get; set; }
		public float offsetY { get; set; }


		int poleCount;
	    public ModelBatcher()
	    {
	        const int maxVertices = 65535;

			//var outerPole = import Model("pole_outer.FBX");
			//var pole = outerPole.GetDrawable(0).Mesh;

			var pole = Uno.Content.Models.MeshGenerator.CreateCube(float3(0), 1);

	        poleCount = maxVertices / pole.VertexCount;

	        int verticeCount = poleCount * pole.VertexCount;
	        int indiceCount = poleCount * pole.IndexCount;

	        SingleBatch = new Batch(verticeCount, indiceCount, true);

			int offsetVal = 0;
			var random = new Random(10);

	        int i, j;
	        int indexAdd = 0;
	        for(i = 0; i < poleCount; i++)
	        {
	            for(j = 0; j < pole.VertexCount; j++)
	            {
	                SingleBatch.Positions.Write(pole.Positions.GetFloat4(j).XYZ);
	                SingleBatch.Normals.Write(pole.Normals.GetFloat4(j).XYZ);
	                SingleBatch.TexCoord0s.Write(pole.TexCoords.GetFloat4(j).XY);
					SingleBatch.Attrib0Buffer.Write(float4(i, i, getCoord(i)));
	            }

	            for(j = 0; j < pole.IndexCount; j++)
	            {
	                SingleBatch.Indices.Write((ushort)(pole.Indices.GetInt(j) + indexAdd));
	            }
	            indexAdd += pole.VertexCount;
	        }

	    }

		float2 getCoord(int tile)
		{
			float2 pos;
			pos.X = tile % 50;
			pos.Y = Math.Ceil(tile / 50) - 1;

			if (pos.X == 0) pos.X = 1;

			return pos;
		}

	    override protected void OnDraw()
	    {
	        draw DefaultShading, SingleBatch
			{
				PixelColor: float4(Attrib0.Z / 50,0, Attrib0.W / 50,1);

				float t: (float)Application.Current.FrameTime;
				VertexPosition: prev + Vector.Transform(3* float3(Attrib0.Z + offsetX, Attrib0.W + offsetY, Math.Sin((Attrib0.Z + t) * 0.5f) + Math.Sin((Attrib0.W + t) * 0.5f)), Quaternion.RotationAxis(Vector.Normalize(Attrib0.XXX), 0));

				apply virtual Context.Pass;
			};

			draw DefaultShading, SingleBatch
			{
				PixelColor: float4(Attrib0.Z / 50,0, Attrib0.W / 50,1);

				float t: (float)Application.Current.FrameTime;
				VertexPosition: prev + Vector.Transform(6* float3(Attrib0.Z + offsetX, Attrib0.W + offsetY, (Math.Sin((Attrib0.Z + t) * 0.5f) + Math.Sin((Attrib0.W + t) * 0.5f)) * 0.65f), Quaternion.RotationAxis(Vector.Normalize(Attrib0.XXX), 0));

				Scale: float3(0.5f, 0.5f, 1);

				apply virtual Context.Pass;
			};

						draw DefaultShading, SingleBatch
			{
				PixelColor: float4(Attrib0.Z / 50,0, Attrib0.W / 50,1);

				float t: (float)Application.Current.FrameTime;
				VertexPosition: prev + Vector.Transform(12* float3(Attrib0.Z + offsetX, Attrib0.W + offsetY, (Math.Sin((Attrib0.Z + t) * 0.5f) + Math.Sin((Attrib0.W + t) * 0.5f)) * 0.4f), Quaternion.RotationAxis(Vector.Normalize(Attrib0.XXX), 0));

				Scale: float3(0.25f, 0.25f, 1);

				apply virtual Context.Pass;
			};
	    }
	}
}