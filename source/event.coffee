
class Space.messaging.Event extends Space.messaging.Serializable
  @type 'Space.messaging.Event'

  constructor: (sourceId, data) ->
    # Allow to provide source id as first argument for convenience
    if arguments.length > 1
      data.sourceId = sourceId
    else
      data = sourceId
    # Hand over the data to serializable base class
    super(data)
