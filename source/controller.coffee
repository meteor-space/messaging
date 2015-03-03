
class Space.messaging.Controller extends Space.Object

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'
    meteor: 'Meteor'
    utils: 'underscore'

  @ERRORS:
    unkownMessageType: "Message type unknown: "

  onDependenciesReady: ->

    for type, handler of @constructor._eventHandlers
      @_bindHandler handler
      @eventBus.subscribeTo type, handler

    for type, handler of @constructor._commandHandlers
      @_bindHandler handler
      @commandBus.registerHandler type, handler

  @handle: (messageType, handler) ->

    unless @_eventHandlers? then @_eventHandlers = {}
    unless @_commandHandlers? then @_commandHandlers = {}

    if messageType.__super__.constructor is Space.messaging.Event
      @_eventHandlers[messageType] = handler

    else if messageType.__super__.constructor is Space.messaging.Command
      @_commandHandlers[messageType] = handler

    else
      throw new Error @ERRORS.unkownMessageType + "<#{messageType}>"

  _bindHandler: (handler) ->

    for name, fn of handler when typeof(fn) is 'function'
      handler[name] = @meteor.bindEnvironment @utils.bind(fn, this)
