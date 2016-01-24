describe("Space.messaging.Versionable", function() {

  const MyVersionableClass = Space.Object.extend({
    mixin: Space.messaging.Versionable,
    schemaVersion: 3,
    transformFromVersion1(data) { data.first = 'first'; },
    transformFromVersion2(data) { data.second = 'second'; }
  });

  it('is version 1 by default', function() {
    let MyVersionable = Space.Object.extend({ mixin: Space.messaging.Versionable });
    let instance = MyVersionable.create();
    expect(instance.schemaVersion).to.equal(1);
  });

  it('can be transformed from older versions', function() {
    const originalData = { schemaVersion: 1 };
    let instance = new MyVersionableClass(originalData);
    expect(instance.first).to.equal('first');
    expect(instance.second).to.equal('second');
  });

  it('supports EJSON', function() {
    let instance = new MyVersionableClass({ schemaVersion: 1 });
    let copy = EJSON.parse(EJSON.stringify(instance));
    expect(copy.schemaVersion).to.equal(MyVersionableClass.prototype.schemaVersion);
  });
});
