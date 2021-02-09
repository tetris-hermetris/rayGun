import nimPNG

type
  Image* = object
    width*: int
    height*: int
    data*: string

proc newImage*(width, height: int): Image =
  Image(width: width, height: height, data: newString(width * height * 3))

proc setPixel*(img: var Image; x, y: int; color: (float, float, float)) =
  
  # var fwidth = img.width.toFloat
  # var fheight = img.height.toFloat

  if 0 <= x and x <= img.width-1 and 0 <= y and y <= img.height-1:
    let p = (x + y * img.width) * 3
    img.data[p + 0] = cast[char]((color[0] * 255).uint8)
    img.data[p + 1] = cast[char]((color[1] * 255).uint8)
    img.data[p + 2] = cast[char]((color[2] * 255).uint8)

proc save*(img: Image; filename: string): bool =
  savePNG24(filename, img.data, img.width, img.height)