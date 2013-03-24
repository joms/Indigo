import os,sys
import Image, json

im = Image.open("joms.png")

width = im.size[0]
height = im.size[1]

pix = im.load()
pixels = []

for x in range(0, width):
	pixels.append([])
	for y in range(0, height):
		pixels[x].append(list(pix[x,y]))

txt = open("image.json", "w")
json.dump(pixels, txt)
txt.close()
