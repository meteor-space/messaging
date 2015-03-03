
class Space.messaging extends Space.Module

  @publish this, 'Space.messaging'

  configure: ->
    @injector.map('Space.messaging.Configuration').asStaticValue()
    @injector.map('Space.messaging.EventBus').asSingleton()
    @injector.map('Space.messaging.CommandBus').asSingleton()
