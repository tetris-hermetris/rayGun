import drawing / [image, draw]
import math, times, strformat
when isMainModule:
  
  let start = now()
  # let LUT = [ (0.0, 0.0, 0.0),
  #             (0.0, 0.0, 1.0),
  #             (0.0, 1.0, 0.0),
  #             (0.0, 1.0, 1.0),
  #             (1.0, 0.0, 0.0),
  #             (1.0, 0.0, 1.0),
  #             (1.0, 1.0, 0.0),
  #             (1.0, 1.0, 1.0)]

  # let LUT = [ (0.0, 0.0, 0.0),
  #             (0.0, 0.0, 0.5),
  #             (0.0, 0.0, 1.0),
  #             (0.0, 0.5, 0.0),
  #             (0.0, 1.0, 0.0),
  #             (0.0, 0.5, 0.5),
  #             (0.0, 1.0, 1.0),
  #             (0.5, 0.0, 0.0),
  #             (1.0, 0.0, 0.0),
  #             (0.5, 0.0, 0.5),
  #             (1.0, 0.0, 1.0),
  #             (0.5, 0.5, 0.0),
  #             (1.0, 1.0, 0.0),
  #             (0.5, 0.5, 0.5),
  #             (1.0, 1.0, 1.0)]

  let W, H = 1333

  var img = newImage(W, H)
  
  # let pitch = (W / (10*5)).toInt
  var cnt, u = 0
  # while u < 85:    
  #   var x0 = 0
  #   while x0 + pitch < W:
  #     var y0 = 0
  #     while y0 + pitch < H:
  #       for x in countup(x0, x0+pitch, 10+u):
  #         for y in countup(y0, y0+pitch, 10+u):
  #           img.line((x+u, y), (x+(x-y+u)*(2*5), y+15*5), LUT[((x+y+u).toFloat/(W/111)).toInt mod LUT.len])
  #           # img.circle((x, y), (tan((x+y).toFloat) * 10).toInt, LUT[((x+y)/50).toInt mod LUT.len])
  #           cnt += 1
  #       y0 += pitch + 1
  #     x0 += pitch + 1
  #   u += 5
  
  # img.circle((100, 100) , 90, LUT[6])

  for x in 0..W-1:
    for y in 0..H-1:
      img.setPixel(x, y, LUT[((sin(x.toFloat * 0.1)+2)*(cos(y.toFloat * 0.03)+2)).toInt mod LUT.len])
  
  # for v in 0..W:
  #   img.setPixel(v, v, LUT[LUT.high])
  let done = now()
  echo done - start
  echo cnt
  echo save(img, "output/output.png")
  # echo save(img, fmt"output/collector/output-{now().getDateStr}-{now().hour}-{now().minute}-{now().second}.png")
# 396900
# 33 seconds, 939 milliseconds, and 739 microseconds
# 54 seconds, 685 milliseconds, and 368 microseconds