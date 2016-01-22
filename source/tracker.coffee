class Space.messaging.Tracker extends Space.Object

  dependencies: {
    tracker: 'Tracker'
    meteor: 'Meteor'
  }

  onDependenciesReady: -> @tracker.autorun => @autorun()

  autorun: ->
