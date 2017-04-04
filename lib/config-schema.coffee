module.exports =
  autoToggle:
    title: "Auto Toggle"
    description: "Toggle on start."
    type: "boolean"
    default: true

  comboMode:
    type: "object"
    properties:
      enabled:
        title: "Combo Mode - Enabled"
        description: "When enabled effects won't appear until reach the activation threshold."
        type: "boolean"
        default: true
        order: 1

      activationThreshold:
        title: "Combo Mode - Activation Threshold"
        description: "Streak threshold to activate the power mode."
        type: "integer"
        default: 10
        minimum: 1
        maximum: 1000

      streakTimeout:
        title: "Combo Mode - Streak Timeout"
        description: "Timeout to reset the streak counter. In seconds."
        type: "integer"
        default: 10
        minimum: 1
        maximum: 100

      exclamationEvery:
        title: "Combo Mode - Exclamation Every"
        description: "Shows an exclamation every streak count."
        type: "integer"
        default: 10
        minimum: 1
        maximum: 100

      exclamationTexts:
        title: "Combo Mode - Exclamation Texts"
        description: "Exclamations to show (randomized)."
        type: "array"
        default: ["Super!", "Radical!", "Fantastic!", "Great!", "OMG", "Whoah!", ":O", "Nice!", "Splendid!", "Wild!", "Grand!", "Impressive!", "Stupendous!", "Extreme!", "Awesome!"]

      opacity:
        title: "Combo Mode - Opacity"
        description: "Opacity of the streak counter when activated."
        type: "number"
        default: 0.5
        minimum: 0
        maximum: 1

  screenShake:
    type: "object"
    properties:
      minIntensity:
        title: "Screen Shake - Minimum Intensity"
        description: "The minimum (randomized) intensity of the shake."
        type: "integer"
        default: 1
        minimum: 0
        maximum: 100

      maxIntensity:
        title: "Screen Shake - Maximum Intensity"
        description: "The maximum (randomized) intensity of the shake."
        type: "integer"
        default: 3
        minimum: 0
        maximum: 100

      enabled:
        title: "Screen Shake - Enabled"
        description: "Turn the shaking on/off."
        type: "boolean"
        default: true

  playAudio:
    type: "object"
    properties:
      enabled:
        title: "Play Audio - Enabled"
        description: "Play audio clip on/off."
        type: "boolean"
        default: false
        order: 1

      audioclip:
        title: "Play Audio - Audioclip"
        description: "Which audio clip played at keystroke."
        type: "string"
        default: '../audioclips/typewriter.wav'
        enum: [
          {value: '../audioclips/sh-yes.wav', description: 'Stephen Hawking Yes'}
          {value: '../audioclips/gun.wav', description: 'Gun'}
          {value: '../audioclips/typewriter.wav', description: 'Type Writer'}
          {value: 'customAudioclip', description: 'Custom Path'}
        ]
        order: 3

      useEncouragement:
        title: "Enable Verbal Encouragement"
        description: "'Its for productivity!'."
        type: "boolean"
        default: true

      encouragementInterval:
        title: "Encouragement Interval"
        description: "Frequency of audio samples from Unreal Tournament, Killer Instinct, and other sources"
        type: "integer"
        default: 20
        minimum: 1
        maximum: 1000

      customAudioclip:
        title: "Play Audio - Path to Audioclip"
        description: "Path to audioclip played at keystroke."
        type: "string"
        default: 'rocksmash.wav'
        order: 4

      volume:
        title: "Play Audio - Volume"
        description: "Volume of the audio clip played at keystroke."
        type: "number"
        default: 0.5
        minimum: 0.0
        maximum: 1
        order: 2

  explosions:
    type: "object"
    properties:
      enabled: "Explosions - Enabled"
      description: "Turn the explosions on/off."
      type: "boolean"
      default: true
      order: 1

  particles:
    type: "object"
    properties:
      enabled:
        title: "Particles - Enabled"
        description: "Turn the particles on/off."
        type: "boolean"
        default: true
        order: 1
      colours:
        type: "object"
        properties:
          type:
            title: "Colours"
            description: "Configure colour options"
            type: "string"
            default: "random"
            enum: [
              {value: 'cursor', description: 'Particles will be the colour at the cursor.'}
              {value: 'random', description: 'Particles will have random colours.'}
              {value: 'fixed', description: 'Particles will have a fixed colour.'}
            ]
            order: 1

          fixed:
            title: "Fixed colour"
            description: "Colour when fixed colour is selected"
            type: "color"
            default: "#fff"

      totalCount:
        type: "object"
        properties:
          max:
            title: "Particles - Max Total"
            description: "The maximum total number of particles on the screen."
            type: "integer"
            default: 500
            minimum: 0

      spawnCount:
        type: "object"
        properties:
          min:
            title: "Particles - Minimum Spawned"
            description: "The minimum (randomized) number of particles spawned on input."
            type: "integer"
            default: 5

          max:
            title: "Particles - Maximum Spawned"
            description: "The maximum (randomized) number of particles spawned on input."
            type: "integer"
            default: 15

      size:
        type: "object"
        properties:
          min:
            title: "Particles - Minimum Size"
            description: "The minimum (randomized) size of the particles."
            type: "integer"
            default: 2
            minimum: 0

          max:
            title: "Particles - Maximum Size"
            description: "The maximum (randomized) size of the particles."
            type: "integer"
            default: 4
            minimum: 0

  excludedFileTypes:
    type: "object"
    properties:
      excluded:
        title: "Prohibit bedlam from enabling on these file types:"
        description: "Use comma separated, lowercase values (i.e. \"html, cpp, css\")"
        type: "array"
        default: ["."]
