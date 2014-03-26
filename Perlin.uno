using Uno;
using Uno.Collections;
using Uno.Graphics;
using Uno.Scenes;
using Uno.Content;
using Uno.Content.Models;

//I STOLE IT FROM HERE: http://www.minecraftforum.net/topic/1073063-generating-perlin-noise/page__st__60
//Is actually java, don't tell duckers.
namespace Everythingspawner
{
	public class Perlin 
	{
	        private long seed;
	        private Random rand;
	        private int octave;
	        //BUGFREE
	        public Perlin(long seed, int octave) {
	                this.seed = seed;
	                this.octave = octave;
	                rand = new Random((int)seed);
	        }
	        public double getNoiseLevelAtPosition(int x, int z) {
	                int xmin = (int) (double) x / octave;
	                int xmax = xmin + 1;
	                int zmin = (int) (double) z / octave;
	                int zmax = zmin + 1;
	                float2 a = float2(xmin, zmin);
	                float2 b = float2(xmax, zmin);
	                float2 c = float2(xmax, zmax);
	                float2 d = float2(xmin, zmax);
	                double ra = getRandomAtPosition(a);
	                double rb = getRandomAtPosition(b);
	                double rc = getRandomAtPosition(c);
	                double rd = getRandomAtPosition(d);
	                double ret = cosineInterpolate( //Interpolate Z direction
	                                cosineInterpolate((float) ra, (float) rb, (float) (x - xmin * octave) / octave), //Interpolate X1
	                                cosineInterpolate((float) rd, (float) rc, (float) (x - xmin * octave) / octave), //Interpolate X2
	                                ((float)z - (float)zmin * (float)octave) / (float)octave);
	                return ret;
	        }
	        private float cosineInterpolate(float a, float b, float x) {
	                float ft = x * Math.PIf;
	                float f = (float) ((1f - Math.Cos(ft)) * .5f);
	                float ret = a * (1f - f) + b * f;
	                return ret;
	        }
	        private double getRandomAtPosition(float2 coord) {
	                double variable = 10000 * (Math.Sin(coord.X) + Math.Cos(coord.Y) + Math.Tan(seed) + Math.Sqrt(seed+coord.Y/(coord.X+1)));
	                rand.SetSeed((int) variable);
	                double ret = (double)rand.NextFloat();
	                return ret;
	        }
	}
}