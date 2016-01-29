
describe("Space.messaging.EventSubscribing", function() {

  const EventBus = new Space.messaging.EventBus;
  const EventSubscribing = Space.messaging.EventSubscribing;

  const MyClass = Space.Object.extend({ mixin: EventSubscribing });
  const MyEvent = Space.messaging.Event.extend(
    'Space.messaging.EventSubscribing.__Test__.MyEvent',
    {}
  );

  it("does not provide empty default", function() {
    expect(MyClass.prototype.eventSubscriptions).not.to.exist;
  });

  describe("handling events", function(){

    beforeEach(function() {
      this.myClassInstance = new MyClass({
        meteor: Meteor,
        eventBus: EventBus,
        underscore: _
      });
      this.myEventInstance = new MyEvent();
    });

    it("can handle events when handler functions are subscribed for the type", function() {
      const handler = sinon.spy();
      this.myClassInstance.subscribe(MyEvent, handler);
      expect(this.myClassInstance.canHandleEvent(this.myEventInstance)).to.be.true;
    });

    it("calls the handler when passed an event it can handle", function() {
      const handler = sinon.spy();
      this.myClassInstance.subscribe(MyEvent, handler);
      this.myClassInstance.on(this.myEventInstance);
      expect(handler).to.have.been.called;
    });

    it("throws an error if the event cannot be handled", function() {
      const createWithoutHandlers = function() {
        this.myClassInstance.on(this.myEventInstance);
      };
      expect(createWithoutHandlers).to.throw.error;
    });

  });


  it("does not throw error if no handlers have been defined", function() {
    const createWithoutHandlers = function() {
      new MyClass({ underscore: _ }).onDependenciesReady();
    };
    expect(createWithoutHandlers).not.to.throw(Error);
  });

});
