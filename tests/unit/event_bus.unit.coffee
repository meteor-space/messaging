
EventBus = Space.messaging.EventBus

describe 'Space.messaging.EventBus', ->

  class TestEvent extends Space.messaging.Event
    @type 'Space.messaging.__tests__.EventBusStubEvent'

  beforeEach ->
    @eventBus = new EventBus()
    @handler = on: sinon.spy()
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
