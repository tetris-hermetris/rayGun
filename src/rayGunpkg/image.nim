import clip, sequtils, nimPNG

proc saveImage*(clip: Clip; filename: string): PNGStatus =
  savePNG24(filename, map(clip.data, proc(x: float64): uint8 = (x * 255).uint8), clip.w, clip.h)