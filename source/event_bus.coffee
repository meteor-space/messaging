
class Space.messaging.EventBus extends Space.Object

  _eventHandlers: null
  _onPublishHooks: null

  constructor: ->
    @_eventHandlers = {}
    @_onPublishHooks = []

  publish: (event, options={}) ->
    eventType = event.typeName()
    hook(event) for hook in @_onPublishHooks when !options.ignoreHooks
    if not @_eventHandlers[eventType]? then return
    handler(event) for handler in @_eventHandlers[eventType]

  onPublish: (handler) -> @_onPublishHooks.push handler

  subscribeTo: (typeName, handler) -> (@_eventHandlers[typeName] ?= []).push handler

  getHandledEventTypes: -> eventType for eventType of @_eventHandlers

  hasHandlerFor: (eventType) -> @_eventHandlers[eventType]?

  distribute: (appId, collection, events) ->
    for eventType in events
      @subscribeTo eventType, (event) -> collection.insert {
        type: eventType.toString()
        payload: EJSON.stringify(event)
        sentBy: appId
        receivedBy: []
      }

  receive: (appId, collection, events) ->
    events = events.map (event) -> event.toString()
    findByTypes = type: $in: events
    notReceivedYet = receivedBy: $nin: [appId]

    # Return the observe handle so that it can be stopped by outside code
    return collection.find($and: [findByTypes, notReceivedYet]).observe {
      added: (event) =>
        # We find and lock the event, so that it never gets read twice per app
        lockedEvent = collection.findAndModify({
          query: $and: [_id: event._id, notReceivedYet]
          update: $push: receivedBy: appId
        })
        # Only publish the event if this process was the one that locked it
        @publish EJSON.parse(event.payload) if lockedEvent?
    }
