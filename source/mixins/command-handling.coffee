Space.messaging.CommandHandling = {

  dependencies: {
    commandBus: 'Space.messaging.CommandBus'
  }

  _commandHandlers: null

  commandHandlers: -> []

  onDependenciesReady: -> @_setupCommandHandling()

  register: (commandType, handler) ->
    if !commandType?
      throw new Error "Cannot register command handler for #{commandType}"
    if !handler?
      throw new Error "You have to provide a handler function."
    @_commandHandlers[commandType.toString()] = handler
    @commandBus.registerHandler commandType, @_bindCommandHandler(handler)

  handle: (command) ->
    handler = @_getCommandHandlerFor(command)
    if not handler?
      throw new Error "No command handler found for <#{command.typeName()}>"
    handler.call this, command

  canHandleCommand: (command) -> @_getCommandHandlerFor(command)?

  _setupCommandHandling: ->
    @_commandHandlers ?= {}
    @_setupDeclarativeMappings 'commandHandlers', (handler, commandType) =>
      @register commandType, handler

  # Command handlers are only bound to the controller instance but not
  # the Meteor environment because the command-sending part of the system
  # could expect a return value from the executed handler and
  # Meteor.bindEnvironment returns undefined if no current fiber exists.
  _bindCommandHandler: (handler) -> @underscore.bind handler, this

  _getCommandHandlerFor: (command) -> @_commandHandlers[command.typeName()]
}

_.deepExtend Space.messaging.CommandHandling, Space.messaging.DeclarativeMappings
