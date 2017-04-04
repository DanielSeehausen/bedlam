random = require "lodash.random"
comboMode = require "./combo-mode"

module.exports =
  shake: (editorElement) ->
    min = @getConfig "minIntensity"
    max = @getConfig "maxIntensity"

    x = @shakeIntensity min, max
    y = @shakeIntensity min, max


    editorElement.style.top = "#{y}px"
    editorElement.style.left = "#{x}px"

    setTimeout ->
      editorElement.style.top = ""
      editorElement.style.left = ""
    , 75

  shakeIntensity: (min, max) ->
    b = comboMode.getBenchmark()
    min = if min*b < min then min else if min*b > max then max
    max = if max*b > max then max else if max*b < min then min
    direction = if Math.random() > 0.5 then -1 else 1
    random(min, max, true) * direction

  getConfig: (config) ->
    atom.config.get "bedlam.screenShake.#{config}"
