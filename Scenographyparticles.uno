using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
	public class Scenographyparticles: Entity
	{
		apply DefaultShading;

		Entity _particle;
		int _width;
		int _length;
		float _spacing;

		public float AnimTime { get; set; }

		public Entity Particle {
			get {
				return _particle;
			}
			set {
				addEntity(value);
			}
		}

		[Range(1, 100)]
		public int Width {
			get{
				return _width;
			}
			set{
				_width = value;
				calculateCoords();
			}
		}
		[Range(1, 100)]
		public int Length {
			get{
				return _length;
			}
			set{
				_length = value;
				calculateCoords();
			}
		}
		[Range(0, 50)]
		public float Spacing {
			get{
				return _spacing;
			}
			set{
				_spacing = value;
				calculateCoords();
			}
		}
		[Range(0,100)]
		public float zOffset { get; set; }
		[Range(0,10)]
		public float AnimSpeed { get; set; }

		// Z-offsetter
		List<float4> offsetterList = new List<float4>();
		List<float2> coordList = new List<float2>();

		public Scenographyparticles()
		{
			calculateCoords();
			addEntity(_particle);
		}

		void addEntity(Entity x)
		{
			if (!Children.IsEmpty) Children.Clear();
			if (x == null) return;

			_particle = x;
			Children.Add(x);
		}

		void calculateCoords()
		{
			coordList.Clear();
			offsetterList.Clear();

			for (int i = 0; i < _width; i++)
			{
				for (int j = 0; j < _length; j++)
				{
					float2 t = float2(i * _spacing, j * _spacing);
					calculateOffsetters(i * j);

					coordList.Add(t);
				}
			}
		}

		void calculateOffsetters(int seed)
		{
			var r = new Random(seed);
			offsetterList.Add(r.NextFloat4());

		}

		protected override void OnDraw()
		{
			if (!Children.IsEmpty)
			{
				Entity e = (Children[0] as Entity);
				for (int i = 0; i < coordList.Count; i++)
				{
					e.Transform.Position = float3(coordList[i], Math.Sin(offsetterList[i].X * AnimTime * AnimSpeed) * zOffset);
					e.OnDraw();
				}
			}
			else return;
		}
	}
}