Serializable = Space.messaging.Serializable
global = this

defineTypeWithFields = (BaseType, namespace, className, fields) ->
  if namespace is '' then classPath = className else classPath = "#{namespace}.#{className}"
  SubType = BaseType.extend(classPath)
  SubType::fields = -> _.extend BaseType::fields(), fields
  Space.resolvePath(namespace)[className] = SubType

Space.messaging.define = (BaseType, options..., definitions) ->

  if !BaseType.isSerializable then throw new Error 'BaseType must extend Space.messaging.Serializable'
  if !definitions? then throw new Error "Space.messaging.define is missing definitions for #{BaseType}."
  if options.length is 1 then namespace = options[0].toString() else namespace = ''
  defineTypeWithFields(BaseType, namespace, className, fields) for className, fields of definitions

Space.messaging.defineSerializables = Space.messaging.define
