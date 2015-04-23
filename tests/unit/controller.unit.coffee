
Controller = Space.messaging.Controller

describe 'Space.messaging.Controller', ->

  class StubEvent extends Space.messaging.Event
    @type 'Space.messaging.__test__.ControllerStubEvent'

  class StubCommand extends Space.messaging.Command
    @type 'Space.messaging.__test__.ControllerStubCommand'

  beforeEach ->
    class @TestController extends Controller
    @controller = new @TestController()
    @handler = sinon.spy()
    @controller.eventBus = subscribeTo: sinon.spy()
    @controller.commandBus = registerHandler: sinon.spy()
    @controller.meteor = bindEnvironment: (fn) -> fn
    @controller.underscore = bind: (fn) -> fn

  it 'extends space object to be js compatible', ->
    expect(Controller).to.extend Space.Object

  it 'defines its dependencies correctly', ->
    expect(Controller).to.dependOn
      eventBus: 'Space.messaging.EventBus'
      commandBus: 'Space.messaging.CommandBus'
      meteor: 'Meteor'
      underscore: 'underscore'

  it 'doesnt process messages by default', ->
    controller = new @TestController()
    expect(-> controller.onDependenciesReady()).not.to.throw Error

  describe 'handling events', ->

    it 'subscribes to the event bus', ->
      @TestController.on StubEvent, @handler
      @controller.onDependenciesReady()
      expect(@controller.eventBus.subscribeTo).to.have.been.calledWithExactly(
        StubEvent.toString(), @handler
      )

  describe 'handling commands', ->

    it 'registers handler on the command bus', ->
      @TestController.handle StubCommand, @handler
      @controller.onDependenciesReady()
      expect(@controller.commandBus.registerHandler).to.have.been.calledWith(
        StubCommand.toString(), @handler
      )
