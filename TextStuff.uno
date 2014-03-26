using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace EverythingSpawner
{
	public class TextStuff: Node
	{
		texture2D[] textures = new []
		{
			import Texture2D("Assets/Indigo_invites.png"),
			import Texture2D("Assets/come_to.png"),
			import Texture2D("Assets/tg-logo.png"),
			import Texture2D("Assets/compoer.png"),
			import Texture2D("Assets/credits.png")
		};

		public float AnimTime { get; set; }

		public bool Debugging { get; set; }


		float index;
		[Group("Image overlay")]
		public float Index
		{
			get { return index; }
			set { index = Math.Clamp(value, 0, textures.Length-1); }
		}

		[Range(0,1), DesignerName("Overlay Alpha"), Group("First overlay")]
		public float OverlayAlpha { get; set; }
		[Color, DesignerName("overlay Color"), Group("First overlay")]
		public float3 OverlayColor { get; set; }

		[Range(0,1), Group("Image overlay"),DesignerName("Image alpha")]
		public float Alpha { get; set; }

		[Range(0,0.5f), Group("Image overlay"), DesignerName("Image flicker")]
		public float Flicker { get; set; }

		[Color, Group("Image overlay")]
		public float3 OverlayCutoff { get; set; }
		[Range(0,1), Group("Image overlay")]
		public float CutoffAlpha { get; set; }

		[Group("Image overlay")]
		public float Inverted { get; set; }
		[Group("InvertColor"), ColorAttribute]
		public float3 InvertColor { get; set; }

		texture2D vignette_snow = import Texture2D("Assets/vignette_snow.jpg");
		[Range(0,1), Group("Image overlay")]
		public float SnowAlpha { get; set; }

		texture2D noise = import Texture2D("Assets/noise.png");
		[Range(0,1), Group("Image overlay")]
		public float NoiseAlpha { get; set; }

		texture2D vignette = import Texture2D("Assets/vignette.jpg");
		public bool Vignette { get; set; }

		[Range(0,1), DesignerName("Overlay overlay Alpha"), Group("Last overlay")]
		public float OverlayOverlayAlpha { get; set; }
		[Color, DesignerName("Overlay overlay Color"), Group("Last overlay")]
		public float3 OverlayOverlayColor { get; set; }

		[Group("RGB Distort")]
		public float RGBDistort { get; set; }

		[Range(-0.005f, 0.005f), Group("RGB Distort")]
		public float Dist { get; set; }

		[Range(0, 1), Group("RGB Distort")]
		public float Angle { get; set; }


		/**
		 Credits to Dr. Slem for the radial blur!
		**/
		[Group("Radial blur")]
		public float RadialBlur {get;set;}
		[Range(0.97f,1.03f), Group("Radial blur")] public float Zoom {get;set;}
        [Range(0.8f,1f), Group("Radial blur")] public float Blend {get;set;}
        [Range(1,10), Group("Radial blur")] public int Passes {get;set;}
        [Range(0.5f,1f), Group("Radial blur")] public float Resolution {get;set;}
        [Range(0f,3f), Group("Radial blur")] public float Brightness {get;set;}

        public float2 Center = float2(0,0);
        // I like to use sliders in the Designer / Inspector so expose as single floats with range
        [Range(-1,1), Group("Radial blur")] public float CenterX{ get{return Center.X;} set{Center.X = value;}}
        [Range(-1,1), Group("Radial blur")] public float CenterY{ get{return Center.Y;} set{Center.Y = value;}}

		public TextStuff()
		{
			Debugging = true;
			RGBDistort = 0;
			Alpha = 1.0f;

			Inverted = 0;

			RadialBlur = 0;
            Zoom = .9927f;
            Blend = .96f;
            Passes = 4;
            Resolution = .5f;
            Brightness = 1.2f;
            Center.X = .2f;
            Center.Y = -.3f;
		}


		BlendSrcAlpha: BlendOperand.One;
		BlendDstAlpha: BlendOperand.One;

		float ResolutionOld = 0;
		protected override void OnDraw()
		{

			if (RGBDistort == 1)
			{
				int2 fbSize = Context.Viewport.Size / 2;
			}


			if (RadialBlur == 1 && Debugging == false)
			{
				int hiresPasses = 2;        // number of passes before quartering the resolution
	            int2 fbSize = Context.Viewport.Size;
	            fbSize.X = (int) (fbSize.X * Resolution);
	            fbSize.Y = (int) (fbSize.Y * Resolution);

	            var fb0 = FramebufferPool.Lock( fbSize, Format.RGBA8888, true );
	            var fb1 = FramebufferPool.Lock( fbSize, Format.RGBA8888, false );
	            var fb0_h = FramebufferPool.Lock( fbSize/2, Format.RGBA8888, false );
	            var fb1_h = FramebufferPool.Lock( fbSize/2, Format.RGBA8888, false );

	            Context.PushRenderTarget(fb0);
	            Context.Clear(float4(0,0,0,1),1);   // hardcoded clear values for now
	            base.OnDraw();
	            Context.PopRenderTarget();

	            var fbsrc = fb0;
	            var fbdst = fb1;
	            float z = Zoom;
	            float c = Blend;
	            for(int i = 0; i < Passes; i++)
	            {
	                float zz = z*z;
	                float cc = c*c;
	                float norml = (1 - c) / (1 - cc*cc);
	                Context.PushRenderTarget(fbdst);
	                draw Uno.Scenes.Primitives.Quad
	                {
	                    DepthTestEnabled: false;
	                    float2 center: Center;
	                    float2 tc: 2f*TexCoord - 1f;
	                    tc: prev*float2(1,-1) - center;

	                    float2 tc0: (( tc * 1) + 1f + center) * .5f;
	                    float2 tc1: (( tc * z) + 1f + center) * .5f;
	                    float2 tc2: (( tc * (zz)) + 1f + center) * .5f;
	                    float2 tc3: (( tc * (zz*z)) + 1f + center) * .5f;
	                    float4 px0: sample( fbsrc.ColorBuffer, tc0 );
	                    float4 px1: sample( fbsrc.ColorBuffer, tc1 );
	                    float4 px2: sample( fbsrc.ColorBuffer, tc2 );
	                    float4 px3: sample( fbsrc.ColorBuffer, tc3 );
	                    PixelColor: norml*px0 + c*norml*px1 + cc*norml*px2 + c*cc*norml*px3;
	                };
	                Context.PopRenderTarget();
	                z = zz*zz;
	                c = cc*cc;

	                var tmp = fbsrc;
	                fbsrc = fbdst;
	                //reduce FB size after the initial high(est)-res passes
	                if( i > (hiresPasses-1) ) tmp = ((i&1) == 0) ? fb0_h : fb1_h;
	                fbdst = tmp;
	            }

	            // final fullscreen blit + color scaling
	            draw Uno.Scenes.Primitives.Quad
	            {
	                PixelColor: Brightness*sample( fbsrc.ColorBuffer, ((TexCoord - .5f) * float2(1,-1))+.5f);
	            };

	            FramebufferPool.Release(fb0);
	            FramebufferPool.Release(fb1);
	            FramebufferPool.Release(fb0_h);
	            FramebufferPool.Release(fb1_h);
			}
			else
			{
				base.OnDraw();
			}

			if (OverlayAlpha > 0.01f)
			{
				draw Uno.Scenes.Primitives.Quad
				{
					BlendEnabled: true;
					BlendSrcRgb: BlendOperand.SrcAlpha;
					BlendDstRgb: BlendOperand.OneMinusSrcAlpha;
					PixelColor : float4(OverlayColor,OverlayAlpha);
					DepthTestEnabled: false;
				};
			}

			if (Alpha > 0.01)
			{
				var blendOpSrc = BlendOperand.One;
				var blendOpDst = BlendOperand.One;
				if (Inverted == 1)
				{
					blendOpSrc = BlendOperand.SrcAlpha;
					blendOpDst = BlendOperand.OneMinusSrcAlpha;
				}

				draw Uno.Scenes.Primitives.Quad
				{
					BlendEnabled: true;

					//BlendSrc: { if (Inverted == 0) return BlendOperand.SrcAlpha; else return BlendOperand.One; };
					//BlendDst: { if (Inverted == 0) return BlendOperand.OneMinusSrcAlpha; else return BlendOperand.One; };

					//BlendSrc: BlendOperand.One;
					//BlendDst: BlendOperand.One;

					BlendSrc : blendOpSrc;
					BlendDst : blendOpDst;

					float4 cx : sample(textures[(int)index], TexCoord);
					float4 color: {
						if (cx.X > OverlayCutoff.X && cx.Y > OverlayCutoff.Y && cx.Z > OverlayCutoff.Z)
						{
							return cx.XYZW * CutoffAlpha;
						} else {
							return cx;
						}
					};
					PixelColor :  color * (Alpha - Math.Abs((Math.Sin((float)Uno.Application.Current.FrameTime*35.3f) * Math.Cos((float)Uno.Application.Current.FrameTime*24.3f) * Flicker)));
					DepthTestEnabled: false;
				};
			}

			if (NoiseAlpha > 0.01f)
			{
				draw Uno.Scenes.Primitives.Quad
				{
					/*BlendEnabled: true;
					BlendSrcRgb: BlendOperand.Zero;
					BlendDstRgb: BlendOperand.SrcColor;*/
					BlendEnabled: true;
					BlendSrcRgb: BlendOperand.SrcAlpha;
					BlendDstRgb: BlendOperand.OneMinusSrcAlpha;

					PixelColor : float4(sample(noise, TexCoord + AnimTime * float2(9, 7)).XYZ, NoiseAlpha);
					DepthTestEnabled: false;
				};
			}

			if (SnowAlpha > 0.0001f)
			{
				draw Uno.Scenes.Primitives.Quad
				{
					BlendEnabled: true;
					BlendSrcRgb: BlendOperand.SrcAlpha;
					BlendDstRgb: BlendOperand.OneMinusSrcAlpha;

					float4 c : sample(vignette_snow, TexCoord).XYZX;
					/*float4 color: {
						if (c.X > SnowCutaway && c.Y > SnowCutaway && c.Z > SnowCutaway)
						{
							return float4(c.XYZ + OverlayColor, c.W + SnowAlpha);
						} else {
							return float4(0);
						}
					};*/

					PixelColor : float4(c.XYZ + OverlayColor, c.W * (SnowAlpha * 10));
					DepthTestEnabled: false;
				};
			}

			if (OverlayOverlayAlpha > 0.01f)
			{
				draw Uno.Scenes.Primitives.Quad
				{
					BlendEnabled: true;
					BlendSrcRgb: BlendOperand.SrcAlpha;
					BlendDstRgb: BlendOperand.OneMinusSrcAlpha;
					PixelColor : float4(OverlayOverlayColor,OverlayOverlayAlpha);
					DepthTestEnabled: false;
				};
			}

			if (Vignette)
			{
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
}