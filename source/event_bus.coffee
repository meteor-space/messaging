
class Space.messaging.EventBus extends Space.Object

  _eventHandlers: null
  _onPublishHooks: null

  constructor: ->
    @_eventHandlers = {}
    @_onPublishHooks = []

  publish: (event) ->
    eventType = event.typeName()
    hook(event) for hook in @_onPublishHooks
    if not @_eventHandlers[eventType]? then return
    handler(event) for handler in @_eventHandlers[eventType]

  onPublish: (handler) -> @_onPublishHooks.push handler

  subscribeTo: (typeName, handler) -> (@_eventHandlers[typeName] ?= []).push handler

  getHandledEventTypes: -> eventType for eventType of @_eventHandlers

  hasHandlerFor: (eventType) -> @_eventHandlers[eventType]?
