describe 'distributed messaging via mongo collections', ->

  SharedCollection = new Mongo.Collection 'Space.messaging.Distributed'

  Space.messaging.define Space.messaging.Event, Space.messaging, 'Space.messaging',
    DistributedEvent: { value: String }

  beforeEach ->
    @clock = sinon.useFakeTimers('Date')
    @firstAppId = 'FirstApp'
    @secondAppId = 'SecondApp'
    @firstBus = new Space.messaging.EventBus()
    @secondBus = new Space.messaging.EventBus()
    @distributedEvents = [Space.messaging.DistributedEvent]
    SharedCollection.remove {}
    # Setup the distribution channels
    @firstBus.distribute @firstAppId, SharedCollection, @distributedEvents
    @secondBusReceive = @secondBus.receive @secondAppId, SharedCollection, @distributedEvents

  afterEach ->
    @clock.restore()
    # Stop observing the query after each test!
    @secondBusReceive.stop()

  describe 'distribute events', ->

    it 'saves the events into the configured collection', ->
      # Publish the event like normal
      testEvent = new Space.messaging.DistributedEvent sourceId: '123', value: 'test'
      @firstBus.publish testEvent

      # But now it should be saved into the collection
      savedEvent = SharedCollection.findOne type: 'Space.messaging.DistributedEvent'
      expect(savedEvent).toMatch {
        type: 'Space.messaging.DistributedEvent'
        payload: EJSON.stringify(testEvent)
        sentBy: @firstAppId
        receivedBy: []
      }
      parsedEvent = EJSON.parse(savedEvent.payload)
      expect(parsedEvent).to.be.instanceOf Space.messaging.DistributedEvent

  describe 'receive distributed events', ->

    it 'publishes the distributed event', (test, waitFor) ->
      # Listen for the event on the second bus
      listener = sinon.spy()
      @secondBus.subscribeTo Space.messaging.DistributedEvent, listener

      # Publish the event on the first bus
      testEvent = new Space.messaging.DistributedEvent sourceId: '123', value: 'test'
      @firstBus.publish testEvent

      Meteor.setTimeout (waitFor ->
        expect(listener).to.have.been.calledOnce
        expect(listener.args[0][0]).to.be.instanceOf Space.messaging.DistributedEvent
        expect(listener.args[0][0]).toMatch testEvent
      ), 100

    it 'can be received by multiple apps', (test, waitFor) ->
      # Setup a third bus with a different app id as the second bus
      thirdBus = new Space.messaging.EventBus()
      thirdReceiveHandle = thirdBus.receive 'ThirdApp', SharedCollection, @distributedEvents

      # Listen for the event on the second bus
      secondBusListener = sinon.spy()
      @secondBus.subscribeTo Space.messaging.DistributedEvent, secondBusListener
      # Listen for the event on the third bus
      thirdBusListener = sinon.spy()
      thirdBus.subscribeTo Space.messaging.DistributedEvent, thirdBusListener

      # Publish the event on the first bus
      testEvent = new Space.messaging.DistributedEvent sourceId: '123', value: 'test'
      @firstBus.publish testEvent

      Meteor.setTimeout (waitFor ->
        expect(secondBusListener).to.have.been.calledOnce
        expect(thirdBusListener).to.have.been.calledOnce
        thirdReceiveHandle.stop()
      ), 100

    it 'does not publish events twice per app', (test, waitFor) ->
      # Setup a third bus with the same app id as the second bus
      thirdBus = new Space.messaging.EventBus()
      thirdReceiveHandle = thirdBus.receive @secondAppId, SharedCollection, @distributedEvents

      # Listen for the event on the second bus
      secondBusListener = sinon.spy()
      @secondBus.subscribeTo Space.messaging.DistributedEvent, secondBusListener
      # Listen for the event on the third bus
      thirdBusListener = sinon.spy()
      thirdBus.subscribeTo Space.messaging.DistributedEvent, thirdBusListener

      # Publish the event on the first bus
      testEvent = new Space.messaging.DistributedEvent sourceId: '123', value: 'test'
      @firstBus.publish testEvent

      Meteor.setTimeout (waitFor ->
        expect(secondBusListener).to.have.been.calledOnce
        expect(thirdBusListener).not.to.have.been.called
        thirdReceiveHandle.stop()
      ), 100
