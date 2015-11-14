class @MyApp extends Space.Application
  requiredModules: ['Space.messaging']
  singletons: ['MyApi', 'MyCommandHandler']

class @MyValue extends Space.messaging.Serializable
  @type 'MyValue'
  @fields: { name: String }

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
    # Simulate some simple method validation
    'MyCommand': (_, command) ->
      @send(command) if command.value.name is 'good-value'
    # Showcase that you can also call your methods "like normal"
    'UncheckedMethod': (_, id) -> @send new AnotherCommand(targetId: id)
  ]

class @MyCommandHandler extends Space.Object
  @mixin Space.messaging.CommandHandling
  commandHandlers: -> [
    'MyCommand': ->
    'AnotherCommand': ->
  ]
