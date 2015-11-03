
describe("Space.messaging.Controller - event handling", function () {

  beforeEach(function() {
    this.testEvent = new MyEvent({
      sourceId: '123',
      version: 1,
      value: new MyValue({ name: 'test' })
    });
    this.anotherEvent = new AnotherEvent({ sourceId: '123' });
  });

  describe("using event maps", function () {

    it("sets up context bound event handlers", function () {

      var eventHandlerSpy = sinon.spy();
      var anotherEventHandler = sinon.spy();

      // Define a controller that uses the `events` API to declare handlers
      MyController = Space.messaging.Controller.extend('MyController', {
        eventSubscriptions: function() {
          return [{
            'MyEvent': eventHandlerSpy,
            'AnotherEvent': anotherEventHandler
          }];
        }
      });

      // Integrate the controller in our test app
      var ControllerTestApp = Space.Application.define('ControllerTestApp', {
        afterInitialize: function() {
          this.injector.map('MyController').toSingleton(MyController);
        }
      });

      // Startup app and send event through the bus
      var app = new ControllerTestApp();
      var controller = app.injector.get('MyController');
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
