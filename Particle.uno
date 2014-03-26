using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace CubeTree
{
	[ComponentOf("Uno.Scenes.Entity")]
	public class Particle: MeshRenderer
	{
		static Material mat = new DefaultMaterial();
		static Mesh mesh = new Mesh(MeshGenerator.CreateSphere(float3(0.0f), 5f, 4, 4));
		public Particle()
		{
			Mesh = mesh;
			Material = mat;
		}
	}
}