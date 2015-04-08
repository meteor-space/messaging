
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

  # Register a handler for a Meteor method that invokes async
  # code and make it easy to return values to the client via automatic
  # setup of a Future. Reduces boilerplate code otherwise necessary

  @method: (name, handler) ->

    handlers = @_methodHandlers ?= {}
    # Save a reference to the handler to bind it to the controller later
    handlers[name] = handler
    # Register the method statically, so that is done only once
    method = {}
    method[name] = ->
      # Setup a future for this request that can be resolved later
      Future = Npm.require 'fibers/future'
      future = new Future()
      # Call the handler and provide the request (this) and future as params
      args = [this, future].concat Array::slice.call(arguments)
      handlers[name].apply null, args
      # Wait until we have a result, then return it to the client
      return future.wait()

    Meteor.methods method

  @_ensureHandlersAreInitialized: ->
    unless @_eventHandlers? then @_eventHandlers = {}
    unless @_commandHandlers? then @_commandHandlers = {}

  @_isEvent: (message) ->
    message.__super__.constructor is Space.messaging.Event

  @_isCommand: (message) ->
    message.__super__.constructor is Space.messaging.Command

  constructor: ->
    # Bind method handlers to the controller instance
    for name, handler of @constructor._methodHandlers
      @[name] = @constructor._methodHandlers[name] = _.bind(handler, this)

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
