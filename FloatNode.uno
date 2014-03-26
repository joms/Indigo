using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
	public class FloatNode: Node
	{
	    public float Input { get; set; }

	    float _output = 0;

	    public float Output { get{ return _output; } }

	    protected override void OnUpdate()
	    {
	        base.OnUpdate();
	        _output = Input;
	    }
	}
}