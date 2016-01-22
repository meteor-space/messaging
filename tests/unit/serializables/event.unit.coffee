
Event = Space.messaging.Event

describe 'Space.messaging.Event', ->

  beforeEach ->
    @event = new Event

  it 'defines its EJSON type correctly', ->
    expect(@event.typeName()).to.equal 'Space.messaging.Event'

  describe 'versioning', ->

    class TestEvent extends Event
      @type 'Space.messaging.TestEvent'
      @fields: { first: String, second: String }
      eventVersion: 3
      migrateFromVersion1: (data) -> data.first = 'first'
      migrateFromVersion2: (data) -> data.second = 'second'

    it 'is version 1 when constructed', ->
      event = new Event()
      expect(event.eventVersion).to.equal(1)

    it 'can be migrated from older versions', ->
      originalData = { eventVersion: 1 }
      event = new TestEvent originalData
      expect(event.first).to.equal 'first'
      expect(event.second).to.equal 'second'

    it 'supports EJSON', ->
      event = new TestEvent { eventVersion: 1 }
      copy = EJSON.parse EJSON.stringify(event)
      expect(copy.eventVersion).to.equal(TestEvent::eventVersion)