Space.messaging.StaticHandlers = {

  dependencies: {
    underscore: 'underscore'
  }

  statics: {
    _handlers: null
    _setupHandler: (name, handler) ->
      @_handlers[name] = original: handler, bound: null
  }

  _getHandlerFor: (method) ->
    @constructor._handlers ?= {}
    @constructor._handlers[method]

  _bindHandlersToInstance: ->
    handlers = @constructor._handlers
    for name, handler of handlers
      boundHandler = @underscore.bind handler.original, this
      handlers[name].bound = boundHandler

}
