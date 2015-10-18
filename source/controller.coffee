
class Space.messaging.Controller extends Space.Object

  @mixin Space.messaging.EventSubscribing

  onDependenciesReady: ->
    @_setupEventSubscribing()
    @_setupCommandHandling?()

if Meteor.isServer
  Space.messaging.Controller.mixin Space.messaging.CommandHandling
