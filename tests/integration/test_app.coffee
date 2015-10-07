class @TestApp extends Space.Application

  RequiredModules: ['Space.messaging']

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'

class TestApp.TestValue extends Space.messaging.Serializable
  @type 'TestApp.TestValue'
  @fields: { value: String }

class TestApp.TestEvent extends Space.messaging.Event
  @type 'TestApp.TestEvent'
  @fields: {
    sourceId: String
    version: Match.Integer
    value: TestApp.TestValue
  }

class TestApp.AnotherEvent extends Space.messaging.Event
  @type 'TestApp.AnotherEvent'
  @fields: { sourceId: String }

class TestApp.TestCommand extends Space.messaging.Command
  @type 'TestApp.TestCommand'
  @fields: {
    targetId: String
    value: TestApp.TestValue
  }

class TestApp.AnotherCommand extends Space.messaging.Command
  @type 'TestApp.AnotherCommand'
  @fields: { targetId: String }
