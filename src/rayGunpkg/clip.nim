type ClipKind* = enum
  bitmap,
  indexed,
  gray,
  rgb,
  lab,
  cie,
  cmyk

type Clip* = object
  w*: int
  h*: int
  kind*: ClipKind
  data*: seq[float64]

proc newClip*(w, h: int; kind: ClipKind = rgb): Clip =
  case kind
  of bitmap, gray, indexed: Clip(w: w, h: h, kind: kind, data: newSeq[float64](w*h))
  of rgb, lab, cie: Clip(w: w, h: h, kind: kind, data: newSeq[float64](w*h*3))
  of cmyk: Clip(w: w, h: h, kind: kind, data: newSeq[float64](w*h*4))
