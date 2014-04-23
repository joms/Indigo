using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Uno.Designer;

namespace Untitled
{
	public class GreetSizeController: Node
	{
		public float marginX { get; private set; }
		public float marginY { get; private set; }
		
		protected override void OnUpdate()
		{
			base.OnUpdate();
			
			marginX = Math.Floor(Application.Current.Window.Size.X / 2 - 500);
			marginY = Math.Floor(Application.Current.Window.Size.Y / 2 - 500);
		}

	}
}