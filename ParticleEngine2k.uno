using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
	public class ParticleEngine2k: Entity
	{
		apply DefaultShading;

		Entity _particle;
		int _width;
		int _length;
		int _height;
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

		public float ball { get; set; }

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
		[Range(1, 100)]
		public int Height {
			get{
				return _height;
			}
			set{
				_height = value;
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
		[Range(0,1)]
		public float Threshold { get; set; }

		[Range(0,50)]
		public float amp { get; set; }

		List<float3> coordList = new List<float3>();

		public ParticleEngine2k()
		{
			_height = 10;
			_width = 10;
			_length = 10;
			Spacing = 10;

			calculateCoords();
			addEntity(_particle);
		}

		void calculateCoords()
		{
			coordList.Clear();

			for (int x = 0; x < _width; x++)
			{
				for (int y = 0; y < _length; y++)
				{
					for (int z = 0; z < _height; z++)
					{
						coordList.Add(float3(x, y, z) * _spacing);
					}
				}
			}
		}

		float3 offPos(float3 p)
		{
			float x = p.X / coordList[coordList.Count - 1].X;
			float y = p.Y / coordList[coordList.Count - 1].Y;
			float z = p.Z / coordList[coordList.Count - 1].Z;

			return float3(x, y, z);
		}

		float calcSquareRadius(float3 p)
		{
			p = offPos(p);
			p -= 0.5f;

			return p.X * p.X + p.Y * p.Y + p.Z * p.Z;
		}

		float ripple(float3 p, float t)
		{
			float squareRadius = calcSquareRadius(p);
			//return 0.5f + Math.Sin(15f * (float)Math.PI * squareRadius - 2f * t) / (2f + 100f * squareRadius);
			//return 0.5f + Math.Sin(15f * (float)Math.PI * squareRadius - 2f * t);
			return Math.Sin(4f * (float)Math.PI * squareRadius - 2f * t);
		}

		float sine (float3 p, float t){
			p = offPos(p);

			float x = Math.Sin((2 * (float)Math.PI * p.X) * amp);
			float y = Math.Sin((2 * (float)Math.PI * p.Y) * amp);
			float z = Math.Sin((2 * (float)Math.PI * p.Z + (p.Y > 0.5f ? t : -t)) * amp);
			return x * x * y * y * z * z;
		}

		void addEntity(Entity x)
		{
			if (!Children.IsEmpty) Children.Clear();
			if (x == null) return;

			_particle = x;
			Children.Add(x);
		}

		protected override void OnDraw()
		{
			if (!Children.IsEmpty)
			{
				Entity e = (Children[0] as Entity);

				foreach (float3 t in coordList)
				{
					float x = sine(t, AnimTime);
					if (ball > 1) x = ripple(t, AnimTime);

					if (x > Threshold)
					{
						e.Transform.Position = t;
						e.OnDraw();
					}
				}
			} else return;
		}
	}
}