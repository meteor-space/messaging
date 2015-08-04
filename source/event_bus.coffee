
class Space.messaging.EventBus extends Space.Object

  _handlers: null

  constructor: -> @_handlers = {}

  publish: (event) ->
    eventType = event.typeName()
    if not @_handlers[eventType]? then return
    handler(event) for handler in @_handlers[eventType]

  subscribeTo: (typeName, handler) -> (@_handlers[typeName] ?= []).push handler

  distribute: (appId, collection, events) ->
    for eventType in events
      @subscribeTo eventType, (event) -> collection.insert {
        type: eventType.toString()
        payload: event
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
        @publish event.payload if lockedEvent?
    }
