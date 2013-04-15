# The MIT License (MIT)
# Copyright (c) 2013 Lucas Dupin Moreira Costa

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
# associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Detector = {}
Detector.getBlobsInCanvas = (canvas)->
	ctx = canvas.getContext '2d'
	imgData = ctx.getImageData 0, 0, canvas.width, canvas.height
	Detector.getBlobs imgData, 200

Detector.getBlobs = (pixels, threshold)->

	# Apply Threshold
	d = pixels.data
	for i in [0..d.length] by 4
		r = d[i];
		g = d[i+1];
		b = d[i+2];
		v = if 0.2126*r + 0.7152*g + 0.0722*b >= threshold then 255 else 0
		d[i] = d[i+1] = d[i+2] = v

	# Recursive function
	searchNearby = (blob, x, y)->

		pixelPos = (y*4*pixels.width)+(x*4)

		# Mark as done
		d[pixelPos] = 0
		# Check if I'm in the boundaries edge!
		blob.minX = x if(blob.minX > x)
		blob.maxX = x if(blob.maxX < x)
		blob.minY = y if(blob.minY > y)
		blob.maxY = y if(blob.maxY < y)

		# Search Left
		if(d[pixelPos-4] == 255)
			searchNearby(blob, x-1, y)
		# Search Top
		if(d[pixelPos - 4*pixels.width] == 255)
			searchNearby(blob, x, y-1)
		# Search Bottom
		if(d[pixelPos + 4*pixels.width] == 255)
			searchNearby(blob, x, y+1)
		# Go further
		if(d[pixelPos + 4] == 255)
			searchNearby(blob, x+1, y)


	allBlobs = []

	d = pixels.data;
	# Each column
	for x in [0..pixels.width]
		# Each line
		for y in [0..pixels.height]
			# Search for the blob
			if d[(x*4)+(y*4*pixels.width)] == 255
				# 
				# Found something!
				# 
				# Now we should go through it's neighbours to find the blob's size
				blob = minX: pixels.width, minY: pixels.height, maxX: 0, maxY: 0
				allBlobs.push(blob)
				searchNearby(blob, x, y)
	
	# Calculate center
	for blob in allBlobs
		blob.centerX = blob.minX + (blob.maxX - blob.minX) / 2
		blob.centerY = blob.minY + (blob.maxY - blob.minY) / 2
		blob.width = blob.maxX - blob.minX + 1
		blob.height = blob.maxY - blob.minY + 1
	
	
	allBlobs

# Export
window.Detector = Detector