using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;

namespace Untitled
{
	public class Group
	{
		public Group(string name, string shortname, int number, float dens, string extra = "")
		{
			Name = name;
			ShortName = shortname;
			Number = number;
			Density = dens;
			Extra = extra;
		}

		public String Name { get; set; }
		public string ShortName { get; set; }
		public int Number { get; set; }
		public float Density { get; set; }
		public string Extra { get; set; }
	}
}