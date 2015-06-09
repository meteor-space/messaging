Serializable = Space.messaging.Serializable

Space.messaging.defineSerializables = (Type, namespace, definitions) ->
  if (Type is not Serializable) and (Type.__super__ is not Serializable)
    throw new Error 'Type type must extend Space.messaging.Serializable'

  # Namespace is optional
  if not definitions?
    definitions = namespace
    namespace = ''

  parent = Space.resolvePath(namespace)

  for key, fields of definitions
    parent[key] = Type.extend ->
      @type namespace + '.' + key
      @fields = fields
      return this
