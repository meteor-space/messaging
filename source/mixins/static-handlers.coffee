Space.messaging.StaticHandlers = {

  dependencies: {
    underscore: 'underscore'
  }

  statics: {
    _handlers: null
    _setupHandler: (name, handler) ->
      @_handlers[name] = original: handler, bound: null
  }

  onDependenciesReady: -> @_ensureHandlersMap()

  _getHandlerFor: (method) ->
    @_ensureHandlersMap()
    @constructor._handlers[method]

  _bindHandlersToInstance: ->
    handlers = @constructor._handlers
    for name, handler of handlers
      boundHandler = @underscore.bind handler.original, this
      handlers[name].bound = boundHandler

  _ensureHandlersMap: -> @constructor._handlers ?= {}

}
