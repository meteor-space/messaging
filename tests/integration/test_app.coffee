class @MyApp extends Space.Application
  RequiredModules: ['Space.messaging']
  Singletons: ['MyApi', 'MyCommandHandler']

class @MyValue extends Space.messaging.Serializable
  @type 'MyValue'
  @fields: { value: String }

Space.messaging.define Space.messaging.Event, {
  MyEvent: { value: MyValue }
  AnotherEvent: {}
}

Space.messaging.define Space.messaging.Command, {
  MyCommand: { value: MyValue }
  AnotherCommand: {}
}

class @MyApi extends Space.messaging.Api
  methods: -> [
    'MyCommand': (_, command) -> @send command
    'UncheckedMethod': (_, id) -> @send new AnotherCommand(targetId: id)
  ]

class @MyCommandHandler extends Space.Object
  @mixin Space.messaging.CommandHandling
  commandHandlers: -> [
    'MyCommand': ->
    'AnotherCommand': ->
  ]
