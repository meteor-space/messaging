class @TestApp extends Space.Application

  RequiredModules: ['Space.messaging']

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'

class TestApp.TestValue extends Space.messaging.Serializable
  @type 'Space.messaging.__tests__.IntegrationTestValue', ->
    value: String

class TestApp.TestEvent extends Space.messaging.Event
  @type 'Space.messaging.__tests__.IntegrationTestEvent', ->
    sourceId: String
    version: Match.Integer
    value: TestApp.TestValue

class TestApp.TestCommand extends Space.messaging.Command
  @type 'Space.messaging.__tests__.IntegrationTestCommand', ->
    version: Match.Integer
    value: TestApp.TestValue
