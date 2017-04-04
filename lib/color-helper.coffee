module.exports =
  golden_ratio_conjugate: 0.618033988749895

  hsvToRgb: (h,s,v) -> # HSV to RGB algorithm, as per wikipedia
    c = v * s
    h2 = (360.0*h) /60.0 # According to wikipedia, 0<h<360...
    h3 = Math.abs((h2%2) - 1.0)
    x = c * (1.0 - h3)
    m = v - c
    if 0<=h2<1 then return [c+m,x+m,m]
    if 1<=h2<2 then return [x+m,c+m,m]
    if 2<=h2<3 then return [m,c+m,x+m]
    if 3<=h2<4 then return [m,x+m,c+m]
    if 4<=h2<5 then return [x+m,m,c+m]
    if 5<=h2<6 then return [c+m,m,x+m]

  getFixedColor: (saturation=1) ->
    c = @getConfig "fixed"
    "rgb(#{c.red*saturation},#{c.green*saturation},#{c.blue*saturation})"

  getRandomGenerator: (saturation=1) ->
    seed = Math.random()
    loop
      seed += @golden_ratio_conjugate
      seed = seed - (seed//1)
      rgb = @hsvToRgb(seed,1,1)
      r = ((rgb[0]*255)*saturation)//1
      g = ((rgb[1]*255)*saturation)//1
      b = ((rgb[2]*255)*saturation)//1
      yield "rgb(#{r},#{g},#{b})"
    return

  getColorAtPosition: (editor, editorElement, screenPosition, saturation=1) ->
    screenPosition = [screenPosition.row, screenPosition.column - 1]
    bufferPosition = editor.bufferPositionForScreenPosition screenPosition
    scope = editor.scopeDescriptorForBufferPosition bufferPosition
    scope = scope.toString().replace(/\./g, '.syntax--')

    try
      el = editorElement.querySelector scope
    catch error
      "rgb(#{255*saturation}, #{255*saturation}, #{255*saturation})"

    if el
      getComputedStyle(el).color
    else
      "rgb(#{255*saturation}, #{255*saturation}, #{255*saturation})"

  getColor: (editor, editorElement, screenPosition, saturation=1) ->
    colorType = @getConfig("type")
    if (colorType == "random")
      @getRandomGenerator(saturation)
    else if colorType == "fixed"
      @getFixedColor(saturation)
    else if colorType == "cursor"
      @getColorAtPosition editor, editorElement, screenPosition, saturation
    else #should never be hit
      @getRandomGenerator(saturation)

  interpolateColor: (start, stop, percent) ->
    return start + Math.trunc((stop - start)*percent)

  getComboCountColor: (p) ->
    # This should transition the combo counter color in the following order, and interpolate between:
    # blue -> teal -> green -> yellow -> orange -> red
    p *= 0.5 # <-- want to extend the amount of time it sits in each color range
    switch
      when (p < 0.2) #blue -> teal
        p /= .2
        return "rgb(15, #{@interpolateColor(125, 255, p)}, 255)"
      when (p < .4) #teal -> green
        p = (p-.2)/.2
        return "rgb(0, 255, #{@interpolateColor(255, 0, p)})"
      when (p < .6) #green -> yellow
        p = (p-.4)/.2
        return "rgb(#{@interpolateColor(0, 255, p)}, 255, 0)"
      when (p < .8) #yellow -> orange
        p = (p-.6)/.2
        return "rgb(255, #{@interpolateColor(255, 125, p)}, 0)"
      when (p < 1.2) #orange -> red
        p = (p-.8)/.2
        return "rgb(255, #{@interpolateColor(125, 15, p)}, 15)"
      else
        return "white"

  getConfig: (config) ->
    atom.config.get "bedlam.particles.colours.#{config}"
