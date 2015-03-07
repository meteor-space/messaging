
class Space.messaging.EventBus extends Space.Object

  _handlers: null

  constructor: -> @_handlers = {}

  publish: (event) ->
    eventType = event.typeName()
    if not @_handlers[eventType]? then return
    handler.on(event) for handler in @_handlers[eventType]

  subscribeTo: (typeName, handler) -> (@_handlers[typeName] ?= []).push handler
