
Event = Space.messaging.Event

describe 'Space.messaging.Event', ->

  beforeEach ->
    @event = new Event

  it 'defines its EJSON type correctly', ->
    expect(@event.typeName()).to.equal 'Space.messaging.Event'