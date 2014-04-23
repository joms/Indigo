using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Untitled
{
	public class Postproc: Node
	{
		texture2D[] textures = new []
		{
			import Texture2D("Assets/overlays/001.png"),
			import Texture2D("Assets/overlays/002.png")
		};

		texture2D vignette = import Texture2D("Assets/frame.png");
		texture2D scanlines = import Texture2D("Assets/scanlines.png");

		[Color]
		public float3 ClearColor { get; set; }

		float index;
		[Group("Image overlay")]
		public float Index
		{
			get { return index; }
			set { index = Math.Clamp(value, 0, textures.Length-1); }
		}

		[Range(0,1), Group("Image overlay"),DesignerName("Image alpha")]
		public float Alpha { get; set; }

		[Group("Image overlay"), DesignerName("Image flicker")]
		public float Flicker { get; set; }

		[DesignerName("Enable postproc")]
		public float postProc { get; set; }

		[Range(0,1), DesignerName("Scanline Alpha")]
		public float ScanAlpha { get; set; }

		[Group("RGB Distort"), DesignerName("Distance"), Range(0, 0.2f)]
		public float RGBDist { get; set; }

		[Group("RGB Distort"), DesignerName("Angle"), Range(0, 6.28f)]
		public float RGBAngle { get; set; }

		[Group("Sin Distort"), DesignerName("Amplitude"), Range(0,1)]
		public float SinAmp { get; set; }

		[Group("Sin Distort"), DesignerName("Frequence"), Range(0,10)]
		public float SinFreq { get; set; }

		[Group("Sin Distort"), DesignerName("Noise"), Range(0,50)]
		public float SinNoise { get; set; }

		[Group("Sin Distort"), DesignerName("Roll speed"), Range(-5, 5)]
		public float SinRoll { get; set; }

		[Color, DesignerName("Color"), Group("First overlay")]
		public float4 OverlayColor { get; set; }

		[Color, DesignerName("Flicker"), Group("First overlay")]
		public float OverlayFlicker { get; set; }

		protected override void OnDraw()
		{
			if (postProc == 1)
			{
				int2 fbSize = Context.Viewport.Size;

				var fb = FramebufferPool.Lock(fbSize, Format.RGBA8888, true);

	            Context.PushRenderTarget(fb);
	            Context.Clear(float4(ClearColor,1),1);
				base.OnDraw();
	            Context.PopRenderTarget();

				draw Uno.Scenes.Primitives.Quad {
					float2 tc: float2(TexCoord.X, 1 - TexCoord.Y);

					float bigDist: (Math.Sin(tc.Y * SinFreq * Math.Sin(pixel p.X * SinNoise)) * SinAmp);
					float fineDist: (Math.Sin(pixel tc.Y * Math.Pow(SinFreq, 3)));

					float4 p: sample(import Texture2D("Assets/perlinline.PNG"), tc);

					float4 result: sample(fb.ColorBuffer, Math.Fract(float2(
						tc.X + bigDist * fineDist,
						tc.Y + (SinRoll * (float)Uno.Application.Current.FrameTime))), SamplerState.NearestClamp);

					PixelColor: result;

					float2 o: RGBDist * (float2(Math.Cos(RGBAngle), Math.Sin(RGBAngle)));

					float r: sample(fb.ColorBuffer, tc + o).X;
					float g: sample(fb.ColorBuffer, tc).Y;
					float b: sample(fb.ColorBuffer, tc - o).Z;

					//PixelColor: prev * float4(r, g, b, 1);
				};

				FramebufferPool.Release(fb);
			} else {
				base.OnDraw();
			}

			if (Alpha > 0.01)
			{

				draw Uno.Scenes.Primitives.Quad
				{
					BlendEnabled: true;
					BlendSrc: Uno.Graphics.BlendOperand.SrcAlpha;
					BlendDst: Uno.Graphics.BlendOperand.OneMinusSrcAlpha;
					PixelColor : sample(textures[(int)index], TexCoord) *
						(Alpha - Math.Abs((Math.Sin((float)Uno.Application.Current.FrameTime*35.3f) * Math.Cos((float)Uno.Application.Current.FrameTime*24.3f) * Flicker)));
					DepthTestEnabled: false;
				};
			}

			if (OverlayColor.W > 0)
			{
				float t = (float)Uno.Application.Current.FrameTime;
				draw Uno.Scenes.Primitives.Quad
				{
					BlendEnabled: true;
					BlendSrcRgb: BlendOperand.SrcAlpha;
					BlendDstRgb: BlendOperand.OneMinusSrcAlpha;

					PixelColor : float4(OverlayColor.XYZ, OverlayColor.W - Math.Abs((Math.Sin(t*35.3f) * Math.Cos(t*24.3f) * OverlayFlicker)));
					DepthTestEnabled: false;
				};
			}

			draw Uno.Scenes.Primitives.Quad
			{
				BlendEnabled: true;
				BlendSrcRgb: BlendOperand.Zero;
				BlendDstRgb: BlendOperand.SrcColor;

				float4 sl: sample(scanlines, TexCoord, SamplerState.NearestClamp);

				PixelColor : float4(sl.XYZ, ScanAlpha);
				DepthTestEnabled: false;
			};
			draw Uno.Scenes.Primitives.Quad
			{
				BlendEnabled: true;
				BlendSrcRgb: BlendOperand.Zero;
				BlendDstRgb: BlendOperand.SrcColor;

				PixelColor : sample(vignette, TexCoord);
				DepthTestEnabled: false;
			};
		}
	}
}