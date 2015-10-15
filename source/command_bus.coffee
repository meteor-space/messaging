
class Space.messaging.CommandBus extends Space.Object

  constructor: -> @_handlers = {}

  send: (command) ->
    handler = @_handlers[command.typeName()]
    if not handler?
      message = "Missing command handler for <#{command.typeName()}>."
      throw new Error message

    handler(command)

  registerHandler: (typeName, handler, overrideExisting) ->
    if @_handlers[typeName]? and !overrideExisting
      throw new Error "There is already an handler for #{typeName} commands."
    @_handlers[typeName] = handler

  overrideHandler: (typeName, handler) ->
    @registerHandler typeName, handler, true

  getHandlerFor: (commandType) -> @_handlers[commandType]

  hasHandlerFor: (commandType) -> @getHandlerFor(commandType)?
