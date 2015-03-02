
Controller = Space.messaging.Controller

describe 'Space.messaging.Controller', ->

  stubControllerDependencies = (controller) ->
    controller.eventBus = subscribe: sinon.spy()
    controller.commandBus = registerHandler: sinon.spy()

  beforeEach -> class @TestController extends Controller

  it 'extends space object to be js compatible', ->
    expect(Controller).to.extend Space.Object

  it 'defines its dependencies correctly', ->
    expect(Controller).to.dependOn
      eventBus: 'Space.messaging.EventBus'
      commandBus: 'Space.messaging.CommandBus'

  it 'doesnt process messages by default', ->
    controller = new @TestController()
    expect(-> controller.onDependenciesReady()).not.to.throw Error

  describe 'handling events', ->

    class StubEvent extends Space.messaging.Event
      @type 'Space.messaging.__test__.ControllerStubEvent'

    it 'subscribes to the event bus', ->

      handler = sinon.spy()
      options = on: handler
      @TestController.handle StubEvent, options
      controller = new @TestController()
      stubControllerDependencies controller
      controller.onDependenciesReady()

      expect(controller.eventBus.subscribe).to.have.been.calledWithExactly(
        StubEvent.toString(), options, controller
      )

  describe 'handling commands', ->

    class StubCommand extends Space.messaging.Command
      @type 'Space.messaging.__test__.ControllerStubCommand'

    it 'registers handler on the command bus', ->

      handler = sinon.spy()
      options = on: handler
      @TestController.handle StubCommand, options
      controller = new @TestController()
      stubControllerDependencies controller
      controller.onDependenciesReady()

      expect(controller.commandBus.registerHandler).to.have.been.calledWithExactly(
        StubCommand.toString(), options, controller
      )
