
class Space.messaging.Command extends Space.messaging.Serializable

  @type 'Space.messaging.Command'

  constructor: (data) ->
    data ?= {}
    data.timestamp = new Date()
    super(data)

  _getFields: ->
    fields = super()
    # Add default fields to all events
    fields?.targetId ?= Match.OneOf(String, Guid)
    fields?.version = Match.Optional(Match.Integer)
    fields?.timestamp = Date
    return fields
