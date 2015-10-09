class Space.messaging.Tracker extends Space.Object

  Dependencies: {
    tracker: 'Tracker'
    meteor: 'Meteor'
  }

  onDependenciesReady: -> @tracker.autorun => @autorun()

  autorun: ->
