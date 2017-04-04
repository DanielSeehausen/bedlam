{CompositeDisposable} = require "atom"
configSchema = require "./config-schema"
powerEditor = require "./power-editor"

module.exports = Bedlam =
  config: configSchema
  subscriptions: null
  active: false
  powerEditor: powerEditor

  # called when the package is initially loaded/activated
  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add "atom-workspace",
      "bedlam:toggle": => @toggle()
      "bedlam:enable": => @enable()
      "bedlam:disable": => @disable()
      "bedlam:reset-max-combo": =>
        @powerEditor.getCombo().resetMaxStreak()

    if @getConfig "autoToggle"
      @toggle()

  # called when the editor is closed also!
  deactivate: ->
    @subscriptions?.dispose()
    @active = false
    @powerEditor.disable()

  getConfig: (config) ->
    atom.config.get "bedlam.#{config}"

  toggle: ->
    if @active then @disable() else @enable()

  enable: ->
    @active = true
    @powerEditor.enable()

  disable: ->
    @active = false
    @powerEditor.disable()
