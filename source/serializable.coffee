
class Space.messaging.Serializable extends Space.Struct

  @isSerializable: true

  # make this class EJSON serializable
  @type: (name) ->
    this::typeName = @toString = generateTypeNameMethod(name)
    EJSON.addType name, _.partial(fromJSONValueFunction, this)
    return this

  toJSONValue: ->
    fields = @fields()
    # No special fields, simply parse instance to create deep copy
    if not fields?
      return JSON.parse JSON.stringify(this)
    else
      # Fields defined, parse them through EJSON to support nested types
      serialized = {}
      serialized[key] = EJSON.toJSONValue(@[key]) for key of fields
      return serialized

# ========= HELPERS ========== #

generateTypeNameMethod = (typeName) -> return -> typeName

fromJSONValueFunction = (Class, json) ->
  # Parse all fields that are set in the given json
  for field of Class::fields() when json[field]?
    json[field] = EJSON.fromJSONValue(json[field])

  return new Class(json)
