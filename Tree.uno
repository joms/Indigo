using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace CubeTree
{
	public class Tree: Entity
	{
		apply DefaultShading;
		int _Seed;

		Entity _tCube;
		float _tLength;
		int _tDens;
		float _tTScale;
		float _tBScale;
		bool _tTrunk;

		int _bDepth;
		int _bDens;
		float _bRecAngle;
		float _bDist;

		bool _lLeaf;
		int _lRes;
		Entity _lParticle;

		[Range(0, 1)]
		public float AnimationTime { get; set; }

		public float3 TreePos { get; set; }

		[Range(0, 100)]
		public int Seed { get {return _Seed; } set { _Seed = value; Refresh(); } }

		[Group("Trunk"), DesignerName("Cube")]
		public Entity TCube {
			get {
				return _tCube;
			}
			set {
				_tCube = value;
				Refresh();
			}
		}

		[Range(1, 250), Group("Trunk"), DesignerName("Length")]
		public float TLength {
			get {
				return _tLength;
			}
			set {
				_tLength = value;
				Refresh();
			}
		}

		[Range(2, 25), Group("Trunk"), DesignerName("Density")]
		public float TDens {
			get {
				return _tDens;
			}
			set {
				_tDens = (int)value;
				Refresh();
			}
		}

		[Range(0.1f, 20), Group("Trunk"), DesignerName("Top Scale")]
		public float TTScale {
			get {
				return _tTScale;
			}
			set {
				_tTScale = value;
				Refresh();
			}
		}

		[Range(0.1f, 20), Group("Trunk"), DesignerName("Bottom Scale")]
		public float TBScale {
			get {
				return _tBScale;
			}
			set {
				_tBScale = value;
				Refresh();
			}
		}

		[Range(1, 10), Group("Branch"), DesignerName("Depth")]
		public float BDepth {
			get {
				return _bDepth;
			}
			set {
				_bDepth = (int)value;
				Refresh();
			}
		}

		[Range(1, 10), Group("Branch"), DesignerName("Density")]
		public int BDensity {
			get {
				return _bDens;
			}
			set {
				_bDens = value;
				Refresh();
			}
		}

		[Range(1, 90), Group("Branch"), DesignerName("Angle")]
		public float BRecAngle {
			get {
				return _bRecAngle;
			}
			set {
				_bRecAngle = value;
				Refresh();
			}
		}

		[Range(1, 30), Group("Branch"), DesignerName("Distance")]
		public float BDist {
			get {
				return _bDist;
			}
			set {
				_bDist = value;
				Refresh();
			}
		}

		[Group("Branch"), DesignerName("Enabled")]
		public bool TTrunk {
			get {
				return _tTrunk;
			}
			set {
				_tTrunk = value;
				Refresh();
			}
		}

		[Group("Leaf"), DesignerName("Particles")]
		public Entity LLeafp {
			get {
				return _lParticle;
			}
			set {
				_lParticle = value;
				Refresh();
			}
		}

		[Range(0, 360), Group("Leaf"), DesignerName("Angle")]
		public float _lAng { get; set; }

		[Range(0, 500), Group("Leaf"), DesignerName("Origo offset")]
		public float _lOrigOff { get; set; }

		[Group("Leaf"), DesignerName("Endpos")]
		public float3 _lEndPos { get; set; }

		static Material mat =  new DefaultMaterial();
		Mesh CubeGen = new Mesh(MeshGenerator.CreateCube(float3(0f), 1f));
		Mesh SphereGen = new Mesh(MeshGenerator.CreateSphere(float3(0f), 1f, 4, 4));

		List<float3> Leaves = new List<float3>();
		List<Transform> Cubes = new List<Transform>();

		public Tree()
		{
			_Seed = 1;

			_tLength = 50;
			_tDens = 5;
			_tTScale = 1;
			_tBScale = 1;
			_tTrunk = true;

			_bDepth = 9;
			_bDens = 2;
			_bRecAngle = 20;
			_bDist = 10;

			_lRes = 4;

			Trunk(float3(0), _tLength, _tDens);
		}

		void Refresh()
		{
			Children.Clear();
			Leaves.Clear();
			Cubes.Clear();
			Trunk(float3(0), _tLength, _tDens);
			if (_tCube != null) Children.Add(_tCube);
			if (_lParticle != null) Children.Add(_lParticle);
		}

		float rand(int x)
		{
			float z = Math.Sin(x++) * 10000;
    		return z - Math.Floor(z);
		}

		// Create base of tree
		void Trunk(float3 start, float length, int dens)
		{
			var randDepth = Math.Abs(4 + (int)(rand(_Seed) * 10) - _bDepth);

			if (_tTrunk == true && randDepth > 2)
			{
				for (int i = 0; i <= dens; i++)
				{
					float id = (float)i / (float)dens;
					float3 step = Math.Lerp(start, start + length, id);
					var t = new Transform();
					t.Position = float3(0, 0, step.Z);
					t.Scaling = float3(Math.Lerp(_tBScale, _tTScale, id));
					CreateCube(t);
				}
			}


			GenTree(float3(start.XY, start.Z + length), -90, randDepth);
		}

		void GenTree(float3 start, float angle, int depth)
		{
			float randAng = 15 + (rand(_Seed) * (_bRecAngle - 15));
//			float randAng = rand.NextFloat() * 90;

			if (depth != 0)
			{
				float3 end;
				float a = Math.DegreesToRadians(angle);

				end.X = start.X - (Math.Cos(a) * depth * _bDist);
				end.Y = 0;
				end.Z = start.Z - (Math.Sin(a) * depth * _bDist);

				Branch(start, end, angle, depth);
				GenTree(end, angle - randAng, depth -1);
				GenTree(end, angle + randAng, depth -1);
			}

			if (depth == 0)
			{
				Leaves.Add(float3(radienT(start.XY), start.Z));
			}
		}

		void Branch(float3 start, float3 end, float angle, float scale)
		{
			for (int i = 1; i <= _bDens; i++)
			{
				float3 step = Math.Lerp(start, end, (float)i / (float)_bDens);
				var t = new Transform();
				t.Position = step;
				t.Scaling = float3(scale);
				CreateCube(t);
			}

		}

		void CreateCube(Transform t)
		{
			/*
			var e = new Entity();
			e.Components.Add(t);
			e.Components.Add(new MeshRenderer() { Mesh = CubeGen, Material = mat });
			Children.Add(e);
			*/
			Cubes.Add(t);
		}

		void CreateSphere(Transform t)
		{
			var e = new Entity();
			e.Components.Add(t);
			e.Components.Add(new MeshRenderer() { Mesh = SphereGen, Material = mat });
			Children.Add(e);
		}

		float3 rand3DAng(int seed)
		{
			var r = new Random(seed);
			return r.NextFloat3();
		}

		float Lerp(float a, float b, float t) { return a + (b - a) * t; }

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

		protected override void OnDraw()
		{
			/*
			for (int i = 0; i < Children.Count - 1; i++)
			{
				var s = (Children[i] as Entity);
				float3 t = s.Transform.Position;

				s.OnDraw();
			}
			*/

			foreach (Transform c in Cubes)
			{
				var s = (Children[0] as Entity);
				s.Transform.Position = c.Position;
				s.Transform.Scaling = c.Scaling / 5;
				s.OnDraw();
			}

			//float3 endPos = _lEndPos - Transform.Position;

			foreach (float3 c in Leaves)
			{
				var s = (Children[Children.Count - 1] as Entity);

				float3 pos = float3(radAng(float2(c.X, c.Y)), c.Z);

				s.Transform.Position = pos;

				s.OnDraw();
			}
		}
	}
}