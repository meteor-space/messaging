Space.messaging.EventSubscribing = {

  dependencies: {
    eventBus: 'Space.messaging.EventBus'
    meteor: 'Meteor'
  }

  _eventHandlers: null

  eventSubscriptions: -> []

  onDependenciesReady: -> @_setupEventSubscribing()

  canHandleEvent: (event) -> @_getEventHandlerFor(event)?

  subscribe: (eventType, handler) ->
    if !eventType?
      throw new Error "Cannot register event handler for #{eventType}"
    if !handler?
      throw new Error "You have to provide a handler function."
    @_eventHandlers[eventType.toString()] = handler
    @eventBus.subscribeTo eventType, @_bindEventHandler(handler)

  on: (event) ->
    handler = @_getEventHandlerFor(event)
    if not handler?
      throw new Error "No event handler found for <#{event.typeName()}>"
    handler.call this, event

  _setupEventSubscribing: ->
    @_eventHandlers ?= {}
    @_setupDeclarativeMappings 'eventSubscriptions', (handler, eventType) =>
      @subscribe eventType, handler

  # All event handlers are bound to the meteor environment by default
  # so that the application code can mainly stay clear of having to
  # deal with these things.
  _bindEventHandler: (handler) ->
    if @meteor.isServer
      @meteor.bindEnvironment handler, @_onException, this
    else
      @underscore.bind handler, this

  _getEventHandlerFor: (event) -> @_eventHandlers[event.typeName()]

  _onException: (error) -> throw error
}

_.deepExtend Space.messaging.EventSubscribing, Space.messaging.DeclarativeMappings
