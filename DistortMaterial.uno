using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Untitled
{
	public class DistortMaterial: DefaultMaterial
	{
		[Group("Distort"), Range(0, 10)]
		public float Amplitude { get; set; }

		[Group("Distort"), Range(0, 10)]
		public float Frequence { get; set; }

		[Group("Distort")]
		public float3 Coords { get; set; }

		float time: ((float)Time / 4f) - Vector.Length(prev VertexPosition) / 4f;

		VertexPosition : prev + float3(0, 0, Math.Cos(time) * (Amplitude * 2.5f));
		VertexPosition: Vector.Transform(prev, Quaternion.RotationAxis(Coords, Math.Sin(time * Frequence) * Amplitude));
	}
}