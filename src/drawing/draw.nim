import image

# Comparison of line (Bresenham) and line_dda on 396900 lines:
# line: 33 seconds, 939 milliseconds, and 739 microseconds
# line_dda: 54 seconds, 685 milliseconds, and 368 microseconds

proc line_dda*(img: var Image, p1: (int, int), p2: (int, int), color: (float, float, float)) = 
  var
    x1: float
    y1: float
    x2: float
    y2: float
  if p2[0] >= p1[0]:
    x1 = p1[0].toFloat
    y1 = p1[1].toFloat
    x2 = p2[0].toFloat
    y2 = p2[1].toFloat
  elif p2[0] <= p1[0]:
    x1 = p2[0].toFloat
    y1 = p2[1].toFloat
    x2 = p1[0].toFloat
    y2 = p1[1].toFloat
  var slope = (y2 - y1) / (x2 - x1)
  if abs(slope) <= 1:
    var
      x = x1
      y = y1
    while x <= x2:
      img.setPixel(x.toInt, y.toInt, color)
      y += slope
      x += 1  
  else:
    if p2[0] >= p1[0]:
      x1 = p2[0].toFloat
      y1 = p2[1].toFloat
      x2 = p1[0].toFloat
      y2 = p1[1].toFloat
    var
      x = x1
      y = y1

    slope = (x2 - x1) / (y2 - y1)
    while y >= y2:
      img.setPixel(x.toInt, y.toInt, color)
      y -= 1
      x -= slope
 
proc line*(img: var Image; p1: (int, int), p2: (int, int); color: (float, float, float)) =
  let
    dx = abs(p2[0] - p1[0])
    sx = if p1[0] < p2[0]: 1 else: -1
    dy = abs(p2[1] - p1[1])
    sy = if p1[1] < p2[1]: 1 else: -1
 
  var
    p1 = p1
    p2 = p2
    err = (if dx > dy: dx else: -dy) div 2
    e2 = 0
 
  while true:
    img.setPixel(p1[0], p1[1], color)
    if p1 == p2:
      break
    e2 = err
    if e2 > -dx:
      err -= dy
      p1[0] += sx
    if e2 < dy:
      err += dx
      p1[1] += sy

proc setPixel4(img: var Image, cx: int, cy: int, r: int, color: (float, float, float)) = 
  img.setPixel(cx, cy + r, color)
  img.setPixel(cx, cy - r, color)
  img.setPixel(cx + r, cy, color)
  img.setPixel(cx - r, cy, color)

proc setPixel8(img: var Image, cx: int, cy: int, x: int, y: int, color: (float, float, float)) = 
  img.setPixel(cx + x, cy + y, color)
  img.setPixel(cx - x, cy + y, color)
  img.setPixel(cx + x, cy - y, color)
  img.setPixel(cx - x, cy - y, color)
  img.setPixel(cx + y, cy + x, color)
  img.setPixel(cx - y, cy + x, color)
  img.setPixel(cx + y, cy - x, color)
  img.setPixel(cx - y, cy - x, color)

proc circle*(img: var Image, c: (int, int), r: int, color: (float, float, float)) =
  var
    r = abs(r)
    x = 0
    y = r
    f = 1 - r
    ddFX = 0
    ddFY = -2 * r
    
  img.setPixel4(c[0], c[1], r, color)
    
  while x < y:
    if f >= 0:
      dec y
      inc ddFY, 2
      inc f, ddFY
    inc x
    inc ddFX, 2
    inc f, ddFX + 1
 
    img.setPixel8(c[0], c[1], x, y, color)