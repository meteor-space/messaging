
class Space.messaging.Event extends Space.messaging.Serializable
  @type 'Space.messaging.Event'
  eventVersion: 1

  constructor: (data) ->
    if data?.eventVersion? and data.eventVersion < @eventVersion
      @_migrateToLatestVersion data
    data?.eventVersion = @eventVersion
    super(data)

  _getFields: ->
    fields = super()
    fields?.eventVersion = Match.Optional(Match.Integer)
    return fields

  _migrateToLatestVersion: (data) ->
    for version in [data.eventVersion..@eventVersion]
      @["migrateFromVersion#{version}"]?(data)
