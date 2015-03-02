
class Space.messaging.Controller extends Space.Object

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'

  @ERRORS:
    unkownMessageType: "Message type unknown: "

  onDependenciesReady: ->

    for type, options of @constructor._eventHandlers
      @eventBus.subscribe type, options, this

    for type, options of @constructor._commandHandlers
      @commandBus.registerHandler type, options, this

  @handle: (messageType, options) ->

    unless @_eventHandlers? then @_eventHandlers = {}
    unless @_commandHandlers? then @_commandHandlers = {}

    if messageType.__super__.constructor is Space.messaging.Event
      @_eventHandlers[messageType] = options

    else if messageType.__super__.constructor is Space.messaging.Command
      @_commandHandlers[messageType] = options

    else
      throw new Error @ERRORS.unkownMessageType + "<#{messageType}>"
