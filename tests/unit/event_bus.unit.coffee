
EventBus = Space.messaging.EventBus

describe 'Space.messaging.EventBus', ->

  class TestEvent extends Space.messaging.Event
    @type 'Space.messaging.__tests__.EventBusStubEvent'

  beforeEach ->
    @eventBus = new EventBus()
    @handler = sinon.spy()
    @testEvent = new TestEvent()

  it 'extends space object to be js compatible', ->
    expect(EventBus).to.extend Space.Object

  describe 'subscribing and publishing', ->

    it 'allows multiple subscribers for one event', ->
      first = sinon.spy()
      second = sinon.spy()
      @eventBus.subscribeTo TestEvent, first
      @eventBus.subscribeTo TestEvent, second
      @eventBus.publish @testEvent

      expect(first).to.have.been.calledWith @testEvent
      expect(second).to.have.been.calledWith @testEvent
