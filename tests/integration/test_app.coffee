class @MyApp extends Space.Application
  RequiredModules: ['Space.messaging']
  Singletons: ['MyApi']

class @TestValue extends Space.messaging.Serializable
  @type 'ExampleValue'
  @fields: { value: String }

Space.messaging.define Space.messaging.Event, 'MyApp', {
  TestEvent: { value: TestValue }
  AnotherEvent: {}
}

Space.messaging.define Space.messaging.Command, 'MyApp', {
  TestCommand: { value: TestValue }
  AnotherCommand: {}
}

class @MyApi extends Space.messaging.Api

  sendSilently: (command) -> @commandBus.send command, null, silent: true

  methods: -> [
    'MyApp.TestCommand': (_, command) -> @sendSilently command
    'UncheckedMethod': (_, id) -> @sendSilently new MyApp.AnotherCommand(targetId: id)
  ]
