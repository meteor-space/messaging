
Event = Space.messaging.Event

describe 'Space.messaging.Event', ->

  beforeEach ->
    @params = sourceId: 'test', version: 0
    @event = new Event @params

  it 'defines its EJSON type correctly', ->
    expect(@event.typeName()).to.equal 'Space.messaging.Event'

  describe 'default fields', ->

    it 'can be created using string source id', ->
      expect(-> new Event(sourceId: '123')).not.to.throw

    it 'can be created using Guid source id', ->
      expect(-> new Event(sourceId: new Guid())).not.to.throw

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
      originalData = { sourceId: '123', eventVersion: 1 }
      event = new TestEvent originalData
      expect(event.first).to.equal 'first'
      expect(event.second).to.equal 'second'

    it 'supports EJSON', ->
      event = new TestEvent { sourceId: '123', eventVersion: 1 }
      copy = EJSON.parse EJSON.stringify(event)
      expect(copy.eventVersion).to.equal(TestEvent::eventVersion)
