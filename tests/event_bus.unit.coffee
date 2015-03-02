
EventBus = Space.messaging.EventBus

describe 'Space.messaging.EventBus', ->

  class TestEvent extends Space.messaging.Event
    @type 'Space.messaging.__tests__.EventBusStubEvent'

  beforeEach ->
    @eventBus = new EventBus()
    @handler =
      before: sinon.stub()
      on: sinon.spy()
      after: sinon.spy()
    @testEvent = new TestEvent()

  it 'extends space object to be js compatible', ->
    expect(EventBus).to.extend Space.Object

  describe 'subscribing and publishing', ->

    it 'allows multiple subscribers for one event', ->
      first = on: sinon.spy()
      second = on: sinon.spy()
      @eventBus.subscribeTo TestEvent, first
      @eventBus.subscribeTo TestEvent, second
      @eventBus.publish @testEvent

      expect(first.on).to.have.been.calledWith @testEvent
      expect(second.on).to.have.been.calledWith @testEvent

    describe 'before hook', ->

      it 'runs the main handler when before hook passes', ->
        @handler.before.returns true
        @eventBus.subscribeTo TestEvent, @handler
        @eventBus.publish @testEvent

        expect(@handler.before).to.have.been.calledWithExactly @testEvent
        expect(@handler.on).to.have.been.calledWithExactly @testEvent
        expect(@handler.after).to.have.been.calledWithExactly @testEvent

      it 'skips the main handler and after hook when before hook fails', ->

        @handler.before.returns false
        @eventBus.subscribeTo TestEvent, @handler
        @eventBus.publish @testEvent

        expect(@handler.before).to.have.been.calledWithExactly @testEvent
        expect(@handler.on).not.to.have.been.called
        expect(@handler.after).not.to.have.been.called
