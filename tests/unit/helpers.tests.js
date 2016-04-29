describe("Space.messaging.define", function() {

  const myNamespace = Space.namespace('My.define.Namespace');

  Space.messaging.define(Space.messaging.Event, myNamespace, {
    FirstEvent: {},
    SecondEvent: {}
  });

  Space.messaging.define(Space.messaging.Event, 'My.define.Namespace', {
    ThirdEvent: {}
  });

  it("creates namespaced serializables", function() {
    expect(myNamespace.FirstEvent).to.extend(Space.messaging.Event);
    expect(myNamespace.SecondEvent).to.extend(Space.messaging.Event);
    expect(myNamespace.ThirdEvent).to.extend(Space.messaging.Event);
  });

});

describe("Space.messaging.define", function() {

  beforeEach(function() {
    this.definedSerializables = Space.messaging.define(Space.messaging.Event, {
      FirstEvent: {},
      SecondEvent: {}
    });
  });

  it("returns object with defined serializables", function() {
    expect(this.definedSerializables.FirstEvent).to.extend(Space.messaging.Event);
    expect(this.definedSerializables.SecondEvent).to.extend(Space.messaging.Event);
  });

});
