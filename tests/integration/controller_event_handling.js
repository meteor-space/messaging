
describe("Space.messaging.Controller - event handling", function () {

  beforeEach(function() {
    this.testEvent = new TestApp.TestEvent({
      sourceId: '123',
      version: 1,
      value: new TestApp.TestValue({ value: 'test' })
    });
    this.anotherEvent = new TestApp.AnotherEvent({ sourceId: '123' });
  });

  describe("using event maps", function () {

    it("sets up context bound event handlers", function () {

      var eventHandlerSpy = sinon.spy();
      var anotherEventHandler = sinon.spy();

      // Define a controller that uses the `events` API to declare handlers
      TestApp.TestController = Space.messaging.Controller.extend('TestController', {
        events: function() {
          return [{
            'TestApp.TestEvent': eventHandlerSpy,
            'TestApp.AnotherEvent': anotherEventHandler
          }];
        }
      });

      // Integrate the controller in our test app
      var ControllerTestApp = TestApp.extend('ControllerTestApp', {
        Singletons: ['TestApp.TestController']
      });

      // Startup app and send event through the bus
      var app = new ControllerTestApp();
      var controller = app.injector.get('TestApp.TestController');
      app.start();
      app.eventBus.publish(this.testEvent);
      app.eventBus.publish(this.anotherEvent);

      // Expect that the controller routed the events correctly
      expect(eventHandlerSpy).to.have.been.calledWithExactly(this.testEvent);
      expect(eventHandlerSpy).to.have.been.calledOn(controller);
      expect(anotherEventHandler).to.have.been.calledWithExactly(this.anotherEvent);
      expect(anotherEventHandler).to.have.been.calledOn(controller);

    });
  });
});
