
EventBus = Space.messaging.EventBus

describe 'Space.messaging.EventBus', ->

  class TestEvent extends Space.messaging.Event
    @type 'Space.messaging.__tests__.EventBusStubEvent'

  beforeEach ->
    @eventBus = new EventBus()
    @testEvent = new TestEvent()
    @handler = sinon.spy()

  it 'extends space object to be js compatible', ->
    expect(EventBus).to.extend Space.Object

  describe 'subscribing to an event', ->

    it 'allows multiple subscriptions to one event', ->
      first = sinon.spy()
      second = sinon.spy()
      @eventBus.subscribeTo TestEvent, first
      @eventBus.subscribeTo TestEvent, second
      @eventBus.publish @testEvent

      expect(first).to.have.been.calledWith @testEvent
      expect(second).to.have.been.calledWith @testEvent

    it 'can provide the types of events it can handle', ->
      subscriber = ->
      @eventBus.subscribeTo TestEvent, subscriber
      expect(@eventBus.getHandledEventTypes()).to.deep.equal(
        ['Space.messaging.__tests__.EventBusStubEvent']
      )

  describe 'publishing events', ->

    it 'calls the subscription with the event', ->
      @eventBus.subscribeTo TestEvent, @handler
      @eventBus.publish @testEvent
      expect(@handler).to.have.been.calledWithExactly @testEvent

  describe 'onPublish callbacks', ->

    it.server 'calls all callbacks when publishing an event', ->
      firstCallback = sinon.spy()
      secondCallback = sinon.spy()
      @eventBus.onPublish firstCallback
      @eventBus.onPublish secondCallback
      @eventBus.publish @testEvent
      expect(firstCallback).to.have.been.calledWithExactly @testEvent
      expect(secondCallback).to.have.been.calledWithExactly @testEvent
