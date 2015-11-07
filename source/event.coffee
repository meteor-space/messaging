
class Space.messaging.Event extends Space.messaging.Serializable

  @type 'Space.messaging.Event'
  eventVersion: 1

  constructor: (data) ->
    data ?= {}
    if data.eventVersion? and data.eventVersion < @eventVersion
      @_migrateToLatestVersion data
    data.eventVersion = @eventVersion
    data.timestamp ?= new Date()
    super(data)

  fields: ->
    fields = super()
    # Add default fields to all events
    fields.sourceId ?= Match.Optional(Match.OneOf(String, Guid))
    fields.eventVersion = Match.Optional(Match.Integer)
    fields.version = Match.Optional(Match.Integer)
    fields.timestamp = Date
    return fields

  _migrateToLatestVersion: (data) ->
    for version in [data.eventVersion..@eventVersion]
      @["migrateFromVersion#{version}"]?(data)
