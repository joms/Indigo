using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

using Uno.UI;

namespace Untitled
{
	public class GreetBrush: Brush
	{
		[Color]
		public float3 StartColor { get; set; }

		[Color]
		public float3 EndColor { get; set; }

		[Range(0,1)]
		public float Alpha { get; set; }

		float2 TexCoord: prev, float2(0);

		float3 f: Math.Lerp(StartColor, EndColor, TexCoord.Y);

		PixelColor: float4(f, Alpha);
	}
}