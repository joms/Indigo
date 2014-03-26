using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
public class GridController: Entity
	{
		apply DefaultShading;

		Entity _tile;
		public Entity Tile { get { return _tile; } set { updateTile(value); } }

		float _spacing;
		int _width;
		int _length;
		float3 _scale;

		[Range(1, 100), Group("Grid")]
		public int Width {
			get {
				return _width;
			}
			set {
				_width = value;
				generateGrid();
			}
		}
		[Range(1, 100), Group("Grid")]
		public int Length {
			get {
				return _length;
			}
			set {
				_length = value;
				generateGrid();
			}
		}

		[Range(0, 10), Group("Grid")]
		public float Spacing {
			get {
				return _spacing;
			}
			set {
				_spacing = value;
				generateGrid();
			}
		}

		[Range(1, 100), Group("Grid")]
		public float3 Scaling {
			get {
				return _scale;
			}
			set {
				_scale = value;
				generateGrid();
			}
		}



		[Range(0, 100), Group("Rotation")]
		public float Speed {get; set;}

		[Range(0, 50), Group("Rotation")]
		public float Offset {get; set;}

		[Range(-5, 5), Group("Rotation")]
		public float OffsetOffsetter {get; set;}

		[Group("Effect")]
		public bool Rings {get;set;}
		[Range(0, 25), Group("Effect")]
		public float RingOffsetter { get; set; }

		public float AnimationTime { get; set; }

		List<Transform> _tList = new List<Transform>();

		public GridController()
		{
			_width = 50;
			_length = 50;
			_spacing = 5f;
			_scale = float3(1, 1, 0.5f);

			Offset = 0.5f;

			AnimationTime = 0;

			if (_tile != null) updateTile(_tile);
			generateGrid();
		}

		void updateTile(Entity x)
		{
			if (!Children.IsEmpty)
				Children.Clear();

			if (x == null) return;

			Children.Add(x);
		}

		void generateGrid()
		{
			_tList.Clear();

			for (int i = 0; i < Width; i++)
			{
				for (int j = 0; j < Length; j++)
				{
					var t = new Transform();
					//t.Position = float3(i * _spacing, j * _spacing, Math.Sin(i + j) * 2);
					t.Position = float3(i * _spacing, j * _spacing, 0);
					t.Scaling = _scale;

					_tList.Add(t);
				}
			}
		}

		float ripple(float3 p, float t)
		{
			float2 x = float2(p.X / _tList[_tList.Count - 1].Position.X, p.Y / _tList[_tList.Count - 1].Position.Y);
			p.X = x.X;
			p.Y = x.Y;

			p.X -= 0.5f;
			p.Y -= 0.5f;
			float squareRadius = p.X * p.X + p.Y * p.Y;
			//return 0.5f + Math.Sin(15f * (float)Math.PI * squareRadius - 2f * t) / (2f + 100f * squareRadius);
			return 0.5f + Math.Sin(15f * (float)Math.PI * squareRadius - 2f * t);
		}

		float2 getGrid(int tile)
		{
			float2 pos;
			pos.X = tile % _width;
			pos.Y = Math.Ceil(tile / _width) - 1;

			if (pos.X == 0) pos.X = 1;

			return pos;
		}

		protected override void OnDraw()
		{
			if (Children.IsEmpty) return;
			for (int i = 0; i < _tList.Count; i++)
			{
				var s = (Children[0] as Entity);

				float3 t = _tList[i].Position;

				float2 c = getGrid(i);

				float rx = Offset * (AnimationTime * Speed) + c.X * Offset;
				float ry = Offset * (AnimationTime * Speed) + c.Y * (Offset / OffsetOffsetter);

				if (Rings) t.Z = ripple(t, AnimationTime) * RingOffsetter;

				float sp = ry + rx;
				s.Transform.Position = t;
				s.Transform.RotationDegrees = float3(sp, 0, 0);
				s.OnDraw();
			}
		}
	}
}