path = require "path"

module.exports =

  refreshClips: ->
    @remNegativeClips = ['sn-unconscious-incompetence', 'sn-conscious-incompetence', 'sn-practice-a-lot']
    @remLongPositiveClips = ['combo-whore', 'rm-go-son-go', 'flawless-victory', 'ludicrous-kill', 'holy-shit']
    @remShortPositiveClips = ['dominating', 'unstoppable', 'sh-yes', 'gun']

  sampleAndRemove: (arr) ->
    if arr.length == 0 then return false
    return arr.splice(Math.floor(Math.random()*arr.length), 1)

  playInputSound: ->
    if (@getConfig "audioclip") is "customAudioclip"
      pathtoaudio = @getConfig "customAudioclip"
    else
      pathtoaudio = path.join(__dirname, @getConfig "audioclip")
    audio = new Audio(pathtoaudio)
    audio.currentTime = 0
    audio.volume = @getConfig "volume"
    audio.play()

  playClip: (clip, vol=1) ->
    #volume (vol) should be used as a modifier to maintain relative levels, not to override user set volume level in the config
    try
      pathtoaudio = path.join(__dirname, "../audioclips/#{clip}.wav")
    catch e then console.error("No audio clip: ../audioclips/#{clip}.wav found!")
    audio = new Audio(pathtoaudio)
    audio.currentTime = 0
    audio.volume = (@getConfig "volume") * vol
    audio.play()

  playRandomAudioClip: (type, vol) ->
    switch type
      when 'longP'
        clip = @sampleAndRemove(@remLongPositiveClips)
      when 'shortP'
        clip = @sampleAndRemove(@remShortPositiveClips)
      when 'neg'
        clip = @sampleAndRemove(@remNegativeClips)
    if clip then @playClip(clip, vol)


  getConfig: (config) ->
    atom.config.get "bedlam.playAudio.#{config}"
