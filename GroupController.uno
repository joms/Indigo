using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Designer;
using Uno.Content;
using Uno.Content.Models;

namespace Untitled
{
	public class GroupController: Node
	{
		Group[] groups = new [] {
			new Group("Ephidrena", "Ep", 112, 13.37f),
			new Group("BitFlavour", "Bf", 314, 6.183f),
			new Group("Excess", "Ec", 33, 65.537f),
			new Group("Outracks", "Ou", 42, 28),
			new Group("Gammel Opland", "Hæ", 88, 6.91f, "af 1891"),
			new Group("Kvasigen", "Kg", 92, 1.63f),
			new Group("Darklite", "Dl", 13, 3.8f),
			new Group("Spaceballs", "Sb", 69, 313.37f),
			new Group("PlayPsyCo", "Pp", 113, 20.48f),
			new Group("Boozoholics", "Bh", 49, 40.96f),
			new Group("Youth Uprising", "Yu", 18, 65.536f),
			new Group("TRBL", "Tl", 67, 327.67f),
			new Group("HomoTronics", "Ho", 117, 69.6969f),
			new Group("ZOMGTronics", "Mo", 118, 69.6969f),
			new Group("SceneSat", "Ss", 89, 114.818f),
			new Group("Hullkort Masters", "Hm", 90, 128.011f),
			new Group("License", "Lc", 44, 1.88f),
			new Group("Bored Coders", "Ba", 36, 32.767f, "Association"),
			new Group("PiXiD", "Px", 2, 255.999f),
			new Group("Odd", "Od", -4, 1.01f),
			new Group("The Gathering", "<3", 2014, 13.37f)
		};

		float _index;
		public float Index {
			get {
				return _index;
			}
			set
			{
				_index = value;
				var index = Math.Clamp((int)value, 0, groups.Length - 1);
				if (index != -1)
				{
					Refresh(index);
				} else {
					return;
				}
			}
		}

		public string Name { get; private set; }
		public string Short { get; private set; }
		public string Number { get; private set; }
		public string Density { get; private set; }
		//public string Extra { get; private set; }

		[Color]
		public float4 Color { get; set; }

		void Refresh(int index)
		{
			var g = groups[index];

			Name = g.Name;
			Short = g.ShortName;
			Number = g.Number.ToString();
			Density = g.Density.ToString();
			if (g.Extra != "")
			{
				Density = g.Extra;
			}
		}

		public GroupController()
		{
			_index = 0;
			Refresh((int)_index);
		}
	}
}