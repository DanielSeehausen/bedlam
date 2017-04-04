# This canvas is currently designed around the explosion sprite only.
# if additional sprites are to be added then a few changes should be made to
# modularize the sprites and their information so that they can be passed
# to rendering functions with their own respective dimensions, ticCount, etc.

{CompositeDisposable} = require "atom"
comboMode = require "./combo-mode"

module.exports =
  subscriptions: null

  init: ->
    @resetExplosions()
    @explosionSpriteSheet = new Image()
    #TODO fix this path
    @explosionSpriteSheet.src = "../../../../../../Desktop/power-mode-ds-edit/sprites/explosion-sprite.png"
    @spriteWidth = @spriteHeight = 130.5
    @spriteLocs = [[0, 0],     [130.5, 0],     [261, 0],     [391.5, 0],
                   [0, 130.5], [130.5, 130.5], [261, 130.5], [391.5, 130.5],
                   [0, 261],   [130.5, 261],   [261, 261],   [391.5, 261],
                   [0, 391.5], [130.5, 391.5], [261, 391.5], [391.5, 391.5]]
    @minOffset = -8
    @maxOffset = 8
    @explosionTicCount = 4 #used to control the speed of the animation
    @explosions = []

  resetCanvas: ->
    @animationOff()
    @editor = null
    @editorElement = null

  animationOff: ->
    cancelAnimationFrame(@animationFrame)
    @animationFrame = null

  resetExplosions: ->
    @explosions = []

  destroy: ->
    @resetCanvas()
    @resetExplosions()
    @canvas?.parentNode.removeChild @canvas
    @canvas = null
    @subscriptions?.dispose()

  setupCanvas: (editor, editorElement) ->
    if not @canvas
      @canvas = document.createElement "canvas"
      @context = @canvas.getContext "2d"
      @canvas.classList.add "power-mode-canvas"
      @canvas.setAttribute("id", "explosion-canvas")
    editorElement.appendChild @canvas
    @canvas.style.display = "block"
    @canvas.width = editorElement.offsetWidth
    @canvas.height = editorElement.offsetHeight
    @scrollView = editorElement.querySelector(".scroll-view")
    @editorElement = editorElement
    @editor = editor
    @init()

  calculatePositions: (screenPosition) ->
    {left, top} = @editorElement.pixelPositionForScreenPosition screenPosition
    left: left + @scrollView.offsetLeft - @editorElement.getScrollLeft()
    top: top + @scrollView.offsetTop - @editorElement.getScrollTop() + @editor.getLineHeightInPixels() / 2

  spawnExplosion: (loc, size = 'normal') ->
    x = loc[0] - (@spriteWidth/2)//1
    y = loc[1] - (@spriteHeight/2)//1
    switch size
      when 'normal'
        @explosions.push {x: x, y: y, sizeMod: 1, frame:  0, tics: 0}
      when 'double'
        @explosions.push {x: x, y: y, sizeMod: 2, frame:  0, tics: 0}
      when 'variable'
        mod = Math.random()
        @explosions.push {x: x, y: y, sizeMod: mod, frame:  0, tics: 0}
      else
        @explosions.push {x: x, y: y, sizeMod: 1, frame:  0, tics: 0}

  renderExplosion: (e) ->
    @context.drawImage(@explosionSpriteSheet,    #img
                  @spriteLocs[e.frame][0], #source x
                  @spriteLocs[e.frame][1], #source y
                  @spriteWidth, #source width
                  @spriteHeight, #source height
                  e.x, #destination x
                  e.y, #destination y
                  @spriteWidth*e.sizeMod, #frame width
                  @spriteHeight*e.sizeMod) #frame height

  updateExplosion: (e, i) ->
    #TODO fix this
    try
      if e.tics > @explosionTicCount #if we are ready for the next sprite
        e.tics = 0
        e.frame += 1
        if e.frame == @spriteLocs.length #if we have completed the animation, remove it and escape via continue
          @explosions.splice i, 1
          return
      e.tics++
    catch e
      @explosions.splice i, 1

  drawExplosions: ->
    @context.clearRect(0, 0, @canvas.width, @canvas.height)
    if not @explosions.length
      return
    @renderExplosion(e) for e in @explosions
    @updateExplosion(e, i) for e, i in @explosions
    @animationFrame = requestAnimationFrame @drawExplosions.bind(this)

  # getComboCounterLoc: ->
  #   #TODO need a resize function that updates positions, until then, this will remain as fixed
  #   # ccBCR = document.getElementById('explosion-canvas').getBoundingClientRect()
  #   x = window.innerWidth - 440
  #   y = 85
  #   return [x, y]

  getComboClusterLocs: ->
    #TODO stop using this crap placeholder and swap back to the random loc generator
    # x, y loc of middle of combo counter at full size
    x = window.innerWidth - 375
    y = 85
    return [[x - 20, y - 15],
            [x + 80, y + 20],
            [x - 100, y]]

  # getRandomOffset: (loc, xmin, xmax, ymin, ymax) ->
  #   #TODO this should spread them out evenly but with some variation (instead of sometimes having them overlay)
  #   x = (Math.random() * (xmax - xmin) + xmin)//1 + loc[0]
  #   y = (Math.random() * (ymax - ymin) + ymin)//1 + loc[1]
  #   return [x, y]

  # genClusterLocs: (loc, amount) ->
  #   # clusterLocs.push(@getRandomOffset(loc, -130, 130, -40, 40)) for i in [0...amount]
  #   clusterLocs

  maxPowerExplosion: ->
    locs = @getComboClusterLocs()
    @spawnExplosion(locs[i], 'double') for i in [0 ... locs.length]
    @drawExplosions()

  getConfig: (config) ->
    atom.config.get "bedlam.explosions.#{config}"
