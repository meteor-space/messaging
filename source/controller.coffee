
class Space.messaging.Controller extends Space.Object

  @mixin [
    Space.messaging.EventSubscribing
    Space.messaging.EventPublishing
    Space.messaging.CommandSending
  ]

if Meteor.isServer
  Space.messaging.Controller.mixin Space.messaging.CommandHandling
