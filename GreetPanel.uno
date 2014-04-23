using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Uno.UI;

namespace Untitled
{
	public class GreetPanel: StackPanel
	{
		protected override void OnDraw(float2 origin)
	    {
	        base.OnDraw(origin);
	        InvalidateVisual();
	    }
	}
}