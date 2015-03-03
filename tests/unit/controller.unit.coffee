
Controller = Space.messaging.Controller

describe 'Space.messaging.Controller', ->

  stubControllerDependencies = (controller) ->
    controller.eventBus = subscribeTo: sinon.spy()
    controller.commandBus = registerHandler: sinon.spy()
    controller.meteor = bindEnvironment: (fn) -> fn
    controller.utils = bind: (fn) -> fn

  beforeEach ->
    class @TestController extends Controller
    @handler = on: sinon.spy()
    @controller = new @TestController()

  it 'extends space object to be js compatible', ->
    expect(Controller).to.extend Space.Object

  it 'defines its dependencies correctly', ->
    expect(Controller).to.dependOn
      eventBus: 'Space.messaging.EventBus'
      commandBus: 'Space.messaging.CommandBus'
      meteor: 'Meteor'
      utils: 'underscore'

  it 'doesnt process messages by default', ->
    controller = new @TestController()
    expect(-> controller.onDependenciesReady()).not.to.throw Error

  describe 'handling events', ->

    class StubEvent extends Space.messaging.Event
      @type 'Space.messaging.__test__.ControllerStubEvent'

    it 'subscribes to the event bus', ->

      @TestController.handle StubEvent, @handler
      stubControllerDependencies @controller
      @controller.onDependenciesReady()

      expect(@controller.eventBus.subscribeTo).to.have.been.calledWithExactly(
        StubEvent.toString(), @handler
      )

  describe 'handling commands', ->

    class StubCommand extends Space.messaging.Command
      @type 'Space.messaging.__test__.ControllerStubCommand'

    it 'registers handler on the command bus', ->

      @TestController.handle StubCommand, @handler
      stubControllerDependencies @controller
      @controller.onDependenciesReady()

      expect(@controller.commandBus.registerHandler).to.have.been.calledWith(
        StubCommand.toString(), @handler
      )
