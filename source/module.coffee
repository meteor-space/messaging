
class Space.messaging extends Space.Module

  @publish this, 'Space.messaging'

  configure: ->
    @injector.map('Space.messaging.EventBus').asSingleton()
    @injector.map('Space.messaging.CommandBus').asSingleton()
    @injector.map('Space.messaging.Api').asStaticValue()
