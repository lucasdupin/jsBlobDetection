Blob Detection for Canvas
=========================

### To get the blobs from a Canvas

```javascript
blobs = Detector.getBlobsInCanvas(canvas)
```

### Or, if you want more control, you can use an ImageData

```javascript
blobs = Detector.getBlobs(imageData, threshold)
```

### And draw the blobs like this
```javascript
for (var i = 0; i < blobs.length; i++) {
	ctx.fillRect(blobs[i].minX, blobs[i].minY, blobs[i].width, blobs[i].height)
};
```

## Working sample:
http://lucasdupin.github.io/jsBlobDetection