
class Space.messaging.EventBus extends Space.Object

  _handlers: null

  constructor: -> @_handlers = {}

  publish: (event) ->
    eventType = event.typeName()
    if not @_handlers[eventType]? then return

    for handler in @_handlers[eventType]
      isAllowed = if handler.before? then handler.before(event) else true
      if isAllowed
        handler.on event
        handler.after?(event)

  subscribeTo: (typeName, handler) -> (@_handlers[typeName] ?= []).push handler
