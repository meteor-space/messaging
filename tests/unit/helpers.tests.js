describe("Space.messaging.define", () => {

  describe("batch defining serializable objects", () => {

    it("returns object with defined serializables", () => {
      const definedSerializables = Space.messaging.define(Space.messaging.Event, {
        FirstEvent: {},
        SecondEvent: {}
      });
      expect(definedSerializables.FirstEvent).to.extend(Space.messaging.Event);
      expect(definedSerializables.SecondEvent).to.extend(Space.messaging.Event);
    });

  });

  describe("use with a Space.namespace", () => {

    beforeEach(() => {
      this.myNamespace = Space.namespace('My.define.Namespace');
    });

    it("creates namespaced serializables when passing a Space.namespace object as the second argument", () => {
      Space.messaging.define(Space.messaging.Event, this.myNamespace, {
        FirstEvent: {},
        SecondEvent: {}
      });
      expect(this.myNamespace.FirstEvent).to.extend(Space.messaging.Event);
      expect(this.myNamespace.SecondEvent).to.extend(Space.messaging.Event);
    });

    it("creates namespaced serializables when passing the string reference of a Space.namespace as the second argument", () => {
      Space.messaging.define(Space.messaging.Event, 'My.define.Namespace', {
        ThirdEvent: {}
      });
      expect(this.myNamespace.ThirdEvent).to.extend(Space.messaging.Event);
    });
  })

});


