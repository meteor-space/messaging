
class Space.messaging.CommandBus extends Space.Object

  Dependencies: {
    meteor: 'Meteor'
    api: 'Space.messaging.Api'
  }

  _handlers: null
  _onSendHooks: null

  constructor: ->
    super
    @_handlers = {}
    @_onSendHooks = []

  send: (command, callback) ->
    if @meteor.isServer
      # ON THE SERVER
      handler = @_handlers[command.typeName()]
      hook(command) for hook in @_onSendHooks
      if !handler?
        message = "Missing command handler for <#{command.typeName()}>."
        throw new Error message
      handler(command)
    else
      # ON THE CLIENT
      @api.send command, callback

  registerHandler: (typeName, handler, overrideExisting) ->
    if @_handlers[typeName]? and !overrideExisting
      throw new Error "There is already an handler for #{typeName} commands."
    @_handlers[typeName] = handler

  overrideHandler: (typeName, handler) ->
    @registerHandler typeName, handler, true

  getHandlerFor: (commandType) -> @_handlers[commandType]

  hasHandlerFor: (commandType) -> @getHandlerFor(commandType)?

  onSend: (handler) -> @_onSendHooks.push handler
