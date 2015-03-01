
Event = Space.messaging.Event

describe 'Space.messaging.Event', ->

  beforeEach ->
    @params = sourceId: 'test', version: 0
    @event = new Event @params

  it 'is serializable', ->
    expect(Event).to.extend Space.messaging.Serializable

  it 'defines its EJSON type correctly', ->
    expect(@event.typeName()).to.equal 'Space.messaging.Event'

  it 'defines its fields correctly', ->
    expect(Event.fields()).to.eql
      sourceId: String
      version: Match.Optional(Match.Integer)
