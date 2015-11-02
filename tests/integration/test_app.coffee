class @MyApp extends Space.Application
  RequiredModules: ['Space.messaging']
  Singletons: ['MyApi']

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

  sendSilently: (command) -> @commandBus.send command, null, silent: true

  methods: -> [
    'MyCommand': (_, command) -> @sendSilently command
    'UncheckedMethod': (_, id) -> @sendSilently new AnotherCommand(targetId: id)
  ]
