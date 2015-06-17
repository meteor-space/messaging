class Space.messaging.Tracker extends Space.Object

  Dependencies:
    tracker: 'Tracker'

  onDependenciesReady: -> @tracker.autorun => @autorun()

  autorun: ->
