Serializable = Space.messaging.Serializable

Space.messaging.defineMessages = (Type, namespace, definitions) ->
  if (Type is not Serializable) and (Type.__super__ is not Serializable)
    throw new Error 'Message type must extend Space.messaging.Serializable'

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
