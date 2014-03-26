using Uno.Graphics;
using Uno.Designer;

namespace Uno.Scenes.Filters
{
	public class Fader : Node
	{
		float _opacity = 0;

		[Range(0, 1)]
		public float Opacity { get; set; }

		[Color]
		public float4 Color { get; set; }

		public bool Negative { get; set; }

		public Fader()
		{
			Color = float4(1,1,1, 0);
			Negative = false;
		}

		protected override void OnDraw()
		{
			int width = (int)Application.Current.GraphicsContext.RenderTarget.Size.X / 2;
			int height = (int)Application.Current.GraphicsContext.RenderTarget.Size.Y / 2;

			var fb1 = FramebufferPool.Lock(width, height, Format.RGBA8888, true);

			float _op;
			if (Negative == false)
			{
				_op = Opacity;
			} else {
				float x = Opacity;
				_op = 0f - x;
			}

			fb1.Dispose();

			Context.PushRenderTarget(fb1);
			base.OnDraw();
			Context.PopRenderTarget();

			draw Primitives.Quad
			{
				DepthTestEnabled: false;
				CullFace: PolygonFace.None;
				float2 tc: VertexPosition.XY;
				PixelColor: sample(fb1.ColorBuffer, tc * 0.5f + 0.5f) + (Color * _op);
			};

			FramebufferPool.Release(fb1);
		}
	}
}