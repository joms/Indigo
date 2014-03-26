using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;

namespace Everythingspawner
{
	public class CameraSwitcher
	{

		public Entity Camera { get; set; }
		public List<Entity> Cameras { get { return _cameras; }}

		List<Entity> _cameras = new List<Entity>();

		float _cameraIndex;
		public float CameraIndex { get { return _cameraIndex;}
		set
			{
				_cameraIndex = value;
				Camera = _cameras[Math.Clamp((int)value, 0, _cameras.Count - 1)];
			}
		}
	}
}