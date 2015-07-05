
class Space.messaging.Controller extends Space.Object

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'
    meteor: 'Meteor'
    underscore: 'underscore'

  # Register command handler
  @handle: (commandType, handler) ->
    if !commandType?
      throw new Error "Cannot register command handler for #{commandType}"
    if !handler?
      throw new Error "You have to provide a handler function."
    @_commandHandlers ?= {}
    @_commandHandlers[commandType.toString()] = handler

  # Subscribe to an event type
  @on: (eventType, handler) ->
    if !eventType?
      throw new Error "Cannot register event handler for #{eventType}"
    if !handler?
      throw new Error "You have to provide a handler function."
    @_eventHandlers ?= {}
    @_eventHandlers[eventType.toString()] = handler

  # Subscribe to events and register command handlers
  onDependenciesReady: ->
    for type, handler of @constructor._eventHandlers
      @eventBus.subscribeTo type, @_bindEventHandler(handler)
    for type, handler of @constructor._commandHandlers
      @commandBus.registerHandler type, @_bindCommandHandler(handler)

  handle: (command) ->
    handler = @constructor._commandHandlers[command.typeName()]
    if not handler?
      throw new Error "No command handler found for <#{command.typeName()}>"
    handler.call this, command

  on: (event) ->
    handler = @constructor._eventHandlers[event.typeName()]
    if not handler?
      throw new Error "No event handler found for <#{event.typeName()}>"
    handler.call this, event

  publish: (event) -> @eventBus.publish event

  send: (command) -> @commandBus.send command

  # All event handlers are bound to the meteor environment by default
  # so that the application code can mainly stay clear of having to
  # deal with these things.
  _bindEventHandler: (handler) ->
    if @meteor.isServer
      @meteor.bindEnvironment handler, @_onException, this
    else
      @underscore.bind handler, this

  # Command handlers are only bound to the controller instance but not
  # the Meteor environment because the command-sending part of the system
  # could expect a return value from the executed handler and
  # Meteor.bindEnvironment returns undefined if no current fiber exists.
  _bindCommandHandler: (handler) -> @underscore.bind handler, this

  _onException: (error) -> throw error
