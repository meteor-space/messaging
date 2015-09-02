Serializable = Space.messaging.Serializable
global = this

Space.messaging.define = (ParentType, options..., definitions) ->

  if (ParentType is not Serializable) and (ParentType.__super__ is not Serializable)
    throw new Error 'Type type must extend Space.messaging.Serializable'

  if !definitions?
    throw new Error "Space.messaging.define is missing definitions for #{Type}."

  if options.length is 0
    namespace = global
    prefix = ''
  else if options.length is 2
    namespace = options[0]
    prefix = options[1] + '.'
  else
    throw new Error "Wrong call to Space.messaging.define(Type, [namespace, prefix], definitions)."

  for className, fields of definitions
    Klass = ParentType.extend(className)
    Klass.type(prefix + className)
    Klass.fields = fields
    namespace[className] = Klass

Space.messaging.defineSerializables = Space.messaging.define
