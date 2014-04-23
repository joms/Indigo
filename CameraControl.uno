using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Untitled
{
	public class CameraControl: Node
	{
		public List<Entity> Cameras { get { return _cameras; }}
		
		public float GameTime { get; set; }

		[Group("Camera spinner"), DesignerName("Enable")]
		public float EnableSpinner { get; set; }

		[Group("Camera spinner"), Range(25, 500)]
		public float Radius { get; set; }

		[Group("Camera spinner"), Range(0, 10)]
		public float Speed { get; set; }

		[Group("Camera spinner"), Range(-500, 500)]
		public float Height { get; set; }

		[Group("Camera spinner")]
		public Entity Target { get; set; }

		[Group("Shake"), DesignerName("Amount"), Range(0,10)]
		public float ShakeAmount { get; set; }

		[Group("Shake"), DesignerName("Speed"), Range(0,1)]
		public float ShakeSpeed { get; set; }

		List<Entity> _cameras = new List<Entity>();

	    public float CameraIndex { get; set; }

	    public Entity Camera
	    {
	        get
	        {
	            var index = Math.Clamp((int)CameraIndex, 0, _cameras.Count - 1);
	            if (index > -1 && index < _cameras.Count)
	                return _cameras[index];

	            return null;
	        }
	    }

		Transform t;

		public CameraControl()
		{
			t = new Transform();
		}

	    protected override void OnUpdate()
	    {
			base.OnUpdate();

			if (_cameras.Count > 0)
			{
				var cam = Camera;

				if (EnableSpinner == 1)
				{
					if (Target != null)
					{
						t.Position = Target.Transform.Position;
					} else {
						t.Position = float3(0);
					}

					cam.Transform.Position = float3((float)Math.Sin(GameTime * Speed) * Radius, (float)Math.Cos(GameTime * Speed) * Radius, Height);
					cam.Transform.LookAt(t, float3(0, 0, 1));
				}

				if (ShakeSpeed > 0.001f)
				{
					double shake_phase = Uno.Application.Current.FrameTime * 32 * ShakeSpeed;
					float3 camOffs = new float3((float)Math.Sin(shake_phase), (float)Math.Cos(shake_phase * 0.9f), (float)Math.Sin(shake_phase - 0.5f));

					cam.Transform.Position += camOffs * ShakeAmount;
				}
			}
		}
	}
}