
class Space.messaging.Controller extends Space.Object

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'
    meteor: 'Meteor'
    utils: 'underscore'

  @ERRORS:
    unkownMessageType: "Message type unknown: "

  @handle: (messageType, handler) ->
    @_ensureHandlersAreInitialized()
    if @_isEvent messageType
      @_eventHandlers[messageType] = handler
    else if @_isCommand messageType
      @_commandHandlers[messageType] = handler
    else
      throw new Error @ERRORS.unkownMessageType + "<#{messageType}>"

  @on: (messageType, options..., callback) ->
    @_ensureHandlersAreInitialized()
    options = options[0] ? {} # Use splat for optional options
    options.on = callback
    @handle messageType, options

  @_ensureHandlersAreInitialized: ->
    unless @_eventHandlers? then @_eventHandlers = {}
    unless @_commandHandlers? then @_commandHandlers = {}

  @_isEvent: (message) ->
    message.__super__.constructor is Space.messaging.Event

  @_isCommand: (message) ->
    message.__super__.constructor is Space.messaging.Command

  onDependenciesReady: ->

    for type, handler of @constructor._eventHandlers
      @eventBus.subscribeTo type, @_createBoundHandler(handler)

    for type, handler of @constructor._commandHandlers
      @commandBus.registerHandler type, @_createBoundHandler(handler)

  _createBoundHandler: (handler) ->
    bound = {}
    # Create handlers that are bound to this controller instance
    for key, value of handler
      if typeof(value) is 'function'
        callback = @utils.bind(value, this)
        bound[key] = @meteor.bindEnvironment callback, @_onException, this
      else
        bound[key] = value
    return bound

  _onException: (error) -> throw error
