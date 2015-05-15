
describe 'Space.messaging (integration)', ->

  beforeEach ->
    @testValue = new TestApp.TestValue value: 'test'
    @testEvent = new TestApp.TestEvent
      sourceId: '123'
      version: 1
      value: @testValue

    @app = new TestApp()
    @app.start()

  it 'handles events correctly', ->

    handler = sinon.spy()
    subscriber = @app.eventBus.subscribeTo TestApp.TestEvent, handler
    @app.eventBus.publish @testEvent
    expect(handler).to.have.been.calledWithExactly @testEvent

  it.server 'handles server-side commands correctly', ->

    testEvent = @testEvent
    class Controller extends Space.messaging.Controller
      @handle TestApp.TestCommand, (command) -> @eventBus.publish testEvent

    @app.injector.map('Controller').toSingleton Controller
    @app.injector.create 'Controller'

    handler = sinon.spy()
    subscriber = @app.eventBus.subscribeTo TestApp.TestEvent, handler
    @app.commandBus.send new TestApp.TestCommand version: 1, value: @testValue
    expect(handler).to.have.been.calledWithExactly @testEvent
