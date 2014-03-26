using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
public class NodeSwitcher : Node
{
    [Uno.Designer.Range(0, 10)]
    public float CurrentScene {get; set;}

    //public bool ShowAll {get; set;}

    public NodeSwitcher()
    {
        CurrentScene = 0;
        //ShowAll = false;
    }
/*
    public override bool HandleEvent(Uno.Scenes.Context c)
    {
        if(c.EventType == EventType.KeyUp)
        {
            switch (c.Key)
            {
                case Uno.Platform.Key.D1 :
                    CurrentScene = 0;
                    break;
                case Uno.Platform.Key.D2 :
                    CurrentScene = 1;
                    break;
                case Uno.Platform.Key.D3 :
                    CurrentScene = 2;
                    break;
                case Uno.Platform.Key.D4 :
                    CurrentScene = 3;
                    break;
                case Uno.Platform.Key.D5 :
                    CurrentScene = 4;
                    break;
                case Uno.Platform.Key.D6 :
                    CurrentScene = 5;
                    break;
                case Uno.Platform.Key.D7 :
                    CurrentScene = 6;
                    break;
                case Uno.Platform.Key.D8 :
                    CurrentScene = 7;
                    break;
                case Uno.Platform.Key.D9 :
                    CurrentScene = 8;
                    break;
                case Uno.Platform.Key.D0 :
                    CurrentScene = 9;
                    break;
            }
        }

        return base.HandleEvent(c);
    }
*/

    protected override void OnDraw()
    {
        //if(!ShowAll)
        //{
            if (!this.Children.IsEmpty)
                if((int)CurrentScene < Children.Count)
                    Children[(int)CurrentScene].Draw();
        /*}else{
            base.Draw(c);
        }
		*/
    }

}
}