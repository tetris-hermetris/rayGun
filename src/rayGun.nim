import rayGunpkg / [clip, image, draw]
import times
when isMainModule:
  
  let start = now()

  let 
    W = 300
    H = 300
# proc setPixel(clip: var Clip, x, y: int, value: seq[float32], kind: ClipKind = rgb) =
  var 
    img = newClip(W, H)
  img.setPixel(1, 1, @[1.0, 1.0, 1.0])
  img.line((1,1), (10, 20), @[1.0, 1.0, 1.0])
  img.circle((20, 10), 15,  @[1.0, 1.0, 1.0])

  echo saveImage(img, "output/output1.jpg")
  let done = now()
  echo done - start
