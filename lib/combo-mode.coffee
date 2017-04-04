debounce = require "lodash.debounce"
defer = require "lodash.defer"
sample = require "lodash.sample"
colorHelper = require "./color-helper"
explosionsCanvas = require "./explosion-canvas"
audio = require "./play-audio"

module.exports =
  #TODO these have been encapsulated, remove them?
  # currentStreak: 0
  # reached: false
  # maxStreakReached: false
  # prevClipPlayedAt: 0

  reset: ->
    @container?.parentNode?.removeChild @container

  destroy: ->
    @reset()
    @container = null
    @debouncedEndStreak?.cancel()
    @debouncedEndStreak = null
    @streakTimeoutObserver?.dispose()
    @opacityObserver?.dispose()
    @currentStreak = 0
    @reached = false
    @maxStreakReached = false

  createElement: (name, parent)->
    @element = document.createElement "div"
    @element.classList.add name
    parent.appendChild @element if parent
    @element

  setup: (editorElement) ->
    if not @container
      @container = @createElement "streak-container"
      @title = @createElement "title", @container
      @title.textContent = "Combo"
      @max = @createElement "max", @container
      @avg = @createElement "avg", @container
      @counter = @createElement "counter", @container
      @counter.setAttribute("id", "combo-counter")
      @bar = @createElement "bar", @container
      @exclamations = @createElement "exclamations", @container
      @maximumPower = 1.8 # currStreak/avgStreak
      @atMaxPower = false
      @avgStreak = @updateAvgStreak()
      @maxStreak = @getMaxStreak()
      @max.textContent = "Max #{@maxStreak}"
      @streakTimeoutObserver?.dispose()
      @streakTimeoutObserver = atom.config.observe 'bedlam.comboMode.streakTimeout', (value) =>
        @streakTimeout = value * 1000
        @endStreak()
        @debouncedEndStreak?.cancel()
        @debouncedEndStreak = debounce @endStreak.bind(this), @streakTimeout

    @exclamations.innerHTML = ''
    editorElement.querySelector(".scroll-view").appendChild @container
    if @currentStreak
      leftTimeout = @streakTimeout - (performance.now() - @lastStreak)
      @refreshStreakBar leftTimeout
    @renderStreak()

  manageEncouragement: ->
    if (@currentStreak > (@prevClipPlayedAt + audio.getConfig("encouragementInterval")))
      b = @getBenchmark()
      switch
        when (b > 1.7)
          audio.playRandomAudioClip('longP', 1.5)
        when (b > 1.5)
          audio.playRandomAudioClip('longP', 1.3)
        when (b > 1.3)
          audio.playRandomAudioClip('shortP', 1.1)
        when (b > 1.1)
          audio.playRandomAudioClip('shortP', 1.0)
        when (b > 0.9)
          audio.playRandomAudioClip('shortP', 1.0)
      @prevClipPlayedAt = @currentStreak

  manageDerision: ->
    if @atMaxPower
      audio.playClip('combo-breaker')
    else if @currentStreak > 10
      audio.playRandomAudioClip('neg', 2.5)

  increaseStreak: ->
    @lastStreak = performance.now()
    @debouncedEndStreak()
    @currentStreak++
    if audio.getConfig("useEncouragement") then @manageEncouragement()
    if @currentStreak > @maxStreak
      @increaseMaxStreak()
    @showExclamation() if @currentStreak > 0 and @currentStreak % @getConfig("exclamationEvery") is 0
    if !@reached and @currentStreak >= @getConfig("activationThreshold")
      @reached = true
      @container.style.opacity = @getConfig("opacity")
      @container.classList.add "reached"
    @refreshStreakBar()
    @renderStreak()

  endStreak: ->
    if @currentStreak > 5 then @updateAvgStreak()
    if audio.getConfig("useEncouragement") then @manageDerision()
    audio.refreshClips()
    @currentStreak = @prevClipPlayedAt = 0
    if @atMaxPower
      @counter.classList.remove "shimmer"
      @bar.classList.remove "shimmer"
      @container.style.opacity = 0
    @atMaxPower = @reached = @maxStreakReached = false
    @container.classList.remove "reached"
    @renderStreak()

  renderStreak: ->
    @counter.textContent = @currentStreak
    #TODO can just make the variable an invoking function
    b = @getBenchmark()
    @counter.style.opacity = if (b > 1.2) then 1 else ((b * .5) + .4)
    @bar.style.opacity = if (b > 1.2) then 1 else ((b * .5) + .4)
    @counter.style.fontSize = if b*80 < 30 then "30px" else if b*80 > 120 then "120px" else "#{b*80}px"
    comboColor = colorHelper.getComboCountColor(b)
    @counter.style.color = @bar.style.background = comboColor

    if !@atMaxPower && b > @maximumPower
      explosionsCanvas.maxPowerExplosion()
      audio.playClip('explosion')
      @atMaxPower = true
      @counter.classList.add "shimmer"
      @bar.classList.add "shimmer"

    @counter.classList.remove "bump"
    defer =>
      @counter.classList.add "bump"

  refreshStreakBar: (leftTimeout = @streakTimeout) ->
    scale = leftTimeout / @streakTimeout
    @bar.style.transition = "none"
    @bar.style.transform = "scaleX(#{scale})"
    setTimeout =>
      @bar.style.transform = ""
      @bar.style.transition = "transform #{leftTimeout}ms linear"
    , 100

  showExclamation: (text = null) ->
    exclamation = document.createElement "span"
    exclamation.classList.add "exclamation"
    text = sample @getConfig "exclamationTexts" if text is null
    exclamation.textContent = text

    @exclamations.insertBefore exclamation, @exclamations.childNodes[0]
    setTimeout =>
      if exclamation.parentNode is @exclamations
        @exclamations.removeChild exclamation
    , 2000

  hasReached: ->
    @reached

  setAvgStreakDefaults: ->
    count = 0
    sum = 0
    localStorage.setItem "bedlam.totalStreakCount", count
    localStorage.setItem "bedlam.totalStreakSum", sum
    @avgStreak = 0
    @avg.textContent = "Avg #{@avgStreak}"

  updateAvgStreak: ->
    sum = localStorage.getItem "bedlam.totalStreakSum"
    count = localStorage.getItem "bedlam.totalStreakCount"
    if (sum == null) || (count == null)
      @setAvgStreakDefaults()
    else
      if @currentStreak > 0
        count = parseInt(count) + 1
        sum = parseInt(sum) + @currentStreak
      else
        count = parseInt(count)
        sum = parseInt(sum)
      localStorage.setItem "bedlam.totalStreakCount", count
      localStorage.setItem "bedlam.totalStreakSum", sum
      @avgStreak = if count == 0 then 0 else Math.trunc(sum/count)
      @avg.textContent = "Avg #{@avgStreak}"
      return @avgStreak

  getMaxStreak: ->
    maxStreak = localStorage.getItem "bedlam.maxStreak"
    maxStreak = 0 if maxStreak is null
    maxStreak

  increaseMaxStreak: ->
    localStorage.setItem "bedlam.maxStreak", @currentStreak
    @maxStreak = @currentStreak
    @max.textContent = "Max #{@maxStreak}"
    @showExclamation "NEW PERSONAL BEST!!!" if @maxStreakReached is false
    @maxStreakReached = true

  resetMaxStreak: ->
    localStorage.setItem "bedlam.maxStreak", 0
    @maxStreakReached = false
    @maxStreak = 0
    if @max
      @max.textContent = "Max 0"

  getBenchmark: ->
    return if @avgStreak == 0 then 0 else parseInt(@currentStreak)/parseInt(@avgStreak)

  getConfig: (config) ->
    atom.config.get "bedlam.comboMode.#{config}"
