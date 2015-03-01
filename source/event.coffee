
class Space.messaging.Event extends Space.messaging.Serializable

  @type 'Space.messaging.Event', ->
    sourceId: String
    version: Match.Optional(Match.Integer)
