
class Space.messaging.Serializable extends Space.Struct

  # make this class EJSON serializable
  @type: (name) ->
    this::typeName = @toString = generateTypeNameMethod(name)
    EJSON.addType name, _.partial(fromJSONValueFunction, this)

  toJSONValue: ->
    fields = @_getFields()
    # No special fields, simply parse instance to create deep copy
    if not fields?
      return JSON.parse JSON.stringify(this)
    else
      # Fields defined, parse them through EJSON to support nested types
      serialized = {}
      serialized[key] = EJSON.stringify(@[key]) for key of fields when @[key]?
      return serialized

# ========= HELPERS ========== #

generateTypeNameMethod = (typeName) -> return -> typeName

fromJSONValueFunction = (Class, json) ->

  if Class.fields?
    # Parse all fields that are set in the given json
    for field of Class.fields when json[field]?
      json[field] = EJSON.parse(json[field])

  return new Class(json)
