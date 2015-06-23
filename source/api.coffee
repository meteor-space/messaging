
class Space.messaging.Api extends Space.Object

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'

  @_methodHandlers: null

  # Register a handler for a Meteor method and add it as
  # method to instance to simplify testing of methods.
  @method: (type, handler) ->
    name = type.toString()
    handlers = @_setupHandler name, handler
    @_registerMethod name, (param) ->
      if type.isSerializable then check param, type
      # Provide the method context to bound handler
      args = [this].concat Array::slice.call(arguments)
      handlers[name].bound.apply null, args

  # Sugar for sending messages to the server
  @send: (message) -> Meteor.call message.typeName(), message

  @_setupHandler: (name, handler) ->
    handlers = @_methodHandlers ?= {}
    handlers[name] = original: handler, bound: null
    return handlers

  # Register the method statically, so that is done only once
  @_registerMethod: (name, body) ->
    method = {}
    method[name] = body
    Meteor.methods method

  onDependenciesReady: ->
    handlers = @constructor._methodHandlers
    for methodName, handler of handlers
      boundHandler = _.bind handler.original, this
      handlers[methodName].bound = @[methodName] = boundHandler
