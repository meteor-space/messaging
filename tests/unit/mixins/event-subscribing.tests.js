const EventSubscribing = Space.messaging.EventSubscribing;

describe("Space.messaging.EventSubscribing", function() {

  let MyClass = Space.Object.extend({ mixin: EventSubscribing });

  it("does not provide empty default", function() {
    expect(MyClass.prototype.eventSubscriptions).not.to.exist;
  });

  it("does not throw error if no handlers have been defined", function() {
    const createWithoutHandlers = function() {
      new MyClass({ underscore: _ }).onDependenciesReady();
    };
    expect(createWithoutHandlers).not.to.throw(Error);
  });

});
