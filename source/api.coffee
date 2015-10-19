
class Space.messaging.Api extends Space.Object

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'
  }

  @mixin Space.messaging.DeclarativeMappings

  @_methodHandlers: {}

  # Register a handler for a Meteor method and add it as
  # method to instance to simplify testing of methods.
  @method: (type, handler) ->
    @_setupHandler type, handler
    @_registerMethod type, @_setupMethod(type)

  # Sugar for sending messages to the server
  @send: (message, callback) ->
    Meteor.call message.typeName(), message, callback

  @_setupHandler: (name, handler) ->
    @_methodHandlers[name] = original: handler, bound: null

  # Register the method statically, so that is done only once
  @_registerMethod: (name, body) ->
    method = {}
    method[name] = body
    Meteor.methods method

  @_setupMethod: (type) =>
    name = type.toString()
    handlers = @_methodHandlers
    return (param) ->
      try type = Space.resolvePath(name)
      if type.isSerializable then check param, type
      # Provide the method context to bound handler
      args = [this].concat Array::slice.call(arguments)
      handlers[name].bound.apply null, args

  onDependenciesReady: ->
    @_setupDeclarativeMappings 'methods', @_setupDeclarativeHandler
    handlers = @constructor._methodHandlers
    for methodName, handler of handlers
      boundHandler = _.bind handler.original, this
      handlers[methodName].bound = @[methodName] = boundHandler

  _setupDeclarativeHandler: (handler, type) =>
    existingHandler = @_getHandlerFor type
    if existingHandler?
      @constructor._setupHandler type, handler
    else
      @constructor.method type, handler

  _getHandlerFor: (method) -> @constructor._methodHandlers[method]
