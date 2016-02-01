
Event = Space.messaging.Event

describe 'Space.messaging.Event', ->

  beforeEach ->
    @event = new Event

  it "is Ejsonable", ->
    expect(Event.hasMixin(Space.messaging.Ejsonable)).to.be.true

  it "is Versionable", ->
    expect(Event.hasMixin(Space.messaging.Versionable)).to.be.true

  it 'defines its EJSON type correctly', ->
    expect(@event.typeName()).to.equal 'Space.messaging.Event'