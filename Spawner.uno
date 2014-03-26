using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
	public class Spawner: Entity
	{
		Entity _ent;
		float radius;
		int amount;
		float rotation;

		[DesignerName("Entity")]
		public Entity Ent { get{ return _ent; } set{ addEnt(value);} }

		[Range(1,25), DesignerName("Amount")]
		public int amountSetter {
			get {
				return amount;
			}
			set {
				amount = value;
				addObjects();
			}
		}

		[Range(1,500), DesignerName("Radius")]
		public float radiusSetter {
			get {
				return radius;
			}
			set {
				radius = value;
				addObjects();
			}
		}

		[Range(0, 360), DesignerName("Rotation")]
		public float rotationSetter {
			get {
				return rotation;
			}
			set {
				rotation = value;
				addObjects();
			}
		}

		[Range(0, 2), DesignerName("Axis")]
		public int axis { get; set; }

		[Range(0, 50), DesignerName("RotationSpeed")]
		public float rotSpeed { get; set; }

		// Radius, Theta, Rotation angle
		public List<float3> coordList = new List<float3>();

		public Spawner()
		{
			amount = 10;
			radius = 10;
			rotation = 0;
			rotSpeed = 10;
			axis = 2;

			addObjects();
			if (_ent != null) addEnt(_ent);
		}

		float2 radienT(float2 c)
		{
			float r = Math.Sqrt(c.X*c.X + c.Y*c.Y);
			float t = Math.Atan2(c.Y, c.X);

			return float2(r, t);
		}

		float2 radAng(float2 rt)
		{
			float x = rt.X * Math.Cos(rt.Y);
			float y = rt.X * Math.Sin(rt.Y);

			return float2(x, y);
		}

		void addEnt(Entity x)
		{
			if (!Children.IsEmpty)
				Children.Clear();

			if (x == null) return;

			Children.Add(x);
		}

		void addObjects()
		{
			if (coordList.Count > 0) coordList.Clear();
			float step = (2 * (float)Math.PI) / amount;

			float a = 0;
			for (int i = 0; i < amount; i++)
			{
				float2 pos = float2(radius * Math.Cos(a), radius * Math.Sin(a));
				coordList.Add(float3(radienT(pos), rotation));

				a += step;
			}
		}

		protected override void OnDraw()
		{
			if (Children.IsEmpty) return;
			var s = (Children[0] as Entity);
			float step = (2 * (float)Math.PI) / amount;
			float a = 0;

			foreach (var i in coordList)
			{
				float2 pos = radAng(float2(i.X, i.Y + Math.DegreesToRadians(i.Z)));
				s.Transform.Position = float3(pos, 0);
				if (axis == 0) // X
				s.Transform.RotationDegrees = float3(rotation * rotSpeed, s.Transform.RotationDegrees.YZ);
				if (axis == 1) // Y
				s.Transform.RotationDegrees = float3(s.Transform.RotationDegrees.X, rotation * rotSpeed, s.Transform.RotationDegrees.Z);
				if (axis == 2) // Z
				s.Transform.RotationDegrees = float3(s.Transform.RotationDegrees.XY, rotation * rotSpeed);
				s.OnDraw();
			}
		}
	}
}