class Space.messaging.Publication extends Space.Object

  Dependencies:
    meteor: 'Meteor'
    underscore: 'underscore'

  @_handlers: null

  @publish: (name, handler) ->
    # Setup handlers
    handlers = @_handlers ?= {}
    handlers[name] = original: handler, bound: null
    @_registerPublication name, -> handlers[name].bound.apply null, arguments

  @_registerPublication: (name, callback) -> Meteor.publish name, callback

  onDependenciesReady: -> @_bindHandlersToInstance()

  _bindHandlersToInstance: ->
    handlers = @constructor._handlers
    for methodName, handler of handlers
      boundHandler = @underscore.bind handler.original, this
      handlers[methodName].bound = @[methodName] = boundHandler
