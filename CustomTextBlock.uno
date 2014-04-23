using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Uno.UI;
using Uno.Designer;

namespace Untitled
{
	public class CustomTextBlock: TextBlock
	{
		public string Value {
			get { return Text; }
			set { Text = value; }
		}

		[Color]
		public float4 FuckbarColorFaen {
			get { return ForegroundColor; }
			set {ForegroundColor = value; }
		}
	}
}