using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;
using Experimental.Audio;

namespace Everythingspawner
{
	public class MusicPlayer: Node
	{
		Animation _animation;
		public Animation Animation
		{
			get { return _animation; }
			set
			{
				_animation = value;
				_animation.Started += AnimationStarted;
				_animation.Stopped += AnimationStopped;
			}
		}

		Sound _sound;
		Channel _chan;

		public MusicPlayer()
		{
			Uno.Application.Current.Window.Title = "Indigo";
			Uno.Application.Current.Window.Fullscreen = true;
			Uno.Application.Current.Window.Size = int2(1920, 1080);
			Uno.Application.Current.Window.KeyDown += ExitOnEsc;
			Uno.Application.Current.Window.PointerCursor = Uno.Platform.PointerCursor.None;

			if (defined(Designer))
			{
				//_sound = new Sound("C:\\Users\\joehol\\Dropbox\\Indigo\\TG2014\\Projects\\Invite\\Uno-proj-gauss\\Assets\\InviteBETA.mp3");
				//_sound = new Sound("H:\\Dropbox Kepler\\Dropbox\\TG-demo\\TG2014\\Projects\\Invite\\Uno-proj-gauss\\Asses\\InviteBETA.mp3");
				_sound = new Sound("H:\\Dropbox\\Indigo\\TG2014\\Projects\\Invite\\Uno-proj-gauss\\Assets\\InviteBETA.mp3");
				//_sound = new Sound("C:\\Users\\Joms\\Dropbox\\Indigo\\TG2014\\Projects\\Invite\\Uno-proj-gauss\\Assets\\InviteBETA.mp3");
			} else {
				_sound = new Sound(import BundleFile("Assets/InviteBETA.mp3"));
			}
			_chan = _sound.PlayLoop();
			_chan.Pause();
		}

		void ExitOnEsc(object sender, Uno.Platform.KeyEventArgs e)
		{
			if (e.Key == Uno.Platform.Key.Escape) Uno.Application.Current.Window.Close();
		}

		void AnimationStarted()
		{
			_chan.Positon = _animation.CurrentTime;
			_chan.Play();
		}

		void AnimationStopped()
		{
			if (defined(Designer))
			{
				_chan.Pause();
			} else {
				Uno.Application.Current.Window.Close();
			}
		}
	}
}