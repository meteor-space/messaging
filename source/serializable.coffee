
class Space.messaging.Serializable extends Space.Object

  @ERRORS:
    typeRequired: 'You forgot to specify the type of the serializable.'

  @type: (name, fields) ->

    if fields? then @fields = fields
    # make it EJSON serializable
    this::typeName = @toString = generateTypeNameMethod(name)
    EJSON.addType name, generateFromJSONValueFunction(this)
    @__IS_SERIALIZABLE__ = true

  constructor: (data) ->

    # Require type to be set statically
    unless @constructor.__IS_SERIALIZABLE__
      throw new Error Serializable.ERRORS.typeRequired

    fields = @_getSerializableFields()
    if not fields? then return
    # Use the fields configuration to check given data during runtime
    check data, fields
    # Copy fields to instance
    @[key] = data[key] for key of fields

  toJSONValue: ->
    fields = @_getSerializableFields()
    # No special fields, simply parse instance to create deep copy
    if not fields? then return JSON.parse JSON.stringify(this)
    # Fields defined, parse them through EJSON to support nested types
    serialized = {}
    serialized[key] = EJSON.stringify(@[key]) for key of fields when @[key]?
    return serialized

  _getSerializableFields: ->
    if @constructor.fields? then return @constructor.fields() else return null

# ========= HELPERS ========== #

generateTypeNameMethod = (typeName) -> return -> typeName

generateFromJSONValueFunction = (Class) -> return (json) ->

  fields = if Class.fields? then Class.fields() else null

  if fields?
    # Parse all fields that are set in the given json
    for field of fields when json[field]?
      json[field] = EJSON.parse(json[field])

  return new Class(json)
