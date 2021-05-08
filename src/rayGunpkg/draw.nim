import clip

# Comparison of line (Bresenham) and line_dda on 396900 lines:
# line: 33 seconds, 939 milliseconds, and 739 microseconds
# line_dda: 54 seconds, 685 milliseconds, and 368 microseconds

proc setPixel*(clip: var Clip, x, y: int, value: seq[float64], kind: ClipKind = rgb) =
  if 0 < x and x <= clip.w-1 and 0 < y and y <= clip.h-1:
    let
      x0 = x - 1
      y0 = y - 1
    case kind
    of bitmap, gray, indexed: 
      assert value.len == 1
      clip.data[x + y * clip.w] = value[0]
    of rgb, lab, cie:
      assert value.len == 3
      for i, v in value:
        clip.data[(x0 + y0 * clip.w) * 3 + i] = v
    of cmyk:
      assert value.len == 4
      for i, v in value:
        clip.data[x + y * clip.w + i] = v

proc line_dda*(clip: var Clip, p1: (int, int), p2: (int, int), value: seq[float64], kind: ClipKind = rgb) = 
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
      clip.setPixel(x.toInt, y.toInt, value, kind)
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
      clip.setPixel(x.toInt, y.toInt, value, kind)
      y -= 1
      x -= slope
 
proc line*(clip: var Clip; p1: (int, int), p2: (int, int), value: seq[float64], kind: ClipKind = rgb) =
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
    clip.setPixel(p1[0], p1[1], value, kind)
    if p1 == p2:
      break
    e2 = err
    if e2 > -dx:
      err -= dy
      p1[0] += sx
    if e2 < dy:
      err += dx
      p1[1] += sy

proc setPixel4(clip: var Clip, cx: int, cy: int, r: int, value: seq[float64], kind: ClipKind = rgb) = 
  clip.setPixel(cx, cy + r, value, kind)
  clip.setPixel(cx, cy - r, value, kind)
  clip.setPixel(cx + r, cy, value, kind)
  clip.setPixel(cx - r, cy, value, kind)

proc setPixel8(clip: var Clip, cx: int, cy: int, x: int, y: int, value: seq[float64], kind: ClipKind = rgb) = 
  clip.setPixel(cx + x, cy + y, value, kind)
  clip.setPixel(cx - x, cy + y, value, kind)
  clip.setPixel(cx + x, cy - y, value, kind)
  clip.setPixel(cx - x, cy - y, value, kind)
  clip.setPixel(cx + y, cy + x, value, kind)
  clip.setPixel(cx - y, cy + x, value, kind)
  clip.setPixel(cx + y, cy - x, value, kind)
  clip.setPixel(cx - y, cy - x, value, kind)

proc circle*(clip: var Clip, c: (int, int), r: int, value: seq[float64], kind: ClipKind = rgb) =
  var
    r = abs(r)
    x = 0
    y = r
    f = 1 - r
    ddFX = 0
    ddFY = -2 * r
    
  clip.setPixel4(c[0], c[1], r, value, kind)
    
  while x < y:
    if f >= 0:
      dec y
      inc ddFY, 2
      inc f, ddFY
    inc x
    inc ddFX, 2
    inc f, ddFX + 1
 
    clip.setPixel8(c[0], c[1], x, y, value, kind)

proc drawCubicBezier*(clip: var Clip; p1, p2, p3, p4: (int, int); value: seq[float64], kind: ClipKind = rgb, nseg: Positive = 1000) =
 
  var points = newSeq[(int, int)](nseg + 1)
 
  for i in 0..nseg:
    let t = i / nseg
    let u = (1 - t) * (1 - t)
    let a = (1 - t) * u
    let b = 3 * t * u
    let c = 3 * (t * t) * (1 - t)
    let d = t * t * t
 
    points[i] = (x: (a * p1[0].toFloat + b * p2[0].toFloat + c * p3[0].toFloat + d * p4[0].toFloat).toInt,
                 y: (a * p1[1].toFloat + b * p2[1].toFloat + c * p3[1].toFloat + d * p4[1].toFloat).toInt)
 
  for i in 1..points.high:
    clip.line(points[i - 1], points[i], value, kind)