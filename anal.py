import os,sys
import Image, json

im = Image.open("joms.png")

width = im.size[0]
height = im.size[1]

pix = im.load()
pixels = []
for x in xrange(width, 0, -1):
	pixels.append([])
	for y in xrange(height, 0, -1):
		pixels[x].append(list(pix[x,y]))

txt = open("image.json", "w")
json.dump(pixels, txt)
txt.close()
