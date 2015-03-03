
class Space.messaging.CommandBus extends Space.Object

  Dependencies:
    meteor: 'Meteor'
    configuration: 'Space.messaging.Configuration'

  @METEOR_METHOD_NAME: 'space-messaging-handle-command'

  constructor: -> @_handlers = {}

  onDependenciesReady: ->
    if !@meteor.isServer then return

    if @configuration.createMeteorMethods
      commandBusMethods = {}
      commandBusMethods[CommandBus.METEOR_METHOD_NAME] = @_handleClientCommand
      try
        @meteor.methods commandBusMethods
      catch error
        console.log error

  send: (command, callback) ->
    unless command instanceof Space.messaging.Command
      throw new Error "Can only send command instances, got this: #{command}"

    if @meteor.isClient
      @meteor.call CommandBus.METEOR_METHOD_NAME, command, callback
    else
      @_handleCommand command

  registerHandler: (typeName, handler, overrideExisting) ->
    if @_handlers[typeName]? and !overrideExisting
      throw new Error "There is already an handler for #{typeName} commands."
    @_handlers[typeName] = handler

  overrideHandler: (typeName, handler) ->
    @registerHandler typeName, handler, true

  getHandlerFor: (commandType) -> @_handlers[commandType]

  _handleCommand: (command, isFromClient) ->

    handler = @_handlers[command.typeName()]

    if not handler?
      message = "Missing command handler for <#{command.typeName()}>."
      throw new Error message

    if isFromClient and not handler.allowClient
      message = "Unauthorized command sent from client: #{command.typeName()}"
      throw new Error message

    isAllowed = if handler.before? then handler.before(command) else true
    if isAllowed
      handler.on command
      handler.after?(command)

  _handleClientCommand: (command) => @_handleCommand command, true
