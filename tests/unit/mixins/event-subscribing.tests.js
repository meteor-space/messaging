
describe("Space.messaging.EventSubscribing", function() {

  const EventSubscribing = Space.messaging.EventSubscribing;
  const EventBus = new Space.messaging.EventBus;
  const MyClass = Space.Object.extend({ mixin: EventSubscribing });
  const MyEvent = Space.messaging.Event.extend(
    'Space.messaging.EventSubscribing.__Test__.MyEvent',
    {}
  );

  it("does not provide empty default", function() {
    expect(MyClass.prototype.eventSubscriptions).not.to.exist;
  });

  it("does not throw error if no handlers have been defined", function() {
    const createWithoutHandlers = function() {
      new MyClass({ underscore: _ }).onDependenciesReady();
    };
    expect(createWithoutHandlers).not.to.throw(Error);
  });

  describe("public methods", function() {

    beforeEach(function() {
      this.myClassInstance = new MyClass({
        meteor: Meteor,
        eventBus: EventBus,
        underscore: _
      });
      this.myEventInstance = new MyEvent();
    });

    describe("canHandleEvent", function() {

      it("returns true if object has a subscribed handler function", function () {
        const handler = sinon.spy();
        this.myClassInstance.subscribe(MyEvent, handler);
        expect(this.myClassInstance.canHandleEvent(this.myEventInstance)).to.be.true;
      });

      it("returns false if object has no subscribed handler functions", function () {
        const handler = sinon.spy();
        expect(this.myClassInstance.canHandleEvent(this.myEventInstance)).to.be.false;
      });

    });

    describe("subscribe", function() {

      it("subscribes the provided function to handle the specified event sent through the event bus", function () {
        const handler = sinon.spy();
        this.myClassInstance.subscribe(MyEvent, handler);
        expect(this.myClassInstance.eventBus.hasHandlerFor(this.myEventInstance)).to.be.true;
      });

    });

    describe("on", function(){

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

  });

});
