
class Space.messaging.Api extends Space.Object

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'
    Future: 'Future'

  @_methodHandlers: null

  # Register a handler for a Meteor method that invokes async
  # code and make it easy to return values to the client via automatic
  # setup of a Future. Reduces boilerplate code otherwise necessary
  @method: (name, handler) ->

    handlers = @_methodHandlers ?= {}
    handlers[name] = original: handler, bound: null

    # Register the method statically, so that is done only once
    method = {}
    method[name] = ->
      # Provide the method context to bound handler
      args = [this].concat Array::slice.call(arguments)
      handlers[name].bound.apply null, args
    Meteor.methods method

  onDependenciesReady: ->
    handlers = @constructor._methodHandlers
    for methodName, handler of handlers
      boundHandler = @_createBoundMethodHandler handler.original
      handlers[methodName].bound = @[methodName] = boundHandler

  _createBoundMethodHandler: (handler) ->
    return =>
      # Setup a future for this request that can be resolved later
      future = new @Future()
      # Provide future as last argument to method handler
      handler.apply this, Array::slice.call(arguments).concat future
      # Wait until we have a result, then return it to the client
      return future.wait()
