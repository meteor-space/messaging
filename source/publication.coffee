class Space.messaging.Publication extends Space.Object

  dependencies: {
    meteor: 'Meteor'
  }

  @mixin [
    Space.messaging.DeclarativeMappings
    Space.messaging.StaticHandlers
  ]

  publications: -> []

  @publish: (name, handler) ->
    @_setupHandler name, handler
    handlers = @_handlers
    @_registerPublication name, ->
      # Provide the publish context to bound handler as first argument
      args = [this].concat Array::slice.call(arguments)
      handlers[name].bound.apply null, args
    return this

  @_registerPublication: (name, callback) -> Meteor.publish name, callback

  onDependenciesReady: ->
    super
    @_setupDeclarativeMappings 'publications', @_setupDeclarativeHandler
    @_bindHandlersToInstance()

  _setupDeclarativeHandler: (handler, type) =>
    existingHandler = @_getHandlerFor type
    if existingHandler?
      @constructor._setupHandler type, handler
    else
      @constructor.publish type, handler
