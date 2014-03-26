using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
	public class FlickerNode: Node
	{
	    [Range(0,0.5f)]
	    public float Flicker { get; set; }
		[Range(0,1)]
		public float Intensity { get; set; }
		[Range(0,1)]
		public float Opacity { get; set; }

		[Color]
		public float3 Color { get; set; }

	    float3 _flickr = float3(0);

	    public float3 Result { get{ return _flickr; } }
		
		public float ResultX { get{ return _flickr.X * 10; } }

	    public FlickerNode()
	    {
	        Flicker = 0.5f;
	    }

	    protected override void OnUpdate()
	    {
	        base.OnUpdate();
			if (Opacity > 0)
			{
				_flickr = Color * Opacity;
			} else {
				_flickr = Color * float3(Math.Abs((Math.Sin(((float)Uno.Application.Current.FrameTime*Intensity)*35.3f) * Math.Cos(((float)Uno.Application.Current.FrameTime*Intensity)*24.3f) * Flicker)));
			}
	    }
	}
}