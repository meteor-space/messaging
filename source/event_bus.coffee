
class Space.messaging.EventBus extends Space.Object

  _eventHandlers: null
  _onPublishCallbacks: null

  constructor: ->
    @_eventHandlers = {}
    @_onPublishCallbacks = []

  publish: (event) ->
    eventType = event.typeName()
    callback(event) for callback in @_onPublishCallbacks
    if not @_eventHandlers[eventType]? then return
    handler(event) for handler in @_eventHandlers[eventType]

  onPublish: (handler) -> @_onPublishCallbacks.push handler

  subscribeTo: (typeName, handler) -> (@_eventHandlers[typeName] ?= []).push handler

  getHandledEventTypes: -> eventType for eventType of @_eventHandlers

  hasHandlerFor: (eventType) -> @_eventHandlers[eventType]?
